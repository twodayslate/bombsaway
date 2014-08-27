//
//  AmmoView.m
//  
//
//  Created by twodayslate on 8/26/14.
//
//

#import "AmmoButton.h"

@implementation AmmoButton

-(id)initWithController:(WDController *)controller {
    _controller = controller;
    return [[AmmoButton alloc] initWithFrame:CGRectMake(_controller.view.frame.size.width-50, _controller.view.frame.size.height-50, 50, 50)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"controler = %@",_controller);
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
