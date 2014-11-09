//
//  Lobby.h
//  Groop
//
//  Created by Mayank Jain on 11/2/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DateCompare) {
    kPastLobby,
    kActiveLobby,
    kFutureLobby
};

@interface LobbyManager : NSObject

@property (strong, nonatomic) NSMutableArray * activeLobbies;
@property (strong, nonatomic) NSMutableArray * pastLobbies;
@property (strong, nonatomic) NSMutableArray * futureLobbies;

+ (LobbyManager *)sharedLobbyManager;
- (NSArray *)getAllLobbies;
- (void)calculateActiveLobbies:(NSArray *)allLobbies;
- (void)queryLobbies;

@end
