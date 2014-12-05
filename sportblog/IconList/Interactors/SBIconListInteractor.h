#import <Foundation/Foundation.h>
#import "SBIconListInteractorIO.h"

@interface SBIconListInteractor : NSObject <SBIconListInteractorInput>

@property (nonatomic, strong) id<SBIconListInteractorOutput> output;

@end
