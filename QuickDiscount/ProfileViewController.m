//
//  ProfileViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 03/11/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "ProfileViewController.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"
#import "SVHTTPRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ProfileViewController (){

    NSMutableDictionary *userCredentials;
    BOOL editable;
    
    NSString *emailText;
    NSString *passwordText;
    NSString *userName;
    NSString *phoneNumber;
    NSString *addressText;
    NSString *confirmPassword;
    NSString *first_name;
    NSString *last_name;
    
    NSString *imageUrl;
    

    
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    editable=NO;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    userCredentials=[SharedManager getInstance].loggedInUser;
    
    imageUrl=[userCredentials objectForKey:@"user_image"];
    
    if(imageUrl.length>0){
        
        [profilePhoto setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        [profilePhoto setImageWithURL:[NSURL URLWithString:imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    }
        
    
    // Do any additional setup after loading the view.
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
    
    UITableViewCell *cell=[tabeViewOutlet dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UITextField *currentField=[cell viewWithTag:indexPath.section+1];
    
    currentField.backgroundColor=[UIColor clearColor];
    
    if (editable&&indexPath.section>1) {
        
        currentField.borderStyle = UITextBorderStyleRoundedRect;
        [currentField setEnabled:editable];
        cell.backgroundColor=[UIColor clearColor];
        cell.layer.borderWidth=0.0f;
        
    }else{
        
        cell.layer.borderWidth=1.0f;
        
        cell.layer.cornerRadius=5.0f;
        
        cell.layer.borderColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0].CGColor;
        
        cell.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    
        currentField.borderStyle = UITextBorderStyleNone;
        [currentField setEnabled:NO];
    }
    
    
    if (indexPath.section==0) {
        
        [currentField setText:[userCredentials objectForKey:@"user_name"]];
        userName=[userCredentials objectForKey:@"user_name"];
        
    }else if(indexPath.section==1){
    
        [currentField setText:[userCredentials objectForKey:@"email_address"]];
        emailText=[userCredentials objectForKey:@"email_address"];
    
    }else if(indexPath.section==2){
        
        [currentField setText:[userCredentials objectForKey:@"phone_number"]];
        phoneNumber=[userCredentials objectForKey:@"phone_number"];
        
    }else if(indexPath.section==3){
        
        [currentField setText:[userCredentials objectForKey:@"address"]];
        addressText=[userCredentials objectForKey:@"address"];
    }else if(indexPath.section==4){
        
        [currentField setText:[userCredentials objectForKey:@"first_name"]];
        first_name=[userCredentials objectForKey:@"first_name"];
    }else if(indexPath.section==5){
        
        [currentField setText:[userCredentials objectForKey:@"last_name"]];
        last_name=[userCredentials objectForKey:@"last_name"];
    }
    
    
    
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
    return 6; // in your case, there are 3 cells
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(id)sender {
    
    if ([self isModal]) {
        
         [self dismissViewControllerAnimated:YES completion:nil];
    
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

- (IBAction)editBtnClicked:(id)sender {
    
    if (editable) {
        
        if ([self validateForm]) {
            
            //Save
            
            if([self validateForm]){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = @"Loading";
                
                //action=register_user&user_name=ashfaq&password=ashfaq&email=engr.ashfaqkhan@gmail.com&phone_number=123&address=123
                
                NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"update_user_profile",@"action",[userCredentials objectForKey:@"user_id"],@"user_id",phoneNumber,@"phone_number",addressText,@"address",first_name,@"first_name",last_name,@"last_name", nil];//first_name,last_name
                [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    NSLog(@"%@",response);
                    
                    if (response) {
                        
                        NSDictionary *result=(NSDictionary*)response;
                        
                        if ([result[@"error"] isEqualToString:@"0"]) {
                            
                            NSMutableDictionary *userResponse=result[@"user"];
                            
                            [SharedManager getInstance].loggedInUser=[NSMutableDictionary dictionaryWithDictionary:userResponse];
                            [SharedManager getInstance].isLoggedIn=YES;
                            
                            [[SharedManager getInstance] saveModel];
                            
                            userCredentials=[SharedManager getInstance].loggedInUser;
                            
                            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Alert" message:result[@"response"] preferredStyle:UIAlertControllerStyleAlert];
                            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                
                                
                                [tabeViewOutlet reloadData];
                                
                                
                            }]];
                            [self presentViewController:netCont animated:YES completion:nil];
                            
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
                    
                    
                }];
                
            }else{
                
                UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Fields Incorrect/Missing" preferredStyle:UIAlertControllerStyleAlert];
                [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:netCont animated:YES completion:nil];
                
            }
            
            
            [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
            editable=NO;
            
        }else{
        
            UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Fields Incorrect/Missing" preferredStyle:UIAlertControllerStyleAlert];
            [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:netCont animated:YES completion:nil];

            
        }
        
        
    
    }else{
        editable=YES;
        [editBtn setTitle:@"Save" forState:UIControlStateNormal];
        
        [tabeViewOutlet reloadData];
    }
    
    
    
}

- (BOOL)validateForm{

    if ((!([self checkIfNumber:phoneNumber])) || [addressText length]==0 || [first_name length]==0 || [last_name length]==0 ) {
        
        return false;
    }
    
    return true;
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

- (IBAction)uploadPhoto:(id)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Source"
                                                                       message:@"Select one of them."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Camera"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  //NSLog(@"All");
                                                                  //[self item1];
                                                                  [self pickFromCamera:nil];
                                                              }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Gallery"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   //NSLog(@"Near By");
                                                                   [self pickFromGallery:nil];
                                                               }];
        
    
        
        
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Called when user taps outside
        }]];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        //[alert addAction:thirdAction];
    
    
        
        //alert.popoverPresentationController.sourceView = self.profileTableView;
        
        // alert.popoverPresentationController.sourceRect = CGRectMake(self.profileTableView.bounds.size.width / 3.0 , self.profileTableView.bounds.size.height / 2.0 , 1.0, 1.0);
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    
}

- (IBAction)pickFromGallery:(id)sender {
    
    //libCamFlag=YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)pickFromCamera:(id)sender {
    
    //libCamFlag=YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //imgPopUpView.hidden=YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    profilePhoto.image = chosenImage;
    
    NSMutableDictionary *loggedInUser=[SharedManager getInstance].loggedInUser;
    
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:imageData, @"img_name",loggedInUser[@"user_id"],@"user_id", nil];
        
        
//    [SVHTTPRequest POST:@"http://213.136.76.43/quickdiscount/wp-admin/admin-ajax.php?action=qdiscount_user_image_update"
    
    [SVHTTPRequest POST:@"http://quickdiscount.it/wp-admin/admin-ajax.php?action=qdiscount_user_image_update"
                 parameters:params
         
                 completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                     
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     
                     NSLog(@"%@",response);
                     
                     //NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

                     
                     NSMutableDictionary *responseDict=response;
                     
                     NSString *errorFlag=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"error"]];
                     
                     if ([errorFlag isEqualToString:@"0"]) {
                         
                        imageUrl=[responseDict objectForKey:@"image_path"];
                         
                         if (imageUrl.length>0) {
                             
                             [[SharedManager getInstance].loggedInUser setObject:imageUrl forKey:@"user_image"];
                             [[SharedManager getInstance] saveModel];
                         }
                         
                     }else{
                         
                         UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Uploading Failed. Try Again Later" preferredStyle:UIAlertControllerStyleAlert];
                         [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                         [self presentViewController:netCont animated:YES completion:nil];
                         
                         
                         
                     }
                     
                     
                 }
         
         
         
         ];
        
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)checkIfNumber:(NSString*)toCheck{
    
    NSScanner* scan = [NSScanner scannerWithString:toCheck];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int tagNumber=(int)textField.tag;
    
    if (tagNumber==1) {
        
        userName=textField.text;
        
    }else if(tagNumber==2){
        
        emailText=textField.text;
        
    }else if(tagNumber==3){
        
        phoneNumber=textField.text;
        
    }else if(tagNumber==4){
        
        addressText=textField.text;
    }else if(tagNumber==5){
        
        first_name=textField.text;
    }else if(tagNumber==6){
        
        last_name=textField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}


@end
