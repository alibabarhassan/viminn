//
//  SignUpViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 18/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>

- (IBAction)signUp:(id)sender;
- (IBAction)unwindToSignUpController:(UIStoryboardSegue *)unwindSegue;


@end
