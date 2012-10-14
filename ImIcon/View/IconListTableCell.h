//
//  IconListTableCell.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconInfo.h"

#define IconListCellHeight 184

@class EGOImageView;
@class ViewController;

@interface IconListTableCell : UITableViewCell<UIAlertViewDelegate>{
    IconInfo * iconInfo;
    ViewController * delegate;
    
    EGOImageView * iconImage;
}

@property (nonatomic, assign) ViewController * delegate;
@property (nonatomic, retain) IconInfo * iconInfo;

- (void)loadWithFrame:(CGRect)frame iconInfo:(IconInfo *)info;
- (void)startLoadImage;

@end
