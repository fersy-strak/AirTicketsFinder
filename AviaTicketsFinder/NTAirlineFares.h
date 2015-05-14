//
//  NTAirlineFares.h
//  AviaTicketsFinder
//
//  Created by Надежда on 30.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTAirlineFares : NSObject

@property NSString *code;           //airline code
@property NSMutableArray *fares;    //array of double

-(id)initWithCode:(NSString *)initCode andFares:(NSMutableArray *)initFares;
-(id)initWithNTAirlineFares:(NTAirlineFares *)initAirlineFares;

-(void)sortFaresFromMinToMax;
-(NSString *)getStringCodeWithBestFare;

@end
