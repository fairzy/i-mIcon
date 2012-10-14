//
//  BannerView.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
// 

#import "BannerView.h"
#import "SwitchBtn.h"


@interface BannerView ()

@end

@implementation BannerView

@synthesize delegate;
@synthesize titleLabel;
@synthesize switchBtn;

// 304 x 40
- (id)initWithFrame:(CGRect)frame title:(NSString *)txt
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
        // 标题
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 155, 40)];
        title.text = txt;
        title.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
        [self addSubview:title];
        self.titleLabel = title;
        title.userInteractionEnabled = YES;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [title addGestureRecognizer:gesture];
        [gesture release];
        [title release];
        // 切换按钮
        SwitchBtn * swbtn = [[SwitchBtn alloc] initWithFrame:CGRectMake(264, 0, 40, 40)];
        [self addSubview:swbtn];
        swbtn.delegate = self;
        self.switchBtn = swbtn;
        [swbtn release];
    }
    return self;
}


- (void)switchBtnClicked:(id)sender{
    if ( [delegate respondsToSelector:@selector(switchBtnClicked)] ) {
        [delegate performSelector:@selector(switchBtnClicked)];
    }
}

- (void)titleClick:(UIGestureRecognizer *)gesture{
    if ( [delegate respondsToSelector:@selector(bannerClick)] ) {
        [delegate performSelector:@selector(bannerClick)];
    }
}


- (void)dealloc{
    [titleLabel release];
    [switchBtn release];
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
