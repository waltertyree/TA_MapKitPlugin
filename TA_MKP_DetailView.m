//
//  TA_MKP_DetailView.m
//  TA_Demo
//
//  Created by Walter Tyree on 1/24/11.
//  Copyright 2011 Tyree Apps, LLC. All rights reserved.
//

#import "TA_MKP_DetailView.h"


@implementation TA_MKP_DetailView

@synthesize mapAnnotation;
@synthesize webView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
-(void)viewWillAppear:(BOOL)animated{
	NSString *bodyHTML;
	NSStringEncoding encoding;
	NSError* error;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TA_MKP_Template" ofType:@"html"]; 
	NSString* myString = [NSString stringWithContentsOfFile:filePath usedEncoding:&encoding error:&error];
	if ([myString length] != 0) {
		bodyHTML = [myString stringByReplacingOccurrencesOfString:@"[[detailHTML]]" withString:[[self mapAnnotation] detailHTML]];
	} else {
		bodyHTML = [[self mapAnnotation] detailHTML];
	}

	[webView loadHTMLString:bodyHTML baseURL:nil];	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
