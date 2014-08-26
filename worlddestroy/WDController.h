//
//  ViewController.h
//  worlddestruction
//
//  Created by twodayslate on 7/4/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MKMapView.h>
#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"
#import "AnimatedGIFImageSerialization.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ExplosionAnnotation.h"
#import "WorldMap.h"
#import "TimerView.h"
#import "AppDelegate.h"
#import "UIViewController+REFrostedViewController.h"
#import "SlideViewController.h"

@class TimerView;

@interface WDController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate> {
    AVAudioPlayer *_audioPlayer;
}
@property (strong, nonatomic) WorldMap *mapView;
@property (strong, nonatomic) TimerView *timerView;
@property (strong, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet id explosion;
@property (strong, nonatomic) IBOutlet NSMutableArray *craters;
@property (strong, nonatomic) IBOutlet NSMutableArray *stillExploding;
@property (strong, nonatomic) IBOutlet NSMutableArray *stillExplodingViews;
@property (strong, nonatomic) SlideViewController *menu;
@end