//
//  ViewController.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadData:) name:kDataManagerDidLoadData object:nil];
    
    [[DataManager sharedInstance] loadData];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didLoadData: (NSNotification *) notification {
    self.view.backgroundColor = [UIColor systemYellowColor];
}

@end
