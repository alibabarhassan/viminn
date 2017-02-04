//
//  SharedManager.m
//  TimeTraveller
//
//  Created by Jawad Sheikh on 9/24/12.
//  Copyright 2012 Xint Solutions. All rights reserved.
//

#import "SharedManager.h"


@implementation SharedManager

@synthesize loggedInUser,isLoggedIn,categories,categoriesProducts,cart,favourites,orders,checkOutDetail;

static SharedManager *instance= NULL;

+(SharedManager *)getInstance
{
	
	@synchronized (self)
	{
		if(instance==NULL)
		{
			instance=[SharedManager loadModel];
			
		}
	}
	
	return instance;
    
//    static id sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
}


-(id)init
{
	if(self== [super init])
	{
        loggedInUser=[[NSMutableDictionary alloc]init];
        categoriesProducts=[[NSMutableDictionary alloc]init];
        checkOutDetail=[[NSMutableDictionary alloc]init];
        categories=[[NSMutableArray alloc]init];
        favourites=[[NSMutableArray alloc]init];
        cart=[[NSMutableArray alloc]init];
        orders=[[NSMutableArray alloc]init];
        isLoggedIn=NO;
    }
	
	return self;
	
}

+(id)loadModel
{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data= [prefs objectForKey:@"qucikdiscout"];
    SharedManager *anInstance=nil;
    
    
    if(!data)
        anInstance= [[SharedManager alloc] init];
    else
        anInstance= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
	return anInstance;
	
}

-(void)saveModel
{
	
	
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:instance];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:data forKey:@"qucikdiscout"];
	
    [prefs synchronize];
	
}





- (void)encodeWithCoder:(NSCoder *)encoder
{

    
    [encoder encodeObject:loggedInUser forKey:@"logedInUser"];
    [encoder encodeObject:categories forKey:@"categories"];
    [encoder encodeObject:favourites forKey:@"favouritesss"];
    [encoder encodeObject:cart forKey:@"carttt"];
    [encoder encodeObject:orders forKey:@"ordersttt"];
    [encoder encodeObject:categoriesProducts forKey:@"categoriesProducts"];
    [encoder encodeObject:checkOutDetail forKey:@"checkOutDetail"];
    [encoder encodeBool:isLoggedIn forKey:@"isLoggedInBoolean"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
	
	if(self== [super init])
	{
       
        self.loggedInUser = [decoder decodeObjectForKey:@"logedInUser"];
        self.categories = [decoder decodeObjectForKey:@"categories"];
        self.favourites = [decoder decodeObjectForKey:@"favouritesss"];
        self.cart = [decoder decodeObjectForKey:@"carttt"];
        self.orders = [decoder decodeObjectForKey:@"ordersttt"];
        self.categoriesProducts = [decoder decodeObjectForKey:@"categoriesProducts"];
        self.checkOutDetail = [decoder decodeObjectForKey:@"checkOutDetail"];
        self.isLoggedIn = [decoder decodeBoolForKey:@"isLoggedInBoolean"];
        
	}	
	return self;
}

-(NSMutableDictionary*)findCategoryFromTitle:(NSString*)title{
    
    for (int c=0; c<[categories count]; c++) {
        
        NSMutableDictionary *dict=[categories objectAtIndex:c];
        NSString *catTitle=[dict objectForKey:@"title"];
        NSString *lowerCaseKey=[catTitle lowercaseString];
        NSString *lowerCaseTitle=[title lowercaseString];
        
        if ([lowerCaseTitle isEqualToString:lowerCaseKey]) {
            return dict;
        }
        
    }
    
    return nil;
    
}


-(NSMutableDictionary*)findCategoryFromId:(NSString*)catId{
    
    for (int c=0; c<[categories count]; c++) {
        
        NSMutableDictionary *dict=[categories objectAtIndex:c];
        NSString *itemCatId=[dict objectForKey:@"id"];
        if ([catId isEqualToString:itemCatId]) {
            return dict;
        }
        
    }
    
    return nil;
    
}


-(NSMutableDictionary*)findProductFromCategoryId:(NSString*)catId andProductId:(NSString*)productId{
    
    NSMutableArray *allItems=[categoriesProducts objectForKey:catId];
    
    for (int c=0; c<[allItems count]; c++) {
        
        NSMutableDictionary *dict=[allItems objectAtIndex:c];
        NSString *itemProId=[dict objectForKey:@"id"];
        if ([productId isEqualToString:itemProId]) {
            return dict;
        }
        
    }
    
    return nil;
    
}

-(NSMutableDictionary*)findProductFromProductId:(NSString*)productId{
    
   NSMutableArray *allItems;
    
    for(NSString *key in categoriesProducts){
    
        allItems=[categoriesProducts objectForKey:key];
        
        for (int c=0; c<[allItems count]; c++) {
        
            NSMutableDictionary *dict=[allItems objectAtIndex:c];
            NSString *itemProId=[dict objectForKey:@"id"];
            if ([productId isEqualToString:itemProId]) {
                return dict;
            }
        
        }
    }
    return nil;
    
}



-(BOOL)isInFavourites:(NSString*)productId{
    
    //NSMutableArray *allItems=[categoriesProducts objectForKey:catId];
    
    for (int c=0; c<[favourites count]; c++) {
        
        NSMutableDictionary *dict=[favourites objectAtIndex:c];
        NSString *itemProId=[dict objectForKey:@"id"];
        if ([productId isEqualToString:itemProId]) {
            return YES;
        }
        
    }
    
    return NO;
    
}


-(void)removeFromFavourites:(NSString*)productId{
    
    //NSMutableArray *allItems=[categoriesProducts objectForKey:catId];
    
    NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:favourites];;
    
    for (int c=0; c<[temp count]; c++) {
        
        NSMutableDictionary *dict=[temp objectAtIndex:c];
        NSString *itemProId=[dict objectForKey:@"id"];
        if ([productId isEqualToString:itemProId]) {
          [favourites removeObjectAtIndex:c];
        }
        
    }
    
    [self saveModel];
    
   // return NO;
    
}



-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
