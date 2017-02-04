//
//  ProductTableViewCell.h
//  QuickDiscount
//
//  Created by Babar Hassan on 22/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *favBtn;
@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (strong, nonatomic) IBOutlet UILabel *proName;
@property (strong, nonatomic) IBOutlet UILabel *proPrice;

@end
