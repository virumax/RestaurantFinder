//
//  LocationSearch.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "ReactiveObjC.h"
#import <Foundation/Foundation.h>

// Protocol for Location Search
@protocol LocationSearch <NSObject>

- (RACSignal *)locationSearchSignal:(NSString *)searchString;

@end
