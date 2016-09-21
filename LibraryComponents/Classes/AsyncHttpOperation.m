//
//  AsyncHttpOperation.m
//  Pods
//
//  Created by Ignacio Giagante on 21/9/16.
//
//

#import "AsyncHttpOperation.h"
#import "MeliDevErrors.h"
#import <AFNetworking.h>

NSString * const MELI_API_URL = @"https://api.mercadolibre.com";

@implementation AsyncHttpOperation

+(instancetype) asyncHttpOperation
{
    static AsyncHttpOperation * asyncHttpOperation = nil;
    static dispatch_once_t one = 0;
    dispatch_once(&one, ^{
        asyncHttpOperation = [[AsyncHttpOperation alloc]init];
    });
    
    return asyncHttpOperation;
}

- (void) get: (NSString *)path successHandler: successHandler failureHanlder: failureHandler {
    
    NSString * url = [MELI_API_URL stringByAppendingString:path];
    NSURL *URL = [NSURL URLWithString: url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success: successHandler failure: failureHandler];
}

- (void) getWithAuth: (NSString *)path successHandler: successHandler failureHanlder: failureHandler {
    
    NSString * url = [MELI_API_URL stringByAppendingString:path];
    url = [url stringByAppendingString: @"?access_token="];
    url = [url stringByAppendingString: self.identity.getAccessTokenValue];
    
    NSURL *URL = [NSURL URLWithString: url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil progress:nil success: successHandler failure: failureHandler];
}

- (void) post: (NSString *)path withBody:(NSDictionary *)params successHandler: successHandler failureHanlder: failureHandler {
    
    NSString * url = [MELI_API_URL stringByAppendingString:path];
    url = [url stringByAppendingString: @"?access_token="];
    url = [url stringByAppendingString: self.identity.getAccessTokenValue];
    
    NSURL *URL = [NSURL URLWithString: url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:URL.absoluteString parameters:params progress:nil success: successHandler failure: failureHandler];
}

@end