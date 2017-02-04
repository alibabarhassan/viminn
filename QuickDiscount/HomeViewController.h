//
//  HomeViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 17/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate,UITabBarControllerDelegate,UIWebViewDelegate>{

    IBOutlet UITableView *mainTableView;
}
- (IBAction)signIn:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)notificationsClicked:(id)sender;

- (IBAction)favouritesClicked:(id)sender;
- (IBAction)helpClicked:(id)sender;
- (IBAction)termOfServiceClicked:(id)sender;
- (IBAction)privacyPolicyClicked:(id)sender;
- (IBAction)unwindToHome:(UIStoryboardSegue *)segue;
- (IBAction)startShopping:(id)sender;
- (IBAction)unwindToHomeAndGoToOrder:(UIStoryboardSegue *)segue;
- (IBAction)callToOrder:(id)sender;
- (IBAction)laundryClicked:(id)sender;
- (IBAction)pharmacyClicked:(id)sender;
- (IBAction)shoesClicked:(id)sender;
- (IBAction)perfumeClicked:(id)sender;
- (IBAction)cenimaBookingClicked:(id)sender;
- (IBAction)hotelBookingClicked:(id)sender;


@end
