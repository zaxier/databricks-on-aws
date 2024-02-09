#!/bin/bash
# iterate alphabetically through the install_scripts/ directory and run each script
for script in install_scripts/*.sh; do
    chmod +x $script
    ./$script
done


exec $SHELL