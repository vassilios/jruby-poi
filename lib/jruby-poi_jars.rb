# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'org/apache/poi/poi/4.1.0/poi-4.1.0.jar'
  require 'org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.jar'
  require 'com/github/virtuald/curvesapi/1.06/curvesapi-1.06.jar'
  require 'commons-codec/commons-codec/1.12/commons-codec-1.12.jar'
  require 'org/apache/commons/commons-collections4/4.3/commons-collections4-4.3.jar'
  require 'org/apache/poi/poi-ooxml-schemas/4.1.0/poi-ooxml-schemas-4.1.0.jar'
  require 'org/apache/xmlbeans/xmlbeans/3.1.0/xmlbeans-3.1.0.jar'
  require 'org/apache/poi/poi-ooxml/4.1.0/poi-ooxml-4.1.0.jar'
  require 'org/apache/commons/commons-compress/1.18/commons-compress-1.18.jar'
end

if defined? Jars
  require_jar 'org.apache.poi', 'poi', '4.1.0'
  require_jar 'org.apache.commons', 'commons-math3', '3.6.1'
  require_jar 'com.github.virtuald', 'curvesapi', '1.06'
  require_jar 'commons-codec', 'commons-codec', '1.12'
  require_jar 'org.apache.commons', 'commons-collections4', '4.3'
  require_jar 'org.apache.poi', 'poi-ooxml-schemas', '4.1.0'
  require_jar 'org.apache.xmlbeans', 'xmlbeans', '3.1.0'
  require_jar 'org.apache.poi', 'poi-ooxml', '4.1.0'
  require_jar 'org.apache.commons', 'commons-compress', '1.18'
end
