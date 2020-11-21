//
//  SearchRequest.m
//  AirTicket
//
//  Created by Оксана Зверева on 21.11.2020.
//

#import <Foundation/Foundation.h>

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destionation;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;
