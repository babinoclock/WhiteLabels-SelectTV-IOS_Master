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

@interface OnDemand_Grid_Cell : UIGridViewCell {

    AppDelegate *appDelegate;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (strong, nonatomic) IBOutlet UIImageView *moviePortraitImage;
@property (strong, nonatomic) IBOutlet UIView *landScapeView;
@property (strong, nonatomic) IBOutlet UIView *portraitView;

//@property (strong, nonatomic) IBOutlet UILabel *landScapeLabel;
//@property (strong, nonatomic) IBOutlet UILabel *airDate;
//@property (strong, nonatomic) IBOutlet UILabel *freeLabel;
//@property (nonatomic, retain) IBOutlet UILabel *portraitLabel;


@end
