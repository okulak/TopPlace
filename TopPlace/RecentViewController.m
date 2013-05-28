//
//  RecentViewController.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/27/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "RecentViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSArray *recents = [settings objectForKey:@"photoInfo"];    
    NSString *COUNT = @"count";
    NSSortDescriptor *countDescriptor = [[NSSortDescriptor alloc] initWithKey:COUNT ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:countDescriptor, nil];
    self.recents = [recents sortedArrayUsingDescriptors:descriptors];
    [self.tableView reloadData];
   }

- (void) viewWillAppear:(BOOL)animated
{
   
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
        cell.detailTextLabel.text = @"Unknow";
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",content];
    }
    if (!title || [title isEqualToString:@""])
    {
        cell.textLabel.text = @"Unknow";
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",title];
    }

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
