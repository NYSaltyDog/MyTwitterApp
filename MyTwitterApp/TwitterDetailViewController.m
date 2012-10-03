//
//  TwitterDetailViewController.m
//  MyTwitterApp
//
//  Created by Kevin on 10/3/12.
//  Copyright (c) 2012 Aquilacom Technologies. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////





#import "TwitterDetailViewController.h"

@interface TwitterDetailViewController ()
- (void)configureView;
@end

@implementation TwitterDetailViewController





@synthesize tweetName;
@synthesize tweetScreenName;
@synthesize tweetProfileImageUrl;
@synthesize tweetCreatedAt;
@synthesize tweetText;


				


//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - Managing the detail item
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }
}







		
//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - ViewControler
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//	
- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { self.title = @"Detail"; }
    
    return self;
}


- (void)viewDidUnload {
    [self setProfileImage:nil];
    // [self setNameTextLable:nil];
    [self setDetailTextLable:nil];
    [self setScreenNameTextLablel:nil];
    [super viewDidUnload];
}





//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - Memory Management
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_profileImage release];
    [_nameTextLabel release];
    [_detailTextLable release];
    [_screenNameTextLablel release];
    
    
    
    [tweetName                release];
	[tweetScreenName         release];
	[tweetProfileImageUrl     release];
	[tweetCreatedAt           release];
    [tweetText                release];
    
    
    
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end

