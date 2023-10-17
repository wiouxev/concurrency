# install-module -name Microsoft.Graph.Intune
# install-module -name msgraphfunctions
# install-module -name intunebackupandrestore
get-module
connect-msgraph
get-module
# should show Microsoft.Graph.Intune, intunebackupandrestore
Connect-Graph
start-intunebackup -path C:\users\ID69795\Desktop