//
//  Land_Cell.h
//  naivegrid
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface Land_Cell : UIGridViewCell {

}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *label;

@end
