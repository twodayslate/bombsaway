//
//  AmmoView.m
//  
//
//  Created by twodayslate on 8/26/14.
//
//

#import "AmmoButton.h"

@implementation AmmoButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"small_bomb_16.gif"] forState:UIControlStateNormal];
        //[button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self setTitle:@"∞" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[button setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
