//
//  Lobby.h
//  Groop
//
//  Created by Mayank Jain on 11/2/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LobbyManager : NSObject

@property (strong, nonatomic) NSMutableArray * activeLobbies;
@property (strong, nonatomic) NSMutableArray * allLobbies;

+ (LobbyManager *)sharedLobbyManager;

@end
