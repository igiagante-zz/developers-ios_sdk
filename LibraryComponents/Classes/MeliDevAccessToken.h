//
//  MeliDevAccessToken.h
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import <Foundation/Foundation.h>

@interface MeliDevAccessToken : NSObject

@property (copy) NSString * accessTokenValue;
@property (copy) NSString * expiresInValue;

- (id) initWithMeliDevAccessToken: (NSString *) token andExpiresIn: (NSString *) expiresIn;
- (BOOL) isTokenExpired;

@end
