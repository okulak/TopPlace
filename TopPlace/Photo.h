//
//  Photo.h
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/27/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSDictionary *photo;

- (Photo *)initWithDictionary:(NSDictionary *) photoInfo;

@end
