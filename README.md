# Flask Examples

Example applications for Flask beginners.

## Installation

First, you need to clone this repository:

```bash
git clone git@github.com:greyli/flask-examples.git
```

Or:

```bash
git clone https://github.com/helloflask/flask-examples.git
```

Then change into the `flask-examples` folder:

```bash
cd flask-examples
```

Now, we will need to create a virtual environment and install all the dependencies:

```bash
python3 -m venv venv  # on Windows, use "python -m venv venv" instead
. venv/bin/activate   # on Windows, use "venv\Scripts\activate" instead
pip install -r requirements.txt
```

## How to Run a Specific Example Application?

**Before run a specific example application, make sure you have activated the virtual enviroment.**

For example, if you want to run the Hello application, just execute these commands:

```bash
cd hello
flask run
```

Similarly, you can run HTTP application like this:

```bash
cd http
flask run
```

The applications will always running on http://localhost:5000.

Version Control and CI/CD: ```bash
There are three files in the .github folder: codeql.yml, docker-image.yml, and docker-publish.yml. These files are used for continuous integration and continuous deployment (CI/CD) using GitHub Actions.```

Bash Scripting: ```bash
There is a bash script named backup.sh in the root directory. This script is used to create a backup of a specified database. ```

Terraform: ```bash
There is a Terraform file named main.tf in the terraform folder. This file is used to create an EC2 instance with Ubuntu OS on AWS.```

Hosting: ```bash
There is a .conf file named reverse-proxy in the root directory. This file contains the configuration for a reverse proxy.```
