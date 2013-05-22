//
//  ViewController.m
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/21/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ViewController.h"
#import "BusStop.h"
#import "BusDetailViewController.h"
#import "MetraAnnotationView.h"
#import "PaceAnnotationView.h"
#import "ListViewController.h"

@interface ViewController ()
{
    __weak IBOutlet MKMapView *__mapView;
    __weak IBOutlet UIView *__containerView;
    
    NSMutableArray *__busStops;
    ListViewController *__listViewController;
}

- (IBAction)mapListToggle:(id)sender;

- (void)getBusStops;
- (void)addPolygonOverlay;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    __busStops = [NSMutableArray array];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(41.878114, -87.629798);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    __mapView.region = region;
        
    [self getBusStops];
    [self addPolygonOverlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}

- (void)addPolygonOverlay
{
    CLLocationCoordinate2D  points[4];
    points[0] = CLLocationCoordinate2DMake(41.705374, -87.635528);
    points[1] = CLLocationCoordinate2DMake(41.705374, -87.603077);
    points[2] = CLLocationCoordinate2DMake(41.875568, -87.635528);
    points[3] = CLLocationCoordinate2DMake(41.875568, -87.603077);
    
    
    MKPolygon* poly = [MKPolygon polygonWithCoordinates:points count:4];
    poly.title = @"loop";
    poly.subtitle = @"the famous Chicago loop";
    [__mapView addOverlay:poly];
}

- (IBAction)mapListToggle:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {        
        
        [UIView animateWithDuration:0.5 animations:^{
            __mapView.alpha = 1;
            __containerView.alpha = 0;
        }];
        
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            __mapView.alpha = 0;
            __containerView.alpha = 1;
        }];
    }
}

- (void)getBusStops
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.heliumfoot.com/files/mobilemakers/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSArray *busStops = [responseDictionary objectForKey:@"row"];
                               
                               for (NSDictionary *busStopDictionary in busStops) {
                                   
                                   BusStop *busStop = [[BusStop alloc] init];
                                   busStop.title = [busStopDictionary objectForKey:@"cta_stop_name"];
                                   busStop.subtitle = [busStopDictionary objectForKey:@"routes"];
                                   busStop.coordinate = CLLocationCoordinate2DMake([[busStopDictionary objectForKey:@"latitude"] floatValue], [[busStopDictionary objectForKey:@"longitude"] floatValue]);
                                   
                                   busStop.direction = [busStopDictionary objectForKey:@"direction"];
                                   busStop.interModalTransfer = [busStopDictionary objectForKey:@"inter_modal"];
                                   
                                   [__mapView addAnnotation:busStop];
                                   [__busStops addObject:busStop];
                                   
                               }
                               
                                __listViewController.busStops = __busStops;
     
                            }];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier = @"reuseIdentifier";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        if ([((BusStop *)annotation).interModalTransfer isEqualToString:@"Metra"]) {
            annotationView = [[MetraAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else if ([((BusStop *)annotation).interModalTransfer isEqualToString:@"Pace"]){
            annotationView = [[PaceAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorPurple;
            ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
        }
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[BusDetailViewController class]]) {
        BusStop *selectedBusStop = [__mapView selectedAnnotations][0];
        
        ((BusDetailViewController *)segue.destinationViewController).busStop = selectedBusStop;
    } else if ([segue.destinationViewController isKindOfClass:[ListViewController class]]){
        __listViewController = (ListViewController *)segue.destinationViewController;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"mapToDetails" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id < MKOverlay >)overlay
{
    
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
        
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polygonView.lineWidth = 3;
        
        return polygonView;
    }
    
    return nil;
}

@end
