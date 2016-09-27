//
//  ViewController.h
//  camera
//
//  Created by mac1 on 16/8/24.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMediaPro.h"
/**
 *主按钮类型
 */
typedef enum {
    SWMediaBtnTypeGif, //录制gif
    SWMediaBtnTypeVideo, //视频
    SWMediaBtnTypeVchat,//通话
    SWMediaBtnTypeCamera // 相机
}SWMediaBtnType;

/**
 *主按钮状态
 */
typedef enum {
    SWMediaBtnStateNormal,
    SWMediaBtnStateSelected,
    SWMediaBtnStatePause,
    SWMediaBtnSateSuccessful
}SWMediaBtnState;

/**
 *调用主按钮的代理API
 */
@protocol SWMediaBtnDelegate<NSObject>
@required

/**
 *点下主按钮，响应后做的工作（拍照 / 视频录制 / 视频通话 / Gif录制）
 */
-(void)actionWithType:(SWMediaBtnType)type  andState:(SWMediaBtnState)state isFirst:(BOOL)isFirst;

@end
@class SWMediaBtn;
typedef  void(^ClickedBlock)(SWMediaBtn *button);
@interface SWMediaBtn : UIView
@property (nonatomic ,assign) CGFloat progressTime;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) CAShapeLayer *inCircleLayer;  //内框
@property (nonatomic, strong)SWMediaPro *SWMediaPro;//进度条
@property (nonatomic, assign) SWMediaBtnType type;
@property (nonatomic, assign) SWMediaBtnState state;
@property (nonatomic, assign) id<SWMediaBtnDelegate>delegate;
@property (nonatomic, strong) void (^clickedBlock)(SWMediaBtnType type, SWMediaBtnState state);


@end
