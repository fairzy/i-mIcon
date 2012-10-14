//
//  CateBtn.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-30.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CateBtn.h"

@implementation CateBtn

@synthesize selected;

- (id)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if ( self ) {
        // 背景
        [self setBackgroundImage:[UIImage imageNamed:@"cate_btn_bg.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"cate_btn_sel.png"] forState:UIControlStateHighlighted];
        // 字体
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearSelect) name:ClearSelectNotification object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)sel{
    if ( sel ) {
        [self setBackgroundImage:[UIImage imageNamed:@"cate_btn_sel.png"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [self setBackgroundImage:[UIImage imageNamed:@"cate_btn_bg.png"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
}

- (void)clearSelect{
    self.selected = NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ClearSelectNotification object:nil];
    
    [super dealloc];
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
