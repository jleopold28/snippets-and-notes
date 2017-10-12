# install grpc and protobuf prereqs
apt-get update
apt-get install git build-essential autoconf libtool libgflags-dev libgtest-dev clang libc++-dev curl pkg-config unzip -y
# grab grpc
git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc /home/vagrant
cd /home/vagrant/grpc
git submodule update --init
# build grpc
make
make install
# install protocol buffers
cd third_party/protobuf
./autogen.sh
./configure
make
make install
# install c++ dev
apt-get install gcc cmake -y
