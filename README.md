# StopWindowsService
Example of how we can start/stop windows service like we do in Azure Dev Ops.
To run this it must be self-hosted

````YML
on: [push]

jobs:
  Deploy:
    runs-on: [self-hosted, windows]
    name: Deploy Kerberos Servers
    steps:
      - name: Stop Windows Service
        uses: jhyderjhyder/PowershellStopWindowsService@v0.3
        with:
          WINDOWSSERVICE_NAME: 'tomcat*'
          SERVICE_ACCOUNT: ${{ secrets.SERVICE_ACCOUNT }}
          SERVICE_PASSWORD: ${{ secrets.SERVICE_PASSWORD }}
          SERVER_NAMES: 'myServer10,myServer12'
````