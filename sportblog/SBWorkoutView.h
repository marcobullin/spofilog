#import <Foundation/Foundation.h>

@protocol SBWorkoutView <NSObject>

- (void)displayExercises:(NSArray *)exercises;
- (void)deletedExerciseAtIndex:(int)index;
- (void)displayAddedExercise:(NSDictionary *)exercise;
- (void)displayWorkoutWithName:(NSString *)name andDate:(NSDate *)date;

@end

