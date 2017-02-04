//
//  ShopViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 19/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>{

    IBOutlet UICollectionView *collectionViewOutlet;
    

}

- (IBAction)unwindToShopAndGoToOrder:(UIStoryboardSegue *)segue;
- (IBAction)unwindToHomeAndGoToOrder:(UIStoryboardSegue *)segue;
- (IBAction)callOrder:(id)sender;

@end
