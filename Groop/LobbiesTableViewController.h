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

@interface LobbiesTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, MWPhotoBrowserDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * pastLobbies;
@property (strong, nonatomic) NSMutableArray * activeLobbies;
@property (strong, nonatomic) NSMutableArray * futureLobbies;
@property (strong, nonatomic) NSArray * searchResults;
@property (strong, nonatomic) NSMutableArray * photos;

@end
