//
//  ViewController.m
//  worlddestruction
//
//  Created by twodayslate on 7/4/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static BOOL shake = NO;

-(void)addAnimatedOverlayToAnnotation:(id<MKAnnotation>)annotation{
    
    [_stillExploding addObject:annotation];
    //get a frame around the annotation
    //NSString *type = annotation.title;
//    NSArray *list = [type componentsSeparatedByString:@","];
//    type = [list objectAtIndex:0];
//    int count = [[list objectAtIndex:1] integerValue];
    double zoomLevel = [annotation.subtitle doubleValue];
    double size = zoomLevel * 0.01;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, size, size);
    CGRect rect = [_mapView  convertRegion:region toRectToView:_mapView];
    //set up the animated overlay
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"explosion (1)" withExtension:@"gif"];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    //self.urlImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = image;
    //imageView.center = imageView.frame.origin;
    //[self addSubview:imageView];
    

    //add to the map and start the animation
    if(!_craters) _craters = [[NSMutableArray alloc] init];
    [_craters addObject:imageView];
    
    
    //[self performSelector:@selector(doneExploding:) withObject:@[annotation,imageView] afterDelay:1.09];
    
    NSMutableDictionary *cb = [[NSMutableDictionary alloc] init];
    [cb setObject:annotation forKey:@"annotation"];
    [cb setObject:imageView forKey:@"imageView"];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doneExploding:) userInfo:cb repeats:NO];
    [self performSelector:@selector(onTimer) withObject:nil afterDelay:0.1];
    [_mapView addSubview:imageView];
}

-(void)doneExploding:(NSTimer *)timer {
    NSMutableDictionary *arg1 = [timer userInfo];
    [_stillExploding removeObject:[arg1 objectForKey:@"annotation"]];
    [self addCraterOverlayToAnnotation:[arg1 objectForKey:@"annotation"]];
    [[arg1 objectForKey:@"imageView"] removeFromSuperview];
    
}

-(void)addCraterOverlayToAnnotation:(id<MKAnnotation>)annotation {
    if([_stillExploding containsObject:annotation]) {
        [self addAnimatedOverlayToAnnotation:annotation];
    } else {
        //get a frame around the annotation
        //NSString *type = annotation.title;
        //    NSArray *list = [type componentsSeparatedByString:@","];
        //    type = [list objectAtIndex:0];
        //    int count = [[list objectAtIndex:1] integerValue];
        double zoomLevel = [annotation.subtitle doubleValue];
        double size = zoomLevel * 0.01;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, size, size);
        CGRect rect = [_mapView  convertRegion:region toRectToView:_mapView];
        //set up the animated overlay
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"crater" withExtension:@"gif"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.image = image;
        
        //add to the map and start the animation
        if(!_craters) _craters = [[NSMutableArray alloc] init];
        [_craters addObject:imageView];
        [_mapView addSubview:imageView];
    }
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self removeCraters];
}

-(void)removeCraters {
    for(UIImageView *view in _craters) {
        [view removeFromSuperview];
    }
    _craters = [[NSMutableArray alloc] init];
}

-(void)readdCraters {
    for(id<MKAnnotation> n in _mapView.annotations){
        [self addCraterOverlayToAnnotation:n];
    }
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"inside region did change");
    [self removeCraters];
    [self readdCraters];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[WorldMap alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_mapView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:_mapView];
    
    
    _timerView = [[TimerView alloc] initWithFrame:CGRectMake(0,_mapView.frame.size.height-10,_mapView.frame.size.width,10)];
    [_timerView setColor:[UIColor colorWithRed:0/256.0 green:256/256.0 blue:0/256.0 alpha:0.3]];
    [self.view addSubview:_timerView];
    [self performSelector:@selector(onTimer) withObject:nil afterDelay:0.01];

    if(!_stillExploding) _stillExploding = [[NSMutableArray alloc] init];
}

- (void)onTimer {
    
    [UIView
     animateWithDuration:0.01
     animations:^{
         _timerView.frame = CGRectMake(_timerView.frame.origin.x, _timerView.frame.origin.y,_timerView.frame.size.width + (self.view.frame.size.width/10),_timerView.frame.size.height);
     }];
    
    if(_timerView.frame.size.width < _mapView.frame.size.width){
        [self performSelector:@selector(onTimer) withObject:nil afterDelay:0.1];
    } else {
        [_timerView setColor:[UIColor colorWithRed:0/256.0 green:256/256.0 blue:0/256.0 alpha:0.3]];
        [_timerView setNeedsDisplay];
    }
}

-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
//    NSLog(@"tap handled");
//    
//    NSLog(@"zoom scale = %f",_mapView.bounds.size.width / _mapView.visibleMapRect.size.width);
//    NSLog(@"visible rect width = %f",_mapView.visibleMapRect.size.width);
//    NSLog(@"visible rect height = %f",_mapView.visibleMapRect.size.height);
//    NSLog(@"zoom level = %f",[_mapView zoomLevel]);
    
    
    if(_timerView.frame.size.width >= _mapView.frame.size.width) {
        CGPoint point = [recognizer locationInView:_mapView];
        
        CLLocationCoordinate2D tapPoint = [_mapView convertPoint:point toCoordinateFromView:self.view];
        
        MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
        
        point1.coordinate = tapPoint;
        point1.title = @"default";
        if(_mapView.visibleMapRect.size.width > _mapView.visibleMapRect.size.height)
            point1.subtitle = [NSString stringWithFormat:@"%f",_mapView.visibleMapRect.size.width];
        else
            point1.subtitle = [NSString stringWithFormat:@"%f",_mapView.visibleMapRect.size.height];
        
        
        //MKCircle *overlay = [MKCircle circleWithCenterCoordinate:tapPoint radius:1000];
        //[_mapView addOverlay:overlay];
        [_mapView addAnnotation:point1];
        //[self shakeMap];
        [self addAnimatedOverlayToAnnotation:point1];
        [self playExplosion:point1];
        
        
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/atari_boom.mp3",
                                   [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer play];
        
        [self resetTimer];
    }
    
}

-(void)resetTimer {
    _timerView.frame = CGRectMake(_timerView.frame.origin.x, _timerView.frame.origin.y,1,_timerView.frame.size.height);
    UIColor *color = [UIColor colorWithRed:256/256.0 green:0/256.0 blue:0/256.0 alpha:0.3];
    [_timerView setColor:color];
    [_timerView setNeedsDisplay];
}

-(void)playExplosion:(id<MKAnnotation>)annotation {
    if(_audioPlayer) {
        [_audioPlayer play];
    } else {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/atari_boom.mp3",
                                   [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer play];
    }
}

-(void)shakeMap {
    shake = YES;
    CLLocationCoordinate2D start = _mapView.centerCoordinate;
    CLLocationCoordinate2D new = start;
    new.latitude = new.latitude + 1;
    [_mapView setCenterCoordinate:new animated:NO];
    [_mapView setCenterCoordinate:start animated:YES];
    [self performSelector:@selector(setShake) withObject:nil afterDelay:0.2];
}

-(void)setShake {
    shake = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString *reuseId = @"explosion";
    
    ExplosionAnnotation *myPersonalView = (ExplosionAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if (myPersonalView == nil) {
        myPersonalView = [[ExplosionAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
    else {
        myPersonalView.annotation = annotation;
    }
    
    return myPersonalView;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self removeCraters];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"inside didRotate");
    [self removeCraters];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self readdCraters];
    
    [UIView
     animateWithDuration:0.01
     animations:^{
         _timerView.frame = CGRectMake(0,_mapView.frame.size.height-_timerView.frame.size.height,_timerView.frame.size.width,_timerView.frame.size.height);
     }];
    
    if([_timerView.color isEqual:[UIColor colorWithRed:0/256.0 green:256/256.0 blue:0/256.0 alpha:0.3]]) {
        [UIView
         animateWithDuration:0.01
         animations:^{
             _timerView.frame = CGRectMake(0,_mapView.frame.size.height-_timerView.frame.size.height,_mapView.frame.size.width,_timerView.frame.size.height);
         }];
    }
    
    //NSLog(@"new frame = (%f,%f)",_timerView.frame.origin.x,_timerView.frame.origin.y);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end