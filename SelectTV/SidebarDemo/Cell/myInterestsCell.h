//
//  myInterestsCell.h
//  naivegrid
//
//  Created by OCS iOS Developer Raji on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface myInterestsCell : UIGridViewCell {
    
}
@property (strong, nonatomic) IBOutlet UIView *thumbnailView;
@property (nonatomic, retain) IBOutlet UIImageView *playIcon;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *innerLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *tickButton;

@property (strong, nonatomic) IBOutlet UIButton *wholeBtn;

@end
