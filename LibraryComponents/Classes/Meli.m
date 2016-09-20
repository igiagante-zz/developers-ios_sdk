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

@interface Meli ()

@end

@implementation Meli

static Identity * identity;
static NSString * clientId;
static NSString * redirectUrl;
static NSDictionary *dictionary;
static BOOL isSDKInitialized = NO;

+(instancetype) meli
{
    static Meli * meli = nil;
    static dispatch_once_t one = 0;
    dispatch_once(&one, ^{
        meli = [[Meli alloc]init];
    });
    
    NSError *error;
    if(!isSDKInitialized) {
        [self startSDK: &error];
    }
    
    if(error) {
        NSLog(@"Domain: %@", error.domain);
        NSLog(@"Error Code: %ld", error.code);
        NSLog(@"Description: %@", [error localizedDescription]);
    }
    
    return meli;
}

- (Identity *) getIdentity {
    
    identity = [Identity restoreIdentity];
    
    if(identity.clientId) {
        return identity;
    } else {
        return nil;
    }
}

+ (void) startSDK: (NSError **) error {
    dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    
    clientId = [dictionary valueForKey:@"MeliAppId"];
    redirectUrl = [dictionary valueForKey:@"MeliRedirectUrl"];
    
    [self verifyAppID:clientId error: &error];
    [self verifyRedirectUrl:redirectUrl error: &error];
    
    isSDKInitialized = YES;
}

+ (void) verifyAppID: (NSString *) appId error:(NSError **) error {
    
    if(appId == nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"App ID is not defined at info.plist"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:AppIdIsNotDefinedError
                                 userInfo:userInfo];
    } else if( [Utils isNumeric: appId] ) {
        NSLog(@"App ID correct %@", appId);
    }
    
}

+ (void) verifyRedirectUrl: (NSString *) redirectUrl error:(NSError **) error {
    
    if(redirectUrl == nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Redirect URL is not defined at info.plist"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:RedirectUrlIsNotDefinedError
                                 userInfo:userInfo];
    } else if( [Utils validateUrl: redirectUrl] ) {
        NSLog(@"Redirect URL is valid %@", redirectUrl);
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Redirect URL is not valid"};
        
        *error = [NSError errorWithDomain:MeliDevErrorDomain
                                     code:RedirectUrlNotValidError
                                 userInfo:userInfo];
    }
}

- (void) startLogin: (UIViewController *) clientViewController {
    
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
