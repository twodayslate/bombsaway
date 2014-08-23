#import <MapKit/MapKit.h>

static double mercadorRadius = 85445659.44705395;
static double mercadorOffset = 268435456;
#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@interface WorldMap : MKMapView
- (double)zoomLevel;
@end
