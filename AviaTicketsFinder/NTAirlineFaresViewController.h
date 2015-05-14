//
//  NTAvialineFaresViewController.h
//   AviaTicketsFinder
//
//  Created by Надежда on 30.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTAirlineFares.h"

@interface NTAirlineFaresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *airlineFaresTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic, strong) NTAirlineFares *airlineFares; //sorted fares from min to max NSNumber

@end
