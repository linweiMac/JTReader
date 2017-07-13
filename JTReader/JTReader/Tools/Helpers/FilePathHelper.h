//
//  FilePathHelper.h
//  信云课堂
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 besttone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <lame/lame.h>
@interface FilePathHelper : NSObject

+(BOOL)fileIsExistsAtPath:(NSString *)path;
+ (NSString *)cacheFilePath:(NSString *)path;
+ (NSString *)cacheFilePath:(NSString *)path fileName:(NSString *)fileName;

//caf转mop3音频
+ (void)cafToMp3:(NSString *)cafPath withMp3:(NSString *)mp3Path;

//时间格式化
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)updateTimeString:(NSDate *)lastUpdateTime;

//文件大小格式化
+(NSString *)getFileSize:(NSInteger)fileSize;
+(NSString *)fileFindImageWithPathExtension:(NSString *)PathExtension;

//图片保存到沙盒里
//+(void)saveImageToDocument:(UIImage *)image imageName:(NSString *)imagename type:(NSString *)type;
@end
