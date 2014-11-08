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
        self.allLobbies = [[NSMutableArray alloc] init];
        self.activeLobbies = [[NSMutableArray alloc] init];
        PFQuery *query = [PFQuery queryWithClassName:@"lobby"];
        [query whereKey:@"users" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu lobbies.", (unsigned long)[objects count]);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    [self.allLobbies addObject:object];
//                    NSLog(@"%@", object);
                }
                NSDictionary *userInfo = @{@"allLobbies": self.allLobbies,
                                           @"activeLobbies":self.activeLobbies};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"allLobbiesUpdated" object:self userInfo:userInfo];
                [self calculateActiveLobbies];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    return self;
}

- (void)calculateActiveLobbies{
    for (PFObject *object in self.allLobbies){
        NSDate * startTime = object[@"startTime"];
        NSDate * endTime = object[@"endTime"];
        if( [startTime compare:[NSDate date]] == NSOrderedAscending && [endTime compare:[NSDate date]] == NSOrderedDescending){
            [self.activeLobbies addObject:object];
        }
    }
    NSDictionary *userInfo = @{@"activeLobbies": self.activeLobbies,
                               @"allLobbies": self.allLobbies};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activeLobbiesUpdated" object:self userInfo:userInfo];
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
