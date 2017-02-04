//
//  MapViewController.m
//  callApp
//
//  Created by IT on 11/10/2016.
//  Copyright © 2016 Xint Solutions. All rights reserved.
//

#import "MapViewController.h"
#import "SVHTTPClient.h"
#import "SharedManager.h"
#import "MBProgressHUD.h"

@interface MapViewController (){
    //SingleUser *loggedINUser;
    int flag;
    NSTimer *updateLoc;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    
    flag=0;
    
    if (self.orderId) {
        
        [self getLatLong:nil];
    
    }else{
    
        NSMutableArray *orders=[SharedManager getInstance].orders;
        
        if ([orders count]>0) {
            
            NSMutableDictionary *lastOrder=[orders objectAtIndex:0];
            
            self.orderId=[NSString stringWithFormat:@"%@",[lastOrder objectForKey:@"id"]];
            
            NSLog(@"%@",lastOrder);
            
            [self getLatLong:nil];
            
        }else{
        
            
        
        }
        
        
        
    
    }
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //loggedINUser=[[SharedManager getInstance].loggedInUser objectAtIndex:0];
    
    [self.navigationItem setTitle:@"Order Location"];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    // Ensure that you can view your own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager startUpdatingLocation];
    //[self plotPositions:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    updateLoc=[NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(getLatLong:) userInfo:nil repeats:YES];
    flag=0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)getLatLong:(id)sender{

    if (self.orderId.length>0) {
        
        if (flag==0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"Updating Location";
        }
    
    
    
    NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"qdridergetorderlatlong",@"action",self.orderId,@"order_id", nil];
    [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (response) {
            
            NSDictionary *result=(NSDictionary*)response;
            
            if ([result[@"error"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                
                NSMutableDictionary *latLng=result[@"data"];
                
                [self plotPositions:latLng];
                
              
            }else if([result[@"error"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                
                
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
        
        if (flag==0) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            flag++;
        }
        
        
        
    }];
    }
        


}






- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    
    
}



-(void)plotPositions:(NSMutableDictionary *)data {
   
    
    CLLocationCoordinate2D placeCoord;
    
    NSString *lati = [data objectForKey:@"latitude"];
    NSString *longi = [data objectForKey:@"longtitude"];
    
    placeCoord.latitude=[lati doubleValue];
    placeCoord.longitude=[longi doubleValue];
    
    MapPoint *placeObject = [[MapPoint alloc] initWithName:@"Rider Name 2342332" address:nil coordinate:placeCoord];
    
    [self.mapView addAnnotation:placeObject];
    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(placeCoord,1000,1000);
    currentLocation.latitude=[lati doubleValue];
    currentLocation.longitude=[longi doubleValue];
    [self.mapView setRegion:region animated:YES];
    
//    placeCoord.latitude=(long)data[@"store_latitude"];;
//    placeCoord.longitude=(long)data[@"store_longitude"];;
//    placeObject = [[MapPoint alloc] initWithName:@"Friend Name" address:nil coordinate:placeCoord];
//    
//    [self.mapView addAnnotation:placeObject];
  
    
///////////-----------server code-------------/////////
//    
//    NSDictionary *parameters=[[NSDictionary alloc]initWithObjectsAndKeys:@"contacts",@"action",loggedINUser.userid,@"userid", nil];
//    [[SVHTTPClient sharedClient] GET:@"" parameters:parameters completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        
//        
//        
//        NSMutableDictionary *responseDict=response;
//        
//        NSMutableDictionary *responseDictionary=[responseDict objectForKey:@"message"];
//        
//       // NSString *responseText=[responseDictionary objectForKey:@"response"];
//        
//        NSString *errorFlag=[NSString stringWithFormat:@"%@",[responseDictionary objectForKey:@"error"]];
//        
//        if ([errorFlag isEqualToString:@"0"]) {
//            
//            NSLog(@"%@",responseDictionary);
//            
//            NSMutableArray *users=[responseDictionary objectForKey:@"users"];
//            
//            //[[SharedManager getInstance].friends removeAllObjects];
//            //[friendsArray removeAllObjects];
//            //[namesArray removeAllObjects];
//            //[namesFilteredArray removeAllObjects];
//            
//            for (int c=0; c<users.count; c++) {
//                
//                NSMutableDictionary *itemDict=[users objectAtIndex:c];
//                
////                SingleUser *SingleU=[[SingleUser alloc]init];
////                
////                SingleU.userid=[itemDict objectForKey:@"userid"];
////                SingleU.fullname=[itemDict objectForKey:@"fullname"];
////                SingleU.email=[itemDict objectForKey:@"email"];
////                SingleU.fbid=[itemDict objectForKey:@"fbid"];
////                SingleU.gender=[itemDict objectForKey:@"gender"];
////                SingleU.interestedin=[itemDict objectForKey:@"interestedin"];
////                SingleU.relationship=[itemDict objectForKey:@"relationship"];
////                SingleU.lookingfor=[itemDict objectForKey:@"lookingfor"];
////                SingleU.timezone=[itemDict objectForKey:@"timezone"];
////                SingleU.longitude=[itemDict objectForKey:@"longitude"];
////                SingleU.latitude=[itemDict objectForKey:@"latitude"];
////                SingleU.age=[itemDict objectForKey:@"age"];
////                SingleU.login_status=[itemDict objectForKey:@"login_status"];
////                SingleU.msg_txt=[itemDict objectForKey:@"msg_txt"];
////                SingleU.objectIndex=c;
////                
////                SingleU.picturesUrl=[itemDict objectForKey:@"pictureurl"];
//               
//                if([[itemDict objectForKey:@"distance"] integerValue]<5000){
//                    
//               
//                    CLLocationCoordinate2D placeCoord;
//                    placeCoord.latitude=[[itemDict objectForKey:@"latitude"]doubleValue];
//                    placeCoord.longitude=[[itemDict objectForKey:@"longitude"] doubleValue];
//                    MapPoint *placeObject = [[MapPoint alloc] initWithName:[itemDict objectForKey:@"fullname"] address:nil coordinate:placeCoord];
//                    
//                    [self.mapView addAnnotation:placeObject];
//                    
//                }
//                
//               
//            }
//        }
//        
//            
//            }];

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
    
    if ([updateLoc isValid])
    {
        [updateLoc invalidate];
        updateLoc=nil;
        flag=0;
    }
    
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
