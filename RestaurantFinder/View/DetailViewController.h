//
//  DetailViewController.h
//  RestaurantFinder
//
//  Created by Virumax on 12/9/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantDetailsViewModel.h"

@interface DetailViewController : UIViewController

- (instancetype)initWithViewModel:(RestaurantDetailsViewModel *)viewModel;
@property (strong, nonatomic) RestaurantDetailsViewModel *viewModel;

@end
