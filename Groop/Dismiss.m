//
//  Dismiss.m
//  Groop
//
//  Created by Mayank Jain on 12/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "Dismiss.h"

@implementation Dismiss

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
