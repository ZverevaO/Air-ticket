//
//  DataManager.h
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@class City, Airport, Country;

#define kDataManagerDidLoadData @"DataManagerDidLoadData"

typedef enum {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager : NSObject

@property (nonatomic, strong, readonly) NSArray <Country *> *countries;
@property (nonatomic, strong, readonly) NSArray <City *> *cities;
@property (nonatomic, strong, readonly) NSArray <Airport *> *airports;
//@property (nonatomic, strong) NSArray <Country *> *countries;
//@property (nonatomic, strong) NSArray <City *> *cities;
//@property (nonatomic, strong) NSArray <Airport *> *airports;

//@property (nonatomic, strong) NSMutableArray *countriesArray;
//@property (nonatomic, strong) NSMutableArray *citiesArray;
//@property (nonatomic, strong) NSMutableArray *airportsArray;

+ (instancetype)sharedInstance;

- (void)loadData;

- (City *)cityForIATA:(NSString *)iata;
- (City *)cityForLocation:(CLLocation *)location;
@end

NS_ASSUME_NONNULL_END
