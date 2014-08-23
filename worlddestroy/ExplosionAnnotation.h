#import <MapKit/MapKit.h>

@interface ExplosionAnnotation : MKAnnotationView
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end