//
//  SyncHttpOperation.m
//  Pods
//
//  Created by Ignacio Giagante on 16/9/16.
//
//

#import "SyncHttpOperation.h"

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
        NSLog(@"Error getting %@, HTTP status code %i", [request URL], [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
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
        return nil;
    } else {
        
        NSString * url = [MELI_API_URL stringByAppendingString:path];
        url = [url stringByAppendingString: @"?access_token="];
        url = [url stringByAppendingString: self.identity.accessToken.accessTokenValue];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        
        return [self execute:request error:&error];
    }
}

- (NSString *) post:(NSString *)path withBody:(NSData *)body error: (NSError **) error {
    
    NSString * url = [MELI_API_URL stringByAppendingString:path];
    url = [url stringByAppendingString: @"?access_token="];
    url = [url stringByAppendingString: self.identity.accessToken.accessTokenValue];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:url]];
    
    return [self execute:request error:&error];
}

- (NSString *) put:(NSString *)path withBody:(NSData *)body error: (NSError **) error {
    
    NSString * url = [MELI_API_URL stringByAppendingString:path];
    url = [url stringByAppendingString: @"?access_token="];
    url = [url stringByAppendingString: self.identity.accessToken.accessTokenValue];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:url]];
    
    return [self execute:request error:&error];
}

@end
