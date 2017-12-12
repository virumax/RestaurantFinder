//
//  DetailViewController.m
//  RestaurantFinder
//
//  Created by Virumax on 12/9/17.
//  Copyright © 2017 Virendra. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menu_image;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentOptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *featuredImageView;

@end

@implementation DetailViewController

// initialize view with viewmodel
- (instancetype)initWithViewModel:(RestaurantDetailsViewModel *)viewModel {
    self = [super init];
    if (self ) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [self bindViewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self bindViewModel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.ratingLabel.layer.cornerRadius = 3;
    self.ratingLabel.layer.masksToBounds = true;
    
    self.menu_image.layer.cornerRadius = 5;
    self.ratingLabel.layer.masksToBounds = true;
}

// Bind UI controls and their vlaues in view model
- (void)bindViewModel {
    self.title = self.viewModel.title;
    self.restaurantNameLabel.text = self.viewModel.restaurant.name;
    self.ratingLabel.text = self.viewModel.restaurant.rating;
    self.costLabel.text =  [NSString stringWithFormat:@"%@",self.viewModel.restaurant.costForTwoPersons];
    self.addressLabel.text = self.viewModel.restaurant.address;

    // Check whether featuredImageURL is valid or not
    if (self.viewModel.restaurant.featuredImageURL.length > 0) {
        NSString *imageURL = self.viewModel.restaurant.featuredImageURL;
        NSArray *imageURLParts = [self.viewModel.restaurant.featuredImageURL componentsSeparatedByString:@"?"]; // remove unnecessary components from URL
        
        if (imageURLParts.count > 0) {
            NSURL *url = [NSURL URLWithString:[imageURLParts firstObject]];
            if(url) {
                imageURL = [imageURLParts firstObject];
            }
        }
        [self.featuredImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                     placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
                                              options:SDWebImageRefreshCached];
    }
}
@end
