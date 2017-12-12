//
//  RestaurantLisViewModel.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelServices.h"
#import "ReactiveObjC.h"

@class ResultsTableController;
@class Location;
@class Restaurant;

@interface RestaurantListViewModel : NSObject

// Initialize this viewModel with ViewModelServices
- (instancetype) initWithServices:(id<ViewModelServices>)services;

// Values to observe
@property (strong, nonatomic) NSString *searchText;
@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Location *defaultLocation;
@property (nonatomic, strong) Restaurant *selectedRestaurant;

// Secondary search results table view.
@property (nonatomic, strong) ResultsTableController *resultsTableController;

@end
