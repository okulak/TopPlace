//
//  PhotoListViewController.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/23/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "PhotoListViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "Photo.h"

@interface PhotoListViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableDictionary *cellPhoto;
@property (strong, nonatomic) NSOperationQueue* queue;

@end

@implementation PhotoListViewController
@synthesize placeID = _placeID;
@synthesize photos = _photos;
@synthesize keys = _keys;
@synthesize place = _place;
@synthesize count = _count;
@synthesize photoURL = _photoURL;
@synthesize cellPhoto = _cellPhoto;


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
    self.cellPhoto = [NSMutableDictionary new];
    [self.tableView addSubview:self.spinner];
    self.spinner.center = self.tableView.center;
    self.queue = [[NSOperationQueue alloc]init];
    [self.queue setName:@"Data Processing Queue"];
    __weak PhotoListViewController *weakself = self;
    [self.queue addOperationWithBlock:^{
        weakself.keys = [NSArray arrayWithObject:@"place_id"];
        weakself.place = [[NSDictionary alloc] initWithObjects:weakself.placeID forKeys:weakself.keys];
        NSArray *photoDictionaries = [FlickrFetcher photosInPlace: weakself.place maxResults:50];
        NSMutableArray* photoDictionariesWithStatistic = [[NSMutableArray alloc]initWithCapacity:photoDictionaries.count];
        for (NSDictionary* photoDictionary in photoDictionaries)
        {
            NSMutableDictionary* data = [photoDictionary mutableCopy];
            [data setObject:[NSNumber numberWithInt:0] forKey:@"count"];
            [photoDictionariesWithStatistic addObject:data];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakself.photos = photoDictionariesWithStatistic;
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
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo list cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath]; 
        
    NSDictionary *photoDictionary = [self.photos objectAtIndex:indexPath.row];
    
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
    

    
    if (![self.cellPhoto objectForKey:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"default.jpg"];
        self.photoURL = [FlickrFetcher urlForPhoto:photoDictionary format: FlickrPhotoFormatSquare];
        [self loadImage:self.photoURL forIndex:indexPath];       
    }
    else
    {
        cell.imageView.image = [self.cellPhoto objectForKey:indexPath];
    }
    
    return cell;
}

-(void)loadImage:(NSURL*)imageUrl forIndex:(NSIndexPath*)index
{
    
    
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:imageUrl];
    __block UIImage*image = [[UIImage alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData * data, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if(httpResponse.statusCode == 200)
        {
            image = [[UIImage alloc]initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cellPhoto setObject:image forKey:index];
                [self updateImage:image byIndex:index];
            });
        }
        else
        {
            NSLog(@"Error in image load %@", error.localizedDescription);
            
        }
    }];
    
}

-(void)updateImage:(UIImage*)image byIndex:(NSIndexPath *)index
{
    NSArray *indexes = [self.tableView indexPathsForVisibleRows];
    if([indexes containsObject:index]) // if our index is visible
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}



-(void)saveStatistic
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSMutableArray* viewedPhotoes = [[settings objectForKey:@"photoInfo"] mutableCopy];
    if(viewedPhotoes == nil)
    viewedPhotoes = [NSMutableArray new];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSMutableDictionary* photo = self.photos[indexPath.row];    
    NSNumber* count = [photo objectForKey:@"count"];
    count = [NSNumber numberWithInt:count.intValue+1];
    [photo setObject:count forKey:@"count"];
    NSUInteger index = [viewedPhotoes indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString* objId = [obj objectForKey:@"id"];
        if([objId isEqualToString:[photo objectForKey:@"id"]])
        {
            self.count = [obj objectForKey:@"count"];
            self.count = [NSNumber numberWithInt:self.count.intValue +1];
            return YES;
        }
        else
            return NO;
    }];
    
    if(index!= NSNotFound)
    {
        NSMutableDictionary* obj = [viewedPhotoes[index] mutableCopy];
        [obj setObject:self.count forKey:@"count"];
        viewedPhotoes[index] = obj;
    }
    else [viewedPhotoes addObject:photo];    
    [settings setObject:viewedPhotoes forKey:@"photoInfo"];
    [settings synchronize];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self saveStatistic];    
    PhotoViewController *fvc = (PhotoViewController*)segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    fvc.photoInformaton = [self.photos objectAtIndex:indexPath.row];    
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
