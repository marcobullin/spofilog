#import "SBWorkoutPresenter.h"

@implementation SBWorkoutPresenter

- (void)findExercisesFromWorkout:(NSDictionary *)workout {
    [self.workoutInteractor findExercisesFromWorkout:workout];
}

- (void)foundExercises:(NSArray *)exercises {
    [self.view displayExercises:exercises];
}

- (void)addExercise:(NSDictionary *)exercise toWorkout:(NSDictionary *)workout {
    [self.workoutInteractor addExercise:exercise toWorkoutWithId:workout[@"workoutId"]];
}

- (void)addedExercise:(NSDictionary *)exercise {
    [self.view displayAddedExercise:exercise];
}

- (void)removeExercise:(NSDictionary *)exercise fromWorkout:(NSDictionary *)workout atIndex:(int)index {
    [self.workoutInteractor removeExercise:exercise fromWorkout:workout atIndex:index];
}

- (void)exerciseDeletedAtIndex:(int)index {
    [self.view deleteExerciseAtIndex:index];
}

- (void)updateWorkout:(NSDictionary *)workout withName:(NSString *)name andDate:(NSDate *)date {
    if ([name isEqualToString:@""]) {
        name = NSLocalizedString(@"Workout", nil);
    }
    
    [self.workoutInteractor updateWorkout:workout withName:name andDate:date];
}

- (void)updatedWorkoutWithName:(NSString *)name andDate:(NSDate *)date {
    [self.view displayWorkoutWithName:name andDate:date];
}



@end
