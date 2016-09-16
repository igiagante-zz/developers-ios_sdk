//
//  Meli.m
//  Pods
//
//  Created by Ignacio Giagante on 6/9/16.
//
//

#import "Meli.h"
#import "Identity.h"
#import "MeliDevLoginViewController.h"
#import "Utils.h"
#import "MeliDevErrors.h"

const NSString * ACCESS_TOKEN = @"access_token";
const NSString * EXPIRES_IN = @"expires_in";
const NSString * USER_ID = @"user_id";

@interface Meli ()

@end

@implementation Meli

static Identity * identity;
static NSString * appId;
static NSString * redirectUrl;
static BOOL isLogged = NO;

+(instancetype) meli
{
    static Meli * meli = nil;
    static dispatch_once_t one = 0;
    dispatch_once(&one, ^{
        meli = [[Meli alloc]init];
    });
    
    identity = [[Identity alloc] init];
    
    return meli;
}

- (void) startSDK: (NSError **) error; {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    
    appId = [dictionary valueForKey:@"MeliAppId"];
    redirectUrl = [dictionary valueForKey:@"MeliRedirectUrl"];
    
    if(appId == nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"App ID is not defined at info.plist"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:AppIdIsNotDefinedError
                                 userInfo:userInfo];
    } else if( [Utils isNumeric: appId] ) {
        NSLog(@"App ID correct %@", appId);
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"App ID is not numeric"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:AppIdNotValidError
                                 userInfo:userInfo];
    }
    
    if(redirectUrl == nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Redirect URL is not defined at info.plist"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:RedirectUrlIsNotDefinedError
                                 userInfo:userInfo];
    } else if( [Utils validateUrl: redirectUrl] ) {
        NSLog(@"Url valid %@", redirectUrl);
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Redirect URL is not valid"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:RedirectUrlNotValidError
                                 userInfo:userInfo];
    }
}

- (void) startLogin: (UIViewController *) clientViewController {
    
    if(!self.loadIdentity) {
        
        MeliDevLoginViewController * loginViewController = [[MeliDevLoginViewController alloc]init];
        loginViewController.redirectUrl = redirectUrl;
        
        loginViewController.onLoginCompleted = ^(NSDictionary *data){
            [self createIdentity:data];
        };
        
        loginViewController.onErrorDetected = ^(NSString *error){
            NSLog(@"%@", error);
        };
        
        [clientViewController.navigationController pushViewController:loginViewController animated:YES];
    } else {
        NSLog(@"User Id: %@", identity.clientId);
        NSLog(@"Access Token: %@", identity.accessToken.accessTokenValue);
        NSLog(@"Expires In: %@", identity.accessToken.expiresInValue);
    }
}

- (BOOL) loadIdentity {
    identity = [self restoreIdentity];
    return identity.clientId != nil;
}

- (void) createIdentity:(NSDictionary *) loginData {

    identity.clientId =[loginData valueForKey:USER_ID];
    
    if(identity) {
        AccessToken *accessToken = [[AccessToken alloc]init];
        accessToken.accessTokenValue = [loginData valueForKey:ACCESS_TOKEN];
        accessToken.expiresInValue = [loginData valueForKey:EXPIRES_IN];
        identity.accessToken = accessToken;
    }
    [self storeIdentity];
}

- (void) storeIdentity {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    
    [defaults setValue:identity.clientId forKey:USER_ID];
    [defaults setValue:identity.accessToken.accessTokenValue forKey:ACCESS_TOKEN];
    [defaults setValue:identity.accessToken.expiresInValue forKey:EXPIRES_IN];
    
    NSLog(@"User Id: %@", identity.clientId);
    NSLog(@"Access Token: %@", identity.accessToken.accessTokenValue);
    NSLog(@"Expires In: %@", identity.accessToken.expiresInValue);
    NSLog(@"%@", @"The identity was saved correctly");
}

- (Identity *) restoreIdentity {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    
    identity.clientId = [defaults valueForKey:USER_ID];
    AccessToken *accessToken = [[AccessToken alloc]init];
    identity.accessToken = accessToken;
    identity.accessToken.accessTokenValue = [defaults valueForKey:ACCESS_TOKEN];
    identity.accessToken.expiresInValue = [defaults valueForKey:EXPIRES_IN];
    
    if(self.isTokenExpired) {
        identity = nil;
    }
    
    return identity;
}

- (BOOL) isTokenExpired {
    NSString * expiresIn = identity.accessToken.expiresInValue;
    if(expiresIn) {
        NSDate *tokenDate = [NSDate dateWithTimeIntervalSinceNow:([expiresIn doubleValue] / 1000)];
        NSDate *now = [NSDate date];
        
        if([self compareDates:tokenDate otherDay:now]){
            return YES;
        }
    }
    return NO;
    
}

- (BOOL)compareDates:(NSDate*)date1 otherDay:(NSDate*)date2 {
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day] > [comp2 day] &&
    [comp1 month] > [comp2 month] &&
    [comp1 year]  > [comp2 year];
}

@end
