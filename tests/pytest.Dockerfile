FROM python:3.10-alpine

RUN apk add --no-cache tmux docker bash \
    --update

# Copy your test files to the container and switch to that directory.
RUN mkdir "/tests"
COPY ./tests /tests
WORKDIR /tests

# Install required packages.
# (The tests directory copied above contains requirements.txt.) 
RUN pip install -r /tests/requirements.txt

# Run pytest
CMD ["pytest"]
