//
//  AboutView.m
//  ImIcon
//
//  Created by mac  on 12-8-28.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor]; 
        UIImageView * iconimg = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, 10, 160, 160)];
        [iconimg setImage: [UIImage imageNamed:@"icon-160.png"]];
        [self addSubview:iconimg];
        [iconimg release];
        
        UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-250)/2, 180, 250, 150)];
        text.numberOfLines = 0;
        text.textAlignment = UITextAlignmentCenter;
        text.font = [UIFont fontWithName:@"zapfino" size:10.0f ];
        [text setText:@"\nDesign: springzhou@163.com\nDev: fairzy@gmail.com"];
        [self addSubview:text];
        [text release];
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
