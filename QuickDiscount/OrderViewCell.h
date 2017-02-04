//
//  OrderViewCell.h
//  QuickDiscount
//
//  Created by Babar Hassan on 25/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImg;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;



@end
