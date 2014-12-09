//
//  PhotoBrowserViewController.h
//  Groop
//
//  Created by Mayank Jain on 11/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface PhotoBrowserViewController : MWPhotoBrowser<MWPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableArray * photos;
@property (strong, nonatomic) PFObject * lobby;

@end
