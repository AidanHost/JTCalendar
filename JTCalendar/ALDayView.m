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
    
    CGContextSetLineWidth(context, 1.f);
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), CGRectGetHeight(rect)/2, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextStrokePath(context);
}


@end
