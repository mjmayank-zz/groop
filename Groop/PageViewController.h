//
//  PageViewController.h
//  Groop
//
//  Created by Mayank Jain on 12/9/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIPageViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *vcs;
@property (assign, nonatomic) NSUInteger index;

+(void)viewControllerAfter:(UIViewController *)vc;
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

@end
