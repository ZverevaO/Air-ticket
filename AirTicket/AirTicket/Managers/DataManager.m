//
//  DataManager.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "DataManager.h"
#import "City.h"
#import "Country.h"
#import "Airport.h"

@implementation DataManager

+ (instancetype)sharedInstance {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DataManager new];
    });
    return instance;
}

- (void)loadData {
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        
        NSArray *countriesJsonArray = [self arrayOfFile:@"countries" ofType:@"json"];
        self->_countries = [self createObjectsFromArray:countriesJsonArray withType:(DataSourceTypeCountry)];
        
        NSArray *citiesJsonArray = [self arrayOfFile:@"cities" ofType:@"json"];
        self->_cities = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayOfFile:@"airports" ofType:@"json"];
        self->_airports = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerDidLoadData object:nil];
        });
        
        NSLog(@"Complete load data");
    });
    
}

- (NSArray *)arrayOfFile:(NSString *)fileName ofType:(NSString *) type {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSMutableArray *)createObjectsFromArray:(NSArray *) array withType:(DataSourceType)type {
    NSMutableArray *results = [NSMutableArray new];
    
    for (NSDictionary *json in array) {
        switch (type) {
            case DataSourceTypeCountry: {
                Country *country = [[Country alloc] initWithDictionary:json];
                [results addObject:country];
                break;
            }
            case DataSourceTypeCity:{
                City *city = [[City alloc] initWithDictionary:json];
                [results addObject:city];
                break;
            }
            case DataSourceTypeAirport:{
                Airport *airport = [[Airport alloc] initWithDictionary: json];
                [results addObject:airport];
                break;
            }
        }
    }
    
    return  results;
}

- (City *)cityForIATA:(NSString *)iata {
    if (iata) {
        for (City *city in self.cities) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    return nil;
}

- (City *)cityForLocation:(CLLocation *)location {
    for (City *city in self.cities) {
        if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude) && ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)) {
            return city;
        }
    }
    return nil;
}


//- (NSArray *)countries
//{
//    return self.countriesArray;
//}
//
//- (NSArray *)cities
//{
//    return self.citiesArray;
//}
//
//- (NSArray *)airports
//{
//    return _airportsArray;
//}

@end
