# tensil

## 1. set up environment

- Get ZULU JDK (v11.0.17) & mill

```bash
$ wget https://cdn.azul.com/zulu/bin/zulu11.60.19-ca-jdk11.0.17-linux_x64.tar.gz
$ tar xf zulu11.60.19-ca-jdk11.0.17-linux_x64.tar.gz
$ export JAVA_HOME=$(pwd)/zulu11.60.19-ca-jdk11.0.17-linux_x64
$ export PATH=$(pwd)/zulu11.60.19-ca-jdk11.0.17-linux_x64/bin:${PATH}
$ sudo sh -c "curl -L https://github.com/com-lihaoyi/mill/releases/download/0.10.9/0.10.9 > /usr/local/bin/mill && chmod +x /usr/local/bin/mill"
```

- Get model data

```bash
$ wget https://github.com/tensil-ai/tensil-models/archive/main.tar.gz
$ tar xf main.tar.gz
$ mv tensil-models-main models
```

- Get tensil source

```bash
$ git clone https://github.com/tensil-ai/tensil.git -b v1.0.15
$ cd tensil
$ ./mill 'rtl.assembly'
$ ./mill 'compiler.assembly'
$ ./mill 'emulator.assembly'
$ ./mill 'web.assembly'

$ sudo mkdir /opt/tensil
$ sudo cp out/rtl/assembly.dest/out.jar /opt/tensil/rtl.jar
$ sudo cp out/compiler/assembly.dest/out.jar /opt/tensil/compiler.jar
$ sudo cp out/emulator/assembly.dest/out.jar /opt/tensil/emulator.jar
$ sudo cp out/web/assembly.dest/out.jar /opt/tensil/web.jar

$ export PATH=${PATH}:$(pwd)/docker/bin
```

## 2. Build HW

- Generate RTL
  - Output files:
    - bram_dp_128x2048.v
    - bram_dp_128x8192.v
    - top_sd_blk.v
    - architecture_params.h

```shell-session
$ cd ..
$ tensil rtl -a src/sd_blk.tarch -s true

----------------------------------------------------------------------
RTL SUMMARY
----------------------------------------------------------------------
Data type:                                      FP16BP8   
Array size:                                     8         
DRAM0 memory size (vectors/scalars/bits):       1,048,576 8,388,608 20
DRAM1 memory size (vectors/scalars/bits):       1,048,576 8,388,608 20
Local memory size (vectors/scalars/bits):       8,192     65,536    13
Accumulator memory size (vectors/scalars/bits): 2,048     16,384    11
Stride #0 size (bits):                          3         
Stride #1 size (bits):                          3         
Operand #0 size (bits):                         16        
Operand #1 size (bits):                         24        
Operand #2 size (bits):                         16        
Instruction size (bytes):                       8         
----------------------------------------------------------------------

$ mkdir rtl
$ mv bram_dp_128x* rtl/
$ mv architecture_params.h rtl/
$ mv top_sd_blk.* rtl/
$ mv firrtl_black_box_resource_files.f rtl/
```

- Generate bitstream

```shell-session
$ vivado -mode batch -source create_xsa.tcl
```

## 3. Generate model
  - resnet20v2_cifar_onnx_sd_blk.tmodel
  - resnet20v2_cifar_onnx_sd_blk.tprog
  - resnet20v2_cifar_onnx_sd_blk.tdata

```shell-session
$ tensil compile -a src/sd_blk.tarch -m models/resnet20v2_cifar.onnx -o "Identity:0" -s true

-----------------------------------------------------------------------------------------------
COMPILER SUMMARY
-----------------------------------------------------------------------------------------------
Model:                                                resnet20v2_cifar_onnx_sd_blk 
Data type:                                            FP16BP8                      
Array size:                                           8                            
DRAM0 memory size (vectors/scalars/bits):             1,048,576                    8,388,608 20
DRAM1 memory size (vectors/scalars/bits):             1,048,576                    8,388,608 20
Local memory size (vectors/scalars/bits):             8,192                        65,536    13
Accumulator memory size (vectors/scalars/bits):       2,048                        16,384    11
Stride #0 size (bits):                                3                            
Stride #1 size (bits):                                3                            
Operand #0 size (bits):                               16                           
Operand #1 size (bits):                               24                           
Operand #2 size (bits):                               16                           
Instruction size (bytes):                             8                            
DRAM0 maximum usage (vectors/scalars):                26,624                       212,992   
DRAM0 aggregate usage (vectors/scalars):              103,458                      827,664   
DRAM1 maximum usage (vectors/scalars):                71,341                       570,728   
DRAM1 aggregate usage (vectors/scalars):              71,341                       570,728   
Local memory maximum usage (vectors/scalars):         8,192                        65,536    
Local memory aggregate usage (vectors/scalars):       393,294                      3,146,352 
Accumumator memory maximum usage (vectors/scalars):   2,048                        16,384    
Accumumator memory aggregate usage (vectors/scalars): 199,212                      1,593,696 
Number of layers:                                     27                           
Maximum number of stages:                             16                           
Maximum number of partitions:                         24                           
Execution latency (MCycles):                          1.916                        
Aggregate latency (MCycles):                          1.916                        
Execution energy (MUnits):                            110.019                      
Aggregate energy (MUnits):                            110.020                      
MAC efficiency (%):                                   50.144                       
Total number of instructions:                         237,189                      
Compilation time (seconds):                           35.625                       
True consts scalar size:                              568,466                      
Consts utilization (%):                               97.545                       
True MACs (MMAC):                                     61.476                       
MAC efficiency (%):                                   50.144                       
-----------------------------------------------------------------------------------------------

$ mkdir ml-model
$ mv resnet20v2_cifar_onnx_sd_blk.t* ml-model/
```

## 4. Run

- Copy files:

```shell-session
$ scp -r tensil/drivers/tcu_pynq zynq@<board IP>:~
$ scp _vivado/sd_blk.runs/impl_1/sd_blk_wrapper.bit zynq@<board IP>:~//sd_blk.bit
$ scp _vivado/sd_blk.gen/sources_1/bd/sd_blk/hw_handoff/sd_blk.hwh zynq@<board IP>:~
$ scp ml-model/* zynq@<board IP>:~
```
