//
//  LoopOverlay.m
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/21/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "LoopOverlay.h"

@implementation LoopOverlay

- (id)init
{
    self = [super init];
    
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake(41.878114, -87.629798);
        self.boundingMapRect = MKMapRectMake(41.888569, -87.635528,
                                             2000, 2000);
    }
    
//    min Longitude , min Latitude , max Longitude , max Latitude 
    
    return self;
}

@end
