#import <Foundation/Foundation.h>
#import "SBExercisesInteractorIO.h"

@interface SBExercisesInteractor : NSObject <SBExercisesInteractorInput>

@property (nonatomic, strong) id<SBExercisesInteractorOutput> output;

@end
