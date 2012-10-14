//
//  ToolBox.m
//  ImIcon
//
//  Created by fairzy fan on 12-6-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "ToolBox.h"

@implementation ToolBox

#define CACHE_PATH ([NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()])
#define CATE_CACHE_PATH ([NSString stringWithFormat:@"%@/Library/Caches/category.plist", NSHomeDirectory()])

+ (NSString *)url2filename:(NSString *)url{
    NSString * filename = [NSString stringWithFormat:@"%@", [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    filename = [filename stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    return filename;
}

+ (NSString *)getImgCacheDir{
    NSString * dirpath = [NSString stringWithFormat:@"%@/ImgCache", CACHE_PATH];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:dirpath] ) {
        NSLog(@"file 不存在");
        BOOL cr = [[NSFileManager defaultManager] createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:nil];
        if ( !cr ) {
            NSLog(@"创建缓存目录失败");
        }
    }
    return dirpath;
}

+ (NSURL *)convertImageUrl:(NSString *)oldurl type:(enum ImageSizeType)t{
    // 处理icon的url
    NSString * iconurl = oldurl;
    NSURL * imgurl = [NSURL URLWithString:iconurl];
    NSString * ext =  [imgurl pathExtension];
    if ( [ext isEqualToString:@"tiff"] || [ext isEqualToString:@"jpeg"] || [ext isEqualToString:@"tif"] ) {
        ext = @"jpg";
    }
    // 175x175
    if ( t == TypeList ) {
        ext = [NSString stringWithFormat:@"256x256-75.%@", ext];
    }else if( t == TypeGrid ){
        ext = [NSString stringWithFormat:@"114x114-75.%@", ext];
    }else{
        ext = [NSString stringWithFormat:@"512x512-75.%@", ext];
    }
    
    imgurl = [[imgurl URLByDeletingPathExtension] URLByAppendingPathExtension:ext];

    return imgurl;
}

// 判断缓存是否存在
+ (BOOL)imageCacheExistWithString:(NSString *)imgurl{
    NSString * filepath = [NSString stringWithFormat:@"%@/%@", [self getImgCacheDir], [self url2filename:imgurl]];
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}


+ (void)saveLikeIconId:(NSString *)appid{
    // get old

    NSMutableArray * ids =  [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]  objectForKey:@"ICON_LIKE_KEY"]];
    [ids addObject:appid];
    [[NSUserDefaults standardUserDefaults] setObject:ids forKey:@"ICON_LIKE_KEY"];
}

+ (void)deleteLikeIconId:(NSString *)appid{
    NSMutableArray * ids = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ICON_LIKE_KEY"]];
    if ( ids == nil || ids.count==0) {
        return;
    }else{
        for (NSString * obj in ids) {
            if ( [obj isEqualToString:appid]) {
                [ids removeObject:obj];
                break;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:ids forKey:@"ICON_LIKE_KEY"];
}

+ (BOOL)checkifIconLiked:(NSString *)appid{
    NSMutableArray * ids = [[NSUserDefaults standardUserDefaults] objectForKey:@"ICON_LIKE_KEY"];
    if ( ids == nil ) {
        return NO;
    }
    BOOL find = NO;
    for (NSString * obj in ids) {
        if ( [obj isEqualToString:appid]) {
            find = YES;
            break;
        }
    }
    return  find;
}

@end
