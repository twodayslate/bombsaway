//
//  TimerView.m
//  worlddestroy
//
//  Created by twodayslate on 8/22/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import "TimerView.h"

@implementation TimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    _color = [UIColor redColor];
    return self;
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