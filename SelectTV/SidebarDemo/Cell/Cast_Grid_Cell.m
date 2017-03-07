//
//  Cast_Grid_Cell.m
//  naivegrid
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "Cast_Grid_Cell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Cast_Grid_Cell





- (id)init {
	
    if (self = [super init]) {
        
		self.frame = CGRectMake(0, 0, 80, 80);//old
        
        //self.frame = CGRectMake(0, 0, 90, 90); //new
        [[NSBundle mainBundle] loadNibNamed:@"Cast_Grid_Cell_iPhone" owner:self options:nil];
        
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];

       
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
