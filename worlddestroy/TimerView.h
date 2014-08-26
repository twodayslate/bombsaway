//
//  TimerView.h
//  worlddestroy
//
//  Created by twodayslate on 8/22/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDController.h"

@class WDController;

@interface TimerView : UIView
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) WDController *comparison;
@property (nonatomic, assign) double delay;

+(UIColor *)greenColor;
+(UIColor *)redColor;
-(id)initWithComparitor:(UIViewController *)comparitor withDelay:(double)delay;
-(BOOL)isMax;
-(void)reset;
-(void)setDelay:(double)delay;
-(void)rotate;

@end
