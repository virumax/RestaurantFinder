//
//  NetworkManager.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#define API_KEY @"c750173e8cf7e5fdc2c331cf897ee8c3"
#define HOST @"https://developers.zomato.com/api/"
#define API_VERSION @"v2.1"
#define BASE_URL [NSString stringWithFormat:@"%@%@/", HOST, API_VERSION]

#import "NetworkManager.h"
#import "MBProgressHUD.h"
#import "ReactiveObjC.h"
#import "Restaurant.h"
#import "RestaurantSearchResults.h"
#import "Location.h"
#import "LocationSearchResults.h"
#import "UIAlertController+CustomBlocks.h"

@interface NetworkManager()

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation NetworkManager
#pragma mark -
#pragma mark Constructors

static NetworkManager *sharedManager = nil;

+ (NetworkManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^
                  {
                      sharedManager = [[NetworkManager alloc] init];
                  });
    return sharedManager;
}

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (AFHTTPSessionManager*)getNetworkingManager {
    if (self.networkingManager == nil) {
        self.networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        self.networkingManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.networkingManager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"user-key"];
        self.networkingManager.responseSerializer.acceptableContentTypes = [self.networkingManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"application/json", @"text/json"]];
        self.networkingManager.securityPolicy = [self getSecurityPolicy];
    }
    return self.networkingManager;
}

- (id)getSecurityPolicy {
    return [AFSecurityPolicy defaultPolicy];
}

- (NSString*)getError:(NSError*)error {
    if (error != nil) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"message"] != nil && [[responseObject objectForKey:@"message"] length] > 0) {
            return [responseObject objectForKey:@"message"];
        }
    }
    return @"Server Error. Please try again later";
}

- (RACSignal *)fetchLocations:(NSString *)searchString {
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [UIAlertController showAlertViewWithTitle:@"Error" message:@"The Internet connection appears to be offline." button1:@"Ok"];
        return [RACSignal empty];
    }
    
    NSString *escapedSearchString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *apiString = [NSString stringWithFormat:@"locations?query=%@&count=10",escapedSearchString];
    
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self)
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [[self getNetworkingManager] GET:apiString parameters:params success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"Success");
            NSMutableArray *locationObjects = [NSMutableArray new];
            
            // Mapping the Location Response to Location object
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSArray *locations = [responseObject objectForKey:@"location_suggestions"];
                for (NSDictionary *locationInfoDict in locations) {
                    NSString *entityId = [locationInfoDict objectForKey:@"entity_id"];
                    NSString *entityType = [locationInfoDict objectForKey:@"entity_type"];
                    NSString *title = [locationInfoDict objectForKey:@"title"];
                    NSString *cityName = [locationInfoDict objectForKey:@"city_name"];
                    NSString *countryName = [locationInfoDict objectForKey:@"country_name"];
                    
                    Location *location = [Location locationWithEntityType:entityType entityId:entityId title:title cityName:cityName countryName:countryName];
                    [locationObjects addObject:location];
                }
            }
            
            if (locationObjects.count == 0) {//location does not exist
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"No Location" forKey:NSLocalizedDescriptionKey];
                // populate the error object with the details
                NSError *error = [NSError errorWithDomain:@"Location" code:200 userInfo:details];
                [subscriber sendError:error];
            }else {
                
                LocationSearchResults *results = [LocationSearchResults new];
                results.searchString = searchString;
                results.locations = locationObjects;
                
                [subscriber sendNext:results];
                [subscriber sendCompleted];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = operation;
            NSError *errorWithOperation = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            [subscriber sendError:errorWithOperation];
        }];
        return [RACDisposable disposableWithBlock:^{
            //            [op cancel];
        }];
    }] replayLazily];
}

- (RACSignal *)fetchRestaurantsForLocation:(Location *)location {
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [UIAlertController showAlertViewWithTitle:@"Error" message:@"The Internet connection appears to be offline." button1:@"Ok"];
        return [RACSignal empty];
    }
    
    NSString *apiString = [NSString stringWithFormat:@"location_details?entity_id=%@&entity_type=%@",location.entity_id,location.entity_type];
    
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self)
        [self showProgressHUD];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [[self getNetworkingManager] GET:apiString parameters:params success:^(NSURLSessionTask *task, id responseObject) {
            [self hideProgressHUD];
            
            NSLog(@"Success");
            NSMutableArray *restaurants = [NSMutableArray new];
            
            // Mapping the Restaurant Response to Location object
            if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *bestReatedRestaurants = [responseObject objectForKey:@"best_rated_restaurant"];
                for (NSDictionary *restaurantInfoDict in bestReatedRestaurants) {
                    NSDictionary *restaurantDict = [restaurantInfoDict objectForKey:@"restaurant"];
                    NSString *cuisines = [restaurantDict objectForKey:@"cuisines"];
                    NSString *name = [restaurantDict objectForKey:@"name"];
                    NSDictionary *ratingDict = [restaurantDict objectForKey:@"user_rating"];
                    NSString *aggregateRating = [ratingDict objectForKey:@"aggregate_rating"];
                    NSDictionary *locationDict = [restaurantDict objectForKey:@"location"];
                    NSString *address = [locationDict objectForKey:@"locality_verbose"];
                    NSString *thumb = [restaurantDict objectForKey:@"thumb"];
                    NSString *featuredImage = [restaurantDict objectForKey:@"featured_image"];
                    NSString *averageCostForPerson = [restaurantDict objectForKey:@"average_cost_for_two"];
                    Restaurant *restaurant = [Restaurant restaurantWithType:cuisines name:name address:address rating:aggregateRating thumb:thumb featuredImage:featuredImage costForTwo:averageCostForPerson];
                    [restaurants addObject:restaurant];
                }
            }
            if (restaurants.count == 0) {//restaurant does not exist
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"No Restaurant" forKey:NSLocalizedDescriptionKey];
                // populate the error object with the details
                NSError *error = [NSError errorWithDomain:@"Restaurant" code:200 userInfo:details];
                [subscriber sendError:error];
            }else {
                RestaurantSearchResults *results = [RestaurantSearchResults new];
                results.restaurants = restaurants;
                results.totalResults = restaurants.count;
                
                [subscriber sendNext:results];
                [subscriber sendCompleted];
            }
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [self hideProgressHUD];
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = operation;
            NSError *errorWithOperation = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            [subscriber sendError:errorWithOperation];
        }];
        return [RACDisposable disposableWithBlock:^{
            //            [op cancel];
        }];
    }] replayLazily];
}

#pragma mark - Manage ProgressHUD
- (void)showProgressHUD {
    [self hideProgressHUD];
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
    [self.progressHUD removeFromSuperViewOnHide];
    self.progressHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:1.0];
    self.progressHUD.contentColor = [UIColor whiteColor];
}

- (void)hideProgressHUD {
    if (self.progressHUD != nil) {
        [self.progressHUD hideAnimated:YES];
        [self.progressHUD removeFromSuperview];
        self.progressHUD = nil;
    }
}
@end
