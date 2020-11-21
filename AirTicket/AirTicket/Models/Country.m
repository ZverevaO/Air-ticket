//
//  Country.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
//        _currency = [dictionary valueForKey:@"currency"];
//        _translations = [dictionary valueForKey:@"name_translations"];
//        _name = [dictionary valueForKey:@"name"];
//        _code = [dictionary valueForKey:@"code"];
        self.currency = dictionary[@"currency"];
        self.translations = dictionary[@"name_translations"];
        self.name = dictionary[@"name"];
        self.code = dictionary[@"code"];
    }
    return self;
}

@end
