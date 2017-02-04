//
//  SubmitViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 29/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <GooglePlaces/GooglePlaces.h>


@interface SubmitViewController : UIViewController<UITextFieldDelegate,GMSAutocompleteViewControllerDelegate>{

    IBOutlet UITextField *firstNameField;
    
    IBOutlet UITextField *lastNameField;
    
    IBOutlet UITextField *addressField;
    
    IBOutlet UITextField *address2Field;
    
    IBOutlet UITextField *cityField;

    IBOutlet UITextField *stateField;
    
    IBOutlet UITextField *postCodeField;
    
    IBOutlet UITextField *countryField;
    
    IBOutlet UITextField *emailField;
    
    IBOutlet UITextField *phoneNumberField;
    
    
    
}
- (IBAction)submitClicked:(id)sender;
- (IBAction)onLaunchClicked:(id)sender;

@end
