//
//  SelectPaymentController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 11/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"
#import "PaymentViewController.h"

@interface SelectPaymentController : UIViewController<PayPalPaymentDelegate,PaymentViewControllerDelegate>


-(IBAction)CashOnDelivery:(id)sender;
-(IBAction)Paypal:(id)sender;

@end
