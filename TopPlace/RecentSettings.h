//
//  RecentSettings.h
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/24/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentSettings : NSObject

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSNumber *count;

+ (RecentSettings*) sharedSettings;
- (void) addPhotoToRecentsWithURL:(NSString*)URL andPhotoID:(NSString *) photoID andCount: (NSNumber *)count;

@end
