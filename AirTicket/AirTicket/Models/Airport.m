//
//  Airport.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "Airport.h"

@implementation Airport

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.timezone = dictionary[@"time_zone"];
        self.translations = dictionary[@"name_translations"];
        self.countryCode = dictionary[@"country_code"];
        self.code = dictionary[@"code"];
        self.flightable = dictionary[@"flightable"];
        
//        _timezone = [dictionary valueForKey:@"time_zone"];
//        _translations = [dictionary valueForKey:@"name_translations"];
//        _name = [dictionary valueForKey:@"name"];
//        _countryCode = [dictionary valueForKey:@"country_code"];
//        _cityCode = [dictionary valueForKey:@"city_code"];
//        _code = [dictionary valueForKey:@"code"];
//        _flightable = [dictionary valueForKey:@"flightable"];
//        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        
        NSDictionary *coords = dictionary[@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
//            NSNumber *lon = [coords valueForKey:@"lon"];
//            NSNumber *lat = [coords valueForKey:@"lat"];
            NSNumber *lon = coords[@"lon"];
            NSNumber *lat = coords[@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                self.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
//                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    return self;
}

@end
