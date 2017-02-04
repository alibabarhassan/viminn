//
//  CartViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 24/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SharedManager.h"
#import "RNBlurModalView.h"
#import "MBProgressHUD.h"
#import "SVHTTPClient.h"


@interface CartViewController (){
    
    //NSMutableArray *allItems;
    NSMutableArray *currentItems;
    UIView *conformationView;
    RNBlurModalView *modal;
    NSString *code;
    
    
}

@end

@implementation CartViewController
- (void)viewDidLoad {
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    //height=180.0f;
    
    [super viewDidLoad];

    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    NSString *titleString=@"Cart";
    
    [self.navigationItem setTitle:titleString];
    
    currentItems=[NSMutableArray arrayWithArray:[SharedManager getInstance].cart];
    
    [self loadTotal];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTotal{

    float totalCharges=0.0f;
    
    for (int c=0; c<[currentItems count]; c++) {
        
        NSString *price=[[currentItems objectAtIndex:c] objectForKey:@"total"];
        
        totalCharges+=[price floatValue];
    }

    subTotalLabel.text=[NSString stringWithFormat:@"%.02f",totalCharges];
    
    float handlingCharges=[handlingChargesLabel.text floatValue];
    
    totalCharges+=handlingCharges;
    
    TotalLabel.text=[NSString stringWithFormat:@"%.02f",totalCharges];
    
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
    
    CartTableCell *cell=[tableViewOutlet dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth=1.0f;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:indexPath.section];
    
    //cell.layer.cornerRadius=5.0f;
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //cell.layer.borderColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1].CGColor;
    
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.cartName.text=[mainDict objectForKey:@"title"];
    
    cell.cartPrice.text=[NSString stringWithFormat:@"%@ %@",[mainDict objectForKey:@"currency"],[mainDict objectForKey:@"total"]];
    
    
    //cell.itemQuantity.text=[NSString stringWithFormat:@"%@ %@",[mainDict objectForKey:@"quantity"],[mainDict objectForKey:@"type"]];
    
    cell.itemQuantity.text=[mainDict objectForKey:@"type"];
    
    cell.quantityField.text=[mainDict objectForKey:@"quantity"];
    
    cell.cancelBtn.tag=indexPath.section;
    
    cell.showProductBtn.tag=indexPath.section+1000;
    
    cell.plusBtn.tag=indexPath.section+2000;
    
    cell.minusBtn.tag=indexPath.section+3000;
    
    //cell.quantityField.tag
    
    
    
    NSString *urlString=[mainDict objectForKey:@"image"];
    [cell.cartImg setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
 
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}

- (IBAction)showProduct:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    
    int arrayIndex=(int)btn.tag-1000;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:arrayIndex];
    
    NSString *urlString=[mainDict objectForKey:@"image"];
    
    UIImageView *cartImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 280, 192)];
    
    [cartImg setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, 280, 100)];
    
    productLbl.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    
    productLbl.numberOfLines=0;
    
    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    productLbl.textAlignment = NSTextAlignmentCenter;
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [view addSubview:cartImg];
    
    [view addSubview:productLbl];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
        
    modal = [[RNBlurModalView alloc] initWithView:view];
   
    [modal show];
}

-(IBAction)removeObjectFromCart:(id)sender{

    UIButton *btn=(UIButton*)sender;
    
    [currentItems removeObjectAtIndex:btn.tag];
    
    [[SharedManager getInstance].cart removeObjectAtIndex:btn.tag];
    
    [[SharedManager getInstance] saveModel];
    
    [tableViewOutlet reloadData];

    [self loadTotal];
}

- (IBAction)plusClicked:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    
    int arrayIndex=(int)btn.tag-2000;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:arrayIndex];
    
    NSString *qString=[mainDict objectForKey:@"quantity"];
    
    int qInt=[qString intValue];
    
    qInt++;
    
    NSString *unitString=[mainDict objectForKey:@"price"];
    
    float unitFloat=[unitString floatValue];
    
    float totalfloat=qInt*unitFloat;
    
    [mainDict setObject:[NSString stringWithFormat:@"%0.02f",totalfloat] forKey:@"total"];
    
    [mainDict setObject:[NSString stringWithFormat:@"%i",qInt] forKey:@"quantity"];
    
    currentItems[arrayIndex]=mainDict;
    
    [tableViewOutlet reloadData];
    
    [self loadTotal];
}

- (IBAction)minusClicked:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    
    int arrayIndex=(int)btn.tag-3000;
    
    NSMutableDictionary *mainDict=[currentItems objectAtIndex:arrayIndex];
    
    NSString *qString=[mainDict objectForKey:@"quantity"];
    
    int qInt=[qString intValue];
    
    if (qInt>1) {
    
        qInt--;
        
        NSString *unitString=[mainDict objectForKey:@"price"];
        
        float unitFloat=[unitString floatValue];
        
        float totalfloat=qInt*unitFloat;
        
        [mainDict setObject:[NSString stringWithFormat:@"%0.02f",totalfloat] forKey:@"total"];
        
        [mainDict setObject:[NSString stringWithFormat:@"%i",qInt] forKey:@"quantity"];
        
        currentItems[arrayIndex]=mainDict;
        
        [tableViewOutlet reloadData];
        
        [self loadTotal];
    }
    
    
    
    
    
}

- (IBAction)checkOut:(id)sender {
    
    if ([SharedManager getInstance].isLoggedIn) {
        
        if ([TotalLabel.text floatValue]==0.0f) {
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Items Added To Cart" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
            
        }else{
        
            [[SharedManager getInstance].loggedInUser setObject:TotalLabel.text forKey:@"total_cart"];
            [[SharedManager getInstance] saveModel];
        
            [self performSegueWithIdentifier:@"checkMeOut" sender:self];
        }
    }else{
        
        if ([TotalLabel.text floatValue]==0.0f) {
            
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Items Added To Cart" preferredStyle:UIAlertControllerStyleAlert];
            
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];
            
        }else{
    
            [self verifyPhoneNumber];
//            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please Login or Signup to Proceed" preferredStyle:UIAlertControllerStyleAlert];
//            
//            [netCont addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                
//                [self performSegueWithIdentifier:@"cartToLogin" sender:self];
//                
//                
//            }]];
//            
//            [netCont addAction:[UIAlertAction actionWithTitle:@"Signup" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                
//                [self performSegueWithIdentifier:@"cartToSignup" sender:self];
//                
//                
//            }]];
//            
//            [netCont addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//            [self presentViewController:netCont animated:YES completion:nil];
            
            
            
        }
    
    }
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if ([segue.identifier isEqualToString:@"checkout"]) {
         
         [[SharedManager getInstance].loggedInUser setObject:TotalLabel.text forKey:@"total_cart"];
         [[SharedManager getInstance] saveModel];
     
     }
 }

- (IBAction)unwindToHome:(UIStoryboardSegue *)segue{
    
}

- (IBAction)enterBtnClicked:(id)sender {
    
    if (true) {
        
        [modal hide];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Sending Message";
        
        NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"register_user_phone",@"action",phoneField.text,@"phone", nil];
        [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            if (response) {
                
                NSDictionary *result=(NSDictionary*)response;
                
                //if ([result[@"error"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                if ([result[@"error"] isEqualToString:@"0"]) {
                    
                    NSMutableDictionary *userResponse=result[@"user"];
                    
                    [SharedManager getInstance].loggedInUser=[NSMutableDictionary dictionaryWithDictionary:userResponse];
                    //[SharedManager getInstance].isLoggedIn=YES;
                    
                    code=[userResponse objectForKey:@"code"];
                    
                    [[SharedManager getInstance] saveModel];
                
                    
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Login"
                                                                                              message: @"Enter the Code we Sent in SMS"
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"0000";
                        textField.text=code;
                        textField.keyboardType=UIKeyboardTypeNumberPad;
                        textField.textColor = [UIColor blueColor];
                        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        textField.borderStyle = UITextBorderStyleRoundedRect;
                    }];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSArray * textfields = alertController.textFields;
                        UITextField * codefield = textfields[0];
                        NSLog(@"%@",codefield.text);
                        
                        if ([code isEqualToString:codefield.text]) {
                            
                            [SharedManager getInstance].isLoggedIn=YES;
                            [[SharedManager getInstance] saveModel];
                            
                            [self checkOut:nil];
                        }else{
                        
                            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Verification Failed" preferredStyle:UIAlertControllerStyleAlert];
                            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:netCont animated:YES completion:nil];
                        
                        }
                        
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else if(([result[@"error"] isEqualToNumber:[NSNumber numberWithInt:1]])){
                    
                    
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
            
            
        }];
        
    }
    
}

- (IBAction)EnterPressed:(id)sender {
    

    
}

-(void)verifyPhoneNumber{

//    int arrayIndex=(int)btn.tag-1000;
//    
//    NSMutableDictionary *mainDict=[currentItems objectAtIndex:arrayIndex];
//    
//    NSString *urlString=[mainDict objectForKey:@"image"];
//    
//    UIImageView *cartImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 280, 192)];
//    
//    [cartImg setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    UILabel *productLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, 280, 100)];
//    
//    productLbl.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
//    
//    productLbl.numberOfLines=0;
//    
//    [productLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
//    
//    productLbl.textAlignment = NSTextAlignmentCenter;
    
    verifView.hidden=NO;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [verifView setFrame:CGRectMake(0, 0, 300, 300)];
    
    [view addSubview:verifView];
    
    //[view addSubview:productLbl];
    
    view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    
    
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    
    [modal show];


}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}



-(IBAction)textChanged:(id)sender{

    NSString *str=phoneField.text;
    
    [self validatePhone:str];

}

-(void)validatePhone:(NSString*)str{

    if (str.length==11) {
        if ([[str substringToIndex:2] isEqualToString:@"03"] ) {
                enterBtn.hidden=NO;
        }else{
        
            enterBtn.hidden=YES;
        }
        
        
    }else{
    
        enterBtn.hidden=YES;
    }

}

 

@end
