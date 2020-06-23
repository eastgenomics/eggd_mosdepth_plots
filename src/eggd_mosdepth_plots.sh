#!/bin/bash
# eggd_mosdepth_plots 1.0.0

main() {

    # temp download directory
    mkdir input && cd input

    # download input files from file:array
    for i in ${!dist[@]}
    do
        dx download "${dist[$i]}" 
    done
    
    # run plot script
    echo "Generating plots"
    python ~/plot-dist.py ./*dist*

    # if prefix given rename with prefix and upload
    if [[ "$prefix" ]]; then
        mv dist.html "${prefix}.dist.html"
        dist_report=$(dx upload ${prefix}.dist.html --brief)
    else
        dist_report=$(dx upload dist.html --brief)
    fi

    dx-jobutil-add-output dist_report "$dist_report" --class=file

    echo "file(s) uploaded"
}