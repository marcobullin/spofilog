#import "SBSetPresenter.h"

@implementation SBSetPresenter

- (void)updateSet:(NSDictionary *)set withNumber:(int)number {
    [self.interactor updateSet:set withNumber:number];
}

- (void)updateSet:(NSDictionary *)set withWeight:(float)weight {
    [self.interactor updateSet:set withWeight:weight];
}

- (void)updateSet:(NSDictionary *)set withRepetitions:(int)repetitions {
    [self.interactor updateSet:set withRepetitions:repetitions];
}

- (void)updatedSet:(NSDictionary *)set {
    [self.view displayUpdateSet:set];
}

@end
