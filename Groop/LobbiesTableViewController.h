//
//  TableViewController.h
//  Groop
//
//  Created by Mayank Jain on 10/15/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MWPhotoBrowser.h"
#import "PageViewController.h"

@interface LobbiesTableViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, MWPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,retain) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray * pastLobbies;
@property (strong, nonatomic) NSMutableArray * activeLobbies;
@property (strong, nonatomic) NSMutableArray * futureLobbies;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) NSMutableArray * photos;
@property (strong, nonatomic) PageViewController * pageController;
@property (strong, nonatomic) IBOutlet UIButton *inboxButton;
@property (strong, nonatomic) IBOutlet UILabel *inboxNotificationLabel;

@end
