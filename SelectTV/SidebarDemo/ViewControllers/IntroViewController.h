//
//  IntroViewController.h
//  SidebarDemo
//
//  Created by Amit Sharma on 26/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface IntroViewController : UIViewController<UIScrollViewDelegate>{
    
       
    BOOL isPortraitFirst;
    BOOL isLandScapeFirst;
    
    

    
}
@property (strong, nonatomic) IBOutlet UIImageView *splashImage;
@property (strong, nonatomic) IBOutlet UIView *additionalView;





@end
