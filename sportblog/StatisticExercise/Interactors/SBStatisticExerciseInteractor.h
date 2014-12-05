#import <Foundation/Foundation.h>
#import "SBStatisticExerciseInteractorIO.h"

@interface SBStatisticExerciseInteractor : NSObject <SBStatisticExerciseInteractorInput>

@property (nonatomic, strong) id<SBStatisticExerciseInteractorOutput> output;

@end
