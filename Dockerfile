FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["aspnetcore_api.csproj", ""]
RUN dotnet restore "./aspnetcore_api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspnetcore_api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspnetcore_api.csproj" -c Release -o /app/publish

# build runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnetcore_api.dll"]