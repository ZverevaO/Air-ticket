//
//  TicketTableViewCell.m
//  AirTicket
//
//  Created by Оксана Зверева on 22.11.2020.
//

#import "TicketTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import "FavoriteTicket+CoreDataClass.h"
#import "Ticket.h"
#import "APIManager.h"


@interface TicketTableViewCell ()
//@property (nonatomic, weak) UIImageView *airlineLogoView;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *placesLabel;
@property (nonatomic, weak) UILabel *dateLabel;
@end



@implementation TicketTableViewCell

+ (NSString *)identifier {
    return @"TicketCellIdentifie";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *price =  [[UILabel alloc] initWithFrame:self.bounds];
        price.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:price];
        self.priceLabel = price;
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:self.bounds];
        //_airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        logo.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:logo];
        self.airlineLogoView = logo;
        
        [UIView animateWithDuration:1.0
                              delay: 3.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            logo.alpha = 0.0;
            
            [UIView animateWithDuration:1.0
                                  delay:4.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                logo.alpha = 1.0;
            }
                             completion:nil];
            
        }
                         completion:nil];
        
        
        UILabel *places = [[UILabel alloc] initWithFrame:self.bounds];
        places.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        places.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:places];
        self.placesLabel = places;
        
        UILabel *date = [[UILabel alloc] initWithFrame:self.bounds];
        date.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:date];
        self.dateLabel = date;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    self.priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    self.airlineLogoView.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    self.placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.priceLabel.frame) + 16.0, 100.0, 20.0);
    self.dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    self.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    self.dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    NSURL *urlLogo = [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png",ticket.airline]];
    [self.airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
    
}

- (void)setFavorite:(FavoriteTicket *)ticket {
    _favorite = ticket;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%lld  руб.", ticket.price];
    self.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    self.dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    if (ticket.airline) {
        NSURL *urlLogo = [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png",ticket.airline]];
        [self.airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
    }
   
    
}


@end
