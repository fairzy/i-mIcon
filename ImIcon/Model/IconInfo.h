//
//  IconInfo.h
//  ImIcon
//
//  Created by fairzy fan on 12-5-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconInfo : NSObject{
    NSString * appId;
    NSString * iconUrl;
    NSString * itunesUrl;
    int likeCount;
    int downCount;
    BOOL localLiked;
}

@property int likeCount;
@property int downCount;
@property  BOOL localLiked;
@property (nonatomic, retain) NSString * appId;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSString * itunesUrl;

@end
