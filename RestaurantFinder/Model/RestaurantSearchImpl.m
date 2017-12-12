//
//  RestaurantSearchImpl.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "RestaurantSearchImpl.h"
#import "RestaurantSearchResults.h"
#import "Restaurant.h"
#import "NetworkManager.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "Location.h"

@interface RestaurantSearchImpl ()

@property (strong, nonatomic) NSMutableSet *requests;

@end

@implementation RestaurantSearchImpl

- (instancetype)init {
    self = [super init];
    if (self) {
        _requests = [NSMutableSet new];
    }
    return  self;
}

// Fetch restaurants using the network layer
- (RACSignal *)restaurantSearchSignal:(Location *)location {
    return [[NetworkManager sharedManager] fetchRestaurantsForLocation:location];
}

@end
