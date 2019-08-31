FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["HelloK8s.csproj", "./"]
RUN dotnet restore "./HelloK8s.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloK8s.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "HelloK8s.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloK8s.dll"]
