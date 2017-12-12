//
//  RestaurantSearchResults.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model for holding Results from Restaurant Search
@interface RestaurantSearchResults : NSObject

@property (strong, nonatomic) NSMutableArray *restaurants;
@property (nonatomic) NSUInteger totalResults;

@end
