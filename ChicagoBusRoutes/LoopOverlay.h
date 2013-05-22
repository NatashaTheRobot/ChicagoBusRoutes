//
//  LoopOverlay.h
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/21/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LoopOverlay : NSObject <MKOverlay>

@property (nonatomic, assign) MKMapRect boundingMapRect;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
