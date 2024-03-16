FROM python:3.8-alpine
RUN apk  add build-base \
    && apk cache clean
WORKDIR /app
COPY ./requirements.txt /app
RUN pip freeze
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5000
ENV FLASK_APP=hello/app.py
CMD ["flask", "run", "--host", "0.0.0.0"]
