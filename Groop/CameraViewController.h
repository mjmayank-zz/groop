//
//  CameraViewController.h
//  Groop
//
//  Created by Mayank Jain on 11/7/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface CameraViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *lobbiesButton;
@property (strong, nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) PageViewController *pageController;
@end
