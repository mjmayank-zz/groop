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
#import "MWPhotoBrowser.h"
#import "LobbyCell.h"
#import "PhotoBrowserViewController.h"

@interface LobbiesTableViewController ()
@property(nonatomic, strong) NSCache *cache;
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.pastLobbies = [LobbyManager sharedLobbyManager].pastLobbies;
    self.activeLobbies = [LobbyManager sharedLobbyManager].activeLobbies;
    self.futureLobbies = [LobbyManager sharedLobbyManager].futureLobbies;
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"] == NULL) {
        UIAlertView *createLobbiesAlert = [[UIAlertView alloc]
                                           
                                           initWithTitle:@"Welcome to Groop!"
                                           message:@"Create lobbies by hitting the plus sign."
                                           delegate:self
                                           cancelButtonTitle:@"Dismiss"
                                           otherButtonTitles:@"Ok", nil];
        
        
        
        UIAlertView *viewPicturesAlert = [[UIAlertView alloc]
                                          
                                          initWithTitle:@"Welcome to Groop!"
                                          message:@"Tap on lobbies to view the pictures that have been uploaded."
                                          delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:@"Ok", nil];
        
        
        [viewPicturesAlert show];
        [createLobbiesAlert show];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"Not" forKey:@"firstTime"];
        
        
        
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"GillSansStd-BOLD" size:18],
      NSFontAttributeName, nil]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:62.0/255 green:162.0/255 blue:183.0/255 alpha:1];
    
    self.cache = [[NSCache alloc] init];
    self.cache.countLimit = 50;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"allLobbiesUpdated"
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshLobbies];
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
        return [@"Active Lobbies" uppercaseString];
    }
    else if(section == 1){
        return [@"Past Lobbies" uppercaseString];
    }
    else{
        return [@"Future Lobbies" uppercaseString];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LobbyCell *cell = (LobbyCell *)[tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[LobbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        [cell.textLabel setText:self.searchResults[indexPath.row]];
    else {
        NSMutableArray * array = [self arrayForSection:indexPath.section];
        
        if([array count] == 0){
            [cell.lobbyName setText:@"No Lobbies"];
        }
        else {
            PFObject * lobby = array[indexPath.row];
            NSString * cell_key = lobby.objectId;
            
            if ([self.cache objectForKey:cell_key] != nil)
            {
                NSLog(@"asda");
                UIImage *image = [self.cache objectForKey:cell_key];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.backgroundImageView setImage:image];
                });
            }
            else{
                PFRelation *relation = [lobby relationForKey:@"pictures"];
                PFQuery *query = [relation query];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved %lu pictures.", (unsigned long)[objects count]);
                        // Do something with the found objects
                        
                        if([objects count] > 0){
                            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_async(queue, ^{
                                NSUInteger randomIndex = arc4random() % [objects count];
                                PFFile * file = objects[randomIndex][@"file"];
                                NSData * data = [file getData];
                                UIImage * image = [UIImage imageWithData:data];
                                
                                [self.cache setObject:image forKey:cell_key];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [cell.backgroundImageView setImage:image];
                                });
                            });
                        }
                        else{
                            [cell.backgroundImageView setImage:[UIImage imageNamed:@"humin.jpg"]];
                        }
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                    
                    [cell.numPhotos setText:[NSString stringWithFormat:@"%d", (int)[objects count]]];
                }];
            }
            
            [cell.lobbyName setText:lobby[@"name"]];
            
            PFRelation *people_relation = [lobby relationForKey:@"users"];
            PFQuery *people_query = [people_relation query];
            [people_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [cell.numPeople setText:[NSString stringWithFormat:@"%d", (int) [objects count]]];
            }];
            
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[self arrayForSection:indexPath.section ] count] == 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    
    PFObject * lobby = [[self arrayForSection:indexPath.section ] objectAtIndex:indexPath.row];
    
    PhotoBrowserViewController * vc = [[PhotoBrowserViewController alloc] init];
    vc.delegate = vc;
    vc.lobby = lobby;
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PFRelation *relation = [lobby relationForKey:@"pictures"];
        PFQuery *query = [relation query];
    
        self.photos = [NSMutableArray new];
    
    
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu pictures.", (unsigned long)[objects count]);
                // Do something with the found objects
    
                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
                for (PFObject *object in objects) {
                    PFFile * file = object[@"file"];
    
                    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:file.url]]];
                }
    
                // Create browser (must be done each time photo browser is
                // displayed. Photo browser objects cannot be re-used)
    
                // Set options
                browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
                browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
                browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
                browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
                browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
                browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
                browser.startOnGrid = YES; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
                // Present
                [self.navigationController pushViewController:browser animated:YES];
    
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
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
    [self refreshLobbies];
}

- (void)refreshLobbies{
    [[LobbyManager sharedLobbyManager] queryLobbies];
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
