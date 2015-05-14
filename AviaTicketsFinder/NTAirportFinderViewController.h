//
//  NTAirportFinderViewController.h
//  AviaTicketsFinder
//
//  Created by Надежда on 27.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTCity.h"


@protocol NTAirportFinderViewControllerDelegate <NSObject>
@required
- (void)hasChoosehCity:(NTCity *)city withCityType:(NSString *)cityType;
@end


@interface NTAirportFinderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
                                                             NSURLConnectionDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, strong) IBOutlet UITableView *citiesTableView;

@property (strong, nonatomic) NSString *cityType;
@property (nonatomic, weak) id <NTAirportFinderViewControllerDelegate> delegate;


@end


