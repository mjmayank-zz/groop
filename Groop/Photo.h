//
//  Photo.h
//  Groop
//
//  Created by Mayank Jain on 11/2/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Photo : NSObject

@property (strong, nonatomic) NSString * caption;
@property (strong, nonatomic) User * photographer;
@property (strong, nonatomic) NSArray * lobbies;

@end
