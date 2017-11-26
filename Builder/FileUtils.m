//
//  FileUtils.m
//  Builder
//
//  Created by Andrew Pontious on 11/25/17.
//  Copyright © 2017 Andrew Pontious. All rights reserved.
//

#import "FileUtils.h"

@interface FileUtils ()

@property (nonatomic, readonly) NSString *projectPath;
@property (nonatomic, readonly) NSFileManager *fm;

@end

@implementation FileUtils

- (instancetype)initWithProjectPath:(NSString *)projectPath {
    self = [super init];
    if (self) {
        _projectPath = projectPath;
        _fm = [NSFileManager defaultManager];
    }
    return self;
}

- (void)deleteFileInFolder:(NSString *)folderName withName:(NSString *)fileName {
    NSString *path = [self.projectPath stringByAppendingPathComponent:folderName];
    path = [path stringByAppendingPathComponent:fileName];

    // Don't check error - it might not exist.
    [self.fm removeItemAtPath:path error:nil];
}

- (BOOL)deleteFilesInFolder:(NSString *)folderName withRegex:(NSString *)regexPattern {
    NSError *error;

    NSString *path = [self.projectPath stringByAppendingPathComponent:folderName];

    NSArray<NSString *> *fileNames = [self.fm contentsOfDirectoryAtPath:path error:&error];
    if (!fileNames || error) {
        NSLog(@"Error attempting to get names of files in %@: %@", path, error);
        return NO;
    }

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!regex || error) {
        NSLog(@"Unable to create regex: %@", error);
        return NO;
    }

    for (NSString *fileName in fileNames) {
        NSRange range = [regex rangeOfFirstMatchInString:fileName options:0 range:NSMakeRange(0, fileName.length)];
        if (range.location == 0 && range.length == fileName.length) {
            BOOL removeResult = [self.fm removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:&error];
            if (!removeResult || error) {
                NSLog(@"Error attempting to delete existing file %@: %@", fileName, error);
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)writeFileWithTemplate:(NSString *)template replacingString:(NSString *)targetString withString:(NSString *)replacementString inFolder:(NSString *)folderName withName:(NSString *)fileName {

    NSMutableString *string = template.mutableCopy;

    [string replaceOccurrencesOfString:targetString
                            withString:replacementString
                               options:0
                                 range:NSMakeRange(0, string.length)];

    NSString *path = [self.projectPath stringByAppendingPathComponent:folderName];

    NSError *error;

    BOOL result = [string writeToFile:[path stringByAppendingPathComponent:fileName]
                           atomically:YES
                             encoding:NSUTF8StringEncoding
                                error:&error];
    if (!result || error) {
        NSLog(@"error saving %@", fileName);
        return NO;
    }

    return YES;
}

@end
