# Reverse-Proxy-Fivem-Resource
This is an example of a fivem resource for balancing players on proxies. This script saves the player's proxy and changes it every 15 minutes and distributes players across all available proxies.

1. Go to server.cfg and specify ```set reverseproxyPort 30120``` if your proxy port is 30120 otherwise change this value.
2. Open "main.lua" and enter your proxies in the "ProxyList" table (don't forget to remove "1.1.1.1", this is an example).
3. Don't forget to start the script in server.cfg.
