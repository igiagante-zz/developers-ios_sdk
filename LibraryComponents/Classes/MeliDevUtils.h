//
//  MeliDevUtils.h
//  Pods
//
//  Created by Ignacio Giagante on 15/9/16.
//
//

#import <Foundation/Foundation.h>

@interface MeliDevUtils : NSObject

+ (BOOL) validateUrl: (NSString *) candidate;
+ (BOOL) isNumeric: (NSString *) candidate;

@end
