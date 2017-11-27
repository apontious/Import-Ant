//
//  FileUtils.h
//  Builder
//
//  Created by Andrew Pontious on 11/25/17.
//  Copyright © 2017 Andrew Pontious.
//  Some rights reserved: http://opensource.org/licenses/mit-license.php
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 Helpful utility methods to do just what we need.
 */
@interface FileUtils : NSObject

/**
 Start with project path that will be used as prefix of full path for every subsequent operation of this instance.
 */
- (instancetype)initWithProjectPath:(NSString *)projectPath;

/**
 Does not check for error since file may not exist.
 */
- (void)deleteFileInFolder:(NSString *)folderName withName:(NSString *)fileName;

/**
 Will log an error message and return NO on any problems. Otherwise, will return YES.
 */
- (BOOL)deleteFilesInFolder:(NSString *)folderName withRegex:(NSString *)regexPattern;

/**
 Will log an error message and return NO on any problems. Otherwise, will return YES.
 */
- (BOOL)writeFileWithTemplate:(NSString *)template replacingString:(NSString *)targetString withString:(NSString *)replacementString inFolder:(NSString *)folderName withName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
