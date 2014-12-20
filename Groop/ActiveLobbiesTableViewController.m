//
//  ActiveLobbiesTableViewController.m
//  Groop
//
//  Created by Mayank Jain on 12/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "ActiveLobbiesTableViewController.h"
#import "LobbyManager.h"
#import "ActiveLobbiesTableViewCell.h"

@interface ActiveLobbiesTableViewController ()

@end

@implementation ActiveLobbiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [[LobbyManager sharedLobbyManager].activeLobbies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveLobbiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activeLobbyCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ActiveLobbiesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activeLobbyCell"];
    }
    PFObject * lobby = [LobbyManager sharedLobbyManager].activeLobbies[indexPath.row];
    // Configure the cell...
    cell.titleLabel.text = lobby[@"name"];
    
    if([[LobbyManager sharedLobbyManager] isPaused:lobby]){
        cell.activeIndicator.hidden = YES;
    }
    else{
        cell.activeIndicator.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * lobby = [LobbyManager sharedLobbyManager].activeLobbies[indexPath.row];
    [[LobbyManager sharedLobbyManager] toggleLobby:lobby];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActiveLobbiesTableViewCell * cell = (ActiveLobbiesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([[LobbyManager sharedLobbyManager] isPaused:lobby]){
        cell.activeIndicator.hidden = YES;
    }
    else{
        cell.activeIndicator.hidden = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60.0)];
    [view setBackgroundColor:[UIColor colorWithRed:62.0/255 green:162.0/255 blue:183.0/255 alpha:1]];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, tableView.frame.size.width, 40)];
    [label setFont:[UIFont fontWithName:@"GillSansSTD-Bold" size:20]];
    [label setTextColor:[UIColor whiteColor]];
    /* Section header is in 0th index... */
    [label setText:[@"Active Groops" uppercaseString]];
    [view addSubview:label];
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [@"Active Lobbies" uppercaseString];
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
