# How to create application

## Environment

- SDK/PetaLinux: 2018.3
- DNNDK: v3.1

***

## MNIST

- Generate calibration images

```shell-session
$ cd app_mnist
$ python generate_images.py
```

- Generate .dcf file

```shell-session
$ dlet -f ../_vivado/sd_blk_dpu.srcs/sources_1/bd/sd_blk_dpu/hw_handoff/sd_blk_dpu.hwh
```

- Compress model

```shell-session
$ decent_q quantize \
--input_frozen_graph freeze/frozen_graph.pb \
--input_nodes images_in \
--output_nodes dense_1/BiasAdd \
--input_shapes ?,28,28,1 \
--input_fn graph_input_fn.calib_input
```

- Compile model

```shell-session
$ dnnc-dpu1.4.0 \
--parser=tensorflow \
--frozen_pb=quantize_results/deploy_model.pb \
--dcf=<.dcf file generated above> \
--cpu_arch=arm32 \
--output_dir=deploy \
--net_name=mnist \
--save_kernel \
--mode=normal
```

- Make .elf

```shell-session
# Create symbplic link to dputils
$ cd ../src/_pkgs/lib/
$ ln -s libdputils.so.3.3 libdputils.so
$ cd ../../../app_mnist/

# Build
$ arm-linux-gnueabihf-g++ main.cpp \
-I../src/_pkgs/include -I../libs/include \
-L../src/_pkgs/lib -L../libs/lib \
-ldputils -lhineon -ln2cube \
-lopencv_core -lopencv_imgproc -lopencv_imgcodecs \
-ltbb -lz  -ljpeg -lwebp -lpng16 -ltiff -llzma \
deploy/dpu_mnist.elf -o app_mnist.elf
```

- Run the .elf file

  - Console output would look like this:

  ```shell-session
  root@sd_blk:/media# ./app_mnist.elf
  ------ DPU (mnist) ------
  Alignment trap: app_mnist.elf (1290) PC=0xb6f265bc Instr=0xe9d60102 Address=0xb6181582 FSR 0x011
  Alignment trap: app_mnist.elf (1290) PC=0xb6f265bc Instr=0xe9d60102 Address=0xb6181622 FSR 0x011
  Alignment trap: app_mnist.elf (1290) PC=0xb6f265bc Instr=0xe9d60102 Address=0xb61816c2 FSR 0x011
  Alignment trap: app_mnist.elf (1290) PC=0xb6f265bc Instr=0xe9d60102 Address=0xb6181762 FSR 0x011
  ..... Pre-loading Images .....
  ..... Start Inference .....
  ..... Inference Result .....
  7, 2, 1, 0, 4, 1, 4, 9, 5, 9, 0, 6, 9, 0, 1, 5, 9, 7, 3, 4,
  
  ...
  
  4, 6, 0, 7, 0, 3, 6, 8, 7, 1, 5, 2, 4, 9, 4, 3, 6, 4, 1, 7,
  2, 6, 6, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6,
  -------------------------
  ```