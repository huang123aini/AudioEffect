
Pod::Spec.new do |s|
  s.name             = 'TXTAudioEffects'
  s.version          = '0.1.0'
  s.summary          = 'Audio effects'
  s.homepage         = 'http://local/TXTAudioEffects'
  s.license          = 'MIT'
  s.author           = { 'huangshiping' => 'aiya123aini@163.com' }
  s.source           = {:git => 'https://github.com/huangshiping/TXTAudioEffects.git', :tag => s.version}
  s.ios.deployment_target = '9.0'

  s.source_files = 'TXTAudioEffects/Classes/*.{h,m}',
                   'TXTAudioEffects/Classes/audioeffects/sonic/sonic.{h,m}',
                   'TXTAudioEffects/Classes/audioeffects/reverb/reverb.{h,m}',
                   'TXTAudioEffects/Classes/audioeffects/biquad/*.{h,m}',
                   'TXTAudioEffects/Classes/audioeffects/vibrato/*.{h,m,mm}'

end
