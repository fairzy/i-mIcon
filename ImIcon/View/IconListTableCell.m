//
//  IconListTableCell.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "IconListTableCell.h"
#import "IconInfo.h"
#import "EGOImageView.h"
#import "ToolBox.h"
#import "ViewController.h"


@interface ListBgView : UIView

@property (nonatomic, retain) UIImage * image;

@end

@implementation ListBgView

@synthesize image;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    NSLog(@"draw");
    //[self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImage * sepline = [UIImage imageNamed:@"sep_line.png"];
    [sepline drawAtPoint:CGPointMake(210, 58)];
    [sepline drawAtPoint:CGPointMake(210, 116)];
    
}

@end


@implementation IconListTableCell

@synthesize iconInfo, delegate;

- (void)loadWithFrame:(CGRect)frame iconInfo:(IconInfo *)info{
    if ( self.iconInfo == info ) {
        return;
    }
    self.frame = frame;
    self.iconInfo = info;
    // 背景
    self.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:239.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    // 清理旧的
    ListBgView * container = (ListBgView *)[self viewWithTag:100];
    if ( container ) {
        [container removeFromSuperview];
        container = nil;
    }
    // 自定义
    container = [[ListBgView alloc] initWithFrame:CGRectMake(8, 4, frame.size.width-16, frame.size.height-8) ];
    container.layer.borderColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:208.0f/255.0f alpha:1.0f].CGColor;
    container.layer.borderWidth = 1.0f;
    container.tag = 100;
    container.opaque = YES;
    container.backgroundColor= [UIColor colorWithHue:0.0f saturation:0.0f brightness:0.98f alpha:1.0f];
    // icon
    iconImage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"icon-default-list.png"]];
    iconImage.frame = CGRectMake(8, 8, 160, 160);
    iconImage.userInteractionEnabled = YES;
    [container addSubview:iconImage];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listIconClicked:)];
    [iconImage addGestureRecognizer:tapGesture];
    [tapGesture release];
    // mask
    UIImageView * maskimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_mask.png"]];
    maskimg.frame = CGRectMake(8, 8, 160, 160);
    [container addSubview:maskimg];
    [maskimg release];
    // 喜欢按钮
    UIButton * likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(225, 20, 78, 20)];
    if ( info.localLiked ) {
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"listcell_like_btn_hig.png"] forState:UIControlStateNormal];
    }else{
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"listcell_like_btn.png"] forState:UIControlStateNormal];
    }
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"listcell_like_btn_hig.png"] forState:UIControlStateHighlighted];
    [likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    likeBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    [likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:likeBtn];
    [likeBtn release];
    // 保存按钮
    UIButton * saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(225, 80, 78, 20)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"listcell_save_btn.png"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    saveBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:saveBtn];
    [saveBtn release];
    // app store
    UIButton * storeBtn = [[UIButton alloc] initWithFrame:CGRectMake(225, 135, 78, 20)];
    [storeBtn setBackgroundImage:[UIImage imageNamed:@"listcell_down_btn.png"] forState:UIControlStateNormal];
    [storeBtn setTitle:@"APP" forState:UIControlStateNormal];
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    storeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    storeBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    [storeBtn addTarget:self action:@selector(storeClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:storeBtn];
    [storeBtn release];
    //
    [self addSubview:container];
    container.userInteractionEnabled = YES;
    [container release];
}

- (void)startLoadImage{
    // 先处理url
    NSString * iconurl = self.iconInfo.iconUrl;
    NSURL * imgurl = [ToolBox convertImageUrl:iconurl type:TypeList];
    NSLog(@"list image url:%@", [imgurl absoluteString]);
    iconImage.imageURL = imgurl;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[iconImage cancelImageLoad];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)listIconClicked:(UITapGestureRecognizer *)gesture{
    NSLog(@"listIconClicked");
    CGRect iconframe = iconImage.frame;
    CGRect newFrame = [self convertRect:iconframe toView:delegate.view];
    delegate.iconTapRect = newFrame;

    if ( [delegate respondsToSelector:@selector(iconTaped:)] ) {
        [delegate performSelector:@selector(iconTaped:) withObject:iconInfo];
    }
}

- (void)likeClick:(id)sender{
    
    UIButton * btn = (UIButton *)sender;
    NSLog(@"like:%@", btn);
    if ( self.iconInfo.localLiked ) {
        [btn setBackgroundImage:[UIImage imageNamed:@"listcell_like_btn.png"] forState:UIControlStateNormal];
        self.iconInfo.localLiked = NO;
        [ToolBox deleteLikeIconId:self.iconInfo.appId];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"listcell_like_btn_hig.png"] forState:UIControlStateNormal];
        self.iconInfo.localLiked = YES;
        [ToolBox saveLikeIconId:self.iconInfo.appId];
    }
}

- (void)saveClick:(id)sender{
    NSLog(@"save");
    if ( delegate  ) {
        [delegate performSelector:@selector(saveIcon:) withObject:iconImage.image ];
    }
}

- (void)storeClick:(id)sender{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"跳转" message:@"打开App Store查看App否?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( buttonIndex == 1 ) {
        NSURL * url = [NSURL URLWithString: self.iconInfo.itunesUrl];
        [[UIApplication sharedApplication] openURL: url];
    }
}

- (void)dealloc{
    [iconInfo release];
    [iconImage release];
    
    [super dealloc];
}

@end
