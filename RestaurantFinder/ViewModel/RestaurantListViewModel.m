//
//  RestaurantLisViewModel.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "RestaurantListViewModel.h"
#import "ResultsTableController.h"
#import "NetworkManager.h"
#import "Restaurant.h"
#import "ViewModelServices.h"
#import "UIAlertController+CustomBlocks.h"
#import "RestaurantSearchResults.h"
#import "LocationSearchResults.h"
#import "RestaurantDetailsViewModel.h"

@interface RestaurantListViewModel()

@property (nonatomic, weak) id<ViewModelServices> services;

@end

@implementation RestaurantListViewModel

- (instancetype) initWithServices:(id<ViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        [self initialize];
    }
    return self;
}

// Initialize with default values and define signals for monitoring values updated in view
- (void)initialize {
    
    // Initialize with default value ex. Bangalore and perform search
    self.searchText = @"";
    self.location = [Location locationWithEntityType:@"city" entityId:@"4" title:@"Bangalore" cityName:@"Bangalore" countryName:@"India"];
    
    // Execute search for default value
    [self executeSearch];
    
    // Signal to observer and validate search text
    RACSignal *validSearchSignal = [RACObserve(self, searchText)
                                     map:^id(NSString *text) {
                                         return @(text.length > 2);
                                     }];
    
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
        NSNumber *valid = (NSNumber *)x;
        if (valid.intValue) {
            [self executeLocationSearch];
        }
    }];

    // Signal to observer and validate location
    RACSignal *validLocationSignal = [RACObserve(self, location)
                                    map:^id(Location *location) {
                                        return @(location != nil);
                                    }];
    
    [validLocationSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@", x);
        NSNumber *valid = (NSNumber *)x;
        if (valid.intValue) {
            [self executeSearch];
        }
    }];
    
    // Signal to observer and validate defaultLocation, means if user taps search from keyboard without selecting location from list
    RACSignal *validDefaultLocationSignal = [RACObserve(self, defaultLocation)
                                      map:^id(Location *location) {
                                          if(location != nil) {
                                              self.location = location;
                                              return @(1);
                                          }else {
                                              return @(0);
                                          }
                                      }];
    
    [validDefaultLocationSignal subscribeNext:^(id x) {
        NSLog(@"selected location is valid %@", x);
        NSNumber *valid = (NSNumber *)x;
        if (valid.intValue) {
            [self executeSearch];
        }
    }];
    
    // Signal to observer and validate restaurant selected by the user
    RACSignal *validRestaurantSignal = [RACObserve(self, selectedRestaurant)
                                      map:^id(Restaurant *restaurant) {
                                          return @(restaurant != nil);
                                      }];
    
    [validRestaurantSignal subscribeNext:^(id x) {
        NSLog(@"Selected restaurant is valid %@", x);
        NSNumber *valid = (NSNumber *)x;
        if (valid.intValue) {
            RestaurantDetailsViewModel *restaurantDetailModel = [[RestaurantDetailsViewModel alloc] initWithSearchResult:self.selectedRestaurant services:self.services];
            [self.services pushViewModel:restaurantDetailModel];
        }
    }];
}

// Execute the restaurant search and update the RestaurantListView
- (void)executeSearch {
    [[[self.services getRestaurantSearchService] restaurantSearchSignal:self.location] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x");
        if(x && [x isKindOfClass:[RestaurantSearchResults class]]) {
            RestaurantSearchResults *results = (RestaurantSearchResults *)x;
            self.restaurants = [NSMutableArray arrayWithArray:results.restaurants];
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        [self handleError:error];
        [self.services pushViewModel:nil];
    } completed:^{
        NSLog(@"completed");
    }];
}

// Execute the location search and update the SearchResultsView
- (void)executeLocationSearch {
    [[[self.services getLocationSearchService] locationSearchSignal:self.searchText] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x");
        if(x && [x isKindOfClass:[LocationSearchResults class]]) {
            SearchResultsViewModel *resultsViewModel =
            [[SearchResultsViewModel alloc] initWithSearchResults:(LocationSearchResults *)x services:self.services];
            [self.services pushViewModel:resultsViewModel];
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
        [self handleError:error];
        [self.services pushViewModel:nil];
    } completed:^{
        NSLog(@"completed");
    }];
}

// Common method to handle and display alerts for API errors
- (void)handleError:(NSError *)error {
    if (error.code == 200) {
        if ([error.domain isEqualToString:@"Restaurant"]) {
            [UIAlertController showAlertViewWithTitle:@"Error" message:@"Sorry, we didn't find restaurant for this location." button1:@"Ok"];
        }else {
//            [UIAlertController showAlertViewWithTitle:@"Error" message:@"Sorry, we didn't find this location." button1:@"Ok"];
        }
    }else {
        if(error && error.localizedDescription.length > 0)
            [UIAlertController showAlertViewWithTitle:@"Error" message:error.localizedDescription button1:@"Ok"];
        else
            [UIAlertController showAlertViewWithTitle:@"Error" message:@"Ooops, Something went wrong. Please try again." button1:@"Ok"];
    }
}
@end
