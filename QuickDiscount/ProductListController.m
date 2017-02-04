//
//  ProductListController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 22/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "ProductListController.h"
#import "ProductTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ProductDetailController.h"
#import "SVHTTPClient.h"
#import "SVHTTPRequest.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "CartViewController.h"
#import "ProCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ProductListController (){
    NSMutableArray *allItems;
    NSMutableArray *currentItems;
    IBOutlet UIView *selectedCategory;
    IBOutlet UIView *filtersView;
    float minPrice;
    float maxPrice;
    
    NSMutableDictionary *catDict;
    
    BOOL filterFlag;
    NSString *sText;
    
}

@end

@implementation ProductListController

- (void)viewDidLoad {
    
    catDict=[[SharedManager getInstance] findCategoryFromTitle:self.CategoryName];
    
    [self loadSelectedCat];
    
    if (_isFav) {
        
        [_backBtn setHidden:YES];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        allItems=[SharedManager getInstance].favourites;
        
        if ([allItems count]==0) {
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Favourites Added" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
        }
        
    }else{
        
        [_backBtn setHidden:YES];
        
        allItems=[[SharedManager getInstance].categoriesProducts objectForKey:[catDict objectForKey:@"id"]];
        [self DownloadProductsForCategoryId:[catDict objectForKey:@"id"]];
        
    }
    
    
    
    
    sText=@"";
    
    minPrice=0;
    maxPrice=0;
    
    [super viewDidLoad];
    

    
    MySearchBar.layer.borderWidth=1.0f;
    
    MySearchBar.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    currentItems=[[NSMutableArray alloc]initWithArray:allItems];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
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


-(void)viewDidAppear:(BOOL)animated{

    NSMutableArray* bandArray = [[NSMutableArray alloc] init];
    
    // add some sample data
    [bandArray addObject:@"Offsprings"];
    [bandArray addObject:@"Radiohead"];
    [bandArray addObject:@"Muse"];
    [bandArray addObject:@"R.E.M."];
    [bandArray addObject:@"The Killers"];
    [bandArray addObject:@"Social Distortion"];
    
    // bind yourTextField to DownPicker
    self.downPicker = [[DownPicker alloc] initWithTextField:self.dropDownField withData:bandArray];
    
    [self.downPicker addTarget:self
                            action:@selector(dp_Selected:)
                  forControlEvents:UIControlEventValueChanged];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSelectedCat{
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    NSString *title=[catDict objectForKey:@"title"];
    
    
    title = [title stringByReplacingOccurrencesOfString:@"amp;"
                                             withString:@""];
    
    //self.navigationController.navigationBar.topItem.title = title;
    [self.navigationItem setTitle:title];
    
    [selectedCatTitle setText:title];

}

-(void)DownloadProductsForCategoryId:(NSString*)Id{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    
    NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"category_products",@"action", [catDict objectForKey:@"id"],@"cat_name",nil];
    [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (response) {
            
            NSDictionary *result=(NSDictionary*)response;
            
            if ([result[@"error"] isEqualToString:@"0"]) {
                
                NSMutableArray *userResponse=result[@"category_products"];
                
                allItems=[[NSMutableArray alloc]initWithArray:userResponse];
                
                currentItems=[[NSMutableArray alloc]initWithArray:userResponse];
                
                [[SharedManager getInstance].categoriesProducts setObject:allItems forKey:Id];
                
                [[SharedManager getInstance] saveModel];
                

            }else if(([result[@"error"] isEqualToString:@"1"])){
                
                
                UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:result[@"response"] preferredStyle:UIAlertControllerStyleAlert];
                [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:netCont animated:YES completion:nil];
                
            }else{
                
                UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
                [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:netCont animated:YES completion:nil];
                
            }
            
        }else{
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
            
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [tableViewOutlet reloadData];
        [productCollectionView reloadData];
        
        
    }];
    


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [currentItems count]; // in your case, there are 3 cells
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductTableViewCell *cell=[tableViewOutlet dequeueReusableCellWithIdentifier:@"productTableCell" forIndexPath:indexPath];
    
    //cell.layer.borderWidth=1.0f;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSMutableDictionary *mainDict=[currentItems objectAtIndex:indexPath.section];
    
    //cell.layer.cornerRadius=5.0f;
    
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    
    cell.backgroundColor=[UIColor whiteColor];
    
    if (_isFav) {
        [cell.favBtn setHidden:YES];
    }else{
        [cell.favBtn setHidden:NO];
    }
    
    if ([[SharedManager getInstance] isInFavourites:[mainDict objectForKey:@"id"]]) {
        
        
        [cell.favBtn setImage:[UIImage imageNamed:@"fav_selected"] forState:UIControlStateNormal];
        
        
    }else{
        
        
        [cell.favBtn setImage:[UIImage imageNamed:@"favIcon"] forState:UIControlStateNormal];
    }

    
    cell.proName.text=[mainDict objectForKey:@"title"];
    
    cell.favBtn.tag=indexPath.section;
    
    cell.proPrice.text=[NSString stringWithFormat:@"%@ %@",[mainDict objectForKey:@"currency"],[mainDict objectForKey:@"price"]];
    
    NSString *urlString=[mainDict objectForKey:@"image"];
    [cell.proImage setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //-55 is a tweak value to remove top spacing
    return 5.0f;
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5; // This is the minimum inter item spacing, can be more
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    sText=searchText;
    
    [self applyFilters];
    if ([searchText length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ProductDetailController *proDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetail"];
    
    NSMutableDictionary *currentDict=[currentItems objectAtIndex:indexPath.section];
    
    proDetail.ProductId=[currentDict objectForKey:@"id"];
    
    proDetail.CategoryId=(_isFav)?[currentDict objectForKey:@"catId"]:[catDict objectForKey:@"id"];
    
    [self.navigationController pushViewController:proDetail animated:YES];

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

- (IBAction)gotoCart:(id)sender{
    
    CartViewController *cartV=[self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    
    [self.navigationController pushViewController:cartV animated:YES];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)minMinusClicked:(id)sender {
    
    if (minPrice>0) {
        
        minPrice--;
        
        
        
        if (maxPrice<minPrice) {
            maxPrice=minPrice;
        }
        
        minField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:minPrice]];
        maxField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:maxPrice]];
        
    }
    
    [self applyFilters];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *) bar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? bar.subviews : [[bar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (IBAction)minPlusClicked:(id)sender {
    
    minPrice++;
    
    if (maxPrice<minPrice) {
        maxPrice=minPrice;
    }
    
    minField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:minPrice]];
    maxField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:maxPrice]];
    
    [self applyFilters];
}

- (IBAction)maxMinusClicked:(id)sender {
    
    if (maxPrice>0) {
        
        maxPrice--;
        
        if (maxPrice<minPrice) {
            minPrice=maxPrice;
        }
        
        minField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:minPrice]];
        maxField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:maxPrice]];
        
        
    }
    
    [self applyFilters];
}

- (IBAction)maxPlusClicked:(id)sender {
    
    maxPrice++;
    
    if (maxPrice<minPrice) {
        minPrice=maxPrice;
    }
    
    minField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:minPrice]];
    maxField.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:maxPrice]];
    
    [self applyFilters];
}


-(void)applyFilters{

    
    [currentItems removeAllObjects];
    
    for (int c=0; c<allItems.count; c++) {
        
        
        NSMutableDictionary *item=[allItems objectAtIndex:c];
        
        NSString *name=[item objectForKey:@"title"];
        
        name=[name lowercaseString];
        
        NSString *lowerCaseKey=[sText lowercaseString];
        
        NSString *price=[item objectForKey:@"price"];
        
        float floatPrice=[price floatValue];
        
        if ((((floatPrice>=minPrice)&&(floatPrice<=maxPrice))||(minPrice==0&&maxPrice==0))&&(([name containsString:lowerCaseKey])||(sText.length==0))) {
            
            [currentItems addObject:item];
            
            
        }
    }

    [tableViewOutlet reloadData];
    [productCollectionView reloadData];

}

-(void)removeAllFilters{


    maxPrice=0;
    minPrice=0;
    
    minField.text=[NSString stringWithFormat:@"%f",minPrice];
    maxField.text=[NSString stringWithFormat:@"%f",maxPrice];
    
    MySearchBar.text=@"";
    sText=@"";
    
    currentItems=[[NSMutableArray alloc]initWithArray:allItems];
    
    [tableViewOutlet reloadData];
    [productCollectionView reloadData];


}






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



- (IBAction)addToFav:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    //int btnTag=btn.tag;
    
    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:[currentItems objectAtIndex:btn.tag]];
    
    [mainDict setObject:[catDict objectForKey:@"id"] forKey:@"catId"];
    
    if ([[SharedManager getInstance] isInFavourites:[mainDict objectForKey:@"id"]]) {
        
        [[SharedManager getInstance] removeFromFavourites:[mainDict objectForKey:@"id"]];
        
        [btn setImage:[UIImage imageNamed:@"favIcon"] forState:UIControlStateNormal];
        
        [[SharedManager getInstance] saveModel];
        
        
    }else{
    
        if ([SharedManager getInstance].favourites) {
            
             [[SharedManager getInstance].favourites addObject:mainDict];
            
        }else{
            [SharedManager getInstance].favourites=[[NSMutableArray alloc]initWithObjects:mainDict,nil];
        }
        
       
        [[SharedManager getInstance] saveModel];
        
        [btn setImage:[UIImage imageNamed:@"fav_selected"] forState:UIControlStateNormal];
        
//        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Success" message:@"Added To Favourites" preferredStyle:UIAlertControllerStyleAlert];
//        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:netCont animated:YES completion:nil];
    }
    
    
}

#pragma mark CollectionViewDelegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [currentItems count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProCollectionViewCell *cell=[productCollectionView dequeueReusableCellWithReuseIdentifier:@"proCollection" forIndexPath:indexPath];
    
    //cell.layer.borderWidth=1.0f;
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:indexPath.row];
    
    //cell.layer.cornerRadius=5.0f;
    
    //cell.layer.borderColor=[UIColor blackColor].CGColor;
    
    //cell.backgroundColor=[UIColor whiteColor];
    
//    if (_isFav) {
//        [cell.favBtn setHidden:YES];
//    }else{
//        [cell.favBtn setHidden:NO];
//    }
    
//    if ([[SharedManager getInstance] isInFavourites:[mainDict objectForKey:@"id"]]) {
//        
//        
//        [cell.favBtn setImage:[UIImage imageNamed:@"fav_selected"] forState:UIControlStateNormal];
//        
//        
//    }else{
//        
//        
//        [cell.favBtn setImage:[UIImage imageNamed:@"favIcon"] forState:UIControlStateNormal];
//    }
    
    
    cell.prodTitle.text=[mainDict objectForKey:@"title"];
    
    //cell.favBtn.tag=indexPath.section;
    
    cell.prodPriceLabel.text=[NSString stringWithFormat:@"%@ %@",[mainDict objectForKey:@"currency"],[mainDict objectForKey:@"price"]];
    
    NSString *urlString=[mainDict objectForKey:@"image"];
    [cell.prodImage setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //NSLog(@"test:%ld",(long)indexPath.row%2);
    
    
    //cell.layer.borderWidth=1.0f;
    //cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    UIView *oldView=[cell.contentView viewWithTag:110];
    
    [oldView removeFromSuperview];
    
    if (indexPath.row%2==0) {
        
        UIView *right = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width-0.5, 0.0f, 0.5f, cell.frame.size.height)];
        right.backgroundColor = [UIColor lightGrayColor];
        
        right.tag=110;
        
        [cell.contentView addSubview:right];
        
    }else{
        
        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.5f, cell.frame.size.height)];
        left.backgroundColor = [UIColor lightGrayColor];
        
        left.tag=110;
        [cell.contentView addSubview:left];
    }
    
    
    
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    float height=(collectionView.frame.size.height>423)?collectionView.frame.size.height:423;
    
    CGSize rect=CGSizeMake(collectionView.frame.size.width/2, height);
    
    return rect;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //-55 is a tweak value to remove top spacing
    return CGSizeMake(1, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    ProductDetailController *proDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetail"];
    
    NSMutableDictionary *currentDict=[currentItems objectAtIndex:indexPath.row];
    
    proDetail.ProductId=[currentDict objectForKey:@"id"];
    
    proDetail.CategoryId=(_isFav)?[currentDict objectForKey:@"catId"]:[catDict objectForKey:@"id"];
    
    [self.navigationController pushViewController:proDetail animated:YES];
}

-(void)dp_Selected:(id)dp {
    NSString* selectedValue = [self.downPicker text];
    // do what you want
    
    NSLog(@"%@",selectedValue);
}

- (IBAction)changeView:(id)sender{

    UIButton *btn=(UIButton*)sender;
    
    if (btn.tag==0) {
        
        productCollectionView.hidden=YES;
        
        btn.tag=1;
    }else{
        
        productCollectionView.hidden=NO;
        btn.tag=0;
    }

}

@end
