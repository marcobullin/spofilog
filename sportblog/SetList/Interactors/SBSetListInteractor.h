#import <Foundation/Foundation.h>
#import "SBSetListInteractorIO.h"

@interface SBSetListInteractor : NSObject <SBSetListInteractorInput>
@property(nonatomic, weak) id<SBSetListInteractorOutput> output;
@end
