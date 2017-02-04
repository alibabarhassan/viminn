//
//  ProfileViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 03/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    IBOutlet UITableView *tabeViewOutlet;
    
    IBOutlet UIImageView *profilePhoto;

    IBOutlet UIButton *editBtn;
}
- (IBAction)backBtn:(id)sender;
- (IBAction)editBtnClicked:(id)sender;
- (IBAction)uploadPhoto:(id)sender;

@end
