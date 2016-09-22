//
//  MeliDevAsyncHttpOperation.h
//  Pods
//
//  Created by Ignacio Giagante on 21/9/16.
//
//

#import <Foundation/Foundation.h>
#import "MeliDevIdentity.h"

typedef void (^SuccessHandler) (NSURLSessionTask *task, id responseObject);
typedef void (^FailureHandler) (NSURLSessionTask *operation, NSError *error);

@interface MeliDevAsyncHttpOperation : NSObject

@property (nonatomic) MeliDevIdentity * identity;

- (void) get: (NSString *)path successHandler: successHandler failureHanlder: failureHandler;
- (void) getWithAuth: (NSString *)path successHandler: successHandler failureHanlder: failureHandler;
- (void) post: (NSString *)path withBody:(NSDictionary *)params successHandler: successHandler failureHanlder: failureHandler;
- (void) delete: (NSString *)path successHandler: successHandler failureHanlder: failureHandler;

@end
