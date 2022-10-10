notebooks_work_directory = "${CURDIR}/notebooks"
notebook_data_directory = "${CURDIR}/notebooks/data"
image_tag = "jupyter-ds-1.1.0"
image_name = "yp13_notebooks"
container_name = "notebook"

build:
	docker build . \
		--build-arg REQUIREMENTS="requirements.txt" \
		-t ${image_name}:${image_tag} 

run:
	docker run \
		--detach \
		--name ${container_name} \
		--mount type=bind,source="${notebooks_work_directory}",target=/home/dim/work \
		--mount type=bind,source="${notebook_data_directory}",target=/home/dim/work/data \
		-it --rm -p 8888:8888 ${image_name}:${image_tag}
	sleep 10
	docker exec ${container_name} jupyter notebook list
	
stop:
	docker stop ${container_name}

run_on_host:
	jupyter notebook --ip 0.0.0.0 --no-browser notebooks

requirements:
	pip install --no-cache-dir -r requirements.txt
	jupyter contrib nbextension install --user
	jupyter nbextension enable code_prettify/code_prettify 
	jupyter nbextension enable toc2/main
	jupyter nbextension enable collapsible_headings/main
