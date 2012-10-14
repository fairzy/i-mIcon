//
//  CateView.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-30.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CateView.h"
#import "CateBtn.h"

#import <QuartzCore/QuartzCore.h>

#define TAG_START 10
#define ITEM_TAG_START 50
#define SCROLL_WIDTH 230
#define SCROLL_HEIGHT 400-75

@implementation CateView

@synthesize cateList, isShown;
@synthesize scrollView, cateBtns;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initView{
    // Initialization code
    // 读取list
    NSString * mainpath = [NSString stringWithFormat:@"%@/Library/Caches/category.plist", NSHomeDirectory()];
    self.cateList = [NSArray arrayWithContentsOfFile:mainpath];
    if ( self.cateList == nil ) {
        NSLog(@"木有缓存目录哦");
        return;
    }
    isShown = NO;
    selectedCateIndex = 0;
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    // 白板
    UIView * board = [[UIView alloc] initWithFrame:CGRectMake(8, 0, self.frame.size.width-16, self.frame.size.height-30)];
    board.backgroundColor = [UIColor whiteColor];
    [self addSubview:board];
    [board release];
    // keys
    NSArray * catekey = [self.cateList valueForKey:@"group_name"];
    // btns
    int keycount = self.cateList.count;
    self.cateBtns = [NSMutableArray arrayWithCapacity:keycount];
    // 左侧分类按钮们
    for (int i=0; i<keycount; i++) {
        // 计算坐标
        float height = 42;
        float width = 64;
        int x = 3;
        int y = 10 + (height+8) * i;
        // 按钮
        CateBtn * btn = [[CateBtn alloc] initWithFrame:CGRectMake(x, y, width, height)];
        btn.tag = TAG_START + i;
        NSString * catename = [catekey objectAtIndex:i];
        [btn setTitle:catename forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(cateSelected:) forControlEvents:UIControlEventTouchUpInside];
        if ( i == 0 ) {
            btn.selected = YES;
        }
        [self.cateBtns addObject:btn];
        [btn release];
    }
    // 右侧具体分类
    // hold住
    UIScrollView * scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(82, 10, self.frame.size.width-90, self.frame.size.height-75.0f)];
    [self addSubview:scrView];
    scrView.showsVerticalScrollIndicator = NO;
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.delegate = self;
    scrView.pagingEnabled = YES;
    
    for (int i=0; i<catekey.count; i++) {
        UIView * holdView = [[UIView alloc] initWithFrame:CGRectMake(SCROLL_WIDTH*i, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
        
        NSString * catename = [catekey objectAtIndex:i];
        NSArray * list = [[self.cateList objectAtIndex:i] objectForKey:@"group_items"];
        // 标题
        UILabel * namelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 50)];
        namelabel.textColor = [UIColor colorWithRed:65.0f/255.0f green:121.0f/255.0f blue:168.0f/255.0f alpha:1.0f];
        namelabel.text = catename;
        [holdView addSubview:namelabel];
        [namelabel release];
        // 条目
        float itemwidth = 78.0f;
        float itemheight = 35.0f;
        int row = ceilf(list.count/3.0f);
        // 行
        float itemMinHeight = 50.0f;
        for (int j = 0; j < row; j++) {
            // 每行的每个
            for (int k = 0; k < 3; k++) {
                int index = j*3 + k;
                if ( index < list.count ) {
                    NSString * itemtitle =  [[list objectAtIndex:index] objectForKey:@"item_name"];
                    UIButton * itemlabel = [[UIButton alloc] initWithFrame:CGRectMake(itemwidth*k, itemMinHeight, itemwidth, itemheight)];
                    [itemlabel addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
                    itemlabel.tag = index + ITEM_TAG_START;
                    itemlabel.titleLabel.adjustsFontSizeToFitWidth = YES;
                    [itemlabel setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                    [itemlabel setTitle:itemtitle forState:UIControlStateNormal];
                    [holdView addSubview:itemlabel];
                    [itemlabel release];
                }
            }
            itemMinHeight += itemheight;
        }
        
        [scrView addSubview:holdView];
        [holdView release];
    }
    
    [scrView setContentSize:CGSizeMake(SCROLL_WIDTH*catekey.count, SCROLL_HEIGHT)];
    [self addSubview:scrView];
    self.scrollView = scrView;
    [scrView release];
    
    // 底部信息栏
    UIImageView * infoBar = [[UIImageView alloc] initWithFrame:CGRectMake(8,  self.frame.size.height-70, self.frame.size.width-16, 40)];
    infoBar.image = [UIImage imageNamed:@"infobar_bg.png"];
    infoBar.userInteractionEnabled = YES;
    // info按钮
    UIButton * infobtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [infobtn setImage:[UIImage imageNamed:@"info_btn.png"] forState:UIControlStateNormal];
    [infobtn addTarget:self action:@selector(infoClick:) forControlEvents:UIControlEventTouchUpInside];
    [infoBar addSubview:infobtn];
    [infobtn release];
    UIButton * shrinkbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-16-40, 0, 40, 40)];
    [shrinkbtn setImage:[UIImage imageNamed:@"shrink_btn.png"] forState:UIControlStateNormal];
    [shrinkbtn addTarget:self action:@selector(shrinkClick:) forControlEvents:UIControlEventTouchUpInside];
    [infoBar addSubview:shrinkbtn];
    [shrinkbtn release];
    
    [self addSubview:infoBar];
    [infoBar release];
}

#pragma mark -
- (void)infoClick:(id)sender{
    
}

- (void)shrinkClick:(id)sender{
    if ( delegate ) {
        [delegate performSelector:@selector(bannerClick)];
    }
}

- (void)cateSelected:(UIButton *)sender{
    int tag = sender.tag-TAG_START;
    selectedCateIndex = tag;
    NSLog(@"cate tag:%d", tag);
    [self.scrollView setContentOffset:CGPointMake( tag * SCROLL_WIDTH, 0 ) animated:YES];
    // 清除其他状态
    [[NSNotificationCenter defaultCenter] postNotificationName:ClearSelectNotification object:nil];
    // 选中当前
    sender.selected = YES;
}

- (void)itemSelected:(UIButton *)sender{
    int tag = sender.tag - ITEM_TAG_START;
    id obj = [self.cateList objectAtIndex:selectedCateIndex];
    NSString *cateName = [obj objectForKey:@"group_name"];
    NSString *itemName = [[[obj objectForKey:@"group_items"] objectAtIndex:tag] objectForKey:@"item_name"];
    NSString *itemId = [[[obj objectForKey:@"group_items"] objectAtIndex:tag] objectForKey:@"item_id"];
    NSLog(@"%@-%@-%@", cateName, itemId, itemName);
    NSString *selTitle = [NSString stringWithFormat:@"%@ -- %@", cateName, itemName];
    NSString * param = [NSString stringWithFormat:@"id=%@", itemId];
    if ( [cateName isEqualToString:@"分类"] ) {
        param = [param stringByAppendingString:@"&t=cate"];
    }else {
        param = [param stringByAppendingString:@"&t=tag"];
    }

    [UIView animateWithDuration:0.55f animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 2, 2);
        sender.alpha = 0;
    } completion:^(BOOL finish){
        [self show:NO];
        sender.transform = CGAffineTransformScale(sender.transform, 0.5, 0.5);
        sender.alpha = 1;
        
        NSLog(@"perform");
        if ( [delegate respondsToSelector:@selector(cateItemSelected:)] ) {
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:selTitle, @"title", param, @"param", nil];
            [delegate performSelector:@selector(cateItemSelected:) withObject:dict];
        }
    }];
}

- (void)show:(BOOL)show{
    if ( show == isShown ) {
        return;
    }
    CGRect frame = self.frame;
    if ( show ) {
        self.hidden = NO;
        frame.origin.y = frame.origin.y + frame.size.height-2;
        isShown = YES;
    }else{
         frame.origin.y = frame.origin.y - frame.size.height+2;
        isShown = NO;
    }
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setFrame:frame];
                     } completion:^(BOOL finished){
                         self.hidden = !show;
                     }];
    [self setFrame:frame];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv{
    int offset = sv.contentOffset.x/SCROLL_WIDTH;
    UIButton * btn = (UIButton *)[self.cateBtns objectAtIndex:offset];
    [self performSelector:@selector(cateSelected:) withObject:btn];
}

#pragma mark dealloc
- (void)dealloc{
    [cateList release];
    [scrollView release];
    [cateBtns release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
