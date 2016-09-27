//
//  ViewController.h
//  camera
//
//  Created by mac1 on 16/8/24.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "SWMediaBtn.h"
#import "SWTimeLabel.h"
#import "PlayAudio.h"
#define LINEWIDTHRATE 0.12f
#define VideoColor [UIColor colorWithRed:251.0 / 255 green:50.0 / 255  blue:54.0/255 alpha:1]
#define VchatColor [UIColor colorWithRed:83.0 / 255 green:224.0 / 255  blue:209.0/255 alpha:1]
#define GifColor [UIColor colorWithRed:254.0 / 255 green:202.0 / 255  blue:99.0/255 alpha:1]
@interface SWMediaBtn()<CAAnimationDelegate>{
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
        _type = SWMediaBtnTypeGif;/*初始化默认type是gif*/
        _state = SWMediaBtnStateNormal;/*初始化默认state是normal*/
        PauseProgressValue = 0.0; /*初始化视频暂停时，记录进度条的值*/
        
        /*初始化播放器*/
        [self initializeAudio];
        
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
        
    }
    
    return self;
}
-(void)initializeAudio{
    AudioPlayer = [[PlayAudio alloc]init];
}
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
    NSLog(@"self.type : %u   type  ; %u",self.type, type);
    if(_type != type){
        _type =  type;
#pragma mark 禁止视频通话时，按钮直接可点
//        self.userInteractionEnabled = (type == SWMediaBtnTypeVchat)?NO:YES;
        self.userInteractionEnabled = YES;
#pragma mark end
        CGColorRef color = nil;
        color = (type == SWMediaBtnTypeVchat)?(VchatColor.CGColor):color;
        color = (type == SWMediaBtnTypeVideo)?(VideoColor.CGColor):color;
        color = (type == SWMediaBtnTypeGif)?(GifColor.CGColor):color;
        color = (type == SWMediaBtnTypeCamera)?([UIColor whiteColor].CGColor):color;
        animationColor.toValue = (__bridge id)color;
        self.inCircleLayer.backgroundColor = color;
        [self.inCircleLayer addAnimation:animationColor forKey:@"backgroundColor"];
        [self setState:SWMediaBtnStateNormal];
    }
}

/**
 *获取主按钮状态
 */
-(void)setState:(SWMediaBtnState)state{
    _SWMediaPro.hidden = NO;
    if(_state != state){
        _state = state;
        if (self.userInteractionEnabled) {
            [self.delegate actionWithType:self.type andState:self.state isFirst:_isFirst];
        }/*点击第四个按钮时，主按钮state转由selected换为normal而进入此方法，此时根据判断主按钮交互关闭，避免再次调用主按钮响应事件方法*/
        
        switch (self.type) {
            case SWMediaBtnTypeCamera:
                break;
            case SWMediaBtnTypeVideo:
                switch (state) {
                    case SWMediaBtnStateNormal:
                        PauseProgressValue = 0.0;/*进度条暂停存取值 归 0 */
                        VideoProgress = 0.0;/*背景音频进度条  归 0 */
                        [_SWMediaPro drawReset];/*重置进度条*/
                        break;
                        
                    case SWMediaBtnStateSelected:
                        [AudioPlayer play];
                        [self getDurationTimeWith:_state];
                        if (_SWMediaPro.progressEnd <=1.0) { [_SWMediaPro drawBegan];}
                        break;
                    case SWMediaBtnStatePause:
                        [AudioPlayer pause];
                        [self getDurationTimeWith:_state];
                        [_SWMediaPro drawPause];
                        break;
                        
                    case SWMediaBtnSateSuccessful:
                        break;
                    default:
                        break;
                }
                
                break;
            case SWMediaBtnTypeVchat:
                switch (state) {
                    case SWMediaBtnStateSelected :
                        self.userInteractionEnabled = NO;
                        break;
                        
                    default:
                        break;
                }
                break;
            case SWMediaBtnTypeGif:
                
                switch (state) {
                    case SWMediaBtnStateNormal:
                        PauseProgressValue = 0.0;/*进度条暂停存取值 归 0 */
                        VideoProgress = 0.0;/*背景音频进度条  归 0 */
                        [_SWMediaPro drawReset];
                        
                        break;
                    case SWMediaBtnStateSelected:
                        if (_SWMediaPro.progressEnd <=1.0) {[_SWMediaPro drawBegan];}
                        [self getDurationTimeWith:_state];
                        break;
                    case SWMediaBtnStatePause:
                        [self getDurationTimeWith:_state];
                        [_SWMediaPro drawPause];
                        break;
                    case SWMediaBtnSateSuccessful:
                        break;
                        
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        self.clickedBlock(_type, _state);
        [self endAnimations];
    }
    
}

/**主按钮Normal状态的动画效果*/
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

/**主按钮Selected / Paused状态的动画效果*/
-(void)endAnimations{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect bounds = self.inCircleLayer.bounds;
        if (_state == SWMediaBtnStateSelected){
            
            bounds.size.width = self.bounds.size.width*0.5;
            bounds.size.height = self.bounds.size.height*0.5;
            animationBounds.toValue = [NSValue valueWithCGRect:bounds];
            animationRadius.toValue = @(5);
            self.inCircleLayer.cornerRadius = 5.0f;
        }else {
            bounds.size.width = self.frame.size.width-(lineWidth+2)*2;
            bounds.size.height = self.frame.size.height-(lineWidth+2)*2;
            animationBounds.toValue = [NSValue valueWithCGRect:bounds];
            animationRadius.toValue = @(bounds.size.width/2);
            self.inCircleLayer.cornerRadius = bounds.size.width/2;
        }
        self.inCircleLayer.bounds = bounds;
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 1.0;
        group.delegate = self;
        group.removedOnCompletion = YES;
        group.animations = @[animationBounds,animationRadius];
        [self.inCircleLayer addAnimation:group forKey:@"group"];
        
    });
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _inCircleLayer.opacity = (self.userInteractionEnabled)?0.3:1.0;
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
                self.state = SWMediaBtnStateSelected;
                break;
            case SWMediaBtnStateSelected:
                self.state = SWMediaBtnStatePause;
                break;
            case SWMediaBtnStatePause:
                self.state = SWMediaBtnStateSelected;
                break;
            default:
                break;
        }
    }else if (self.type == SWMediaBtnTypeGif){
        switch (_state){
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
        switch (_state) {
            case SWMediaBtnStateNormal:
                
                self.state = SWMediaBtnStateSelected;
                break;
#pragma  mark vchat如果需要多次录制
                //            case SWMediaBtnStateSelected:
                //                self.state = SWMediaBtnSateSuccessful;
                //                break;
                //            case SWMediaBtnSateSuccessful:
                //                self.state = SWMediaBtnStateSelected;
            default:
                break;
        }
        
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
    
    if ([ProgressValue floatValue] <=1.0){  [_SWMediaPro drawMoved];   }
    else{_SWMediaPro.progressEnd = 0.0;}
    
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
-(void)setProgressTime:(CGFloat)progressTime{
    
    if (_progressTime != progressTime) {
        _progressTime = progressTime;
    }
    if (_type == SWMediaBtnTypeGif ) {
        if (GifProgress > 1.0 ||_state == SWMediaBtnSateSuccessful || progressTime >=8.0 || progressTime >= 80.0){
            self.isFirst = YES;
            self.state = SWMediaBtnSateSuccessful;
            self.userInteractionEnabled = NO;
            GifProgress = 0.0;
            
        }
        else if(_state == SWMediaBtnStateSelected) {
            
            [self performSelectorOnMainThread:@selector(GifRun:) withObject:[NSString stringWithFormat:@"%f", GifProgress] waitUntilDone:NO];
            GifProgress += 0.0125;
            PauseProgressValue = GifProgress;
        }else if (_state == SWMediaBtnStatePause){
            
        }
        
    }else if (_type == SWMediaBtnTypeVideo){
        if (VideoProgress > 1.0 || _state == SWMediaBtnSateSuccessful || progressTime >= 80.0) {
            self.isFirst = YES;
            self.state = SWMediaBtnSateSuccessful;
            self.userInteractionEnabled = NO;
            VideoProgress = 0.0;
            
        }else if (_state == SWMediaBtnStateSelected){
            [self performSelectorOnMainThread:@selector(VideoRun:) withObject:[NSString stringWithFormat:@"%f",VideoProgress] waitUntilDone:NO];
            VideoProgress +=0.00125;
            PauseProgressValue = VideoProgress;
        }else if(_state == SWMediaBtnStatePause){
            
        }
        
    }
    
    
}
#pragma  mark 未加显示时间Label，用此方法
-(void)getDurationTimeWith:(SWMediaBtnState )state{
    
    //    time = 0.0000000;
    //    GifProgress = PauseProgressValue;
    //    VideoProgress = PauseProgressValue;
    //    dispatch_source_t Phonetimer;
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    Phonetimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    //
    //    dispatch_source_set_timer(Phonetimer,dispatch_walltime(NULL, 0),0.1* NSEC_PER_SEC, 0); //每0.1秒执行
    //
    //    dispatch_source_set_event_handler(Phonetimer, ^{
    //
    //        if(_state == SWMediaBtnStateNormal){ dispatch_source_cancel(Phonetimer); }
    //        if (_type == SWMediaBtnTypeGif ) {
    //            if (GifProgress > 1.0 ||_state == SWMediaBtnSateSuccessful || time >=8.0){
    //                self.isFirst = YES;
    //                self.state = SWMediaBtnSateSuccessful;
    //                self.userInteractionEnabled = NO;
    //                dispatch_source_cancel(Phonetimer);
    //
    //            }
    //            else if(_state == SWMediaBtnStateSelected) {
    //
    //                [self performSelectorOnMainThread:@selector(GifRun:) withObject:[NSString stringWithFormat:@"%f", GifProgress] waitUntilDone:NO];
    //                GifProgress += 0.0125;
    //                PauseProgressValue = GifProgress;
    //            }else if (_state == SWMediaBtnStatePause){
    //                dispatch_source_cancel(Phonetimer);
    //            }
    //
    //
    //        }else if (_type == SWMediaBtnTypeVideo){
    //            if (VideoProgress > 1.0 || _state == SWMediaBtnSateSuccessful) {
    //                self.isFirst = YES;
    //                self.state = SWMediaBtnSateSuccessful;
    //                self.userInteractionEnabled = NO;
    //                dispatch_source_cancel(Phonetimer);
    //            }else if (_state == SWMediaBtnStateSelected){
    //                [self performSelectorOnMainThread:@selector(VideoRun:) withObject:[NSString stringWithFormat:@"%f",VideoProgress] waitUntilDone:NO];
    //                VideoProgress +=0.0005555555555;
    //                PauseProgressValue = VideoProgress;
    //            }else if(_state == SWMediaBtnStatePause){
    //                dispatch_source_cancel(Phonetimer);
    //            }
    //
    //        }
    //
    //
    //        time += 0.1 ;
    //    });
    //    dispatch_resume(Phonetimer);
    
    
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
