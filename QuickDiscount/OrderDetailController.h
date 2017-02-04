//
//  OrderDetailController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 09/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    
    IBOutlet UITableView *tableViewOutlet;
    
}


- (IBAction)unwindFromMapController:(UIStoryboardSegue *)unwindSegue;
@property (nonatomic) int orderIndex;
@end
