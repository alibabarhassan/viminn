//
//  ScanViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 07/12/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "ScanViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ScanViewController (){
 
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scanBtn.center=self.view.center;
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)scanForPrescription:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //imgPopUpView.hidden=YES;
    
    submitBtn.hidden=NO;
    changeBtn.hidden=NO;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [self.scanBtn setImage:chosenImage forState:UIControlStateNormal];
//    profilePhoto.image = chosenImage;
//    
//    NSMutableDictionary *loggedInUser=[SharedManager getInstance].loggedInUser;
//    
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = @"Loading";
//    
//    
//    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
//    
//    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:imageData, @"img_name",loggedInUser[@"user_id"],@"user_id", nil];
//    
//    
//    [SVHTTPRequest POST:@"http://213.136.76.43/quickdiscount/wp-admin/admin-ajax.php?action=qdiscount_user_image_update"
//     
//             parameters:params
//     
//             completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//                 
//                 [MBProgressHUD hideHUDForView:self.view animated:YES];
//                 
//                 NSLog(@"%@",response);
//                 
//                 //NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//                 
//                 
//                 NSMutableDictionary *responseDict=response;
//                 
//                 NSString *errorFlag=[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"error"]];
//                 
//                 if ([errorFlag isEqualToString:@"0"]) {
//                     
//                     imageUrl=[responseDict objectForKey:@"image_path"];
//                     
//                     if (imageUrl.length>0) {
//                         
//                         [[SharedManager getInstance].loggedInUser setObject:imageUrl forKey:@"user_image"];
//                         [[SharedManager getInstance] saveModel];
//                     }
//                     
//                 }else{
//                     
//                     UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Uploading Failed. Try Again Later" preferredStyle:UIAlertControllerStyleAlert];
//                     [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
//                     [self presentViewController:netCont animated:YES completion:nil];
//                     
//                     
//                     
//                 }
//                 
//                 
//             }
//     
//     
//     
//     ];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)submitScan:(id)sender {
}
@end
