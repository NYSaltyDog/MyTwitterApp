//
//  TwitterAddViewController.h
//  MyTwitter
//
//  Created by Kevin on 10/1/12.
//  Copyright (c) 2012 Aquilacom Technologies. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////



#import <UIKit/UIKit.h>

@interface TwitterAddViewController : UIViewController
{
    
}


// autosynthesized
@property (retain, nonatomic) IBOutlet  UITextField         * textUserName;


- (IBAction)buttonCancel:(id)sender;
- (IBAction)buttonEnter:(id)sender;

- (void)saveData;
- (NSString *) saveFilePath;

@end
