//
//  ActiveLobbiesTableViewController.h
//  Groop
//
//  Created by Mayank Jain on 12/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveLobbiesTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray * pastLobbies;
@property (strong, nonatomic) NSMutableArray * activeLobbies;
@property (strong, nonatomic) NSMutableArray * futureLobbies;

@end
