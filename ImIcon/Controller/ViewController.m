//
//  ViewController.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"
#import "IconListTableCell.h"
#import "IconGridTableCell.h"
#import "CateView.h"
#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "LoadingCell.h"
#import "LoadMoreView.h"
#import "ToolBox.h"
#import "MobClick.h"

#define API_URL @"http://iconapi.sinaapp.com" // no / in the end


@interface ViewController ()

- (NSArray *)array2IconInfoArray:(NSArray *)array;

@end

@implementation ViewController

@synthesize bannerView, loadMoreView, arrowImg;
@synthesize dataArray;
@synthesize cateView, containerView;
@synthesize iconTapRect;
@synthesize reqParam;

- (void)loadView{
    [super loadView];
    // 数据初始化
    listType = ListTypeList;
    isLoadingMore = NO;
    // 容器
    UIView * conview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    // 背景
    conview.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 网格列表
    gridTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, 320, 432) style:UITableViewStylePlain];
    [conview addSubview:gridTableView];
    gridTableView.backgroundColor =  [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    gridTableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
    gridTableView.delegate = self;
    gridTableView.dataSource = self;
    //gridTableView.hidden = YES;
    gridTableView.alpha = 0.0f;
    // 列表2
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, 320, 432) style:UITableViewStylePlain];
    [conview addSubview:listTableView];
    listTableView.backgroundColor =  [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.delegate = self;
    listTableView.dataSource = self;
    //listTableView.hidden = NO;
    listTableView.alpha = 1.0f;
    //
    [self.view addSubview:conview];
    self.containerView = conview;
    [conview release];
    // 下拉列表
    CateView * cview = [[CateView alloc] initWithFrame:CGRectMake(0, 40-440, 320, 441)];
    cview.hidden = YES;
    [self.view addSubview:cview];
    self.cateView = cview;
    cview.delegate = self;
    [cview release];
    
    // 标题栏
    BannerView * banner = [[BannerView alloc] initWithFrame:CGRectMake(8, -1, 304, 40) title:@"随机"];
    banner.layer.borderColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:185.0f/255.0f alpha:1.0f].CGColor;
    banner.layer.borderWidth = 1.0f;
    [self.view addSubview:banner];
    self.bannerView = banner;
    banner.delegate = self;
    [banner release];
    
    // 标题栏小箭头
    UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(2, 10, 20, 20)];
    [arrow setImage: [UIImage imageNamed:@"arrow_r.png"]];
    [self.bannerView addSubview:arrow];
    self.arrowImg = arrow;
    [arrow release];
}

- (void)viewDidLoad
{
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    //
    LoadMoreView * footview = [[LoadMoreView alloc] initWithFrame:CGRectMake(0, 0, listTableView.bounds.size.width, 50)];
    listTableView.clipsToBounds = NO;
    footview.hidden = YES;
    listTableView.tableFooterView = footview;
    self.loadMoreView = footview;
    [footview release];
    
    // 初始化数据(分类初始化，请求hot图片列表)
    [self initDataView:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initDataView:(NSString *)param{
    self.dataArray = nil;
    [listTableView reloadData];
    [gridTableView reloadData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    currentPage = 0;
    
    [self performSelectorInBackground:@selector(loadData:) withObject:param];
}

#pragma mark load data
- (void)loadData:(NSString *)param{
    isLoadingMore = YES;
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    // 请求分类信息
    if( param == nil ){
        NSString * cateurl = [NSString stringWithFormat:@"%@/category_list.php", API_URL];
        NSLog(@"请求地址:%@", cateurl);
        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:cateurl]];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString * responStr = [request responseString];
            // 解析cate并存入文件中
            NSArray * array = [responStr objectFromJSONString];
            NSLog(@"id:%d", [array count]);
            NSString * mainpath = [NSString stringWithFormat:@"%@/Library/Caches/category.plist", NSHomeDirectory()];
            BOOL wr = [array writeToFile:mainpath atomically:YES];
            [self.cateView initView];
            NSLog(@"写入:%d", wr);
            if (wr == NO) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"写缓存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }else {
            NSLog(@"error:%@", error);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请求分类信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    // 请求列表信息
    if ( param == nil ) {
        param = @"t=hot";
    }
    NSString * imgurl = [NSString stringWithFormat:@"%@/%@?p=%d&%@", API_URL, @"img_list.php",currentPage, param];
    NSLog(@"img url:%@", imgurl);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgurl]];
    [request startSynchronous];
    NSError *error = [request error];
    NSArray * tmparray = nil;
    if (!error) {
        NSString * responStr = [request responseString];
        
        tmparray = [responStr objectFromJSONString];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请求图片列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    NSMutableArray * tmpDataArray = [NSMutableArray arrayWithArray: [self array2IconInfoArray:tmparray]];
    if ( self.dataArray == nil ) {
        self.dataArray = tmpDataArray;
        [self performSelectorOnMainThread:@selector(reloadView) withObject:nil waitUntilDone:NO];
    }else{
        NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:tmpDataArray.count];
        for (int i=0; i<tmpDataArray.count; i++) {
            NSIndexPath * path = [NSIndexPath indexPathForRow:self.dataArray.count+i inSection:0];
            [indexPaths addObject:path];
        }
        [self.dataArray addObjectsFromArray:tmpDataArray];
        [self performSelectorOnMainThread:@selector(loadNextPageView:) withObject:indexPaths waitUntilDone:NO];
    }
    
    [pool drain];
}

// 数据加载完后重新load Tableview
- (void)reloadView{
    NSLog(@"load complete");
    [HUD hide:YES];
    isLoadingMore = NO;
    [self.loadMoreView setLoadState:LoadStatePullToLoadMore];
    
    [listTableView reloadData];
    self.loadMoreView.hidden = NO;
    [gridTableView reloadData];
}
// 加载下一页数据完成后刷新tablview
- (void)loadNextPageView:(NSArray *)indexpath{
    NSLog(@"load next page complete");
    [HUD hide:YES];
    isLoadingMore = NO;
    [self.loadMoreView setLoadState:LoadStatePullToLoadMore];
    
    if( listType == ListTypeList ){
        [listTableView insertRowsAtIndexPaths:indexpath withRowAnimation:UITableViewRowAnimationTop];
        [gridTableView reloadData];
    }
    
}


#pragma mark
- (void)switchBtnClicked{
    NSLog(@"%s", __func__);
    if ( listType == ListTypeGrid ) {
        // set offset
        [listTableView setContentOffset:CGPointMake(0, lastOffset)];
        lastOffset = gridTableView.contentOffset.y;
    }else{
        // set offset
        [gridTableView setContentOffset:CGPointMake(0, lastOffset)];
        lastOffset = listTableView.contentOffset.y;
    }
    // 
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    [gridTableView.layer addAnimation:transition forKey:nil];
    [listTableView.layer addAnimation:transition forKey:nil];
    
    if ( listType == ListTypeGrid) {
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        [gridTableView.layer addAnimation:transition forKey:nil];
        [listTableView.layer addAnimation:transition forKey:nil];
        
        NSLog(@"grid to list");
        // set alpha
        listType = ListTypeList;
        listTableView.alpha = 1.0f;
        gridTableView.alpha = 0.0f;
    }else {
        NSLog(@"list to grid");
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [gridTableView.layer addAnimation:transition forKey:nil];
        [listTableView.layer addAnimation:transition forKey:nil];
        // set alpha
        listType = ListTypeGrid;
        listTableView.alpha = 0.0f;
        gridTableView.alpha = 1.0f;
    }
    
    [MobClick event:@"SwitchBtnClick"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"stopped");

    [self performSelector:@selector(reloadView)];
}

#pragma mark -

- (void)bannerClick{
    if ( self.cateView.isShown ) {
        // 旋转箭头
        [UIView animateWithDuration:0.25f delay:0.25f options:UIViewAnimationCurveEaseIn animations:^{
            CATransform3D rt = CATransform3DIdentity;
            rt = CATransform3DRotate(rt, 0.0f, 0.0f, 0.0f, 1.0f);
            self.arrowImg.layer.transform = rt;
        } completion:nil];
    
        // 显示下啦view
        [self.cateView show:NO];
        // 缩放底层view
        [UIView animateWithDuration:0.25f delay:0.25f options:UIViewAnimationCurveEaseIn animations:^{
            CATransform3D t = CATransform3DIdentity;
            t = CATransform3DScale(t, 1.0f, 1.0f, 1.0f);
            self.containerView.layer.transform = t;
        } completion:nil];
        
        self.bannerView.switchBtn.userInteractionEnabled = YES;
    }else {
        // 旋转箭头
        [UIView animateWithDuration:0.25f delay:0.25f options:UIViewAnimationCurveEaseIn animations:^{
            CATransform3D rt = CATransform3DIdentity;
            rt = CATransform3DRotate(rt, 45.0f, 0.0f, 0.0f, 1.0f);
            self.arrowImg.layer.transform = rt;
        } completion:nil];
        // 缩放view
        [UIView animateWithDuration:0.25f animations:^{
            CATransform3D t = CATransform3DIdentity;
            t = CATransform3DScale(t, 0.8f, 0.8f, 0.8f);
            self.containerView.layer.transform = t;
        } completion:^(BOOL finished){
            [self.cateView show:YES];
        }];
        self.bannerView.switchBtn.userInteractionEnabled = NO;
    }
    
    [MobClick event:@"BannerClick"];
}


#pragma mark - custom delegate
// 点击了icon，查看大图
- (void)iconTaped:(IconInfo *)info{
    NSLog(@"tapped!");
    
    DetailViewController * detailController = [[DetailViewController alloc] initWithIconInfo:info initFrame:iconTapRect];
    [self presentModalViewController:detailController animated:NO];
    [detailController release];
    
    [MobClick event:@"iconTaped" label:info.appId];
}

- (void)saveIcon:(UIImage *)img{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
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


- (void)cateItemSelected:(NSDictionary *)dict{
    [self bannerClick];
    //
    NSString * title = [dict objectForKey:@"title"];
    self.bannerView.titleLabel.text = title;
    
    NSString * param = [dict objectForKey:@"param"];
    self.reqParam = param;
    self.bannerView.switchBtn.userInteractionEnabled = YES;
    self.dataArray = nil;
    [listTableView reloadData];
    [gridTableView reloadData];
    
    [self performSelector:@selector(initDataView:) withObject:self.reqParam];
    
    [MobClick event:@"cateItemSelected" label:title];
}

- (NSArray *)array2IconInfoArray:(NSArray *)array{
    NSMutableArray * newarray = [NSMutableArray arrayWithCapacity:array.count];
    for (id obj in array) {
        NSLog(@"one obj:%@", obj);
        IconInfo * info = [IconInfo new];
        info.appId = [obj objectForKey:@"appID"];
        info.iconUrl = [obj objectForKey:@"appLogo"];
        info.itunesUrl = [obj objectForKey:@"appLink"];
        info.likeCount = [[obj objectForKey:@"likeCount"] intValue];
        info.downCount = [[obj objectForKey:@"downCount"] intValue];
        info.localLiked = [ToolBox checkifIconLiked:info.appId];
        [newarray addObject:info];
        [info release];
    }
    return newarray;
}

#pragma mark UITableView DataSource
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( tableView == listTableView ) {
        return IconListCellHeight;
    }else {
        return IconGridCellHeight;
    }
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%s", __func__);
    if ( dataArray == nil ) {
        return 0;
    }

    if ( tableView == listTableView ) {
        return [dataArray count];
    }else {
        return ceilf([dataArray count]/4.0f);
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s, %d", __func__, [indexPath row]);
    int row = [indexPath row];
    NSLog(@"tableview==list:%d, ==grid:%d", listTableView==tableView, gridTableView==tableView);
    if ( tableView == listTableView ) {
        
        NSString * cellid = @"icon_list_cell_normal";
        IconListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if ( cell == nil ) {
            cell = [[[IconListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        IconInfo * info = [dataArray objectAtIndex:row];
        NSLog(@"info.iconUrl:%@", info.iconUrl);
        [cell loadWithFrame:CGRectMake(0, 0, 320, IconListCellHeight) iconInfo:info];
        [cell startLoadImage];
        return cell;

    }else {
        int row = [indexPath row];
        NSString * cellid = @"icon_grid_cell";
        IconGridTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if ( cell == nil ) {
            cell = [[[IconGridTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        NSMutableArray * tmpArray = [[NSMutableArray alloc] initWithCapacity:4];
        int realrow = row*4;
        for ( int i=0 ; i<4; i++) {
            if ( realrow+i < [dataArray count] ) {
                IconInfo * info1 = [dataArray objectAtIndex:realrow+i];
                [tmpArray addObject:info1];
            }
        }
        [cell loadArray: tmpArray];
        NSLog(@"tmpArray:%@", tmpArray);
        [cell startLoadImage];
        [tmpArray release];
        return cell;
    }
}


#pragma mark scroll delegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    float offset = scrollView.contentOffset.y + scrollView.frame.size.height;
//    NSLog(@"offset:%f -- %f", offset, scrollView.contentSize.height);
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ( listType == ListTypeGrid ) {
        return;
    }
    float offset = scrollView.contentOffset.y + scrollView.frame.size.height;
    NSLog(@"offset:%f", offset);
    NSLog(@"size:%f", scrollView.contentSize.height);
    
    if ( !isLoadingMore ) {
        if ( offset > scrollView.contentSize.height+60 ) {
            [self.loadMoreView setLoadState:LoadStateReleaseToStart];
        }else{
            [self.loadMoreView setLoadState:LoadStatePullToLoadMore];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ( listType == ListTypeGrid ) {
        return;
    }
    float offset = scrollView.contentOffset.y + scrollView.frame.size.height;
    if ( !isLoadingMore && offset > scrollView.contentSize.height+60) {
        [self.loadMoreView setLoadState:LoadStateLoading];
        // 开始加载下一页
        currentPage++;
        [self performSelectorInBackground:@selector(loadData:) withObject:self.reqParam];
        isLoadingMore = YES;
    }
}


#pragma mark dealloc
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void)dealloc{
    [arrowImg release];
    [bannerView release];
    [gridTableView release];
    [listTableView release];
    
    [super dealloc];
}

@end
