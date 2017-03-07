//
//  SearchRadioViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 02/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Radio.h"
@interface SearchRadioViewController : UIViewController<RadioDelegate>{
    
    IBOutlet UIView *searchRadioView;
    Radio *radio;
    UIActivityIndicatorView *radioLoadingView;
    //UILabel *emailTitleLabel;
    //UILabel *emailDataLabel;
}


@property (strong, nonatomic) IBOutlet UILabel *SearchRadioTitle;
@property (strong, nonatomic) IBOutlet UIImageView *searchRadioImage;
@property (strong, nonatomic) IBOutlet UILabel *searchRadioSlogan;
@property (strong, nonatomic) IBOutlet UILabel *sloganData;
@property (strong, nonatomic) IBOutlet UILabel *searchRadioAddress;
@property (strong, nonatomic) IBOutlet UILabel *addressData;
@property (strong, nonatomic) IBOutlet UILabel *searchRadioPhone;
@property (strong, nonatomic) IBOutlet UILabel *phoneData;
@property (strong, nonatomic) IBOutlet UILabel *searchRadioDescription;
@property (strong, nonatomic) IBOutlet UITextView *descriptionData;
@property (strong, nonatomic) IBOutlet UIScrollView *radioFullScrollView;

@property (strong, nonatomic) IBOutlet UILabel *descriptionDataLabel;

@property (strong, nonatomic) IBOutlet UILabel *emailTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailDataLabel;

@property (strong, nonatomic) IBOutlet UIWebView *searchRadioWebView;
@property (strong, nonatomic) IBOutlet UIButton *searchRadioPlayButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchRadioActivityIndicator;

@property(retain,nonatomic) NSMutableArray* radioDetailArray;
@property(retain,nonatomic) NSString* radioImageUrl;
- (IBAction)goBackAction:(id)sender;


@end
