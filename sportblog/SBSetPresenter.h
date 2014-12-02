#import <Foundation/Foundation.h>
#import "SBSetInteractorIO.h"
#import "SBSetView.h"

@interface SBSetPresenter : NSObject <SBSetInteractorOutput>

@property (nonatomic, strong) id<SBSetInteractorInput> interactor;
@property (nonatomic, strong) id<SBSetView> view;

- (void)updateSet:(NSDictionary *)set withNumber:(int)number;
- (void)updateSet:(NSDictionary *)set withWeight:(float)weight;
- (void)updateSet:(NSDictionary *)set withRepetitions:(int)repetitions;

@end
