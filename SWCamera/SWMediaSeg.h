//
//  SWMediaSeg.h
//  VideoText
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SWMediaSegWidth [[UIScreen mainScreen]bounds].size.width
#define KW(R) R*(SWMediaSegWidth)/375
#define SWMediaSegHeight 50.0

typedef NS_ENUM(NSInteger, SWCameraType) {
    SWCameraTypeGif,//录制gif
    SWCameraTypeVideo, //视频
    SWCameraTypeVchat,//通话
    SWCameraTypeCamera, // 相机
};
@protocol SWMediaSegDelegate <NSObject>
-(void)changeType:(SWCameraType)type;


@end
@interface SWMediaSeg : UIView


@property (nonatomic, strong) id<SWMediaSegDelegate>delegate;
@property (nonatomic,strong) void (^changeType)(SWCameraType  Type);
@property (nonatomic, assign) SWCameraType type;
-(void)changeCameraCaptureType:(SWCameraType)type;
@end
