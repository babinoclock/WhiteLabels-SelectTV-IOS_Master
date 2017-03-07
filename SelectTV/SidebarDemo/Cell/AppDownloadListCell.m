//
//  AppDownloadListCell.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 09/07/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "AppDownloadListCell.h"

@implementation AppDownloadListCell

@synthesize appImage;


- (id)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 80, 80);//old
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [[NSBundle mainBundle] loadNibNamed:@"AppDownloadListCell_IPad" owner:self options:nil];
        }
        else{
            [[NSBundle mainBundle] loadNibNamed:@"AppDownloadListCell_IPhone" owner:self options:nil];
        }
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
       
        
    }
    return self;
}
- (void)dealloc {
}

@end
