//
//  CartTableCell.h
//  QuickDiscount
//
//  Created by Babar Hassan on 24/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cartImg;
@property (strong, nonatomic) IBOutlet UILabel *cartName;
@property (strong, nonatomic) IBOutlet UILabel *cartPrice;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewBtn;
@property (strong, nonatomic) IBOutlet UILabel *itemQuantity;
@property (strong, nonatomic) IBOutlet UIButton *showProductBtn;

@property (strong, nonatomic) IBOutlet UIButton *plusBtn;
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UITextField *quantityField;


@end
