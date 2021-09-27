FROM python:3.8.12-slim-buster
WORKDIR /anki
COPY . .
RUN pip3 install -r requirements.txt
CMD ["python3", "-m", "ankisyncd"]