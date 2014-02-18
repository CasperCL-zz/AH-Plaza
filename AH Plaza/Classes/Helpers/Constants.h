//
//  Constants.h
//  AH Plaza
//
//  Created by Casper Eekhof on 07-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#ifndef AH_Plaza_Constants_h
#define AH_Plaza_Constants_h

#define isiPhone4 (!([[UIScreen mainScreen] bounds].size.height - 480))
#define isiPhone5 (!([[UIScreen mainScreen] bounds].size.height - 580))
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS6 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0.0") && SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.1.3"))
#define iOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))

#define ah_blue 0x348FD7

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif
