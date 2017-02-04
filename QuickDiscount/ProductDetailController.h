//
//  ProductDetailController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 22/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailController : UIViewController{

    IBOutlet UILabel *titleLabel;

    IBOutlet UIImageView *mainImageView;

    IBOutlet UILabel *minusLabel;

    IBOutlet UILabel *plusLabel;
    
    IBOutlet UITextField *itemCountField;
    
    IBOutlet UITextField *unitPriceField;
    
    IBOutlet UITextField *totalAmountField;
    
}

- (IBAction)minusClicked:(id)sender;

- (IBAction)plusClicked:(id)sender;

- (IBAction)addToCartClicked:(id)sender;

- (IBAction)showPopUp:(id)sender;
@property (nonatomic,strong) NSString *CategoryId;

@property (nonatomic,strong) NSString *ProductId;


@end
