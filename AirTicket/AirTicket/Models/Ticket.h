//
//  Ticket.h
//  AirTicket
//
//  Created by Оксана Зверева on 22.11.2020.
//

#import <Foundation/Foundation.h>
#import "MapPrice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ticket : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *airline;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *expiers;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithMapPrice:(MapPrice *) price;


@end

NS_ASSUME_NONNULL_END
