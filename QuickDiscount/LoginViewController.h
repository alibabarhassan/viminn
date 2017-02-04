//
//  LoginViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 18/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>{

    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
}

- (IBAction)LogIn:(id)sender;
- (IBAction)unwindToLoginController:(UIStoryboardSegue *)unwindSegue;


@end
