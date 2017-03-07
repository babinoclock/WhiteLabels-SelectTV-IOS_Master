//
//  CustomAlertView.m
//  SidebarDemo
//
//  Created by Ocs Developer 6 on 1/18/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "CustomAlertView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomAlertView

- (id)initWithParentView: (UIView *)_parentView
{
    self = [super init];
    if (self) {
        
        if (_parentView) {
            self.frame = _parentView.frame;
           // _parentView = _parentView;
        } else {
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
        
//        delegate = self;
//        useMotionEffects = false;
//        buttonTitles = @[@"Close"];
//        buttonColors = @[kCustomIOS7DefaultButtonColor];
    }
    return self;
}
+ (CustomAlertView *) alertWithTitle:(NSString *)title message:(NSString *)message
{
    CustomAlertView* alertView = [[CustomAlertView alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertView.bounds.size.width - 40, 100)];
    
    // Add some custom content to the alert view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, view.bounds.size.width - 40, 100)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    
    CGRect frame = titleLabel.frame;
    frame.size.width =  view.bounds.size.width - 40;
    titleLabel.frame = frame;
    
    [view addSubview:titleLabel];
    
    // Add some custom content to the alert view
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, view.bounds.size.width - 40, 100)];
    
    messageLabel.numberOfLines = 0;
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:18.0f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];
    
    CGRect frame2 = messageLabel.frame;
    frame2.size.width =  view.bounds.size.width - 40;
    messageLabel.frame = frame2;
    
    [view addSubview:messageLabel];
    
    CGRect frame3 = view.frame;
    frame3.size.height = titleLabel.bounds.size.height + messageLabel.bounds.size.height + 30;
    view.frame = frame3;
    
    [alertView setContainerView:view];
    
    [alertView setUseMotionEffects:true];
    
    return alertView;
}



@end
