//
//  NetworkManager.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class RACSignal;
@class Location;

typedef void (^NetworkManagerSuccess)(id responseObject);
typedef void (^NetworkManagerFailure)(NSError *error);

@interface NetworkManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *networkingManager;

+ (id)sharedManager;
- (RACSignal *)fetchLocations:(NSString *)searchString;
- (RACSignal *)fetchRestaurantsForLocation:(Location *)location;

@end
