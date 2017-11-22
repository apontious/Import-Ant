//
//  AntBuilder.h
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious. All rights reserved.
//

@import Foundation;

@interface AntBuilder : NSObject

/**
 @param count How many files to generate. A count of 100 will generate Ant000.h and Ant000.m to Ant099.h and Ant099.m.
 */
- (instancetype)initWithCount:(NSUInteger)count;

/**
 Deletes existing files and at projectPath + Ant framework directory and creates ones according to count.

 Also deletes existing test files at projectPath + Ant framework test directory and creates ones according to count.

 Does not add these files to project - that part can be automated, but it's a pain, so I'm leaving it to do by hand.
 */
- (void)createAntWithProjectPath:(NSString *)projectPath;

@end
