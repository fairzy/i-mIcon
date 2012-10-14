//
//  DetailViewController.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-31.
//  Copyright (c) 2012年 PConline. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "IconInfo.h"
#import "EGOImageView.h"
#import "ToolBox.h"
#import "AButton.h"
#import "ProgressView.h"
#import "MobClick.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize iconInfo;
@synthesize iconImgView, maskImage;
@synthesize heartBtn, saveBtn, downBtn;
@synthesize progressView2;

- (id)initWithIconInfo:(IconInfo *)info initFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.iconInfo = info;
        initFrame = frame;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    //
    // 图片
    EGOImageView * icon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"icon-default-detail.png"]];
    [icon setFrame:initFrame];
    [self.view addSubview:icon];
    self.iconImgView = icon;
    [icon release];
    // mask
    UIImageView * mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-mask-detail.png"]];
    [mask setFrame:self.iconImgView.frame];
    [self.view addSubview:mask];
    self.maskImage = mask;
    [mask release];
    // 点击返回view
    UIView * tapview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:tapview];
    UITapGestureRecognizer * gestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTaped:)];
    [tapview addGestureRecognizer:gestrue];
    [gestrue release];
    [tapview release];
    
    // 红心按钮
    UIButton * heart = [[UIButton alloc] initWithFrame:CGRectMake(40, 335, 50, 42)];
    if ( self.iconInfo.localLiked ) {
        [heart setBackgroundImage:[UIImage imageNamed:@"heart-btn-hig.png"] forState:UIControlStateNormal];
    }else{
        [heart setBackgroundImage:[UIImage imageNamed:@"heart-btn.png"] forState:UIControlStateNormal];
    }
    [heart setBackgroundImage:[UIImage imageNamed:@"heart-btn-hig.png"] forState:UIControlStateHighlighted];
    [heart setTitle:@"喜欢" forState:UIControlStateNormal];
    heart.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    [heart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    heart.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    heart.exclusiveTouch = YES;
    heart.alpha = 0.0f;
    self.heartBtn = heart;
    [self.view addSubview:heart];
    [heart addTarget:self action:@selector(heartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [heart release];

    // 下载按钮
    UIButton * down = [[UIButton alloc] initWithFrame:CGRectMake(40+95, 335, 50, 42)];
    self.downBtn = down;
    [down setBackgroundImage:[UIImage imageNamed:@"down-btn.png"] forState:UIControlStateNormal];
    [down setTitle:@"下载App" forState:UIControlStateNormal];
    down.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    down.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:down];
    down.alpha = 0.0f;
    [down addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [down release];
    
    // 保存按钮
    UIButton * save = [[UIButton alloc] initWithFrame:CGRectMake(40+95*2, 335, 50, 42)];
    self.saveBtn = save;
    [save setBackgroundImage:[UIImage imageNamed:@"save-btn.png"] forState:UIControlStateNormal];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    save.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    save.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:save];
    save.alpha = 0.0f;
    [save addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [save release];
    // 进度条
    ProgressView * progress2 = [[ProgressView alloc] initWithFrame:CGRectMake(32, 300, 256, 20)];
    progress2.clearsContextBeforeDrawing = YES;
    [self.view addSubview:progress2];
    progress2.alpha = 0.0f;
    self.progressView2 = progress2;
    [progress2 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startLoadImage];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.iconImgView setFrame:CGRectMake(32, 32, 256, 256)];
        [self.maskImage setFrame:CGRectMake(32, 32, 256, 256)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5f animations:^{
            self.heartBtn.alpha = 1.0f;
            self.downBtn.alpha = 1.0f;
            self.saveBtn.alpha = 1.0f;
            self.progressView2.alpha = 1.0f;
        }];
    }];
}


#pragma mark -
- (void)startLoadImage{
    imageLoaded = NO;
    NSLog(@"start load imgae");
    // 处理icon的url
    NSString * iconurl = self.iconInfo.iconUrl;
    NSURL * imgurl = [ToolBox convertImageUrl:iconurl type:TypeDetail];
    // 读取缓存
    if ( [ToolBox imageCacheExistWithString:[imgurl absoluteString]] ) {
        NSString * imagepath = [NSString stringWithFormat:@"%@/%@", [ToolBox getImgCacheDir], [ToolBox url2filename: [imgurl absoluteString]]];
        UIImage * image = [UIImage imageWithContentsOfFile:imagepath ];
        self.iconImgView.image = image;
        self.progressView2.hidden = YES;
        imageLoaded = YES;
    }else{
        // 读取图片
        [imageData release];
        imageData = [[NSMutableData alloc] init];
        currentDataLen = 0;
        imageRequest = [[ASIHTTPRequest requestWithURL:imgurl] retain];
        imageRequest.delegate = self;
        [imageRequest startAsynchronous];
    }
}

- (void)downBtnClick:(id)sender{
    [MobClick event:@"storeClick" label:self.iconInfo.appId];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"跳转" message:@"打开App Store查看App否?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    
    
}

- (void)saveBtnClick:(id)sender{
    if ( imageLoaded ) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.yOffset = -80.0f;
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [HUD show:YES];
        
        UIImageWriteToSavedPhotosAlbum(self.iconImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [MobClick event:@"saveClick" label:self.iconInfo.appId];
}

- (void)heartBtnClick:(id)sender{
    NSLog(@"%s", __func__);
    UIButton * btn = (UIButton *)sender;
    if ( self.iconInfo.localLiked ) {
        [btn setBackgroundImage:[UIImage imageNamed:@"heart-btn.png"] forState:UIControlStateNormal];
        self.iconInfo.localLiked = NO;
        [ToolBox deleteLikeIconId:self.iconInfo.appId];
        
        [MobClick event:@"likeClick" label:self.iconInfo.appId];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"heart-btn-hig.png"] forState:UIControlStateNormal];
        self.iconInfo.localLiked = YES;
        [ToolBox saveLikeIconId:self.iconInfo.appId];
    }
}


- (void)bgTaped:(UIGestureRecognizer *)gesture{
    [imageRequest clearDelegatesAndCancel];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo{
    [HUD hide:YES];
    NSString * msg = @"";
    if (error){
        msg = @"保存失败";
        NSLog(@"error:%@", error);
    }else {
        msg = @"保存成功";
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


#pragma mark - ASIHTTPRequestDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    NSLog(@"did receive data");
    currentDataLen += [data length];
    [self.progressView2 setProgress:currentDataLen/allDataLength];
    [imageData appendData:data];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"responseHeaders:%@", responseHeaders);
    allDataLength = [[responseHeaders objectForKey:@"Content-Length"] intValue];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"request finished");
    // 写缓存
    NSString * iconurl = self.iconInfo.iconUrl;
    NSURL * imgurl = [ToolBox convertImageUrl:iconurl type:TypeDetail];
    NSString * imagepath = [NSString stringWithFormat:@"%@/%@", [ToolBox getImgCacheDir], [ToolBox url2filename: [imgurl absoluteString]]];
    BOOL wr = [imageData writeToFile:imagepath atomically:YES];
    NSLog(@"大图些缓存:%d", wr);
    // 
    UIImage * image = [UIImage imageWithData:imageData];
    self.iconImgView.image = image;
    self.progressView2.hidden = YES;
    imageLoaded = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"request failed:%@", request.error);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( buttonIndex == 1 ) {
        [MobClick event:@"storeRealJump" label:self.iconInfo.appId];
        
        NSString * itunesurl = self.iconInfo.itunesUrl;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl ]];
    }
    
}

#pragma mark -

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [imageRequest cancel];
    [imageRequest clearDelegatesAndCancel];
    [imageRequest release];
    imageRequest = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}



- (void)dealloc{
    NSLog(@"%s", __func__);
    [imageRequest cancel];
    [imageRequest clearDelegatesAndCancel];
    [imageRequest release];
    [iconInfo release];
    [iconImgView release];
    [heartBtn release];
    [downBtn release];
    [saveBtn release];
    [imageData release];
    [progressView2 release];
    [maskImage release];
    
    [super dealloc];
}

@end
