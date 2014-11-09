//
//  Lobby.m
//  Groop
//
//  Created by Mayank Jain on 11/2/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "LobbyManager.h"

@implementation LobbyManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.pastLobbies = [[NSMutableArray alloc] init];
        self.activeLobbies = [[NSMutableArray alloc] init];
        self.futureLobbies = [[NSMutableArray alloc] init];
        
        [self queryLobbies];
    }
    return self;
}

- (DateCompare)sortLobby:(PFObject *)lobby{
    NSDate * startTime = lobby[@"startTime"];
    NSDate * endTime = lobby[@"endTime"];
    if ([endTime compare:[NSDate date]] == NSOrderedAscending){
        return kPastLobby;
    }
    else if( [startTime compare:[NSDate date]] == NSOrderedAscending && [endTime compare:[NSDate date]] == NSOrderedDescending){
        return kActiveLobby;
    }
    else{
        return kFutureLobby;
    }
}

- (void)calculateActiveLobbies:(NSArray *) allLobbies{
    NSMutableArray * pastLobbies = [[NSMutableArray alloc] init];
    NSMutableArray * activeLobbies = [[NSMutableArray alloc] init];
    NSMutableArray * futureLobbies = [[NSMutableArray alloc] init];
    for (PFObject *object in allLobbies){
        DateCompare date = [self sortLobby:object];
        if(date == kPastLobby){
            [pastLobbies addObject:object];
        }
        else if(date == kActiveLobby){
            [activeLobbies addObject:object];
        }
        else{
            [futureLobbies addObject:object];
        }
    }
    
    self.pastLobbies = pastLobbies;
    self.activeLobbies = activeLobbies;
    self.futureLobbies = futureLobbies;
    
    NSDictionary *userInfo = @{@"activeLobbies": self.activeLobbies,
                               @"pastLobbies": self.pastLobbies,
                               @"futureLobbies": self.futureLobbies};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allLobbiesUpdated" object:self userInfo:userInfo];
}

- (NSMutableArray *)getAllLobbies{
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    [temp addObjectsFromArray:self.pastLobbies];
    [temp addObjectsFromArray:self.activeLobbies];
    [temp addObjectsFromArray:self.futureLobbies];
    return temp;
}

- (void) queryLobbies{
    PFQuery *query = [PFQuery queryWithClassName:@"lobby"];
    [query whereKey:@"users" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu lobbies.", (unsigned long)[objects count]);
            [self calculateActiveLobbies:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Singleton implementation in ARC
+ (LobbyManager *)sharedLobbyManager
{
    static LobbyManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
