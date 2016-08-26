//
//  MeliDevSDKExampleViewController.m
//  MeliDevSDK
//
//  Created by Ignacio Giagante on 26/8/16.
//  Copyright © 2016 Mercado Libre. All rights reserved.
//

#import "MeliDevSDKExampleViewController.h"
#import <MeliDevSDK/MeliDevTestViewController.h>

@interface MeliDevSDKExampleViewController ()
- (IBAction)go:(id)sender;

@end

@implementation MeliDevSDKExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)go:(id)sender {
    MeliDevTestViewController * controller = [[MeliDevTestViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
