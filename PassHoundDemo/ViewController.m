//
//  ViewController.m
//  PassHoundDemo
//
//  Created by troy simon on 10/30/12.
//  Copyright (c) 2012 PassHound LLC. All rights reserved.
//

#import "ViewController.h"
#import "PassHoundLib.h"

@interface ViewController () {
    PassHoundLib *sharedManager;
}

@end

@implementation ViewController

@synthesize user;
@synthesize pwd;
@synthesize error;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    sharedManager = [[PassHoundLib alloc] init];
    
    //Login to PassHound
    if ([sharedManager login:@"demo@demo.com" password:@"demo"]) {
        int iid = 0;
        
        // Retrieve the PassHound PassBook Templates
        NSArray *lists = [sharedManager getTemplates];
        NSDictionary *data =[ lists lastObject];
        
        // Obtain the ID of the last PassHound Template
        iid = [[data objectForKey:@"id"] integerValue];
        
        // Obtain the Key/Values of the PassHound Template
        lists = [sharedManager getTemplateKeyValue:iid];
        
        // Obtain all the PassHound Passes
        lists = [sharedManager getPasses];
        data =[ lists lastObject];
        iid = [[data objectForKey:@"id"] integerValue];
        
        // Obtain the Key/Values of the PassHound PassBook
        NSArray *a = [sharedManager  getBookKeyValue:iid];
        
        // Extract the Key/Values
        NSMutableDictionary *keyvals = [[NSMutableDictionary alloc] initWithCapacity:[a count]];
        
        for (NSDictionary *d in a) {
            [keyvals setValue:[d objectForKey:@"key"] forKey:[d objectForKey:@"data"]];
        }
        
        // Change the Key Values
        if (![sharedManager editBook:@"primaryFields_depart_label=PHILADELPHIA&primaryFields_depart_value=PHL" forPass:iid])
            NSLog(@"%@",[sharedManager getError]);
        
        // Email the Template
        [sharedManager send:iid email:@"info@passhound.com" emailTemplate:0];
    } else {
        NSLog(@"%@",[sharedManager getError]);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    return YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [user becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
