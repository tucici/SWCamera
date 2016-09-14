//
//  PlayAudio.m
//  camera
//
//  Created by mac1 on 16/8/31.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "PlayAudio.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayAudio ()<AVAudioPlayerDelegate>{
    
}

@end
@implementation PlayAudio
-(id)init{
    self = [super init];
    if (self) {
        if (!self.audioPlayer) {
            
        }
    }
    
    
    return self;
    
}
/**
 *播放本地Audio的api
 */
-(BOOL)PlayAudioWith:(NSString *)FileUrl{
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:FileUrl];
    if (!data) {
        NSLog(@"添加本地音乐失败！");
        return NO;
    }
    _audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:&error];
    self.percentage = _audioPlayer.currentTime / _audioPlayer.duration;
    _audioPlayer.numberOfLoops = 0;
    self.audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];//*加载音频文件到缓存*//
    //设置后台播放模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:NO error:nil];
    [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    NSLog(@"播放本地音乐成功");
    return YES;
}
/**
 *   播放
 */
-(void)play{
    if (![self.audioPlayer isPlaying]) {
        
        [self.audioPlayer play];
    }
    
}

/**
 *  暂停播放
 */
-(void)pause{
    if ([self.audioPlayer isPlaying]) {
        
        [self.audioPlayer pause];
        
    }
}
/**
 * 停止
 */
-(void)stop{
    if ([self.audioPlayer isPlaying]) {
        
        [self.audioPlayer stop];
        
    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成");
}

@end
