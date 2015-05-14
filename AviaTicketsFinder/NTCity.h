//
//  NTCity.h
//  AviaTicketsFinder
//
//  Created by Надежда on 28.04.15.
//  Copyright (c) 2015 fs_lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTCity : NSObject

@property NSString *city;
@property NSString *country;
@property NSString *cityCode;

-(id)initWithCity:(NSString *)initCity country:(NSString *)initCountry cityCode:(NSString *)initCityCode;
-(id)initWithNTCity:(NTCity *)initCity;

-(NSString *)cityCountryString;

@end
