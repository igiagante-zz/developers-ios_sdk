//
//  AccessToken.h
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (copy) NSString * accessTokenValue;
@property (copy) NSString * expiresInValue;

- (id) initWithAccessToken: (NSString *) token and: (NSString *) expiresIn;

@end
