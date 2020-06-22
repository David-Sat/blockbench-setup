# Setup Hyperledger Fabric for BlockBench
## Execute Installation Script
```
chmod +x hfsetup.sh
./hfsetup.sh
```
### Add Environment Variables

```
nano ~/.profile
```
Add this to `~/.profile`:
```
export PATH=$HOME/fabric-samples/bin:$PATH
export GOROOT=/usr/local/go
export GOPATH=$HOME/blockbench
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```
Update environment variables with:
```
source ~/.profile
```
### Manage Docker as non-root 
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

### Fix missing folder permissions
Check permissions:
```
ls -la ~
```
Give permissions:
```
sudo chown -R $USER:$USER fabric-samples/
ls -la ~
```
