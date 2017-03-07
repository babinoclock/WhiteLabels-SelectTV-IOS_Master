//
//  AppListGridCell.m
//  naivegrid
//
//  Created by OCS iOS Developer on 05/05/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "AppListGridCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation AppListGridCell
@synthesize appImage;
@synthesize appRateLabel,appTitleLabel;

- (id)init {
    if (self = [super init]) {
		self.frame = CGRectMake(0, 0, 80, 80);//old
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [[NSBundle mainBundle] loadNibNamed:@"AppListGridCell_Ipad" owner:self options:nil];
        }
        else{
            [[NSBundle mainBundle] loadNibNamed:@"AppListGridCell_Iphone" owner:self options:nil];
        }
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
         appTitleLabel.numberOfLines = 0;
         appRateLabel.numberOfLines = 0;
       
	}
    return self;
}
- (void)dealloc {
}

@end
