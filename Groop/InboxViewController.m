//
//  InboxViewController.m
//  Groop
//
//  Created by Derek Quach on 1/19/15.
//  Copyright (c) 2015 Mayank Jain. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"You have opened the inbox");
    
    PFQuery *query = [PFQuery queryWithClassName:@"lobby"];
    [query whereKey:@"invited" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"These should be lobbies you are invited to");
            for (PFObject *object in objects) {
                NSLog(object[@"name"]);
                PFRelation *invitedRelation = [object relationForKey:@"invited"];
                PFRelation *userRelation = [object relationForKey:@"users"];
                [invitedRelation removeObject:[PFUser currentUser]];
                [userRelation addObject:[PFUser currentUser]];
                [object saveInBackground];
            }
        }
    }];
    
}


@end