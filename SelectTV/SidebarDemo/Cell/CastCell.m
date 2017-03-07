//
//  Cell.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CastCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CastCell

@synthesize label;


- (id)init {
    
    
    if (self = [super init]) {
        
       
        
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        
//             self.frame = CGRectMake(0, 0, 208, 60);
//          [[NSBundle mainBundle] loadNibNamed:@"CastCellIpad" owner:self options:nil];
//        } else {
//            self.frame = CGRectMake(0, 0, 120, 40);
//            [[NSBundle mainBundle] loadNibNamed:@"CastCell" owner:self options:nil];
//        }
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [[NSBundle mainBundle] loadNibNamed:@"CastCell" owner:self options:nil];
        
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
