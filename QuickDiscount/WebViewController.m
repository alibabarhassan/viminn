//
//  WebViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 06/12/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "WebViewController.h"
#import "LoadingView.h"

@interface WebViewController (){
    LoadingView *loadingView;

}



@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    loadingView=[[LoadingView alloc]init];
    
    webView.delegate=self;
    
    [self.navigationItem setTitle:@"Hotels Booking"];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    // Do any additional setup after loading the view.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    
    UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"No Internet Connection" preferredStyle:UIAlertControllerStyleAlert];
    [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:netCont animated:YES completion:nil];
    
    [loadingView hide];
}



-(void)webViewDidStartLoad:(UIWebView *)webView{
    [loadingView showInView:self.view withTitle:@"Loading Please Wait!"];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    [loadingView hide];
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

@end
