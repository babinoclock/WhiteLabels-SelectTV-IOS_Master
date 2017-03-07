//
//  MenuView.m
//  SidebarDemo
//
//  Created by Solafort Yong on 11/3/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import "MenuView.h"
#import "Category.h"
#import "ChanelManager.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "AppDelegate.h"
@implementation MenuView


-(void)initWithCategories:(NSMutableArray *)arrCats
{
    
    self.tableViewCats.delegate = self;
    self.tableViewCats.dataSource = self;
    self.arrData = [NSMutableArray arrayWithArray:arrCats];
    [self.tableViewCats reloadData];
  //  [_ipadCancel setHidden:YES];
    
     // [_ipadCancel addTarget:MenuView action:@selector(can:) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }

    
}

- (IBAction)cancelButton:(id)sender {
    
    if([self.arrData count]>0){
        Category* catogory = [self.arrData objectAtIndex:0];
        Category* parentChanel = [[ChanelManager sharedChanelManager] getParentChanel:catogory];
        if(parentChanel.idParent == (NSString*)[NSNull null] || parentChanel.idParent == nil)
        {
            [self.delegate onDismissMenuView];
            
        }else{
            
            NSMutableArray* arrSubs = [[ChanelManager sharedChanelManager] subCatergories:parentChanel.idParent];
            self.arrData =[NSMutableArray arrayWithArray:arrSubs];
            [self.tableViewCats reloadData];
            
        }
        
    }else{
        [self.delegate onDismissMenuView];
    }

}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    Category* chanel = [self.arrData objectAtIndex:indexPath.row];
    cell.textLabel.text = chanel.name;
    NSLog(@"channel%@",chanel.name);
    cell.textLabel.textColor = [UIColor blackColor];
    [cell.textLabel setFont:[COMMON getResizeableFont:Roboto_Light(12)]];
    
    cell.backgroundColor = [UIColor colorWithRed:44/256 green:44/256 blue:44/256 alpha:0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Category* chanel = [self.arrData objectAtIndex:indexPath.row];
    NSString* idCategory = [chanel idCategory];
    NSMutableArray* arrCategories = [[ChanelManager sharedChanelManager] subCatergories:idCategory];
    if([arrCategories count]==0)
    {
        [self.delegate onWatchChanel:idCategory];
        return;
    }
    
    self.arrData = [NSMutableArray arrayWithArray:arrCategories];
    [self.tableViewCats reloadData];
    
}

#pragma mark - Button Events
- (IBAction)onBack:(id)sender {
    
    if([self.arrData count]>0){
        Category* catogory = [self.arrData objectAtIndex:0];
        Category* parentChanel = [[ChanelManager sharedChanelManager] getParentChanel:catogory];
        if(parentChanel.idParent == (NSString*)[NSNull null] || parentChanel.idParent == nil)
        {
            [self.delegate onDismissMenuView];
            
        }else{
            
            NSMutableArray* arrSubs = [[ChanelManager sharedChanelManager] subCatergories:parentChanel.idParent];
            self.arrData =[NSMutableArray arrayWithArray:arrSubs];
            [self.tableViewCats reloadData];
            
        }
    
    }else{
        [self.delegate onDismissMenuView];
    }
    
}

#pragma  mark - orientationChanged
-(void) orientationChanged:(NSNotification *) note
{
    UIDevice * device = note.object;
    
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [self rotateViews:true];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self rotateViews:false];
            break;
            
        default:
            break;
    }
}
#pragma  mark - rotateViews
-(void) rotateViews:(BOOL) bPortrait{
    if(bPortrait){
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [_ipadCancel setHidden:YES];
        }
        else{
            [_ipadCancel setHidden:YES];
        }
        
        
    }
    
    else{
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
         {
             [_ipadCancel setHidden:NO];
         }
         else{
             [_ipadCancel setHidden:NO];
         }
    }
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}
@end
