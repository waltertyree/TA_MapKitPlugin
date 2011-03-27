//
//  TA_MKP_Annotation.h
//  TA_Demo
//
//  Created by Walter Tyree on 1/24/11.
//  Copyright 2011 Tyree Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TA_MKP_Annotation : NSObject <MKAnnotation>{
	NSNumber *latitude;
	NSNumber *longitude;
	
	NSString *theTitle;
	NSString *theSubtitle;
	NSString *detailHTML;
	
	NSString *pinImage;
	UIImage *image;

}
@property (nonatomic,retain) NSString *pinImage;
@property (nonatomic,retain) NSNumber *latitude;
@property (nonatomic,retain) NSNumber *longitude;
@property (nonatomic,retain) UIImage *image;

@property (nonatomic,retain) NSString *theTitle;
@property (nonatomic,retain) NSString *theSubtitle;
@property (nonatomic,retain) NSString *detailHTML;


-(id)initWithDictionary:(NSDictionary *)aPlace;
-(UIImage *)makeImage;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end
