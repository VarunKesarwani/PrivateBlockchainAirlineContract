geth --datadir ./node2/data --networkid 15353 --syncmode 'full' --bootnodes $1 --port 30305 --http --http.corsdomain "*" --http.port 8546 --http.addr $2 --http.vhosts '*' --http.api admin,eth,miner,net,txpool,personal,web3,debug --authrpc.port 8552 --unlock $3 --allow-insecure-unlock  --password password.txt console

#geth --datadir ./node2/data --networkid 15353 --syncmode 'full' --bootnodes $1 --port 30305 --http --http.corsdomain "*" --http.port 8546 --http.addr $2 --http.vhosts '*' --http.api admin,eth,miner,net,txpool,personal,web3,debug --authrpc.port 8552 --unlock $3 --allow-insecure-unlock  --password password.txt console