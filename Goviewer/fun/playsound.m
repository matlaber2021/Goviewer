function playsound(cases)

h = timerfind('Tag','sound');
delete(h);

switch cases
  case {'deadstoneless'}
    filename = 'sound\deadstoneless.wav';
  case {'deadstonemore'}
    filename = 'sound\deadstonemore.wav';
  case {'move'}
    filename = 'sound\move.wav';
end
[data,fs]=audioread(filename);
obj = timer('TimerFcn',@playsound_callback,'Tag','sound');
obj.start();

  function playsound_callback(h,e)
    sound(data,fs);
  end

end