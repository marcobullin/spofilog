#import "SBWorkoutListInteractor.h"
#import "SBWorkoutDataSource.h"
#import "SBWorkout.h"

@implementation SBWorkoutListInteractor

- (void)findAllWorkoutsOrderedByDate {
    RLMResults *workouts = [[SBWorkoutDataSource new] allWorkoutsOrderedByDate];
    
    NSMutableArray *workoutsArray = [NSMutableArray new];
    for (SBWorkout *workout in workouts) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:workout.workoutId forKey:@"workoutId"];
        [dict setObject:workout.name forKey:@"name"];
        [dict setObject:workout.date forKey:@"date"];
        
        [workoutsArray addObject:dict];
    }
    
    [self.output foundWorkouts:workoutsArray];
}

- (void)createWorkout {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    SBWorkout *createdWorkout = [dataSource createWorkoutWithName:NSLocalizedString(@"Workout", nil) andDate:[NSDate date]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               createdWorkout.workoutId,
                                                               createdWorkout.name,
                                                               createdWorkout.date,
                                                               createdWorkout.exercises] forKeys:@[@"workoutId", @"name", @"date", @"exercises"]];
    
    [self.output workoutCreated:dict];
}

- (void)deleteWorkout:(NSDictionary *)workout atIndex:(int)index {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    [dataSource deleteWorkoutWithId:workout[@"workoutId"]];
    
    [self.output workoutDeletedAtIndex:index];
}

@end
