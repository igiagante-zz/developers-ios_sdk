//
//  SyncHttpOperation.m
//  Pods
//
//  Created by Ignacio Giagante on 16/9/16.
//
//

#import "SyncHttpOperation.h"
#import "MeliDevErrors.h"

static NSString const * MELI_IDENTITY_NIL_MESSAGE = @"Meli Identity is nil";

@implementation SyncHttpOperation

+(instancetype) syncHttpOperation
{
    static SyncHttpOperation * syncHttpOperation = nil;
    static dispatch_once_t one = 0;
    dispatch_once(&one, ^{
        syncHttpOperation = [[SyncHttpOperation alloc]init];
    });

    return syncHttpOperation;
}

- (NSString *) execute: (NSMutableURLRequest *)request error: (NSError **) error {
    
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if(!([responseCode statusCode] == 200 || [responseCode statusCode] == 201)){
        
        NSString * requestError = [NSString stringWithFormat:HTTP_REQUEST_ERROR_MESSAGE, [request URL], [responseCode statusCode] ];
        
        NSLog(HTTP_REQUEST_ERROR_MESSAGE, [request URL], [responseCode statusCode]);
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: requestError};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:HttpRequestError
                                 userInfo:userInfo];
        
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

/**
 * If the identity was not created, the reference to the error will be modified.
 **/
- (void) processError: (NSError **) error {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: MELI_IDENTITY_NIL_MESSAGE};
    
    *error = [NSError errorWithDomain:MeliDevErrorDomain
                                         code:MeliIdentityIsNil
                                     userInfo:userInfo];
}

- (NSString *) get: (NSString *)path error: (NSError **) error {
    
    NSString * url = [MELI_API_URL stringByAppendingString:path];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    return [self execute:request error:&error];
}

- (NSString *) getWithAuth: (NSString *)path error: (NSError **) error {
    
    if(!self.identity) {
        [self processError:&error];
        return nil;
    } else {
        
        NSString * url = [MELI_API_URL stringByAppendingString:path];
        url = [url stringByAppendingString: @"?access_token="];
        url = [url stringByAppendingString: self.identity.getAccessTokenValue];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        
        return [self execute:request error:&error];
    }
}

- (NSString *) delete: (NSString *)path error: (NSError **) error {
    
    if(!self.identity) {
        [self processError:&error];
        return nil;
    } else {
        
        NSString * url = [MELI_API_URL stringByAppendingString:path];
        url = [url stringByAppendingString: @"?access_token="];
        url = [url stringByAppendingString: self.identity.getAccessTokenValue];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"DELETE"];
        [request setURL:[NSURL URLWithString:url]];
        
        return [self execute:request error:&error];
    }
}

- (NSString *) post:(NSString *)path withBody:(NSData *)body error: (NSError **) error {
    
    if(!self.identity) {
        [self processError:&error];
        return nil;
    } else {
    
        NSString * url = [MELI_API_URL stringByAppendingString:path];
        url = [url stringByAppendingString: @"?access_token="];
        url = [url stringByAppendingString: self.identity.getAccessTokenValue];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:body];
        [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
        [request setURL:[NSURL URLWithString:url]];
    
        return [self execute:request error:&error];
    }
}

- (NSString *) put:(NSString *)path withBody:(NSData *)body error: (NSError **) error {
    
    if(!self.identity) {
        [self processError:&error];
        return nil;
    } else {
    
        NSString * url = [MELI_API_URL stringByAppendingString:path];
        url = [url stringByAppendingString: @"?access_token="];
        url = [url stringByAppendingString: self.identity.getAccessTokenValue];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:body];
        [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
        [request setURL:[NSURL URLWithString:url]];
    
        return [self execute:request error:&error];
    }
}

@end
