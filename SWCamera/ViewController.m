//
//  ViewController.m
//  camera
//
//  Created by mac1 on 16/8/24.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import "ViewController.h"

#import "SWMediaInteractionView.h"

@interface ViewController ()<SWMediaInteractionDelegate,SWMediaInteractionSourceDelegate>
{
    SWMediaInteractionView *mainV;
    CGFloat time;
}
@end
@implementation ViewController
-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    /*初始化UI界面*/
    mainV = [[SWMediaInteractionView alloc]initWithFrame:self.view.frame];
    mainV.delegate = self;
   [self.view addSubview:mainV];
    
    /*    模拟脸谱列表取消按钮*/
    UIButton *Btn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 100, 100)];
    Btn.center = self.view.center;
    [Btn setTitle:@"CLIEK" forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    
    
}
-(void)clicked:(UIButton *)sender{
    //    sender.selected = YES;
    
    sender.selected =!sender.selected;
    NSLog(@"sender.selected  :%d",sender.selected);
//    [mainV SWMediaBtnHidden:sender.selected];
    [mainV SWMediaSegHidden:sender.selected andUserInteraction:!sender.selected];
   
}
/**
 *ViewController开始倒计时5秒钟,5秒后，在此方法里就可以实现Vedio的Select;
 */
-(void)startVideoOrVchatIntercactionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state{
    /*5秒后调用此Block*/
    
    NSLog(@"倒计时五秒");
    
    time = 0;
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t animatime = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(animatime,dispatch_walltime(NULL, 0),1* NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(animatime, ^{
        
        time=time+1;
        NSLog(@"倒计时还剩%f",time);
        if (time == 5) {
            
            [mainV VedioOrVchatUserInteraction:YES];
            
            dispatch_source_cancel(animatime);
            NSLog(@"😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊  ");
        }
        
    });
    
    dispatch_resume(animatime);
    
    
}
-(void)finishedActionWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state isFirst:(BOOL)isFirst{
    NSLog(@"SWMediaInteraction type  :    %d     state:   %d    >>>>>>>isFirst:%d",type,state,isFirst);
    
}
-(void)initPicture{
    NSLog(@"initPicture");
}
/**
 *录制视频初始化
 */
-(void)initVideo{
    NSLog(@"initVideo");
}
/**
 *视频通话初始化
 */
-(void)initVchat{
    NSLog(@"initVchat");
}
/**
 *录制Gif初始化
 */
-(void)initGif{
    NSLog(@"initGif");
}
-(void)actionForFirstCustormWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state{
    NSLog(@"第一个小按钮   Type:    %d   state:   %d",type,state);
}
/**
 *第二个小按钮
 */
-(void)actionForSecondCustorm2WithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state{
     
}
/**
 *第三个小按钮
 */
-(void)actionForThirdCustorm3WithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state{
    NSLog(@"第三个小按钮   Type:    %d   state:   %d",type,state);
}
/**
 *第四个小按钮
 */
-(void)actionForFourthCustormWithType:(SWMediaBtnType)type andState:(SWMediaBtnState)state{
    
    NSLog(@"第四个小按钮   Type:    %d   state:   %d",type,state);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
