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
- (id)initWithPhotoID:(NSString *)photoID photoURL:(NSString *)photoURL count:(NSNumber *)count;


@end


@implementation RecentSettings
@synthesize photoURL = _photoURL;
@synthesize photoID = _photoID;
@synthesize count = _count;

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

- (void) addPhotoToRecentsWithURL:(NSString*)URL andPhotoID:(id) photoID andCount:(NSNumber *)count
{
   
    
    
    NSDictionary *photoInfo = [NSDictionary new];
    [photoInfo setValue:URL forKey:@"photoURL"];
    
    NSMutableArray *array = [NSMutableArray array];
    // создаем и кладем photoInfo в массив
   
    [array addObject:[settings initWithPhotoID:self.photoID photoURL:self.photoURL count:self.count]];
   
     // поля, по которым будет выполняться сортировка.
    // они должны строго соответствовать переменным класса Student.
    NSString *COUNT = @"count";
  
    
    // создаем объекты класса NSSortDescriptor, которые будут использоваться для сортировки
    NSSortDescriptor *countDescriptor = [[NSSortDescriptor alloc] initWithKey:COUNT ascending:YES
                                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
        
    // в данном случае сортировка будет вначале производиться по ФИО, а затем по факультету.
    // если же дескрипторы поменять местами, то сначала отсортировано будет по факультету, а затем по ФИО.
    NSArray *descriptors = [NSArray arrayWithObjects:countDescriptor, nil];
    
    // непостредственно сортируем массив, используя ранее созданные десктрипторы
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:descriptors];
    // сейчас массив уже отсортирован
   
    
    [settings.defaults synchronize];

}


@end
