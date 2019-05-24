## Dakota in Docker

[![Build Status](https://travis-ci.com/evanchodora/dakota-docker.svg?branch=master)](https://travis-ci.com/evanchodora/dakota-docker)

A Dockerfile to build a self-contained Dakota environment with all dependencies. Built using the latest version of Dakota (currently 6.10).

Simpl build using `docker build -t dakota .` and run with `docker run -it --rm -v $WORK_DIR:/src dakota -i $DAKOTA_INPUT_FILE` 

### About Dakota

The Dakota project delivers both state-of-the-art research and robust, usable software for optimization and UQ. Broadly, the Dakota software's advanced parametric analyses enable design exploration, model calibration, risk analysis, and quantification of margins and uncertainty with computational models. The Dakota toolkit provides a flexible, extensible interface between such simulation codes and its iterative systems analysis methods, which include:

  - optimization with gradient and nongradient-based methods;
  - uncertainty quantification with sampling, reliability, stochastic expansion, and epistemic methods;
  - parameter estimation using nonlinear least squares (deterministic) or Bayesian inference (stochastic); and
  - sensitivity/variance analysis with design of experiments and parameter study methods.

For more information see https://dakota.sandia.gov/
