//
//  WebViewController.h
//  QuickDiscount
//
//  Created by Babar Hassan on 06/12/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>{

    IBOutlet UIWebView *webView;
}

@property (nonatomic,strong) NSString *urlString;

@end
