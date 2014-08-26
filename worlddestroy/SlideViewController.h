//
//  SlideViewController.h
//  worlddestroy
//
//  Created by twodayslate on 8/24/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "WorldMap.h"

@interface SlideViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet NSArray *cities;
@property (strong, nonatomic) IBOutlet NSArray *coordinates;
@property (strong, nonatomic) IBOutlet NSArray *linkTitles;
@property (strong, nonatomic) IBOutlet NSArray *links;
@property (strong, nonatomic) IBOutlet NSMutableArray *sectionsArray;
@property (strong, nonatomic) WorldMap *mapView;
@property (nonatomic, assign) BOOL ads;

- (void)launchTwitter:(NSString *)username;
@end
