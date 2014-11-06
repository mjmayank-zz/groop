//
//  FBEventsTableViewController.h
//  Groop
//
//  Created by Mayank Jain on 11/6/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBEventsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * array;

@end
