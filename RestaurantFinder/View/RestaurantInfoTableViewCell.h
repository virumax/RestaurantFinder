//
//  RestaurantInfoTableViewCell.h
//  RestaurantFinder
//
//  Created by Virumax on 12/10/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cell for showing restaurant info
@interface RestaurantInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *restaurantThumbImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *cuisines;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
