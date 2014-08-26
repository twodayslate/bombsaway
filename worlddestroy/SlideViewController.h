//
//  SlideViewController.h
//  worlddestroy
//
//  Created by twodayslate on 8/24/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "WorldMap.h"

@interface SlideViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet NSArray *countries;
@property (strong, nonatomic) IBOutlet NSArray *coordinates;
@property (strong, nonatomic) WorldMap *mapView;
@end
