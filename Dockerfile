# ========== Build stage ==========
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj & restore trước để cache
COPY CodeHostingDemo.csproj .
RUN dotnet restore

# copy toàn bộ và publish
COPY . .
RUN dotnet publish -c Release -o /app/out

# ========== Runtime stage ==========
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .
# Render cấp biến PORT => map vào ASPNETCORE_URLS
ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT}
EXPOSE 10000
CMD ["dotnet", "CodeHostingDemo.dll"]
