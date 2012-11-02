//
//  ViewController.h
//  PassHoundDemo
//
//  Created by troy simon on 10/30/12.
//  Copyright (c) 2012 PassHound LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UIImageView *passcard;
@property (nonatomic,strong) IBOutlet UITextField *email;
@end
