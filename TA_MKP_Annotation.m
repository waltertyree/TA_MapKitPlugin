//
//  TA_MKP_Annotation.m
//  TA_Demo
//
//  Created by Walter Tyree on 1/24/11.
//  Copyright 2011 Tyree Apps, LLC. All rights reserved.
//

#import "TA_MKP_Annotation.h"


@implementation TA_MKP_Annotation

@synthesize latitude;
@synthesize longitude;
@synthesize image;
@synthesize theTitle;
@synthesize theSubtitle;
@synthesize detailHTML;


-(id)initWithDictionary:(NSDictionary *)aPlace{
	//aPlace is the NSDictionary that the main view controller is passing to us for JUST this object
	[self setTheTitle:[aPlace objectForKey:@"placeName"]];
	[self setTheSubtitle:[aPlace objectForKey:@"subTitle"]];
	[self setDetailHTML:[aPlace objectForKey:@"detail_HTML"]];
	
	[self setLatitude:[aPlace objectForKey:@"latitude"]];
	[self setLongitude:[aPlace objectForKey:@"longitude"]];
	
	[self setPinImage:[aPlace objectForKey:@"pinImage"]];
	
	return self;
}
-(NSString*)pinImage{
	return pinImage;
}

-(void)setPinImage:(NSString *)theName{
	[pinImage autorelease];
	pinImage = [theName retain];
	NSLog(@"The imagename for the pin will be:%@",pinImage);
	UIImage *tempImage = [UIImage imageNamed:pinImage];
	[self setImage:tempImage];
	
}

//This is added because we think that in low memory situations we are
//dumping the pin images. So, now we make a new one each time.
-(UIImage*)makeImage{
    UIImage *tempImage = [UIImage imageNamed:pinImage]; 
    return tempImage;
}
#pragma mark -
#pragma mark MKAnnotation Protocol Methods
- (CLLocationCoordinate2D)coordinate;
//This is required by the MKAnnotation protocol
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[self latitude] doubleValue];
    theCoordinate.longitude = [[self longitude ] doubleValue];
    return theCoordinate; 
}
- (NSString *)title
{
    return [self theTitle];
}

// optional
- (NSString *)subtitle
{
    return [self theSubtitle];
}

- (void)dealloc
{
    [image release];
    [super dealloc];
}

@end
