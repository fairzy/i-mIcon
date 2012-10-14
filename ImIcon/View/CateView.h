//
//  CateView.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-30.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutView.h"

@interface CateView : UIView <UIScrollViewDelegate>{
    NSArray * cateList;
    
    UIScrollView * scrollView;
    NSMutableArray * cateBtns;
    AboutView * aboutView;
    
    NSString * oldTitle;
    BOOL isShown;
    int selectedCateIndex;
    id delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSArray * cateList;
@property (nonatomic, retain) NSMutableArray * cateBtns;
@property (nonatomic, assign) BOOL isShown;
@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIView * boardView;
@property (nonatomic, retain) NSString * oldTitle;

- (void)show:(BOOL)show;
- (void)initView;

@end
