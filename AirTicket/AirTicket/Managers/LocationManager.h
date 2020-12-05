//
//  LocationManager.h
//  AirTicket
//
//  Created by Оксана Зверева on 28.11.2020.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationManagerDidUpdateLocation @"LocationManagerDidUpdateLocation"

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject
@property (nonatomic, readonly) CLLocation *currentLocation; 
@end

NS_ASSUME_NONNULL_END
