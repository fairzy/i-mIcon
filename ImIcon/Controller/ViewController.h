//
//  ViewController.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

enum ListType {
    ListTypeGrid = 0,
    ListTypeList = 1
    };

@class BannerView;
@class CateView;
@class LoadMoreView;

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, UIScrollViewDelegate>{
    BannerView  * bannerView;
    CateView    * cateView;
    UITableView * listTableView;
    UITableView * gridTableView;
    MBProgressHUD *HUD;
    LoadMoreView * loadMoreView;
    UIView * containerView;
    UIImageView * arrowImg;
    
    NSMutableArray * dataArray; // 数据源
    enum ListType listType;
    CGRect iconTapRect;         // icon被tap的区域（用于过渡动画）
    BOOL isLoadingMore;         // 是否正在加载数据
    int currentPage;            // 当前请求页数
    NSString * reqParam;        // 当前的选择的分类(请求参数)
    float lastOffset;
}

@property (nonatomic, retain) BannerView    * bannerView;
@property (nonatomic, retain) CateView      * cateView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, assign) CGRect iconTapRect;
@property (nonatomic, retain) NSString * reqParam;
@property (nonatomic, retain) LoadMoreView * loadMoreView;
@property (nonatomic, retain) UIImageView * arrowImg;

- (void)initDataView:(NSString *)url;

@end
