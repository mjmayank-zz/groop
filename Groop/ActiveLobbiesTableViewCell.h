//
//  ActiveLobbiesTableViewCell.h
//  Groop
//
//  Created by Mayank Jain on 12/10/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveLobbiesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activeIndicator;

@end
