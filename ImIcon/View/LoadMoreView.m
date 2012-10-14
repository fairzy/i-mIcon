//
//  LoadMoreView.m
//  ImIcon
//
//  Created by mac  on 12-8-10.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "LoadMoreView.h"

@implementation LoadMoreView

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, frame.size.width-16, frame.size.height)];
        [text setText:@"上拉加载更多"];
        [text setTextAlignment:UITextAlignmentCenter];
        [self addSubview:text];
        self.textLabel = text;
        [text release];
    }
    return self;
}

- (void)setLoadState:(enum LoadState)state{
    if ( state == LoadStateLoading  ) {
        [textLabel setText:@"正在加载"];
    }else if( state == LoadStatePullToLoadMore ){
        [textLabel setText:@"上拉加载更多"];
    }else{
        [textLabel setText:@"松手开始加载"];
    }
}


- (void)dealloc{
    [textLabel release];
    
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
