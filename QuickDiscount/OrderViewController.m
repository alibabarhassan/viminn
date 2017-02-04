//
//  OrderViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 19/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderViewCell.h"
#import "MBProgressHUD.h"
#import "SharedManager.h"
#import "SVHTTPClient.h"
#import "SVHTTPRequest.h"
#import "AFNetworking.h"
#import "OrderDetailController.h"
#import "SWRevealViewController.h"
#import "CartViewController.h"


#define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_ 1

@interface OrderViewController (){

    //NSMutableArray *allItems;
    NSMutableArray *currentItems;
    int selectedIndex;
    
}

@end

@implementation OrderViewController
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28/255.0f green:117/255.0f blue:188/255.0f alpha:1];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"options_icon.png"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
    }
    
    currentItems=[SharedManager getInstance].orders;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

   
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self downloadOrders];
    
    NSInteger count=[[SharedManager getInstance].cart count];
    
    UIView *customView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    UIButton *cartBtn=[[UIButton alloc]initWithFrame:customView.frame];
    
    [cartBtn setImage:[UIImage imageNamed:@"cart40"] forState:UIControlStateNormal];
    
    [cartBtn addTarget:self action:@selector(gotoCart:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:cartBtn];
    
    if (count>0)
    {
        
        UILabel *cartCount=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 10, 10)];
        
        cartCount.text=[NSString stringWithFormat:@"%ld",(long)count];
        
        cartCount.layer.borderWidth=1.0f;
        
        cartCount.layer.cornerRadius = 5.0f;
        
        cartCount.layer.borderColor=[UIColor redColor].CGColor;
        
        [cartCount setFont:[UIFont systemFontOfSize:8]];
        
        [cartCount setTextAlignment:NSTextAlignmentCenter];
        
        [cartCount setTextColor:[UIColor whiteColor]];
        
        [customView addSubview:cartCount];
    }
    
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc]
                                  initWithCustomView:customView];
    filterBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = filterBtn;
    
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
    
    //NSLog(@"%li",(long)indexPath.row);
    
    OrderViewCell *cell=[tableViewOutlet dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth=1.0f;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:indexPath.section];
    
    //cell.layer.cornerRadius=5.0f;
    
    NSString *dateCreatedFull=mainDict[@"date_created"];
    
    NSArray *stringArray = [dateCreatedFull componentsSeparatedByString:@"T"];
    
    NSString *dateString=[stringArray objectAtIndex:0];

    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //cell.layer.borderColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1].CGColor;
    
    cell.backgroundColor=[UIColor whiteColor];
    
    //cell.orderNumberLabel.text=[NSString stringWithFormat:@"Order No. %@",[mainDict objectForKey:@"number"]];
    
    cell.orderNumberLabel.text=[NSString stringWithFormat:@"Order Number %@",[mainDict objectForKey:@"number"]];
    
//    cell.totalPriceLabel.text=[NSString stringWithFormat:@"%@ %@",[mainDict objectForKey:@"currency"],[mainDict objectForKey:@"total"]];
    
    cell.totalPriceLabel.text=[NSString stringWithFormat:@"€ %@",[mainDict objectForKey:@"total"]];
    
    cell.dateLabel.text=dateString;
    
    NSString *status=[mainDict objectForKey:@"status"];//deliver,
    
    [cell.statusImg setImage:[UIImage imageNamed:status]];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [currentItems count]; // in your case, there are 3 cells
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex=(int)indexPath.section;
    
    OrderDetailController *orderD=[self.storyboard instantiateViewControllerWithIdentifier:@"detailOrder"];
    orderD.orderIndex=selectedIndex;
    
    [self.navigationController pushViewController:orderD animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

-(void)downloadOrders{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    
    NSString *user_id=[[SharedManager getInstance].loggedInUser objectForKey:@"user_id"];
    NSMutableDictionary *customerParams=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user_id,@"customer_id", nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
     manager.securityPolicy.allowInvalidCertificates = YES;
    
//    [manager GET:@"http://213.136.76.43/quickdiscount/wp-admin/admin-ajax.php?action=list_orders" parameters:customerParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [manager GET:@"http://213.136.76.43/vimmin/wp-admin/admin-ajax.php?action=list_orders" parameters:customerParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        
        NSMutableArray *arr=responseObject;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([arr count]) {
         
            [currentItems removeAllObjects];
            
            [SharedManager getInstance].orders=[[NSMutableArray alloc] initWithArray:arr];
            
            [[SharedManager getInstance] saveModel];
            
            currentItems=[SharedManager getInstance].orders;
            
        }else{
        
            [[SharedManager getInstance].orders removeAllObjects];
            
            [[SharedManager getInstance] saveModel];
            
            [currentItems removeAllObjects];
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Orders placed" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
            
        }
        
        
        [tableViewOutlet reloadData];
        
        
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];
    }];
 
    
}

-(IBAction)gotoCart:(id)sender{
    
    CartViewController *cartV=[self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    
    [self.navigationController pushViewController:cartV animated:YES];
    
}


@end
