//
//  CategoryCell.h
//  QuickDiscount
//
//  Created by Babar Hassan on 21/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *catImage;
@property (strong, nonatomic) IBOutlet UILabel *catName;
@property (nonatomic,strong) NSString *CategoryId;
@end
