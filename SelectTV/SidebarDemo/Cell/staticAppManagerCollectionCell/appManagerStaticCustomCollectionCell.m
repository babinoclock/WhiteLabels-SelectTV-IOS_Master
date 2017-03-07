//
//  appManagerStaticCustomCollectionCell.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 08/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "appManagerStaticCustomCollectionCell.h"

@implementation appManagerStaticCustomCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_installBtn setTitle:@"Install" forState:UIControlStateNormal];
   // [_installBtn setTintColor:[UIColor greenColor]];
    [_installBtn setBackgroundImage:[UIImage imageNamed:@"AddButton.png"] forState:UIControlStateNormal];
}

@end
