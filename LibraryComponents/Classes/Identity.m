//
//  Identity.m
//  Pods
//
//  Created by Ignacio Giagante on 1/9/16.
//
//

#import "Identity.h"
#import "Meli.h"

const NSString * ACCESS_TOKEN = @"access_token";
const NSString * EXPIRES_IN = @"expires_in";
const NSString * USER_ID = @"user_id";

@implementation Identity

- (NSString *) getAccessTokenValue {
    return _accessToken.accessTokenValue;
}

+ (void) createIdentity:(NSDictionary *) loginData {
    
    Identity * identity = [[Identity alloc]init];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    identity.clientId = [dictionary valueForKey: MELI_APP_ID_KEY];
    identity.userId = [loginData valueForKey:USER_ID];
    
    NSString * accessTokenValue = [loginData valueForKey:ACCESS_TOKEN];
    NSString * expiresInValue = [loginData valueForKey:EXPIRES_IN];
    
    AccessToken *accessToken = [[AccessToken alloc] initWithAccessToken:accessTokenValue andExpiresIn:expiresInValue];
    identity.accessToken = accessToken;
    
    [identity storeIdentity];
}

- (void) storeIdentity {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    
    [defaults setValue:_clientId forKey:CLIENT_ID];
    [defaults setValue:_userId forKey:USER_ID];
    [defaults setValue:_accessToken.accessTokenValue forKey:ACCESS_TOKEN];
    [defaults setValue:_accessToken.expiresInValue forKey:EXPIRES_IN];
    
    NSLog(@"Client Id: %@", _clientId);
    NSLog(@"Access Token: %@", _accessToken.accessTokenValue);
    NSLog(@"Expires In: %@", _accessToken.expiresInValue);
    NSLog(@"%@", @"The identity was saved correctly");
}

+ (Identity *) restoreIdentity {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    NSString *clientId = [dictionary valueForKey: MELI_APP_ID_KEY];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *clientIdSaved = [defaults valueForKey: CLIENT_ID];
    
    // check if the clientId was modified
    if(![clientIdSaved isEqualToString:clientId]) {
        return nil;
    }
    
    Identity * identity = [[Identity alloc]init];
    identity.clientId = clientId;
    
    NSString * accessTokenValue = [defaults valueForKey:ACCESS_TOKEN];
    NSString * expiresInValue = [defaults valueForKey:EXPIRES_IN];
    
    AccessToken *accessToken = [[AccessToken alloc] initWithAccessToken:accessTokenValue andExpiresIn:expiresInValue];
    identity.accessToken = accessToken;
    
    if([accessToken isTokenExpired]) {
        identity = nil;
    }
    
    return identity;
}

@end
