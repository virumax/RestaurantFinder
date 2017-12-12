//
//  ViewController.h
//  RestaurantFinder
//
//  Created by Virumax on 12/9/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantListViewModel.h"

@interface RestaurantListViewController : UITableViewController

@property (weak, nonatomic) RestaurantListViewModel *viewModel;
@property (nonatomic, strong) UISearchController *searchController;

- (instancetype)initWithViewModel:(RestaurantListViewModel *)viewModel;

@end

