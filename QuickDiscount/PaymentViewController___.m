//
//  PaymentViewController.m
//  QuickDiscount
//
//  Created by Hassan Tarar on 27/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()
@property(nonatomic,strong)PayPalConfiguration *payPalconfig;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)payPalPaymentProcess:(id)sender {
    
    PayPalItem *item1=[PayPalItem itemWithName:@"Iphone6" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"999"] withCurrency:@"USD" withSku:@"SKU-IPHONE6"];
    PayPalItem *item2=[PayPalItem itemWithName:@"Iphone7" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"1999"] withCurrency:@"USD" withSku:@"SKU-IPHONE7"];
    NSArray *items=@[item1,item2];
    
    NSDecimalNumber *subTotal=[PayPalItem totalPriceForItems:items];
    NSDecimalNumber *shippinCharges=[[NSDecimalNumber alloc]initWithString:@"10.0" ];
    NSDecimalNumber *taxes=[[NSDecimalNumber alloc]initWithString:@"75.0" ];
    
    PayPalPaymentDetails *paymentDetails=[PayPalPaymentDetails paymentDetailsWithSubtotal:subTotal withShipping:shippinCharges withTax:taxes ];
    
    NSDecimalNumber *totalAmount=[[subTotal decimalNumberByAdding:shippinCharges] decimalNumberByAdding:taxes];
    
    
    PayPalPayment *payment=[[PayPalPayment alloc] init];
    payment.amount=totalAmount;
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
