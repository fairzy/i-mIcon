//
//  LoadingCell.h
//  ImIcon
//
//  Created by fairzy fan on 12-6-21.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IconLoadingHeight 50

@interface LoadingCell : UITableViewCell{
    UILabel * loadingText;
    UIActivityIndicatorView * loadingIndicator;
}

@property (nonatomic, retain) UILabel * loadingText;
@property (nonatomic, retain) UIActivityIndicatorView * loadingIndicator;

- (void)setLoading:(BOOL)isload;

@end
