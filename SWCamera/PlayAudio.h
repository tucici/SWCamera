//
//  PlayAudio.h
//  camera
//
//  Created by mac1 on 16/8/31.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol PlayAudioDelegate<NSObject>
@required
-(void)updataAudioPercentage:(CGFloat)percentage;
@end
@interface PlayAudio : NSObject
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) CGFloat percentage;
@property (nonatomic ,assign) id<PlayAudioDelegate>delegate;
/**
 *播放本地音乐API,返回值为1，表示播放成功，返回值为0，则添加本地音乐失败。
 */
-(BOOL)PlayAudioWith:(NSString *)FileUrl;
-(void)play;
-(void)pause;
-(void)stop;
@end
