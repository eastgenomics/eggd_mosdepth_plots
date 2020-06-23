#!/bin/bash
# eggd_mosdepth_plots 1.0.0

main() {

    # temp download directory
    mkdir input && cd input

    # download input files
    for i in ${!dist[@]}
    do
        dx download "${dist[$i]}" 
    done
    
    # run plot script
    echo "Generating plots"
    python ~/plot-dist.py ./*dist*
            
    if [ $(ls | wc -l) == 2 ]
    # only 1 input & output file => name output input.dist.html
    then
        dist_file=$( ls *dist.txt )
        mv dist.html "${dist_file/txt/html}"
        dist_report=$(dx upload "${dist_file/txt/html}" --brief)
    else
        # could probably have a nice way to name multi file plots
        dist_report=$(dx upload dist.html --brief)
    fi

    dx-jobutil-add-output dist_report "$dist_report" --class=file

    echo "file(s) uploaded"
}