FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs

# Copy csproj and restore as distinct layers
COPY Personal.Web/*.csproj ./Personal.Web/
COPY Personal.Domain/*.csproj ./Personal.Domain/
WORKDIR /app/Personal.Web
RUN dotnet restore

# Copy everything else and build
WORKDIR /app
COPY Personal.Web/. ./Personal.Web
COPY Personal.Domain/. ./Personal.Domain 
WORKDIR /app/Personal.Web
RUN dotnet publish -c Release -o out


FROM node:8 as build-deps
WORKDIR /app
COPY Personal.Web/ClientApp/package.json Personal.Web/ClientApp/yarn.lock ./Personal.Web/ClientApp/
COPY Personal.Web/ClientApp/public/. ./Personal.Web/ClientApp/public/
WORKDIR /app/Personal.Web/ClientApp
RUN yarn

FROM nginx
COPY Nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /app
COPY Personal.Web/ClientApp/build /usr/share/nginx/html
#EXPOSE 5001
CMD ["nginx", "-g", "daemon off;"]


# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/Personal.Web/out .

#ENV ASPNETCORE_URLS http://+:5001
#EXPOSE 5001
ENTRYPOINT ["dotnet", "Personal.Web.dll"]
