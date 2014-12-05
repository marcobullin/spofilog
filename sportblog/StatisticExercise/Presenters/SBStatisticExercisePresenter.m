#import "SBStatisticExercisePresenter.h"

@implementation SBStatisticExercisePresenter

- (void)findStatisticsForExerciseSetsWithName:(NSString *)name {
    [self.interactor findExerciseSetsByName:name];
}

- (void)foundExerciseSets:(NSArray *)exercises {
    NSMutableArray *reps    = [[NSMutableArray alloc] init];
    NSMutableArray *weights = [[NSMutableArray alloc] init];
    NSMutableArray *labels  = [[NSMutableArray alloc] init];
    
    int count = 0;
    int statisticCountOfSets = 0;
    float statisticMinWeight = 0;
    float statisticMaxWeight = 0;
    int statisticRepetitions = 0;
    float statisticProgress = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    float averageRepetitions = 0;
    int exerciseCount = 0;
    int minRepetitions = 0;
    int maxRepetitions = 0;
    float firstWeight = 0;
    float lastWeight = 0;
    float prevWeight = 0;
    
    for (int i = 0; i < [exercises count]; i++) {
        NSDictionary *exercise = [exercises objectAtIndex:i];
        
        int countOfSets = [exercise[@"sets"] count];
        statisticCountOfSets += countOfSets;
        
        for (int j = 0; j < countOfSets; j++) {
            NSDictionary *set = [exercise[@"sets"] objectAtIndex:j];
            
            NSDate *date = exercise[@"date"];
            if (firstDate == nil || [date compare:firstDate] == NSOrderedAscending) {
                firstDate = exercise[@"date"];
            }
            
            if (lastDate == nil || [date compare:lastDate] == NSOrderedDescending) {
                lastDate = exercise[@"date"];
            }
            
            if (statisticMinWeight == 0 || [set[@"weight"] floatValue] < statisticMinWeight) {
                statisticMinWeight = [set[@"weight"] floatValue];
            }
            
            if ([set[@"weight"] floatValue] > statisticMaxWeight) {
                statisticMaxWeight = [set[@"weight"] floatValue];
            }
            
            if (minRepetitions == 0 || [set[@"repetitions"] intValue] < minRepetitions) {
                minRepetitions = [set[@"repetitions"] intValue];
            }
            
            if ([set[@"repetitions"] intValue] > maxRepetitions) {
                maxRepetitions = [set[@"repetitions"] intValue];
            }
            
            if (prevWeight != 0) {
                statisticProgress += ((([set[@"weight"] floatValue] / prevWeight) * 100) - 100);
            }
            prevWeight = [set[@"weight"] floatValue];
            
            if (firstWeight == 0) {
                firstWeight = [set[@"weight"] floatValue];
            }
            
            lastWeight = [set[@"weight"] floatValue];
            
            statisticRepetitions += [set[@"repetitions"] intValue];
            
            [reps addObject:[NSNumber numberWithInt:[set[@"repetitions"] intValue]]];
            [weights addObject:[NSNumber numberWithFloat:[set[@"weight"] floatValue]]];
            [labels addObject:@""];//[self.dateFormatter stringFromDate:exercise.date]];
            count++;
        }
        
        exerciseCount++;
    }
    
    if (count != 0) {
        statisticProgress = statisticProgress / count;
        averageRepetitions = statisticRepetitions / count;
    }
    
    float max = (statisticMaxWeight > maxRepetitions) ? statisticMaxWeight : maxRepetitions;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *firstDateText;
    if (firstDate == nil) {
        firstDateText = @"";
    } else {
        firstDateText = [NSString stringWithFormat:NSLocalizedString(@"from %@", nil), [dateFormatter stringFromDate:firstDate]];
    }
    
    NSString *lastDateText;
    if (lastDate == nil) {
        lastDateText = @"";
    } else {
        lastDateText = [NSString stringWithFormat:NSLocalizedString(@"to %@", nil), [dateFormatter stringFromDate:lastDate]];
    }
    
    if ([weights count] == 1) {
        [weights insertObject:[NSNumber numberWithFloat:0] atIndex:0];
        [labels insertObject:@"" atIndex:0];
    }
    
    if ([reps count] == 1) {
        [reps insertObject:[NSNumber numberWithInt:0] atIndex:0];
    }
    
    NSString *text;
    if (firstWeight == 0) {
        text = @"0";
    } else {
        text = [NSString stringWithFormat:@"%.01f%%", ((lastWeight / firstWeight) * 100) - 100];
    }
    
    NSDictionary *data = @{
       @"max" : [NSString stringWithFormat:@"%f", max],
       @"firstDateText" : firstDateText,
       @"lastDateText" :lastDateText,
       @"weights" : weights,
       @"labels" : labels,
       @"reps" : reps,
       @"exerciseCount" : [NSString stringWithFormat:@"%d", exerciseCount],
       @"statisticCountOfSets" : [NSString stringWithFormat:@"%d", statisticCountOfSets],
       @"statisticMinWeight" : [NSString stringWithFormat:@"%.01f kg", statisticMinWeight],
       @"statisticMaxWeight" : [NSString stringWithFormat:@"%.01f kg", statisticMaxWeight],
       @"firstWeight" : text,
       @"statisticProgress" : [NSString stringWithFormat:@"%.01f%%", statisticProgress],
       @"minRepetitions" : [NSString stringWithFormat:@"%d", minRepetitions],
       @"maxRepetitions" : [NSString stringWithFormat:@"%d", maxRepetitions],
       @"averageRepetitions" : [NSString stringWithFormat:@"%.01f", averageRepetitions],
       @"statisticRepetitions" : [NSString stringWithFormat:@"%d", statisticRepetitions]
    };
    
    [self.view displayStatisticsForExercises:data];
}

@end
