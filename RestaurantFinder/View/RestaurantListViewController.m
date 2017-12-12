//
//  ViewController.m
//  RestaurantFinder
//
//  Created by Virumax on 12/9/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "ResultsTableController.h"
#import "Restaurant.h"
#import "NetworkManager.h"
#import "ReactiveObjC.h"
#import "DetailViewController.h"
#import "RestaurantInfoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"RestaurantInfoTableViewCell";

@interface RestaurantListViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

// Secondary search results table view.
@property (nonatomic, strong) ResultsTableController *resultsTableController;

@end

@implementation RestaurantListViewController

// initialize view with viewmodel
- (instancetype)initWithViewModel:(RestaurantListViewModel *)viewModel {
    self = [super init];
    if (self ) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create results tablecontroller to set it as a searchResultController
    _resultsTableController = [[ResultsTableController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    
    if ([self.navigationItem respondsToSelector:@selector(setSearchController:)]) {
        // For iOS 11 and later, the search bar in the navigation bar.
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.searchController = self.searchController;
        
        // the search bar visible all the time.
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    }
    else {
        // For iOS 10 and earlier, the search bar in the table view's header.
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    // the delegate for this filtered table so didSelectRowAtIndexPath is called for both tables.
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    self.searchController.searchBar.placeholder = @"Enter location here";
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    // use a nib which contains the cell's view and this class as the files owner
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    [self bindViewModel];
}

// Bind UI controls and their vlaues in view model
- (void)bindViewModel {
    
    // Update viewModel searachText variable when user types in SearchBar
    @weakify(self)
    RAC(self.viewModel, searchText) = [[self rac_signalForSelector:@selector(updateSearchResultsForSearchController:) fromProtocol:@protocol(UISearchResultsUpdating)] map:^id(RACTuple *tuple) {
        if(tuple.first) {
            return self.searchController.searchBar.text;
        }else {
            return @"";
        }
    }];
    
    // Observer changes in Restaurants array and refresh the tableview
    [RACObserve(self.viewModel, restaurants) subscribeNext:^(NSArray *visibleItemsInSections) {
        @strongify(self)
        self.searchController.active = NO;
        [self.tableView reloadData];
    }];
    
    // Update viewModel defaultLocation variable when user taps Search button
    RAC(self.viewModel, defaultLocation) = [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)] map:^id(RACTuple *tuple) {
        if(tuple.first && self.resultsTableController.viewModel.locations.count > 0) {
            return self.resultsTableController.viewModel.locations[1]; // If user directly taps search button return first location by default
        }else {
            return @"";
        }
    }];
    
    // Update viewModel location variable when user selects location from SearchResults list
    RAC(self.viewModel, location) = [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] map:^id(RACTuple *tuple) {
        @strongify(self)
        if(tuple.first) {
            UITableView *tableView = (UITableView *)tuple.first;
            if(tableView != self.tableView) {
                NSIndexPath *indexPath = tuple.second;
                return self.resultsTableController.viewModel.locations[indexPath.row];
            }
            return nil;
        }else {
            return nil;
        }
    }];
    
    // Update viewModel selectedRestaurant variable when user selects restaurant from Restaurant list
    RAC(self.viewModel, selectedRestaurant) = [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] map:^id(RACTuple *tuple) {
        @strongify(self)
        if(tuple.first) {
            UITableView *tableView = (UITableView *)tuple.first;
            if(tableView == self.tableView) {
                NSIndexPath *indexPath = tuple.second;
                return self.viewModel.restaurants[indexPath.row];
            }
            return nil;
        }else {
            return nil;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

/** Called after the search controller's search bar has agreed to begin editing or when
 'active' is set to YES.
 If you choose not to present the controller yourself or do not implement this method,
 a default presentation is performed on your behalf.
 
 Implement this method if the default presentation is not adequate for your purposes.
 */
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantInfoTableViewCell *cell = (RestaurantInfoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Fetch restaurant object and update cell UI
    Restaurant *restaurant = self.viewModel.restaurants[indexPath.row];
    
    cell.restaurantName.text = restaurant.name;
    if (restaurant.thumbImageURL.length > 0) { // If thumb image does not exist showing placeholder
        [cell.restaurantThumbImage sd_setImageWithURL:[NSURL URLWithString:restaurant.thumbImageURL]
                                     placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
                                              options:SDWebImageRefreshCached];
    }
    cell.cuisines.text = restaurant.cuisine;
    cell.rating.text = [NSString stringWithFormat:@"Rating: %@", restaurant.rating];
    cell.address.text = restaurant.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.tableView) {
        return 122; // Rowheight for Restaurant cell
    }else {
        return 44; // Rowheight for lcoation suggestions cell
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}
@end
