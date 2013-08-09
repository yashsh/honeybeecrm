# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CRMApp::Application.initialize!

# Apply patch for date and date input to save in model - datetime fields
require "column_patch"
