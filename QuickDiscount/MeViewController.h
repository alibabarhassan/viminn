//
//  MeViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 19/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{

    IBOutlet UITableView *tableViewOutlet;
}

- (IBAction)viewProfile:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)goToFavouries:(id)sender;
- (IBAction)unwindFromMapController:(UIStoryboardSegue *)unwindSegue;
- (IBAction)helpClicked:(id)sender;
- (IBAction)termOfServiceClicked:(id)sender;
- (IBAction)privacyPolicyClicked:(id)sender;
- (IBAction)aboutUsClicked:(id)sender;



@end
