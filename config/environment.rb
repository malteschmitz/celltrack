# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Celltrack::Application.initialize!

# set global paths
PICTURE_ROOT = Rails.root.join('public', 'experiments')
IMPORT_ROOT = Rails.root.join('import')