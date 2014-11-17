#import "SBWorkoutListPresenter.h"

@implementation SBWorkoutListPresenter

- (void)findWorkouts {
    [self.workoutInteractor findAllWorkoutsOrderedByDate];
}

- (void)foundWorkouts:(NSArray *)workouts {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"EEEE"];
    
    NSMutableArray *displayData = [NSMutableArray new];
    for (NSDictionary *workout in workouts) {
        NSDate *date = [workout objectForKey:@"date"];
        NSString *day = [dateFormatter2 stringFromDate:date];
        
        NSString *displayDate = [NSString stringWithFormat:@"%@ - %@", day, [dateFormatter stringFromDate:date]];
        NSString *displayName = [workout objectForKey:@"name"];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:displayName forKey:@"name"];
        [dict setObject:displayDate forKey:@"date"];
        
        [displayData addObject:dict];
    }
    
    [self.view displayWorkouts:displayData];
}

- (void)createWorkout {
    [self.workoutInteractor createWorkout];
}

- (void)workoutCreated:(NSDictionary *)workout {
    [self.view displayWorkoutDetails:workout];
}

- (void)removeWorkout:(NSDictionary *)workout atIndexPath:(NSIndexPath *)indexPath {
    [self.workoutInteractor removeWorkoutWithId:[workout objectForKey:@"workoutId"] atIndexPath:indexPath];
}

- (void)workoutDeletedAtIndexPath:(NSIndexPath *)indexPath {
    [self.view removeWorkoutAtIndexPath:indexPath];
}

@end
