//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Robert Figueras on 5/28/14.
//
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"


@interface ViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *busStopsArray;
@property NSDictionary *selectedDictionary;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedDictionary = [[NSDictionary alloc]init];

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                            NSData *data,
                                                                                                            NSError *connectionError) {

        NSDictionary *amazonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        self.busStopsArray = [amazonDictionary objectForKey:@"row"];

        // Zoom-set variables
//        double maxLongitudeNorth = 0.0;
//        double maxLongitudeSouth = 0.0;
//        double maxLatitudeEast = 0.0;
//        double maxLatitudeWest = 50.0;

        for (NSDictionary *busDictionary in self.busStopsArray) {
            NSString *latitude = [busDictionary objectForKey:@"latitude"];
            NSString *longitude = [busDictionary objectForKey:@"longitude"];

            double latConvertedToDouble = [latitude doubleValue];
            double longConvertedToDouble = [longitude doubleValue];
            MKPointAnnotation *busStopAnnotation = [[MKPointAnnotation alloc]init];
            busStopAnnotation.coordinate = CLLocationCoordinate2DMake(latConvertedToDouble, longConvertedToDouble);
            busStopAnnotation.title = [busDictionary objectForKey:@"cta_stop_name"];
            busStopAnnotation.subtitle = [busDictionary objectForKey:@"routes"];

            [self.mapView addAnnotation:busStopAnnotation];

//            // Setting initial zoom boundaries
//            // Set East boundary
//            if(latConvertedToDouble > maxLatitudeEast)
//            {
//                maxLatitudeEast = latConvertedToDouble;
//            }
//            // Set West boundary
//            if(latConvertedToDouble < maxLatitudeWest)
//            {
//                maxLatitudeWest = latConvertedToDouble;
//            }
//            // Set North boundary
//            if(longConvertedToDouble < maxLongitudeNorth)
//            {
//                maxLongitudeNorth = longConvertedToDouble;
//            }
//            // Set South boundary
//            if(longConvertedToDouble > maxLongitudeSouth)
//            {
//                maxLongitudeSouth = longConvertedToDouble;
//            }
        }

        // Calculate center coordinates
//        double centerCoordinateY = (maxLongitudeSouth + ((maxLongitudeNorth - maxLongitudeSouth) / 2));
//        double centerCoordinateX = (maxLatitudeEast + ((maxLatitudeWest - maxLatitudeEast) / 2));
//        NSLog(@"CENTER Y: %d CENTER X: %d", centerCoordinateY, centerCoordinateX);

        // Set initial zoom
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.84, -87.70);
        MKCoordinateSpan span = MKCoordinateSpanMake(.3, .3);
        MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
        [self.mapView setRegion:region];
    }];
}

#pragma mark - AnnotationView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    [pin rightCalloutAccessoryView];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // Identifies selected pins and adds it to array
    NSArray *selectedAnnotations = [[NSArray alloc]initWithArray:[self.mapView selectedAnnotations]];
    MKPointAnnotation *selectedPin = [selectedAnnotations objectAtIndex:0];
    for(NSDictionary *eachDictionary in self.busStopsArray)
    {
        // Finds the selected bus stop in the array of dictionaries by matching the name
        if([eachDictionary[@"cta_stop_name"] isEqualToString:selectedPin.title])
        {
            self.selectedDictionary = eachDictionary;
            NSLog(@"%@",self.selectedDictionary);
        }
    }
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = [segue destinationViewController];
    detailVC.selectedBusStopDictionary = self.selectedDictionary;
}

@end
