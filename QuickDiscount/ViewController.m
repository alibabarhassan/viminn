//
//  ViewController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 18/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "ViewController.h"
#import "SharedManager.h"

@interface ViewController (){

    

}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    
    [SharedManager getInstance].isLoggedIn=NO;
    [[SharedManager getInstance] saveModel];
    
}

@end
