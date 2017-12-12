//
//  SearchResultsViewModel.m
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "ResultsTableController.h"
#import "Location.h"

NSString *const kCellIdentifierID = @"cellID";

@interface ResultsTableController ()

@end

@implementation ResultsTableController

// initialize view with viewmodel
- (instancetype)initWithViewModel:(SearchResultsViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:kCellIdentifierID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifierID];
    }
    
    Location *location = self.viewModel.locations[indexPath.row];
    cell.textLabel.text = location.title;
    cell.detailTextLabel.text = location.country_name;
    
    return cell;
}

@end
