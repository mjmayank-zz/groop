//
//  EventCollectionViewController.h
//  Groop
//
//  Created by Mayank Jain on 10/15/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LobbyAlbumViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray * array;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) PFObject *lobby;

@end
