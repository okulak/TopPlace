//
//  PhotoListViewController.h
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/23/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoListViewController : UITableViewController

@property (nonatomic, strong) NSArray *placeID;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSURL *photoURL;

@end
