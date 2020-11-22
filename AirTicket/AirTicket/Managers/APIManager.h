//
//  APIManager.h
//  AirTicket
//
//  Created by Оксана Зверева on 22.11.2020.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "SearchRequest.h"


@class City;

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;

@end

NS_ASSUME_NONNULL_END
