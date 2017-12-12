//
//  Location.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model for holding Location parameters
@interface Location : NSObject

@property (nonatomic, copy) NSString *entity_type;
@property (nonatomic, copy) NSString *entity_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *country_name;

// Returns location object with passed parameters
+(Location *)locationWithEntityType:(NSString *)entityType entityId:(NSString *)entityId title:(NSString *)title cityName:(NSString *)cityName countryName:(NSString *)countryName;

@end
