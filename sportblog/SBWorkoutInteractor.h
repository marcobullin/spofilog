#import <Foundation/Foundation.h>
#import "SBWorkoutInteractorIO.h"

@interface SBWorkoutInteractor : NSObject <SBWorkoutInteractorInput>

@property(nonatomic, weak) id<SBWorkoutInteractorOutput> output;

@end
