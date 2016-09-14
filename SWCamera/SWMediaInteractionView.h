//
//  SWMediaInteractionView.h
//  camera
//
//  Created by mac1 on 16/9/8.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMediaBtn.h"
#import "SWMediaSeg.h"
/**
 *(拍照 / 录制视频 / 视频通话 / 录制Gif)初始化API
 */
@protocol SWMediaInteractionDelegate <NSObject>
/**
 *拍照初始化
 */
-(void)initPicture;
/**
 *录制视频初始化
 */
-(void)initVideo;
/**
 *视频通话初始化
 */
-(void)initVchat;
/**
 *录制Gif初始化
 */
-(void)initGif;

/**
 *(拍照 / 视频录制 / 视频通话 / Gif录制)暂停或者完成，
 */
-(void)finishedActionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state isFirst:(BOOL)isFirst;
/**
 *拍摄视频时，倒计5秒后，调用此API，实现主按钮状态切换到Selected  / 通话视频时，通话线路接通，实现主按钮状态切换到Selected ；
 */
-(void)startVideoOrVchatIntercactionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state;
@end



/**
 *四个小按钮实现的代理API
 */
@protocol SWMediaInteractionSourceDelegate <NSObject>
/**
 *第一个小按钮
 */
-(void)actionForFirstCustormWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state;
/**
 *第二个小按钮
 */
-(void)actionForSecondCustorm2WithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state;
/**
 *第三个小按钮
 */
-(void)actionForThirdCustorm3WithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state;
/**
 *第四个小按钮
 */
-(void)actionForFourthCustormWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state;

@end
@interface SWMediaInteractionView : UIView
@property (nonatomic, strong) UIButton *CusBtn1;
@property (nonatomic, strong) UIButton *CusBtn2;
@property (nonatomic, strong) UIButton *CusBtn3;
@property (nonatomic, strong) UIButton *CusBtn4;
@property (nonatomic ,assign) id<SWMediaInteractionDelegate,SWMediaInteractionSourceDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;

/*特定场景，isHidden为YES ，隐藏分段选择器，若isHidden为NO,则显示分段选择器*/
-(void)SWMediaSegHidden:(BOOL) isHidden andUserInteraction:(BOOL)isUserInteraction;

/*第一个小按钮CustormButton的作用为添加滤镜和脸谱时，如果isHidden为YES ,则隐藏主按钮，如果isHidden为NO,则显示主按钮*/
-(void)SWMediaBtnHidden:(BOOL) isHidden;
/*如果isVchating 为YES，则表示视频通话接通，如果isVchating为NO,则表示视频通话断开*/
-(void)VedioOrVchatUserInteraction:(BOOL)isVchating;


/*
 *Vchat接通，被接收方回调，主按钮Type自动改变为type ，主按钮state自动改变为state
 *如果BOOL值为YES,则通知被接收方主按钮交互打开，如果BOOL为NO，则通知被接收方，主按钮交互关闭
 */
-(void)whenVchatingSWMediaBtnType:(SWMediaBtnType)type andState:(SWMediaBtnState)state andItercation:(BOOL)intercation;
@end
