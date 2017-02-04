//
//  OrderDetailCell.h
//  QuickDiscount
//
//  Created by Babar Hassan on 09/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *prodName;
@property (strong, nonatomic) IBOutlet UILabel *prodPriceAndQty;
@property (strong, nonatomic) IBOutlet UIImageView *prodImage;

@end
