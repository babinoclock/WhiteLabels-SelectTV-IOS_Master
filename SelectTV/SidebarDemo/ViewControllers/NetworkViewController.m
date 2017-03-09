//
//  NetworkViewController.m
//  SidebarDemo
//
//  Created by Panda on 7/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "NetworkViewController.h"
#import "UIGridView.h"
#import "PlusViewController.h"
#import "AppConfig.h"
@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 107;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 107;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 3;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 0;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    
    return nil;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex currentGridCell:(id)currentCell
{
    NSLog(@"%d, %d clicked", rowIndex, colIndex);
    
}

#pragma mark - Navigation Bar Click

- (IBAction)onPlusClick:(id)sender {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        
        PlusViewController *plusVC = [storyboard instantiateViewControllerWithIdentifier:@"PlusViewController"];
        [self.navigationController presentViewController:plusVC animated:YES completion:nil];
        return;
        
    }
    
    
    PlusViewController *plusViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"plusviewcontroller"];
    [self.navigationController presentViewController:plusViewController animated:YES completion:nil];
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

@end
