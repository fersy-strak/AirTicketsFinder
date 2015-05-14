//
//  NTCity.m
//  AviaTicketsFinder
//
//  Created by Надежда on 28.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import "NTCity.h"

@implementation NTCity

@synthesize city;
@synthesize country;
@synthesize cityCode;

-(id)initWithCity:(NSString *)initCity country:(NSString *)initCountry cityCode:(NSString *)initCityCode {
    if ( self = [super init] ) {
        self.city = initCity;
        self.country = initCountry;
        self.cityCode = initCityCode;
    }
    return self;
}

-(id)initWithNTCity:(NTCity *)initCity {
    if ( self = [super init] ) {
        self.city = initCity.city;
        self.country = initCity.country;
        self.cityCode = initCity.cityCode;
    }
    return self;
}

-(NSString *)cityCountryString {
    NSMutableString *cityInfo = [NSMutableString stringWithCapacity:30];
    [cityInfo setString:self.city];
    [cityInfo appendString:@", "];
    [cityInfo appendString:self.country];
    
    return (NSString *)cityInfo;
}

@end
