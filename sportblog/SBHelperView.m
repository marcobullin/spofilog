//
//  SBHelperView.m
//  sportblog
//
//  Created by Marco Bullin on 09/10/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBHelperView.h"

@implementation SBHelperView

- (instancetype)initWithMessage:(NSString *)message onPoint:(CGPoint)messagePosition andHintOnPoint:(CGPoint)hintPosition andRenderOnView:(UIView *)view {
    self = [super init];
    
    if (self) {
        
        NSString *key = message;
        
        BOOL wasShown = false;//[[NSUserDefaults standardUserDefaults] boolForKey:key];
        
        if (wasShown) {
            return self;
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        }
        
        self.opaque = NO;
    
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messagePosition.x, messagePosition.y, 320, 44)];
        messageLabel.text = message;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [messageLabel.font fontWithSize:25];
    
        [self addSubview:messageLabel];
        
        _hintPoint = hintPosition;
        
        [view addSubview:self];
        
        [self performSelector:@selector(remove:) withObject:nil afterDelay:3.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
    return self;
}

- (void)remove:(id)sender {
    [self removeFromSuperview];
}

- (void)drawRect:(CGRect)rect {
    CGRect holeRect = CGRectMake(_hintPoint.x, _hintPoint.y, 50, 50);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor );
    CGContextFillRect( context, rect );
    
    CGRectIntersection( holeRect, rect );
    
    CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    CGContextFillEllipseInRect( context, holeRect );
}

@end
