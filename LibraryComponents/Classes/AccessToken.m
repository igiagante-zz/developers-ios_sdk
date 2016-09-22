//
//  AccessToken.m
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import "AccessToken.h"

@interface AccessToken ()

@property (nonatomic, strong) NSDate * tokenDateExpiration;

@end

@implementation AccessToken

- (instancetype) initWithAccessToken: (NSString *) token andExpiresIn: (NSString *) expiresIn {
    
    self = [super init];
    if(self) {
        _accessTokenValue = token;
        _expiresInValue = expiresIn;
        _tokenDateExpiration = [NSDate dateWithTimeIntervalSinceNow:([expiresIn doubleValue])];
    }
    return self;
}

- (BOOL) isTokenExpired {

    NSDate *now = [NSDate date];
    
    if([now timeIntervalSinceDate:self.tokenDateExpiration] > 0){
        return YES;
    }
    return NO;
}

@end
