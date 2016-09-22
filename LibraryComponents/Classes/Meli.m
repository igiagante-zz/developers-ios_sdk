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

static NSString const * MELI_REDIRECT_URL_KEY = @"MeliRedirectUrl";

static NSString const * APP_ID_NOT_DEFINED_KEY = @"App ID is not defined at info.plist";
static NSString const * REDIRECT_URL_NOT_DEFINED_KEY = @"Redirect URL is not defined at info.plist";
static NSString const * APP_ID_IS_NOT_NUMERIC_KEY = @"App ID is not numeric";
static NSString const * REDIRECT_URL_IS_NOT_VALID_KEY = @"Redirect URL is not valid";

@interface Meli ()

@end

@implementation Meli

static Identity * identity;
static NSString * clientId;
static NSString * redirectUrl;
static NSDictionary *dictionary;
static BOOL isSDKInitialized = NO;

+ (void) initSDK {
    
    NSError *error;
    if(!isSDKInitialized) {
        [self startSDK: &error];
    }
    
    if(error) {
        NSLog(@"Domain: %@", error.domain);
        NSLog(@"Error Code: %ld", error.code);
        NSLog(@"Description: %@", [error localizedDescription]);
    }
}

+ (Identity *) getIdentity {
    
    identity = [Identity restoreIdentity];
    
    if(identity.clientId) {
        return identity;
    } else {
        return nil;
    }
}

+ (void) startSDK: (NSError **) error {
    dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    
    clientId = [dictionary valueForKey: MELI_APP_ID_KEY];
    redirectUrl = [dictionary valueForKey: MELI_REDIRECT_URL_KEY];
    
    [self verifyAppID:clientId error: &error];
    [self verifyRedirectUrl:redirectUrl error: &error];
    
    isSDKInitialized = YES;
}

+ (void) verifyAppID: (NSString *) appId error:(NSError **) error {
    
    if(appId == nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: APP_ID_NOT_DEFINED_KEY};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:AppIdIsNotDefinedError
                                 userInfo:userInfo];
    } else if( [Utils isNumeric: appId] ) {
        NSLog(@"App ID correct %@", appId);
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: APP_ID_IS_NOT_NUMERIC_KEY};

        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:AppIdNotValidError
                                 userInfo:userInfo];
    }
    
}

+ (void) verifyRedirectUrl: (NSString *) redirectUrl error:(NSError **) error {
    
    if(redirectUrl == nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: REDIRECT_URL_NOT_DEFINED_KEY};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:RedirectUrlIsNotDefinedError
                                 userInfo:userInfo];
    } else if( [Utils validateUrl: redirectUrl] ) {
        NSLog(@"Redirect URL is valid %@", redirectUrl);
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: REDIRECT_URL_IS_NOT_VALID_KEY};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:RedirectUrlNotValidError
                                 userInfo:userInfo];
    }
}

+ (void) startLogin: (UIViewController *) clientViewController {
    
        MeliDevLoginViewController * loginViewController = [[MeliDevLoginViewController alloc]init];
        loginViewController.redirectUrl = redirectUrl;
        loginViewController.appId = clientId;
        
        loginViewController.onLoginCompleted = ^(NSDictionary *data){
            [Identity createIdentity:data];
        };
        
        loginViewController.onErrorDetected = ^(NSString *error){
            NSLog(@"%@", error);
        };
        
        [clientViewController.navigationController pushViewController:loginViewController animated:YES];
}

@end
