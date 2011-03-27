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

@interface TA_MapKitPlugin ()

	-(void)zoomToFitMapAnnotations;

@end



@implementation TA_MapKitPlugin

@synthesize mapView;
@synthesize mapViewAnnotations;

@synthesize locationList;

@synthesize initialMapWidth;
@synthesize initialLatitude;
@synthesize initialLongitude;



#pragma mark -
#pragma mark Set Up View
-(id)initWithTabInfo:(NSDictionary *)tabInfo topLevelTab:(NSDictionary *)topLevelTab {
	[self setMapViewAnnotations:[[NSMutableArray alloc]initWithCapacity:1]];
	
	for (NSDictionary *dict in [tabInfo objectForKey:@"Places"]) {
		TA_MKP_Annotation *tempPlace = [[TA_MKP_Annotation alloc] initWithDictionary:dict];
		if ([[tempPlace pinImage] length] == 0 && [topLevelTab objectForKey:@"pinImage"])
			[tempPlace setPinImage:[topLevelTab objectForKey:@"pinImage"]];
		[[self mapViewAnnotations] addObject:tempPlace];
		[tempPlace release];
	}
	NSSortDescriptor *theTitleSorter = [[NSSortDescriptor alloc] initWithKey:@"theTitle" ascending:YES];
	[[self mapViewAnnotations] sortUsingDescriptors:[NSArray arrayWithObjects:theTitleSorter,nil]];
	[theTitleSorter release];

	if ([tabInfo objectForKey:@"start_latitude"]) {
		[self setInitialLatitude:[tabInfo objectForKey:@"start_latitude"]];
	}else {
		[self setInitialLatitude:[NSNumber numberWithFloat:35.047]];
	}

	if ([tabInfo objectForKey:@"start_longitude"]) {
		[self setInitialLongitude:[tabInfo objectForKey:@"start_longitude"]];
		
	}else {
		[self setInitialLongitude:[NSNumber numberWithFloat:-90.025]];
	}[self setInitialMapWidth:[tabInfo objectForKey:@"start_view"]];
	
	return [self initWithNibName:@"TA_MapKitPlugin" bundle:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// "Segmented" control to the right
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 [UIImage imageNamed:@"locationList.png"],
											 [UIImage imageNamed:@"iconLocation.png"],
											 nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	
	_navControls = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	[[self navigationItem] setRightBarButtonItem:_navControls];
   
	//Setting up the crosshairs button to use to toggle on the user location
	/*UIImage* image = [UIImage imageNamed:@"iconLocation.png"];
	_locationButton = [[UIBarButtonItem alloc] initWithImage:image
												  style:UIBarButtonItemStyleBordered
												 target:self
												 action:@selector(locationButtonTouched:)];
	_locationButton.width = image.size.width + 10;
	[[self navigationItem] setRightBarButtonItem:_locationButton];
	*/
	//Set up the default mapview
	[[self mapView] setDelegate:self]; 
	[[self mapView] setMapType:MKMapTypeStandard];   // also MKMapTypeSatellite or MKMapTypeHybrid
	//CLLocationCoordinate2D *defaultCenter = CLLocationCoordinate2DMake(35.046872, -90.024971);
	[[self mapView] addAnnotations:[self mapViewAnnotations]];
	
	
	if ([self initialMapWidth] != nil) {
        CLLocationCoordinate2D centerPoint;
        centerPoint.latitude = [[self initialLatitude] doubleValue];
        centerPoint.longitude = [[self initialLongitude] doubleValue];
	MKCoordinateRegion tempRegion = MKCoordinateRegionMakeWithDistance(centerPoint,[[self initialMapWidth] doubleValue],[[self initialMapWidth] doubleValue]); 
	[[self mapView] setRegion:[[self mapView] regionThatFits:tempRegion]];
	}else {
		[self zoomToFitMapAnnotations];
	}
	[[self locationList] reloadData];
	 [super viewDidLoad];
}
- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	//NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
	if ([segmentedControl selectedSegmentIndex] == 0) {
		if ([[self locationList] isHidden]) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[[self locationList] setHidden:NO];
			[UIView commitAnimations];
		}else {

			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[[self locationList] setHidden:YES];
			[UIView commitAnimations];
			
		}

		
	} else {
		[self performSelector:@selector(locationButtonTouched:) withObject:sender];
	}
}
#pragma mark -
#pragma mark User Interaction Functions
-(void)zoomToFitMapAnnotations
/*This code is based on an old code snippit posted by Codis to their blog
 http://codisllc.com/blog/zoom-mkmapview-to-fit-annotations/
*/
{
    if([[[self mapView] annotations] count] == 0)
        return;
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for(TA_MKP_Annotation* annotation in [[self mapView] annotations])
    {
		
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
		
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
    region = [[self mapView] regionThatFits:region];
    [[self mapView] setRegion:region animated:YES];
}

-(void)locationButtonTouched:(id)sender;{
	[[self mapView] setShowsUserLocation:![[self mapView] showsUserLocation]]; 
	if (![[self mapView] isUserLocationVisible] && [[self mapView] showsUserLocation]){
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:NSLocalizedString(@"Location",@"Title for Alert Box when the user's location is not on the map")
							  message:NSLocalizedString(@"Your location is not on this map. Would you like to zoom the map to include your location?",@"Body for User Location alert Box")
							  delegate: self
							  cancelButtonTitle:NSLocalizedString(@"YES",@"YES")
							  otherButtonTitles:NSLocalizedString(@"NO",@"NO"),nil];
		[alert show];
		[alert release];
		
	}
}

- (void) addButtontToCalloutIfNeeded: (MKAnnotationView *) mkav  {
	if ([[(TA_MKP_Annotation*)[mkav annotation] detailHTML] length] != 0) {
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton addTarget:self
					action:nil
		  forControlEvents:UIControlEventTouchUpInside];
	[mkav setRightCalloutAccessoryView:rightButton];
	} else {
		[mkav setRightCalloutAccessoryView:nil];
	}
	
}
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
        NSLog(@"The image title is: %@ and the length is: %d",[annotation pinImage],[[annotation pinImage]length]);
		if ([[annotation pinImage] length] !=0) {
			MKAnnotationView* av_reuse = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TA_MKP_noPin];
			if (!av_reuse) {
				MKAnnotationView *av = [[[MKAnnotationView alloc] initWithAnnotation:annotation
																	 reuseIdentifier:TA_MKP_noPin] autorelease];
				
				[av setCanShowCallout:YES];	
				[self addButtontToCalloutIfNeeded:av];
				[av setOpaque:NO];
                [av setImage:[annotation makeImage]];
				return av;
				 } else {
					 [av_reuse setAnnotation:annotation];
                     [av_reuse setImage:[annotation makeImage]];
                     [av_reuse setCanShowCallout:YES];
					 [self addButtontToCalloutIfNeeded:av_reuse];					 
					 return av_reuse;
				 }
		}else {
			MKPinAnnotationView* pin_reuse = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TA_MKP_Pin];
			if (!pin_reuse) {
				MKPinAnnotationView *pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
																			reuseIdentifier:TA_MKP_Pin] autorelease];
				[pin setCanShowCallout:YES];
				[self addButtontToCalloutIfNeeded:pin];		
				[pin setOpaque:NO];
				return pin;
			} else {
				[pin_reuse setAnnotation:annotation];
				[pin_reuse setCanShowCallout:YES];
				[self addButtontToCalloutIfNeeded:pin_reuse];	
				return pin_reuse;
			}
		}
		}
	//if the annotation is not the user and is not one of the ones we created from the NGconfig list then
	//return nil so that the phone will display the default view for that kind of annotation
	return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	NSLog(@"The detailHTML for this annotation is:%@",[(TA_MKP_Annotation *)[view annotation] detailHTML]);
	TA_MKP_DetailView *detailView = [[TA_MKP_DetailView alloc] init];
	[detailView setMapAnnotation:[view annotation]];
	[[self navigationController] pushViewController:detailView animated:YES];
	[detailView release];
}


#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self zoomToFitMapAnnotations];
			break;
		default:
			break;
	}
}
#pragma mark -
#pragma mark UITable View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		//They tapped on one of the map annotations. We want to:
	//2) Hide the tableview
	[tableView setHidden:YES];
	
	
	//1) Center that annotation on the map
	TA_MKP_Annotation *tempAnnotation;
	tempAnnotation = [[self mapViewAnnotations] objectAtIndex:[indexPath row]];
	[[self mapView] setCenterCoordinate:[tempAnnotation coordinate] 
							   animated:YES];
	

	//4) show the Callout for the annotation
	[[self mapView] selectAnnotation:tempAnnotation animated:YES];
	//3) Deselect the selected row
	[tableView deselectRowAtIndexPath:indexPath animated:YES];


	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   //We are reading from the map annotations view
   //We want to make a generic cell with an arrow detail view
   //We want to put in the name
   //We want to add the subtitle but comment that out
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ALocation"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ALocation"] autorelease];
    }
	//This line was changed for iPhone 3.0
	//[[UIDevice currentDevice] systemVersion]);
	//cell.text = [trialArray objectAtIndex:indexPath.row]; //but cell.text is depreciated
    [cell.textLabel setText:[[[self mapViewAnnotations] objectAtIndex:indexPath.row] theTitle]];
	[cell.detailTextLabel setText:[[[self mapViewAnnotations] objectAtIndex:indexPath.row] theSubtitle]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//We want as many rows in our table as there are items in the mapview annotations
	TA_MKP_Annotation *tempAnnotation; 
	for (tempAnnotation in [self mapViewAnnotations]) {
		NSLog(@"The name to be displayed in the TableView is:%@",[tempAnnotation theTitle]);
			  }
			  return [[self mapViewAnnotations] count];

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
	
	[_navControls release];
	
	[super dealloc];
	
}


@end
