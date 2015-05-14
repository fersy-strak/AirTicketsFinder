//
//  NTSearchTicketParametersViewController.h
//  AviaTicketsFinder
//
//  Created by Надежда on 21.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTAirportFinderViewController.h"

@interface NTSearchTicketParametersViewController : UIViewController <NSURLConnectionDelegate, NTAirportFinderViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *depaturePointButton;
@property (nonatomic, strong) IBOutlet UIButton *arrivalPointButton;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UILabel *numberPassangersLabel;
@property (nonatomic, strong) IBOutlet UIStepper *numberPassangersStepper;
@property (nonatomic, strong) IBOutlet UISegmentedControl *comfortClassSegmentedControl;
@property (nonatomic, strong) IBOutlet UIButton *findTicketsButton;
@property (nonatomic, strong) IBOutlet UIProgressView *findTicketsProgressView;
@property (nonatomic, strong) IBOutlet UIButton *showResultsButton;

- (IBAction) changeNumberPassangers:(id) sender;
- (IBAction) startFindingTickets:(id) sender;

@end

