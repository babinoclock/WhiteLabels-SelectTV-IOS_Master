//
//  Land_Cell.m
//  naivegrid
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "Land_Cell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Land_Cell


@synthesize thumbnail;
@synthesize label;


- (id)init {
	
    if (self = [super init]) {
        
		self.frame = CGRectMake(0, 0, 80, 80);//old
        
        //self.frame = CGRectMake(0, 0, 90, 90); //new
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [[NSBundle mainBundle] loadNibNamed:@"Land_Cell_Ipad" owner:self options:nil];
        }
        else{
             self.frame = CGRectMake(0, 0, 80, 80);
            [[NSBundle mainBundle] loadNibNamed:@"Land_Cell" owner:self options:nil];
        }
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
		
        [self addSubview:self.view];
		
//		self.thumbnail.layer.cornerRadius = 4.0;
//		self.thumbnail.layer.masksToBounds = YES;
//		self.thumbnail.layer.borderColor = [UIColor blackColor].CGColor;
//		self.thumbnail.layer.borderWidth = 1.0;
        label.numberOfLines = 0;
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
