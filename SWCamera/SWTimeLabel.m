//
//  SWTimeLabel.m
//  SWCamera
//
//  Created by mac1 on 16/9/22.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "SWTimeLabel.h"
#define view_bounds ([[UIScreen mainScreen]bounds])
#define view_width  view_bounds.size.width
#define view_height view_bounds.size.height
#define VideoColor [UIColor colorWithRed:251.0 / 255 green:50.0 / 255  blue:54.0/255 alpha:1]
@interface SWTimeLabel(){
    BOOL _timerSwitch;                             /*定时器开关*/
    UILabel *_label;                               /*显示时间*/
}
@property (nonatomic, assign)CGFloat currentTime;      /*gif录制时间，最大值为8秒*/

@end
@implementation SWTimeLabel
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.center = CGPointMake(view_width * 0.5, self.center.y);
        /*initializeTimeLabel*/
        [self initializeTimeLabel];
        
    }
    return self;
}
/*initializeTimeLabel*/
-(void)initializeTimeLabel{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont fontWithName:@"Arial" size:20];
    _label.hidden = YES;
    _label.textColor = VideoColor;
    [self addSubview:_label];
    
}

-(void)setCurrentTime:(CGFloat)currentTime{
    if (_currentTime != currentTime) {
        _currentTime = currentTime;
        self.changeTimeValue(currentTime);
    }
    
}
-(void)startRunningTime{
    
    _timerSwitch = YES;
    [self initializeTimer];
    
}
-(void)pauseRunningTime{
    _timerSwitch = NO;
    
}
-(void)endRunningTime{
    _currentTime = 0.0000000;
    _timerSwitch = NO;
    _label.hidden = YES;
}
-(void)showTimeInLabelWith:(NSString *)hourString and:(NSString *)minutesString and:(NSString *)secondString{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * timeString = [NSString stringWithFormat:@"%@:%@:%@",hourString, minutesString, secondString];
        [_label setText:timeString];
        _label.hidden = NO;
        [_label sizeToFit];
        [_label setCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5)];
    });
}
/*获取的秒，转化00:00:00时间格式*/
-(void)addTime:(NSString *)timeStr{
    
    int hours = floor([timeStr intValue]/3600);
    int minutes = floor(([timeStr intValue]%3600) / 60);
    int secondes = floor(([timeStr intValue ]% 3600) % 60);
    NSString *hoursStr = [NSString stringWithFormat:@"%@",((hours >= 0) && (hours < 10))?[NSString stringWithFormat:@"0%d",hours]:[NSString stringWithFormat:@"%d",hours]];
    NSString *minutesStr = [NSString stringWithFormat:@"%@",((minutes >= 0) && (minutes < 10))?[NSString stringWithFormat:@"0%d",minutes]:[NSString stringWithFormat:@"%d",minutes]];
    NSString *secondesStr = [NSString stringWithFormat:@"%@",((secondes >= 0) && (secondes < 10))?[NSString stringWithFormat:@"0%d",secondes]:[NSString stringWithFormat:@"%d",secondes]];
    
    [self showTimeInLabelWith:hoursStr and: minutesStr and:secondesStr];
    
}
/*初始化计时器*/
-(void)initializeTimer{
    dispatch_source_t runningTimer;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    runningTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(runningTimer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);/*每0.1秒执行一次*/
    dispatch_source_set_event_handler(runningTimer, ^{
        if (_timerSwitch) {
            self.currentTime += 0.1;
        }
        /*如果时间累计超过86400秒（1天）就结束计算时间，并通知自动结束通话*/
        if (_currentTime >= 86400.0 || !_timerSwitch) {
            dispatch_source_cancel(runningTimer);
        }
        [self performSelectorOnMainThread:@selector(addTime:) withObject:[NSString stringWithFormat:@"%f",_currentTime] waitUntilDone:NO];
        
    });
    dispatch_resume(runningTimer);
    
}

@end
