//
//  City.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "City.h"

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.timezone = dictionary[@"time_zone"];
        self.translations = dictionary[@"name_translations"];
        self.name = dictionary[@"name"];
        self.countryCode = dictionary[@"country_code"];
        self.code = dictionary[@"code"];
        NSDictionary *coords = dictionary[@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = coords[@"lon"];
            NSNumber *lat = coords[@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                self.coordinate = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
            }
        }
    }
    return self;
}

@end
