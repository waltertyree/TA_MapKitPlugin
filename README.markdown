#Readme for TA\_MapKit Plugin for TapLynx

#####Created by Walter Tyree on 9/13/10.
#####Copyright 2010 Tyree Apps, LLC. All rights reserved.

In order to use the MapKit features of the iPhone, you first must ensure that you have added the 
MapKit framework to your applicaiton. If you have never added a framework to XCode here is a [link
to instructions from Apple](http://developer.apple.com/library/ios/#recipes/XcodeRecipes/Linking_to_Libraries_and_Frameworks/Linking_to_Libraries_and_Frameworks.html)

If the above link is broken, it comes from the iOS Reference Library, XCode 3 Recipes document
and the Linking to Libraries and Frameworks chapter.

This first version of the Tyree Apps MapKit plugin for TapLynx requires locations to be in
latitude and longitude notation, rather than simple Street Address/Zip. There seems to
be a lot of licensing and marketing tied up with geocoding of addresses, so for now we
are leaving that step up to the user. For US based addresses we like www.geocoder.us but
there are many other free and paid services available.

##NGConfig.plist Configurations
As with any other TapLynx plugin, this is designed so that the user can get a usable product using only the NGConfig.plist file. The main map layout and configuration is done at the top level of the Dictionary. All of the places to be represented on the map are done within an array with a key of _Places_. There is a plist snippet titled _TA\_MKP\_plist.plist_ included in the project which has a sample dictionary that you can paste into code to view the sample data. _Important_ if you do not want to use a particular key make sure to delete the whole key, don\'t just leave it with a blank value.

###Key \(Type\): Value Description
Title \(String\): This is the string that will appear in the Navigation bar above the map
ShortTitle \(String\): This is the title for the button on the tab bar
TabImageName \(String\): This is the filename of an image that is included in the project and is of suitable size and format for a tab button
customViewControllerClass \(String\): This is the name of the controller it should always be TA\_MapKitPlugin
start\_latitude \(Number\): This is a floating point decimal used for the latitude. Latitudes that are North of the Equator are represented by positive numbers. If no value is supplied the default of 35.047 is used
start\_longitude \(Number\): This is a floating point decimal used for the longitude. Longitudes that are East of the Prime Meridian are represented by positive numbers. If no value is supplied, the default of -90.025 is used.
start\_view \(Number\): This is the width, in meters, that the default view of the map should have. If no value is supplied, the map will set its zoom level so that all of the pins are visible.
pinImage \(String\): This is the filename of an image used to replace the default map pin icon supplied by the system. If no pinImage is supplied a standard, red pin will be displayed. You can place this key either at the root of the map dictionary or within any of the item dictionaries. This give the possibility for a mixutre of pin images.
Places \(Array\): This is an array of dictionaries. Each dictionary will have information about 1 location.
_Within The Places Array_
placeName \(String\): This is the main title that will be displayed in the callout
subTitle \(String\): This will be the subtitle displayed in the callout. This is optional
detail\_HTML \(String\): This is the HTML that will be displayed on a detail view that is pushed onto the application when the user clicks on the callout.
latitude \(Number\): The latitude value for the location.
longitude \(Number\): The longitude value for the location.
pinImage \(String\): This is the filename of an image icon that will display only for this location.
