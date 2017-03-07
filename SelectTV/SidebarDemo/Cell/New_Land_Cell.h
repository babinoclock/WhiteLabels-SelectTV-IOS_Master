//
//  New_Land_Cell.h
//  naivegrid
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
#import "AppDelegate.h"

@interface New_Land_Cell : UIGridViewCell {
    AppDelegate *appDelegate;
    
    
}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *portraitLabel;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (strong, nonatomic) IBOutlet UIView *landScapeView;
@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UILabel *landScapeLabel;
@property (strong, nonatomic) IBOutlet UILabel *airDate;
@property (strong, nonatomic) IBOutlet UILabel *freeLabel;


@end
