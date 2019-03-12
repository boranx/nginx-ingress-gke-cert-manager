FROM python:3.6-alpine
COPY . /app
WORKDIR /app
RUN pip3 install flask
ENTRYPOINT ["python3"]
CMD ["main.py"]