//
//  CateBtn.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-30.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ClearSelectNotification  @"ClearSelectNotification"

@interface CateBtn : UIButton{
    BOOL selected;
}

@property (nonatomic, assign) BOOL selected;

@end
