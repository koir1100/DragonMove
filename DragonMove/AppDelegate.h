//
//  AppDelegate.h
//  MenuEx1
//
//  Created by 51310 on 13. 4. 3..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
    
	CCDirectorIOS	*director_;							// weak ref
    
    NSInteger gameScore; // 게임 점수를 저장하는 변수
    BOOL gameResult; // 게임 결과를 저장하는 변수
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (readwrite) NSInteger gameScore;
@property (readwrite) BOOL gameResult;

@end
