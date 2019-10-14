# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'org/apache/xmlbeans/xmlbeans/2.6.0/xmlbeans-2.6.0.jar'
  require 'org/apache/commons/commons-collections4/4.1/commons-collections4-4.1.jar'
  require 'org/apache/poi/poi-ooxml/3.15/poi-ooxml-3.15.jar'
  require 'org/apache/poi/poi/3.15/poi-3.15.jar'
  require 'commons-codec/commons-codec/1.10/commons-codec-1.10.jar'
  require 'org/apache/poi/poi-ooxml-schemas/3.15/poi-ooxml-schemas-3.15.jar'
  require 'stax/stax-api/1.0.1/stax-api-1.0.1.jar'
  require 'com/github/virtuald/curvesapi/1.04/curvesapi-1.04.jar'
end

if defined? Jars
  require_jar 'org.apache.xmlbeans', 'xmlbeans', '2.6.0'
  require_jar 'org.apache.commons', 'commons-collections4', '4.1'
  require_jar 'org.apache.poi', 'poi-ooxml', '3.15'
  require_jar 'org.apache.poi', 'poi', '3.15'
  require_jar 'commons-codec', 'commons-codec', '1.10'
  require_jar 'org.apache.poi', 'poi-ooxml-schemas', '3.15'
  require_jar 'stax', 'stax-api', '1.0.1'
  require_jar 'com.github.virtuald', 'curvesapi', '1.04'
end
