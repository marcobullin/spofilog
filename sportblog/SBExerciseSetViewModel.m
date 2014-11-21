//
//  SBExerciseViewModel.m
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBExerciseSetViewModel.h"

@implementation SBExerciseSetViewModel

- (instancetype)initWithExercise:(NSDictionary *)exercise {
    self = [super init];
    
    if (self) {
        _nameText = exercise[@"name"];
        _nameTextColor = [UIColor headlineColor];
        
        _setsText = [NSString stringWithFormat:NSLocalizedString(@"%d Sets", nil), [exercise[@"sets"] count]];
        _setsTextColor = [UIColor textColor];
        
        _frontImages = exercise[@"frontImages"];
        _backImages = exercise[@"backImages"];
    }
    
    return self;
}

@end
