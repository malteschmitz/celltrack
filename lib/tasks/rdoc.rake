RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = Rails.root.join('doc', 'app').to_path
  rdoc.rdoc_files.include('README.rdoc', 'app/**/*.rb', 'lib/*.rb')
  rdoc.title = 'Celltrack Documentation'
  rdoc.options << '--all' 
end