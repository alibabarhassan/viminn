//
//  ProCollectionViewCell.h
//  QuickDiscount
//
//  Created by Babar Hassan on 01/02/2017.
//  Copyright © 2017 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *prodImage;
@property (strong, nonatomic) IBOutlet UILabel *prodTitle;
@property (strong, nonatomic) IBOutlet UIImageView *prodRating;
@property (strong, nonatomic) IBOutlet UILabel *prodNumberOfRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProDealsLabel;
@property (strong, nonatomic) IBOutlet UILabel *prodPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *prodSavedMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *prodOptions1;
@property (strong, nonatomic) IBOutlet UILabel *prodOptions2;



@end
