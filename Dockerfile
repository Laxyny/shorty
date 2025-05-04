# Utilise l'image officielle Crystal
FROM crystallang/crystal:latest

# Dossier de l'application
WORKDIR /app

# Copie les fichiers
COPY shard.yml ./
COPY src ./src

# Installe les dépendances
RUN shards install

# Compile l'application
RUN crystal build src/shorty.cr --release -o shorty

# Port d'écoute
EXPOSE 3000

# Commande de démarrage
CMD ["./shorty"]