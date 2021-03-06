//
//  TicketTableViewCell.h
//  AirTicket
//
//  Created by Оксана Зверева on 22.11.2020.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
