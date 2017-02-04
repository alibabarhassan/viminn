//
//  MapViewController.h
//  callApp
//
//  Created by IT on 11/10/2016.
//  Copyright © 2016 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    CLLocationCoordinate2D currentLocation;
    int currenDist;
    BOOL firstLaunch;
    int mapflag;
}

@property (strong,nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSString *orderId;

- (IBAction)goBack:(id)sender;

@end
