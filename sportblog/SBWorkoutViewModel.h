#import <Foundation/Foundation.h>
#import "SBWorkout.h"

@interface SBWorkoutViewModel : NSObject

- (instancetype)initWithWorkout:(SBWorkout *)workout;

@property (nonatomic, readonly) NSString *nameText;
@property (nonatomic, readonly) NSString *dateText;

@end