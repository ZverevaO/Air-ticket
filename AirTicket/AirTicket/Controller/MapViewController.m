//
//  MapViewController.m
//  AirTicket
//
//  Created by Оксана Зверева on 28.11.2020.
//
#import <MapKit/MapKit.h>

#import "MapViewController.h"

#import "APIManager.h"
#import "DataManager.h"
#import "LocationManager.h"
#import "CoreDataManager.h"

#import "City.h"
#import "MapPrice.h"
#import "Ticket.h"

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *manager;
@property (nonatomic, strong) City *origin;
@property (nonatomic, copy) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"Prices map";
    
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    map.delegate = self;
    [self.view addSubview: map];
    self.mapView = map;
    
  
    
    [[DataManager sharedInstance] loadData];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(didloadData) name:kDataManagerDidLoadData object:nil];
    [nc addObserver:self selector:@selector(didUpdateLocation:) name:kLocationManagerDidUpdateLocation object:nil];
    
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) didloadData {
    self.manager = [LocationManager new];
}

-(void) didUpdateLocation:(NSNotification *)notification {
    CLLocation * location = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000000, 1000000);
    [self.mapView setRegion:region animated:YES];
    
    if (location) {
        self.origin = [[DataManager sharedInstance] cityForLocation:location];
        NSLog(@"город %@",self.origin);
        if (self.origin) {
            [[APIManager sharedInstance] mapPricesFor:self.origin withCompletion:^(NSArray * _Nonnull prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void) setPrices:(NSArray *)prices {
    _prices = [prices copy];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (MapPrice * price in prices) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
        annotation.subtitle = [NSString stringWithFormat: @"%ld руб.", (long)price.value];
        annotation.coordinate = price.destination.coordinate;
        [self.mapView addAnnotation:annotation];
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Ticket actions" message:@"What do you want to do with the ticket?" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action;
   
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil];
    MapPrice *price = [self getPriceByCity:view.annotation.coordinate];
    
    Ticket *ticket = [[Ticket alloc] initWithMapPrice:price];
    NSLog(@"Ticket 121311= %@", ticket.from);
    
    
    CoreDataManager *manager = [CoreDataManager sharedInstance];
    if ([manager isFavorite:ticket]) {
        action = [UIAlertAction actionWithTitle:@"Remove from favorites" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [manager removeFromFavorite:ticket];
        }];
    } else
    {
        action = [UIAlertAction actionWithTitle:@"Add to favorites" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [manager addToFavorite:ticket];
        }];
    }
    
    [sheet addAction:action];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

-(MapPrice *)getPriceByCity: (CLLocationCoordinate2D) coordinate {
    MapPrice *resultPrice;
    NSArray *mprices = self.prices;
    
    for (MapPrice * price in mprices) {
        if (price.destination.coordinate.latitude == coordinate.latitude && price.destination.coordinate.longitude == coordinate.longitude) {
            resultPrice = price;
        };
    }
    
    return resultPrice;
}

@end
