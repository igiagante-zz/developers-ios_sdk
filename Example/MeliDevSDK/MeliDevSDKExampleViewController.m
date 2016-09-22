//
//  MeliDevSDKExampleViewController.m
//  MeliDevSDK
//
//  Created by Ignacio Giagante on 26/8/16.
//  Copyright © 2016 Mercado Libre. All rights reserved.
//

#import "MeliDevSDKExampleViewController.h"
#import "MeliDevLoginViewController.h"
#import "Meli.h"
#import "MeliDevIdentity.h"
#import "MeliDevASyncHttpOperation.h"
#import "MeliDevSyncHttpOperation.h"
#import "MeliDevErrors.h"

static NSString * CLIENT_ID_VALUE = @"5197208004815569";
static NSString * REDIRECT_URL_VALUE = @"https://www.example.com";

@interface MeliDevSDKExampleViewController ()

@property MeliDevIdentity *identity;

@property (copy) NSString * result;
@property (nonatomic) NSError * error;

- (IBAction)go:(id)sender;

@end

@implementation MeliDevSDKExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSError *error;
    [Meli startSDK: CLIENT_ID_VALUE withRedirectUrl: REDIRECT_URL_VALUE error:&error];
    
    if(error) {
        NSLog(@"Domain: %@", error.domain);
        NSLog(@"Error Code: %ld", error.code);
        NSLog(@"Description: %@", [error localizedDescription]);
    }

    self.identity = [Meli getMeliDevIdentity];
    
    if(self.identity) {
        [self getUsersItemsAsync];
    } else {
        [Meli startLogin:self];
    }
}

- (void) processError: (NSURLSessionTask *) operation error:(NSError *)error {
    
    NSURLRequest * request = operation.currentRequest;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
    
    if(!([httpResponse statusCode] == 200 || [httpResponse statusCode] == 201)){
        
        NSString * requestError = [NSString stringWithFormat: HTTP_REQUEST_ERROR_MESSAGE, [request URL],
                                   (long)[httpResponse statusCode] ];
        NSLog(@"Http request error %@", requestError);
    }
}

- (void) parseData: (id) responseObject {
    
    NSArray *jsonArray = (NSArray *) responseObject;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Result %@", result);
}

- (void) getUsersItemsAsync {
    
    MeliDevAsyncHttpOperation *httpClient = [[MeliDevAsyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/users/221910727/items/search";
    
    SuccessHandler successHandler = ^(NSURLSessionTask *task, id responseObject) {
        [self parseData:responseObject];
    };
    
    FailureHandler failureHandler = ^(NSURLSessionTask *operation, NSError *error) {
        if(error) {
            [self processError:operation error:error];
        }
    };
    
    [httpClient getWithAuth:path successHandler:successHandler failureHanlder:failureHandler];
}

- (void) testDeleteAsync {
    
    MeliDevAsyncHttpOperation *httpClient = [[MeliDevAsyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/items/MLA635779960/pictures/939505-MLA25061434619_092016";
    
    SuccessHandler successHandler = ^(NSURLSessionTask *task, id responseObject) {
        [self parseData:responseObject];
    };
    
    FailureHandler failureHandler = ^(NSURLSessionTask *operation, NSError *error) {
        if(error) {
            [self processError:operation error:error];
        }
    };
    
    [httpClient delete:path successHandler:successHandler failureHanlder:failureHandler];
}

- (void) testPostAsync {
    
    MeliDevAsyncHttpOperation *httpClient = [[MeliDevAsyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/items";
    
    NSError *error;
    NSDictionary * params = [NSJSONSerialization JSONObjectWithData:[self createJsonDataForPost] options:kNilOptions error:&error];
    
    SuccessHandler successHandler = ^(NSURLSessionTask *task, id responseObject) {
        [self parseData:responseObject];
    };
    
    FailureHandler failureHandler = ^(NSURLSessionTask *operation, NSError *error) {
        if(error) {
            [self processError:operation error:error];
        }
    };
    
    [httpClient post:path withBody:params successHandler:successHandler failureHanlder:failureHandler];
}

- (void) testPutAsync {
    
    MeliDevAsyncHttpOperation *httpClient = [[MeliDevAsyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/items/MLA635779960";
    
    NSError *error;
    NSDictionary * params = [NSJSONSerialization JSONObjectWithData:[self createJsonDataForPut] options:kNilOptions error:&error];
    
    SuccessHandler successHandler = ^(NSURLSessionTask *task, id responseObject) {
        [self parseData:responseObject];
    };
    
    FailureHandler failureHandler = ^(NSURLSessionTask *operation, NSError *error) {
        if(error) {
            [self processError:operation error:error];
        }
    };
    
    [httpClient post:path withBody:params successHandler:successHandler failureHanlder:failureHandler];
}

- (void) getUsersItems {
    NSError *error;
    MeliDevSyncHttpOperation *httpClient = [[MeliDevSyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/users/221910727/items/search";
    NSString * result =[httpClient getWithAuth:path error:&error];
    NSLog(@"Result %@", result);
}

- (void) testDelete {
    NSError *error;
    MeliDevSyncHttpOperation *httpClient = [[MeliDevSyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/items/MLA635779960/pictures/939505-MLA25061434619_092016";
    NSString * result =[httpClient delete:path error:&error];
    NSLog(@"Result %@", result);
}

- (void) testPost {
    NSError *error;
    MeliDevSyncHttpOperation *httpClient = [[MeliDevSyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/items";
    NSString * result =[httpClient post:path withBody:[self createJsonDataForPost] error:&error];
    NSLog(@"Result %@", result);
}

- (void) testPut {
    NSError *error;
    MeliDevSyncHttpOperation *httpClient = [[MeliDevSyncHttpOperation alloc] init];
    httpClient.identity = self.identity;
    NSString *path = @"/items/MLA635779960";
    NSString * result =[httpClient put:path withBody:[self createJsonDataForPut] error:&error];
    NSLog(@"Result %@", result);
}

-(NSData *)createJsonDataForPut
{
    //your keys for json
    NSArray * keys = @[@"status"];
    
    //your objects for json
    NSArray * objects = @[@"paused"];
    
    //create dictionary to convert json object
    NSDictionary * jsonData=[[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    
    
    //convert dictionary to json data
    NSData * json =[NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];
    
    
    //convert json data to string for showing if you create it truely
    NSString * jsonString=[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    return json;
}

-(NSData *)createJsonDataForPost
{
    //your keys for json
    NSArray * keys = @[@"title",@"category_id", @"price", @"currency_id", @"available_quantity", @"buying_mode",
                     @"listing_type_id", @"condition", @"description", @"video_id", @"warranty", @"pictures", @"attributes"];
    
    //your objects for json
    NSArray * objects = @[@"Item de test - No Ofertar", @"MLA5529", @10, @"ARS", @1, @"buy_it_now", @"bronze",
                        @"new", @"Item:,  Ray-Ban WAYFARER Gloss Black RB2140 901  Model: RB2140. Size: 50mm. Name: WAYFARER. Color: Gloss Black. Includes Ray-Ban Carrying Case and Cleaning Cloth. New in Box",
                        @"YOUTUBE_ID_HERE", @"12 months by Ray Ban",
                        @[
                            @{@"source":@"http://upload.wikimedia.org/wikipedia/commons/f/fd/Ray_Ban_Original_Wayfarer.jpg"},
                            @{@"source":@"http://en.wikipedia.org/wiki/File:Teashades.gif"}
                        ],
                        @[
                              @{@"id":@"83000", @"value_id":@"91993"}
                        ]];
    
    //create dictionary to convert json object
    NSDictionary * jsonData=[[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    
    
    //convert dictionary to json data
    NSData * json =[NSJSONSerialization dataWithJSONObject:jsonData options:NSJSONWritingPrettyPrinted error:nil];
    
    
    //convert json data to string for showing if you create it truely
    NSString * jsonString=[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    return json;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)go:(id)sender {
   
}
@end
