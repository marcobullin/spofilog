//
//  SBExerciseViewModel.h
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBExerciseSet.h"
#import "UIColor+SBColor.h"

@interface SBExerciseSetViewModel : NSObject

- (instancetype)initWithExercise:(SBExerciseSet *)exercise;

@property (nonatomic, readonly) NSString *nameText;
@property (nonatomic, readonly) NSString *setsText;
@property (nonatomic, readonly) UIColor *nameTextColor;
@property (nonatomic, readonly) UIColor *setsTextColor;

@end
