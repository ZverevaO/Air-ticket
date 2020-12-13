//
//  TabBarController.m
//  AirTicket
//
//  Created by Оксана Зверева on 29.11.2020.
//

#import "TabBarController.h"

#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [self createViewControllers];
    self.tabBar.tintColor = [UIColor blackColor];
}

- (NSArray <UIViewController *> *)createViewControllers {
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray new];
    
    MainViewController *mainVC = [MainViewController new];
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search"
                                                      image:[UIImage systemImageNamed:@"magnifyingglass.circle"]
                                              selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle.fill"]];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [controllers addObject:mainNC];
    
    MapViewController *mapVC = [MapViewController new];
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Prices map"
                                                     image:[UIImage systemImageNamed:@"map"]
                                             selectedImage:[UIImage systemImageNamed:@"map.fill"]];
    UINavigationController *mapNC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [controllers addObject:mapNC];
    
    

    TicketsViewController *favVC = [[TicketsViewController alloc] initAsFavoriteTickets];
    favVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites"
                                                     image:[UIImage systemImageNamed:@"star"]
                                             selectedImage:[UIImage systemImageNamed:@"star.fill"]];
    UINavigationController *favNC = [[UINavigationController alloc] initWithRootViewController:favVC];
    [controllers addObject:favNC];
    
    return  controllers;
}


@end
