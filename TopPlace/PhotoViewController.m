//
//  PhotoViewController.m
//  TopPlace
//
//  Created by Oleksandr Kulakov on 5/24/13.
//  Copyright (c) 2013 Oleksandr Kulakov. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentSettings.h"

@interface PhotoViewController () <UIScrollViewAccessibilityDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameOfPhoto;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation PhotoViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize photoInformaton = _photoInformaton;
@synthesize nameOfPhoto;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoURL = [FlickrFetcher urlForPhoto:self.photoInformaton format: 2];
    [self loadImage:self.photoURL];//TODO::
    self.scrollView.delegate = self;
	self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.center = self.view.center;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *title = [NSString stringWithFormat:@"%@",[self.photoInformaton objectForKey:@"title"]];
    self.nameOfPhoto.textColor = [UIColor greenColor];
    self.nameOfPhoto.text =[NSString stringWithFormat:@"%@", title];
}

- (void) viewDidAppear:(BOOL)animated
{
    
}


-(void)loadImage:(NSURL*)imageUrl
{
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:imageUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData * data, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if(httpResponse.statusCode == 200)
        {
            UIImage*image = [[UIImage alloc]initWithData:data];
            [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:NO];
        }
        else
        {
            NSLog(@"Error in image load %@", error.localizedDescription);
        }
    }];    
}

-(void)showImage:(UIImage*)image
{
    [self.spinner stopAnimating];
    self.imageView.image = image;
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated
{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
