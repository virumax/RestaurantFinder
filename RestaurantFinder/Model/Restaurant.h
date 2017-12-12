//
//  Restaurant.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model for holding Restaurant parameters
@interface Restaurant : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *thumbImageURL;
@property (nonatomic, assign) BOOL homeDeliveryAvailable;
@property (nonatomic, assign) BOOL isDeliveringNow;
@property (nonatomic, copy) NSString *cuisine;
@property (nonatomic, copy) NSString *featuredImageURL;
@property (nonatomic, copy) NSString *costForTwoPersons;

// Returns restaurant object with passed parameters
+ (Restaurant *)restaurantWithType:(NSString *)type name:(NSString *)name address:(NSString *)address rating:(NSString *)rating thumb:(NSString *)thumbImageURL featuredImage:(NSString *)featuredImage costForTwo:(NSString *)costForTwo;

@end
