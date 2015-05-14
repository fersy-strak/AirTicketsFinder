//
//  NTAirlinesListViewController.m
//  AviaTicketsFinder
//
//  Created by Надежда on 30.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import "NTAirlinesListViewController.h"
#import "NTAirlineFaresViewController.h"
#import "NTAirlineFares.h"

@interface NTAirlinesListViewController ()

@end


@implementation NTAirlinesListViewController

@synthesize airlinesTableView;
@synthesize dataFromFares2;

NSMutableArray *airlinesFaresArray;//array of NTAirlineFares

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title for back button to NTAirlinesListViewController
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //process income data
    [self convertDataFromFares2ToArrayNTAirlineFares];
    
    if ([airlinesFaresArray count] == 0) {
        NSLog(@"Sorry! Nothing tickets were found. Try another parameters of flight!");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.airlinesTableView deselectRowAtIndexPath:[self.airlinesTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) convertDataFromFares2ToArrayNTAirlineFares {
    NSDictionary *jsonDataFromFares2 = [NSJSONSerialization JSONObjectWithData:dataFromFares2 options:1 error:NULL];
    
    airlinesFaresArray = [NSMutableArray array];
    for (NSDictionary *airline in [jsonDataFromFares2 valueForKey:@"Airlines"]) {
        NSMutableArray *faresArray = [NSMutableArray array];
        for (NSDictionary *fare in [airline valueForKey:@"Fares"]) {
            [faresArray addObject:[NSNumber numberWithDouble:[[fare valueForKey:@"TotalAmount"] doubleValue]]];
        }
        
        NTAirlineFares *airlineFares = [[NTAirlineFares alloc] initWithCode:[airline valueForKey:@"Code"]
                                                                   andFares:faresArray];
        [airlinesFaresArray addObject:airlineFares];
    }
    
    [self.airlinesTableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (airlinesFaresArray)
        return [airlinesFaresArray count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"airlinesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [[airlinesFaresArray objectAtIndex:indexPath.row] getStringCodeWithBestFare];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAirlineFades"]) {
        NSIndexPath *indexPath = [self.airlinesTableView indexPathForSelectedRow];
        NTAirlineFares *airlineFares = [[NTAirlineFares alloc]
                                        initWithNTAirlineFares:[airlinesFaresArray objectAtIndex:indexPath.row]];
        [airlineFares sortFaresFromMinToMax];
        
        NTAirlineFaresViewController *avialineFaresViewController = segue.destinationViewController;   
        avialineFaresViewController.airlineFares = airlineFares;
    }
}

@end
