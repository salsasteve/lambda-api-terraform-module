#!/bin/bash -e

# Create lambda_pkg_$random_string/ that will be zipped and contain all the python packages for lambda 
cd $path_cwd
echo "path_cwd" $path_cwd
dir_name=lambda_pkg/
rm -rf $dir_name
mkdir -p $dir_name
echo "dir_name" $dir_name

# Virtual env setup
echo "runtime" $runtime
virtualenv -p $runtime env-$function_name
source env-$function_name/bin/activate

# Create absolute path to lambda source code
echo "source_code_path" $source_code_paths
source_code_path=$path_cwd/$source_code_path
echo "source_code_path" $source_code_path 
# Installing python dependencies into virtualenv
FILE=$source_code_path/requirements.txt
if [ -f $FILE ]; then
  echo "requirements.txt file exists in source_code_path. Installing dependencies.."
  pip3 install -q -r $FILE --upgrade
else
  echo "requirements.txt file does not exist. Skipping installation of dependencies."
fi

# Deactivate virtualenv
deactivate

# Creating deployment package
cd env-$function_name/lib/$runtime/site-packages/
echo "path_cwd/dir_name" $path_cwd/$dir_name
echo "source_code_path/" $source_code_path
ls -la $source_code_path
echo "path_cwd/dir_name" $path_cwd/$dir_name
ls -la $path_cwd/$dir_name

# Recursive copy of the entire site-packages directory to the lambda_pkg_$random_string directory
cp -r . $path_cwd/$dir_name   
# Recursive copy everything in the ~/lambda directory to the lambda_pkg_$random_string directory
cp -R $source_code_path/. $path_cwd/$dir_name/
ls -la $path_cwd/$dir_name

# Removing virtual env folder
cd $path_cwd
echo "path_cwd" $path_cwd
ls -la
rm -rf env-$function_name/