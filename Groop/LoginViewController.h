//
//  LoginViewController.h
//  Groop
//
//  Created by Mayank Jain on 11/5/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController<PFLogInViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *cameraPermissionButton;

@end
