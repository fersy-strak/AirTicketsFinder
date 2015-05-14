//
//  NTAirlineFares.m
//  AviaTicketsFinder
//
//  Created by Надежда on 30.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import "NTAirlineFares.h"

@implementation NTAirlineFares

@synthesize code;
@synthesize fares;

-(id)initWithCode:(NSString *)initCode andFares:(NSMutableArray *)initFares {
    if ( self = [super init] ) {
        self.code = initCode;
        self.fares = initFares;
    }
    return self;
}

-(id)initWithNTAirlineFares:(NTAirlineFares *)initAirlineFares {
    if ( self = [super init] ) {
        self.code = initAirlineFares.code;
        self.fares = initAirlineFares.fares;
    }
    return self;
}

-(void)sortFaresFromMinToMax {
    self.fares = [[self.fares sortedArrayUsingSelector: @selector(compare:)] mutableCopy];
}

-(NSString *)getStringCodeWithBestFare {
    NSNumber * bestFare = [self.fares valueForKeyPath:@"@min.doubleValue"];
    
    //create string
    NSMutableString *airlineBestFare = [NSMutableString stringWithCapacity:12];
    [airlineBestFare setString:self.code];
    [airlineBestFare appendString:@": "];
    [airlineBestFare appendString:[bestFare stringValue]];
    [airlineBestFare appendString:@" USD"];
    
    return airlineBestFare;
}

@end
