//
//  IconGridTableCell.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#define IconGridCellHeight  78

@class IconInfo;
@class IconGridTableCellContentView;
@class ViewController;

@interface IconGridTableCell : UITableViewCell<ASIHTTPRequestDelegate>{
    NSArray * infoArray;
    NSArray * imgArray;
    IconGridTableCellContentView * cellContentView;
    ViewController * delegate;
    
    // 请求队列
    ASINetworkQueue * queue;
}

@property (nonatomic, assign) ViewController * delegate;
@property (nonatomic, retain) NSArray * infoArray;
@property (nonatomic, retain) NSArray * imgArray;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier iconArray:(NSArray *)infocon;
//- (void)loadWithFrame:(CGRect)frame iconArray:(NSArray *)infos;
- (void)startLoadImage;
- (void)loadArray:(NSArray *)infos;
//- (void)reload;

@end
