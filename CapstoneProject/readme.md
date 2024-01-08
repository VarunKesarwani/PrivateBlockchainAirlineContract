Instal Geth:
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum

Install Nettool
sudo apt install net-tools

Check Open Port
-- Using Nettool
sudo netstat -l (All)
sudo netstat -lt (TCP Only)
netstat -tlpen | grep 8080

-- Firewall
sudo ufw status
sudo ufw enable
sudo ufw allow 8545/tcp
sudo ufw disable

-- lsof
sudo lsof -i tcp
sudo lsof -nP | grep LISTEN

-- File Operation Ubuntu
Delete Dir - rmdir node1
Remove all file- rm -r node1
remove - rm 4649-harmony.json
rename - mv 4649.json genesis.json

Create Node and Account manully:
mkdir GethPrivateBlockchainNetwork
cd GethPrivateBlockchainNetwork
mkdir node1 node2 node3 bnode bashfile

-- Create 4 account
geth --datadir ./node1/data account new 
echo '0x9D3ff0e525Fc319B4C1F7a67304A25EB2F58869A' >> accounts.txt
geth --datadir ./node1/data account new
echo '0x5fddd02F36Ced752393ef29479B298B07E6dE510' >> accounts.txt
geth --datadir ./node1/data account new
echo '0x4DBF8823e5028b001A0C144D24A2e21c8d77f6d5' >> accounts.txt
geth --datadir ./node1/data account new
echo '0x8f30D33eEac4E81449d3101AD04adf56C589D2E1' >> accounts.txt

geth --datadir ./node2/data account new
echo '0x774B999fc4F8Fd2Aca5EA52Eff0aA5ed80d2663a' >> accounts.txt
geth --datadir ./node2/data account new
echo '0x6Ad0A9c65FEaEa0287ec601Cda5216591eCE6Fb6' >> accounts.txt

geth --datadir ./node3/data account new
echo '0x774B999fc4F8Fd2Aca5EA52Eff0aA5ed80d2663a' >> accounts.txt
geth --datadir ./node3/data account new
echo '0x774B999fc4F8Fd2Aca5EA52Eff0aA5ed80d2663a' >> accounts.txt



Save Password Details:
echo 'abc@123' >> password.txt

-- If password is different for each account
echo 'abc@123' >> node1/password_2.txt
echo 'abc@123' >> node1/password_2.txt
echo 'abc@123' >> node1/password_3.txt
echo 'abc@123' >> node1/password_4.txt

echo 'abc@123' >> node2/password_1.txt
echo 'abc@123' >> node2/password_2.txt

echo 'abc@123' >> node3/password_1.txt

copy bash file to server:
scp -i "Gl-PrivateBlockchain-MainNode-01.pem" C:/Users/varun.gupta/Documents/Varun/Study/GL_Material/BlockChain/CapstoneProject/bashfile/bnode.sh ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/bashfile

scp -i "Gl-PrivateBlockchain-MainNode-01.pem" C:/Users/varun.gupta/Documents/Varun/Study/GL_Material/BlockChain/CapstoneProject/bashfile/node1.sh ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/bashfile

scp -i "Gl-PrivateBlockchain-MainNode-01.pem" C:/Users/varun.gupta/Documents/Varun/Study/GL_Material/BlockChain/CapstoneProject/bashfile/node2.sh ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/bashfile

scp -i "Gl-PrivateBlockchain-MainNode-01.pem" C:/Users/varun.gupta/Documents/Varun/Study/GL_Material/BlockChain/CapstoneProject/bashfile/node3.sh ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/bashfile

Create Bootnode:
bootnode -genkey bnode/boot.key

Copy Bashfile
vim bashfile/node1.sh
-- To Close (esc -> :wq)
vim bashfile/node2.sh
vim bashfile/node3.sh
vim bashfile/bnode.sh
(or)
scp -i "Gl-PrivateBlockchain-MainNode.pem" ..\BashFile\node1.sh ubuntu@ec2-18-212-75-108.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/bashfile

Creete Genesis json:
puppeth
network name - genesis
Network ID - 15353
--ctrl+D

Download Genesis File:
scp -r -i "Gl-PrivateBlockchain-MainNode-01.pem" ubuntu@ec2-3-85-36-4.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/genesis.json .
ssh -i "Gl-PrivateBlockchain-MainNode-01.pem" ubuntu@ec2-3-85-36-4.compute-1.amazonaws.com

Initialize node:
geth --datadir ./node1/data init ./genesis.json
geth --datadir ./node2/data init ./genesis.json
geth --datadir ./node3/data init ./genesis.json

cd
chmod +x /home/ubuntu/GethPrivateBlockchainNetwork/bashfile/bnode.sh
chmod +x /home/ubuntu/GethPrivateBlockchainNetwork/bashfile/node1.sh
chmod +x /home/ubuntu/GethPrivateBlockchainNetwork/bashfile/node2.sh
chmod +x /home/ubuntu/GethPrivateBlockchainNetwork/bashfile/node3.sh

cd GethPrivateBlockchainNetwork

Download Keystore files to local:
scp -r -i "Gl-PrivateBlockchain-MainNode-01.pem" ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/node1/data/keystore .
scp -r -i "Gl-PrivateBlockchain-MainNode-01.pem" ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/node2/data/keystore .
scp -r -i "Gl-PrivateBlockchain-MainNode-01.pem" ubuntu@ec2-54-159-12-187.compute-1.amazonaws.com:/home/ubuntu/GethPrivateBlockchainNetwork/node3/data/keystore .

Start Nodes
Bootnode : 
bash bashfile/bnode.sh 172.31.92.25

Enode Address:
enode://5d3e9f76827172f0a5adca0255d2afc0125acc4c812f89ec6defe9fc4e0e6cce528ef77bb181648032e93e0186b88f8f74b95d724617d6e163c01031f68fec4d@172.31.92.25:0?discport=30301

Open new ternimal
bash node1/node1.sh <enode addr> <Private IP> <Account>
bash bashfile/node1.sh enode://5d3e9f76827172f0a5adca0255d2afc0125acc4c812f89ec6defe9fc4e0e6cce528ef77bb181648032e93e0186b88f8f74b95d724617d6e163c01031f68fec4d@172.31.92.25:0?discport=30301 172.31.92.25 0x9D3ff0e525Fc319B4C1F7a67304A25EB2F58869A

Open new ternimal
bash node2/node2.sh <enode addr> <Private IP> <Account>
bash bashfile/node2.sh enode://5d3e9f76827172f0a5adca0255d2afc0125acc4c812f89ec6defe9fc4e0e6cce528ef77bb181648032e93e0186b88f8f74b95d724617d6e163c01031f68fec4d@172.31.92.25:0?discport=30301 172.31.92.25 0xf674AB2132d826E09EDB3AaA98B865165F2ba055

Open new ternimal
bash node3/node3.sh <enode addr> <Private IP> <Account>
bash bashfile/node3.sh enode://5d3e9f76827172f0a5adca0255d2afc0125acc4c812f89ec6defe9fc4e0e6cce528ef77bb181648032e93e0186b88f8f74b95d724617d6e163c01031f68fec4d@172.31.92.25:0?discport=30301 172.31.92.25 0x774B999fc4F8Fd2Aca5EA52Eff0aA5ed80d2663a

Curl Operation:
Node1 Account:
curl -X POST http://172.31.92.25:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0x9D3ff0e525Fc319B4C1F7a67304A25EB2F58869A","latest"], "id":1}'

Node2 Account:
curl -X POST http://172.31.92.25:8546 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0xf674AB2132d826E09EDB3AaA98B865165F2ba055","latest"], "id":1}'

Node1 Account from local:
curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0x9D3ff0e525Fc319B4C1F7a67304A25EB2F58869A","latest"], "id":1}'
curl -X POST http://3.85.36.4:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0x9D3ff0e525Fc319B4C1F7a67304A25EB2F58869A","latest"], "id":1}'

Node2 Account from local:
curl -X POST http://<Public IP>:8546 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0xf674AB2132d826E09EDB3AaA98B865165F2ba055","latest"], "id":1}'
curl -X POST http://3.85.36.4:8546 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0", "method":"eth_getBalance", "params":["0xf674AB2132d826E09EDB3AaA98B865165F2ba055","latest"], "id":1}'

curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 1,"method": "admin_peers","params": []}'
curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 2,"method": "eth_blockNumber","params": []}'
curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 3,"method": "eth_accounts","params": []}'
curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 4,"method": "eth_getBalance","params":["0x08d1f47128f5c04d7a4aee69e90642645059acd6","latest"]}'
curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 5,"method": "personal_newAccount","params":["abc@123"]}'

curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 6,"method": "eth_sendTransaction","params":[{"from":"0x08d1f47128f5c04d7a4aee69e90642645059acd6","to": "0x2bc05c71899ecff51c80952ba8ed444796499118","value": "0xf4240"}]}'

curl -X POST http://<Public IP>:8545 -H "Content-Type: application/json" --data '{"jsonrpc": "2.0","id": 5,"method": "eth_getTransactionByHash","params":["0xa96de080dfcb9c5f908528b92d3df55a0e230cf4e48ae178bb220862c2a544c7"]}'

Links:
Private Network
https://geth.ethereum.org/docs/getting-started/dev-mode
https://hackernoon.com/how-to-set-up-a-private-ethereum-blockchain-proof-of-authority-with-go-ethereum-part-1
https://medium.com/scb-digital/running-a-private-ethereum-blockchain-using-docker-589c8e6a4fe8
https://medium.com/@andrenit/buildind-an-ethereum-playground-with-docker-part-1-introduction-80be173aaa7a#.o1ifv82wn

Contracts:
https://www.tutorialspoint.com/solidity/index.htm
https://medium.com/robhitchens/solidity-crud-part-1-824ffa69509a
https://bitbucket.org/rhitchens2/soliditycrud/src/master/contracts/SolidityCRUD-part2.sol
https://www.youtube.com/watch?v=CgXQC4dbGUE
https://www.youtube.com/watch?v=nvw27RCTaEw
https://github.com/smallbatch-apps/fairline-contract

