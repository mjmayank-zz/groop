//
//  LoginViewController.m
//  Groop
//
//  Created by Mayank Jain on 11/5/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "LoginViewController.h"
#import <Photos/Photos.h>
#import "LobbiesTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        // If not logged in, we will show a PFLogInViewController
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        // Customize the Log In View Controller
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"user_about_me", @"user_events", @"user_friends"];
        logInViewController.fields = PFLogInFieldsFacebook; // Show Twitter login, Facebook login, and a Dismiss button.
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

}

- (IBAction)cameraPermissionsButtonPressed:(id)sender {
    
    [self.cameraPermissionButton setEnabled:false];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainIdentifier"] animated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"hasPermissions"];
                break;
            case PHAuthorizationStatusRestricted:
                
                break;
            case PHAuthorizationStatusDenied:
                
                break;
            default:
                break;
        }
    }];

}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [FBRequestConnection startWithGraphPath:@"me"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                                  PFUser *currentUser = [PFUser currentUser];
                                  
                                  NSString * fbID = result[@"id"];
                                  NSString * firstName = result[@"first_name"];
                                  NSString * lastName = result[@"last_name"];
                                  
                                  [currentUser setObject:fbID forKey:@"fbID"];
                                  [currentUser setObject:firstName forKey:@"first_name"];
                                  [currentUser setObject:lastName forKey:@"last_name"];
                                  
                                  [currentUser saveInBackground];
                                
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
    
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


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
