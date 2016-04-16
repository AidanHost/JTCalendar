//
//  ALDayView.m
//  Pods
//
//  Created by Антон on 17.04.16.
//
//

#import "ALDayView.h"

@implementation ALDayView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    CGContextSetLineWidth(context, 2.f);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}


@end
