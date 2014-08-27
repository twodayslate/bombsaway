//
//  SlideViewController.m
//  worlddestroy
//
//  Created by twodayslate on 8/24/14.
//  Copyright (c) 2014 PRNDL. All rights reserved.
//

#import "SlideViewController.h"

@implementation SlideViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.opaque = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.50f];
    
    _cities = @[@"Your location",
                   @"Beijing", @"London",
                   @"New York City", @"Moscow",
                   @"Tokyo", @"Chicago",
                   @"Hong Kong", @"Paris",
                   @"Washington D.C."];
    //Eventually add user location
    _coordinates = @[ @[[NSNumber numberWithDouble:_mapView.userLocation.location.coordinate.latitude], [NSNumber numberWithDouble:_mapView.userLocation.location.coordinate.longitude]],
                      @[@39.9139, @116.3917], @[@51.5072, @0.1275],
                      @[@40.7127, @74.0059], @[@55.7500, @37.6167],
                      @[@35.6895, @139.6917], @[@41.8819, @87.6278],
                      @[@22.2670, @114.1880], @[@48.8567, @2.3508],
                      @[@38.8951, @77.0367] ]; // Thanks Google :)
    
    _ads = YES;
    
    _links = @[@"http://prndl.us/",@"http://twitter.com/twodayslate"];
    _linkTitles = @[@"PRNDL.us",@"@twodayslate"];
    
    _sectionsArray = [[NSMutableArray alloc] init];;
    
    if(_ads) {
        [_sectionsArray addObject:@"ads"];
    }
    
    [_sectionsArray addObject:@"cities"];
    [_sectionsArray addObject:@"about"];
    
    // Do any additional setup after loading the view.
}

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return 32;
        } else {
            return 50;
        }
    }
    else return 66; //iPad
}

- (ADBannerView *)adBannerView {
    if(!_adView) {
        _adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    }
    return _adView;
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *type = [_sectionsArray objectAtIndex:section];

    if([type isEqual:@"ads"]) {
        return 0;
    } else if([type isEqual:@"cities"]) {
        return [_cities count];
    } else if([type isEqual:@"about"]) {
        return [_linkTitles count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    if(!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSString *type = [_sectionsArray objectAtIndex:indexPath.section];
    
    if([type isEqual:@"ads"]) {
        cell.textLabel.text = @"Remove all ads - $0.99";
    } else if([type isEqual:@"cities"]) {
        cell.textLabel.text = [_cities objectAtIndex:indexPath.row];
    } else if([type isEqual:@"about"]) {
        cell.textLabel.text = [_linkTitles objectAtIndex:indexPath.row];
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *type = [_sectionsArray objectAtIndex:section];
    
    if([type isEqual:@"ads"]) {
        return @"ADVERTISEMENT";
    } else if([type isEqual:@"cities"]) {
        return @"MAJOR CITIES";
    } else if([type isEqual:@"about"]) {
        return @"ABOUT";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = [_sectionsArray objectAtIndex:indexPath.section];
    
    if([type isEqual:@"ads"]) {
        if(indexPath.row == 1) {
            // iAP here
        }
    } else if([type isEqual:@"cities"]) {
        [self goToCity:(int)indexPath.row ];
        [self.frostedViewController hideMenuViewController];
    } else if([type isEqual:@"about"]) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://prndl.us"]];
        } else { [self launchTwitter:@"twodayslate"]; }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)goToCity:(int)city {
    CLLocationCoordinate2D  point;
    point.latitude = [[[_coordinates objectAtIndex:city] objectAtIndex:0] doubleValue];
    point.longitude = [[[_coordinates objectAtIndex:city] objectAtIndex:1] doubleValue];
    
    NSLog(@"Going to: (%f, %f)",point.latitude,point.longitude);
    
    //    int zoomLevel = 5;
    //    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*_mapView.frame.size.width/256);
    //    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(point, 250, 250);
    //    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMake(point, span)];
    //    [_mapView setRegion:adjustedRegion animated:YES];
    
    // This sets a minimum distance but not a maximum
    MKCoordinateRegion region;
    region.center.latitude = point.latitude;
    region.center.longitude = point.longitude;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:TRUE];
    
    [_mapView setCenterCoordinate:point animated:YES];
}

- (void)launchTwitter:(NSString *)username {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/twodayslate"]];
	}
    
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=twodayslate"]];
	}
    
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=twodayslate"]];
	}
    
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=twodayslate"]];
	}
    
	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/twodayslate"]];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;

            tableViewHeaderFooterView.textLabel.textColor = [UIColor whiteColor];
            UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.3];
            tableViewHeaderFooterView.tintColor = color;
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [super tableView:tableView viewForHeaderInSection:section];
    if(_ads && section == 0) {
        return [self adBannerView];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(_ads && section == 0) {
        return [self getBannerHeight];
    } else {
        return 25;
    }
}

@end
