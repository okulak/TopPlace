//
//  TopPlaceViewController.h
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/23/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopPlaceViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *photoID;
@property (nonatomic, strong) NSArray *placeList;
@end
