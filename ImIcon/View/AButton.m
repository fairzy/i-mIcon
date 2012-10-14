//
//  AButton.m
//  ImIcon
//
//  Created by fairzy fan on 12-6-15.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "AButton.h"

@implementation AButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView * btnImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"heart-btn.png"]];
        [btnImage setFrame:CGRectMake(0, 0, 50, 40)];
        [self addSubview:btnImage];
        [btnImage release];
        
        UILabel * btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 50, 20)];
        btnLabel.text = @"测试";
        [self addSubview:btnLabel];
        [btnLabel release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
