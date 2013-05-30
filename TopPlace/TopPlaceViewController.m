//
//  TopPlaceViewController.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/23/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "TopPlaceViewController.h"
#import "FlickrFetcher.h"
#import "PhotoListViewController.h"

@interface TopPlaceViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation TopPlaceViewController
@synthesize photoID = _photoID;
@synthesize placeList = _placeList;


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
    [self.tableView addSubview:self.spinner];
    self.spinner.center = self.tableView.center;
    self.photoID = [NSMutableDictionary dictionary];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"Data Processing Queue"];
    __weak TopPlaceViewController *weakself = self;
    [queue addOperationWithBlock:^{
        NSArray *placeList = [FlickrFetcher topPlaces];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakself.placeList = placeList;
            [self.spinner stopAnimating];
            [weakself.tableView reloadData];
        }];
    }];


    
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
    return [self.placeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top place cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *placeList = [self.placeList objectAtIndex:indexPath.row];
    NSString *place = [NSString stringWithFormat:@"%@",[placeList valueForKey:@"woe_name"]];
    NSString *location = [NSString stringWithFormat:@"%@",[placeList valueForKey:@"_content"]];
    NSArray *placeID = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[placeList valueForKey:@"place_id"]]];
    NSString *key = [NSString stringWithFormat:@"%i", indexPath.row];
    [self.photoID setObject:placeID forKey:key];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",place];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",location];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotoListViewController *flvc = (PhotoListViewController*)segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *key = [NSString stringWithFormat:@"%i", indexPath.row];
    flvc.placeID = @[[self.photoID objectForKey:key]];
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
//    NSArray *photos = [FlickrFetcher photosInPlace:self.photoID maxResults:50];
}

@end
