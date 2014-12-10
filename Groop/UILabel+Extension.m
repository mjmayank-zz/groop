//
//  UILabel+Extension.m
//  Groop
//
//  Created by Mayank Jain on 12/9/14.
//  Copyright (c) 2014 Mayank Jain. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation LabelExtension

- (void)setText:(NSString *)text {
    text = [text uppercaseString];
    [super setText:text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
