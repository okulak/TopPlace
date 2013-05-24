//
//  RecentSettings.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/24/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "RecentSettings.h"

static RecentSettings* settings = nil;

@interface RecentSettings ()

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSMutableDictionary* defaultSettings;

@end


@implementation RecentSettings

+ (RecentSettings*) sharedSettings
{
    if (settings == nil)
    {
        settings = [RecentSettings new];
        settings.defaults = [NSUserDefaults standardUserDefaults];
        settings.defaultSettings = [[NSMutableDictionary alloc]init];
        [settings.defaults synchronize];
    }
    return settings;
}

- (void) addPhotoToRecentsWithURL:(NSString*)URL andPhotoID:(id) photoID
{
    NSURL *link = [NSURL URLWithString:URL];
    [settings.defaultSettings setObject:link forKey:photoID];
    NSString *key = [NSString stringWithFormat:@"Recents"];
    [settings.defaults setObject:settings.defaultSettings forKey:key];
    [settings.defaults synchronize];
    
}


@end
