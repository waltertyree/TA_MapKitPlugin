//
//  TA_MKP_DetailView.h
//  TA_Demo
//
//  Created by Walter Tyree on 1/24/11.
//  Copyright 2011 Tyree Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TA_MKP_Annotation.h"


@interface TA_MKP_DetailView : UIViewController {
	UIWebView *webView;
	TA_MKP_Annotation *mapAnnotation;

}
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) TA_MKP_Annotation *mapAnnotation;

@end
