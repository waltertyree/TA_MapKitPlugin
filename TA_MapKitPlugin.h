//
//  TA_MapKitPlugin.h
//  
//
//  Created by Walter Tyree on 1/24/11.
//  Copyright 2011 Tyree Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TA_MapKitPlugin : UIViewController <MKMapViewDelegate, UIAlertViewDelegate, UITableViewDelegate>{
	MKMapView *_mapView;
	UIBarButtonItem *_locationButton;
	NSMutableArray *_mapViewAnnotations;
	
	UITableView *_locationList;
	
	//These are variables to store information that TapLynx gives us
	NSNumber *_initialLatitude;
	NSNumber *_initialLongitude;
	NSNumber *_initialMapWidth;


}

@property (nonatomic,retain) IBOutlet UITableView *locationList;
@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) IBOutlet NSMutableArray *mapViewAnnotations;
@property (nonatomic,retain) NSNumber *initialLatitude;
@property (nonatomic,retain) NSNumber *initialLongitude;
@property (nonatomic,retain) NSNumber *initialMapWidth;

-(id)initWithTabInfo:(NSDictionary *)tabInfo topLevelTab:(NSDictionary *)topLevelTab;
-(void)locationButtonTouched:(id)sender;
@end
