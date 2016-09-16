//
//  AccessToken.m
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import "AccessToken.h"

@implementation AccessToken

- (id) initWithAccessToken: (NSString *) token and: (NSString *) expiresIn {
    
    self = [super init];
    
    if(self) {
        _accessTokenValue = token;
        _expiresInValue = expiresIn;
    }
}

@end
