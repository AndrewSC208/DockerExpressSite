1. DOCKER MACHINE: I am not sure if I need this for linux, but it's good to know about it. 

note: docker on linux is the defult machine, and this is how I will integrate with AWS, using the aws machine driver.

	A. commands: docker-machine -> for help
	
		1. docker-machine ls           : displays a list of docker machines
		2. docker-machine start  [name]
		3. docker-machine stop 	 [name]
		4. docker-machine env 	 [name]: setup up a new terminal that is not connected, if you are running on linux this is already handeled
		5. docker-machine ip 	 [name]
		6. docker-machine status [name]


2. DOCKER CLIENT: Tool that interacts with the docker deamon
MAIN USES:
	A. Interact with docker engine
	B. Build and Manage Images
	C. Run and Manage Containers


MAIN COMMANDS:
	1. docker pull    [image name]     :get images
	2. docker run     [image name]     :run image
	3. docker run -d -p 80:80 [image name]: run image on specificed port {external:internal}
	3. docker stop [running container id to kill]
	3. docker images: lists all the images that are available
	4. docker rmi 	  [image id to remove]
	4. docker ps:     only shows the running containers
	5. docker ps -a:  show all available containers
	6. docker network ls
	7. docker network inspect [network_name]
	8. docker image inspect [image_name]


3. HOOKING SOURCE CODE INTO DOCKER WITH VOLUMS:

	HOW DO YOU GET YOUR SOURCE CODE INTO A CONTAINER?
		ANSWERS:
		1. CREATE A CONTAINER VOLUME THAT POINTS TO THE SOURCE CODE.
		2. ADD YOUR SOURCE CODE INTO A CUSTOM IMAGE THAT IS USED TO CREATE CONTAINER.
	
	layered volumn system
		A. Image is a set of read only layers
		B. Container is a set of read/write layer
		
		DIFFERENCE: Image has read r/o and container has r/w
		
		C. Volumes: 
			- Special type of directory in a container typically referred to as a "data volumne"
			- Can share and reuse among containers
			- Updated to an image won't affect a data volume
			- Data volumes are persisted even after the container is deleted

			CMD: point container to data volume:
									
									Container Volume
										   ^
										   |
			docker run -p 8080:3000 -v /var/www node
									 |
									 V
							  Create a volume
			
			SETUP:
				docker inspect "mycontainer"
				returns:
				"Mounts": [
					{	"Name": "jfklsfds",
						"Source": "/mnt/.../var/lib/docker/_data",
						"Destation": "/var/www",
						"Driver": "local",
						"RW": true
					}
				]


			CUSTOMIZING VOLUMES:

							
							  Port's   Host location	
								|			  ^
								V             |			
				docker run -p 8080:3000 -v $(pwd):/var/www node	
										 |				\
										 V               > container volume
								 Create a Volumne

			
				docker inspeact mycontainer
				returns:
				"Mounts": [
					{	"Name": "jfklsfds",
						"Source": "/src",
						"Destation": "/var/www",
						"Driver": "local",
						"RW": true
					}
				]
				
		EXAMPLE: Hooking a volume to Node.js source code:
		
													
												working dir
		                                            |                            
		docker run -p 8080:3000 -v $(pwd):/var/www -w "/var/www" node npm start
															|
														Location of 

		CLEAN UP VOLUMN:
			docker inspeact "container name"
			docker rm -v "lastcontainer"
			

4. BUILDING CUSTOM IMAGES W/DOCKERFILE

	A. Getting started with dockerfile: Text file with instructions to build image
		KEY DOCKER INSTRUCTIONS:
		
			FROM 'image'
			MAINTEINER
			RUN 
			COPY
			ENTRYPOINT
			WORKING
			EXPOSE 
			ENV
			VOLUME

		EXAMPLE:

		FROM node
		MAINTAINER Andrew Meiling
		COPY ./var/www
		WORKINGDIR /var/www
		RUN npm install
		EXPOSE 8080
		ENTRYPOINT ["node","server.js"]

		EXAMPLE: Create a custom Node.js Dockerfile
			1. MAKE DOCKER FILE: Look at the dockerfile in project folder
			2. BUILD A NODE.JS IMAGE: 

				docker build --tag <username>/<imageName> .
					--tag, -t: tag name
						   -f: name of dockerfile, Dockerfile is the default
				
				docker build -f "nameoftime" -t <username>/node .

	B. PUBLISH A DOCKER IMAGE:

		docker push <you username>/node

5. COMMUNICATING BETWEEN DOCKER CONTAINERS:
	
	A. Getting started with container linking:
		- Legacy Linking: Uses names, good for easy setup.
		- Custom Bridge Network: This is good, and the most advanced.

	B. LEGACY LINKING:

		STEPS/COMMANDS: 
			1. Run a container with a name
				- docker run -d --name my-postgres postgres
								[name]      [name]:[alias]
			2. Link to running container by name
				- dockr run -d -p 5000:5000 --link my-postgres:postgres andrew/aspnetcore
				                            [link]      [name]:[alias]	
			3. Repeat for Additional Containers


		EXAMPLE: Linking Node.js and MongoDB Containers:
			See docker file in project for linking steps

	C. CONTAINER NETWORKS/BRIDGE NETWORKS:
		
		STEPS/COMMANDS:
			1. Create a custom bridge network:

												  [name of custom network]
															 |
															 V
				docker network create --driver bridge isolated_network
								  A               A
								  |				  |
					[create custom network]	[use a bridge network]


			2. Run Containers in the isolated network:

								    			["Link" to this container by name]
								    							A
																|
				docker run -d --net=isolated_network --name mongodb mongo
								|
								V
					[Run container in network]


6. MANAGING CONTAINERS WITH DOCKER COMPOSE:
	
	A. Getting started with docker compose: manage application lifecycle.

		- start, stop and rebuild services
		- view the status of running services
		- stream the log output of running services
		- run a one-off command on a service

		WORKFLOW: build services, stat up services, tear down services
		

	B. The docker-compse.yml file: (service configuration)
		Example:

		version: '2'

		services:
			node:
				build:
					context:.
					dockerfile: node.dockerfile
				networks:
					-nodeapp-network

			mongodb:
				image: mongo
				networks:
					-nodeapp-network

		networks:
			nodeapp-network
				driver: bridge
	
		build
		environment
		image
		network
		ports
		volumes

	C. Docker compose commands
		docker-compose build
		docker-compose up
		docker-compose down
		docker-compose logs
		docker-compose ps
		docker-compose stop
		docker-compose start
		docker-compose rm
		
	D. Docker compose in action
		see file

		WELL IT LOOKS LIKE THIS PART CHANGED SO I THINK A GOOD PLACE TO START IS TO GET EACH MAJOR PEICE SETUP INDIVIDUALLY, AND THEN FOCUS ON TYING THEM ALL UP LATER FOR DEPLOYMENT!

		NOW THAT I THINK ABOUT IT MIGHT BE A GOOD IDEA TO BUILD THE PRODUCTION ENVIRONMENT WITH THIS SYSTEM. THEN LATER I WONT HAVE TO WORRY ABOUT IT.

	E. Setting up development environment services
	F. Create a custom docker-compose.yml file
	G. Managing development evironment services





// == ##### ALL COMMANDS ##### == //

Management Commands:
  container   Manage containers
  image       Manage images
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  volume      Manage volumes

Commands:
  attach      Attach to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes



