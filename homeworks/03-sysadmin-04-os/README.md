1. <br/>![node_exporter](img/1.1.jpg)
<br/>![node_exporter](img/1.2.jpg)
<br/>![node_exporter](img/1.3.jpg)
1. metrics
cpu:
node_cpu_seconds_total{cpu="0",mode="idle"} 4292.49 <br/>
node_cpu_seconds_total{cpu="0",mode="system"} 239.76 <br/>
node_cpu_seconds_total{cpu="0",mode="user"} 4.11 <br/>
memory:<br/>
node_memory_MemAvailable_bytes <br/>
node_memory_MemFree_bytes <br/>
disk:<br/>
node_disk_written_bytes_total{device="sda"}<br/>
node_disk_read_bytes_total{device="sda"}<br/>
network:<br/>
node_network_receive_bytes_total{device="enp0s3"} <br/>
node_network_transmit_bytes_total{device="enp0s3"}<br/>
node_network_receive_errs_total{device="enp0s3"}<br/>
node_network_transmit_errs_total{device="enp0s3"}<br/>
1. <br/>![netdata](img/3.1.jpg)
<br/>![netdata](img/3.2.jpg)
<br/>![netdata](img/3.3.jpg)
1. <br/>![dmesg](img/4.1.jpg)
<br/>![netdata](img/4.2.jpg)
1. этот параметр означает количество максимальное число открытых дескрипторов для ядра (системы)
<br/>![limits_fd](img/5.1.jpg)
ulimit -Hn - показывает жесткие ограничения на количество открытых дескрипторов от процесса
ulimit -Sn - показывает мягкие ограничения на количество открытых дескрипторов от процесса
<br/>![limits_fd](img/5.2.jpg)
cat /proc/sys/fs/file-max - предел операционной системы
<br/>![limits_fd](img/5.3.jpg)
1.
<br/>![namespaces](img/6.jpg)
7. это fork бомба, создает множество паралельных форков самой себя
<br/>![fork-bomb](img/7.jpg)
ulimit -u 200 - можно установить ограничения процессов от одного пользователя, на моей машине запущено ~120 процессов
