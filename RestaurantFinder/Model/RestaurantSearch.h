//
//  RestaurantSearch.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "ReactiveObjC.h"
#import <Foundation/Foundation.h>
#import "Location.h"

// Protocol for Restaurant Search
@protocol RestaurantSearch <NSObject>

- (RACSignal *)restaurantSearchSignal:(Location *)location;

@end

