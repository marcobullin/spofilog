#import <Foundation/Foundation.h>
#import "SBWorkoutInteractorIO.h"

@interface SBWorkoutInteractor : NSObject <SBWorkoutInteractorInput>

@property(nonatomic, strong) id<SBWorkoutInteractorOutput> output;

@end
