//
//  SignUpViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 18/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "SignUpViewController.h"
#import "MBProgressHUD.h"
#import "SVHTTPClient.h"
#import "SVHTTPRequest.h"
#import "SharedManager.h"

@interface SignUpViewController (){

    NSString *emailText;
    NSString *passwordText;
    NSString *userName;
    NSString *phoneNumber;
    NSString *addressText;
    NSString *confirmPassword;
    NSString *first_name;
    NSString *last_name;
    

}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UITextField *userNameField=[self.view viewWithTag:1];
    UITextField *emailField=[self.view viewWithTag:2];
    UITextField *phoneNumberField=[self.view viewWithTag:3];
    UITextField *addressField=[self.view viewWithTag:4];
    UITextField *passwordField=[self.view viewWithTag:5];
    UITextField *confirmPasswordField=[self.view viewWithTag:6];
    
    emailText=emailField.text;
    passwordText=passwordField.text;
    userName=userNameField.text;
    phoneNumber=phoneNumberField.text;
    addressText=addressField.text;
    confirmPassword=confirmPasswordField.text;
    
    NSLog(@"Navigation Controller %@",self.navigationController);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[super navigationController] setNavigationBarHidden:NO animated:YES];
    super.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    super.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    super.navigationItem.title = @"SignUp";
    [super.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag>=3 && textField.tag<7) {
        [self animateTextField:textField up:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag>=3 && textField.tag<7) {
        [self animateTextField:textField up:NO];
    }
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)validateForm{
    
    
    UITextField *userNameField=[self.view viewWithTag:1];
    UITextField *emailField=[self.view viewWithTag:2];
    UITextField *phoneNumberField=[self.view viewWithTag:3];
    UITextField *addressField=[self.view viewWithTag:4];
    UITextField *passwordField=[self.view viewWithTag:5];
    UITextField *confirmPasswordField=[self.view viewWithTag:6];
    UITextField *first_nameField=[self.view viewWithTag:7];
    UITextField *last_nameField=[self.view viewWithTag:8];
    
    emailText=emailField.text;
    passwordText=passwordField.text;
    userName=userNameField.text;
    phoneNumber=phoneNumberField.text;
    addressText=addressField.text;
    confirmPassword=confirmPasswordField.text;
    first_name=first_nameField.text;
    last_name=last_nameField.text;
    
    if ([emailText length]==0 || [first_name length]==0 || [last_name length]==0 || [passwordText length]==0 || (!([self NSStringIsValidEmail:emailText])) || (!([self checkIfNumber:phoneNumber])) || [userName length]==0 || [userName length]==0 || [addressText length]==0 || (!([confirmPassword isEqualToString:passwordText]))) {
        
        return false;
    }
    
    
    return true;
    
}


-(BOOL)checkIfNumber:(NSString*)toCheck{
    
    NSScanner* scan = [NSScanner scannerWithString:toCheck];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];

}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)signUp:(id)sender {
    
    if([self validateForm]){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading";
        
        //action=register_user&user_name=ashfaq&password=ashfaq&email=engr.ashfaqkhan@gmail.com&phone_number=123&address=123
        
        NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"register_user",@"action",emailText,@"email",passwordText,@"password",userName,@"user_name",phoneNumber,@"phone_number",addressText,@"address",first_name,@"first_name",last_name,@"last_name", nil];//first_name,last_name
        [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            NSLog(@"%@",response);
            
            if (response) {
                
                NSDictionary *result=(NSDictionary*)response;
                
                if ([result[@"error"] isEqualToString:@"0"]) {
                    
                    NSMutableDictionary *userResponse=result[@"user"];
                    
                    [SharedManager getInstance].loggedInUser=[NSMutableDictionary dictionaryWithDictionary:userResponse];
                    [SharedManager getInstance].isLoggedIn=YES;
                    
                    [[SharedManager getInstance] saveModel];
                    
                    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Alert" message:result[@"response"] preferredStyle:UIAlertControllerStyleAlert];
                    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        //[self performSegueWithIdentifier:@"SignUPToHome" sender:self];
                        [self performSegueWithIdentifier:@"goBackHome" sender:self];
                    
                    }]];
                    [self presentViewController:netCont animated:YES completion:nil];
                
                }else if(([result[@"error"] isEqualToString:@"1"])){
                    
                    
                    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:result[@"response"] preferredStyle:UIAlertControllerStyleAlert];
                    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:netCont animated:YES completion:nil];
                
                }else{
                
                    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
                    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:netCont animated:YES completion:nil];
                
                }
                
            }else{
            
                UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
                [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:netCont animated:YES completion:nil];
            
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        }];
        
    }else{
        
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Fields Incorrect/Missing" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];
        
    }
    
    
}

- (IBAction)unwindToSignUpController:(UIStoryboardSegue *)unwindSegue
{
    
    
}




@end
