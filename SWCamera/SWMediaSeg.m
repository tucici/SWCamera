//
//  SWMediaSeg.m
//  VideoText
//
//  Created by mac1 on 16/7/5.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "SWMediaSeg.h"



@interface SWMediaSeg ()
{
    UILabel *gifLable;
    UILabel *videoLable;
    UILabel *chatLable;
    UILabel *picLable;
    
    NSTimer *timeRemoveView;
    NSInteger time;
    NSInteger dismissTime;
}
@end
@implementation SWMediaSeg


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0.0, 100.0, SWMediaSegWidth, SWMediaSegHeight)];
    
    if (self) {
        [self setCenter:CGPointMake(frame.size.width / 2, frame.size.height - 100)];
        
        [self creatSelectView];
        
        gifLable.textColor = [UIColor yellowColor];
    }
    return self;
}



- (void)creatSelectView
{
    
    time = 0;
    dismissTime = 10;
    
    UIView * black = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, KW(SWMediaSegWidth * 3.0 / 4.0), 30)];
    black.center = CGPointMake(self.center.x, black.center.y);
    black.backgroundColor = [UIColor blackColor];
    black.alpha = 0.5;
    black.layer.cornerRadius = 10;
    [self addSubview:black];
    
    
    CGFloat deltaX = KW(SWMediaSegWidth * 3.0 / 4.0) / 4.0;
    gifLable = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, deltaX - 20.0, 30)];
    gifLable.font = [UIFont systemFontOfSize:13];
    gifLable.text = @"Gif";
    gifLable.textColor = [UIColor whiteColor];
    gifLable.textAlignment = NSTextAlignmentCenter;
    [black addSubview:gifLable];
    
    videoLable = [[UILabel alloc]initWithFrame:CGRectMake(deltaX, 0, deltaX, 30)];
    videoLable.font = [UIFont systemFontOfSize:13];
    videoLable.textAlignment = NSTextAlignmentCenter;
    videoLable.text = @"Video";
    videoLable.textColor = [UIColor whiteColor];
    [black addSubview:videoLable];
    
    chatLable = [[UILabel alloc]initWithFrame:CGRectMake(2 * deltaX, 0, deltaX, 30)];
    chatLable.font = [UIFont systemFontOfSize:13];
    chatLable.textAlignment = NSTextAlignmentCenter;
    chatLable.text = @"Call";
    chatLable.textColor = [UIColor whiteColor];
    [black addSubview:chatLable];
    
    picLable = [[UILabel alloc]initWithFrame:CGRectMake(3 * deltaX, 0, deltaX, 30)];
    picLable.font = [UIFont systemFontOfSize:13];
    picLable.textAlignment = NSTextAlignmentCenter;
    picLable.text = @"Photo";
    picLable.textColor = [UIColor whiteColor];
    [black addSubview:picLable];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0.0;
    }];
}




- (void)setType:(SWCameraType)Type
{
    self.alpha = 1;
    [self timeout];
    _type = Type;
    
    self.changeType(self.type);
    //    [self.delegate changeType:_type];
    gifLable.textColor = [UIColor whiteColor];
    videoLable.textColor = [UIColor whiteColor];
    chatLable.textColor = [UIColor whiteColor];
    picLable.textColor = [UIColor whiteColor];
    
    
    if (Type == 0) {
        gifLable.textColor = [UIColor yellowColor];
        
    }else if (Type == 1)
    {
        videoLable.textColor = [UIColor yellowColor];
    }else if (Type == 2)
    {
        chatLable.textColor = [UIColor yellowColor];
    }else
    {
        picLable.textColor = [UIColor yellowColor];
    }
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 0.0;
    }];
    
}
-(void)changeCameraCaptureType:(SWCameraType)type{
    switch (type) {
        case SWCameraTypeCamera:
            [self setType:SWCameraTypeCamera];
            break;
        case SWCameraTypeVideo:
            [self setType:SWCameraTypeVideo];
            break;
        case SWCameraTypeVchat:
            [self setType:SWCameraTypeVchat];
            break;
        case SWCameraTypeGif:
            [self setType:SWCameraTypeGif];
            break;
        default:
            break;
    }
    
}
-(void)timeout;
{
//   NSRunLoop *LOOP = [NSRunLoop currentRunLoop];
//    
//    NSLog(@"当前loop 😡😡😡😡😡😡😡😡 ：%@",LOOP);
//    time = 0;
//    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t animatime = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(animatime,dispatch_walltime(NULL, 0), 5* NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(animatime, ^{
//        if (time == 5) {
//            dispatch_source_cancel(animatime);
//            NSLog(@"😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊");
//        }
//        //            [UIView animateWithDuration:2.0 animations:^{
//        NSLog(@"gcdloop 😈😈😈😈😈😈😈 ： %@",[NSRunLoop currentRunLoop]);
////        NSLog(@"self.alpha  %f",self.alpha);self.alpha -=0.05;
//        
//    });
//    time=time+5;
//    dispatch_resume(animatime);
}


@end
