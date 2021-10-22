FROM python:slim-buster
WORKDIR /app
COPY src .
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install -r requirements.txt
CMD ["python3", "-m", "ankisyncd"]