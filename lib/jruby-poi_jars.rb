# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.jar'
  require 'commons-codec/commons-codec/1.15/commons-codec-1.15.jar'
  require 'org/apache/poi/poi-ooxml/5.2.3/poi-ooxml-5.2.3.jar'
  require 'org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar'
  require 'org/apache/xmlbeans/xmlbeans/5.1.1/xmlbeans-5.1.1.jar'
  require 'org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.jar'
  require 'com/github/virtuald/curvesapi/1.07/curvesapi-1.07.jar'
  require 'org/apache/poi/poi-ooxml-lite/5.2.3/poi-ooxml-lite-5.2.3.jar'
  require 'com/zaxxer/SparseBitSet/1.2/SparseBitSet-1.2.jar'
  require 'org/apache/logging/log4j/log4j-core/2.18.0/log4j-core-2.18.0.jar'
  require 'org/apache/poi/poi/5.2.3/poi-5.2.3.jar'
  require 'commons-io/commons-io/2.11.0/commons-io-2.11.0.jar'
  require 'org/apache/logging/log4j/log4j-api/2.18.0/log4j-api-2.18.0.jar'
end

if defined? Jars
  require_jar 'org.apache.commons', 'commons-math3', '3.6.1'
  require_jar 'commons-codec', 'commons-codec', '1.15'
  require_jar 'org.apache.poi', 'poi-ooxml', '5.2.3'
  require_jar 'org.apache.commons', 'commons-compress', '1.21'
  require_jar 'org.apache.xmlbeans', 'xmlbeans', '5.1.1'
  require_jar 'org.apache.commons', 'commons-collections4', '4.4'
  require_jar 'com.github.virtuald', 'curvesapi', '1.07'
  require_jar 'org.apache.poi', 'poi-ooxml-lite', '5.2.3'
  require_jar 'com.zaxxer', 'SparseBitSet', '1.2'
  require_jar 'org.apache.logging.log4j', 'log4j-core', '2.18.0'
  require_jar 'org.apache.poi', 'poi', '5.2.3'
  require_jar 'commons-io', 'commons-io', '2.11.0'
  require_jar 'org.apache.logging.log4j', 'log4j-api', '2.18.0'
end
