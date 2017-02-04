//
//  SubmitViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 29/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "SubmitViewController.h"
#import "SVHTTPClient.h"
#import "SVHTTPRequest.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"




@interface SubmitViewController (){

    NSMutableDictionary *loggedInUser;
    NSMutableDictionary *params;
}

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    params=[SharedManager getInstance].checkOutDetail;
    loggedInUser=[SharedManager getInstance].loggedInUser;
    
    [self loadFields];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    

        
}

-(void)loadFields{

    if([SharedManager getInstance].isLoggedIn){
        

        firstNameField.text=[params objectForKey:@"first_name"];
        lastNameField.text=[params objectForKey:@"last_name"];
        phoneNumberField.text=[loggedInUser objectForKey:@"phone"];
        emailField.text=[params objectForKey:@"email"];
        addressField.text=[params objectForKey:@"address_1"];
        address2Field.text=[params objectForKey:@"address_2"];
        cityField.text=@"Lahore";
        stateField.text=@"Punjab";
        countryField.text=@"Pakistan";
        postCodeField.text=@"54000";
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.identifier isEqualToString:@"goToPaymentMethod"]) {
//        
//        NSMutableArray * arr = [[NSMutableArray alloc] init];
//        
//        
//        
//        //NSString *jsonStr=@"[";
//        
//        for (int i=0; i<[[SharedManager getInstance].cart count]; i++) {
//            
//            NSMutableDictionary *dict=[[SharedManager getInstance].cart objectAtIndex:i];
//            //NSString *str=[NSString stringWithFormat:@"{\"product_id\":\"%@\",\"quantity\":\"%@\"},",[dict objectForKey:@"id"],[dict objectForKey:@"quantity"]];
//            
//            //jsonStr=[jsonStr stringByAppendingString:str];
//            
//            NSNumber *u_id=[NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
//            NSNumber *qty=[NSNumber numberWithInt:[[dict objectForKey:@"quantity"] intValue]];
//            
//            NSMutableDictionary *jsonDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:u_id,@"product_id",qty,@"quantity", nil];
//            
//            [arr addObject:jsonDict];
//            
//        }
//        
//        NSError *error;
//        
//        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
//        NSLog(@"jsonData as string:\n%@", jsonString);
//        
//        //jsonStr = [jsonStr substringToIndex:[jsonStr length]-1];
//        //jsonStr=[jsonStr stringByAppendingString:@"]"];
//        
//        
//        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"quickdiscount_create_order",@"action",[loggedInUser objectForKey:@"user_id"],@"customer_id",@"cod",@"payment_method",@"Cash on Delivery",@"payment_method_title",@"false",@"set_paid",firstNameField.text,@"first_name",lastNameField.text,@"last_name",addressField.text,@"address_1",address2Field.text,@"address_2",cityField.text,@"city",stateField.text,@"state",postCodeField.text,@"postcode",countryField.text,@"country",emailField.text,@"email",phoneNumberField.text,@"phone",@"0",@"total_amount",jsonString,@"line_item",nil];
//        
//        [SharedManager getInstance].checkOutDetail=[[NSMutableDictionary alloc]initWithDictionary:parameters];
//        
//        [[SharedManager getInstance] saveModel];
//        
//    }
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==4) {
        [textField resignFirstResponder];
        [self onLaunchClicked:nil];
    }
    
    if (textField.tag>4) {
        [self animateTextField:textField up:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag>4) {
        [self animateTextField:textField up:NO];
    }
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    
    int tag=(int)textField.tag;
    const int movementDistance = -(20*tag); // tweak as needed
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


- (IBAction)submitClicked:(id)sender {
    
    
    if (addressField.text.length>0 &&address2Field.text.length>0&&firstNameField.text.length>0 &&lastNameField.text.length>0&&cityField.text.length>0 &&stateField.text.length>0 && postCodeField.text.length>0 &&countryField.text.length>0&&emailField.text.length>0 &&phoneNumberField.text.length>0) {
        
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        
        
        
        //NSString *jsonStr=@"[";
        
        for (int i=0; i<[[SharedManager getInstance].cart count]; i++) {
            
            NSMutableDictionary *dict=[[SharedManager getInstance].cart objectAtIndex:i];
            //NSString *str=[NSString stringWithFormat:@"{\"product_id\":\"%@\",\"quantity\":\"%@\"},",[dict objectForKey:@"id"],[dict objectForKey:@"quantity"]];
            
            //jsonStr=[jsonStr stringByAppendingString:str];
            
            NSNumber *u_id=[NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
            NSNumber *qty=[NSNumber numberWithInt:[[dict objectForKey:@"quantity"] intValue]];
            
            NSMutableDictionary *jsonDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:u_id,@"product_id",qty,@"quantity", nil];
            
            [arr addObject:jsonDict];
            
        }
        
        NSError *error;
        
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSLog(@"jsonData as string:\n%@", jsonString);
        
        //jsonStr = [jsonStr substringToIndex:[jsonStr length]-1];
        //jsonStr=[jsonStr stringByAppendingString:@"]"];
        
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"quickdiscount_create_order",@"action",[loggedInUser objectForKey:@"user_id"],@"customer_id",@"cod",@"payment_method",@"Cash on Delivery",@"payment_method_title",@"false",@"set_paid",firstNameField.text,@"first_name",lastNameField.text,@"last_name",addressField.text,@"address_1",address2Field.text,@"address_2",cityField.text,@"city",stateField.text,@"state",postCodeField.text,@"postcode",countryField.text,@"country",emailField.text,@"email",phoneNumberField.text,@"phone",@"0",@"total_amount",jsonString,@"line_item",nil];
        
        [SharedManager getInstance].checkOutDetail=[[NSMutableDictionary alloc]initWithDictionary:parameters];
        
        [[SharedManager getInstance] saveModel];
        
        [self performSegueWithIdentifier:@"goToPaymentMethod" sender:self];
    }else{
    
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Fill All Fields" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];

    }
    
}


- (IBAction)onLaunchClicked:(id)sender {
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    address2Field.text=place.name;
    
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
