//
//  PageViewController.m
//  Groop
//
//  Created by Mayank Jain on 12/9/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "PageViewController.h"
#import "CameraViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    // Do any additional setup after loading the view.
    
    CameraViewController * cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraIdentifier"];
    
    self.vcs = @[[self.storyboard instantiateViewControllerWithIdentifier:@"ActiveIdentifier"],
                 cameraVC,
                 [self.storyboard instantiateViewControllerWithIdentifier:@"MainIdentifier"]];
    cameraVC.pageController = self;
    
    [self setViewControllers:@[self.vcs[1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.vcs count] == 0) || (index >= [self.vcs count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    return self.vcs[index];
}

+(void)viewControllerAfter:(UIViewController *)vc{
    
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.vcs indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.vcs indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.vcs count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
