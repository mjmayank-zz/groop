//
//  LobbyCell.h
//  Groop
//
//  Created by Mayank Jain on 11/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LobbyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *lobbyName;
@property (strong, nonatomic) IBOutlet UILabel *lobbyTime;

@end
