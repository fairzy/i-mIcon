//
//  IconInfo.m
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "IconInfo.h"

@implementation IconInfo
    
@synthesize iconUrl;
@synthesize itunesUrl;
@synthesize likeCount;
@synthesize downCount;
@synthesize localLiked;
@synthesize appId;

- (void)dealloc{
    [iconUrl release];
    [itunesUrl release];
    [appId release];
    
    [super dealloc];
}


@end
