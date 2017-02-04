//
//  ProductListController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 22/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"



@interface ProductListController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{

    IBOutlet UITableView *tableViewOutlet;
    IBOutlet UISearchBar *MySearchBar;
    IBOutlet UITextField *minField;
    IBOutlet UIImageView *selectedCatImage;
    IBOutlet UILabel *selectedCatTitle;

    IBOutlet UITextField *maxField;
    IBOutlet UICollectionView *productCollectionView;
}

- (IBAction)minMinusClicked:(id)sender;
- (IBAction)minPlusClicked:(id)sender;
- (IBAction)maxMinusClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *dropDownField;
- (IBAction)maxPlusClicked:(id)sender;
@property (strong, nonatomic) DownPicker *downPicker;
@property (nonatomic,strong) NSString *CategoryName;
@property (nonatomic) BOOL isFav;
- (IBAction)goBack:(id)sender;
- (IBAction)addToFav:(id)sender;
- (IBAction)changeView:(id)sender;


@end
