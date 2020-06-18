# Setup BlockBench
## Execute Installation Script
```
chmod +x bbsetup.sh
sudo ./bbsetup.sh
```

### Fix missing folder permissions
Check permissions:
```
ls -la ~
```
Give permissions:
```
sudo chown -R $USER:$USER blockbench/
sudo chown -R $USER:$USER restclient-cpp/
ls -la ~
```

## Make Drivers
```
cd ~/blockbench/src/macro/kvstore
make

cd ~/blockbench/src/macro/smallbank
make
```
### If failure related to restclient-cpp:

change `LDFLAGS` in `Makefile`:
```
LDFLAGS= -lpthread  -lcurl -L /usr/local/lib -lrestclient-cpp
```
#### In case of NPM Problems:
ELIFECYCLE
```
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
npm start
```
