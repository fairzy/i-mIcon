//
//  DetailViewController.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-31.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@class IconInfo;
@class EGOImageView;
@class ProgressView;

@interface DetailViewController : UIViewController<ASIHTTPRequestDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>{
    IconInfo * iconInfo;
    CGRect initFrame;
    NSMutableData * imageData;
    float currentDataLen;
    float allDataLength;
    ASIHTTPRequest * imageRequest;
    BOOL imageLoaded;
    
    EGOImageView * iconImgView;
    UIImageView * maskImage;
    UIButton * heartBtn;
    UIButton * downBtn;
    UIButton * saveBtn;
//    UIProgressView * progressView;
    ProgressView * progressView2;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IconInfo * iconInfo;
@property (nonatomic, retain) EGOImageView * iconImgView;
@property (nonatomic, retain) UIImageView * maskImage;
@property (nonatomic, retain) UIButton * heartBtn;
@property (nonatomic, retain) UIButton * downBtn;
@property (nonatomic, retain) UIButton * saveBtn;
//@property (nonatomic, retain) UIProgressView * progressView;
@property (nonatomic, retain) ProgressView * progressView2;

- (id)initWithIconInfo:(IconInfo *)info initFrame:(CGRect)frame;
- (void)startLoadImage;

@end
