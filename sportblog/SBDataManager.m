//
//  SBDataManager.m
//  sportblog
//
//  Created by Marco Bullin on 03/10/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBDataManager.h"

@implementation SBDataManager

+ (void)deleteWorkout:(SBWorkout *)workout {
    [RLMRealm.defaultRealm beginWriteTransaction];
    
    // delete exercises
    for (SBExerciseSet *exercise in workout.exercises) {
        
        // delete sets
        for (SBSet *set in exercise.sets) {
            [workout.exercises.realm deleteObject:set];
        }
        
        [workout.realm deleteObject:exercise];
    }
    
    // delete workout
    [RLMRealm.defaultRealm deleteObject:workout];
    [RLMRealm.defaultRealm commitWriteTransaction];
}

@end
