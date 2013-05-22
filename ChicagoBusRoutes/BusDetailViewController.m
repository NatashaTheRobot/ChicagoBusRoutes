//
//  BusDetailViewController.m
//  ChicagoBusRoutes
//
//  Created by Natasha Murashev on 5/21/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "BusDetailViewController.h"

@interface BusDetailViewController ()
{
    __weak IBOutlet UILabel *__titleLabel;
    __weak IBOutlet UILabel *__directionLabel;
    __weak IBOutlet UITextView *__routesTextView;
    __weak IBOutlet UILabel *__interModalLabel;
    
}

@end

@implementation BusDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    __titleLabel.text = self.busStop.title;
    __directionLabel.text = self.busStop.direction;
    __routesTextView.text = self.busStop.subtitle;
    __interModalLabel.text = self.busStop.interModalTransfer;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
