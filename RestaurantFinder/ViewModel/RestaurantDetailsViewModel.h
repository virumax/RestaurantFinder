//
//  RestaurantDetailsViewModel.h
//  RestaurantFinder
//
//  Created by Virumax on 12/11/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "ViewModelServices.h"

@interface RestaurantDetailsViewModel : NSObject

// initialize viewModel with Restaurant value
- (instancetype)initWithSearchResult:(Restaurant *)result services:(id<ViewModelServices>)services;

@property (strong, nonatomic) Restaurant *restaurant;
@property (strong, nonatomic) NSString *title;
@end
