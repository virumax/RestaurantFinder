//
//  ViewModelServices.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearch.h"
#import "LocationSearch.h"

// To use of the Model layer from within the ViewModel, this is protocol to be implemented
@protocol ViewModelServices <NSObject>

- (id<RestaurantSearch>) getRestaurantSearchService; // Restaurant search service
- (id<LocationSearch>) getLocationSearchService; // Location search service
- (void)pushViewModel:(id)viewModel; // navigation between views

@end
