//
//  ScanViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 07/12/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CAAnimationDelegate>{

    IBOutlet UIButton *submitBtn;

    IBOutlet UIButton *changeBtn;

}
- (IBAction)scanForPrescription:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)submitScan:(id)sender;

@end
