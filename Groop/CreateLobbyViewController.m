//
//  CreateLobbyViewController.m
//  Groop
//
//  Created by Mayank Jain on 11/6/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "CreateLobbyViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)saveButtonPressed:(id)sender {
    PFObject *lobby = [PFObject objectWithClassName:@"lobby"];
    lobby[@"name"] = self.nameTextField.text;
    lobby[@"startTime"] = [self.startDatePicker date];
    lobby[@"endTime"] = [self.endDatePicker date];
    PFRelation *users = [lobby relationForKey:@"users"];
    [users addObject:[PFUser currentUser]];
    
    [lobby saveInBackground];
    
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainIdentifier"] animated:YES completion:nil];
}

- (void) dateChanged:(id)sender{
    [self.nameTextField resignFirstResponder];
}



@end