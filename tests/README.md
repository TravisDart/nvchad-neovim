# Run Tests:
```
# Install pyenv:
curl https://pyenv.run | bash

# Set up the venv
pyenv virtualenv 3 neovim-test
pyenv activate neovim-test
pip install -r requirements.txt

# Run tests:
pytest
```

## Todo:

* Reduce repetition in tests
* Integrate a CI solution and separate test tasks from CI tasks.
* Containerize the test runner
* 