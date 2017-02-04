//
//  SettingsViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 31/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tableViewOutlet;
}
- (IBAction)goBack:(id)sender;

@end
