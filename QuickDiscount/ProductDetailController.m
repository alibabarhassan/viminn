//
//  ProductDetailController.m
//  QuickDiscount
//
//  Created by Babar Hassan on 22/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "ProductDetailController.h"
#import "CartViewController.h"
#import "SharedManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "RNBlurModalView.h"

@interface ProductDetailController (){
    
    NSMutableDictionary *productDict;

}

@end

@implementation ProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    productDict=[[SharedManager getInstance] findProductFromCategoryId:self.CategoryId andProductId:self.ProductId];
    
    [self loadProduct];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    
    
}

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

-(void)loadProduct{

    NSString *urlString=[productDict objectForKey:@"image"];
    
    [mainImageView setImageWithURL:[NSURL URLWithString:urlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString *titleString=[productDict objectForKey:@"title"];
    
    titleLabel.text=titleString;
    
    [self.navigationItem setTitle:titleString];
    
    NSString *unitPrice=[productDict objectForKey:@"price"];
    
    unitPriceField.text=unitPrice;

}

-(void)viewDidLayoutSubviews{
    
    
    
    

    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    titleLabel.layer.cornerRadius=5.0f;
    
    minusLabel.layer.borderWidth = 1;
    minusLabel.layer.borderColor=[minusLabel.backgroundColor CGColor];
    minusLabel.layer.cornerRadius=5.0f;
    
    plusLabel.layer.borderWidth = 1;
    plusLabel.layer.borderColor=[plusLabel.backgroundColor CGColor];
    plusLabel.layer.cornerRadius=5.0f;

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

- (IBAction)minusClicked:(id)sender {
    
    int currentNumber=[itemCountField.text intValue];
    
    if (currentNumber>0) {
        
        currentNumber--;
        
        itemCountField.text=[NSString stringWithFormat:@"%i",currentNumber];
        
        int unitPrice=[unitPriceField.text intValue];
        
        int totalAmount=currentNumber*unitPrice;
        
        totalAmountField.text=[NSString stringWithFormat:@"%i",totalAmount];
        
    
    }
    
}

- (IBAction)plusClicked:(id)sender {
    
    int currentNumber=[itemCountField.text intValue];
    currentNumber++;
    itemCountField.text=[NSString stringWithFormat:@"%i",currentNumber];
    
    float unitPrice=[unitPriceField.text floatValue];
    
    float totalAmount=currentNumber*unitPrice;
    
    totalAmountField.text=[NSString stringWithFormat:@"%.02f",totalAmount];
    
    itemCountField.text=[NSString stringWithFormat:@"%i",currentNumber];
}


- (IBAction)addToCartClicked:(id)sender{
    
    NSString *totalAmount=totalAmountField.text;
    
    NSString *totalQty=itemCountField.text;
    
    if ([totalAmount isEqualToString:@"0"]) {
        
        UIAlertController *netCont=[UIAlertController alertControllerWithTitle:@"Error" message:@"Weight/Quantity cannot be 0" preferredStyle:UIAlertControllerStyleAlert];
        [netCont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:netCont animated:YES completion:nil];
        
    }else{
    
        NSMutableDictionary *cartItem=[[NSMutableDictionary alloc]initWithDictionary:productDict];
        
        [cartItem setObject:totalAmount forKey:@"total"];
        
        [cartItem setObject:totalQty forKey:@"quantity"];
        
        [[SharedManager getInstance].cart addObject:cartItem];
        [[SharedManager getInstance] saveModel];
    
        CartViewController *proDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    
        [self.navigationController pushViewController:proDetail animated:YES];
    }

}

- (IBAction)showPopUp:(id)sender {
    
    //UIButton *btn=(UIButton*)sender;
    
    //int arrayIndex=(int)btn.tag-1000;
    
    //NSMutableDictionary *mainDict=[currentItems objectAtIndex:arrayIndex];
    
    NSString *urlString=[productDict objectForKey:@"image"];
    
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
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithView:view];
    
    [modal show];
}

-(IBAction)gotoCart:(id)sender{
    
    CartViewController *cartV=[self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    
    [self.navigationController pushViewController:cartV animated:YES];
    
}

@end
