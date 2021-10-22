FROM python:3.8.12-slim-buster
WORKDIR /app
COPY SRC/* ./
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install -r requirements.txt
CMD ["python", "-m", "ankisyncd"]