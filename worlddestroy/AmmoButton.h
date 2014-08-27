//
//  AmmoView.h
//  
//
//  Created by twodayslate on 8/26/14.
//
//

#import <UIKit/UIKit.h>
#import "WDController.h"

@class WDController;

@interface AmmoButton : UIButton
@property (strong, nonatomic) WDController *controller;
-(id)initWithController:(WDController *)controller;
@end
