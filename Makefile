install:
	pip install --upgrade pip
	pip install -r requirements.txt

train:
	python3 train.py

eval:
	echo "## Model Metrics" > report.md
	cat results/metrics.txt >> report.md
	echo "\n## Confusion Matrix Plot" >> report.md
	echo "![Confusion Matrix](./results/model_results.png)" >> report.md
	cml comment create report.md

update-branch:
	git config --global user.name "arjunv112"
	git config --global user.email "e0223017@sriher.edu.in"
	git add model results
	git commit -m "Update model and results"
	git push --force origin HEAD:update

hf-login:
	git pull origin update || true
	git switch update || true
	pip install -U "huggingface_hub[cli]"
	hf auth login --token $(HF_TOKEN) --add-to-git-credential

push-hub:
	# Added '.' to specify uploading to the root directory
	hf upload arjun122/mlcloud ./app . --repo-type=space --commit-message="Sync App files"
	hf upload arjun122/mlcloud ./model . --repo-type=space --commit-message="Sync Model"
	hf upload arjun122/mlcloud ./results . --repo-type=space --commit-message="Sync Results"

deploy:
	make hf-login
	make push-hub
