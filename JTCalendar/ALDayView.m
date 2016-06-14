//
//  ALDayView.m
//  Pods
//
//  Created by Антон on 17.04.16.
//
//

#import "ALDayView.h"

@implementation ALDayView

- (instancetype) init {
    self = [super init];
    if (self) {
        self.colorForBorderView = [UIColor lightGrayColor];
        self.setBorderForView = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.setBorderForView) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        rect.origin.x = rect.origin.x+1; // for ios 10
        rect.origin.y = rect.origin.y+1; // for ios 10
        rect.size.height = rect.size.height-2; // for ios 10
        rect.size.width = rect.size.width-2; // for ios 10
        
        CGContextSetLineWidth(context, 1.f);
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), CGRectGetHeight(rect)/2, 0, 2*M_PI, 0);
        CGContextSetStrokeColorWithColor(context, self.colorForBorderView.CGColor);
        CGContextStrokePath(context);
    }
}


@end
