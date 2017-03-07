//
//  StartScreenViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 05/03/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreenViewController : UIViewController<UIScrollViewDelegate>
{
    UIView            *sampletest;
    UIView            *viewImages;
    UIWebView         *webContent;
    
    UIView            *pgDtView;
    NSInteger         Currentindex;
    int               flag;
    float xslider;
    
}
@property (strong, nonatomic) IBOutlet UIImageView  *mainImageView;
@property (strong, nonatomic) IBOutlet UIImageView  *stringImageView;

@property (strong, nonatomic) IBOutlet UIButton  *arrowBtn;

@property (strong, nonatomic) NSMutableArray        *mainImageArry;
@property (strong, nonatomic) NSMutableArray        *htmlArray;
@property (strong, nonatomic) NSMutableArray        *textImageArray;
@property (strong, nonatomic) NSMutableArray        *arrowImageArray;

@property (nonatomic, strong) UIScrollView *touchScrollView;



@end

