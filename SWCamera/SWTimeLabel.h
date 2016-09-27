//
//  SWTimeLabel.h
//  SWCamera
//
//  Created by mac1 on 16/9/22.
//  Copyright © 2016年 Deadpool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTimeLabel : UIView
@property (nonatomic, strong) void (^changeTimeValue)(CGFloat time);
-(void)startRunningTime;
-(void)pauseRunningTime;
-(void)endRunningTime;
@end
