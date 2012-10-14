//
//  ToolBox.h
//  ImIcon
//
//  Created by fairzy fan on 12-6-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ImageSizeType {
    TypeGrid = 0,
    TypeList = 1,
    TypeDetail
    };

@interface ToolBox : NSObject

+ (NSString *)getImgCacheDir;
+ (NSString *)url2filename:(NSString *)url;
+ (NSURL *)convertImageUrl:(NSString *)oldurl type:(enum ImageSizeType)t;
+ (BOOL)imageCacheExistWithString:(NSString *)imgurl;
+ (void)saveLikeIconId:(NSString *)appid;
+ (void)deleteLikeIconId:(NSString *)appid;
+ (BOOL)checkifIconLiked:(NSString *)appid;
@end
