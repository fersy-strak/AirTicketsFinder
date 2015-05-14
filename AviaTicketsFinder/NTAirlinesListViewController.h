//
//  NTAirlinesListViewController.h
//  AviaTicketsFinder
//
//  Created by Надежда on 30.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTAirlinesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *airlinesTableView;
@property (nonatomic, strong) NSData *dataFromFares2;

@end
