function ScanShotCallback(h,e)
%

fig=ancestor(h,'figure');
obj=GoPrinter(fig);
CaptureScreen(obj);
