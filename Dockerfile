# ========== Build stage ==========
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# copy csproj & restore (cache)
COPY CodeHostingDemo.csproj .
RUN dotnet restore

# copy toàn bộ và publish
COPY . .
RUN dotnet publish -c Release -o /app/out

# ========== Runtime stage ==========
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .
ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT}
EXPOSE 10000
CMD ["dotnet", "CodeHostingDemo.dll"]
