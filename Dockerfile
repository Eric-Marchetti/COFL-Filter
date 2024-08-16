FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
WORKDIR /build
ADD https://api.github.com/repos/Eric-Marchetti/COFL/git/refs/heads/main version.json
RUN git clone --depth=1 https://github.com/Eric-Marchetti/COFL.git dev
RUN ls -l dev
WORKDIR /build/sky
COPY SkyFilter.csproj SkyFilter.csproj
RUN dotnet restore
COPY . .
RUN dotnet publish -c release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app .
RUN mkdir -p ah/files

ENV ASPNETCORE_URLS=http://+:8000

USER app

ENTRYPOINT ["dotnet", "SkyFilter.dll", "--hostBuilder:reloadConfigOnChange=false"]

VOLUME /data

