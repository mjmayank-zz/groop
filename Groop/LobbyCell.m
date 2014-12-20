//
//  LobbyCell.m
//  Groop
//
//  Created by Mayank Jain on 11/11/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "LobbyCell.h"

@implementation LobbyCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundImageView.layer.cornerRadius = 44.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.backgroundImageView.image = nil;
}

@end
