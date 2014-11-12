//
//  CameraRollWorker.m
//  Groop
//
//  Created by Mayank Jain on 11/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "CameraRollWorker.h"
#import <Photos/Photos.h>

@implementation CameraRollWorker

- (id)init
{
    self = [super init];
    if (self)
    {
        NSDate * startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-1000];
        NSDate * endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:1000];
        [self getImagesBetweenDatesStartDate:startDate endDate:endDate];
    }
    return self;
}

- (void) getImagesBetweenDatesStartDate:(NSDate*)startDate endDate:(NSDate *)endDate{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHAssetCollection *assetCollection = (PHAssetCollection *)smartAlbums[0];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for(PHAsset * asset in assetsFetchResult){
        if([asset.creationDate compare:startDate] == NSOrderedDescending && [asset.creationDate compare:endDate] == NSOrderedAscending){
            [results addObject:asset];
        }
    }
}

-(void)saveAssets:(NSArray *)array ToLobby:(PFObject *)lobby{
    
    PHImageManager * manager = [[PHImageManager alloc] init];
    
    for(PHAsset * asset in array){
        [manager requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            PFFile *imageFile = [PFFile fileWithData:imageData];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    PFObject * photo = [PFObject objectWithClassName:@"picture"];
                    [photo setObject:imageFile forKey:@"file"];
                    [photo setObject:[PFUser currentUser] forKey:@"photographer"];
                    
                    
                    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(!error){
                            PFRelation * relation = [lobby relationForKey:@"pictures"];
                            [relation addObject:photo];
                            [lobby saveInBackground];
                        }
                        else{
                            NSLog(@"%@", error);
                        }
                    }];
                    
                }
            }];
        }];
    }
}

@end
