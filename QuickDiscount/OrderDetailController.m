//
//  OrderDetailController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 09/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderDetailCell.h"
#import "MBProgressHUD.h"
#import "SharedManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MapViewController.h"


@interface OrderDetailController (){

    NSMutableDictionary *mainDict;
    NSMutableArray *lineItems;
    NSString *selectedOrderId;

}

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    //height=180.0f;
    
    [super viewDidLoad];
    
    //currentItems=[[NSMutableArray alloc]initWithArray:allItems];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    //    UIImage *logoImage = [UIImage imageNamed:@"qd80x80.png"];
    //    if (logoImage == nil) {
    //        NSLog(@"Can't open logo image");
    //    }
    //
    //    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    //
    //    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithCustomView:logoImageView];
    //    [self.navigationItem setLeftBarButtonItem:logoItem animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //[self downloadOrders];
    
    
//    NSString *title=@"Order Items";
//    
//    //UIBarButtonItem *mapBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location"] style:UIBarButtonItemStylePlain target:self action:@selector(reOrder:)];
//    
//    
//    
//    UIButton *mapButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [mapButton setBackgroundImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
//    
//    [mapButton addTarget:self action:@selector(gotoMap:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navigationItem setTitle:title];
//    self.navigationItem.titleView=mapButton;
//    
    //UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc]
    //initWithTitle:@"ReOrder" style:UIBarButtonItemStylePlain target:self action:@selector(reOrder:)];
    
    self.navigationController.navigationBar.hidden=NO;
    
    mainDict=[[SharedManager getInstance].orders objectAtIndex:self.orderIndex];
    
    selectedOrderId=[NSString stringWithFormat:@"%@",[mainDict objectForKey:@"id"]];
    
    lineItems=[mainDict objectForKey:@"line_items"];
    
    UIView * container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [button addTarget:self action:@selector(gotoMap:) forControlEvents:UIControlEventTouchUpInside];
    //[button setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    //button.tintColor=[UIColor whiteColor];
    [button setTitle:@"View Map" forState:UIControlStateNormal];
    [container addSubview:button];
    self.navigationItem.titleView = container;
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reorder"] style:UIBarButtonItemStylePlain target:self action:@selector(reOrder:)];
    
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
    
    OrderDetailCell *cell=[tableViewOutlet dequeueReusableCellWithIdentifier:@"orderDCell" forIndexPath:indexPath];
    
    
    NSMutableDictionary *lineItem=[lineItems objectAtIndex:indexPath.section];
    
//    NSMutableDictionary *itemDict=[[SharedManager getInstance] findProductFromProductId:[NSString stringWithFormat:@"%@",[lineItem objectForKey:@"product_id"]]];
//    
    cell.layer.borderWidth=1.0f;
    
    //cell.layer.cornerRadius=5.0f;
    
    
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //cell.layer.borderColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1].CGColor;
    
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.prodName.text=[NSString stringWithFormat:@"%@",[lineItem objectForKey:@"name"] ];
    
    cell.prodPriceAndQty.text=[NSString stringWithFormat:@"%@ %@           Qunatity %@",[mainDict objectForKey:@"currency"],[lineItem objectForKey:@"total"],[lineItem objectForKey:@"quantity"]];
    
    //[NSString stringWithFormat:@"%@ %@",[mainDict objectForKey:@"currency"],[mainDict objectForKey:@"total"]]
    
    NSString *urlString=[lineItem objectForKey:@"product_img"];
    [cell.prodImage setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
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
    return [lineItems count]; // in your case, there are 3 cells
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//
//    if (searchText.length>0) {
//
//
//
//        [currentItems removeAllObjects];
//
//        for (int c=0; c<allItems.count; c++) {
//
//
//            NSMutableDictionary *item=[allItems objectAtIndex:c];
//
//            NSString *name=[item objectForKey:@"name"];
//
//            name=[name lowercaseString];
//
//            NSString *lowerCaseKey=[searchText lowercaseString];
//
//            if ([name containsString:lowerCaseKey]) {
//
//                [currentItems addObject:item];
//
//
//            }
//        }
//
//    }else{
//
//        currentItems=[[NSMutableArray alloc]initWithArray:allItems];
//
//    }
//
//    [tableViewOutlet reloadData];
//
//
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    selectedIndex=(int)indexPath.section;
//    
//    OrderDetailController *orderD=[self.storyboard instantiateViewControllerWithIdentifier:@"detailOrder"];
//    orderD.orderIndex=selectedIndex;
//    
//    [self.navigationController pushViewController:orderD animated:YES];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

-(IBAction)reOrder:(id)sender{

    [[SharedManager getInstance].cart removeAllObjects];
    for (int c=0; c<[lineItems count]; c++) {
        
        NSMutableDictionary *item=[lineItems objectAtIndex:c];
        
        NSString *totalAmount=[NSString stringWithFormat:@"%@",[item objectForKey:@"total"]];
        NSString *totalQty=[NSString stringWithFormat:@"%@",[item objectForKey:@"quantity"]];
        
        NSString *productId=[NSString stringWithFormat:@"%@",[item objectForKey:@"product_id"]];
        
        NSMutableDictionary *cartItem=[[NSMutableDictionary alloc]initWithDictionary:[[SharedManager getInstance] findProductFromProductId:productId]];
        
        //[cartItem setObject:totalAmount forKey:@"total"];
        cartItem[@"total"]= totalAmount;
        
        //[cartItem setObject:totalQty forKey:@"quantity"];
        cartItem[@"quantity"]= totalQty;
        [[SharedManager getInstance].cart addObject:cartItem];
    }
    
    [[SharedManager getInstance] saveModel];
    
    
    [self performSegueWithIdentifier:@"showCart" sender:self];
    

}

-(IBAction)gotoMap:(id)sender{

    //[self performSegueWithIdentifier:@"showMapViewC" sender:self];
    
    MapViewController *mapC=[self.storyboard instantiateViewControllerWithIdentifier:@"mapController"];
    mapC.orderId = selectedOrderId;
    
    [self.navigationController pushViewController:mapC animated:YES];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showMapViewC"]) {
//        
//        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
//        MapViewController *mapC =[nav.viewControllers objectAtIndex:0];
        
    }

}

- (IBAction)unwindFromMapController:(UIStoryboardSegue *)unwindSegue
{
    
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//    if ([segue.identifier isEqualToString:@"detailOrder"]) {
//
//        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
//        
//        OrderDetailController *orderD =[nav.viewControllers objectAtIndex:0];
//        orderD.orderIndex = selectedIndex;
//        //proList.isFav = YES;
//    }
//}

@end
