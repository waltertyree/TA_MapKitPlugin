#Copyright 2012 Tyree Apps
#Proper call of this file is with two Arguments. The firs is a csv file and the second is a well formed NGconfig.plist that has a TA_MapKit entry with an array of Places already in it.
#This is a destructive command and it will replace the contents of the NGConfig.plist passed to it.

require 'csv'
require 'cgi'

finalFile = ""
  
def printPlistHeader
  return "<key>Places</key>\n<array>\n"
end

def printPlistFooter
  return "</array>"
end


finalFile += printPlistHeader

File.open(ARGV[0]) do |f|
  CSV.foreach(f) do |row|  
  if !row[0].to_s.empty? && row[0] != 'Place Title'
      finalFile += "<dict><key>placeName</key>\n"
      finalFile += "<string>" + CGI.escapeHTML(row[0]) + "</string>\n"
      if checkNil(row[1])
        finalFile += "<key>subTitle</key>\n"
        finalFile += "<string>" + CGI.escapeHTML(row[1]) + "</string>\n"
      end
      if !row[4].to_s.empty?
        finalFile += "<key>pinImage</key>\n"
        finalFile += "<string>" + CGI.escapeHTML(row[4]) + "</string>\n"
      end
      if !row[5].to_s.empty?
        finalFile += "<key>detail_HTML</key>\n"
        finalFile += "<string>" + CGI.escapeHTML(row[5]) + "</string>\n"
      end
      finalFile += "<key>latitude</key>\n"
      finalFile += "<real>" + row[2] + "</real>\n"
      finalFile += "<key>longitude</key>\n"
      finalFile += "<real>" + row[3] + "</real>\n"
      
      finalFile += "</dict>\n"
    end
	end
end

finalFile += printPlistFooter


plistFile = File.read(ARGV[1])
 plistFile.sub!(/<key>Places.+?<\/array>/m, finalFile)

 File.write(ARGV[1],plistFile)


