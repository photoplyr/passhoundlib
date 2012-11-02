//
//  PassHoundLib.h
//  PassHoundLib
//
//  Created by troy simon on 11/1/12.
//  Copyright (c) 2012 PassHound LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassHoundLib : NSObject 

- (id)init;
-(NSString *) getError;
-(NSString *) getToken;
-(BOOL) login:(NSString *) usr password:(NSString *) pwd;
-(NSArray *) getTemplateKeyValue:(int)idTemplate ;
-(NSArray *) getTemplates;
-(NSArray *) getPasses;
-(NSArray *) getBookKeyValue:(int) idBook ;
-(BOOL) editBook:(NSString *)vals  forPass:(int)idPass;
-(BOOL) send:(int)bookId email:(NSString *)email emailTemplate:(int)id_email_tmp ;
-(NSString *) getPassImage:(int)idPass;

@end
