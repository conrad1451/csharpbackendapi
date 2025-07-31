# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["CSharpBackendAPITest/CSharpBackendAPITest.csproj", "CSharpBackendAPITest/"]
# If you have multiple projects in your solution, copy them all and restore
# COPY ["AnotherProject/AnotherProject.csproj", "AnotherProject/"]
RUN dotnet restore "CSharpBackendAPITest/CSharpBackendAPITest.csproj"

COPY . .
WORKDIR "/src/CSharpBackendAPITest"
RUN dotnet build "CSharpBackendAPITest.csproj" -c Release -o /app/build

# Stage 2: Publish the application
FROM build AS publish
RUN dotnet publish "CSharpBackendAPITest.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080 
# Or whatever port your application listens on, often 80/443 in production
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CSharpBackendAPITest.dll"]