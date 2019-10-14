JRUBY_POI_LIB_PATH=File.expand_path(File.dirname(__FILE__))

require File.join(JRUBY_POI_LIB_PATH, 'poi', 'version')

# Java
require 'java'
require File.join(JRUBY_POI_LIB_PATH, 'jruby-poi_jars')

# Ruby
require File.join(JRUBY_POI_LIB_PATH, 'poi', 'version')
require File.join(JRUBY_POI_LIB_PATH, 'poi', 'workbook')
require 'date' # required for Date.parse
