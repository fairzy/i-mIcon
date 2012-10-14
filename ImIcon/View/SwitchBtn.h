//
//  SwitchBtn.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SwitchBtnType {
    BtnTypeGrid = 0,
    BtnTypeList = 1
};

@interface SwitchBtn : UIView{
    UIButton * gridBtn;
    UIButton * listBtn;
    
    enum SwitchBtnType btnType;
    id delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign, readonly) enum SwitchBtnType btnType;
@property (nonatomic, retain) UIButton * gridBtn;
@property (nonatomic, retain) UIButton * listBtn;

@end
