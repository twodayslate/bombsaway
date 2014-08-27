//
//  ViewController.m
//  worlddestruction
//
//  Created by twodayslate on 7/4/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import "WDController.h"

@implementation WDController

static BOOL shake = NO;

-(void)addAnimatedOverlayToAnnotation:(id<MKAnnotation>)annotation{
    
    [_stillExploding addObject:annotation];
    //get a frame around the annotation
    //NSString *type = annotation.title;
//    NSArray *list = [type componentsSeparatedByString:@","];
//    type = [list objectAtIndex:0];
//    int count = [[list objectAtIndex:1] integerValue];
    double zoomLevel = [annotation.subtitle doubleValue];
    double size = zoomLevel*15000;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, size, size);
    CGPoint point = [_mapView convertCoordinate:annotation.coordinate toPointToView:_mapView];
    CGRect rect = [_mapView  convertRegion:region toRectToView:_mapView];
    
    region = MKCoordinateRegionMakeWithDistance([_mapView centerCoordinate], size, size);
    CGRect rect1= [_mapView  convertRegion:region toRectToView:_mapView];
    
    CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y, rect1.size.width, rect1.size.height);
    
    
    //set up the animated overlay
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"explosion (4)" withExtension:@"gif"];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect2];
    imageView.layer.magnificationFilter = kCAFilterNearest; // for crisp edges
    imageView.image = image;
    imageView.center = point;

    

    //add to the map and start the animation
    if(!_craters) _craters = [[NSMutableArray alloc] init];
    [_craters addObject:imageView];
    
    
    //[self performSelector:@selector(doneExploding:) withObject:@[annotation,imageView] afterDelay:1.09];
    
    NSMutableDictionary *cb = [[NSMutableDictionary alloc] init];
    [cb setObject:annotation forKey:@"annotation"];
    [cb setObject:imageView forKey:@"imageView"];
    [NSTimer scheduledTimerWithTimeInterval:1.05 target:self selector:@selector(doneExploding:) userInfo:cb repeats:NO];
    
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
        double size = zoomLevel*15000;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, size, size);
        CGRect rect = [_mapView  convertRegion:region toRectToView:_mapView];
        CGPoint point = [_mapView convertCoordinate:annotation.coordinate toPointToView:_mapView];
        region = MKCoordinateRegionMakeWithDistance([_mapView centerCoordinate], size, size);
        CGRect rect1= [_mapView  convertRegion:region toRectToView:_mapView];
        
        CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y, rect1.size.width, rect1.size.height);
        //set up the animated overlay
        //CGContextRef c = UIGraphicsGetCurrentContext();
        //CGContextSetInterpolationQuality(c, kCGInterpolationNone); // get an error with this
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"crater" withExtension:@"gif"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect2];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(point.x,point.y);
        
        
        imageView.image = image;
        imageView.layer.magnificationFilter = kCAFilterNearest;
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
    
    UIImage *image = [UIImage imageNamed:@"menu-128.png"];
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
    [menu setImage:image forState:UIControlStateNormal];
    [menu addTarget:self
               action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:menu];
    
    _timerView = [[TimerView alloc] initWithComparitor:self withDelay:0.1];
    [self.view addSubview:_timerView];
    
//    _ammoView = [[AmmoView alloc] initWithController:self];
//    [self.view addSubview:_ammoView];
    
    _ammoButton = [AmmoButton buttonWithType:UIButtonTypeCustom];
    [_ammoButton setFrame:CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-50, 50, 50)];
    [self.view addSubview:_ammoButton];
    
    _menu.mapView = _mapView;
    if(!_stillExploding) _stillExploding = [[NSMutableArray alloc] init];
}

-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
//    NSLog(@"tap handled");
//    
//    NSLog(@"zoom scale = %f",_mapView.bounds.size.width / _mapView.visibleMapRect.size.width);
//    NSLog(@"visible rect width = %f",_mapView.visibleMapRect.size.width);
//    NSLog(@"visible rect height = %f",_mapView.visibleMapRect.size.height);
//    NSLog(@"zoom level = %f",[_mapView zoomLevel]);
    
    
    if([_timerView isMax]) {
        CGPoint point = [recognizer locationInView:_mapView];
        
        CLLocationCoordinate2D tapPoint = [_mapView convertPoint:point toCoordinateFromView:self.view];
        
        MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
        
        point1.coordinate = tapPoint;
        point1.title = @"default";
        if(_mapView.region.span.latitudeDelta > _mapView.region.span.longitudeDelta)
            point1.subtitle = [NSString stringWithFormat:@"%f",(double)_mapView.region.span.latitudeDelta];
        else
            point1.subtitle = [NSString stringWithFormat:@"%f",(double)_mapView.region.span.longitudeDelta];
        
        
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
        
        [_timerView reset];
    }
    
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
    
    [_timerView rotate];
    [UIView
     animateWithDuration:0.01
     animations:^{
         _ammoButton.frame = CGRectMake(self.mapView.frame.size.width-50, self.mapView.frame.size.height-50, 50, 50);
     }];
}

- (void)didReceiveMemoryWarning
{;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

@end