#import "SBWorkoutPresenter.h"

@implementation SBWorkoutPresenter

- (void)removeExerciseWithId:(NSString *)exerciseId {
    
}

- (void)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId {
    [self.view displayExerciseDetails:exercise];
}

- (void)updateWorkoutWithId:(NSString *)workoutId withName:(NSString *)workoutName andDate:(NSDate *)workoutDate {
    [self.view displayUpdatedWorkout];
}

@end
