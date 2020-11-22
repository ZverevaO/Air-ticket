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
#import "APIManager.h"
#import "TicketsViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, weak) UIView *placeContainerView;
@property (nonatomic, weak) UIButton *departureButton;
@property (nonatomic, weak) UIButton *arrivalButton;
@property (nonatomic, weak) UIButton *searchButton;

@property (nonatomic, assign) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData:) name:kDataManagerDidLoadData object:nil];
    [[DataManager sharedInstance] loadData];
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    
    UIView *placeView =  [[UIView alloc] initWithFrame:CGRectMake(20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
    //_placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
    placeView.backgroundColor = [UIColor whiteColor];
    placeView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    placeView.layer.shadowOffset = CGSizeZero;
    placeView.layer.shadowRadius = 20.0;
    placeView.layer.shadowOpacity = 1.0;
    placeView.layer.cornerRadius = 6.0;
    [self.view addSubview: placeView];
    self.placeContainerView = placeView;

    
    UIButton *depart = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //_departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [depart setTitle:@"From" forState: UIControlStateNormal];
    depart.tintColor = [UIColor blackColor];
    depart.frame = CGRectMake(10.0, 20.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
    depart.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    depart.layer.cornerRadius = 4.0;
    [depart addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.departureButton = depart;
    //[self.view addSubview:depart];
    [self.placeContainerView addSubview:depart];
    
    
    UIButton *arrival = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //_arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [arrival setTitle:@"To" forState: UIControlStateNormal];
    arrival.tintColor = [UIColor blackColor];
    arrival.frame = CGRectMake(10.0, CGRectGetMaxY(self.departureButton.frame) + 10.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
    arrival.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    arrival.layer.cornerRadius = 4.0;
    [arrival addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:arrival];
    self.arrivalButton = arrival;
    [self.placeContainerView addSubview:arrival];
    
   
    
    UIButton *search = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //_searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [search setTitle:@"Search" forState:UIControlStateNormal];
    search.tintColor = [UIColor whiteColor];
    search.frame = CGRectMake(30.0, CGRectGetMaxY(self.placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    search.backgroundColor = [UIColor blackColor];
    search.layer.cornerRadius = 8.0;
    search.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [search addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];
    self.searchButton = search;

    
}


- (void)searchButtonDidTap:(UIButton *)sender {
    
    [[APIManager sharedInstance] ticketsWithRequest:self.searchRequest withCompletion:^(NSArray * _Nonnull tickets) {
        if (tickets.count > 0) {
            TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketsViewController sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"No tickets found" preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
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

- (void) didLoadData: (NSNotification *)notifications {
    //self.view.backgroundColor = [UIColor systemYellowColor];
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self.departureButton];
    }];
}

//- (void)dataLoadedSuccessfully {
//    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
//        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self.departureButton];
//    }];
//}


@end
