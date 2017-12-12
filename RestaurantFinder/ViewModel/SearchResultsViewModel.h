//
//  SearchResultsViewModel.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelServices.h"
#import "LocationSearchResults.h"

@interface SearchResultsViewModel : NSObject

// to initialize viewModel with Locations array
- (instancetype)initWithSearchResults:(LocationSearchResults *)results services:(id<ViewModelServices>)services;

@property (strong, nonatomic) NSMutableArray *locations;

@end
