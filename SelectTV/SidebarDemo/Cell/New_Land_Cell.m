//
//  New_Land_Cell.m
//  naivegrid
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "New_Land_Cell.h"
#import <QuartzCore/QuartzCore.h> 
#import "AppConfig.h"
@implementation New_Land_Cell


@synthesize thumbnail;
@synthesize portraitLabel,landScapeLabel;


- (id)init {
	
    if (self = [super init]) {
        
		self.frame = CGRectMake(0, 0, 80, 80);//old
        
        //self.frame = CGRectMake(0, 0, 90, 90); //new
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [[NSBundle mainBundle] loadNibNamed:@"New_Land_Cell_Ipad" owner:self options:nil];
        } else{
            if(IS_IPHONE4||IS_IPHONE5){
                [[NSBundle mainBundle] loadNibNamed:@"New_Land_Cell_IPhone" owner:self options:nil];
            }
            else{
                [[NSBundle mainBundle] loadNibNamed:@"New_Land_Cell" owner:self options:nil];
            }
        }
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];

         portraitLabel.numberOfLines = 0;
        landScapeLabel.numberOfLines = 0;
	}
	
    return self;
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
}


@end
