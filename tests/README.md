# Run Tests:
```
# Install pyenv:
curl https://pyenv.run | bash

# Set up the venv
pyenv install 3.12
pyenv virtualenv 3.12 neovim-test
pyenv activate neovim-test
python -m pip install --upgrade pip
pip install -r requirements.txt

# Run tests: (Use -s to include output.)
export CONTAINER_GH_TOKEN='...' 
pytest -s
```

## Manual testing:
Before manually testing, run these commands:
```
docker rmi travisdart/nvchad-neovim:latest
export GH_TOKEN="..."
```

Then, run the examples from the readme.

For each example, first test that autocomplete is working.

Then, (for all except the basic example) make sure these commands work:
* `:!gh auth status`
* `:!git config --global user.email`
* `:!git config --global user.name`

## Todo:

* Reduce repetition in tests
* Integrate a CI solution and separate test tasks from CI tasks.
* Containerize the test runner
