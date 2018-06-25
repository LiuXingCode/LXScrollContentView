

Pod::Spec.new do |s|
    s.name         = 'LXScrollContentView'
    s.version      = '1.5'
    s.summary      = 'A similar to the NetEase news home left and right to switch the scroll frame'
    s.homepage     = 'https://github.com/LiuXingCode/LXScrollContentView'
    s.license      = 'MIT'
    s.authors      = {'xing.liu' => 'liuxinghenau@163.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/LiuXingCode/LXScrollContentView.git', :tag => s.version}
    s.source_files = 'LXScrollContentViewLib/**/*.{h,m}'
    s.requires_arc = true
end

