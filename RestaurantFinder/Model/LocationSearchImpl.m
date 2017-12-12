//
//  LocationSearchImpl.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "LocationSearchImpl.h"
#import "LocationSearchResults.h"
#import "Location.h"
#import "NetworkManager.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>

@interface LocationSearchImpl()

@property (strong, nonatomic) NSMutableSet *requests;

@end

@implementation LocationSearchImpl

- (instancetype)init {
    self = [super init];
    if (self) {
        _requests = [NSMutableSet new];
    }
    return  self;
}

// Fetch locations using the network layer
- (RACSignal *)locationSearchSignal:(NSString *)searchString {
    return [[NetworkManager sharedManager] fetchLocations:searchString];
}

@end
