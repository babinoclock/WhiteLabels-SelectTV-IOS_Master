//
//  ThumbnailVC.h
//  MultipleViews
//
//  Created by Javra Software on 7/28/11.
//  Copyright 2011 Javra Softwarew. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThumbnailVC : UIViewController {

}
@property (nonatomic, retain) UIView *thumnailView;
@property (nonatomic, retain) IBOutlet UILabel *thumbnailLabel;
- (IBAction) touchMeAction;
@end
