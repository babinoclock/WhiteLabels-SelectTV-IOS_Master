//
//  AppListGridCell.h
//  naivegrid
//
//  Created by OCS iOS Developer on 05/05/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface AppListGridCell : UIGridViewCell {

    
    
}
@property (strong, nonatomic) IBOutlet UIView *appView;

@property (nonatomic, retain) IBOutlet UIImageView *appImage;
@property (nonatomic, retain) IBOutlet UILabel *appRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *appTitleLabel;

@end
