//
//  MeliDevIdentityTests.m
//  MeliDevSDK
//
//  Created by Ignacio Giagante on 22/9/16.
//  Copyright © 2016 Mercado Libre. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MeliDevIdentity.h"

static NSString * MELI_APP_ID = @"MeliAppId";
static NSString * USER_ID = @"user_id";
static NSString * ACCESS_TOKEN = @"access_token";
static NSString * EXPIRES_IN = @"expires_in";

static NSString * MELI_APP_ID_VALUE = @"7230677288562808";
static NSString * USER_ID_VALUE = @"2277711";
static NSString * ACCESS_TOKEN_VALUE = @"token";
static NSString * EXPIRES_IN_VALUE = @"21600";

@interface MeliDevIdentityTests : XCTestCase

@end

@implementation MeliDevIdentityTests

- (void)setUp {
    
    [super setUp];
    
    NSMutableDictionary *loginData = [[NSMutableDictionary alloc] init];
    [loginData setValue: MELI_APP_ID_VALUE forKey: MELI_APP_ID];
    [loginData setValue: USER_ID_VALUE forKey: USER_ID];
    [loginData setValue: ACCESS_TOKEN_VALUE forKey: ACCESS_TOKEN];
    [loginData setValue: EXPIRES_IN_VALUE forKey: EXPIRES_IN];
    
    [MeliDevIdentity createMeliDevIdentity:loginData];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testRestoreMeliDevIdentity_withLoginData_shouldReturnMeliDevIdentity {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    NSString * clientId = [dictionary valueForKey: @"MeliAppId"];
    
    MeliDevIdentity * identity = [MeliDevIdentity restoreMeliDevIdentity];
    
    XCTAssertNotNil(identity, @"The identity should not be nil");
    XCTAssertTrue([identity.clientId isEqualToString:clientId]);
    XCTAssertTrue([identity.getMeliDevAccessTokenValue isEqualToString:ACCESS_TOKEN_VALUE]);
    XCTAssertTrue([identity.accessToken.expiresInValue isEqualToString:EXPIRES_IN_VALUE]);
}

- (void) testRestoreMeliDevIdentity_withClientIdChanged_shouldReturnNil {
    
}

@end