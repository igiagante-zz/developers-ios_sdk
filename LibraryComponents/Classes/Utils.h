//
//  Utils.h
//  Pods
//
//  Created by Ignacio Giagante on 15/9/16.
//
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL) validateUrl: (NSString *) candidate;
+ (BOOL) isNumeric: (NSString *) candidate;

@end
