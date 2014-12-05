#import <Foundation/Foundation.h>
#import "SBWorkoutListInteractorIO.h"
#import "SBWorkoutDataSource.h"

@interface SBWorkoutListInteractor : NSObject <SBWorkoutListInteractorInput>
@property (nonatomic, strong) id<SBWorkoutListInteractorOutput> output;
@property (nonatomic, strong) SBWorkoutDataSource *datasource;

@end
