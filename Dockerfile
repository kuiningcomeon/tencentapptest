FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 5008

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["TestMvc.csproj", ""]
RUN dotnet restore "./TestMvc.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TestMvc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestMvc.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestMvc.dll"]