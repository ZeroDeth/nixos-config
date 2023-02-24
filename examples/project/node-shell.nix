# nix-shell --pure --show-trace node-shell.nix
# nix develop -f node-shell.nix -c fish

/*
How to consume Python modules using pip in a virtual environment like I am used to on other Operating Systems? {#how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems}
https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems-how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems
*/

with import <nixpkgs> { };

let
  pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    pythonPackages.python

    # This execute some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    pythonPackages.venvShellHook

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    # pythonPackages.numpy
    # pythonPackages.requests

    # In this particular example, in order to compile any binary extensions they may
    # require, the Python modules listed in the hypothetical requirements.txt need
    # the following packages to be installed locally:
    # taglib
    # openssl
    # git
    # libxml2
    # libxslt
    # libzip
    # zlib

    nodejs-14_x              #v14.18.3
    yarn                     #1.22.17
    awscli2                  #aws-cli/2.4.9 Python/3.9.10 Linux/5.15.13 source/x86_64.nixos.21 prompt/off
    terraform_0_15           #0.15.5
    terraform-docs
    tflint
    tfsec
    terrascan
    # checkov
    pre-commit
    graphviz
    gawk
  ];

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH

    mkdir -p .nix-node
    export NODE_PATH=$PWD/.nix-node
    export NPM_CONFIG_PREFIX=$PWD/.nix-node
    export PATH=$NODE_PATH/bin:$PATH

    npm install -g aws-cdk       #global not working


    node --version       v14.18.3
    yarn --version       #1.22.17
    npm --version        #6.14.15
    aws --version        #aws-cli/2.4.9
    cdk --version        #2.10.0 (build e5b301f)
    terraform version    #0.15.5
    python --version     #3.9.10
    pip --version        #21.2.4
    yawsso version       #0.7.2

  '';
}
