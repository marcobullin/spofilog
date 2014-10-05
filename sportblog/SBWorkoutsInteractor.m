#import "SBWorkoutsInteractor.h"

@implementation SBWorkoutsInteractor

- (RLMArray *)findWorkouts {
    return [[SBWorkout allObjects] arraySortedByProperty:@"date" ascending:NO];
}

- (void)deleteWorkout:(SBWorkout *)workout {
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

- (void)updateWorkout:(SBWorkout *)workout withName:(NSString *)name andDate:(NSDate *)date {
    [workout.realm beginWriteTransaction];
    workout.name = name;
    workout.date = date;
    [workout.realm commitWriteTransaction];
}

- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date {
    SBWorkout *workout = [SBWorkout new];
    workout.name = name;
    workout.date = date;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:workout];
    [realm commitWriteTransaction];
    
    return workout;
}

- (void)removeExerciseAtRow:(int)row fromWorkout:(SBWorkout *)workout {
    [workout.realm beginWriteTransaction];
    [workout.exercises removeObjectAtIndex:row];
    [workout.realm commitWriteTransaction];
}

@end
