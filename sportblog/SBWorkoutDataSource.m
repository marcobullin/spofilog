#import "SBWorkoutDataSource.h"
#import "SBWorkout.h"

@implementation SBWorkoutDataSource

- (RLMResults *)allWorkoutsOrderedByDate {
    return [[SBWorkout allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
}

- (SBWorkout *)createWorkoutWithName:(NSString *)name andDate:(NSDate *)date {
    SBWorkout *workout = [SBWorkout new];
    workout.workoutId = [[NSDate date] timeIntervalSince1970];
    workout.name = name;
    workout.date = date;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:workout];
    [realm commitWriteTransaction];
    
    return workout;
}

- (void)deleteWorkoutWithId:(int)workoutId {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"workoutId = %d", workoutId];
    RLMResults *workouts = [SBWorkout objectsWithPredicate:pred];

    if ([workouts count] == 0) {
        return;
    }
    SBWorkout *workout = [workouts firstObject];
    
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
