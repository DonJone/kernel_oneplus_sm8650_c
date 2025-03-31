          mkdir kernel_workspace && cd kernel_workspace
         # cp -a '/home/don/Music/kernel_workspace'  /home/don
          git clone https://github.com/yaap/kernel_oneplus_sm8650.git -b fifteen kernel_platform
          rm -rf kernel_platform/android/abi_gki_protected_exports_*
          sed -i 's/ -dirty//g' kernel_platform/scripts/setlocalversion || true
          cd kernel_platform
          curl -LSs "https://raw.githubusercontent.com/ShirkNeko/KernelSU/main/kernel/setup.sh" | bash -s susfs-dev
          cd ../
          git clone https://gitlab.com/simonpunk/susfs4ksu.git -b gki-android14-6.1
          git clone https://github.com/ShirkNeko/SukiSU_patch.git
          cd kernel_platform
          cp ../susfs4ksu/kernel_patches/50_add_susfs_in_gki-android14-6.1.patch ./
          cp ../susfs4ksu/kernel_patches/fs/* ./fs/
          cp ../susfs4ksu/kernel_patches/include/linux/* ./include/linux/
          # zram lz4kd
          #cp -r ../SukiSU_patch/other/lz4k/include/linux/* ./include/linux
          #cp -r ../SukiSU_patch/other/lz4k/lib/* ./lib
          #cp -r ../SukiSU_patchcd /other/lz4k/crypto/* ./crypto
          patch -p1 < 50_add_susfs_in_gki-android14-6.1.patch || true
          cp ../SukiSU_patch/69_hide_stuff.patch ./
          patch -p1 -F 3 < 69_hide_stuff.patch
          cp ../SukiSU_patch/hooks/new_hooks.patch ./
          patch -p1 -F 3 < new_hooks.patch
          #cp ../SukiSU_patch/other/lz4k_patch/6.1/lz4kd.patch
          #patch -p1 -F 3 < lz4kd.patch || true
          echo "CONFIG_KSU=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_SU=n" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_MANUAL_HOOK=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_PATH=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_KSTAT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_TRY_UMOUNT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SPOOF_UNAME=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_ENABLE_LOG=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y" >> ./arch/arm64/configs/gki_defconfig
          echo "CONFIG_KSU_SUSFS_OPEN_REDIRECT=y" >> ./arch/arm64/configs/gki_defconfig   
          #echo "CONFIG_CRYPTO_LZ4K=y" >> ./arch/arm64/configs/gki_defconfig
          #echo "CONFIG_CRYPTO_LZ4KD=y" >> ./arch/arm64/configs/gki_defconfig
          #echo "CONFIG_CRYPTO_LZ4HC=y" >> ./arch/arm64/configs/gki_defconfig
          #echo "CONFIG_CRYPTO_842=y" >> ./arch/arm64/configs/gki_defconfig
          sed -i 's/check_defconfig//' ./build.config.gki
          sed -i '$s|echo "\$res"|echo "\Kim"|' ./scripts/setlocalversion
          sed -i 's/-dirty//' ./scripts/setlocalversion
          make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 -j$(nproc --all) O=out gki_defconfig vendor/pineapple_GKI.config vendor/oplus/pineapple_GKI.config vendor/oplus/waffle.config # Build the kernel config
          make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 -j$(nproc --all) O=out # Build the kernel itself
          make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 -j$(nproc --all) O=out modules_install INSTALL_MOD_PATH=./Kernel_Prebuilts # Save the kernel modules to out/Kernel_Prebuilts/lib/modules
          make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 -j$(nproc --all) O=out install INSTALL_PATH=./Kernel_Prebuilts # Save the kernel image(s) and devicetrees to ./Kernel_Prebuilts/boot hopefully
          make ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 -j$(nproc --all) O=out headers_install INSTALL_HDR_PATH=./Kernel_Prebuilts/usr # Save the kernel headers to out/Kernel_Prebuilts/usr
          
          

          
          
