//
//  PhotoViewController.h
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/24/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (nonatomic, strong) NSDictionary *photoInformaton;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSNumber *count;

@end
