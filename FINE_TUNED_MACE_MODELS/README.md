Each sub directory contains the fine tuned MACE model (named MACE_model_swa.model)
and the training set file in the ASE traj format.

The extxyz format can be obtained with

> ase convert TRAIN.traj TRAIN.extxyz

The directory GENERAL contains the general model, i.e. the model trained on the joined training set of each molecular crystal
