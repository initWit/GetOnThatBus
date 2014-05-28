//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Robert Figueras on 5/28/14.
//
//

#import "ViewController.h"
#import <MapKit/MapKit.h>


@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                            NSData *data,
                                                                                                            NSError *connectionError) {

        NSDictionary *amazonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSArray *busStopsArray = [amazonDictionary objectForKey:@"row"];

        for (NSDictionary *busDictionary in busStopsArray) {
            NSString *latitude = [busDictionary objectForKey:@"latitude"];
            NSString *longitude = [busDictionary objectForKey:@"longitude"];

            double latConvertedToDouble = [latitude doubleValue];
            double longConvertedToDouble = [longitude doubleValue];
            MKPointAnnotation *busStopAnnotation = [[MKPointAnnotation alloc]init];
            busStopAnnotation.coordinate = CLLocationCoordinate2DMake(latConvertedToDouble, longConvertedToDouble);
            busStopAnnotation.title = [busDictionary objectForKey:@"cta_stop_name"];
            busStopAnnotation.subtitle = [busDictionary objectForKey:@"routes"];

            [self.mapView addAnnotation:busStopAnnotation];

        }
    }];

}

#pragma mark - AnnotationView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    return pin;
}

//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//
//
//}


@end
