//
//  Location.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "Location.h"

@implementation Location

// Returns location object with passed parameters
+(Location *)locationWithEntityType:(NSString *)entityType entityId:(NSString *)entityId title:(NSString *)title cityName:(NSString *)cityName countryName:(NSString *)countryName {
    Location *location = [[Location alloc] init];
    location.entity_type = entityType;
    location.entity_id = entityId;
    location.title = title;
    location.city_name = cityName;
    location.country_name = countryName;
    return location;
}

@end
