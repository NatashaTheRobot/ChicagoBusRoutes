//
//  ListViewController.h
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *busStops;

@end
