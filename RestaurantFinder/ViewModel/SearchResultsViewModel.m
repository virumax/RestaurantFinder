//
//  SearchResultsViewModel.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "SearchResultsViewModel.h"

@implementation SearchResultsViewModel

// initialize viewModel with Locations array to display in the list
- (instancetype)initWithSearchResults:(LocationSearchResults *)results services:(id<ViewModelServices>)services {
    if (self = [super init]) {
        _locations = results.locations;
    }
    return self;
}
@end
