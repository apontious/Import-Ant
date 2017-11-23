//
//  AntBuilder.m
//  Builder
//
//  Created by Andrew Pontious on 11/21/17.
//  Copyright © 2017 Andrew Pontious. All rights reserved.
//

#import "AntBuilder.h"

static NSString *const kAntFrameworkFolderName = @"Ant";
static NSString *const kAntFrameworkHeaderName = @"Ant.h";

static NSString *const kAntFrameworkHeaderTemplate;
static NSString *const kAntFrameworkHeaderReplacementsString = @"FRAMEWORK_IMPORT_REPLACEMENTS";

static NSString *const kAntHeaderTemplate;
static NSString *const kAntSourceTemplate;
static NSString *const kAntBaseNumberReplacementString = @"BASE_NUMBER";

static NSString *const kAntTestsFolderName = @"AntTests";
static NSString *const kAntTestFileName = @"AntTests.m";

static NSString *const kAntTestFileTemplate;
static NSString *const kAntTestTemplate;
static NSString *const kAntTestFileTestsReplacementString = @"TEST_REPLACEMENTS";

@implementation AntBuilder

- (instancetype)initWithCount:(NSUInteger)count {
    self = [super init];
    if (self) {
        _count = count;

        if (count < 1) {
            assert("Not expecting count to be zero");
        }
    }
    return self;
}

- (void)createAntWithProjectPath:(NSString *)projectPath {
    [self _ant_deleteExistingFilesWithProjectPath:projectPath];

    [self _ant_createFrameworkHeaderWithProjectPath:projectPath];
    [self _ant_createHeadersAndSourceWithProjectPath:projectPath];
    [self _ant_createTestFileWithProjectPath:projectPath];
}

#pragma mark - Private Methods

- (void)_ant_deleteExistingFilesWithProjectPath:(NSString *)projectPath {

    NSError *error;

    // Ant
    //    Ant.h

    NSFileManager *fm = [NSFileManager defaultManager];

    NSString *antFrameworkPath = [projectPath stringByAppendingPathComponent:kAntFrameworkFolderName];

    NSString *antFrameworkHeaderPath = [antFrameworkPath stringByAppendingPathComponent:kAntFrameworkHeaderName];

    // Don't check error - it might not exist.
    [fm removeItemAtPath:antFrameworkHeaderPath error:nil];

    //    Ant0001.h

    NSArray<NSString *> *antFrameworkFileNames = [fm contentsOfDirectoryAtPath:antFrameworkPath error:&error];
    if (!antFrameworkFileNames || error) {
        NSLog(@"Error attempting to get names of files in %@: %@", antFrameworkPath, error);
        return;
    }

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"Ant[0123456789]+\\.[hm]" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!regex || error) {
        NSLog(@"Unable to create regex: %@", error);
        return;
    }

    for (NSString *fileName in antFrameworkFileNames) {
        NSRange range = [regex rangeOfFirstMatchInString:fileName options:0 range:NSMakeRange(0, fileName.length)];
        if (range.location == 0 && range.length == fileName.length) {
            BOOL removeResult = [fm removeItemAtPath:[antFrameworkPath stringByAppendingPathComponent:fileName] error:&error];
            if (!removeResult || error) {
                NSLog(@"Error attempting to delete existing file %@: %@", fileName, error);
                return;
            }
        }
    }

    // AntTests
    //    AntTests.m

    NSString *antTestsPath = [projectPath stringByAppendingPathComponent:kAntTestsFolderName];

    NSString *antTestFilePath = [antTestsPath stringByAppendingPathComponent:kAntTestFileName];

    // Don't check error - it might not exist.
    [fm removeItemAtPath:antTestFilePath error:nil];
}

/**
 001 to 099, for example, or 01 to 09, or 0001 to 0999.

 Can be easily combined with prefixes and suffixes for header or source file names or method names or string results.
 */
- (NSMutableArray<NSString *> *)_ant_antBaseNumberStrings {
    NSString *temp = [NSString stringWithFormat:@"%lu", (unsigned long)(self.count - 1)];
    const NSUInteger maxDigits = temp.length;

    if (maxDigits > 6) {
        assert("Not expecting count to be > 999999");
    }

    NSMutableArray<NSString *> *result = [NSMutableArray new];

    for (NSUInteger i = 0; i < self.count; i++) {
        NSString *numberString = [NSString stringWithFormat:@"%lu", (unsigned long)i];

        [result addObject:[NSString stringWithFormat:@"%@%@",
                           [@"0000000" substringToIndex:maxDigits + 1 - numberString.length],
                           numberString]];
    }

    return result;
}

- (NSString *)_ant_replaceFrameworkHeaderImportsInTemplate:(NSString *)template {
    NSArray<NSString *> *baseNumberStrings = [self _ant_antBaseNumberStrings];

    NSMutableString *headerFileNamesString = [NSMutableString new];

    for (NSString *baseNumberString in baseNumberStrings) {
        [headerFileNamesString appendFormat:@"#import <Ant/Ant%@.h>\n", baseNumberString];
    }

    NSMutableString *result = template.mutableCopy;

    [result replaceOccurrencesOfString:kAntFrameworkHeaderReplacementsString
                            withString:headerFileNamesString
                               options:0
                                 range:NSMakeRange(0, result.length)];

    return result;
}

- (void)_ant_createFrameworkHeaderWithProjectPath:(NSString *)projectPath {

    NSString *frameworkHeaderString = [self _ant_replaceFrameworkHeaderImportsInTemplate:kAntFrameworkHeaderTemplate];

    NSError *error;

    BOOL result = [frameworkHeaderString writeToFile:[[projectPath stringByAppendingPathComponent:kAntFrameworkFolderName] stringByAppendingPathComponent:kAntFrameworkHeaderName]
                                          atomically:YES
                                            encoding:NSUTF8StringEncoding
                                               error:&error];
    if (!result || error) {
        assert("error saving Ant.h");
    }
}

- (void)_ant_createHeadersAndSourceWithProjectPath:(NSString *)projectPath {
    NSArray<NSString *> *baseNumberStrings = [self _ant_antBaseNumberStrings];

    for (NSString *baseNumberString in baseNumberStrings) {
        // Header
        NSMutableString *antHeaderString = kAntHeaderTemplate.mutableCopy;

        [antHeaderString replaceOccurrencesOfString:kAntBaseNumberReplacementString
                                         withString:baseNumberString
                                            options:0
                                              range:NSMakeRange(0, antHeaderString.length)];

        NSError *error;

        BOOL headerResult = [antHeaderString writeToFile:[[projectPath stringByAppendingPathComponent:kAntFrameworkFolderName] stringByAppendingPathComponent:[NSString stringWithFormat:@"Ant%@.h", baseNumberString]]
                                              atomically:YES
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
        if (!headerResult || error) {
            assert("error saving Ant header");
        }

        // Source
        NSMutableString *antSourceString = kAntSourceTemplate.mutableCopy;

        [antSourceString replaceOccurrencesOfString:kAntBaseNumberReplacementString
                                         withString:baseNumberString
                                            options:0
                                              range:NSMakeRange(0, antSourceString.length)];

        BOOL sourceResult = [antSourceString writeToFile:[[projectPath stringByAppendingPathComponent:kAntFrameworkFolderName] stringByAppendingPathComponent:[NSString stringWithFormat:@"Ant%@.m", baseNumberString]]
                                              atomically:YES
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
        if (!sourceResult || error) {
            assert("error saving Ant source");
        }
    }
}

- (void)_ant_createTestFileWithProjectPath:(NSString *)projectPath {
    NSArray<NSString *> *baseNumberStrings = [self _ant_antBaseNumberStrings];

    NSMutableString *testsString = [NSMutableString new];

    for (NSString *baseNumberString in baseNumberStrings) {
        NSMutableString *testString = kAntTestTemplate.mutableCopy;

        [testString replaceOccurrencesOfString:kAntBaseNumberReplacementString
                                    withString:baseNumberString
                                       options:0
                                         range:NSMakeRange(0, testString.length)];

        [testsString appendString:testString];
    }

    NSString *testFileString = [kAntTestFileTemplate stringByReplacingOccurrencesOfString:kAntTestFileTestsReplacementString withString:testsString];

    NSError *error;

    BOOL result = [testFileString writeToFile:[[projectPath stringByAppendingPathComponent:kAntTestsFolderName] stringByAppendingPathComponent:kAntTestFileName]
                                          atomically:YES
                                            encoding:NSUTF8StringEncoding
                                               error:&error];
    if (!result || error) {
        assert("error saving AntTests.m");
    }
}

@end

static NSString *const kAntFrameworkHeaderTemplate =
@"//\n\
//  Ant.h\n\
//  Ant\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious. All rights reserved.\n\
//\n\
\n\
@import Foundation;\n\
\n\
FRAMEWORK_IMPORT_REPLACEMENTS";

static NSString *const kAntHeaderTemplate =
@"//\n\
//  AntBASE_NUMBER.h\n\
//  Ant\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious. All rights reserved.\n\
//\n\
\n\
@import Foundation;\n\
\n\
@interface AntBASE_NUMBER : NSObject\n\
\n\
- (NSString *)antBASE_NUMBER;\n\
\n\
@end\n\
";

static NSString *const kAntSourceTemplate =
@"//\n\
//  AntBASE_NUMBER.m\n\
//  Ant\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious. All rights reserved.\n\
//\n\
\n\
#import \"AntBASE_NUMBER.h\"\n\
\n\
@implementation AntBASE_NUMBER\n\
\n\
- (NSString *)antBASE_NUMBER {\n\
    return @\"antBASE_NUMBER\";\n\
}\n\
\n\
@end\n\
";

static NSString *const kAntTestFileTemplate =
@"//\n\
//  AntTests.m\n\
//  AntTests\n\
//\n\
//  Created by Andrew Pontious on 11/21/17.\n\
//  Copyright © 2017 Andrew Pontious. All rights reserved.\n\
//\n\
\n\
@import XCTest;\n\
\n\
@import Ant;\n\
\n\
@interface AntTests : XCTestCase\n\
\n\
@end\n\
\n\
@implementation AntTests\n\
TEST_REPLACEMENTS\n\
@end\n\
";

static NSString *const kAntTestTemplate =
@"\n\
- (void)testAntBASE_NUMBER {\n\
    AntBASE_NUMBER *ant = [[AntBASE_NUMBER alloc] init];\n\
    XCTAssertEqualObjects(ant.antBASE_NUMBER, @\"antBASE_NUMBER\", @\"Method should produce given string\");\n\
}\n\
";
