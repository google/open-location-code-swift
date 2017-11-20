Pod::Spec.new do |s|

  s.name         = "OpenLocationCodeFramework"
  s.module_name  = "OpenLocationCode"
  s.version      = "2.0.1"
  s.summary      = "Open Location Code conversion library for Swift and Objective-C"

  s.description  = <<-DESC

Open Location Codes are short, 10-11 character codes that can be used
instead of street addresses. The codes can be generated and decoded offline,
and use a reduced character set that minimises the chance of codes including
words.

This Pod supports Swift and Objective-C projects on iOS, macOS, tvOS, 
and watchOS.

                   DESC

  s.homepage     = "http://openlocationcode.com"
  s.license      = "Apache License, Version 2.0"
  s.authors      = { "William Denniss" => "wdenniss@google.com",
                   }

  s.platforms    = { :ios => "8.0", :osx => "10.9", :watchos => "2.0", :tvos => "9.0" }

  s.source       = { :git => "https://github.com/google/open-location-code-swift.git", :tag => s.version }

  s.pod_target_xcconfig = {
    # Set the Swift version to match .swift-version
    'SWIFT_VERSION' => '4.0',
    # Treat warnings as errors.
    'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES',
  }

  s.source_files = "Source/*.swift"
  s.requires_arc = true
end
