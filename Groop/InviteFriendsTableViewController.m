//
//  InviteFriendsTableViewController.m
//  Groop
//
//  Created by Mayank Jain on 11/6/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "InviteFriendsTableViewController.h"

@interface InviteFriendsTableViewController ()

@end

@implementation InviteFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.array = [[NSMutableArray alloc] init];
    
    [FBRequestConnection startWithGraphPath:@"me/friends"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                                  for (NSDictionary * obj in result[@"data"]){
                                      [self.array addObject:obj];
                                  }
                                  [self.tableView reloadData];
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteFriendCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row][@"name"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath: indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

- (IBAction)submitButton:(id)sender {
    NSLog(@"Button Pressed");
    
    int numEntries = 0;
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells)
    {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            PFRelation * relation = [self.lobby relationForKey:@"users"];
            
            PFQuery *query = [PFUser query];
            [query whereKey:@"fbID" equalTo:[self.array objectAtIndex:indexPath.row][@"id"]];
            
            __block PFUser *friend;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %lu lobbies.", (unsigned long)[objects count]);
                    // Do something with the found objects
                    friend = [objects objectAtIndex:0];
                    [relation addObject:friend];
                    [self.lobby saveInBackground];
                    NSLog(@"Invited %@", cell.textLabel.text);
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
    NSLog(@"%d entries selected", numEntries);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
