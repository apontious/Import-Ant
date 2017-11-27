//
//  HillBuilder.h
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

@import Foundation;

@class AntBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface HillBuilder : NSObject

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) AntBuilder *antBuilder;

/**
 @param count number of Hill app header/source file pairs to create. A count of 5000, for example, will generate Hill00000.h and Hill00000.m to Hill04999.h and Hill04999.m.
 @param antBuilder AntBuilder used to know which Ant headers to reference.
 */
- (instancetype)initWithCount:(NSUInteger)count antBuilder:(AntBuilder *)antBuilder;

/**
 Deletes existing files and at projectPath + Hill app directory and creates ones according to count.

 Also deletes existing test files at projectPath + Hill app test directory and creates ones according to count.

 Does not add these files to project - that part can be automated, but it's a pain, so I'm leaving it to do by hand.
 */
- (void)createHillWithProjectPath:(NSString *)projectPath;

@end

NS_ASSUME_NONNULL_END
