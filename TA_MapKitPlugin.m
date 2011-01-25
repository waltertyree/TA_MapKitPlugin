//
//  TA_MapKitPlugin.m
//  
//
//  Created by Walter Tyree on 1/24/11.
//  Copyright 2011 Tyree Apps, LLC. All rights reserved.
//

#import "TA_MapKitPlugin.h"
#import "TA_MKP_Annotation.h"
#import "TA_MKP_DetailView.h"


@implementation TA_MapKitPlugin

@synthesize mapView;
@synthesize mapViewAnnotations;

@synthesize initialMapWidth;
@synthesize initialLatitude;
@synthesize initialLongitude;




-(id)initWithTabInfo:(NSDictionary *)tabInfo topLevelTab:(NSDictionary *)topLevelTab {
	[self setMapViewAnnotations:[[NSMutableArray alloc]initWithCapacity:1]];
	
	for (NSDictionary *dict in [tabInfo objectForKey:@"Places"]) {
		TA_MKP_Annotation *tempPlace = [[TA_MKP_Annotation alloc] initWithDictionary:dict];
		if ([[tempPlace pinImage] length] == 0 && [topLevelTab objectForKey:@"pinImage"])
			[tempPlace setPinImage:[topLevelTab objectForKey:@"pinImage"]];
		[[self mapViewAnnotations] addObject:tempPlace];
		[tempPlace release];
	}
	[self setInitialLatitude:[tabInfo objectForKey:@"start_latitude"]];
	[self setInitialLongitude:[tabInfo objectForKey:@"start_longitude"]];
	[self setInitialMapWidth:[tabInfo objectForKey:@"start_view"]];
	
	return [self initWithNibName:@"TA_MapKitPlugin" bundle:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Setting up the crosshairs button to use to toggle on the user location
	UIImage* image = [UIImage imageNamed:@"iconLocation.png"];
	_locationButton = [[UIBarButtonItem alloc] initWithImage:image
												  style:UIBarButtonItemStyleBordered
												 target:self
												 action:@selector(locationButtonTouched:)];
	_locationButton.width = image.size.width + 10;
	[[self navigationItem] setRightBarButtonItem:_locationButton];
	
	//Set up the default mapview
	[[self mapView] setDelegate:self]; 
	[[self mapView] setMapType:MKMapTypeStandard];   // also MKMapTypeSatellite or MKMapTypeHybrid
	//CLLocationCoordinate2D *defaultCenter = CLLocationCoordinate2DMake(35.046872, -90.024971);
	
	MKCoordinateRegion tempRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([[self initialLatitude] doubleValue], [[self initialLongitude] doubleValue])
																	   ,[[self initialMapWidth] doubleValue],[[self initialMapWidth] doubleValue]); 
	[[self mapView] setRegion:[[self mapView] regionThatFits:tempRegion]];
	[[self mapView] addAnnotations:[self mapViewAnnotations]];
	}

-(void)locationButtonTouched:(id)sender;{
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark MKMapView Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id)annotation{
	//If the Annotation is the user location (the little blue circle) let the iPhone handle it
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
	
	if ([annotation isKindOfClass:[TA_MKP_Annotation class]]) {
		static NSString* TA_MKP_Pin = @"TA_MKP_wpinIdentifier";
		static NSString* TA_MKP_noPin = @"TA_MKP_nopinIdentifier";
		//MKAnnotationView* pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TA_MKP_AnnotationIdentifier];
		//If there is no annotation to reuse, make anew one
		//if (!pinView) {
		if ([[annotation pinImage] length] !=0) {
			MKAnnotationView* av_reuse = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TA_MKP_noPin];
			if (!av_reuse) {
				MKAnnotationView *av = [[[MKAnnotationView alloc] initWithAnnotation:annotation
																	 reuseIdentifier:TA_MKP_noPin] autorelease];
				UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				[av setCanShowCallout:YES];
				[rightButton addTarget:self
								action:nil
					  forControlEvents:UIControlEventTouchUpInside];
				
				[av setRightCalloutAccessoryView:rightButton];
				[av setOpaque:NO];
				[av setImage:[annotation image]];
				return av;
				 } else {
					 [av_reuse setAnnotation:annotation];
					 [av_reuse setImage:[annotation image]];
					 return av_reuse;
				 }
		}else {
			MKPinAnnotationView* pin_reuse = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TA_MKP_Pin];
			if (!pin_reuse) {
				MKPinAnnotationView *pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
																	 reuseIdentifier:TA_MKP_Pin] autorelease];
				UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				[pin setCanShowCallout:YES];
				[rightButton addTarget:self
								action:nil
					  forControlEvents:UIControlEventTouchUpInside];
				
				[pin setRightCalloutAccessoryView:rightButton];
				[pin setOpaque:NO];
				return pin;
			} else {
				[pin_reuse setAnnotation:annotation];
				return pin_reuse;
			}
		}
		}
	//if the annotation is not the user and is not one of the ones we created from the NGconfig list then
	//return nil so that the phone will display the default view for that kind of annotation
	return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	NSLog(@"%@",[(TA_MKP_Annotation *)[view annotation] detailHTML]);
	TA_MKP_DetailView *detailView = [[TA_MKP_DetailView alloc] init];
	[detailView setMapAnnotation:[view annotation]];
	[[self navigationController] pushViewController:detailView animated:YES];
	[detailView release];
}
#pragma mark -
#pragma mark View Lifecycle
- (void)viewWillAppear:(BOOL)animated
{


}

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
    [[self mapView] setDelegate:nil];
	[_mapView release];
	
	[_locationButton release];
	
	[super dealloc];
	
}


@end
