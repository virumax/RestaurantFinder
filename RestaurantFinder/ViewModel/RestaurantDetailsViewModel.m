//
//  RestaurantDetailsViewModel.m
//  RestaurantFinder
//
//  Created by Virumax on 12/11/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "RestaurantDetailsViewModel.h"

@implementation RestaurantDetailsViewModel

// initialize viewModel with Restaurant value
- (instancetype)initWithSearchResult:(Restaurant *)result services:(id<ViewModelServices>)services {
    if (self = [super init]) {
        _restaurant = result;
        [self initialize];
    }
    return self;
}

// Bind model name and viewModel property
- (void)initialize {
    // Initialize with default value
    self.title = self.restaurant.name;
}
@end
