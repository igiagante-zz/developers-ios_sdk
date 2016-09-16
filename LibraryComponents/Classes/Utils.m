//
//  Utils.m
//  Pods
//
//  Created by Ignacio Giagante on 15/9/16.
//
//

#import "Utils.h"

const NSString * REGEX_URL = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
const NSString * REGEX_NUMERIC = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";

@implementation Utils

+ (BOOL) validateUrl: (NSString *) candidate {
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_URL];
    return [urlTest evaluateWithObject:candidate];
}

+ (BOOL) isNumeric: (NSString *) candidate {
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_NUMERIC];
    return [numericTest evaluateWithObject:candidate];
}

@end
