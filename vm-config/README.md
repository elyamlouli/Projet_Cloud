# Lancer les conteneurs
```
docker run -it --rm -d -p 8081:3000 ghcr.io/ryusan49/projet-cloud-frontend:1.0
docker run -it --rm -d -p 8080:8080 ghcr.io/ryusan49/projet-cloud-backend:1.0
docker run -it --rm -d ghcr.io/ryusan49/projet-cloud-worker:1.0
```

