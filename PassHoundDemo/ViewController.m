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
    int iid;
}

@end

@implementation ViewController

@synthesize passcard;
@synthesize email;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    sharedManager = [[PassHoundLib alloc] init];
    
    [self test2];
}

- (NSTimeInterval)getUTCFormateDate{
    
    NSDateComponents *comps = [[NSCalendar currentCalendar]
                               components:NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    
    return [[[NSCalendar currentCalendar] dateFromComponents:comps] timeIntervalSince1970];
}

-(void) test2 {
    NSString *sName = [NSString stringWithFormat:@"Test%f",[self getUTCFormateDate]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];

    
    if ([sharedManager login:@"troy.simon@gmail.com" password:@"tsim0n"]) {
        if ([sharedManager createPass:sName fromTemplate:@"RJTEst"] ) {
            
            NSArray *a = [sharedManager getPassKeyValue:sName];
            
            // Extract the Key/Values
            NSMutableDictionary *keyvals = [[NSMutableDictionary alloc] initWithCapacity:[a count]];
            
            for (NSDictionary *d in a) {
                 [keyvals setValue:[d objectForKey:@"data"] forKey:[d objectForKey:@"key"]];
                //[keyvals setValue:[d objectForKey:@"key"] forKey:[d objectForKey:@"data"]];
            }
            
            [sharedManager editPass:[NSString stringWithFormat: @"barcode_altText=%@",dateString] forPass:sName];
            
            // Update the image
            UIImage *image = [UIImage imageNamed:@"passhound.png"];
            NSData *imageData = UIImagePNGRepresentation(image);
            
            NSString *s = [sharedManager postStripImage: imageData forImage:@"strip.png" forTemplate:iid];
            
            if ([sharedManager sendByName:sName email:@"simon.troy@me.com" emailTemplate:@"rentjuice"]) {
                
            }
            
        }
    }
}


-(void) test1 {
    //Login to PassHound
   // if ([sharedManager login:@"demo@demo.com" password:@"demo"]) {
     if ([sharedManager login:@"troy.simon@gmail.com" password:@"tsim0n"]) {
        iid = 0;
        
        // Retrieve the PassHound PassBook Templates
        NSArray *lists = [sharedManager getTemplates];
        NSDictionary *data =[ lists lastObject];
        
        // Obtain the ID of the last PassHound Template
        iid = [[data objectForKey:@"id"] integerValue];
        
        // Update the image
        UIImage *image = [UIImage imageNamed:@"passhound.png"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSString *s = [sharedManager postStripImage: imageData forImage:@"strip.png" forTemplate:iid];
         
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
        if (![sharedManager editBook:@"primaryFields_depart_label=Newark&primaryFields_depart_value=NWK" forPass:iid])
            NSLog(@"%@",[sharedManager getError]);
        
        NSString *sURL = [sharedManager getPassImage:iid];
        
        NSURL *imgUrl=[[NSURL alloc] initWithString:sURL];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:imgUrl];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                passcard.image = [UIImage imageWithData:image];
            });
        });
        
    } else {
        NSLog(@"%@",[sharedManager getError]);
    }
}

-(IBAction)savePass:(id)sender {
    //NSURL *url = [[NSURL alloc] initWithString:[sharedManager getPassURL]];
    //[[UIApplication sharedApplication] openURL:url];
  
}

-(IBAction)emailPass:(id)sender {
    // Email the Template
    [self.email resignFirstResponder];
    if ([sharedManager send:iid email:self.email.text emailTemplate:0] ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PassHound" message:@"Pass was emailed!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if ([sharedManager send:iid email:self.email.text emailTemplate:0]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PassHound" message:@"Pass was emailed!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    
    return YES;
}

-(void) viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
