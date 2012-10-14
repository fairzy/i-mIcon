//
//  LoadMoreView.h
//  ImIcon
//
//  Created by mac  on 12-8-10.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

enum LoadState {
    LoadStatePullToLoadMore = 0,
    LoadStateReleaseToStart,
    LoadStateLoading
    };

@interface LoadMoreView : UIView{
    UILabel * textLabel;
    enum LoadState loadState;
}

@property (nonatomic, retain) UILabel * textLabel;

- (void)setLoadState:(enum LoadState)state;

@end
