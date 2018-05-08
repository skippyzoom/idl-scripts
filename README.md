IDL scripts for analyzing EPPIC data. This repository should not contain functions or procedures. Typical types of scripts include, in order of decreasing abstraction,

1) top-level batch scripts that call project-specific scripts within a specified directory either via cd or by declaring a path (e.g., parametric_wave_batch.pro);
2) project scripts that read or declare global variables and call analysis scripts (e.g., parametric_wave.pro);
3) scripts for reading, performing analysis, or producing graphics of a specific data quantity (e.g., get_den1_plane.pro, den1_fft_calc.pro, and den1_fft_images.pro); and
4) scripts that load or unload variables into or out of global memory (e.g., import_plane_defaults.pro).

This paradigm strongly discourages calling scripts from within functions or procedures.

Since scripts change often in the course of analyzing a particular data set, commit messages do not need to be as descriptive as usual.