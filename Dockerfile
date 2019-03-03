# Initializes the image build
FROM tiangolo/uwsgi-nginx-flask:python3.7    

# Copy the requirements file from current directory to app directory
COPY requirements.txt /app/requirements.txt  

# Set the current working directory to the app folder
WORKDIR /app  

# Upgrade pip to latest version                               
RUN pip install --upgrade pip   

# Install the necessary dependencies in the image           
RUN pip install -r /app/requirements.txt  
   
# Copy the files in current directory to the app folder
COPY . /app                                  

# Normally we would have something like CMD for flask on this line, 
# but it appears the image we're using already takes care of running the flask app for us 