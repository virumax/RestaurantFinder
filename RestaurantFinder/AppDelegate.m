//
//  AppDelegate.m
//  RestaurantFinder
//
//  Created by Virumax on 12/9/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "AppDelegate.h"
#import "Restaurant.h"
#import "RestaurantListViewController.h"
#import "RestaurantListViewModel.h"
#import "ViewModelServicesImpl.h"

@interface AppDelegate ()

@property (strong, nonatomic) RestaurantListViewModel *viewModel;
@property (strong, nonatomic) ViewModelServicesImpl *viewModelServices;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self createInitialViewController];
    
    return YES;
}

- (void)createInitialViewController {
    UINavigationController *navigationController = (UINavigationController *)(self.window).rootViewController;
    
    // we want the first view controller
    RestaurantListViewController *viewController = (RestaurantListViewController *)navigationController.viewControllers[0];
    
    // initialize the glue between view and viewmodel that is viewModelServices
    self.viewModelServices = [[ViewModelServicesImpl alloc] initWithNavigationController:navigationController];
    self.viewModel = [[RestaurantListViewModel alloc] initWithServices:self.viewModelServices];
    
    // assign viewModel
    viewController.viewModel = self.viewModel;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
