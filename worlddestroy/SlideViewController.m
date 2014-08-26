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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:0.50f];
    
    _countries = @[@"Beijing", @"London",
                   @"New York City", @"Moscow",
                   @"Tokyo", @"Chicago",
                   @"Hong Kong", @"Paris",
                   @"Washington D.C."];
    _coordinates = @[ @[@39.9139, @116.3917], @[@51.5072, @0.1275],
                      @[@40.7127, @74.0059], @[@55.7500, @37.6167],
                      @[@35.6895, @139.6917], @[@41.8819, @87.6278],
                      @[@22.2670, @114.1880], @[@48.8567, @2.3508],
                      @[@38.8951, @77.0367] ]; // Thanks Google :)
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSections {
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    if(!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = [_countries objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"MAJOR CITIES";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLLocationCoordinate2D  point;
    point.latitude = [[[_coordinates objectAtIndex:indexPath.row] objectAtIndex:0] doubleValue];
    point.longitude = [[[_coordinates objectAtIndex:indexPath.row] objectAtIndex:1] doubleValue];
    
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
    
    [self.frostedViewController hideMenuViewController];
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

@end
