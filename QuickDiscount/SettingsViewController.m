//
//  SettingsViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 31/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [currentItems count];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier=[NSString stringWithFormat:@"cellrow%li",(long)indexPath.section];
    
    UITableViewCell *cell=[tableViewOutlet dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.layer.borderWidth=1.0f;
    
    
    cell.layer.cornerRadius=5.0f;
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //cell.layer.borderColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1].CGColor;
    
    //cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
    
}


//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    CGSize rect=CGSizeMake(collectionView.frame.size.width/2-5, collectionView.frame.size.width/2);
//
//    return rect;
//
//
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    //-55 is a tweak value to remove top spacing
//    return -55.0f;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3; // in your case, there are 3 cells
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)goBack:(id)sender {
    
    if ([self isModal]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}
@end
