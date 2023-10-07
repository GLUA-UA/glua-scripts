#
# A Quartus Prime Lite Edition 22.1.2 script builder
# GLUA - Author: Miguel Vila
#

#
# This script generates a Quartus Prime Lite Edition 22.1.2 script
# to a specific linux distribution. It reads all the files from this
# directory and appeds them to the script.
#
# Example: if there is a file called "ubuntu-22.04" in this directory
# the script will append its contents to the template script and generate
# a new one called "quartus-lite-22.1.2-ubuntu-22.04.sh".
#

import os
import sys
import shutil

def main():
    # Get the script path and name
    script_path = os.path.dirname(os.path.realpath(__file__))
    script_name = os.path.basename(__file__)
    generated_path = os.path.join(script_path, "..")
    
    # Get all the files in this directory except this script and template.sh
    files = [f for f in os.listdir(script_path) if os.path.isfile(os.path.join(script_path, f))]
    files.remove(script_name)
    files.remove("template.sh")
    
    # Create a new script for each file
    for file in files:
        file_name = os.path.splitext(file)[0]
        new_script_name = "quartus-lite-22-1-2-" + file_name + ".sh"
        shutil.copyfile(os.path.join(script_path, "template.sh"), os.path.join(generated_path, new_script_name))
        # replace the following string '# {{{## REPLACE BY DISTRO SPECIFIC INSTALL SCRIPT ##}}}' with the contents of the file
        with open(os.path.join(script_path, file), "r") as f:
            file_contents = f.read()
        with open(os.path.join(generated_path, new_script_name), "r") as f:
            script_contents = f.read()
        script_contents = script_contents.replace("# {{{## REPLACE BY DISTRO SPECIFIC INSTALL SCRIPT ##}}}", file_contents)
        with open(os.path.join(generated_path, new_script_name), "w") as f:
            f.write(script_contents)
        # Make the new script executable
        os.chmod(os.path.join(generated_path, new_script_name), 0o755)
        print(new_script_name)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
    except Exception as e:
        print(e)
        sys.exit(1)
    sys.exit(0)