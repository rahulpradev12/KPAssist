
Pod::Spec.new do |spec|


  spec.name         = "KPAssist"
  spec.version      = "0.0.2"
  spec.summary      = "KPAssist is used to provide support to users through speech assistance for frequently used actions."

  spec.description  = <<-DESC
                     This module is going to play role of voice assistant in the apps. Model will be trained as deep the requirements are added.
                   DESC

  spec.homepage     = "https://github.com/rahulpradev12/KPAssist"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Rahul Pradev R" => "rahulpr@deloitte.com" }
  

  spec.platform     = :ios
  
  spec.ios.deployment_target = "12.0"
  spec.swift_version = "4.2"


  spec.source       = { :git => "https://github.com/rahulpradev12/KPAssist.git", :tag => "#{spec.version}" }

  spec.source_files  = "KPAssist/Classes/**/*.{swift}"

  spec.resource_bundles = { 'KPAssist' => 'KPAssist/Resources/*.{mlmodel}' }
  

end
