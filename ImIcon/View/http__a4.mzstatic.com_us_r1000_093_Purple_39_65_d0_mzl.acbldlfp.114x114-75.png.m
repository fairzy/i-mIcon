//
//  SwitchBtn.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "SwitchBtn.h"

@implementation SwitchBtn

@synthesize gridBtn;
@synthesize listBtn;
@synthesize btnType;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 切换按钮
        UIButton * gridbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.gridBtn = gridbtn;
        [gridBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [gridBtn setImage:[UIImage imageNamed:@"switch_btn_grid.png"] forState:UIControlStateNormal];
        [self addSubview:gridBtn];
        [gridBtn addTarget:self action:@selector(gridBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        gridBtn.hidden = YES;
        
        // 切换按钮
        UIButton * list = [UIButton buttonWithType:UIButtonTypeCustom];
        self.listBtn = list;
        [listBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [listBtn setImage:[UIImage imageNamed:@"switch_btn_list.png"] forState:UIControlStateNormal];
        [self addSubview:listBtn];
        [listBtn addTarget:self action:@selector(listBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 按钮类型初始化
        btnType = BtnTypeList;
    }
    return self;
}

- (void)listBtnClicked:(id)sender{
    btnType = BtnTypeGrid;
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromLeft
                           forView:self cache:YES];
    self.gridBtn.hidden = NO;
    self.listBtn.hidden = YES;
    [UIView commitAnimations];
    [self performSelector:@selector(btnClicked:)];
}

- (void)gridBtnClicked:(id)sender{
    btnType = BtnTypeList;
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:self cache:YES];
    self.listBtn.hidden = NO;
    self.gridBtn.hidden = YES;
    
    [UIView commitAnimations];
    [self performSelector:@selector(btnClicked:)];
}

- (void)btnClicked:(id)sender{
    if ( [delegate respondsToSelector:@selector(switchBtnClicked:)] ) {
        [delegate performSelector:@selector(switchBtnClicked:)];
    }
}

- (void)dealloc{
    [listBtn release];
    [gridBtn release];
    
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
