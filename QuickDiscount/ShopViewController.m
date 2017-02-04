//
//  ShopViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 19/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "ShopViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CategoryCell.h"
#import "ProductListController.h"
#import "SVHTTPClient.h"
#import "SVHTTPRequest.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "CartViewController.h"
#import "SWRevealViewController.h"

@interface ShopViewController (){
    
    float height;
    NSMutableArray *allItems;
    NSMutableArray *currentItems;
    IBOutlet UISearchBar *mySearchBar;
    

}

@end

@implementation ShopViewController



- (void)viewDidLoad {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28/255.0f green:117/255.0f blue:188/255.0f alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToLaundry:)
                                                 name:@"GoToLaundry"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToPharmacy:)
                                                 name:@"GoToPharmacy"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToShoes:)
                                                 name:@"GoToShoes"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToPerfume:)
                                                 name:@"GoToPerfume"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToCenima:)
                                                 name:@"GoToCenima"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToMobile:)
                                                 name:@"GoToMobile"
                                               object:nil];
    
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"options_icon.png"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
    }
    
    [self loadCategories];
    
    mySearchBar.layer.borderWidth=0.0f;
    
    mySearchBar.backgroundImage=[[UIImage alloc]init];
    
    mySearchBar.layer.borderColor=[[UIColor colorWithRed:69/255.0f green:70/255.0f blue:73/255.0f alpha:1] CGColor];
    
    allItems=[SharedManager getInstance].categories;
    
    currentItems=[[NSMutableArray alloc]initWithArray:allItems];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    NSInteger count=[[SharedManager getInstance].cart count];
    
    [self.view layoutIfNeeded];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
        [collectionViewOutlet scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];

        
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
return [currentItems count]+1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row<[currentItems count]){
    
    CategoryCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth=0.0f;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:indexPath.row];
    
    //cell.layer.cornerRadius=2.0f;
    
    cell.layer.borderColor=[[UIColor colorWithRed:69/255.0f green:70/255.0f blue:73/255.0f alpha:1] CGColor];
    
    cell.backgroundColor=[UIColor whiteColor];
    
    NSString *title=[mainDict objectForKey:@"title"];
    
    
    title = [title stringByReplacingOccurrencesOfString:@"amp;"
                                         withString:@""];
    
    cell.catName.text=title;
    
    [cell.catName setTextColor:[UIColor colorWithRed:69/255.0f green:70/255.0f blue:73/255.0f alpha:1]];
    
    cell.CategoryId=[mainDict objectForKey:@"id"];
    
    NSString *urlString=[mainDict objectForKey:@"image"];
    
    if (urlString.length>0) {
        
        [cell.catImage setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }else{
    
        
        [cell.catImage setImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    
        return cell;
    
    }else{
        
            UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"lastCell" forIndexPath:indexPath];
            return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGSize rect=CGSizeMake(collectionView.frame.size.width/2-5, collectionView.frame.size.width/3.5);
    
    if (indexPath.row==[currentItems count]) {
        
        rect=CGSizeMake(collectionView.frame.size.width, 40.0f);
    }
    
    return rect;


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //-55 is a tweak value to remove top spacing
    return CGSizeMake(1, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length>0) {
        
    
    
        [currentItems removeAllObjects];
    
        for (int c=0; c<allItems.count; c++) {
    
            
            NSMutableDictionary *item=[allItems objectAtIndex:c];
            
            NSString *name=[item objectForKey:@"title"];
    
            name=[name lowercaseString];
            
            NSString *lowerCaseKey=[searchText lowercaseString];
            
            if ([name containsString:lowerCaseKey]) {
    
                [currentItems addObject:item];
    
    
            }
        }
    
    }else{
    
        currentItems=[[NSMutableArray alloc]initWithArray:allItems];
    
    }
    
    [collectionViewOutlet reloadData];
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableDictionary *mainDict=[currentItems objectAtIndex:indexPath.row];
    
    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=[mainDict objectForKey:@"title"];
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}


-(IBAction)goToPharmacy:(id)sender{

    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=@"pharmacy";
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];


}


-(IBAction)goToLaundry:(id)sender{
    
    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=@"Lavasecco";
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];
    
    
}

-(IBAction)goToShoes:(id)sender{
    
    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=@"scarpe";
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];
    
    
}


-(IBAction)goToPerfume:(id)sender{
    
    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=@"profumo";
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];
    
    
}


-(IBAction)goToCenima:(id)sender{
    
    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=@"biglietti del cinema";
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];
    
    
}

-(IBAction)goToMobile:(id)sender{

    ProductListController *proList=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductList"];
    
    proList.CategoryName=@"mobile e tablet";
    
    proList.isFav=NO;
    
    [self.navigationController pushViewController:proList animated:YES];

}


-(void)loadCategories{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    
    NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"get_all_categories",@"action", nil];
    [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (response) {
            
            NSDictionary *result=(NSDictionary*)response;
            
            if ([result[@"error"] isEqualToString:@"0"]) {
                
                NSMutableArray *userResponse=result[@"categories"];
                
                [allItems removeAllObjects];
                [currentItems removeAllObjects];
                
                
                
                for (int c=0;c<[userResponse count];c++) {
                    
                    [allItems addObject:[userResponse objectAtIndex:c]];
                    [currentItems addObject:[userResponse objectAtIndex:c]];
                }
                
                [SharedManager getInstance].categories=[NSMutableArray arrayWithArray:allItems];
                
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
        
        [collectionViewOutlet reloadData];
        
        
    }];



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



-(IBAction)gotoCart:(id)sender{

    CartViewController *cartV=[self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    
    [self.navigationController pushViewController:cartV animated:YES];
    
}

- (IBAction)unwindToHomeAndGoToOrder:(UIStoryboardSegue *)segue{
    
    
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)callOrder:(id)sender {
    NSString *listingPhoneNumber=@"+923217711167";
    
    NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",listingPhoneNumber ];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:phoneCallNum] options:@{} completionHandler:nil];
    
    NSLog(@"phone btn touch %@", phoneCallNum);
}

- (IBAction)unwindToShopAndGoToOrder:(UIStoryboardSegue *)segue {
    
    [self.tabBarController setSelectedIndex:2];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
