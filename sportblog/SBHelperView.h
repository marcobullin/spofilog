//
//  SBHelperView.h
//  sportblog
//
//  Created by Marco Bullin on 09/10/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBHelperView : UIView

@property (nonatomic, strong) NSString* message;
@property (nonatomic) CGPoint messagePoint;
@property (nonatomic) CGRect hintPoint;

- (instancetype)initWithMessage:(NSString *)message onPoint:(CGPoint)messagePosition andHintOnPoint:(CGRect)hintPosition andRenderOnView:(UIView *)view;

@end
