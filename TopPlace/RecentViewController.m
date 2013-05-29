//
//  RecentViewController.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/27/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "RecentViewController.h"
#import "PhotoViewController.h"

@interface RecentViewController ()

@end

@implementation RecentViewController
@synthesize recents = _resents;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSArray *recents = [settings objectForKey:@"photoInfo"];
    NSString *count = @"count";
    NSSortDescriptor *countDescriptor = [[NSSortDescriptor alloc] initWithKey:count ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:countDescriptor, nil];
    self.recents = [recents sortedArrayUsingDescriptors:descriptors];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{       
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRecent = [self.recents count];
    if (numberOfRecent > 50)
    {
        numberOfRecent = 50;
    }
    return numberOfRecent;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo list cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];    
    NSDictionary *photoDictionary = [self.recents objectAtIndex:indexPath.row];    
    NSString *title = [NSString stringWithFormat:@"%@",[photoDictionary objectForKey:@"title"]];
    NSDictionary *description = [photoDictionary objectForKey:@"description"];
    NSString *content = [NSString stringWithFormat:@"%@",[description objectForKey:@"_content"]];    
    if (!content || [content isEqualToString:@""])
    {
        cell.detailTextLabel.text = @"Unknown";
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",content];
    }
    if (!title || [title isEqualToString:@""])
    {
        cell.textLabel.text = @"Unknown";
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",title];
    }

    
    return cell;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotoViewController *fvc = (PhotoViewController*)segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    fvc.photoInformaton = [self.recents objectAtIndex:indexPath.row];
}


@end
