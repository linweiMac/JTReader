//
//  FilePathHelper.m
//  信云课堂
//
//  Created by apple on 14-6-6.
//  Copyright (c) 2014年 besttone. All rights reserved.
//

#import "FilePathHelper.h"

#define kDocumentFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation FilePathHelper


+(BOOL)fileIsExistsAtPath:(NSString *)path
{
    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)cacheFilePath:(NSString *)path
{
    NSString *recordDir = [kDocumentFolder stringByAppendingPathComponent:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:recordDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return recordDir;
}

+ (NSString *)cacheFilePath:(NSString *)path fileName:(NSString *)fileName
{
    NSString *fileDir = [kDocumentFolder stringByAppendingPathComponent:path];

    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    fileDir = [fileDir stringByAppendingPathComponent:fileName];
    
    return fileDir;
}

+(void)cafToMp3:(NSString *)cafPath withMp3:(NSString *)mp3Path
{
    NSString *cafFilePath = cafPath;
    NSString *mp3FilePath = mp3Path;
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
}


+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

+ (NSString *)updateTimeString:(NSDate *)lastUpdateTime
{
    if (!lastUpdateTime) return @"";
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day] && [cmp1 year] == [cmp2 year] &&[cmp1 month] == [cmp2 month]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
        return [formatter stringFromDate:lastUpdateTime];
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"HH:mm";
        NSString *time = [formatter stringFromDate:lastUpdateTime];
        NSUInteger month= [cmp1 month];
        NSUInteger day= [cmp1 day];
        return [NSString stringWithFormat:@"%ld/%ld %@",month,day,time];
        
    } else {
        formatter.dateFormat = @"HH:mm";
        NSString *time = [formatter stringFromDate:lastUpdateTime];
        NSUInteger month= [cmp1 month];
        NSUInteger day= [cmp1 day];
        NSUInteger year= [cmp1 year];
        return [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,time];

    }
}


+(NSString *)getFileSize:(NSInteger)fileSize
{
    NSString *size;
    size = @"";
    long GB = 1024*1024*1024;
    long MB = 1024*1024;
    long KB = 1024;
    
    if (fileSize>=GB) {
        float fileSizeTemp = (float)fileSize *1.00;
        float aa =fileSizeTemp/GB;
        size = [NSString stringWithFormat:@"%0.2fGB",aa];
    }else if (fileSize>=MB) {
        float fileSizeTemp = (float)fileSize *1.00;
        float aa =fileSizeTemp/MB;
        size = [NSString stringWithFormat:@"%0.2fMB",aa];
    }else if (fileSize>=KB) {
        float fileSizeTemp = (float)fileSize *1.00;
        float aa =fileSizeTemp/KB;
        size = [NSString stringWithFormat:@"%0.2fKB",aa];
    }
    return size;
}


+(NSString *)fileFindImageWithPathExtension:(NSString *)PathExtension
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    [arr addObject:@[@"avi"]];
    [arr addObject:@[@"doc",@"docx"]];
    [arr addObject:@[@"ppt",@"pptx"]];
    [arr addObject:@[@"xls",@"xlsx"]];
    [arr addObject:@[@"pdf"]];
    [arr addObject:@[@"mov"]];
    [arr addObject:@[@"mp3"]];
    [arr addObject:@[@"mp4"]];
    [arr addObject:@[@"wav"]];
    [arr addObject:@[@"txt"]];
    [arr addObject:@[@"rtf"]];
    [arr addObject:@[@"jpg",@"jpeg"]];
    [arr addObject:@[@"png"]];
    
    for (int i=0; i<arr.count; i++) {
        NSArray *temp = [arr objectAtIndex:i];
        
        if (temp.count==1) {
            if ([PathExtension isEqualToString:[temp objectAtIndex:0]] ) {
                return PathExtension;
            }
        }else if (temp.count==2) {
            if ([PathExtension isEqualToString:[temp objectAtIndex:0]] ||[PathExtension isEqualToString:[temp objectAtIndex:1]]) {
                return PathExtension;
            }
        }
    }
    
    return @"notFile";
}


//图片保存到沙盒里
//+(void)saveImageToDocument:(UIImage *)image imageName:(NSString *)imagename type:(NSString *)type
//{
//    NSString *filePath = [FilePathHelper cacheFilePath:type fileName:imagename];  // 保存文件的名称
//    [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES];
//}

@end
