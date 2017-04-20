#!/usr/bin/env bash

# CAVEATS:
#
#     * Version number is hard-coded (39.0) so change it if
#       necessary.
#
#     * depends on the `describeMetadata` target found in
#       the base "build.xml" in the migration tool download
#       zipfile.

# (1) GENERATE PACKAGE.XML THAT CONTAINS ALL METADATA TYPES
#     AVAILABLE FOR THE TARGET ORG
#
#     Spits out "getAllMetaPackage.xml". Rename and move it
#     to "getAllMeta" directory (or any other dir for that
#     matter but then change the `retrieveTarget` attribute.
ant describeMetadata | awk '
  BEGIN {print "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">"};
  /XMLName:/{print "<types><members>*</members><name>"$3"</name></types>"};
  END {print "<version>39.0</version></Package>"}' > targets/getAllMeta/package.xml

# (2) COPY ANT TARGET TO BUILD.XML (IF NOT THERE ALREADY)
#
# <target name="getAllMeta">
#     <sf:retrieve
#     username="${sf.username}"
#     password="${sf.password}"
#     serverurl="${sf.serverurl}"
#     retrieveTarget="getAllMeta"
#     unpackaged="getAllMeta/package.xml"
#     pollWaitMillis="1000" />
# </target>

# (3) CALL `ant getAllMeta`
