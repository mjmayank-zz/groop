//
//  TableViewController.m
//  Groop
//
//  Created by Mayank Jain on 10/15/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "LobbiesTableViewController.h"
#import "LobbyAlbumViewController.h"
#import "LobbyManager.h"

@interface LobbiesTableViewController ()

@end

@implementation LobbiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"allLobbiesUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"activeLobbiesUpdated" object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.pastLobbies = [LobbyManager sharedLobbyManager].pastLobbies;
    self.activeLobbies = [LobbyManager sharedLobbyManager].activeLobbies;
    self.futureLobbies = [LobbyManager sharedLobbyManager].futureLobbies;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"allLobbiesUpdated"
                                                    object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"activeLobbiesUpdated"
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData:(NSNotification *)notification{
    self.pastLobbies = notification.userInfo[@"pastLobbies"];
    self.activeLobbies = notification.userInfo[@"activeLobbies"];
    self.futureLobbies = notification.userInfo[@"futureLobbies"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSMutableArray *) arrayForSection:(NSInteger)section{
    if(section == 0){
        return self.activeLobbies;
    }
    else if(section == 1){
        return self.pastLobbies;
    }
    else{
        return self.futureLobbies;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        if([[self arrayForSection:section] count] == 0){
            return 1;
        }
        return [[self arrayForSection:section] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return @"Active Lobbies";
    }
    else if(section == 1){
        return @"Past Lobbies";
    }
    else{
        return @"Future Lobbies";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
        [cell.textLabel setText:self.searchResults[indexPath.row]];
    else{
        NSMutableArray * array = [self arrayForSection:indexPath.section];
        if([array count] == 0){
            [cell.textLabel setText:@"No Lobbies"];
        }
        else{
            [cell.textLabel setText:array[indexPath.row][@"name"]];
        }
    }
    return cell;
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
- (IBAction)refreshButtonPressed:(id)sender {
    LobbyManager * lobbyM = [LobbyManager sharedLobbyManager];
    [lobbyM calculateActiveLobbies:[lobbyM getAllLobbies]];
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"lobbyToAlbum"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        if([[self arrayForSection:path.section] count] == 0){
            return NO;
        }
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"lobbyToAlbum"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        LobbyAlbumViewController *vc = segue.destinationViewController;
        vc.lobby = [[self arrayForSection:path.section ] objectAtIndex:path.row];
    }

}


#pragma mark - SearchDelegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.name contains[c] %@", searchText];
//    self.searchResults = [self.array filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



@end
