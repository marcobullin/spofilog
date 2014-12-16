#import "SBSetListInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBSetListInteractor

- (void)findSetsFromExercise:(NSDictionary *)exercise {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    
    RLMArray *sets = [dataSource allSetsFromExerciseWithId:exercise[@"exerciseId"]];
    
    if (sets == nil) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (SBSet *set in sets) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                                   set.setId,
                                                                   [NSString stringWithFormat:@"%d", set.number],
                                                                   [NSString stringWithFormat:@"%f", set.weight],
                                                                   [NSString stringWithFormat:@"%d", set.repetitions]
                                                                   ]
                                                         forKeys:@[
                                                                   @"setId",
                                                                   @"number",
                                                                   @"weight",
                                                                   @"repetitions"]];
        
        [array addObject:dict];
    }
    
    [self.output foundSets:array];
}

- (void)deleteSet:(NSDictionary *)set fromExercise:(NSDictionary *)exercise atIndex:(int)index {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    [dataSource deleteSetWithId:set[@"setId"] fromExerciseWithId:exercise[@"exerciseId"]];
    
    [self updateStatisticsForWidget];
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

    [self updateStatisticsForWidget];
    [self.output createdSet:dict];
}

- (void)createSetDependingOnLastExerciseWithNumber:(int)number andAddToExercise:(NSDictionary *)exercise withFallbackWeight:(float)weight andFallbackRepetitions:(int)repetitions {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    
    SBSet *lastSet = [dataSource lastSetOfExerciseWithName:exercise[@"name"]];
    
    SBSet *createdSet;
    if (lastSet == nil) {
        createdSet = [dataSource createSetWithNumber:number weight:weight andRepetitions:repetitions];
    } else {
        createdSet = [dataSource createSetWithNumber:number weight:lastSet.weight andRepetitions:lastSet.repetitions];
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
    
    [self updateStatisticsForWidget];
    [self.output createdSet:dict];
}

- (void)updateStatisticsForWidget {
    SBWorkoutDataSource *dataSource = [SBWorkoutDataSource new];
    
    RLMResults *exercises = [dataSource allExerciseSets];
    
    NSMutableArray *response = [NSMutableArray new];
    
    NSMutableArray *result = [NSMutableArray new];
    for (SBExerciseSet *exercise in exercises) {
        if (![result containsObject:exercise.name]) {
            [result addObject:exercise.name];
        }
    }
    
    int count = 0;
    float prevWeight = 0;
    float statisticProgress = 0;
    for (NSString *name in result) {
        RLMResults *exerciseSets = [dataSource allExerciseSetsByName:name];
        
        count = 0;
        prevWeight = 0;
        statisticProgress = 0;
        for (int i = 0; i < [exerciseSets count]; i++) {
            SBExerciseSet *exercise = exerciseSets[i];
            int countOfSets = [exercise.sets count];
            
            for (int j = 0; j < countOfSets; j++) {
                SBSet *set = [exercise.sets objectAtIndex:j];
                
                if (prevWeight != 0) {
                    statisticProgress += (((set.weight / prevWeight) * 100) - 100);
                }
                prevWeight = set.weight;
                count++;
            }
        }
        
        if (count != 0) {
            statisticProgress = statisticProgress / count;
        }
        
        NSDictionary *dict = @{
                               @"name" : name,
                               @"value" : [NSString stringWithFormat:@"%f", statisticProgress]
                               };
        
        [response addObject:dict];
    }
    
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"group.widget.statistics"];
    
    [ud setObject:response forKey:@"statistics"];
    [ud synchronize];
}


@end
