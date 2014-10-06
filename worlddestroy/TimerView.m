//
//  TimerView.m
//  worlddestroy
//
//  Created by twodayslate on 8/22/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView

+(UIColor *)greenColor {
    return [[UIColor alloc] initWithRed:0.0 green:256.0 blue:0.0 alpha:0.6];
}
+(UIColor *)redColor {
    return [[UIColor alloc] initWithRed:256.0 green:0.0 blue:0.0 alpha:0.6];
}

-(id)initWithComparitor:(WDController *)comparitor withDelay:(double)delay;{
    
    
    self = [[TimerView alloc] initWithFrame:CGRectMake(0,comparitor.mapView.frame.size.height-10,comparitor.mapView.frame.size.width,10)];
    _comparison = comparitor;
    _delay = delay;
    
    [self setColor:[TimerView greenColor]];
    [self performSelector:@selector(onTimer) withObject:nil afterDelay:_delay];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    return self;
}

- (void)onTimer {
    
    [UIView
     animateWithDuration:0.01
     animations:^{
         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width + (_comparison.view.frame.size.width/(_delay*100)),self.frame.size.height);
     }];
    
    if(![self isMax]) {
        [self performSelector:@selector(onTimer) withObject:nil afterDelay:_delay];
    } else {
        [self setColor:[TimerView greenColor]];
    }
    
    [self setNeedsDisplay];
}

-(BOOL)isMax {
    return self.frame.size.width >= _comparison.mapView.frame.size.width;
}

-(void)reset {
    [UIView
     animateWithDuration:0.01
     animations:^{
         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,0,self.frame.size.height);
         [self setColor:[TimerView redColor]];
         [self setNeedsDisplay];
     }];
    [self performSelector:@selector(onTimer) withObject:nil afterDelay:_delay];
}

-(void)setDelay:(double)delay {
    _delay = delay;
}

-(void)rotate {
    [UIView
     animateWithDuration:0.01
     animations:^{
         self.frame = CGRectMake(0,_comparison.mapView.frame.size.height-self.frame.size.height,self.frame.size.width,self.frame.size.height);
     }];
    
    if([self isMax] || [_color isEqual:[TimerView greenColor]]) {
        [UIView
         animateWithDuration:0.01
         animations:^{
             self.frame = CGRectMake(0,_comparison.mapView.frame.size.height-self.frame.size.height,_comparison.mapView.frame.size.width,self.frame.size.height);
         }];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext ();
    
    // The color to fill the rectangle (in this case black)
    CGContextSetFillColorWithColor(context, _color.CGColor);
    
    // draw the filled rectangle
    CGContextFillRect (context, self.bounds);
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (BOOL) shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
