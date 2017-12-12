//
//  SearchResultsViewModel.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//


#import "SearchResultsViewModel.h"

@interface ResultsTableController : UITableViewController

- (instancetype)initWithViewModel:(SearchResultsViewModel *)viewModel;

@property (strong, nonatomic) SearchResultsViewModel *viewModel;

@end
