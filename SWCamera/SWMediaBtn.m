//
//  ViewController.h
//  camera
//
//  Created by mac1 on 16/8/24.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "SWMediaBtn.h"
#import "PlayAudio.h"
#import "SWVideo.h"
#define LINEWIDTHRATE 0.12f
#define VideoColor [UIColor colorWithRed:251.0 / 255 green:50.0 / 255  blue:54.0/255 alpha:1]
#define VchatColor [UIColor colorWithRed:83.0 / 255 green:224.0 / 255  blue:209.0/255 alpha:1]
#define GifColor [UIColor colorWithRed:254.0 / 255 green:202.0 / 255  blue:99.0/255 alpha:1]
@interface SWMediaBtn(){
    /*动画组*/
    CABasicAnimation *animationColor;
    CABasicAnimation *animationRadius;
    CABasicAnimation *animationBounds;
    CABasicAnimation *animationZoomIn;
    
    CGFloat lineWidth;
    
    /*音频播放器*/
    PlayAudio* AudioPlayer;
    CGFloat  time ;
    CGFloat GifProgress ;
    double PauseProgressValue;
    double VideoProgress ;
    
}

@property (nonatomic, strong) NSString * VchatTime;
@property (nonatomic, strong) UILabel* TimeLabel;
@end
@implementation SWMediaBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor: [UIColor clearColor]];
        self.state = SWMediaBtnTypeGif;
        /*初始化视频暂停时，记录进度条的值*/
        PauseProgressValue = 0.0;
        
        /*初始化播放器*/
        AudioPlayer = [[PlayAudio alloc]init];
        
        /*初始化环形进度条*/
        _SWMediaPro  = [[SWMediaPro alloc]initWithFrame:self.frame];
        _SWMediaPro.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);
        _SWMediaPro.progressEnd = 0;
        _SWMediaPro.drawColor = [UIColor redColor];
        _SWMediaPro.pauseColor = [UIColor whiteColor];
        [self addSubview:_SWMediaPro];
        
        
        /*初始化主按钮内圆渲染效果*/
        self.inCircleLayer = [CAShapeLayer layer];
        lineWidth = frame.size.width*LINEWIDTHRATE;
        CGFloat radius_inCircle = frame.size.width-(lineWidth+2)*2;
        _inCircleLayer.frame = CGRectMake(lineWidth+2, lineWidth+2, radius_inCircle, radius_inCircle);
        _inCircleLayer.cornerRadius = _inCircleLayer.frame.size.width/ 2;
        _inCircleLayer.backgroundColor = GifColor.CGColor;
        [self.layer addSublayer:_inCircleLayer];
        
        /*初始化动画效果*/
        [self startAnimations];
        /*Vchat时间*/
        //        _TimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width , frame.size.height)];
        //        _TimeLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);
        //        _TimeLabel.font = [UIFont fontWithName:@"Arial" size:12];
        //        _TimeLabel.textAlignment = NSTextAlignmentCenter;
        //        _TimeLabel.textColor = [UIColor blackColor];
        //        _TimeLabel.hidden = YES;
        //        [self addSubview:_TimeLabel];
        
        _type = SWMediaBtnTypeGif;
        _state = SWMediaBtnStateNormal;
        
        
    }
    
    return self;
}
/**
 *获取Vchat时间
 */
//-(void)setVchatTime:(NSString *) VchatTime{
//
//    _VchatTime = VchatTime;
//    int hours = floor([VchatTime intValue]/3600);
//    int minutes = floor(([VchatTime intValue]%3600) / 60);
//    int secondes = floor(([VchatTime intValue ]% 3600) % 60);
//    NSString *hoursStr = [NSString stringWithFormat:@"%@",((hours >= 0) && (hours < 10))?[NSString stringWithFormat:@"0%d",hours]:[NSString stringWithFormat:@"%d",hours]];
//    NSString *minutesStr = [NSString stringWithFormat:@"%@",((minutes >= 0) && (minutes < 10))?[NSString stringWithFormat:@"0%d",minutes]:[NSString stringWithFormat:@"%d",minutes]];
//    NSString *secondesStr = [NSString stringWithFormat:@"%@",((secondes >= 0) && (secondes < 10))?[NSString stringWithFormat:@"0%d",secondes]:[NSString stringWithFormat:@"%d",secondes]];
//    [_TimeLabel setText:[NSString stringWithFormat:@"%@:%@:%@", hoursStr, minutesStr, secondesStr]];
//
//}
/**
 *是否是第一次触发主按钮
 */
-(void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
}
/**
 *获取主按钮类型
 */
-(void)setType:(SWMediaBtnType)type{
    
    if(_type != type){
        _type =  type;
        if (type == SWMediaBtnTypeVchat) {
            
            animationColor.toValue = (id)VchatColor.CGColor;
            self.inCircleLayer.backgroundColor = VchatColor.CGColor;
            [self.inCircleLayer addAnimation:animationColor forKey:@"backgroundColor"];
            
        }else if (type == SWMediaBtnTypeVideo){
            animationColor.toValue = (id)VideoColor.CGColor;
            self.inCircleLayer.backgroundColor = VideoColor.CGColor;
            [self.inCircleLayer addAnimation:animationColor forKey:@"backgroundColor"];
            
        }else if (type == SWMediaBtnTypeGif){
            animationColor.toValue = (id)GifColor.CGColor;
            self.inCircleLayer.backgroundColor = GifColor.CGColor;
            [self.inCircleLayer addAnimation:animationColor forKey:@"backgroundColor"];
            
        }else if (type == SWMediaBtnTypeCamera){
            animationColor.toValue = (id)[UIColor whiteColor].CGColor;
            self.inCircleLayer.backgroundColor = [UIColor whiteColor].CGColor;
            [self.inCircleLayer addAnimation:animationColor forKey:@"backgroundColor"];
            
        }
        
        [self.inCircleLayer removeAllAnimations];
        [self setState:SWMediaBtnStateNormal];
    }
}
/**
 *获取主按钮状态
 */
-(void)setState:(SWMediaBtnState)state{
    self.userInteractionEnabled = YES;
    _SWMediaPro.hidden = NO;
    _TimeLabel.hidden = YES;
    
    if(_state != state){
        _state = state;
        
        switch (self.type) {
                
            case SWMediaBtnTypeCamera:
                break;
            case SWMediaBtnTypeVideo:
                
                switch (state) {
                    case SWMediaBtnStateNormal:
                        
                        /*切换到视频录制，准备录制状态，实现录制初始化画面的代理*/
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        [AudioPlayer stop];/*播放背景音频*/
                        PauseProgressValue = 0.0;/*进度条暂停存取值 归 0 */
                        VideoProgress = 0.0;/*背景音频进度条  归 0 */
                        [_SWMediaPro drawReset];/*充值进度条*/
                        [self endAnimations];
                        self.clickedBlock(self.type, state);
                        break;
                        
                    case SWMediaBtnStateSelected:
                        /*切换到视频录制，已经录制状态，实现实时录制的代理*/
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        [AudioPlayer play];
                        [self getDurationTimeWith:_state];
                        
                        if (_SWMediaPro.progressEnd <=1.0) {
                            [_SWMediaPro drawBegan];
                        }
                        [self endAnimations];
                        self.clickedBlock(self.type, state);
                        
                        break;
                    case SWMediaBtnStatePause:
                        /*切换到视频录制，录制暂停状态，实现录制暂停的代理*/
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        
                        [self endAnimations];
                        
                        self.clickedBlock (self.type,self.state);
                        [AudioPlayer pause];
                        [self getDurationTimeWith:_state];
                        [_SWMediaPro drawPause];
                        
                        break;
                        
                    case SWMediaBtnSateSuccessful:
                        /*切换到GifType，已完成录制，实现完成录制代理*/
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        [self endAnimations];
                        self.clickedBlock(self.type, self.state);
                        break;
                    default:
                        break;
                }
                
                break;
            case SWMediaBtnTypeVchat:
                switch (state) {
                    case SWMediaBtnStateNormal:
                        [self endAnimations];
                        break;
                    case SWMediaBtnStateSelected:
                        /*切换到视频通话，已经在通话中的状态，实现通话内容的代理*/
                        [self endAnimations];
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        
                        //                        [self getDurationTimeWith:self.state];
                        //                        _TimeLabel.hidden = NO;
                        
                        self.clickedBlock(self.type, state);
                        
                        break;
                        
                    default:
                        break;
                }
                break;
            case SWMediaBtnTypeGif:
                
                switch (state) {
                    case SWMediaBtnStateNormal:
                        /*切换到GifType，准备录制状态，实现Gif录制初始化画面的代理*/
                        PauseProgressValue = 0.0;/*进度条暂停存取值 归 0 */
                        VideoProgress = 0.0;/*背景音频进度条  归 0 */
                        [_SWMediaPro drawReset];
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        
                        [self endAnimations];
                        self.clickedBlock(self.type, state);
                        
                        break;
                    case SWMediaBtnStateSelected:
                        /*切换到GifType，已经录制状态，实现Gif录制内容的代理*/
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        if (_SWMediaPro.progressEnd <=1.0) {
                            [_SWMediaPro drawBegan];
                        }
                        [self getDurationTimeWith:_state];
                        [self endAnimations];
                        self.clickedBlock (self.type, self.state);
                        break;
                    case SWMediaBtnStatePause:
                        /*切换到GifType，处于暂停状态，实现录制暂停代理*/
                        [self getDurationTimeWith:_state];
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        [self endAnimations];
                        [_SWMediaPro drawPause];
                        self.clickedBlock (self.type,self.state);
                        //                        [_SWMediaPro drawPause];
                        break;
                    case SWMediaBtnSateSuccessful:
                        /*切换到GifType，已完成录制，实现完成录制代理*/
                        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
                        [self endAnimations];
                        self.clickedBlock(self.type, self.state);
                        break;
                        
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        
        
    }
    
}
/**
 *主按钮Normal状态的动画效果
 */
-(void)startAnimations{
    
    animationColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animationColor.duration = 0.3f;
    animationColor.fromValue = (id)self.inCircleLayer.backgroundColor;
    
    animationRadius = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animationBounds  = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animationRadius.duration = animationBounds.duration = 0.2f;
    animationRadius.fromValue = @(self.inCircleLayer.cornerRadius);
    animationBounds.fromValue = [NSValue valueWithCGRect:self.inCircleLayer.bounds];
    
    
    animationZoomIn= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationZoomIn.duration = 0.2f;
    animationZoomIn.autoreverses = NO;
    animationZoomIn.repeatCount = 1;
    animationZoomIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationZoomIn.autoreverses = YES;
    
    
}
/**
 *主按钮Selected / Paused状态的动画效果
 */

-(void)endAnimations{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        CGRect bounds = self.inCircleLayer.bounds;
        if (_state == SWMediaBtnStateNormal) {
            animationRadius.toValue = @(5);
            
            bounds.size.width = self.frame.size.width-(lineWidth+2)*2;
            bounds.size.height = self.frame.size.height-(lineWidth+2)*2;
            animationBounds.toValue = [NSValue valueWithCGRect:bounds];
            animationRadius.toValue = @(bounds.size.width/2);
            self.inCircleLayer.cornerRadius = bounds.size.width/2;
            self.inCircleLayer.bounds = bounds;
        }else if (_state == SWMediaBtnStateSelected){
            
            animationRadius.toValue = @(5);
            bounds.size.width = self.bounds.size.width*0.5;
            bounds.size.height = self.bounds.size.height*0.5;
            animationBounds.toValue = [NSValue valueWithCGRect:bounds];
            self.inCircleLayer.cornerRadius = 5.0f;
            self.inCircleLayer.bounds = bounds;
        }else if (_state == SWMediaBtnStatePause){
            bounds.size.width = self.frame.size.width-(lineWidth+2)*2;
            bounds.size.height = self.frame.size.height-(lineWidth+2)*2;
            animationBounds.toValue = [NSValue valueWithCGRect:bounds];
            animationRadius.toValue = @(bounds.size.width/2);
            self.inCircleLayer.cornerRadius = bounds.size.width/2;
            self.inCircleLayer.bounds = bounds;
            
        }else if (_state == SWMediaBtnSateSuccessful){
            bounds.size.width = self.frame.size.width-(lineWidth+2)*2;
            bounds.size.height = self.frame.size.height-(lineWidth+2)*2;
            animationBounds.toValue = [NSValue valueWithCGRect:bounds];
            animationRadius.toValue = @(bounds.size.width/2);
            self.inCircleLayer.cornerRadius = bounds.size.width/2;
            self.inCircleLayer.bounds = bounds;
            
        }
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 3;
        group.delegate = self;
        group.removedOnCompletion = YES;
        group.animations = @[animationBounds,animationRadius];
        [self.inCircleLayer addAnimation:group forKey:@"group"];
    });
    
}
-(void)actionOnState{}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _inCircleLayer.opacity = 0.3;
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
/**
 *主按钮触摸响应事件
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _inCircleLayer.opacity = 1.0;
    
    if(self.type==SWMediaBtnTypeVideo){
        switch (_state) {
            case SWMediaBtnStateNormal:
                self.userInteractionEnabled = NO;
                [self.delegate startVideoOrVchatActionWithType:_type andState:_state];
                
                break;
            case SWMediaBtnStateSelected:
                self.state =SWMediaBtnStatePause;
                break;
            case SWMediaBtnStatePause:
                self.state = SWMediaBtnStateSelected;
                break;
            default:
                break;
        }
        
    }else if (self.type == SWMediaBtnTypeGif){
        switch (_state) {
            case SWMediaBtnStateNormal:
                self.state = SWMediaBtnStateSelected;
                break;
            case SWMediaBtnStateSelected:
                self.state =SWMediaBtnStatePause;
                break;
            case SWMediaBtnStatePause:
                
                self.state = SWMediaBtnStateSelected;
                break;
            default:
                break;
        }
    }else if (self.type == SWMediaBtnTypeVchat){
        self.userInteractionEnabled = NO;
        [self.delegate startVideoOrVchatActionWithType:_type andState:_state];
        
    }else if(self.type == SWMediaBtnTypeCamera){
        
        animationZoomIn.toValue = [NSNumber numberWithFloat:1.3];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 0.2;
        group.animations = @[animationZoomIn];
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeRemoved;
        [self.inCircleLayer addAnimation:group forKey:nil];
        
        /*此方法的代理方 需要实现拍照事件*/
        [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
    }
}
/**
 *录制Gif，进度条跟随
 */
-(void)GifRun:(NSString *)ProgressValue{
    
    [_SWMediaPro setDrawColor:GifColor];
    _SWMediaPro.progressEnd = [ProgressValue floatValue];
    
    if ([ProgressValue floatValue] <=1.0) {
        [_SWMediaPro drawMoved];
        
    }else{
        _SWMediaPro.progressEnd = 0.0;
        
    }
    
}
/**
 *录制视频,进度条跟随
 */
-(void)VideoRun:(NSString *)ProgressValue{
    
    [_SWMediaPro setDrawColor:VideoColor];
    _SWMediaPro.progressEnd = [ProgressValue floatValue];
    
    if (_SWMediaPro.progressEnd <=1.0) {
        [_SWMediaPro drawMoved];
    }else{
        
        _SWMediaPro.progressEnd = 0.0;
        self.state = (_type == SWMediaBtnTypeVideo)?SWMediaBtnStatePause:SWMediaBtnStateNormal;
        
    }
    
    
}
-(void)VideoPause:(NSString *)VideoProgress{
    
}
-(void)getDurationTimeWith:(SWMediaBtnState )state{
    
    time = 0.0000000;
    GifProgress = PauseProgressValue;
    VideoProgress = PauseProgressValue;
    dispatch_source_t Phonetimer;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    Phonetimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(Phonetimer,dispatch_walltime(NULL, 0),0.1* NSEC_PER_SEC, 0); //每0.1秒执行
    
    dispatch_source_set_event_handler(Phonetimer, ^{
        
        if(_state == SWMediaBtnStateNormal){
            dispatch_source_cancel(Phonetimer);
        }
        if (_type == SWMediaBtnTypeGif ) {
            if (GifProgress > 1.0 ||_state == SWMediaBtnSateSuccessful || time >=8.0){
                //                [_SWMediaPro drawEnded];
                self.isFirst = YES;
                self.state = SWMediaBtnSateSuccessful;
                self.userInteractionEnabled = NO;
                dispatch_source_cancel(Phonetimer);
                
                
            }
            else if(_state == SWMediaBtnStateSelected) {
                [self performSelectorOnMainThread:@selector(GifRun:) withObject:[NSString stringWithFormat:@"%f", GifProgress] waitUntilDone:NO];
                GifProgress += 0.0125;
                PauseProgressValue = GifProgress;
            }else if (_state == SWMediaBtnStatePause){
                dispatch_source_cancel(Phonetimer);
                
            }
            
            
        }else if (_type == SWMediaBtnTypeVideo){
            if (VideoProgress > 1.0 || _state == SWMediaBtnSateSuccessful) {
                self.isFirst = YES;
                self.state = SWMediaBtnSateSuccessful;
                self.userInteractionEnabled = NO;
                dispatch_source_cancel(Phonetimer);
            }else if (_state == SWMediaBtnStateSelected){
                [self performSelectorOnMainThread:@selector(VideoRun:) withObject:[NSString stringWithFormat:@"%f",VideoProgress] waitUntilDone:NO];
                VideoProgress +=0.0005555555555;
                PauseProgressValue = VideoProgress;
            }else if(_state == SWMediaBtnStatePause){
                dispatch_source_cancel(Phonetimer);
            }
            
        }
        /*获取Vchat时间*/
        //        [self performSelectorOnMainThread:@selector(setVchatTime:) withObject:[NSString stringWithFormat:@"%f", time] waitUntilDone:NO];
        
        time += 0.1 ;
    });
    dispatch_resume(Phonetimer);
    
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
