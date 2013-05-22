//
//  ListViewController.m
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ListViewController.h"
#import "BusStop.h"
#import "BusDetailViewController.h"

@interface ListViewController ()
{
    __weak IBOutlet UITableView *__tableView;
}


@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBusStops:(NSMutableArray *)busStops
{
    _busStops = busStops;
    [__tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUInteger selectedRow = [__tableView indexPathForSelectedRow].row;
    
    ((BusDetailViewController *)segue.destinationViewController).busStop = self.busStops[selectedRow];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.busStops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"busStop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BusStop *busStop = self.busStops[indexPath.row];
    
    cell.textLabel.text = busStop.title;
    cell.detailTextLabel.text = busStop.subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"listToDetail" sender:self];
}

@end
