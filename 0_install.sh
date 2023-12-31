#!/bin/bash

# chmod +x 1_install_terraform.sh
# chmod +x 2_test_terraform.sh
# chmod +x 3_install_aws_cli.sh
# chmod +x 4_install_other.sh

# ./1_install_terraform.sh
# ./2_test_terraform.sh
# ./3_install_aws_cli.sh
# ./4_install_other.sh



# iterate alphabetically through the install_scripts/ directory and run each script
for script in install_scripts/*.sh; do
    chmod +x $script
    ./$script
done


exec $SHELL