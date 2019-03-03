FROM tiangolo/uwsgi-nginx-flask:python3.7    # Initializes the image build

COPY requirements.txt /app/requirements.txt  # Copy the requirements file from current directory to app directory
WORKDIR /app                                 # Set the current working directory to the app folder
RUN pip install --upgrade pip                # Upgrade pip to latest version
RUN pip install -r /app/requirements.txt     # Install the necessary dependencies in the image
COPY . /app                                  # Copy the files in current directory to the app folder

# Normally we would have something like CMD for flask on this line, 
# but it appears the image we're using already takes care of running the flask app for us 