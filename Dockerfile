FROM python:3.9.6-alpine3.14
WORKDIR /app
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev
RUN python -m pip install --upgrade pip
COPY /api/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY api .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--workers", "4"]
RUN apk del .build-deps