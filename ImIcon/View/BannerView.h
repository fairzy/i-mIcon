//
//  BannerView.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchBtn.h"


@class SwitchBtn;

@interface BannerView : UIView{
    UILabel * titleLabel;
    SwitchBtn * switchBtn;
    
    id delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) SwitchBtn * switchBtn;

- (id)initWithFrame:(CGRect)frame title:(NSString *)txt;

@end
