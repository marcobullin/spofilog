#import "SBWorkoutInteractor.h"
#import "SBWorkoutDataSource.h"
#import "SBWorkout.h"

@implementation SBWorkoutInteractor

- (void)findAllWorkoutsOrderedByDate {
    RLMResults *workouts = [[SBWorkoutDataSource new] allWorkoutsOrderedByDate];
    
    NSMutableArray *workoutsArray = [NSMutableArray new];
    for (SBWorkout *workout in workouts) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:[NSString stringWithFormat:@"%d", workout.workoutId] forKey:@"workoutId"];
        [dict setObject:workout.name forKey:@"name"];
        [dict setObject:workout.date forKey:@"date"];
        
        [workoutsArray addObject:dict];
    }
    
    [self.output foundWorkouts:workoutsArray];
}

- (void)createWorkout {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    SBWorkout *createdWorkout = [dataSource createWorkoutWithName:NSLocalizedString(@"Workout", nil) andDate:[NSDate date]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[createdWorkout.name, createdWorkout.date, createdWorkout.exercises] forKeys:@[@"name", @"date", @"exercises"]];
    
    [self.output workoutCreated:dict];
}

- (void)removeWorkoutWithId:(NSString *)workoutId atIndexPath:(NSIndexPath *)indexPath {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    [dataSource deleteWorkoutWithId:[workoutId intValue]];
    
    [self.output workoutDeletedAtIndexPath:indexPath];
}

@end
