//
//  ProgressView.m
//  ImIcon
//
//  Created by fairzy fan on 12-6-15.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 10.0f;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clearsContextBeforeDrawing = YES;
        self.opaque = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    CGMutablePathRef rectpath = CGPathCreateMutable();
    CGPathAddRect(rectpath, NULL, CGRectMake(0.0f, 0.0f, width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, rectpath);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 1.0f);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(rectpath);
    
    if ( progress > 0 ) {
        CGContextMoveToPoint(context, 2.0f, height/2);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(currentContext, 3.0f);
        float endx = (width-2) * progress;
        CGContextAddLineToPoint(currentContext, endx, height/2);
        CGContextStrokePath(currentContext);
    }
}

- (void)setProgress:(float)pro{
    progress = pro;
    [self setNeedsDisplay];
}

@end
