//
//  ButStop.h
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/21/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusStop : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *direction;
@property (strong, nonatomic) NSString *interModalTransfer;

#pragma mark - MKAnnotation delegate properties
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;


@end
