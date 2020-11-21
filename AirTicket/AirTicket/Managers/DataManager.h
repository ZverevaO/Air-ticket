//
//  DataManager.h
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class City, Airport, Country;

#define kDataManagerDidLoadData @"DataManagerDidLoadData"

typedef enum {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager : NSObject

//@property (nonatomic, strong, readonly) NSArray <Country *> *countries;
//@property (nonatomic, strong, readonly) NSArray <City *> *cities;
//@property (nonatomic, strong, readonly) NSArray <Airport *> *airports;
@property (nonatomic, strong) NSArray <Country *> *countries;
@property (nonatomic, strong) NSArray <City *> *cities;
@property (nonatomic, strong) NSArray <Airport *> *airports;

+ (instancetype)sharedInstance;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END