//
//  SBAddEntryViewModel.m
//  sportblog
//
//  Created by Bullin, Marco on 06.10.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBAddEntryViewModel.h"

@implementation SBAddEntryViewModel

- (instancetype)initWithExercises:(NSArray *)exercises {
    self = [super init];
    
    if (self) {
        if ([exercises count] > 0) {
            _text = NSLocalizedString(@"Add another exercise", nil);
        } else {
            _text = NSLocalizedString(@"Add exercise", nil);
        }
        
        _backgroundColor = [UIColor actionCellColor];
    }
    
    return self;
}

- (instancetype)initWithWorkouts:(NSDictionary *)workouts {
    self = [super init];
    
    if (self) {
        if ([workouts count] > 0) {
            _text = NSLocalizedString(@"Create A New Workout", nil);
        } else {
            _text = NSLocalizedString(@"Create Your First Workout", nil);
        }
        
        _backgroundColor = [UIColor actionCellColor];
    }
    
    return self;
}

@end
