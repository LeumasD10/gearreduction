%{
GEAR.M
ANALYZES AN N DIMENSIONAL GEAR REDUCTION TRAIN AND COMPUTES SHEARING STRESS IN ALL N SHAFTS

PARAMETERS:
A:      Vector of all gear radii Ai that interact with gear in previous shaft Bi-1.
        (mm)
B:      Vector of all gear radii Bi that interact with gear in next shaft Ai+1.
        (mm)
T1:     Starting applied torque
        (Nm)
d:      Vector of all Diameters of shafts in mm
L:      Vector of all Lengths of shafts in m
G:      Modulus of rigidity (GPa)


ASSUMPTIONS:
Shafts are all solid, Ideal conditions, Shafts and structures supported 
Extraneous forces and stresses are assumed to be negligible
%}

A   =    [0,10,20,10,15];
B   =    [25,30,30,35,0];
d   =    [15,16,16,17,18];
L   =    [10,10,5,4,5];
T1  =    100;
G   =    77;       %For Steel  

%% Compute torques transferred for each shaft
Gear_ratio = B(1:end-1)./A(2:end);
Torques = [T1];
for i=1:size(Gear_ratio,2)
    Torques = [Torques,Gear_ratio(i)*Torques(i)];
end


%% Compute shearing stresses
d = d/2000; % Convert to mm and radii
tau = (2*Torques)./(pi*(d.^3))*10^-6;

%% Compute angles of twist
% phi = TL/JG
G = G*(10^9);   % Convert to Pa
angles = [0];
e = size(Torques,2);

for i=1:e
    pos = e+1-i;
    J = 0.5*pi*d(pos)^3;
    relative = Torques(pos)*L(pos)/(J*G);
    angles = [angles, angles(end)+relative];
end

%% Display Results
disp(['Stresses as follows in MPa: ' num2str(tau)]);
disp(['Angles as follows in degrees: ' num2str(fliplr(angles(2:end))*180/pi)]);




