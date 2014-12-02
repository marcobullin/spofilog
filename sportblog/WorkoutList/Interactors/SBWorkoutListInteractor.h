#import <Foundation/Foundation.h>
#import "SBWorkoutListInteractorIO.h"

@interface SBWorkoutListInteractor : NSObject <SBWorkoutListInteractorInput>
@property(nonatomic, weak) id<SBWorkoutListInteractorOutput> output;
@end
