//
//  TwitterMasterViewController.m
//  MyTwitterApp
//
//  Created by Kevin on 10/3/12.
//  Copyright (c) 2012 Aquilacom Technologies. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////




#import "TwitterMasterViewController.h"

#import "TwitterDetailViewController.h"

@interface TwitterMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation TwitterMasterViewController


@synthesize  currentTitle;
@synthesize  currentDate;
@synthesize  currentLink;
@synthesize  myUserName;





//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - ViewControler
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // UIBarButtonItem *searchButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(insertNewObject:)] autorelease];
    UIBarButtonItem *searchButton           = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonClicked)] autorelease];
    
    self.navigationItem.rightBarButtonItem = searchButton;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Twitter App", @"Twitter App");
    }
    return self;
}




- (void)insertNewObject:(id)sender
{
    // for inserting new rows in tableView
    if (!_objects) { _objects = [[NSMutableArray alloc] init]; }
    
    [_objects insertObject:[NSDate date] atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}




// Load ModalView as initial view on start up
-(void)viewWillAppear:(BOOL)animated
{
    if (startedBefore == NO) {[self loadTwitterAddViewController:self];} startedBefore = YES;
    // [_newsTable reloadData];
}




// build URL for url fetch method
- (void)viewDidAppear:(BOOL)animated
{
    cellSize                    = CGSizeMake([_newsTable bounds].size.width, 60);
    NSString * twitterUserName  = [self retrieveUserName];
    NSString * twitterBaseURL   = @"https://api.twitter.com/1/statuses/user_timeline.rss?count=20&screen_name=";
    NSString * path             = [NSString stringWithFormat: @"%@%@", twitterBaseURL, twitterUserName];
    
    //NSLog(@"The path is: %@ ", path);
    [self parseXMLFileAtURL:path];
    [super viewDidAppear:animated];
}





//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - XML Parser
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (void)parseXMLFileAtURL:(NSString *)URL
{
	tweets          = [[NSMutableArray alloc] init];
    
	// convert the path to NSURL
	NSURL *xmlURL   = [NSURL URLWithString:URL];
	twitterParser   = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// set delegate to receive callbacks.
	[twitterParser setDelegate:self];
	[twitterParser parse];
}




//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - Parsing Delegate Methods
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (void)parserDidStartDocument:(NSXMLParser *)parser { NSLog(@"found file and started parsing"); }

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
    
	if ([elementName isEqualToString:@"item"])
    {
        // clear out item caches...
		item                    = [[NSMutableDictionary alloc] init];
		currentTitle            = [[NSMutableString alloc] init];
		currentDate             = [[NSMutableString alloc] init];
        currentLink             = [[NSMutableString alloc] init];
        
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	// NSLog(@"ended this element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
    {
        // save values to item, then to array...
		[item setObject:currentTitle            forKey:@"title"];
		[item setObject:currentDate             forKey:@"pubDate"];
        [item setObject:currentLink             forKey:@"link"];
        
        NSLog(@"adding tweet: %@", currentTitle);
        [tweets addObject:[item copy]];
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	// NSLog(@"found characters: %@", string);
    
    // save the characters for the current item...
    if      ([currentElement isEqualToString:@"title"])     {[currentTitle  appendString:string];}
    else if ([currentElement isEqualToString:@"pubDate"])   {[currentDate   appendString:string];}
    else if ([currentElement isEqualToString:@"link"])      {[currentLink   appendString:string];}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
    [_newsTable reloadData];
	NSLog(@"all done!");
	NSLog(@"tweets array has %d items", [tweets count]);
}






//
//
//   //                                                                    ////
//  //////////////////////////////////////////////////////////////////////////
#pragma mark - TableView
//  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//   \\                                                                    \\\\
//
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //---> return _objects.count;
    return [tweets count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
 
 /*    
    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
*/  
    // Set up the cell
	int tweetIndex          = [indexPath indexAtPosition: [indexPath length] - 1];
	cell.textLabel.text     = [[tweets objectAtIndex: tweetIndex] objectForKey: @"pubDate"];
    
	return cell;
 
 
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
    
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController)
    {
        self.detailViewController = [[[TwitterDetailViewController alloc] initWithNibName:@"TwitterDetailViewController" bundle:nil] autorelease];
    }
    
    // NSDate *object = _objects[indexPath.row];
    // self.detailViewController.detailItem = object;
    // [self.navigationController pushViewController:self.detailViewController animated:YES];

    
    int tweetIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    NSString * tweetLink = [[tweets objectAtIndex: tweetIndex] objectForKey: @"link"];
    
    NSString * object    =   [[tweets objectAtIndex: tweetIndex] objectForKey: @"title"];                    // currentTitle;
    self.detailViewController.detailItem = object;
   
    NSLog(@"tableView row index: %@", tweetLink);
    [self.navigationController pushViewController:self.detailViewController animated:YES];
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
- (void) loadTwitterAddViewController:(id)sender
{
    TwitterAddViewController *twitterAddViewController = [[[TwitterAddViewController alloc] initWithNibName:@"TwitterAddViewController" bundle:nil] autorelease];
    [self.navigationController presentModalViewController:twitterAddViewController animated:NO];
}


- (void)searchButtonClicked
{
    TwitterAddViewController *twitterAddViewController = [[[TwitterAddViewController alloc] initWithNibName:@"TwitterAddViewController" bundle:nil] autorelease];
    [self.navigationController presentModalViewController:twitterAddViewController animated:YES];
}




- (NSString *) savedFilePath
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"savedUserName.plist"];
}


-(NSString *)retrieveUserName
{
    NSString *path          = [self savedFilePath];
    BOOL fileExists         = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (fileExists == YES)
    {
        NSArray *values     = [[NSArray alloc] initWithContentsOfFile:path];
        myUserName          = [values objectAtIndex:0];
        
        NSLog(@"saved user name: %@", myUserName);
    }
    return myUserName;
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
    [_detailViewController      release];
    [_objects                   release];
    [_newsTable                 release];
    
    [currentElement             release];
	[twitterParser              release];
	[tweets                     release];
	[item                       release];
    [myUserName                 release];
    [currentTitle               release];
	[currentDate                release];
	[currentLink                release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    // startedBefore = NO;
    
    [self setNewsTable:nil];
    [super viewDidUnload];
}



@end
