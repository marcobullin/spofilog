#import <Foundation/Foundation.h>
#import "SBSetInteractorIO.h"

@interface SBSetInteractor : NSObject <SBSetInteractorInput>

@property (nonatomic, strong) id<SBSetInteractorOutput> output;

@end
