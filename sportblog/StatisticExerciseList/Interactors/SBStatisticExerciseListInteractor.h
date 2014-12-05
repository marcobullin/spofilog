#import <Foundation/Foundation.h>
#import "SBStatisticExerciseListInteractorIO.h"

@interface SBStatisticExerciseListInteractor : NSObject <SBStatisticExerciseListInteractorInput>

@property (nonatomic, strong) id<SBStatisticExerciseListInteractorOutput> output;

@end
