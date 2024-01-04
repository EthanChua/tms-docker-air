# Use an existing image as a base
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy packed tgz file to working directory
COPY dependencies1.0.0.tgz ./

# Install the dependencies from packed tgz file
RUN npm install dependencies1.0.0.tgz

# Copy the rest of the code from src directory to working directory
COPY . .

# Check that orginal package.json with the package.json from tgz file, exit if they are different
RUN diff package.json node_modules/dependencies/package.json || exit 1

# replace root package.json with the one from tgz file
RUN rm package.json
RUN mv node_modules/dependencies/package.json ./

# move node_modules from nested folder generated by tgz to working directory
RUN mv node_modules/dependencies/node_modules/* node_modules
RUN rm -r node_modules/dependencies

# remove unnecessary files
RUN rm dependencies1.0.0.tgz
RUN rm.dockerignore

#  Create non-root user
RUN adduser -u 1001 -D defaultuser
USER defaultuser

# Expose the port that the app listens on
EXPOSE 3000

# Define the command to run the app
CMD ["node", "app.js"]
