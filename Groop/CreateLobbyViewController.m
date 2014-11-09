//
//  CreateLobbyViewController.m
//  Groop
//
//  Created by Mayank Jain on 11/6/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "CreateLobbyViewController.h"
#import "InviteFriendsTableViewController.h"

@interface CreateLobbyViewController ()

@end

@implementation CreateLobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.name){
        self.nameTextField.text = self.name;
    }
    if(self.startdate){
        [self.startDatePicker setDate:self.startdate animated:YES];
    }
    if(self.enddate){
        [self.endDatePicker setDate:self.enddate animated:YES];
    }
    
    [self.startDatePicker addTarget:self action:@selector(dateChanged:)
     forControlEvents:UIControlEventValueChanged];
    [self.endDatePicker addTarget:self action:@selector(dateChanged:)
     forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dateChanged:(id)sender{
    [self.nameTextField resignFirstResponder];
}

#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL isVerified = self.nameTextField.text.length > 0;
    
    if (!isVerified)
    {
        NSLog(@"Please fill in name");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Please fill in a name"
                              delegate:self
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    return isVerified;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"createToFriends"]){
        InviteFriendsTableViewController *vc = [segue destinationViewController];
        
        self.lobby = [PFObject objectWithClassName:@"lobby"];
        self.lobby[@"name"] = self.nameTextField.text;
        self.lobby[@"startTime"] = [self.startDatePicker date];
        self.lobby[@"endTime"] = [self.endDatePicker date];
        self.lobby[@"creator"] = [PFUser currentUser];
        PFRelation *users = [self.lobby relationForKey:@"users"];
        [users addObject:[PFUser currentUser]];
        
    
        vc.lobby = self.lobby;
        
        [FBRequestConnection startWithGraphPath:@"me/friends?fields=installed,id,name,picture"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Sucess! Include your code to handle the results here
                                      NSLog(@"user events: %@", result);
                                      for (NSDictionary * obj in result[@"data"]){
                                          if([obj[@"installed"] isEqualToString:@"true"]){
                                              [vc.array addObject:obj];
                                          }
                                      }
                                  } else {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                  }
                              }];
    }
}

@end
