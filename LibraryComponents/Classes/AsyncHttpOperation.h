//
//  AsyncHttpOperation.h
//  Pods
//
//  Created by Ignacio Giagante on 21/9/16.
//
//

#import <Foundation/Foundation.h>
#import "Identity.h"

typedef void (^SuccessHandler) (NSURLSessionTask *task, id responseObject);
typedef void (^FailureHandler) (NSURLSessionTask *operation, NSError *error);

@interface AsyncHttpOperation : NSObject

@property (nonatomic) Identity * identity;

+(instancetype) asyncHttpOperation;

- (void) get: (NSString *)path successHandler: successHandler failureHanlder: failureHandler;
- (void) getWithAuth: (NSString *)path successHandler: successHandler failureHanlder: failureHandler;
- (void) post: (NSString *)path withBody:(NSDictionary *)params successHandler: successHandler failureHanlder: failureHandler;

@end
