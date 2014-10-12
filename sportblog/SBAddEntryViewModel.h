//
//  SBAddEntryViewModel.h
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+SBColor.h"

@interface SBAddEntryViewModel : NSObject

- (instancetype)initWithExercises:(RLMArray *)exercises;
- (instancetype)initWithWorkouts:(RLMArray *)workouts;

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIColor *backgroundColor;

@end
