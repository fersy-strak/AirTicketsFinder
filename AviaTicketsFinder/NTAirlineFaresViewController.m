//
//  NTAvialineFaresViewController.m
//   AviaTicketsFinder
//
//  Created by Надежда on 30.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import "NTAirlineFaresViewController.h"


@interface NTAirlineFaresViewController ()

@end

@implementation NTAirlineFaresViewController

@synthesize airlineFaresTableView;
@synthesize navigationItem;
@synthesize airlineFares;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [navigationItem setTitle:airlineFares.code];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [airlineFares.fares count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"faresCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSMutableString *cellText = [NSMutableString stringWithCapacity:10];
    [cellText setString:[[airlineFares.fares objectAtIndex:indexPath.row] stringValue]];
    [cellText appendString:@" USD"];

    cell.textLabel.text = cellText;
    
    return cell;
}

@end
