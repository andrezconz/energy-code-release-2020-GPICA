#!/bin/bash

# Comentamos lo que requiere datos que no tenemos
# Rscript 1_take_draws.R
# $STATA_PATH -b do 2_plot_damage_function_fig_3.do

# Vamos directo a lo que genera el insumo para el SCC
STATA_PATH="/Applications/Stata/StataSE.app/Contents/MacOS/stata-se"
$STATA_PATH -b do 3_run_damage_functions.do
