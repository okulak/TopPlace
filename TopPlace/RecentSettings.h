//
//  RecentSettings.h
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/24/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentSettings : NSObject

+ (RecentSettings*) sharedSettings;
- (void) addPhotoToRecentsWithURL:(NSString*)URL andPhotoID:(id) photoID;

@end
