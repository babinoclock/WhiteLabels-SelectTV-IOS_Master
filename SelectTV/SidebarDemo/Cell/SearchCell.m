//
//  RadioGenreTableViewCell.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 12/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "SearchCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 70, 70); //old
        [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
              
        
    }
    
    return self;
    
}
- (void)dealloc {
}


@end
