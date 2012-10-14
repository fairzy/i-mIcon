//
//  IconGridTableCell.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IconGridTableCell.h"
#import "IconInfo.h"
#import "ViewController.h"
#import "ToolBox.h"
#import "ASIHTTPRequest.h"

#define TAG_START 10

#ifndef __OPTIMIZE__  
#define NSLog(...) NSLog(__VA_ARGS__)  
#else  
#define NSLog(...) /**/
#endif  


@interface IconGridTableCellContentView : UIView{
    NSArray * dataArray;
    BOOL isTouching;
    CGRect touchRect;
}

@property (nonatomic, assign) NSArray * dataArray;

@end

@implementation IconGridTableCellContentView

@synthesize dataArray;

- (id)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
        self.opaque = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
//    NSLog(@"ddd:%f,%f,%f,%f", rect.origin.x, rect.origin.y, rect.size.width,rect.size.height);
    UIImage * maskImage = [UIImage imageNamed:@"icon-mask-grid.png"];
    UIImage * defaultImage = [UIImage imageNamed:@"icon-default-grid.png"];
    
    for ( int i=0 ; i<dataArray.count; i++) {
        NSLog(@"默认绘制rect");
        CGRect rect = CGRectMake(8*(i+1)+70*i, 0, 70, 70);
        // icon
        IconInfo * iconInfo = [dataArray objectAtIndex:i];
        NSString * trueImageurl = [ToolBox url2filename: [[ToolBox convertImageUrl:iconInfo.iconUrl type:TypeGrid] absoluteString]];
        NSString * imgCacheFile = [NSString stringWithFormat:@"%@/%@", [ToolBox getImgCacheDir], trueImageurl];
        NSLog(@"read cache:%@, %d", imgCacheFile, [[NSFileManager defaultManager] fileExistsAtPath:imgCacheFile]);
        // 读取缓存
        UIImage * iconImage = [UIImage imageWithContentsOfFile:imgCacheFile];
        if ( iconImage == nil ) {
            iconImage = defaultImage;
        }
        [iconImage drawInRect:rect];
        [maskImage drawInRect:rect];
    }
//    if ( isTouching ) {
//        UIImage * outmanImg = [UIImage imageNamed:@"outman.png"];
//        [outmanImg drawInRect:touchRect];
//    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    CGPoint point = [[touches anyObject] locationInView:self];
//    int x = point.x / 80;
//    touchRect = CGRectMake(8*(x+1)+70*x, 0, 70, 70);
//    isTouching = YES;
//    
//    NSLog(@"touch begin:%d, %f,%f", [touches count], point.x, point.y );
//    
//    [self setNeedsDisplayInRect:touchRect];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    isTouching = NO;
//    
//    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"touch cancelm:%d,%f,%f", [touches count], point.x, point.y);
//    
//    [self setNeedsDisplayInRect:touchRect];
//    touchRect = CGRectZero;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    isTouching = NO;
//    
//    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"touch ended:%d, %f, %f", [touches count], point.x, point.y);
//    
//    [self setNeedsDisplayInRect:touchRect];
//    touchRect = CGRectZero;
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"touch moved:%d, %f, %f", [touches count], point.x, point.y);
//}


@end

@implementation IconGridTableCell

@synthesize infoArray;
@synthesize imgArray;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
        self.opaque = YES;
        cellContentView = [[IconGridTableCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0)];
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:cellContentView];
        [cellContentView setNeedsDisplay];
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnclick:) ];
        [cellContentView addGestureRecognizer:gesture];
        [gesture release];
    }
    
    return self;
}

- (void)loadArray:(NSArray *)infos{
    self.infoArray = infos;
    cellContentView.dataArray = self.infoArray;
}

- (void)startLoadImage{
    [cellContentView setNeedsDisplay];
    if ( queue != nil ) {
        [queue cancelAllOperations];
        [queue release];
        queue = nil;
    }
    queue = [[ASINetworkQueue alloc] init];
    [queue setShouldCancelAllRequestsOnFailure:NO];
    
    // 异步下载图片
    for ( int i=0 ; i<infoArray.count; i++) {
        //[cellContentView setNeedsDisplayInRect:CGRectMake(8*(i+1)+70*i, 0, 70, 70)];
        IconInfo * iconinfo = (IconInfo *)[self.infoArray objectAtIndex:i];
        // 处理icon的url
        NSString * iconurl = iconinfo.iconUrl;
        NSURL * imgurl = [ToolBox convertImageUrl:iconurl type:TypeGrid];
        NSLog(@"异步下载图片:%d", i);
        // 先判断缓存是否存在
        if( [ToolBox imageCacheExistWithString:[imgurl absoluteString]] == NO){
            NSLog(@"下载开始");
            // 先设置为默认图片
            
            // 再发起请求
            ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:imgurl];
            request.tag = i;
            request.delegate = self;
            [queue addOperation:request];
        }
    }
    [queue go];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    int tag = request.tag;
    NSLog(@"异步加载finish:%d", tag);
    NSString * imgFilename = [ToolBox url2filename: [request.url absoluteString]] ;
    // 写缓存
    NSData * data = [request responseData];
    NSString * imgCacheFile = [NSString stringWithFormat:@"%@/%@", [ToolBox getImgCacheDir], imgFilename];
    NSLog(@"image finish: %d--%@", tag, imgCacheFile);
    BOOL wr = [data writeToFile:imgCacheFile atomically:YES];
    NSLog(@"write result:%d", wr);
    [cellContentView setNeedsDisplayInRect:CGRectMake(8*(tag+1)+70*tag, 0, 70, 70)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[queue cancelAllOperations];
	}
}

- (void)btnclick:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:cellContentView];
    int tag = point.x / 80;
    if ( delegate && [delegate isKindOfClass:[UIViewController class]]) {
        CGRect frame = CGRectMake(8*(tag+1)+70*tag, 0, 70, 70);
        NSLog(@"old frame:%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
//        CGRect newframe = [self convertRect:frame toView:self];
//        NSLog(@"new frame:%f, %f, %f, %f", newframe.origin.x, newframe.origin.y, newframe.size.width, newframe.size.height);
        CGRect newframe = [self convertRect:frame toView:delegate.view];
        delegate.iconTapRect = newframe;
        NSLog(@"new frame:%f, %f, %f, %f", newframe.origin.x, newframe.origin.y, newframe.size.width, newframe.size.height);
    }
    if ( [delegate respondsToSelector:@selector(iconTaped:)] ) {
        IconInfo * info = [self.infoArray objectAtIndex:tag];
        [delegate performSelector:@selector(iconTaped:) withObject:info];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)dealloc{
    [infoArray release];
    [imgArray release];
    [cellContentView release];
    [queue reset];
    [queue release];
    
    
    [super dealloc];
}


@end
