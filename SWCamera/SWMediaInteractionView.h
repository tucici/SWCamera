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
 *(拍照 / 视频录制 / 视频通话 / Gif录制)或者暂停，
 */
-(void)finishedActionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state isFirst:(BOOL)isFirst;

/*点击屏幕，隐藏面具滤镜下拉菜单*/
-(void)hiddenMaskAndFilterMenu;

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
@property (nonatomic, assign) CGFloat  kw_filter;
@property (nonatomic, strong) UIButton *CusBtn1;
@property (nonatomic, strong) UIButton *CusBtn2;
@property (nonatomic, strong) UIButton *CusBtn3;
@property (nonatomic, strong) UIButton *CusBtn4;
@property (nonatomic ,assign) id<SWMediaInteractionDelegate,SWMediaInteractionSourceDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;
/*当点击添加人员，进行通话，在拨通状态，SWMediaBtnType不可选*/
-(void)invitingVchat:(BOOL)inviting;

/*第一个小按钮CustormButton的作用为添加滤镜和脸谱时，如果isHidden为YES ,则隐藏主按钮，如果isHidden为NO,则显示主按钮*/
-(void)SWMediaBtnHidden:(BOOL) isHidden;

/*
 *SWMediaBtyType为Video
 isWorking为YES，表示视频倒计时结束，即将录制。isWorking为NO,则表示录制结束*/
-(void)recordingVedio:(BOOL)isWorking;

/*
 * SWMediaBtnType为Vchat ，通话接通和挂断时候，调用此方法，分别打开或者关闭邀请方和接收方主按钮SWMediaBtn交互，从而实现通话进行中，点击主按钮录制的事件。
 *  >邀请方，在通话接通的通知中，调用此方法，传入参数分别为:SWMediaBtnTypeVchat/SWediaBtnStateNormal/YES(NO),
 *      1. 打开接收方主按钮交互(关闭接收方主按钮交互)；
 *      2.同时显示四个小按钮(隐藏画面录制/声音录制/挂断等三个小按钮)；
 *      3.关闭分段选择器交互(打开分段选择器交互)；
 *  >接收方，同上。
 */
-(void)recordingVchatWithSWMediaBtnType:(SWMediaBtnType)type andState:(SWMediaBtnState)state andIsVchating:(BOOL)isVchating;


@end
