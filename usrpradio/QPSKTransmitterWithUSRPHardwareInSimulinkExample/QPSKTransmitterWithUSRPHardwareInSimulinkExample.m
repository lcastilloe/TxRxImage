%% QPSK Transmitter with USRP Hardware in Simulink
% This model shows how to use the Universal Software Radio Peripheral(TM)
% (USRP) device with Simulink(R) to implement a QPSK transmitter. The USRP
% device in this model will keep transmitting indexed 'Hello world'
% messages at its specified center frequency and at bit rate of 1Mbps. You
% can demodulate the transmitted message using the
% <docid:usrpradio_ug#example-sdruqpskrx QPSK Receiver with USRP Hardware in Simulink>
% example with an additional USRP device.
%
% In order to run this model, you need to ensure that the specified center
% frequency of the SDRu Transmitter is within the acceptable range of your
% USRP daughterboard.

% Copyright 2011-2023 The MathWorks, Inc.

%% Required Hardware and Software
% To run this example, you will need one of the following hardware and
% the corresponding software support package.
% 
% * 200-Series USRP Radio and
% <https://www.mathworks.com/hardware-support/usrp.html _Communications
% Toolbox Support Package for USRP Radio_>. For information on how to map
% an NI(TM) USRP device to an Ettus Research(TM) 200-series USRP device,
% see <docid:usrpradio_ug#buzc7a6-1 _Supported Hardware and Required
% Software_>.
% * 300-Series USRP Radio and
% <https://www.mathworks.com/hardware-support/ni-usrp-radios.html _Wireless
% Testbench Support Package for NI USRP Radios_>. For information on how to
% map an NI USRP device to an Ettus Research 300-series USRP device, see
% <docid:wt_gs#mw_74eb94c7-dcbc-40dc-8a56-cc7bc0124002 _Supported Radio
% Devices_>.
%% Structure of the Example
% The top-level structure of the model is shown in the following figure:
modelname = 'sdruqpsktx';
open_system(modelname);
set_param(modelname, 'SimulationCommand', 'update')

%%
% The transmitter includes the *Bit Generation* subsystem, the *QPSK
% Modulator* block, and the *Raised Cosine Transmit Filter* block. The *Bit
% Generation* subsystem uses a MATLAB workspace variable as the payload of
% a frame, as shown in the figure below. Each frame contains 100 'Hello
% world ###' messages and a header. The first 26 bits are header bits, a
% 13-bit Barker code that has been oversampled by two. The Barker code is 
% oversampled by two in order to generate precisely 13 QPSK symbols for 
% later use in the *Data Decoding* subsystem of the receiver model. The remaining 
% bits are the payload. The payload correspond to the ASCII representation of
% 'Hello world ###', where '###' is a repeating sequence of '000', '001',
% '002', ..., '099'. The payload is scrambled to guarantee a balanced 
% distribution of zeros and ones for the timing recovery operation in 
% the receiver model. The scrambled bits are modulated by the 
% *QPSK Modulator* (with Gray mapping). The modulated symbols are upsampled 
% by two by the *Raised Cosine Transmit Filter* with a roll-off factor 0.5. 
% The output rate of the *Raised Cosine Filter* is set to be 400k samples/second 
% with a symbol rate of 200k symbols per second. Please match the symbol
% rate of the transmitter model and the receiver model correspondingly.

open_system([modelname '/Bit Generation']);

%% Running the Example
% Before running the model, first turn on the USRP and connect it to the
% computer. Set the _Center frequency_ parameter of the *SDRu Transmitter*
% block and run the model. You can run the
% <matlab:openExample('usrpradio/QPSKReceiverWithUSRPHardwareInSimulinkExample','supportingFile','sdruqpskrx.slx')
% QPSK Receiver with USRP Hardware> model with an additional USRP device to
% receive
% the transmitted signal.
close_system([modelname '/Bit Generation']);
close_system(modelname, 0);

%% Exploring the Example
% Due to hardware variations among the USRP boards, a frequency offset 
% will likely exist between the USRP transmitter hardware and the USRP
% receiver hardware. In that case, perform a manual frequency calibration 
% using the companion frequency offset calibration 
% <matlab:openExample('usrpradio/FrequencyOffsetCalibrationUSRPHardwareSimulinkExample','supportingFile','sdrufreqcalib.slx') transmitter> and 
% <matlab:openExample('usrpradio/FrequencyOffsetCalibrationUSRPHardwareSimulinkExample','supportingFile','sdrufreqcalib_rx.slx') receiver> models and examine the resulting behavior.
% 
% Since the gain behavior of different USRP daughter boards also varies
% considerably, the default gain setting in the transmitter and receiver 
% models may not be well-suited for your daughter boards. If the message is
% not properly decoded by the receiver model, you can vary the gain of the 
% source signals in the *SDRu Transmitter* block of this model, and that of
% the *SDRu Receiver* block in the receiver model.
