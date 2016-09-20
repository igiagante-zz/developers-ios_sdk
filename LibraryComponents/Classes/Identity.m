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
    
    AccessToken *accessToken = [[AccessToken alloc]init];
    accessToken = accessToken;
    accessToken.accessTokenValue = [loginData valueForKey:ACCESS_TOKEN];
    accessToken.expiresInValue = [loginData valueForKey:EXPIRES_IN];
    
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
    
    AccessToken *accessToken = [[AccessToken alloc]init];
    accessToken = accessToken;
    accessToken.accessTokenValue = [defaults valueForKey:ACCESS_TOKEN];
    accessToken.expiresInValue = [defaults valueForKey:EXPIRES_IN];
    
    identity.accessToken = accessToken;
    
    if([self isTokenExpired: accessToken.expiresInValue]) {
        identity = nil;
    }
    
    return identity;
}

+ (BOOL) isTokenExpired: (NSString *) expiresInValue{
    NSString * expiresIn = expiresInValue;
    if(expiresIn) {
        NSDate *tokenDate = [NSDate dateWithTimeIntervalSinceNow:([expiresIn doubleValue] / 1000)];
        NSDate *now = [NSDate date];
        
        if([self compareDates:tokenDate otherDay:now]){
            return YES;
        }
    }
    return NO;
}

+ (BOOL)compareDates:(NSDate*)date1 otherDay:(NSDate*)date2 {
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day] > [comp2 day] &&
    [comp1 month] > [comp2 month] &&
    [comp1 year]  > [comp2 year];
}

@end
