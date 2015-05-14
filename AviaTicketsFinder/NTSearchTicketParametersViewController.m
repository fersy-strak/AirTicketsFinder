//
//  NTSearchTicketParametersViewController.m
//  AviaTicketsFinder
//
//  Created by Надежда on 21.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import "NTSearchTicketParametersViewController.h"
#import "NTCity.h"
#import "NTAirportFinderViewController.h"
#import "NTAirlinesListViewController.h"


@interface NTSearchTicketParametersViewController  ()

@end


@implementation NTSearchTicketParametersViewController

@synthesize depaturePointButton;
@synthesize arrivalPointButton;
@synthesize datePicker;
@synthesize numberPassangersLabel;
@synthesize numberPassangersStepper;
@synthesize comfortClassSegmentedControl;
@synthesize findTicketsButton;
@synthesize findTicketsProgressView;
@synthesize showResultsButton;

NSURLConnection *connToNewRequest2;
NSURLConnection *connToRequestState;
NSURLConnection *connToFares2;
NSData *dataFromNewRequest2;
NSData *dataFromRequestState;
NSData *dataFromFares2;
NSURLRequest* requestForConnToRequestState;
NTCity *depatureCity;
NTCity *arrivalCity;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //work with datePicker
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = 11;
    dateComponents.day = 30;
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate:[NSDate date]
                                                                  options:0];
    [datePicker setMaximumDate:newDate];
    
    //set start state
    [findTicketsButton setEnabled:NO];
    
    //set default value
    [findTicketsProgressView setProgress:0.f];
    
    //set title for back button to NTSearchTicketParametersViewController
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (depatureCity && arrivalCity) {
        [findTicketsButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) changeNumberPassangers:(id) sender {
    [numberPassangersLabel setText: [@(numberPassangersStepper.value) stringValue]];
}

- (IBAction) startFindingTickets:(id) sender {
    if (depatureCity && arrivalCity) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        //prepare date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM"];
        NSString *month = [formatter stringFromDate:datePicker.date];
        [formatter setDateFormat:@"dd"];
        NSString *day = [formatter stringFromDate:datePicker.date];
        
        NSString *comfortClass;
        if (comfortClassSegmentedControl.selectedSegmentIndex == 0) {
            comfortClass = @"E";
        }
        else if (comfortClassSegmentedControl.selectedSegmentIndex == 1) {
            comfortClass = @"B";
        }
        else {
            NSLog(@"Wrong value in comfortClassSegmentedControl.selectedSegmentIndex!");
        }
        
        //build urlString
        NSMutableString *urlString = [NSMutableString stringWithCapacity:100];
        [urlString setString:@"https://www.anywayanyday.com/api2/NewRequest2/?Route="];
        [urlString appendString:day];
        [urlString appendString:month];
        [urlString appendString:depatureCity.cityCode];
        [urlString appendString:arrivalCity.cityCode];
        [urlString appendString:@"AD"];
        [urlString appendString:numberPassangersLabel.text];
        [urlString appendString:@"CN0IN0SC"];
        [urlString appendString:comfortClass];
        [urlString appendString:@"&_Serialize=JSON"];
        NSLog(@"urlStringForConnToNewRequest2 = %@", urlString);

        
        NSURL* url = [NSURL URLWithString:urlString];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        connToNewRequest2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connToNewRequest2) {
            NSLog(@"Connection OK!!");
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSLog(@"Connection failed((");
        }
    }
}


#pragma mark - NTAirportFinderViewControllerDelegate

- (void)hasChoosehCity:(NTCity *)city withCityType:(NSString *)cityType{
    if ([cityType isEqualToString:@"Depature city"]) {
        [depaturePointButton setTitle:[city cityCountryString] forState:UIControlStateNormal];
        depatureCity = [[NTCity alloc] initWithNTCity:city];
    }
    else if ([cityType isEqualToString:@"Arrival city"]) {
        [arrivalPointButton setTitle:[city cityCountryString] forState:UIControlStateNormal];
        arrivalCity = [[NTCity alloc] initWithNTCity:city];
    }
    else {
        NSLog(@"Unproccess type of cityType!");
    }
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == connToNewRequest2){
        dataFromNewRequest2 = data;
    }
    else if(connection == connToRequestState){
        dataFromRequestState = data;
    }
    else if(connection == connToFares2){
        dataFromFares2 = data;
    }
    else {
        NSLog(@"Unproccess connection in connection:didReceiveData:!");
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection == connToNewRequest2){
        //build urlString with dataFromNewRequest2
        NSDictionary *jsonDataFromNewRequest2 = [NSJSONSerialization JSONObjectWithData:dataFromNewRequest2 options:1 error:NULL];
        NSMutableString *urlString = [NSMutableString stringWithCapacity:100];
        [urlString setString:@"https://www.anywayanyday.com/api2/RequestState/?R="];
        [urlString appendString:[jsonDataFromNewRequest2 valueForKey:@"IdSynonym"]];
        [urlString appendString:@"&_Serialize=JSON"];
        NSLog(@"urlStringForConnToRequestState = %@", urlString);
        
        NSURL* url = [NSURL URLWithString:urlString];
        requestForConnToRequestState = [NSURLRequest requestWithURL:url];
        connToRequestState = [[NSURLConnection alloc] initWithRequest:requestForConnToRequestState delegate:self];
    }
    else if(connection == connToRequestState){
        NSDictionary *jsonDataFromRequestState = [NSJSONSerialization JSONObjectWithData:dataFromRequestState options:1 error:NULL];
        //show proccess
        NSInteger percentageProgress = [[jsonDataFromRequestState valueForKey:@"Completed"] integerValue];
        float progress = (float) percentageProgress/100;
        [findTicketsProgressView setProgress:progress];
        
        if (percentageProgress < 100) {
            //create interval for update progress in findTicketsProgressView
            [NSThread sleepForTimeInterval:0.2];
            connToRequestState = [[NSURLConnection alloc] initWithRequest:requestForConnToRequestState delegate:self];
        }
        else if (percentageProgress == 100) {
            //build urlString with dataFromNewRequest2
            NSDictionary *jsonDataFromNewRequest2 = [NSJSONSerialization JSONObjectWithData:dataFromNewRequest2 options:1 error:NULL];
            NSMutableString *urlString = [NSMutableString stringWithCapacity:100];
            [urlString setString:@"https://www.anywayanyday.com/api2/Fares2/?L=EN&C=USD&DebugFullNames=true&_Serialize=JSON&R="];
            [urlString appendString:[jsonDataFromNewRequest2 valueForKey:@"IdSynonym"]];
            NSLog(@"urlStringForConnToFares2 = %@", urlString);
            
            NSURL* url = [NSURL URLWithString:urlString];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            connToFares2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else {
            NSLog(@"Wrong percentageProgress in connToRequestState: >100!");
        }
    }
    else if(connection==connToFares2){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //show results of search
        [showResultsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {
        NSLog(@"Unproccess connection in connectionDidFinishLoading:!");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@", error);
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseDepatureCity"]) {
        NTAirportFinderViewController *airportFinderViewController = segue.destinationViewController;
        airportFinderViewController.delegate = self;
        airportFinderViewController.cityType = @"Depature city";
    }
    else if ([segue.identifier isEqualToString:@"chooseArrivalCity"]) {
        NTAirportFinderViewController *airportFinderViewController = segue.destinationViewController;
        airportFinderViewController.delegate = self;
        airportFinderViewController.cityType = @"Arrival city";
    }
    else if ([segue.identifier isEqualToString:@"showAviaCompaniesList"]) {
        NTAirlinesListViewController *aviaCompaniesListViewController = segue.destinationViewController;
        aviaCompaniesListViewController.dataFromFares2 = dataFromFares2;
        
        [findTicketsProgressView setProgress:0.f];
    }
    else {
        NSLog(@"Unproccess type of segue!");
    }
}

@end































