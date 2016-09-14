//
//  SWMediaPro.m
//  DrawCircle
//
//  Created by Starain on 16/9/6.
//  Copyright © 2016年 Starain. All rights reserved.
//

#import "SWMediaPro.h"

#define Point self.bounds.size.width/2
#define lineWidth 5.0
@interface SWMediaPro ()
{
    
    CGContextRef context;
}
@property (nonatomic, strong) NSMutableArray *nowArray;/*最后一段录制的红点绘制*/
@property (nonatomic, strong) NSMutableArray *pauseArray;/*绘制白点*/
@property (nonatomic, strong) NSArray *allArray;/*前面分段录制*/

@end

@implementation SWMediaPro

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextAddArc(context, Point, Point, Point- 2.5, M_PI_2 , M_PI_2 + 2 * M_PI, 0);
    CGContextStrokePath(context);
    if (!self.nowArray || self.nowArray.count < 2)
    {
        return;
    }
    
    ;
    // 历史
    for (int j = 0; j < self.allArray.count; j++)
    {
        NSMutableArray *tempArray = self.allArray[j];
        
        for (int i = 0; i < tempArray.count-1; i++)
        {
            CGContextSetStrokeColorWithColor(context, [self.drawColor CGColor]);
            CGFloat startAngle = M_PI_2 + 2 * M_PI * [tempArray[i] floatValue];
            CGFloat endAngle = M_PI_2 + 2 * M_PI * [tempArray[i+1] floatValue];
            CGContextAddArc(context, Point, Point, Point - 2.5, startAngle, endAngle, 0);
            CGContextStrokePath(context);
        }
    }
    
    // 本次
    for (int i = 0; i < self.nowArray.count-1; i++)
    {
        CGContextSetStrokeColorWithColor(context, [self.drawColor CGColor]);
        CGFloat startAngle = M_PI_2 + 2 * M_PI * [self.nowArray[i] floatValue];
        CGFloat endAngle = M_PI_2 + 2 * M_PI * [self.nowArray[i+1] floatValue];
        CGContextAddArc(context, Point, Point, Point - 2.5, startAngle, endAngle, 0);
        CGContextStrokePath(context);
    }
    
    // 暂停
    for (int j = 0; j < self.pauseArray.count; j++)
    {
        CGContextSetStrokeColorWithColor(context, [self.pauseColor CGColor]);
        CGFloat startAngle = M_PI_2 + 2 * M_PI * [self.pauseArray[j] floatValue];
        CGFloat endAngle = M_PI_2 + 2 * M_PI * [self.pauseArray[j] floatValue];
        CGContextAddArc(context, Point, Point, Point - 2.5, startAngle-0.01, endAngle+0.01, 0);
        CGContextStrokePath(context);
    }
}

- (void)setProgressEnd:(double)progressEnd
{
    _progressEnd = progressEnd;
    [self setNeedsDisplay];
}

- (void)drawBegan
{
    self.nowArray = [NSMutableArray array];
    [self.nowArray addObject:@(self.progressEnd)];
}

- (void)drawMoved
{
    [self.nowArray addObject:@(self.progressEnd)];
    [self setNeedsDisplay];
}
-(void)drawPause{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.nowArray];
    if (self.allArray)
    {
        self.allArray = [self.allArray arrayByAddingObject:tempArray];
    }
    else
    {
        self.allArray = [[NSArray alloc] initWithObjects:tempArray, nil];
    }
    [self.pauseArray addObject:@(self.progressEnd)];
}
- (void)drawEnded
{
    
    self.pauseArray  = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawMoved];
        [self setNeedsDisplay];
    });
    
}

- (void)drawReset
{
    self.pauseArray  = nil;
    self.allArray    = nil;
    self.nowArray    = nil;
    self.progressEnd = 0.0;
    [self drawBegan];
    [self drawMoved];
    [self setNeedsDisplay];
}

- (UIColor *)drawColor
{
    if (!_drawColor)
    {
        _drawColor = [UIColor redColor];
    }
    return _drawColor;
}

- (NSMutableArray *)pauseArray
{
    if (!_pauseArray)
    {
        _pauseArray = [NSMutableArray array];
    }
    return _pauseArray;
}

@end
