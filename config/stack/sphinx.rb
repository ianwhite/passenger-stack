package :sphinx_mysql, :provides => :sphinx do
  description 'Sphinx with mysql'
  version "0.9.8.1"
  
  source "http://www.sphinxsearch.com/downloads/sphinx-#{version}.tar.gz", :with => [:mysql]
  
  verify do
    has_executable "searchd"
  end
end

package :sphinx_postgresql, :provides => :sphinx do
  description 'Sphinx with postgresql'
  version "0.9.8.1"
  
  source "http://www.sphinxsearch.com/downloads/sphinx-#{version}.tar.gz", :with => [:pgsql], :without => [:mysql]
  
  verify do
    has_executable "searchd"
  end
end
