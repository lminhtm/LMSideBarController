Pod::Spec.new do |s|

  s.name             = "LMSideBarController"
  s.version          = "1.0.1"
  s.summary          = "LMSideBarController is a simple side bar controller inspired by Tappy"
  s.homepage         = "https://github.com/lminhtm/LMSideBarController"
  s.license          = 'MIT'
  s.author           = { "LMinh" => "lminhtm@gmail.com" }
  s.source           = { :git => "https://github.com/lminhtm/LMSideBarController.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'LMSideBarController/**/*.{h,m}'

end
