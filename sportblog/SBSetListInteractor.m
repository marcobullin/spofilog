#import "SBSetListInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBSetListInteractor

- (void)deleteSet:(NSDictionary *)set fromExercise:(NSDictionary *)exercise atIndex:(int)index {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    [dataSource deleteSetWithId:set[@"setId"] fromExerciseWithId:exercise[@"exerciseId"]];
    
    [self.output deletedSetAtIndex:index];
}

- (void)createSetDependingOnSet:(NSDictionary *)set andAddToExercise:(NSDictionary *)exercise {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    SBSet *createdSet = [dataSource createSetWithNumber:[set[@"number"] intValue]+1 weight:[set[@"weight"] floatValue] andRepetitions:[set[@"repetitions"] intValue]];
    
    [dataSource addSet:createdSet toExerciseWithId:exercise[@"exerciseId"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               createdSet.setId,
                                                               [NSString stringWithFormat:@"%d", createdSet.number],
                                                               [NSString stringWithFormat:@"%f", createdSet.weight],
                                                               [NSString stringWithFormat:@"%d", createdSet.repetitions]
                                                               ]
                                                     forKeys:@[
                                                               @"setId",
                                                               @"number",
                                                               @"weight",
                                                               @"repetitions"]];

    
    [self.output createdSet:dict];
}

- (void)createSetDependingOnLastExerciseWithNumber:(int)number andAddToExercise:(NSDictionary *)exercise withFallbackWeight:(float)weight andFallbackRepetitions:(int)repetitions {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    
    SBSet *lastSet = [dataSource lastSetOfExerciseWithName:exercise[@"name"]];
    
    SBSet *createdSet;
    if (lastSet == nil) {
        createdSet = [dataSource createSetWithNumber:number weight:weight andRepetitions:repetitions];
    } else {
        createdSet = [dataSource createSetWithNumber:number weight:createdSet.weight andRepetitions:createdSet.repetitions];
    }

    [dataSource addSet:createdSet toExerciseWithId:exercise[@"exerciseId"]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               createdSet.setId,
                                                               [NSString stringWithFormat:@"%d", createdSet.number],
                                                               [NSString stringWithFormat:@"%f", createdSet.weight],
                                                               [NSString stringWithFormat:@"%d", createdSet.repetitions]
                                                               ]
                                                     forKeys:@[
                                                               @"setId",
                                                               @"number",
                                                               @"weight",
                                                               @"repetitions"]];
    
    [self.output createdSet:dict];
}

@end
