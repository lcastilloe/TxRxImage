function [platform,address] = sdruExampleSetAvailableRadio()
%sdruExampleSetAvailableRadio Find and set available USRP(R) radio
%   [P,A] = sdruExampleSetAvailableRadio searches for available USRP(R)
%   radios and returns the platform, P, and address, A, of the radio. This
%   function also finds SDRu transmitter and receier blocks in the example
%   model and sets the platform and address parameters.

%   Copyright 2014-2021 The MathWorks, Inc.

% Find a USRP(R) radio
[platform,address] = sdruExampleFindRadio();

% Find USRP(R) blocks and set platform and address
txBlocks = find_system(gcs, 'MaskType', 'SDRu Transmitter');
rxBlocks = find_system(gcs, 'MaskType', 'SDRu Receiver');
blocks = [txBlocks rxBlocks];

for p=1:length(blocks)
  set_param(blocks{1}, 'Platform', platform);
  set_param(blocks{1}, 'USRP_ID', address);
end
