//
//  CartViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 24/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{

    IBOutlet UILabel *subTotalLabel;

    IBOutlet UILabel *handlingChargesLabel;

    IBOutlet UILabel *TotalLabel;
    
    IBOutlet UIButton *enterBtn;
    IBOutlet UITextField *phoneField;
    IBOutlet UIView *verifView;
    IBOutlet UITableView *tableViewOutlet;
}
- (IBAction)showProduct:(id)sender;

-(IBAction)removeObjectFromCart:(id)sender;
- (IBAction)plusClicked:(id)sender;
- (IBAction)minusClicked:(id)sender;
- (IBAction)checkOut:(id)sender;
- (IBAction)unwindToHome:(UIStoryboardSegue *)segue;
- (IBAction)enterBtnClicked:(id)sender;
-(IBAction)textChanged:(id)sender;



@end
