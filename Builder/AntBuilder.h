//
//  AntBuilder.h
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface AntBuilder : NSObject

@property (nonatomic, readonly) NSUInteger count;

/**
 @param count Number of Ant framework header/source file pairs to create. A count of 100, for example, will generate Ant000.h and Ant000.m to Ant099.h and Ant099.m.
 */
- (instancetype)initWithCount:(NSUInteger)count;

/**
 Deletes existing files and at projectPath + Ant framework directory and creates ones according to count.

 Also deletes existing test files at projectPath + Ant framework test directory and creates ones according to count.

 Does not add these files to project - that part can be automated, but it's a pain, so I'm leaving it to do by hand.
 */
- (void)createAntWithProjectPath:(NSString *)projectPath;

/**
 For a client with file count count, return which Ant framework index number to use for client index number.

 For example, if client index were 20 out of 1000 and Ant count were 50, we would divide 1000 by 50, leaving 20.
 So for every 20 client files, you'd use 1 Ant file.
 Divide the index by 20, you get 1, because for indexes 0-19, you'd use Ant file 0, and for files 20-39, you'd use Ant file 1.

 Number can be used as part of Ant class names, such as Ant001, or ant method names, such as ant001.
 */
- (NSString *)antNumberForIndex:(NSUInteger)index inCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
