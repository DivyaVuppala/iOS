//
//  NetworkServiceHandler.m
//  RAKbankDynamic
//
//  Created by Sanjay B on 15/10/10.
//  Copyright 2010 Zylog Inc. All rights reserved.
//

#import "NetworkServiceHandler.h"

@interface NetworkServiceHandler(PRIVATE)

@end

@implementation NetworkServiceHandler

#pragma mark resource Path
+(NSString*)getResourceFilePath:(NSString*)filePath
{
	NSString* resourcePath = [[NSBundle mainBundle]resourcePath];
	resourcePath = [resourcePath stringByAppendingPathComponent:filePath];
	return resourcePath;
}


+(BOOL)NSStringIsValidateAmount:(NSString*)checkString
{
	NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:@"."];
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			if ([characters characterIsMember:character])
			{
				characterCount++;
			}
			else
			{
				return NO;
			}
			
		}
		
	}
	
	if((characterCount == 0) || (characterCount == 1))
	{
		return YES;
	}
	else
	{
		return NO;
	}
	
}

+(BOOL)NSStringIsValidateDecimal:(NSString*)checkString
{
    NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    int characterCount = 0;
    
    NSUInteger i;
    for (i = 0; i < [checkString length]; i++)
    {
        unichar character = [checkString characterAtIndex:i];
        if(![numcharacters characterIsMember:character])
        {
            characterCount ++;
            
        }
       }
    if(characterCount == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
	
}


+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
	BOOL sticterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}

+(BOOL)NSStringIsValidatePhone:(NSString*)checkString
{
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			characterCount ++;
			
		}
		
	}
	
	//NSLog(@"Total characters = %d", characterCount);
	
	if(characterCount == 0)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}
+(BOOL)NSStringIsValidateAccountNo:(NSString*)checkString
{
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			characterCount ++;
			
		}
		
	}
	
	//NSLog(@"Total characters = %d", characterCount);
	
	if(characterCount == 0)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+(BOOL)NSStringIsValidateDate:(NSString*)checkString
{
    //	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890/"];
    //	int characterCount = 0;
    //	
    //	NSUInteger i;
    //	for (i = 0; i < [checkString length]; i++)
    //	{
    //		unichar character = [checkString characterAtIndex:i];
    //		if(![numcharacters characterIsMember:character])
    //		{
    //			characterCount ++;
    //			
    //		}
    //		
    //	}
    //	
    //	if(characterCount == 0)
    //	{
    //		return YES;
    //	}
    //	else
    //	{
    //		return NO;
    //	}
    
    NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890/"];
    int characterCount = 0;
    
    NSUInteger i;
    for (i = 0; i < [checkString length]; i++)
    {
        unichar character = [checkString characterAtIndex:i];
        if(![numcharacters characterIsMember:character])
        {
            characterCount ++;
            
        }
        
    }
    
    if(characterCount == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


+(BOOL)NSStringIsValidateAlphabet:(NSString *)checkString
{
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			characterCount ++;
			
		}
		
	}
	
	//NSLog(@"Total characters = %d", characterCount);
	
	if(characterCount == 0)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+(BOOL)NSStringIsValidateAlphaNumaric:(NSString *)checkString
{
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			characterCount ++;
			
		}
		
	}
	
	//NSLog(@"Total characters = %d", characterCount);
	
	if(characterCount == 0)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+(BOOL)NSStringIsValidateAlphaNumaric_withSplChrac:(NSString *)checkString
{
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-."];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			characterCount ++;
			
		}
		
	}
	
	//NSLog(@"Total characters = %d", characterCount);
	
	if(characterCount == 0)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}


+(BOOL)NSStringIsValidateAlphaNumaric_withoutSpace:(NSString *)checkString
{
	NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
	int characterCount = 0;
	
	NSUInteger i;
	for (i = 0; i < [checkString length]; i++)
	{
		unichar character = [checkString characterAtIndex:i];
		if(![numcharacters characterIsMember:character])
		{
			characterCount ++;
			
		}
		
	}
	
	
	if(characterCount == 0)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}



//+(BOOL)NSStringIsValidateOnlyChar:(NSString*)checkString
//{
//    NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890-~!@#$%^&*()_+/?<>.,`"];
//    int characterCount = 0;
//    
//    NSUInteger i;
//    for (i = 0; i < [checkString length]; i++)
//    {
//        unichar character = [checkString characterAtIndex:i];
//        if(![numcharacters characterIsMember:character])
//        {
//            characterCount ++;
//            
//        }
//        
//    }
//    
//    //NSLog(@"Total characters = %d", characterCount);
//    
//    if(characterCount == 0)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

+(BOOL)NSStringIsValidateIBAN:(NSString*)checkString{
   	if([checkString length] < 32)
	{
		return YES;
	}
	else
		return NO;
}


+(BOOL)isAllowAccountNumber:(NSString*)strg
{
	if([strg length] < 13)
	{
		return YES;
	}
	else
		return NO;
}
+(BOOL)isAllowOutsideAccountNumber:(NSString*)strg
{
	if([strg length] < 34)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowEmailId:(NSString*)strg
{
	if([strg length] < 30)
	{
		return YES;
	}
	else
		return NO;
}


+(BOOL)isAllowOtherComment:(NSString*)strg
{
	if([strg length] < 30)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowTransferName:(NSString*)strg
{
	if([strg length] < 64)
	{
		return YES;
	}
	else
		return NO;
}
+(BOOL)isAllowTransferDetails:(NSString*)strg
{
	if([strg length] < 35)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowCity:(NSString*)strg
{
	if([strg length] < 32)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowMxNames:(NSString*)strg
{
	if([strg length] < 20)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowMaxNumber:(NSString*)strg
{
	if([strg length] < 24)
	{
		return YES;
	}
	else
		return NO;
}


+(BOOL)isAllowSwift:(NSString*)strg
{
	if([strg length] < 11)
	{
		return YES;
	}
	else
		return NO;
}



+(BOOL)isAllowMobileNumber:(NSString*)strg
{
	if([strg length] < 12)
	{
		return YES;
	}
	else
		return NO;
    
    /*  NSCharacterSet* numcharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
     int characterCount = 0;
     
     NSUInteger i;
     for (i = 0; i < [strg length]; i++)
     {
     unichar character = [strg characterAtIndex:i];
     if(![numcharacters characterIsMember:character])
     {
     characterCount ++;
     
     }
     
     }
     
     if(characterCount == 0)
     {
     return YES;
     }
     else
     {
     return NO;
     }*/
    
    
    
}

+(BOOL)isAllowFaxNumber:(NSString*)strg
{
	if([strg length] < 9)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowPhoneNumber:(NSString*)strg
{
	if([strg length] < 9)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowLoanNumber:(NSString*)strg
{
	if([strg length] < 8)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowCreditCardNumber:(NSString*)strg
{
	if([strg length] < 16)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowPONumber:(NSString*)strg
{
	if([strg length] < 6)
	{
		return YES;
	}
	else
		return NO;
}
+(BOOL)isAllowCountryCode:(NSString*)strg
{
	if([strg length] < 3)
	{
		return YES;
	}
	else
		return NO;
}
+(BOOL)isAllowNames:(NSString*)strg
{
	if([strg length] < 15)
	{
		return YES;
	}
	else
		return NO;
}
+(BOOL)isAllowMaxChars:(NSString*)strg
{
	if([strg length] < 30)
	{
		return YES;
	}
	else
		return NO;
}
+(BOOL)isAllowAmount:(NSString*)strg
{
	if([strg length] < 20)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowDesc:(NSString*)strg
{
	if([strg length] < 50)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowtextfied:(NSString*)strg
{
	if([strg length] < 50)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowtextNameOfCard:(NSString*)strg
{
	if([strg length] <= 47)
	{
		return YES;
	}
	else
		return NO;
}

+(BOOL)isAllowtextNameOnCard:(NSString*)strg
{
	if([strg length] <= 140)
	{
		return YES;
	}
	else
		return NO;
}


+(BOOL)isAllowPinNumber:(NSString*)strg
{
		
	if(([strg length] < 3) )
	{
		return YES;
	}
	
	else
		return NO;
    
}




+(BOOL)isAllowLoginName:(NSString*)strg
{
	if([strg length] < 15)
	{
		return YES;
	}
	else
		return NO;
}



@end


























