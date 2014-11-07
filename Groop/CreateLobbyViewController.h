//
//  CreateLobbyViewController.h
//  Groop
//
//  Created by Mayank Jain on 11/6/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateLobbyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSDate * startdate;
@property (strong, nonatomic) NSDate * enddate;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) PFObject * lobby;

@end
