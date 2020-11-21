//
//  ViewController.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"
#import "SearchRequest.h"
#import "City.h"
#import "Airport.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, weak) UIButton *departureButton;
@property (nonatomic, weak) UIButton *arrivalButton;

@property (nonatomic, assign) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData:) name:kDataManagerDidLoadData object:nil];
    
    //[[DataManager sharedInstance] loadData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    
    UIButton *depart = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //_departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [depart setTitle:@"From   " forState: UIControlStateNormal];
    depart.tintColor = [UIColor blackColor];
    depart.frame = CGRectMake(30.0, 140.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    depart.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [depart addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.departureButton = depart;
    [self.view addSubview:depart];
    
    
    UIButton *arrival = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //_arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [arrival setTitle:@"To" forState: UIControlStateNormal];
    arrival.tintColor = [UIColor blackColor];
    arrival.frame = CGRectMake(30.0, CGRectGetMaxY(_departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    arrival.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [arrival addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:arrival];
    self.arrivalButton = arrival;
    
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? self.departureButton : self.arrivalButton ];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }
    [button setTitle: title forState: UIControlStateNormal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didLoadData: (NSNotification *) notification {
    self.view.backgroundColor = [UIColor systemYellowColor];
}


@end
