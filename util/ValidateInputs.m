function [ ] = ValidateInputs( inputs )
%ValidateInputs Validate Required inputs
%   Required inputs: 
%       * inputs.data
%       * inputs.labels
%       * inputs.rapidPTLibraryPath

    assert(isfield(inputs,'data'), 'Input Error: inputs.data is a required input..');


end

