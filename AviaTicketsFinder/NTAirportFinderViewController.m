//
//  NTAirportFinderViewController.m
//  AviaTicketsFinder
//
//  Created by Надежда on 27.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import "NTCity.h"
#import "NTAirportFinderViewController.h"
#import "NTSearchTicketParametersViewController.h"

@interface NTAirportFinderViewController ()

@end


@implementation NTAirportFinderViewController

@synthesize navigationItem;
@synthesize citiesTableView;
@synthesize cityType;
@synthesize delegate;


NSMutableString *searchLowercaseString;
NSData *airportFinderData;
NSMutableArray *citiesSearchResult; //array of NTCity

- (void)viewDidLoad {
    [super viewDidLoad];

    [navigationItem setTitle:cityType];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    citiesSearchResult = [NSMutableArray array];
}

- (void)viewDidLayoutSubviews {
    //resize UITableViewWrapperView
    for (UIView *subview in citiesTableView.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"]) {
            subview.frame = CGRectMake(0, 0, citiesTableView.bounds.size.width, citiesTableView.bounds.size.height);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) convertAirportFinderDataToCitiesSearchResult {
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:airportFinderData options:1 error:NULL];
    
    [citiesSearchResult removeAllObjects];
    for (NSDictionary *airportInfo in [jsonData valueForKey:@"Array"]) {
        NSString *cityFromAirportInfo = [[[NSString alloc]
                                          initWithString:[airportInfo valueForKey:@"City"]]
                                          lowercaseString];
        
        if (cityFromAirportInfo && [cityFromAirportInfo hasPrefix:searchLowercaseString] &&
            [[airportInfo valueForKey:@"Code"] isEqualToString:[airportInfo valueForKey:@"CityCode"]]) {
            
            NTCity *city = [[NTCity alloc] initWithCity:[airportInfo valueForKey:@"City"]
                                               country:[airportInfo valueForKey:@"Country"]
                                              cityCode:[airportInfo valueForKey:@"CityCode"]];
            [citiesSearchResult addObject:city];
        }
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"tableView numberOfRowsInSection:");
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [citiesSearchResult count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[citiesSearchResult objectAtIndex:indexPath.row] cityCountryString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView didSelectRowAtIndexPath:");
    [self.delegate hasChoosehCity:[citiesSearchResult objectAtIndex:indexPath.row] withCityType:cityType];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)findCitiesUseSearchString:(NSString *)searchString scope:(NSString*)scope {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableString *urlString = [NSMutableString stringWithCapacity:85];
    [urlString setString:@"https://www.anywayanyday.com/AirportNames/?language=EN&filter="];
    [urlString appendString:searchString];
    [urlString appendString:@"&_Serialize=JSON"];
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection) {
        NSLog(@"Connection OK!!");
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Connection failed((");
    }
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
        shouldReloadTableForSearchString:(NSString *)searchString {

    searchLowercaseString = [NSMutableString stringWithString:[searchString lowercaseString]];
    
    if (searchString.length >= 2) {
        [self findCitiesUseSearchString:searchString
                                  scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                        selectedScopeButtonIndex]]];
    }
    else {
        //clear results of previous search
        [citiesSearchResult removeAllObjects];
    }
    
    return YES;
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Connection didReceiveData");
    
    airportFinderData = data;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Connection connectionDidFinishLoading");
    
    [self convertAirportFinderDataToCitiesSearchResult];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@", error);
}

@end
