//
//  Ticket.m
//  AirTicket
//
//  Created by Оксана Зверева on 22.11.2020.
//

#import "Ticket.h"
#import "MapPrice.h"

@implementation Ticket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _airline = [dictionary valueForKey:@"airline"];
        _expiers = dateFromString([dictionary valueForKey:@"expires_at"]);
        _departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        _flightNumber = [dictionary valueForKey:@"flight_number"];
        _price = [dictionary valueForKey:@"price"];
        _returnDate = dateFromString([dictionary valueForKey:@"return_at"]);
    }
    return self;
}

//создаем билет из MapPrice для сохранения в избранных
- (instancetype)initWithMapPrice:(MapPrice *) price {
    self = [super init];
    if (self) {
        self.airline = @"";
        self.expiers = price.departure;
        self.departure = price.departure;
        self.flightNumber = [NSNumber numberWithInt:111];
        self.price = [NSNumber numberWithLong: price.value];
        self.returnDate = price.returnDate;
        self.from = price.origin.code;
        self.to = price.destination.code;
    }
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if (!dateString) { return  nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *correctSrtingDate = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    correctSrtingDate = [correctSrtingDate stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString: correctSrtingDate];
}


@end
