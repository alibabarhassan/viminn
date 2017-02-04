//
//  LoginViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 18/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "LoginViewController.h"
#import "SVHTTPClient.h"
#import "MBProgressHUD.h"
#import "SharedManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[super navigationController] setNavigationBarHidden:NO animated:YES];
    super.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationController.navigationBar.translucent = NO;
    super.navigationItem.title = @"Login";
    [super.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //emailField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (IBAction)LogIn:(id)sender{
    
    
    if([self validateForm]){
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading";
        
        NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"login",@"action",emailField.text,@"username",passwordField.text,@"password", nil];
        [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            if (response) {
                
                NSDictionary *result=(NSDictionary*)response;
                
                if ([result[@"error"] isEqualToString:@"0"]) {
                    
                    NSMutableDictionary *userResponse=result[@"user"];
                    
                    [SharedManager getInstance].loggedInUser=[NSMutableDictionary dictionaryWithDictionary:userResponse];
                    [SharedManager getInstance].isLoggedIn=YES;
                    
                    [[SharedManager getInstance] saveModel];
                    
                    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Alert" message:result[@"response"] preferredStyle:UIAlertControllerStyleAlert];
                    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        //[self performSegueWithIdentifier:@"LoginToHome" sender:self];goBackToHome
                        [self performSegueWithIdentifier:@"goBackToHome" sender:self];
                        
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
    
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Email or Password Missing/Incorrect" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];
    
    }
    
}

- (BOOL)validateForm{

    NSString *emailText=emailField.text;
    NSString *passwordText=passwordField.text;
    
    if ([emailText length]==0 || [passwordText length]==0/* || (!([self NSStringIsValidEmail:emailText] ))*/) {
        
        return false;
    }
    
    
    return true;

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

- (IBAction)unwindToLoginController:(UIStoryboardSegue *)unwindSegue
{
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
