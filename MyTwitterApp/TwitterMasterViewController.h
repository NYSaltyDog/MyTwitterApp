//
//  TwitterMasterViewController.h
//  MyTwitter
//
//  Created by Kevin on 10/1/12.
//  Copyright (c) 2012 Aquilacom Technologies. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////




#import <UIKit/UIKit.h>
#import "TwitterAddViewController.h"


@class TwitterDetailViewController;

@interface TwitterMasterViewController : UITableViewController <NSXMLParserDelegate>
{
    BOOL                      startedBefore;
	UIActivityIndicatorView * activityIndicator;
	CGSize                    cellSize;
	NSXMLParser             * twitterParser;
	NSMutableArray          * tweets;
	NSMutableDictionary     * item;
    NSString                * myUserName;
    
	// parsing
	NSString                * currentElement;
    NSMutableString         * currentTitle;
    NSMutableString         * currentDate;
    NSMutableString         * currentLink;
    
}

// auto synthesized
@property (strong, nonatomic) TwitterDetailViewController   * detailViewController;
@property (strong, nonatomic) IBOutlet  UITableView         * newsTable;
@property (retain, nonatomic)           NSString            * myUserName;
@property (retain, nonatomic)           NSMutableString     * currentTitle;
@property (retain, nonatomic)           NSMutableString     * currentDate;
@property (retain, nonatomic)           NSMutableString     * currentLink;

-(void)loadTwitterAddViewController:(id)sender;
-(void)searchButtonClicked;
-(NSString *)retrieveUserName;
-(NSString *) savedFilePath;


@end
