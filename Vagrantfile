Vagrant.configure("2") do |config|

  $etcd_cluster = "node1=http://172.17.8.101:2380"
  (1..3).each do |i|
    config.vm.define "node#{i}" do |server|
      server.vm.box = "centos/7"
      # 关闭镜像更新
      server.vm.box_check_update = false
      server.vm.hostname = "node#{i}"
      ip = "172.17.8.#{i + 100}"
      memory = 2048
      if i == 1 then
        memory = 1024
      end
      server.vm.network "private_network", ip: ip
      # server.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: true
      server.vm.provider "virtualbox" do |v|
        v.name = "server#{i}"
        v.memory = memory
        v.cpus = 2
      end
      server.vm.provision "shell" do |s|
        s.path = "init.sh"
        s.args = [i, ip, $etcd_cluster]
      end
    end
  end
end
