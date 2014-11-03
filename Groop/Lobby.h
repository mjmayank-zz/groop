//
//  Lobby.h
//  Groop
//
//  Created by Mayank Jain on 11/2/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lobby : NSObject

@property (strong, nonatomic) NSDate * startTime;
@property (strong, nonatomic) NSDate * endTime;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray * photos;

@end
