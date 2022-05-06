FROM node:alpine as web
WORKDIR /web
COPY ./web/package*.json ./
RUN npm ci
COPY ./web/ ./
RUN npm run build
CMD ["npm", "run", "start"]
EXPOSE 3000


FROM python:3.10 as py
WORKDIR /api
COPY ./api ./
RUN pip install


FROM py AS backend
RUN pip install gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "image_api.web:app"]


FROM py AS worker
CMD ["celery", "worker",  "--app", "image_api.worker.app"]