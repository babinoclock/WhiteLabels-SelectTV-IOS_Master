//
//  ThumbnailVC.m
//  MultipleViews
//
//  Created by Javra Software on 7/28/11.
//  Copyright 2011 Javra Softwarew. All rights reserved.
//

#import "ThumbnailVC.h"


@implementation ThumbnailVC

- (IBAction) touchMeAction {
	NSLog(@"Touched!");
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    _thumbnailLabel.layer.borderWidth=2.0;
    _thumbnailLabel.layer.borderColor =[UIColor grayColor].CGColor;
                                        
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
