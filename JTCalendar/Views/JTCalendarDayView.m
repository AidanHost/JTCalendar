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
    
}

- (void)initAndLayoutDotViewWithCountDots:(NSInteger)countDot withColorSForDots:(NSArray *)colors {
    
    CGFloat newCenter;
    
    if (countDot == 1) {
        newCenter = CGRectGetWidth(self.frame)/2.0;
    } else if (countDot == 2) {
        newCenter = CGRectGetWidth(self.frame)/2.0 - distanse/2.0;
    } else {
        newCenter = CGRectGetWidth(self.frame)/2.0 - distanse;
    }

    for (int i = 0; i < countDot; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sizeDot, self.sizeDot)];
    
        dot.center = CGPointMake(newCenter + i*distanse, (self.frame.size.height / 2.0) + self.sizeDot * 2.5);
        dot.layer.cornerRadius = self.sizeDot / 2.0;
        
        dot.backgroundColor = colors[i];
        dot.layer.rasterizationScale = [UIScreen mainScreen].scale;
        dot.layer.shouldRasterize = YES;
        
        [self addSubview:dot];
        [self.dots addObject:dot];
    }
}

- (void)setBackgroundColorForDotView:(UIView *)dot withColor:(UIColor *)color {
    dot.backgroundColor = color;
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
        [dateFormatter setDateFormat:@"dd"];
    }
    
    _textLabel.text = [dateFormatter stringFromDate:_date];
        
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

@end
