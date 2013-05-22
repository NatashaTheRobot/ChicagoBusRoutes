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
#import "LoopOverlay.h"
#import "OverlayView.h"
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

@property (strong, nonatomic) LoopOverlay *overlay;

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
    
    self.overlay = [[LoopOverlay alloc] init];
        
    [__mapView addOverlay:self.overlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}

- (IBAction)mapListToggle:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            __mapView.alpha = 1;
            __containerView.alpha = 0;
            break;
        case 1:
            __mapView.alpha = 0;
            __containerView.alpha = 1;
            break;
        default:
            __mapView.alpha = 1;
            __containerView.alpha = 0;
            break;
    }
    
    
//    [UIView animateWithDuration:0.5 animations:^{
//        dimmerView.alpha = 0.5;
//        containerView.alpha = 1;
//    }];
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
    
    OverlayView *mapOverlayView = [[OverlayView alloc] initWithOverlay:self.overlay];
    
    return mapOverlayView;

}

@end