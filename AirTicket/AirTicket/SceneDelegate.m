//
//  SceneDelegate.m
//  AirTicket
//
//  Created by Оксана Зверева on 16.11.2020.
//

#import "SceneDelegate.h"
#import "MainViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    UIWindow *window = [[UIWindow alloc] initWithFrame:windowScene.coordinateSpace.bounds];
    window.windowScene = windowScene;
    
    MainViewController *vc = [MainViewController new];
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = window;
    [window makeKeyAndVisible]; 
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
  
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
  
}


- (void)sceneWillResignActive:(UIScene *)scene {
 
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
  
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
  
}


@end
