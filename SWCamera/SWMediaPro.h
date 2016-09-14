//
//  SWMediaPro.h
//  DrawCircle
//
//  Created by Starain on 16/9/6.
//  Copyright © 2016年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWMediaPro : UIView

@property (nonatomic, assign) CGFloat progressEnd;
@property (nonatomic, strong) UIColor *pauseColor;
@property (nonatomic, strong) UIColor *drawColor;

/** 起始 */
- (void)drawBegan;
/** 过程 */
- (void)drawMoved;
/** 暂停 */
- (void)drawPause;
/** 结束 */
- (void)drawEnded;
/** 复位 */
- (void)drawReset;


@end
