//
//  SBSetInteractor.h
//  sportblog
//
//  Created by Bullin, Marco on 03.11.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSet.h"
#import "SBExerciseSet.h"

@interface SBSetInteractorOLD : NSObject

- (void)deleteSet:(SBSet *)set fromExerciseSet:(SBExerciseSet *)exercise AtIndex:(int)index;
- (SBSet *)createSetDependingOnSet:(SBSet *)set;
- (SBSet *)createSetWithNumber:(int)number weight:(float)weight andRepetitions:(int)repetitions;
- (void)updateSet:(SBSet *)set withNumber:(int)number;
- (void)updateSet:(SBSet *)set withWeight:(float)weight;
- (void)updateSet:(SBSet *)set withRepetitions:(int)repetitions;
- (SBSet *)lastSetOfExerciseWithName:(NSString *)name;

@end
