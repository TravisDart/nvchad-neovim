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

## Todo:

* Reduce repetition in tests
* Integrate a CI solution and separate test tasks from CI tasks.
* Containerize the test runner
