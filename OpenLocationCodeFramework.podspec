Pod::Spec.new do |s|

  s.name         = "OpenLocationCodeFramework"
  s.module_name  = "OpenLocationCode"
  s.version      = "3.0.0"
  s.summary      = "Open Location Code conversion library for Swift and Objective-C"

  s.description  = <<-DESC

Open Location Codes are short, 10-11 character codes that can be used
instead of street addresses. The codes can be generated and decoded offline,
and use a reduced character set that minimises the chance of codes including
words.

This Pod supports Swift and Objective-C projects on iOS, macOS, tvOS,
watchOS, and visionOS.

                   DESC

  s.homepage     = "https://plus.codes"
  s.license      = { :type => "Apache-2.0", :file => "LICENSE" }
  s.authors      = { "William Denniss" => "wdenniss@google.com" }

  s.ios.deployment_target      = "12.0"
  s.osx.deployment_target      = "10.13"
  s.tvos.deployment_target     = "12.0"
  s.watchos.deployment_target  = "4.0"
  s.visionos.deployment_target = "1.0" if s.respond_to?(:visionos)

  s.source       = { :git => "https://github.com/google/open-location-code-swift.git", :tag => s.version.to_s }

  s.pod_target_xcconfig = {
    # Treat warnings as errors.
    'GCC_TREAT_WARNINGS_AS_ERRORS' => 'YES',
  }

  s.swift_versions = ['5.0', '6.0']
  s.source_files   = "Source/*.swift"
  s.requires_arc   = true
end
