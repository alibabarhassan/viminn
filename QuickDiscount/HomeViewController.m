//
//  HomeViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 17/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductListController.h"
#import "RNBlurModalView.h"
#import "SWRevealViewController.h"
#import "SharedManager.h"
#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "SVHTTPClient.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WebViewController.h"
#import "LoadingView.h"


@interface HomeViewController (){

    CATransition * slideTransition;
    int indexR;
    float isPlaying;
    AVPlayer *player;
    RNBlurModalView *modal;
    LoadingView *loadingView;
    UIActivityIndicatorView *activity;
    int collectionButtonCount;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    collectionButtonCount=6;
    
    UIImageView *titleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 148, 40)];
    
    titleImageView.image=[UIImage imageNamed:@"header_text"];
    
    self.navigationItem.titleView = titleImageView;
    
    isPlaying=false;
    [self loadCategories];
    
    self.tabBarController.delegate=self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28/255.0f green:117/255.0f blue:188/255.0f alpha:1];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES
//                                            withAnimation:UIStatusBarAnimationFade];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replay:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signInWithToggle:)
                                                 name:@"GoToLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favouritesClickedWithToggle:)
                                                 name:@"GoToFav"
                                               object:nil];
    
    
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:28/255.0f green:117/255.0f blue:188/255.0f alpha:1];
    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"options_icon.png"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = revealButtonItem;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    indexR=0;
    
    
    
    //[self startAnimation:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

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


#pragma mark - TableViewDelegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; // in your case, there are 3 cells
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"tableCell%li",(long)indexPath.section]];
    
    cell.backgroundColor=[UIColor whiteColor];
    
    if (indexPath.section==0) {
        
//        UIImageView *imageView=[cell viewWithTag:112];
//        imageView.animationImages = [NSArray arrayWithObjects:
//                                     [UIImage imageNamed:@"img10.png"],
//                                     [UIImage imageNamed:@"img11.png"],
//                                     [UIImage imageNamed:@"img12.png"],
//                                     [UIImage imageNamed:@"img13.png"],nil];
//        [imageView setAnimationRepeatCount:10];
//        imageView.animationDuration =1.5;
//        [imageView startAnimating];
        
//        NSURL *url=[NSURL URLWithString:@"http://213.136.76.43/quickdiscount/wp-content/uploads/coke_s.3gp"];
        
        NSURL *url=[NSURL URLWithString:@"http://213.136.76.43/quickdiscount/wp-content/uploads/coke_l.mp4"];
        player = [AVPlayer playerWithURL:url];
        
        player.muted = YES;
        // create a player view controller
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        [controller.view setFrame:cell.contentView.bounds];
        [cell.contentView addSubview:controller.view];
        //[cell presentViewController:controller animated:YES completion:nil];
        controller.player = player;
        [player play];
        isPlaying=YES;
        //[player pause];
        
    }
//    if (indexPath.section==1) {
//        
//        UICollectionView *collectionView=[cell viewWithTag:114];
//        
//        [collectionView setContentSize:CGSizeMake(tableView.frame.size.width, 4*tableView.frame.size.width/3+20)];
//        
//        
//    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //-55 is a tweak value to remove top spacing
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        return 2*tableView.frame.size.width/4;
    }else if (indexPath.section==1){
        return 3*tableView.frame.size.width/3+20;
        
    }else if (indexPath.section==2){
        //return 131.0f;
        return 40.0f;
    }else{
        return 40.0f;
    }

}


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section>0) {

        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }else{
        
        if (isPlaying) {
            
            [player pause];
            isPlaying=NO;
            
        }else{
            
            [player play];
            isPlaying=YES;
        }
    
    }

}

#pragma mark - CollectionView Delegates


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionButtonCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%li",(long)indexPath.item] forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    
    UIView *oldView=[cell.contentView viewWithTag:110];
    
    [oldView removeFromSuperview];
    
    UIView *oldView2=[cell.contentView viewWithTag:111];
    
    [oldView2 removeFromSuperview];
    
    UIView *oldView3=[cell.contentView viewWithTag:112];
    
    [oldView3 removeFromSuperview];
    
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
    
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, 0.5f)];
    top.backgroundColor = [UIColor lightGrayColor];
    
    top.tag=111;
    
    [cell.contentView addSubview:top];
    
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0.0f, cell.frame.size.height-0.5, cell.frame.size.width, 0.5f)];
    bottom.backgroundColor = [UIColor lightGrayColor];
    
    bottom.tag=111;
    
    [cell.contentView addSubview:bottom];
    
    
    if (indexPath.row==0||indexPath.row==1) {
        top.hidden=YES;
    }
    
    if (((indexPath.row==collectionButtonCount-2)&&(collectionButtonCount%2==0))||indexPath.row==collectionButtonCount-1) {
        bottom.hidden=YES;
    }
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize rect=CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.width/3);
    
    return rect;
    
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signIn:(id)sender {
    
    [self performSegueWithIdentifier:@"goToSignIn" sender:self];
    
}

- (IBAction)signInWithToggle:(id)sender {
    
    

    [self.revealViewController revealToggle:nil];
    
    [self.tabBarController setSelectedIndex:0];
    
    [self performSegueWithIdentifier:@"goToSignIn" sender:self];
    
}

- (IBAction)createAccount:(id)sender {
    
    
}

- (IBAction)notificationsClicked:(id)sender {
    
    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 280, 100)];
    
    productLbl.text=@"No Notifications To Show";
    
    productLbl.numberOfLines=0;
    
    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    productLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:productLbl];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
    [modal show];
    
    
}
- (IBAction)favouritesClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"showFavN" sender:self];

}


- (IBAction)laundryClicked:(id)sender {

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToLaundry"
     object:self];
    
    [self.tabBarController setSelectedIndex:1];

}

- (IBAction)pharmacyClicked:(id)sender {

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToPharmacy"
     object:self];
    
    [self.tabBarController setSelectedIndex:1];

}

//- (IBAction)laundryClicked:(id)sender {}


- (IBAction)favouritesClickedWithToggle:(id)sender {
    
    [self.revealViewController revealToggle:nil];
    
    [self.tabBarController setSelectedIndex:0];
    
    [self performSegueWithIdentifier:@"showFavN" sender:self];
    
    
}

- (IBAction)helpClicked:(id)sender {
    
    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 280)];
    
    productLbl.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
    
    productLbl.numberOfLines=0;
    
    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    productLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:productLbl];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
    [modal show];
}

- (IBAction)termOfServiceClicked:(id)sender {
    
    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 280)];
    
    productLbl.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
    
    productLbl.numberOfLines=0;
    
    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    productLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:productLbl];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
    [modal show];
}

- (IBAction)privacyPolicyClicked:(id)sender {
    
    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 280)];
    
    productLbl.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
    
    productLbl.numberOfLines=0;
    
    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    productLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    //[view addSubview:cartImg];
    
    [view addSubview:productLbl];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
    [modal show];
}


-(void) createNewImage {
    //imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,460)];
    
    
    //[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(setLastImage:) userInfo:nil repeats:NO];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showFavN"]) {
        //UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        
        //ProductListController *proList =[nav.viewControllers objectAtIndex:0];
        ProductListController *proList =segue.destinationViewController;
        proList.CategoryName = @"Favourites";
        proList.isFav = YES;
    }
}

- (IBAction)startAnimation:(UIButton *)sender
    {
        slideTransition = [CATransition animation]; // CATransition * slideTransition; instance variable
        slideTransition.duration = 2;
        slideTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        slideTransition.type = kCATransitionPush;
        slideTransition.delegate = self;
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(slideShow) userInfo:nil repeats:YES];
        [timer fire];
}
-(void)slideShow
{
        slideTransition.subtype =kCATransitionFromRight; // or kCATransitionFromRight
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        UITableViewCell* cell = [mainTableView cellForRowAtIndexPath:indexPath];
        
        UIImageView *animatedImageView=[cell viewWithTag:112];

        [animatedImageView.layer addAnimation:slideTransition forKey:nil];
        
        if (indexR < 2) // NSUInteger  index; instance variable
        {
            indexR++;
            
        }
        else
        {
            indexR=0;
        }
        
        UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"slider0%i.png",indexR]];
        
        UIImageView *replacementView=[[UIImageView alloc]initWithFrame:animatedImageView.frame];
        
        [replacementView setImage:img];
        
        [UIView transitionFromView:animatedImageView
                            toView:replacementView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        completion:nil];
        
        animatedImageView=nil;
        replacementView.tag=112;
        
        
        //[animatedImageView setImage:img];
        
    }

- (IBAction)unwindToHome:(UIStoryboardSegue *)segue {
    
}


- (IBAction)unwindToHomeAndGoToOrder:(UIStoryboardSegue *)segue {
    
    
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)callToOrder:(id)sender {
    
    NSString *listingPhoneNumber=@"+923217711167";
    
    NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",listingPhoneNumber ];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:phoneCallNum] options:@{} completionHandler:nil];
    
    NSLog(@"phone btn touch %@", phoneCallNum);
}



- (IBAction)startShopping:(id)sender {
    
    [self.tabBarController setSelectedIndex:1];
}

-(IBAction)gotoCart:(id)sender{
    
    CartViewController *cartV=[self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    
    [self.navigationController pushViewController:cartV animated:YES];
    
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
                
                //[allItems removeAllObjects];
                //[currentItems removeAllObjects];
                
                NSMutableArray *allItems=[[NSMutableArray alloc]init];
                
                for (int c=0;c<[userResponse count];c++) {
                    
                    [allItems addObject:[userResponse objectAtIndex:c]];
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
        
        //[collectionViewOutlet reloadData];
        
        
    }];
    
    
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    
    
    NSLog(@"Tab index = %u", (int)indexOfTab);
    
    if (indexOfTab==1) {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];

    }
    
    
    
}


- (IBAction)shoesClicked:(id)sender{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToShoes"
     object:self];
    
    [self.tabBarController setSelectedIndex:1];

}
- (IBAction)perfumeClicked:(id)sender{

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToPerfume"
     object:self];
    
    [self.tabBarController setSelectedIndex:1];

}

- (IBAction)cenimaBookingClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToCenima"
     object:self];
    
    [self.tabBarController setSelectedIndex:1];
    
    
}
- (IBAction)tabClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoToMobile"
     object:self];
    
    [self.tabBarController setSelectedIndex:1];
    
}

- (IBAction)hotelBookingClicked:(id)sender {
    
    UIButton *btn=sender;

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading Please Wait";
    
        if (btn.tag==1) {
    
            
            
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-40, screenHeight-40)] ;
            
            webV.delegate=self;
            
            [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/hotel/"]]];
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
            
            //[view addSubview:cartImg];
            
            [view addSubview:webV];
            
            view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
            
            
            view.layer.cornerRadius = 5.f;
            view.layer.borderColor = [UIColor blackColor].CGColor;
            view.layer.borderWidth = 2.f;
            
//            activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(view.center.x, view.center.y, 50, 50)];
//            
//            activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
//            
//            [view addSubview:activity];
//            
//            [activity startAnimating];
            
            modal = [[RNBlurModalView alloc] initWithView:view];
            
//            [modal show];
            
            
    
        }else if(btn.tag==2){
    
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-40, screenHeight-40)] ;
            
            webV.delegate=self;
            
            [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/prenotazioni-aeree/"]]];
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
            
            //[view addSubview:cartImg];
            
            [view addSubview:webV];
            
            view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
            
            
            view.layer.cornerRadius = 5.f;
            view.layer.borderColor = [UIColor blackColor].CGColor;
            view.layer.borderWidth = 2.f;
            
            modal = [[RNBlurModalView alloc] initWithView:view];
            

            
        }else if(btn.tag==3){
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            UIWebView *webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-40, screenHeight-40)] ;
            
            webV.delegate=self;
            
            [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quickdiscount.it/cinema/"]]];
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, screenHeight-20)];
            
            //[view addSubview:cartImg];
            
            [view addSubview:webV];
            
            view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
            
            
            view.layer.cornerRadius = 5.f;
            view.layer.borderColor = [UIColor blackColor].CGColor;
            view.layer.borderWidth = 2.f;
            
            modal = [[RNBlurModalView alloc] initWithView:view];
            
            
            
        }
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    
    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:netCont animated:YES completion:nil];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



//-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [loadingView showInView:self.view withTitle:@"Loading Please Wait!"];
//    
//}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [modal show];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)replay:(NSNotification *)notification
{
    
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
    player.muted = YES;
    [player play];
}

@end
