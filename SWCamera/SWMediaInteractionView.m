//
//  SWMediaInteractionView.m
//  camera
//
//  Created by mac1 on 16/9/8.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "SWMediaInteractionView.h"
#import "SWMediaSeg.h"
#define GifColor [UIColor colorWithRed:254.0 / 255 green:202.0 / 255  blue:99.0/255 alpha:1]
#define SWMediaBtnWidth 60.0
#define MINDISTANCE 30.0
@interface SWMediaInteractionView ()<SWMediaBtnDelegate>{
    NSArray *btnImgArray;          /*四个小按钮icon数组*/
    CGFloat x_max;                 /*SWMediaBtn主按钮X方向最大值*/
    CGFloat x_min;                 /*SWMediaBtn主按钮X方向最小值*/
    CGFloat x_mid;                 /*SWMediaBtn主按钮X方向中间值*/
    CGFloat y_min;                 /*SWMediaBtn主按钮Y方向最小值*/
    CGFloat space;                 /*四个小按钮间隙距离*/
    CGPoint gestureStartPiont;     /*判断手势滑向的初始点位置*/
    CGFloat time;
    BOOL SegUserIntercation;
}

@property (nonatomic, strong) SWMediaSeg *Seg;
//@property (nonatomic, strong) UIButton *CusBtn1;
//@property (nonatomic, strong) UIButton *CusBtn2;
//@property (nonatomic, strong) UIButton *CusBtn3;
//@property (nonatomic, strong) UIButton *CusBtn4;

@end
@implementation SWMediaInteractionView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    NSLog(@"%f  %f  %f  %f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        /*初始化功能分段选择器*/
        [self InitializeSWMediaSeg];
        
        /*初始化SWMediaBtn主按钮*/
        [self InitializeSWMediaBtn];
        
        /*初始化四个小按钮*/
        [self InitializeCustormButtons];
        
        /*Block code*/
        [self blockFunction];
        
        
    }
    
    
    return self;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touchStart = [touches anyObject];
    gestureStartPiont = [touchStart locationInView:self];
    
    [UIView animateWithDuration:2.0 animations:^{
        _Seg.alpha = 1.0;
        [UIView animateWithDuration:2.0 animations:^{
            _Seg.alpha = 0.0;
        }];
    }];
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touche = [touches anyObject];
    CGPoint currentPoint = [touche locationInView:self];
    CGFloat deltaX = gestureStartPiont.x - currentPoint.x;
    
    SWMediaBtn *button =(SWMediaBtn *)[self viewWithTag:100];
    if (button.state != SWMediaBtnStateNormal) {
        return;
    }
    //向左滑动
    if (deltaX > MINDISTANCE)
        
    {
        NSLog(@">>>>>>>>>>>>>>>向左滑动%d<<<<<<<<<<<<<<<<<<<<<<<",SegUserIntercation);
        if (SegUserIntercation) {
            _Seg.type = (_Seg.type == SWCameraTypeGif)?SWCameraTypeCamera:(_Seg.type - 1);
        }
        
        
    }
    
    //向右滑动
    else if (deltaX < -MINDISTANCE)
        
    {
        NSLog(@">>>>>>>>>>>>>>>向右滑动%d<<<<<<<<<<<<<<<<<<<<<<<",SegUserIntercation);
        if (SegUserIntercation) {
            _Seg.type = (_Seg.type == SWCameraTypeCamera)?SWCameraTypeGif:(_Seg.type + 1);
        }
        
        
    }
}

-(void)InitializeSWMediaSeg{
    _Seg = [[SWMediaSeg alloc]initWithFrame:self.frame];
    _Seg.tag = 120;
    SegUserIntercation = YES;
    [self addSubview:_Seg];
    
    
}
-(void)InitializeSWMediaBtn{
    SWMediaBtn *Btn = [[SWMediaBtn alloc]initWithFrame:CGRectMake(100.0, 100.0, 60.0, 60.0)];
    Btn.delegate = self;
    Btn.isFirst = YES;
    [Btn setCenter:CGPointMake(self.center.x, self.frame.size.height- 40)];
    Btn.state = SWMediaBtnStateNormal;
    Btn.tag = 100;
    [self addSubview:Btn];
    
}
-(void)InitializeCustormButtons{
    SWMediaBtn *button =(SWMediaBtn *)[self viewWithTag:100];
    
    x_max = CGRectGetMaxX(button.frame);
    x_min = CGRectGetMinX(button.frame);
    x_mid = CGRectGetMidX(button.frame);
    y_min = CGRectGetMinY(button.frame) ;
    space = (x_min - SWMediaBtnWidth * 2) / 3;
    
    btnImgArray = [[NSArray alloc]initWithObjects:@"vBtnMask",@"btnCameraN",@"btnMute05NCopy",@"btnOkN",@"btnCallNCopy2", nil];
    self.CusBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(space , y_min, SWMediaBtnWidth, SWMediaBtnWidth)];
    self.CusBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(2*space + SWMediaBtnWidth, y_min, SWMediaBtnWidth, SWMediaBtnWidth)];
    self.CusBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(x_max+space, y_min, SWMediaBtnWidth, SWMediaBtnWidth)];
    self.CusBtn4 = [[UIButton alloc]initWithFrame:CGRectMake(x_max + 2 * space + SWMediaBtnWidth, y_min, SWMediaBtnWidth, SWMediaBtnWidth)];
    
    [self.CusBtn1 setImage:[UIImage imageNamed:btnImgArray[0]] forState:UIControlStateNormal];
    [self.CusBtn2 setImage:[UIImage imageNamed:btnImgArray[1]] forState:UIControlStateNormal];
    [self.CusBtn3 setImage:[UIImage imageNamed:btnImgArray[2]] forState:UIControlStateNormal];
    [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[3]] forState:UIControlStateNormal];
    
    [self.CusBtn1 addTarget:self action:@selector(CusBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [self.CusBtn2 addTarget:self action:@selector(CusBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.CusBtn3 addTarget:self action:@selector(CusBtn3:) forControlEvents:UIControlEventTouchUpInside];
    [self.CusBtn4 addTarget:self action:@selector(CusBtn4:) forControlEvents:UIControlEventTouchUpInside];
    
    self.CusBtn1.hidden = NO;
    self.CusBtn2.hidden = YES;
    self.CusBtn3.hidden = YES;
    self.CusBtn4.hidden = YES;
    
    [self addSubview:self.CusBtn1];
    [self addSubview:self.CusBtn2];
    [self addSubview:self.CusBtn3];
    [self addSubview:self.CusBtn4];
    
    
}

/**
 *第一个小按钮
 */
-(void)CusBtn1:(UIButton *)sender{
    
    SWMediaBtn *button = [self viewWithTag:100];
    button.userInteractionEnabled = YES;
    [self.delegate actionForFirstCustormWithType:button.type andState:button.state];
    button.state =((button.state == SWMediaBtnStatePause)||(button.state ==SWMediaBtnSateSuccessful))&&((button.type == SWMediaBtnTypeVideo)||(button.type == SWMediaBtnTypeGif))?SWMediaBtnStateNormal:button.state;
    
    NSLog(@">>>>>>>>>>>>>>>>点击CusButton>>>>>>>1<<<<<<  %d   ",button.state);
}
/**
 *第二个小按钮
 */
-(void)CusBtn2:(UIButton *)sender{
    
    SWMediaBtn *button = [self viewWithTag:100];
    [self.delegate actionForSecondCustorm2WithType:button.type andState:button.state];
}
/**
 *第三个小按钮
 */
-(void)CusBtn3:(UIButton *)sender{
    SWMediaBtn *button = [self viewWithTag:100];
    [self.delegate actionForThirdCustorm3WithType:button.type andState:button.state];
    NSLog(@">>>>>>>>>>>>>>>>点击CusButton>>>>>>>3<<<<<<  ");
}
/**
 *第四个小按钮
 */
-(void)CusBtn4:(UIButton *)sender{
    NSLog(@">>>>>>>>>>>>>>>>点击CusButton>>>>>>>4<<<<<<  ");
    
    SWMediaBtn *button = [self viewWithTag:100];
    SWMediaSeg *seg = [self viewWithTag:120];
    [self.delegate actionForFourthCustormWithType:button.type andState:button.state];
    button.state = ((button.type ==SWMediaBtnTypeGif)||(button.type == SWMediaBtnTypeVideo)||(button.type == SWMediaBtnTypeVchat))?SWMediaBtnStateNormal:button.state;
    
    seg.userInteractionEnabled = YES;
    button.userInteractionEnabled = YES;
    self.CusBtn2.hidden = YES;
    self.CusBtn3.hidden = YES;
    self.CusBtn4.hidden = YES;
}
/*特定场景，isHidden为YES ，隐藏分段选择器，若isHidden为NO,则显示分段选择器*/
-(void)SWMediaSegHidden:(BOOL) isHidden andUserInteraction:(BOOL)isUserInteraction;{
    _Seg.hidden = isHidden;
    NSLog(@">>>>>>>>>>>>>>>%d<<<<<<<<<<<<<<<<<<<<<<<",isUserInteraction);
    SegUserIntercation = isUserInteraction;
    _Seg.userInteractionEnabled = isUserInteraction;
    
}
/*第一个小按钮CustormButton的作用为添加滤镜和脸谱时，如果isHidden为YES ,则隐藏主按钮，如果isHidden为NO,则显示主按钮*/
-(void)SWMediaBtnHidden:(BOOL)isHidden{
    SWMediaBtn *button = [self viewWithTag:100];
    button.hidden = isHidden;
}
/*录制Vedio5秒倒计时完成 改变主按钮state  /  通话接通  改变主按钮state   */
-(void)VedioOrVchatUserInteraction:(BOOL)isVchating{
    SWMediaBtn *button = [self viewWithTag:100];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        button.userInteractionEnabled = !isVchating;
        
        if (button.type == SWMediaBtnTypeVideo) {
            button.state = SWMediaBtnStateSelected;
        }
        else if (button.type == SWMediaBtnTypeVchat){
            if (isVchating) {
                button.state = SWMediaBtnStateSelected;
            }
            else if (!isVchating){
                button.state = SWMediaBtnStateNormal;
                _Seg.userInteractionEnabled =!isVchating;
            }
        }
        
    });
    
}
/*
 *Vchat接通，被接收方回调，主按钮Type自动改变为type ，主按钮state自动改变为state
 *如果BOOL值为YES,则通知被接收方主按钮交互打开，如果BOOL为NO，则通知被接收方，主按钮交互关闭
 */
-(void)whenVchatingSWMediaBtnType:(SWMediaBtnType)type andState:(SWMediaBtnState)state andItercation:(BOOL)intercation{
    SWMediaBtn *button = [self viewWithTag:100];
    SWMediaSeg *seg = [self viewWithTag:120];
    button.userInteractionEnabled = intercation;
    if (type == SWMediaBtnTypeVchat) {
        if (state == 0) {
            seg.userInteractionEnabled = YES;
            button.userInteractionEnabled = YES;
            self.CusBtn2.hidden = YES;
            self.CusBtn3.hidden = YES;
            self.CusBtn4.hidden = YES;
        }
        
        button.type = type;
        button.state = state;
    }
    
}
#pragma SWMediaBtnDelegate;
-(void)actionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state isFirst:(BOOL)isFirst{
    NSLog(@"type  ;  %d  state : %d    isFirst: %d",type,state,isFirst);
    [self.delegate finishedActionWithType:type andState:state isFirst:isFirst];
}
-(void)startVideoOrVchatActionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state{
    
    [self.delegate startVideoOrVchatIntercactionWithType:type andState:state];
    
}
/*===================================================================Block Code==========================================================================*/
-(void)blockFunction{
    SWMediaBtn *button = (SWMediaBtn *)[self viewWithTag:100];
    SWMediaSeg *Seg = [self viewWithTag: 120];
    button.inCircleLayer.backgroundColor = GifColor.CGColor;
    
    /*======================================主按钮各个类型下，各个状态下，显示四个小按钮CustormButtons======================================*/
    [button setClickedBlock:^(SWMediaBtnType type, SWMediaBtnState state) {
        switch (type) {
            case SWMediaBtnTypeCamera:
                break;
            case SWMediaBtnTypeVideo:
                if (button.state == SWMediaBtnStateNormal) {
                    
                    self.CusBtn4.hidden = YES;
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnMask"] forState:UIControlStateNormal];
                    
                }else if (button.state  == SWMediaBtnStateSelected){
                    
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnMask"] forState:UIControlStateNormal];
                    self.CusBtn4.hidden = YES;
                    
                }else if (button.state == SWMediaBtnStatePause){
                    
                    self.CusBtn4.hidden = NO;
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnCloseface"] forState:UIControlStateNormal];
                    
                }else if (button.state == SWMediaBtnSateSuccessful){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.CusBtn4.hidden = NO;
                        [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnCloseface"] forState:UIControlStateNormal];
                    });
                }
                
                break;
            case SWMediaBtnTypeVchat:
                
                [self.CusBtn4 setImage:[UIImage imageNamed:@"btnCallNCopy2"] forState:UIControlStateNormal];
                self.CusBtn2.hidden = NO;
                self.CusBtn3.hidden = NO;
                self.CusBtn4.hidden = NO;
                
                break;
            case SWMediaBtnTypeGif:
                
                if (button.state == SWMediaBtnStateNormal) {
                    
                    self.CusBtn4.hidden = YES;
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnMask"] forState:UIControlStateNormal];
                    
                }else if (button.state  == SWMediaBtnStateSelected){
                    
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnMask"] forState:UIControlStateNormal];
                    self.CusBtn4.hidden = YES;
                    
                }else if (button.state == SWMediaBtnStatePause){
                    
                    self.CusBtn4.hidden = NO;
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnCloseface"] forState:UIControlStateNormal];
                    
                }else if (button.state == SWMediaBtnSateSuccessful){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@">>>>>>%@",[NSThread currentThread]);
                        self.CusBtn4.hidden = NO;
                        [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnCloseface"] forState:UIControlStateNormal];
                    });
                    
                }
                
                break;
            default:
                break;
        }
        
        Seg.userInteractionEnabled = (button.state == SWMediaBtnStateNormal)?YES:NO;
        
    }];
    
    /*======================================主按钮各个类型下，各个状态下，隐藏四个小按钮CustormButtons======================================*/
    [button setDisClickedBlock:^(SWMediaBtnType type ,SWMediaBtnState state) {
        switch (type) {
            case SWMediaBtnTypeCamera:
                
                break;
            case SWMediaBtnTypeVideo:
                self.CusBtn4.hidden = NO;
                
                break;
            case SWMediaBtnTypeVchat:
                
                [self.CusBtn4 setImage:[UIImage imageNamed:@"btnCallNCopy2"] forState:UIControlStateNormal];
                self.CusBtn2.hidden = NO;
                self.CusBtn3.hidden = NO;
                self.CusBtn4.hidden = NO;
                
                break;
            case SWMediaBtnTypeGif:
                
                self.CusBtn4.hidden = NO;
                
                break;
            default:
                break;
        }
        
        Seg.userInteractionEnabled = (state == SWMediaBtnStateNormal)?YES:NO;;
    }];
    
    /*=========================================================根据手势滑向，改变主按钮Type======================================*/
    [Seg setChangeType:^(SWCameraType type) {
        button.isFirst = YES;
        switch (type) {
            case 0:
                if (button.type == SWMediaBtnTypeVideo || button.type  == SWMediaBtnTypeVchat || button.type == SWMediaBtnTypeCamera) {
                    
                    [self.delegate initPicture];
                    button.type = SWMediaBtnTypeGif;
                    
                    NSLog(@"选中Gif");
                }
                break;
            case 1:
                [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[3]] forState:UIControlStateNormal];
                if (button.type == SWMediaBtnTypeCamera || button.type  == SWMediaBtnTypeVchat || button.type == SWMediaBtnTypeGif) {
                    [self.delegate initVideo];
                    button.type = SWMediaBtnTypeVideo;
                    NSLog(@"选中视频");
                }
                
                break;
            case 2:
                [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[4]] forState:UIControlStateNormal];
                if (button.type == SWMediaBtnTypeVideo || button.type  == SWMediaBtnTypeCamera || button.type == SWMediaBtnTypeGif) {
                    [self.delegate initVchat];
                    button.type = SWMediaBtnTypeVchat;
                    NSLog(@"选中通话");
                }
                break;
            case 3:
                [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[3]] forState:UIControlStateNormal];
                if (button.type == SWMediaBtnTypeGif || button.type  == SWMediaBtnTypeVchat || button.type == SWMediaBtnTypeVideo) {
                    [self.delegate initPicture];
                    button.type = SWMediaBtnTypeCamera;
                    NSLog(@"选中拍照");
                }
                break;
            default:
                break;
        }
        
    }];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
