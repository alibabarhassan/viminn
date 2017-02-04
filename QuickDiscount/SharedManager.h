//
//  SharedManager.h
//  TimeTraveller
//
//  Created by Jawad Sheikh on 9/24/12.
//  Copyright 2012 Xint Solutions. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@interface SharedManager : NSObject <NSCoding>
{
   
    NSMutableDictionary *loggedInUser;
    NSMutableDictionary *categoriesProducts;
    NSMutableArray *categories;
    NSMutableArray *favourites;
    NSMutableArray *cart;
    NSMutableArray *orders;
    BOOL isLoggedIn;
    NSMutableDictionary *checkOutDetail;
    
    
}

@property(nonatomic,strong)NSMutableDictionary *loggedInUser;
@property(nonatomic,strong)NSMutableDictionary *categoriesProducts;
@property(nonatomic,strong)NSMutableDictionary *checkOutDetail;
@property(nonatomic,strong)NSMutableArray *categories;
@property(nonatomic,strong)NSMutableArray *favourites;
@property(nonatomic,strong)NSMutableArray *cart;
@property(nonatomic,strong)NSMutableArray *orders;
@property(nonatomic)BOOL isLoggedIn;

+(SharedManager *)getInstance;

+(id)loadModel;
-(void)saveModel;

-(NSMutableDictionary*)findCategoryFromTitle:(NSString*)title;
-(NSMutableDictionary*)findCategoryFromId:(NSString*)catId;
-(NSMutableDictionary*)findProductFromCategoryId:(NSString*)catId andProductId:(NSString*)productId;
-(BOOL)isInFavourites:(NSString*)productId;
-(NSMutableDictionary*)findProductFromProductId:(NSString*)productId;
-(void)removeFromFavourites:(NSString*)productId;

@end
