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

#import "City.h"
#import "MapPrice.h"

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
@end
