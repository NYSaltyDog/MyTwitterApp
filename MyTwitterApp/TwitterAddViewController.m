//
//  TwitterAddViewController.m
//  MyTwitter
//
//  Created by Kevin on 10/1/12.
//  Copyright (c) 2012 Aquilacom Technologies. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////



#import "TwitterAddViewController.h"

@interface TwitterAddViewController ()

@end

@implementation TwitterAddViewController



//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - ViewControler
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_textUserName becomeFirstResponder];
    
}


- (void)viewDidUnload
{
    [self setTextUserName:nil];
    [super viewDidUnload];
}


-(void)viewWillUnload
{
    // [self saveData];
}




//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - Custom Methods
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (IBAction)buttonCancel:(id)sender
{
    [_textUserName resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)buttonEnter:(id)sender
{
    // delete existing file... then SAVE...
    [self saveData];
    
    [_textUserName resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
    
}



- (NSString *) saveFilePath
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"savedUserName.plist"];
}



-(void) saveData
{
    // if file exists... delete it
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: [self saveFilePath]];
    
    if (fileExists == YES)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self saveFilePath] error:nil ];
        
    }
    NSString * stringObject = _textUserName.text;
    
    NSArray *value = [[NSArray alloc] initWithObjects:stringObject, nil];
    [value writeToFile:[self saveFilePath] atomically:YES];
    
    NSLog(@"saved data: %@", value);
}





//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - Memory
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (void)dealloc {
    [_textUserName release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

