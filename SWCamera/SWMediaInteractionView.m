//
//  SWMediaInteractionView.m
//  camera
//
//  Created by mac1 on 16/9/8.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "SWMediaInteractionView.h"
#import "SWMediaSeg.h"
#import "SWTimeLabel.h"
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
    BOOL isDropDown;               /*判断按钮是否下拉*/
    
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
}

@property (nonatomic, strong) SWMediaSeg *Seg;
@property (nonatomic, strong) SWTimeLabel *timeLabel;

@end
@implementation SWMediaInteractionView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        isDropDown = NO;
        self.backgroundColor = [UIColor clearColor];
        /*初始化点击手势*/
        [self initializeTap];
        
        /*初始化滑动手势*/
        [self initializeSwipe];
#pragma mark 只需要Vchat的时候，更改的地方
        /*初始化功能分段选择器*/
        [self initializeSWMediaSeg];
#pragma mark end
        /*初始化SWMediaBtn主按钮*/
        [self initializeSWMediaBtn];
        
        /*初始化四个小按钮*/
        [self initializeCustormButtons];
        
        /*初始化显示时间的View*/
        [self initializeTimeView];
        /*Block code*/
        [self blockFunction];
        
    }
    
    
    return self;
    
}
-(void)tap:(UITapGestureRecognizer *)sender{
    NSLog(@"0000  %d",isDropDown);
    SWMediaBtn *button =(SWMediaBtn *)[self viewWithTag:100];
    
    if (button.frame.origin.y < self.frame.size.height ) {
        [UIView animateWithDuration:1.0 animations:^{
            isDropDown = YES;
            _CusBtn1.transform = CGAffineTransformMakeTranslation(0.0, 150.0);
            _CusBtn2.transform = CGAffineTransformMakeTranslation(0.0, 150.0);
            _CusBtn3.transform = CGAffineTransformMakeTranslation(0.0, 150.0);
            _CusBtn4.transform = CGAffineTransformMakeTranslation(0.0, 150.0);
            _Seg.transform = CGAffineTransformMakeTranslation(0.0, 150);
            button.transform = CGAffineTransformMakeTranslation(0.0, 150.0);
            [self.delegate hiddenMaskAndFilterMenu];
        }];
        
    }else{
        
        [UIView animateWithDuration:1.0 animations:^{
            isDropDown = NO;
            
            _CusBtn1.transform = CGAffineTransformIdentity;
            _CusBtn2.transform = CGAffineTransformIdentity;
            _CusBtn3.transform = CGAffineTransformIdentity;
            _CusBtn4.transform = CGAffineTransformIdentity;
            _Seg.transform = CGAffineTransformIdentity;
            button.transform = CGAffineTransformIdentity;
        }];
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touchStart = [touches anyObject];
    gestureStartPiont = [touchStart locationInView:self];
    
}


- (void)initializeSwipe{
    swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeftAction)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    
    
    swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRightAction)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
}

- (void)swipeLeftAction{
    SWMediaBtn *button  =  (SWMediaBtn *)[self viewWithTag:100];
#pragma  mark 主按钮只能在normal状态下滑动
    if (button.state == SWMediaBtnStateNormal) {
#pragma  mark end
        _Seg.type = (_Seg.type == SWCameraTypeGif)?SWCameraTypeCamera:(_Seg.type - 1);
    }
#pragma mark 滑动手势，主按钮动画效果由隐藏复位到原位
    if (isDropDown) {
        [self performSelectorOnMainThread:@selector(tap:) withObject:nil waitUntilDone:NO];
    }
#pragma mark end
}

- (void)swipeRightAction{
    SWMediaBtn *button  =  (SWMediaBtn *)[self viewWithTag:100];
#pragma  mark 主按钮只能在normal状态下滑动
    if (button.state == SWMediaBtnStateNormal) {
#pragma  mark end
        _Seg.type = (_Seg.type == SWCameraTypeCamera)?SWCameraTypeGif:(_Seg.type + 1);
    }
#pragma mark 滑动手势，主按钮动画效果由隐藏复位到原位
    if (isDropDown) {
        [self performSelectorOnMainThread:@selector(tap:) withObject:nil waitUntilDone:NO];
    }
#pragma mark end
}

-(void)initializeTap{
    
    UIView *sub = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - 150)];
    [sub setBackgroundColor: [UIColor clearColor]];
    [self addSubview:sub];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [sub addGestureRecognizer:tap];
    
}
-(void)initializeSWMediaSeg{
    _Seg = [[SWMediaSeg alloc]initWithFrame:self.frame];
    _Seg.tag = 120;
    SegUserIntercation = YES;
    [self addSubview:_Seg];
    
}
-(void)initializeSWMediaBtn{
    SWMediaBtn *Btn = [[SWMediaBtn alloc]initWithFrame:CGRectMake(100.0, 100.0, 60.0, 60.0)];
    Btn.delegate = self;
    Btn.isFirst = YES;
    [Btn setCenter:CGPointMake(self.center.x, self.frame.size.height- 40)];
#pragma mark 只需要Vchat的时候，更改的地方
    //    Btn.type = SWMediaBtnTypeVchat;
    [self.delegate initVchat];
#pragma end
    Btn.state = SWMediaBtnStateNormal;
    Btn.tag = 100;
    [self addSubview:Btn];
    
}
-(void)initializeCustormButtons{
    SWMediaBtn *button =(SWMediaBtn *)[self viewWithTag:100];
    
    x_max = CGRectGetMaxX(button.frame);
    x_min = CGRectGetMinX(button.frame);
    x_mid = CGRectGetMidX(button.frame);
    y_min = CGRectGetMinY(button.frame);
    space = (x_min - SWMediaBtnWidth * 2) / 3.0;
    self.kw_filter = space;
    
    btnImgArray = [[NSArray alloc]initWithObjects:@"vBtnMask",@"btnCameraN",@"btnMute05NCopy",@"btnOkN",@"btnCallNCopy2", nil];
    self.CusBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(15 , y_min, 46, SWMediaBtnWidth)];
    
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
-(void)initializeTimeView{
    SWMediaBtn *button =(SWMediaBtn *)[self viewWithTag:100];
    CGFloat originY = CGRectGetMinY(button.frame) - 25;
    _timeLabel = [[SWTimeLabel alloc]initWithFrame:CGRectMake(0.0, originY, SWMediaBtnWidth + 20.0, 25.0)];
    [self addSubview:_timeLabel];
    //    [_timeLabel startRunningTime];
}
/**
 *第一个小按钮
 */
-(void)CusBtn1:(UIButton *)sender{
    
    SWMediaBtn *button = [self viewWithTag:100];
    button.userInteractionEnabled = (button.type == SWMediaBtnTypeVchat)?NO:YES;
    [self.delegate actionForFirstCustormWithType:button.type andState:button.state];
    button.state =((button.state == SWMediaBtnStatePause)||(button.state ==SWMediaBtnSateSuccessful))&&((button.type == SWMediaBtnTypeVideo)||(button.type == SWMediaBtnTypeGif))?SWMediaBtnStateNormal:button.state;
    
}
/**
 *第二个小按钮
 */
-(void)CusBtn2:(UIButton *)sender{
    if (!sender.selected) {
        [sender setImage:[UIImage imageNamed:@"v_btn_camera_off"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"btnCameraN"] forState:UIControlStateNormal];
    }
    sender.selected =!sender.selected;
    SWMediaBtn *button = [self viewWithTag:100];
    [self.delegate actionForSecondCustorm2WithType:button.type andState:button.state];
}
/**
 *第三个小按钮
 */
-(void)CusBtn3:(UIButton *)sender{
    if (!sender.selected) {
        [sender setImage:[UIImage imageNamed:@"v_btn_voice_small_off"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"btnMute05NCopy"] forState:UIControlStateNormal];
    }
    sender.selected =!sender.selected;
    SWMediaBtn *button = [self viewWithTag:100];
    [self.delegate actionForThirdCustorm3WithType:button.type andState:button.state];
    
}
/**
 *第四个小按钮
 */
-(void)CusBtn4:(UIButton *)sender{
    SWMediaBtn *button = [self viewWithTag:100];
    [self.delegate actionForFourthCustormWithType:button.type andState:button.state];
    button.state = ((button.type ==SWMediaBtnTypeGif)||(button.type == SWMediaBtnTypeVideo)||(button.type == SWMediaBtnTypeVchat))?SWMediaBtnStateNormal:button.state;
    button.userInteractionEnabled = (button.type == SWMediaBtnTypeVchat)?NO:YES;
    _Seg.userInteractionEnabled = YES;
    [_timeLabel endRunningTime];/*保存或者挂断后，定时器归零*/
    [self invitingVchat:NO];
    self.CusBtn2.hidden = YES;
    self.CusBtn3.hidden = YES;
    self.CusBtn4.hidden = YES;
}
/*特定场景，isHidden为YES ，隐藏分段选择器，若isHidden为NO,则显示分段选择器*/
-(void)SWMediaSegHidden:(BOOL) isHidden andUserInteraction:(BOOL)isUserInteraction;{
    SWMediaBtn *button = [self viewWithTag:100];
    button.userInteractionEnabled = isHidden;
    
}
/*第一个小按钮CustormButton的作用为添加滤镜和脸谱时，如果isHidden为YES ,则隐藏主按钮，如果isHidden为NO,则显示主按钮*/
-(void)SWMediaBtnHidden:(BOOL)isHidden{
    SWMediaBtn *button = [self viewWithTag:100];
    button.hidden = isHidden;
}
/*录制Vedio5秒倒计时完成，改变主按钮state     */
-(void)recordingVedio:(BOOL)isWorking{
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~");
    SWMediaBtn *button = [self viewWithTag:100];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        button.userInteractionEnabled = isWorking;
        
        if (button.type == SWMediaBtnTypeVideo) {
            button.state = SWMediaBtnStateSelected;
        }
        
        
    });
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}


- (void)disInterfaceSwap:(BOOL)inviting{
    if(inviting){
        _Seg.userInteractionEnabled = YES;
    }else{
        _Seg.userInteractionEnabled = NO;
    }
}

/*当点击添加人员，进行通话，在拨通状态，SWMediaBtnType不可选*/
-(void)invitingVchat:(BOOL)inviting{
    
    if(inviting){
        NSLog(@"_seg  : %@",_Seg);
        [swipeLeft removeTarget:self action:@selector(swipeLeftAction)];
        [swipeRight removeTarget:self action:@selector(swipeRightAction)];
        self.CusBtn4.hidden = NO;
    }else{
        [swipeRight addTarget:self action:@selector(swipeRightAction)];
        [swipeLeft addTarget:self action:@selector(swipeLeftAction)];
        self.CusBtn4.hidden = YES;
    }
    
    
}
/*
 *Vchat接通，被接收方调用，主按钮Type自动改变为type ，主按钮state自动改变为state
 *如果BOOL值为YES,则被接收方主按钮交互打开，如果BOOL为NO，则被接收方，主按钮交互关闭
 */
-(void)recordingVchatWithSWMediaBtnType:(SWMediaBtnType)type andState:(SWMediaBtnState)state andIsVchating:(BOOL)isVchating{
    SWMediaBtn *button = [self viewWithTag:100];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( button.type != type) {   button.type = type; }
        if (button.state != state) {  button.state = state; }
        
        button.userInteractionEnabled = isVchating;
        _Seg.userInteractionEnabled = !isVchating;
        _Seg.type = 2;
        self.CusBtn2.hidden = !isVchating;
        self.CusBtn3.hidden = !isVchating;
        self.CusBtn4.hidden = !isVchating;
    });
}


#pragma  mark SWMediaBtnDelegate
-(void)actionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state isFirst:(BOOL)isFirst{
    if (type == SWMediaBtnTypeGif || type == SWMediaBtnTypeVideo || type == SWMediaBtnTypeVchat) {
        if (state == SWMediaBtnStateSelected) {
            [_timeLabel startRunningTime];
        }else if (state == SWMediaBtnStatePause || state == SWMediaBtnSateSuccessful){
            [_timeLabel pauseRunningTime];
        }else{
            [_timeLabel endRunningTime];
        }
    }
    [self.delegate finishedActionWithType:type andState:state isFirst:isFirst];
}



#pragma mark Function
/*===================================================================Block Code==========================================================================*/
-(void)blockFunction{
    SWMediaBtn *button = (SWMediaBtn *)[self viewWithTag:100];
    SWMediaSeg *Seg = [self viewWithTag: 120];
    //    button.inCircleLayer.backgroundColor = GifColor.CGColor;
    
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
                    [self invitingVchat:YES];
                    [self.CusBtn1 setImage:[UIImage imageNamed:@"vBtnMask"] forState:UIControlStateNormal];
                    self.CusBtn4.hidden = YES;
                    
                }else if (button.state == SWMediaBtnStatePause){
                    [self invitingVchat:YES];
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
    
    /*=========================================================根据手势滑向，改变主按钮Type======================================*/
    [Seg setChangeType:^(SWCameraType type) {
        button.isFirst = YES;
        switch (type) {
            case 0:
                if (button.type == SWMediaBtnTypeVideo || button.type  == SWMediaBtnTypeVchat || button.type == SWMediaBtnTypeCamera) {
                    button.type = SWMediaBtnTypeGif;
                    [self.delegate initPicture];
                    
                    NSLog(@"选中Gif");
                }
                break;
            case 1:
                [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[3]] forState:UIControlStateNormal];
                if (button.type == SWMediaBtnTypeCamera || button.type  == SWMediaBtnTypeVchat || button.type == SWMediaBtnTypeGif) {
                    button.type = SWMediaBtnTypeVideo;
                    [self.delegate initVideo];//
                    NSLog(@"选中视频");
                }
                
                break;
            case 2:
                [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[4]] forState:UIControlStateNormal];
                if (button.type == SWMediaBtnTypeVideo || button.type  == SWMediaBtnTypeCamera || button.type == SWMediaBtnTypeGif) {
                    button.type = SWMediaBtnTypeVchat;
                    [self.delegate initVchat];//
                    NSLog(@"选中通话");
                }
                break;
            case 3:
                [self.CusBtn4 setImage:[UIImage imageNamed:btnImgArray[3]] forState:UIControlStateNormal];
                if (button.type == SWMediaBtnTypeGif || button.type  == SWMediaBtnTypeVchat || button.type == SWMediaBtnTypeVideo) {
                    button.type = SWMediaBtnTypeCamera;
                    [self.delegate initPicture];
                    NSLog(@"选中拍照");
                }
                break;
            default:
                break;
        }
        
    }];
    
    [_timeLabel setChangeTimeValue:^(CGFloat labeltime) {
        button.progressTime = labeltime;
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
