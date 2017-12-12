//
//  Restaurant.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

// Returns restaurant object with passed parameters
+ (Restaurant *)restaurantWithType:(NSString *)type name:(NSString *)name address:(NSString *)address rating:(NSString *)rating thumb:(NSString *)thumbImageURL featuredImage:(NSString *)featuredImage costForTwo:(NSString *)costForTwo{
    Restaurant *newRestaurant = [[self alloc] init];
    newRestaurant.cuisine = type;
    newRestaurant.name = name;
    newRestaurant.address = address;
    newRestaurant.rating = rating;
    newRestaurant.thumbImageURL = thumbImageURL;
    newRestaurant.featuredImageURL = featuredImage;
    newRestaurant.costForTwoPersons = costForTwo;
    return newRestaurant;
}

@end
