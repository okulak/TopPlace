//
//  Photo.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/27/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "Photo.h"
#import "FlickrFetcher.h"
@interface Photo()

@end;

@implementation Photo
@synthesize photoURL = _photoURL;
@synthesize photoID = _photoID;
@synthesize count = _count;
@synthesize photo = _photo;

- (Photo *)initWithDictionary:(NSDictionary *) photoInfo
{    
    self.photoID = [photoInfo objectForKey:@"id"];
    if (![photoInfo objectForKey:@"count"])
    {
        self.count = [NSNumber numberWithInt:1];
    }
    else
    {
        int count = [photoInfo objectForKey:@"count"];
        count++;
        self.count = [NSNumber numberWithInt:count];
    }    
    self.photoURL = [FlickrFetcher urlStringForPhoto:photoInfo format:2];
    self.photo = photoInfo;
//    [photoInfo setValue:self.photoID forKey:@"id"];
//    [photoInfo setValue:self.photoURL forKey:@"photo_URL"];
//    [photoInfo setValue:self.count forKey:@"count"];
//    [self.photo addObject:photoInfo];
    
    
    
    
    return self;
}

@end
