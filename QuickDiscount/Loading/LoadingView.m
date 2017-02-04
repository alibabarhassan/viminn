//
//  LoadingView.m
//  IVillageToGo
//
//  Created by Jameel khan on 02/04/10.
//  Copyright 2010 LUMS. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView
@synthesize spinner;


-(id)init
{

    if (self = [super initWithFrame:CGRectMake(0, 0, 200, 60)]) {
        // Initialization code
        
        
        //self.backgroundColor = [UIColor colorWithWhite: 1.0 alpha: 0.9];
        self.backgroundColor = [UIColor lightGrayColor];
        self.backgroundColor = [UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:0.9];
        self.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        self.alpha = 0.0;
        self.clipsToBounds = YES;
        if ([self.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) self.layer setCornerRadius: 10];
                
        
        label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, 20)] ;
        label.text = NSLocalizedString(@"Loading...", nil);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize: 15];
        [self addSubview:label];
        
        self.spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        self.spinner.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 +10);
        [self addSubview:self.spinner];
        
        
    }
    return self;
    

}


-(void)showInView:(UIView *)targetView withTitle:(NSString *)title
{


    label.text=title;
    [targetView addSubview:self];
    
    
    [self.spinner startAnimating];
	
    self.center = CGPointMake(targetView.bounds.size.width / 2, targetView.bounds.size.height / 2);
    self.alpha=1.0;
    [targetView bringSubviewToFront:self];
    targetView.userInteractionEnabled=NO;


}

-(void)showInView:(UIView *)targetView withTitle:(NSString *)title withSizeOf:(UIView *)sizeView{
    
    label.text=title;
    [targetView addSubview:self];
    [self.spinner startAnimating];
    
    self.center = CGPointMake(sizeView.frame.size.width / 2, sizeView.frame.size.height / 2);
    self.alpha=1.0;
    targetView.userInteractionEnabled=NO;
    
}

-(void)hide
{
    
    UIView *superView= [self superview];
    superView.userInteractionEnabled=YES;
    [self removeFromSuperview];
    [self.spinner stopAnimating];

}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {

	//[spinner release];
	//[super dealloc];

}


@end
