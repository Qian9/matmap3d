function [x,y,z] = ecef2eci(utc, x0, y0, z0)
% rotate ECEF coordinates to ECI
% because this doesn't account for nutation, etc. error is often > 1%
%
% x0, y0, z0:  ECEF position (meters)
% utc: time UTC

% x,y,z:  ECI position
arguments
  utc (:,1) datetime
  x0 (:,1) {mustBeNumeric,mustBeReal,mustBeEqualSize(utc,x0)}
  y0 (:,1) {mustBeNumeric,mustBeReal,mustBeEqualSize(utc,y0)}
  z0 (:,1) {mustBeNumeric,mustBeReal,mustBeEqualSize(utc,z0)}
end
%% Greenwich hour angles (radians)
gst = matmap3d.greenwichsrt(juliandate(utc));
%% Convert into ECEF
x = nan(size(gst));
y = nan(size(x));
z = nan(size(x));

for j = 1:length(x)
  eci = matmap3d.R3(gst(j)).' * [x0(j), y0(j), z0(j)].';
  x(j) = eci(1);
  y(j) = eci(2);
  z(j) = eci(3);
end
end % function

function mustBeEqualSize(a,b)
assert(isequal(size(a),size(b)), 'Size of inputs must equal each other')
end
