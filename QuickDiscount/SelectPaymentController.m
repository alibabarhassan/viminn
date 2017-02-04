//
//  SelectPaymentController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 11/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "SelectPaymentController.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"



@interface SelectPaymentController ()
@property(nonatomic,strong)PayPalConfiguration *payPalconfig;


@end

@implementation SelectPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _payPalconfig=[[PayPalConfiguration alloc] init];
    _payPalconfig.acceptCreditCards=YES;
    _payPalconfig.merchantName=@"Quick Discount";//Original Merchant Name
    _payPalconfig.merchantPrivacyPolicyURL=[NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalconfig.merchantUserAgreementURL=[NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalconfig.languageOrLocale=[NSLocale preferredLanguages][0];
    _payPalconfig.payPalShippingAddressOption=PayPalShippingAddressOptionPayPal;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)CashOnDelivery:(id)sender{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    
        NSMutableDictionary *parameters=[SharedManager getInstance].checkOutDetail;

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
// [manager GET:@"http://213.136.76.43/quickdiscount/wp-admin/admin-ajax.php?action=quickdiscount_create_order" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
     [manager GET:@"http://213.136.76.43/vimmin//wp-admin/admin-ajax.php?action=quickdiscount_create_order" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success!");
    
            //NSMutableArray *arr=responseObject;
            
            NSMutableDictionary *dict=responseObject;
            
            NSNumber *flag=[dict objectForKey:@"error"];
            
            if ([flag isEqualToNumber:[NSNumber numberWithInt:0]]) {
                
                UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Success" message:@"Order Placed Successfully" preferredStyle:UIAlertControllerStyleAlert];
                [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    [[SharedManager getInstance].cart removeAllObjects];
                    [[SharedManager getInstance] saveModel];
                    
                    [self performSegueWithIdentifier:@"goToOrders" sender:self];
                    
                }]];
                [self presentViewController:netCont animated:YES completion:nil];
                
            }else{
            
            
                UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:netCont animated:YES completion:nil];
            
            
            }
    
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    
            //NSLog(@"success=%@",string);
            
            
    
    
    
    
    
    
    
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
    
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
        }];
    
    


}


-(void)submitOrder:(NSString*)type paidStatus:(NSString*)paidStatus{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    
    NSMutableDictionary *parameters=[SharedManager getInstance].checkOutDetail;
    
    [parameters setObject:type forKey:@"payment_method"];
    
    [parameters setObject:paidStatus forKey:@"set_paid"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    [manager GET:@"http://213.136.76.43/quickdiscount/wp-admin/admin-ajax.php?action=quickdiscount_create_order" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    [manager GET:@"http://213.136.76.43/vimmin/wp-admin/admin-ajax.php?action=quickdiscount_create_order" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        
        //NSMutableArray *arr=responseObject;
        
        NSMutableDictionary *dict=responseObject;
        
        NSNumber *flag=[dict objectForKey:@"error"];
        
        if ([flag isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Success" message:@"Order Placed Successfully" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [[SharedManager getInstance].cart removeAllObjects];
                [[SharedManager getInstance] saveModel];
                
                [self performSegueWithIdentifier:@"goToOrders" sender:self];
                
            }]];
            [self presentViewController:netCont animated:YES completion:nil];
            
        }else{
            
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Failed. Try Again" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
            
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //NSLog(@"success=%@",string);
        
        
        
        
        
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];
    }];
    
    



}

-(IBAction)Paypal:(id)sender{
    
    NSMutableArray *items=[[NSMutableArray alloc]init];
    
    NSDecimalNumber *subTotal=[[NSDecimalNumber alloc]initWithInt:0];
    
    NSString *currencyCode=@"";
    
    for (int i=0; i<[[SharedManager getInstance].cart count]; i++) {
        
        NSMutableDictionary *dict=[[SharedManager getInstance].cart objectAtIndex:i];
        
        PayPalItem *item1=[PayPalItem itemWithName:[dict objectForKey:@"title"] withQuantity:(int)[dict objectForKey:@"quantity"] withPrice:[NSDecimalNumber decimalNumberWithString:[dict objectForKey:@"total"]] withCurrency:[dict objectForKey:@"currency"] withSku:@"SKU_product"];
        
        currencyCode=[dict objectForKey:@"currency"];
        //[[NSDecimalNumber alloc] initWithFloat:42.13f]
        
        [items addObject:item1];
        
        float totalInEUR=[[dict objectForKey:@"total"] floatValue];
        
        totalInEUR=totalInEUR/102;
        
        NSString *totalInUSD=[NSString stringWithFormat:@"%0.02f",totalInEUR];
        
        subTotal=[subTotal decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:totalInUSD]];
        
    }
    
    // payment.subTotal = [payment.subTotal decimalNumberByAdding:item.totalPrice];
    NSDecimalNumber *shippinCharges=[[NSDecimalNumber alloc]initWithString:@"0.0"];
    //NSDecimalNumber *subTotal=[PayPalItem totalPriceForItems:items];
    
    if (subTotal<[NSDecimalNumber decimalNumberWithString:@"50.00"]) {
        
        shippinCharges=[[NSDecimalNumber alloc]initWithString:@"1.0"];
        
    }
    
    
    NSDecimalNumber *taxes=[[NSDecimalNumber alloc]initWithString:@"0.0" ];
    
    PayPalPaymentDetails *paymentDetails=[PayPalPaymentDetails paymentDetailsWithSubtotal:subTotal withShipping:shippinCharges withTax:taxes ];
    
    NSDecimalNumber *totalAmount=[[subTotal decimalNumberByAdding:shippinCharges] decimalNumberByAdding:taxes];
    
    
    PayPalPayment *payment=[[PayPalPayment alloc] init];
    payment.amount=totalAmount;
    //payment.currencyCode=currencyCode;
    payment.currencyCode=@"USD";
    payment.shortDescription=@"MY PAYMENT";
    payment.paymentDetails=paymentDetails;
    // self.payPalconfig.acceptCreditCards=self.acceptcre
    PayPalPaymentViewController *viewCont=[[PayPalPaymentViewController alloc]initWithPayment:payment configuration:_payPalconfig delegate:self];
    [self presentViewController:viewCont animated:YES completion:nil];
    
}

-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController{
    NSLog(@"Payment Failed!");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment{
    NSLog(@"Payment Successfull!");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self submitOrder:@"paypal" paidStatus:@"true"];
    
}

- (IBAction)btnStripeTapped:(id)sender
{
    

    
    NSDecimalNumber *subTotal=[[NSDecimalNumber alloc]initWithInt:0];
    
    NSString *currencyCode=@"";
    
    for (int i=0; i<[[SharedManager getInstance].cart count]; i++) {
        
        NSMutableDictionary *dict=[[SharedManager getInstance].cart objectAtIndex:i];
        
        currencyCode=[dict objectForKey:@"currency"];
        //[[NSDecimalNumber alloc] initWithFloat:42.13f]
        
        
        float totalInEUR=[[dict objectForKey:@"total"] floatValue];
        
        //totalInEUR=totalInEUR/102;
        
        NSString *totalInUSD=[NSString stringWithFormat:@"%0.02f",totalInEUR];
        
        subTotal=[subTotal decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:totalInUSD]];
        
    }
    
    // payment.subTotal = [payment.subTotal decimalNumberByAdding:item.totalPrice];
    NSDecimalNumber *shippinCharges=[[NSDecimalNumber alloc]initWithString:@"0.0"];
    //NSDecimalNumber *subTotal=[PayPalItem totalPriceForItems:items];
    
    if (subTotal<[NSDecimalNumber decimalNumberWithString:@"5000.00"]) {
        
        shippinCharges=[[NSDecimalNumber alloc]initWithString:@"100.0"];
        
    }
    
    
    NSDecimalNumber *taxes=[[NSDecimalNumber alloc]initWithString:@"0.0" ];
    
    
    
    NSDecimalNumber *totalAmount=[[subTotal decimalNumberByAdding:shippinCharges] decimalNumberByAdding:taxes];
    
    
    PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
    paymentViewController.amount = totalAmount;
    //paymentViewController.
     paymentViewController.title = @"Order";
    paymentViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (error) {
            //[self showDialougeWithTitle:@"Error" andMessage:[error localizedDescription]];
            NSLog(@"Error");
            
        } else {
           // [self showDialougeWithTitle:@"Success" andMessage:@"Payment Successfully Created."];
            NSLog(@"Success");
            
            [self submitOrder:@"stripe" paidStatus:@"true"];
        }
    }];
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
