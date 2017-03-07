//
//  myInterestsCell.m
//  naivegrid
//
//  Created by OCS iOS Developer Raji on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "myInterestsCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation myInterestsCell


@synthesize thumbnail;
@synthesize innerLabel,titleLabel;


- (id)init {
	
    if (self = [super init]) {
        
		self.frame = CGRectMake(0, 0, 80, 80);//old
        
        //self.frame = CGRectMake(0, 0, 90, 90); //new
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
             [[NSBundle mainBundle] loadNibNamed:@"myInterestsCell_IPad" owner:self options:nil];
        }
        else{
              [[NSBundle mainBundle] loadNibNamed:@"myInterestsCell_IPhone" owner:self options:nil];
        }
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
    
        innerLabel.numberOfLines = 0;
        titleLabel.numberOfLines = 0;
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
