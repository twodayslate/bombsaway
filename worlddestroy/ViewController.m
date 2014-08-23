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
//static NSMutableArray *craters = nil;



-(void)addAnimatedOverlayToAnnotation:(id<MKAnnotation>)annotation{
    //get a frame around the annotation
    NSString *type = annotation.title;
    double zoomLevel = [annotation.subtitle doubleValue];
    double size = zoomLevel * 0.01;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, size, size);
    CGRect rect = [_mapView  convertRegion:region toRectToView:_mapView];
    //set up the animated overlay
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"FWqc3Kk" withExtension:@"gif"];
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
    [_mapView addSubview:imageView];
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //removes the animated overlay
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
        [self addAnimatedOverlayToAnnotation:n];
    }
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"inside here");
    [self readdCraters];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[WorldMap alloc] initWithFrame:self.view.frame];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_mapView addGestureRecognizer:tapGesture];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeSatellite;
    _mapView.scrollEnabled = YES;
    _mapView.showsUserLocation = NO;
    _mapView.rotateEnabled = YES;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mapView];
}

-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap handled");
    
    NSLog(@"zoom scale = %f",_mapView.bounds.size.width / _mapView.visibleMapRect.size.width);
    NSLog(@"visible rect width = %f",_mapView.visibleMapRect.size.width);
    NSLog(@"visible rect height = %f",_mapView.visibleMapRect.size.height);
    NSLog(@"zoom level = %f",[_mapView zoomLevel]);
    
    CGPoint point = [recognizer locationInView:_mapView];
    
    CLLocationCoordinate2D tapPoint = [_mapView convertPoint:point toCoordinateFromView:self.view];
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    
    point1.coordinate = tapPoint;
    point1.title = @"default,0";
    if(_mapView.visibleMapRect.size.width > _mapView.visibleMapRect.size.height)
        point1.subtitle = [NSString stringWithFormat:@"%f",_mapView.visibleMapRect.size.width];
    else
        point1.subtitle = [NSString stringWithFormat:@"%f",_mapView.visibleMapRect.size.height];
        
    
    //MKCircle *overlay = [MKCircle circleWithCenterCoordinate:tapPoint radius:1000];
    //[_mapView addOverlay:overlay];
    [_mapView addAnnotation:point1];
    [self addAnimatedOverlayToAnnotation:point1];
    [self shakeMap];
    [self playExplosion];
    
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/atari_boom.mp3",
                               [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    _audioPlayer.numberOfLoops = 0;
    [_audioPlayer play];
}

-(void)playExplosion {
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
    CLLocationCoordinate2D start = _mapView.centerCoordinate;
    CLLocationCoordinate2D new = start;
    new.latitude = new.latitude + 1;
    [_mapView setCenterCoordinate:new animated:NO];
    [_mapView setCenterCoordinate:start animated:YES];
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
    [self removeCraters];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self readdCraters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end