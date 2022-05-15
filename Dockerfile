FROM node:alpine as web
WORKDIR /web
COPY ./web/package*.json ./
RUN npm ci
COPY ./web/ ./
RUN npm run build

ENV CELERY_BROKER_URL="amqp://frosty-bouman:Gs2CLP65kBuPAs9YxfAZ@awesome-boyd.internal.100do.se:5672/frosty-bouman"
ENV S3_ENDPOINT_URL="https://s3.100do.se"
ENV AWS_ACCESS_KEY_ID="frosty-bouman"
ENV AWS_SECRET_ACCESS_KEY="j15,8IhlGOUbIp05wa6U"
ENV S3_BUCKET_NAME="frosty-bouman"
CMD ["npm", "run", "start"]
EXPOSE 3000


FROM python:3.10 as py
WORKDIR /api
COPY ./api ./
RUN pip install .
ENV CELERY_BROKER_URL="amqp://frosty-bouman:Gs2CLP65kBuPAs9YxfAZ@awesome-boyd.internal.100do.se:5672/frosty-bouman"
ENV S3_ENDPOINT_URL="https://s3.100do.se"
ENV AWS_ACCESS_KEY_ID="frosty-bouman"
ENV AWS_SECRET_ACCESS_KEY="j15,8IhlGOUbIp05wa6U"
ENV S3_BUCKET_NAME="frosty-bouman"


FROM py AS backend
RUN pip install gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "image_api.web:app"]
EXPOSE 8080


FROM py AS worker
CMD ["celery", "--app", "image_api.worker.app", "worker"]
