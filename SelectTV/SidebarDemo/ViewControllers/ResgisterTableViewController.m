//
//  ResgisterTableViewController.m
//  SidebarDemo
//
//  Created by Amit Sharma on 20/08/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ResgisterTableViewController.h"

#import "RabbitTVManager.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"

@interface ResgisterTableViewController ()

@end

@implementation ResgisterTableViewController



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    whichSlected = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
        self.title = @"Register";
       // [self addLeftImageOnTextField:@"Email icon" :emailTF];
       // [self addLeftImageOnTextField:@"Lock" :passwordTF];
      //  [self addLeftImageOnTextField:@"Lock" :confirmPasswordTF];
      //  [self addLeftImageOnTextField:@"Lock" :userNameTF];
      //xr  [self addLeftImageOnTextField:@"Lock" :ageRangeTF];
    
    
    UIImageView *boxBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    [self.tableView setBackgroundView:boxBackView];
    
}

-(void)removeView{
    
    [mainPickerView setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    mainPickerView = [[UIView alloc] initWithFrame:self.view.frame];
    
    [mainPickerView setBackgroundColor:[UIColor whiteColor]];
    [mainPickerView setAlpha:0.8];
    
    UITapGestureRecognizer *rec  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [mainPickerView addGestureRecognizer:rec];
    [mainPickerView setUserInteractionEnabled:YES];
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-200 , self.view.frame.size.width, 200)];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    [myPickerView setShowsSelectionIndicator:NO];
    [mainPickerView addSubview:myPickerView];
    [self.view addSubview:mainPickerView];
    [mainPickerView setHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)genderChangeButtonPressed:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    [btn setSelected:YES];
    ([sender tag]==1)?[maleButton setSelected:NO]:[femaleButton setSelected:NO];
  
    
    
}



-(void)addLeftImageOnTextField:(NSString *)imageName :(UITextField *)textField{
    
    [textField setDelegate:self];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imgView.image = [UIImage imageNamed:imageName];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    int width = 40;
    if (imageName.length==0) {
        width = 20;
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [paddingView addSubview:imgView];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setLeftView:paddingView];
    
    
}




-(IBAction)registerButtonTapped:(id)sender{
    
    
    
    
    
    if (emailTF.text.length==0 || passwordTF.text.length==0 || confirmPasswordTF.text.length==0) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Username, email address and passsord can't be empty." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;

        
        
    }
    
    else if (![self emailvalidate:emailTF.text]){
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please enter correct email" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;

        
    }
    
    else if (![passwordTF.text isEqualToString:confirmPasswordTF.text]){
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Password and confirm password doesn't match." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    
    
    else{
        
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        
        
        if ([maleButton isSelected] ) {
       
            //tempDict = @{@"gender":@"M",@"age_group":@"1"};
            
            [tempDict setObject:@"M" forKey:@"gender"];
        }
        
        else{
            [tempDict setObject:@"F" forKey:@"gender"];

        }
        
        if (whichSlected>0) {
            [tempDict setObject:[NSNumber numberWithInt:whichSlected] forKey:@"age_group"];

        }
        
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];

        [[RabbitTVManager sharedManager] getRegisterDetails:^(AFHTTPRequestOperation * operation, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];

            NSLog(@"%@",responseObject);
            if ([responseObject valueForKey:@"error"]) {
                [[[UIAlertView alloc] initWithTitle:nil message:[responseObject valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
            }
            else{
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"LoginSuccessFull"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController.navigationBar setHidden:YES];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                SWRevealViewController *sideBar = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                [self.navigationController pushViewController:sideBar animated:YES];
            }
            
            
        }  email:emailTF.text password:passwordTF.text  data:tempDict];
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
}


-(BOOL) emailvalidate:(NSString *)tempMail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:tempMail];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField==ageRangeTF) {
        
        
        [emailTF resignFirstResponder];
                [userNameTF resignFirstResponder];
                [passwordTF resignFirstResponder];        [confirmPasswordTF resignFirstResponder];
        
        
        [mainPickerView setHidden:NO];
        return NO;
    }
    return YES;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {

            [mainPickerView setHidden:YES];
    
    NSString *title;
    
    whichSlected = (int)row +1;
    
    if (row==0) {
        title = @"18-24";
    }
    else if (row==1) {
        title = @"25-35";
    }
    else if (row==2) {
        title = @"36-49";
    }
    else {
        title = @"50+";
    }
    [ageRangeTF setText:title];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows;
    numRows= 5;
    
    return 4;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;

    if (row==0) {
        title = @"18-24";
    }
    else if (row==1) {
        title = @"25-35";
    }
    else if (row==2) {
        title = @"36-49";
    }
    else {
        title = @"50+";
    }
    
    
    
    return title;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}
@end
