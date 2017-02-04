//
//  PaymentViewController.h
//  QuickDiscount
//
//  Created by Hassan Tarar on 27/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "PayPalConfiguration.h"
#import "PayPalPaymentViewController.h"

@interface PaymentViewController : UIViewController<PayPalPaymentDelegate>

@end
