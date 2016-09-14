//
//  SWVideo.m
//  ShiWoFace
//
//  Created by Jason Jiang on 16/8/29.
//  Copyright (c) 2016年 ShiWoFace. All rights reserved.
//

#import "SWVideo.h"

@interface SWVideo ()
{
    NSString *videoVchatPath;
}
@end

@implementation SWVideo
+(instancetype)mainInstance {
    static  SWVideo *video = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        video = [[SWVideo alloc] init];
    });
    return video;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        _videoMaxSeconds = 180;
        _gifMaxSeconds = 8;
        _keyFrames = [NSMutableArray array];
        _movieFilePaths = [NSMutableArray array];
        [self creatVideoVchatPath];
    }
    return self;
}

-(void)creatVideoVchatPath {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //管理文件夹的单例
    NSFileManager *fileManager = [NSFileManager defaultManager];
    videoVchatPath = [cachesPath stringByAppendingPathComponent:@"VideoVchat"];
    if (![fileManager fileExistsAtPath:videoVchatPath]) {
        [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:_videoFileName forKey:@"videoFileName"];
    [aCoder encodeObject:_coverFileName forKey:@"coverFileName"];
    [aCoder encodeObject:_createTime forKey:@"createTime"];
    [aCoder encodeObject:_duration forKey:@"duration"];
    [aCoder encodeObject:_videoFileSize forKey:@"videoFileSize"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_coverSelectedIndex forKey:@"coverSelectedIndex"];
    [aCoder encodeObject:_access forKey:@"access"];
    [aCoder encodeObject:_anonymity forKey:@"anonymity"];
    [aCoder encodeObject:_videoDescription forKey:@"videoDescription"];
    [aCoder encodeObject:_channel forKey:@"channel"];
    
    [aCoder encodeObject:_movieFilePaths forKey:@"movieFilePaths"];
    [aCoder encodeObject:_keyFrames forKey:@"keyFrames"];
    [aCoder encodeObject:_defaultCover forKey:@"defaultCover"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        _videoFileName = [aDecoder decodeObjectForKey:@"videoFileName"];
        _coverFileName =[aDecoder decodeObjectForKey:@"coverFileName"];
        _createTime =[aDecoder decodeObjectForKey:@"createTime"];
        _duration =[aDecoder decodeObjectForKey:@"duration"];
        _videoFileSize =[aDecoder decodeObjectForKey:@"videoFileSize"];
        _location =[aDecoder decodeObjectForKey:@"location"];
        _coverSelectedIndex =[aDecoder decodeObjectForKey:@"coverSelectedIndex"];
        _access =[aDecoder decodeObjectForKey:@"access"];
        _anonymity =[aDecoder decodeObjectForKey:@"anonymity"];
        _videoDescription =[aDecoder decodeObjectForKey:@"videoDescription"];
        _channel =[aDecoder decodeObjectForKey:@"channel"];
        _movieFilePaths = [aDecoder decodeObjectForKey:@"movieFilePaths"];
        _keyFrames = [aDecoder decodeObjectForKey:@"keyFrames"];
        _defaultCover = [aDecoder decodeObjectForKey:@"defaultCover"];
    }
    
    return self;
}
-(void)saveFramePicture:(UIImage *)image {
    [_keyFrames addObject:image];
}
static int VchatCount = 0;
-(void)startVchat {
    VchatCount++;
    NSString *VchatPath = [videoVchatPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mov",VchatCount]];
    [_movieFilePaths addObject:VchatPath];
    NSLog(@"luzhishipin++++++++=%@",_movieFilePaths);
}
- (void)setVideoFilePath:(NSURL *)url {
    if (url && ![[url absoluteString] isEqualToString:@""]) {
        NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"/"];
        _videoFileName = [parts lastObject];
    }
    
}

- (void)setCoverFilePath:(NSURL *)url {
    if (url && ![[url absoluteString] isEqualToString:@""]) {
        NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"/"];
        _coverFileName = [parts lastObject];
    }
}

#pragma mark - Getters
- (NSMutableArray *)movieFilePaths {
    if (!_movieFilePaths) {
        _movieFilePaths = [NSMutableArray array];
    }
    return _movieFilePaths;
}

- (NSMutableArray *)keyFrames {
    if (!_keyFrames) {
        _keyFrames = [NSMutableArray array];
    }
    return _keyFrames;
}

@end
