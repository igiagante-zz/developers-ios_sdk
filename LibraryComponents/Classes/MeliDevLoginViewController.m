//
//  MeliDevLoginViewController.m
//  Pods
//
//  Created by Ignacio Giagante on 12/9/16.
//
//

#import "MeliDevLoginViewController.h"
#import "Identity.h"
#import "MBProgressHUD.h"

const NSString * LOGIN_URL = @"http://auth.mercadolibre.com/authorization?response_type=token&client_id=";
const NSString * CALLBACK_LOGIN = @"login";
const NSString * CALLBACK_MESSAGE_DISPATCH = @"background_message_dispatch";

@interface MeliDevLoginViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (nonatomic) Identity * identity;

- (void *) createParamDictionary: (NSString *) urlString;

@end

@implementation MeliDevLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.delegate = self;
    
    NSString *urlLogin = [LOGIN_URL stringByAppendingString:_appId];
    NSURL *url = [NSURL URLWithString:urlLogin];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.layer.zPosition = 1;
    
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *urlString = url.absoluteString;
    
    NSLog(@"Url: %@", urlString);
    
    if([urlString containsString:self.redirectUrl]) {
        NSArray * parts = [urlString componentsSeparatedByString:@"#"];
        [self getIdentityData:parts[1]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([urlString containsString: CALLBACK_LOGIN] || [urlString containsString: CALLBACK_MESSAGE_DISPATCH]) {
        [self.HUD hideAnimated:TRUE];
    }
    return YES;
}

- (void *) getIdentityData: (NSString *) urlString {
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        
        [queryStringDictionary setObject:value forKey:key];
    }

    self.onLoginCompleted(queryStringDictionary);
    [self.HUD hideAnimated:TRUE];
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    return queryItem.value;
}

@end
