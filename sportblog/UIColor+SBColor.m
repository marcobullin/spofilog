#import "UIColor+SBColor.h"

@implementation UIColor (SBColor)

+ (UIColor *)navigationBarColor {
    return [UIColor colorWithRed:60.0/255.0f green:110.0/255.0f blue:150.0/255.0f alpha:1];
}

+ (UIColor *)tableViewColor {
    return [UIColor whiteColor];//[UIColor colorWithRed:140.0/255.0f green:190.0/255.0f blue:230.0/255.0f alpha:1];
}

+ (UIColor *)importantCellColor {
    return [UIColor colorWithRed:40.0/255.0f green:160.0/255.0f blue:240.0/255.0f alpha:1];
}

+ (UIColor *)actionCellColor {
    return [UIColor colorWithRed:90.0/255.0f green:175.0/255.0f blue:230.0/255.0f alpha:1];
}

+ (UIColor *)textColor {
    return [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1];
}

+ (UIColor *)highlightColor {
    return [UIColor colorWithRed:76.0/255.0f green:217.0/255.0f blue:100.0/255.0f alpha:1];
}

+ (UIColor *)headlineColor {
    return [UIColor colorWithRed:150.0/255.0f green:93.0/255.0f blue:60.0/255.0f alpha:1];
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:235.0/255.0f alpha:1];
}

@end
