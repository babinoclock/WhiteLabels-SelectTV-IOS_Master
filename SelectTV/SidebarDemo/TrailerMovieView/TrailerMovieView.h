//
//  TrailerMovieView.h
//  SidebarDemo
//
//  Created by scott harris on 9/29/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>

@interface TrailerMovieView : UIView<YTPlayerViewDelegate>
{
    NSMutableArray* links;
    NSInteger index;
}

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;


-(void)setTrailers:(NSMutableArray*)arrTrailers;

- (IBAction)onCancel:(id)sender;
- (void) startPlay;

@end
