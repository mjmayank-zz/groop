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

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Test");
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
    self.array = [LobbyManager sharedLobbyManager].allLobbies;
//    PFQuery *query = [PFQuery queryWithClassName:@"lobby"];
//    [query whereKey:@"users" equalTo:[PFUser currentUser]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu lobbies.", (unsigned long)[objects count]);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                [self.array addObject:object];
//                NSLog(@"%@", object);
//            }
//            [self.tableView reloadData];
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"eventsUpdated"
                                                    object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self promptLogin];
    
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.center = self.view.center;
//    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData:(NSNotification *)notification{
    self.array = notification.userInfo[@"allLobbies"];
    self.activeLobbies = notification.userInfo[@"activeLobbies"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([self.activeLobbies count] == 0){
        return 1;
    }
    else return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        if(section == 0){
            return [self.array count];
        }
        else{
            return [self.activeLobbies count];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Past Lobbies";
    else{
        return @"Active Lobbies";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
        [cell.textLabel setText:self.searchResults[indexPath.row]];
    else
        if(indexPath.section == 0){
            [cell.textLabel setText:self.array[indexPath.row][@"name"]];
        }
        else{
            [cell.textLabel setText:self.activeLobbies[indexPath.row][@"name"]];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"lobbyToAlbum"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        LobbyAlbumViewController *vc = segue.destinationViewController;
        if(path.section == 0){
            vc.lobby = [self.array objectAtIndex:path.row];
        }
        else{
            vc.lobby = [self.activeLobbies objectAtIndex:path.row];
        }
    }

}


#pragma mark - SearchDelegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.name contains[c] %@", searchText];
    self.searchResults = [self.array filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(void)promptLogin{
//    if (![PFUser currentUser]) { // No user logged in
//        // Create the log in view controller
//        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
//        [logInViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Create the sign up view controller
//        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
//        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Assign our sign up controller to be displayed from the login controller
//        [logInViewController setSignUpController:signUpViewController];
//        
//        // Present the log in view controller
//        [self presentViewController:logInViewController animated:YES completion:NULL];
//    }
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        // If not logged in, we will show a PFLogInViewController
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        // Customize the Log In View Controller
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsTwitter | PFLogInFieldsFacebook; // Show Twitter login, Facebook login, and a Dismiss button.
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}



@end
