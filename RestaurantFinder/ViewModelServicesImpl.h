//
//  ViewModelServicesImpl.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelServices.h"

// To connect the Model and ViewModel. Implementation of ViewModelServices
@interface ViewModelServicesImpl : NSObject <ViewModelServices>

// Initialize with root Navigation controller
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
