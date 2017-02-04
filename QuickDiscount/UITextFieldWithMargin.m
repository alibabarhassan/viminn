//
//  UITextFieldWithMargin.m
//  QuickDiscount
//
//  Created by Babar Hassan on 18/10/2016.
//  Copyright © 2016 xint sol. All rights reserved.
//

#import "UITextFieldWithMargin.h"

@implementation UITextFieldWithMargin

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

@end
