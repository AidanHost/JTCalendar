//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"

static CGFloat distanse = 7.5f;

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;

    self.dots = [NSMutableArray array];
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    
    {
        _circleView = [[ALDayView alloc] init];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;

        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    if ([self.dots count] < 1) {
        if ([self.subviews count] > 2) {
            NSInteger counts = self.subviews.count;
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < counts - 2; i++) {
                [array addObject:[self.subviews objectAtIndex:(counts-1-i)]];
            }
            for (UIView *view in array) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)layoutSubviews
{
    _textLabel.frame = self.bounds;
    
    self.sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    
   self.sizeDot = self.sizeCircle;
    
    self.sizeCircle = self.sizeCircle * _circleRatio;
    self.sizeDot = self.sizeDot * _dotRatio;
    
    self.sizeCircle = roundf(self.sizeCircle);
    self.sizeDot = roundf(self.sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, self.sizeCircle, self.sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = self.sizeCircle / 2.;
    _circleView.layer.masksToBounds = YES; // fix for ios 10
    
    [self layoutDots];
}

- (void)layoutDots
{
    if ([self.dots count] != 0) {
        CGFloat newCenter;
        if ([self.dots count] == 1) {
            newCenter = CGRectGetWidth(self.frame)/2.0;
        } else if ([self.dots count] == 2) {
            newCenter = CGRectGetWidth(self.frame)/2.0 - distanse/2.0;
        } else {
            newCenter = CGRectGetWidth(self.frame)/2.0 - distanse;
        }
        
        for (int i = 0; i < [self.dots count]; i++) {
            UIView *dot = self.dots[i];
            dot.frame = CGRectMake(0, 0, self.sizeDot, self.sizeDot);
            dot.center = CGPointMake(newCenter + i*distanse, (self.frame.size.height / 2.0) + self.sizeDot * 2.5);
            dot.layer.cornerRadius = self.sizeDot / 2.0;
            dot.layer.rasterizationScale = [UIScreen mainScreen].scale;
            dot.layer.shouldRasterize = YES;
            [self addSubview:dot];
        }
    }
}

- (void)initAndLayoutDotViewWithCountDots:(NSInteger)countDot withColorSForDots:(NSArray *)colors {
    if ([self.dots count] < 1) {
        for (int i = 0; i < countDot; i++) {
            UIView *dot = [[UIView alloc] init];
            dot.backgroundColor = colors[i];
            [self.dots addObject:dot];
        }
    }
}


- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
        if (_manager.settings.formatDay == JTCalendarFormatDayLongDay) {
            [dateFormatter setDateFormat:@"dd"];
        } else {
            [dateFormatter setDateFormat:@"d"];
        }
    }
    
    _textLabel.text = [dateFormatter stringFromDate:_date];
    
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

@end
