//
//  UIColor+SBColor.m
//  sportblog
//
//  Created by Bullin, Marco on 23.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "UIColor+SBColor.h"

@implementation UIColor (SBColor)

+ (UIColor *)tableViewColor {
    return [UIColor colorWithRed:140.0/255.0f green:190.0/255.0f blue:230.0/255.0f alpha:1];
}

+ (UIColor *)importantCellColor {
    return [UIColor colorWithRed:90.0/255.0f green:175.0/255.0f blue:230.0/255.0f alpha:1];
}

+ (UIColor *)actionCellColor {
    return [UIColor colorWithRed:40.0/255.0f green:160.0/255.0f blue:240.0/255.0f alpha:1];
}

@end
