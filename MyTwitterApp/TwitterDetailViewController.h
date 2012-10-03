//
//  TwitterDetailViewController.h
//  MyTwitter
//
//  Created by Kevin on 10/1/12.
//  Copyright (c) 2012 Aquilacom Technologies. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////




#import <UIKit/UIKit.h>

@interface TwitterDetailViewController : UIViewController
{
    NSMutableString         * tweetName;
    NSMutableString         * tweettScreenName;
    NSMutableString         * tweetProfileImageUrl;
    NSMutableString         * tweetCreatedAt;
    NSMutableString         * tweetText;
    
}



// Autosynthesize
@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel              * detailDescriptionLabel;
@property (retain, nonatomic) IBOutlet UIImageView          * profileImage;
@property (retain, nonatomic) IBOutlet UILabel              * nameTextLabel;
@property (retain, nonatomic) IBOutlet UILabel              * screenNameTextLablel;
@property (retain, nonatomic) IBOutlet UILabel              * detailTextLable;



@property (retain, nonatomic)           NSMutableString     * tweetName;
@property (retain, nonatomic)           NSMutableString     * tweetScreenName;
@property (retain, nonatomic)           NSMutableString     * tweetProfileImageUrl;
@property (retain, nonatomic)           NSMutableString     * tweetCreatedAt;
@property (retain, nonatomic)           NSMutableString     * tweetText;



@end
