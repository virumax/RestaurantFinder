//
//  ViewModelServicesImpl.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "ViewModelServicesImpl.h"
#import "RestaurantSearchImpl.h"
#import "LocationSearchImpl.h"
#import "ResultsTableController.h"
#import "RestaurantListViewController.h"
#import "RestaurantDetailsViewModel.h"
#import "DetailViewController.h"

@interface ViewModelServicesImpl ()

@property (strong, nonatomic) RestaurantSearchImpl *searchService;
@property (strong, nonatomic) LocationSearchImpl *locationSearchService;
@property (weak, nonatomic) UINavigationController *navigationController;

@end

@implementation ViewModelServicesImpl

// initialize viewModelService with default value for handling navigation
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        _searchService = [RestaurantSearchImpl new];
        _locationSearchService = [LocationSearchImpl new];
        _navigationController = navigationController;
    }
    return self;
}

// get the reference of RestaurantSearchService
- (id<RestaurantSearch>)getRestaurantSearchService {
    return self.searchService;
}

// get the reference of LocationSearchService
- (id<LocationSearch>)getLocationSearchService {
    return self.locationSearchService;
}

// Handle the navigation/routing of Views(viewcontrollers)
- (void)pushViewModel:(id)viewModel {
    
    RestaurantListViewController *viewController = (RestaurantListViewController *)self.navigationController.viewControllers[0];;
    
    ResultsTableController *tableController = (ResultsTableController *)viewController.searchController.searchResultsController;
    
    if (viewModel && [viewModel isKindOfClass:SearchResultsViewModel.class]) {
        // hand over the filtered results to our search results table
        tableController.viewModel = viewModel;
        [tableController.tableView reloadData];
    } else if (viewModel && [viewModel isKindOfClass:[RestaurantDetailsViewModel class]]) {
        // take the DetailsViewController instance from storyboard and push it with updated viewModel
        DetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.viewModel = viewModel;
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        // if no objects or datasource is present removeAllObjects and reload
        [tableController.viewModel.locations removeAllObjects];
        [tableController.tableView reloadData];
        NSLog(@"an unknown ViewModel was pushed!");
    }
}

@end
