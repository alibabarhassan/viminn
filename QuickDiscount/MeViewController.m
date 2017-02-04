//
//  MeViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 19/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "MeViewController.h"
#import "SharedManager.h"
#import "ProductListController.h"
#import "RNBlurModalView.h"
#import "LoadingView.h"
#import "MBProgressHUD.h"

@interface MeViewController (){
    LoadingView *loadingView;
    RNBlurModalView *modal;
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    NSString *identifier=[NSString stringWithFormat:@"cellrow%li",(long)indexPath.section+1];
    
    UITableViewCell *cell=[tableViewOutlet dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.layer.borderWidth=1.0f;
    
    
    cell.layer.cornerRadius=5.0f;
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //cell.layer.borderColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1].CGColor;
    
    cell.backgroundColor=[UIColor whiteColor];
    
//    if ((indexPath.section+1)==4) {
//        
//        UIButton *logOutBtn=[cell viewWithTag:112];
//        
//        if ([SharedManager getInstance].isLoggedIn) {
//            
//            [logOutBtn setTitle:@"Logout" forState:UIControlStateNormal];
//            
//        }else{
//            
//            [logOutBtn setTitle:@"Login" forState:UIControlStateNormal];
//        }
//        
//    }
    
    return cell;
    
}

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

- (IBAction)viewProfile:(id)sender {
    
    if ([SharedManager getInstance].isLoggedIn) {
        
        [self performSegueWithIdentifier:@"showProfile" sender:self];
        
    }else{
    
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Alert" message:@"User must be logged in to go to Profile" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];
    }
    
}

- (IBAction)logOut:(id)sender {
    
    
    if([SharedManager getInstance].isLoggedIn){
    
    
        [SharedManager getInstance].isLoggedIn=NO;
    
        [[SharedManager getInstance] saveModel];
    
        [tableViewOutlet reloadData];
        
    }else{
        
        //[self performSegueWithIdentifier:@"sideBarToLogin" sender:self];
        
        
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GoToLogin"
         object:self];
    }
    
    
}

- (IBAction)goToFavouries:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToFav"
     object:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showFav"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        
        ProductListController *proList =[nav.viewControllers objectAtIndex:0];
        proList.CategoryName = @"Favourites";
        proList.isFav = YES;
    }
}

- (IBAction)unwindFromMapController:(UIStoryboardSegue *)unwindSegue
{
    
    
}


- (IBAction)helpClicked:(id)sender {
    
//    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 280)];
//    
//    productLbl.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
//    
//    productLbl.numberOfLines=0;
//    
//    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
//    
//    productLbl.textAlignment = NSTextAlignmentCenter;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading Please Wait";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)] ;
    
    webV.delegate=self;
    
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/termini-di-servizio/"]]];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:webV];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
    
}

- (IBAction)termOfServiceClicked:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading Please Wait";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)] ;
    
    webV.delegate=self;
    
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/termini-di-servizio/"]]];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:webV];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
}

- (IBAction)privacyPolicyClicked:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading Please Wait";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)] ;
    
    webV.delegate=self;
    
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/politica-sulla-riservatezza/"]]];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:webV];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
}

- (IBAction)aboutUsClicked:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading Please Wait";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)] ;
    
    webV.delegate=self;
    
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/riguardo-a-noi/"]]];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:webV];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    
    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:netCont animated:YES completion:nil];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}





-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    [modal show];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
