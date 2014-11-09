//
//  InviteFriendsTableViewController.h
//  Groop
//
//  Created by Mayank Jain on 11/6/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InviteFriendsTableViewController : UITableViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * array;
@property (strong, nonatomic) NSMutableArray * friendsAttendingArray;
@property (strong, nonatomic) PFObject * lobby;
@property (strong, nonatomic) NSString * eventId;
@end
