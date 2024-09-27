Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC3118B474
	for <fio@vger.kernel.org>; Fri, 27 Sep 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727438412; cv=none; b=g7imVb9jekiGkTPVrCe0tYv19f6DZjlFi/mabK1EhqakLndZQje0hXMfWAFmIwdoMgDqJ6GgrFpcQOmqiGw7o3ZQwSuK/t+c+j1pQ2T8/XBd9AgXuciVLkRLaQKsW8kLEOTwTYON7EA/vg0Za9hWsmoS3vuulUBNkNOc+UrPXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727438412; c=relaxed/simple;
	bh=jKCkCyUKBqFNCditDM6xK27teQloMgI7+PB3ToBIElw=;
	h=Subject:From:To:Message-Id:Date; b=JBNUW+jjHgwLu6ii2LtTqHgkU09gC7dPU+N9PI82ENdZzS9+y/35nf440rnUDOSZkHjFMLN2rqp24ABu9urJKYgfWMQQTVc0pnsU3l7mpdesam6p7oiRtOB4gUitcWLrWaPDwQ+liZ4F+Tx0VxdVBs7e/An95T+62ltKmmqfjlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VMdQZZgH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VMdQZZgH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Mg/1mzpqxo9IwA70Mg63pQzwxPKUHbbfoUpruVdsHC4=; b=VMdQZZgH8Y7JgEwR+LjhNewKzP
	WXpwFKYp5nrmQiNFVhsq2UigRhvb4rWH4wapNegUdAEGbQXaYe1nr3kcwBUHF+lmqtGp6NWDHnW6x
	zBHZ4wN1kgT+oHVl5962NG1FlisReixYxMy8p8dnY1gABLTe27iNvfUx7iMphB6XKfByeSmv15Uvt
	8XMTkfV26pDD3s6hFwwqlFWTOX9x9G8rgqUD/8jtzB62q6Jc833JGpfW+5aY8GX9BY8K8u/0cRZ/G
	GpvfWtFXRl9XudCjrYOHMySsaaJOjKQ74/+VDbL7MAXGmO8jS9Mpd/x51vauh2Mq2myEYioxucwTj
	DAR121Ew==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1su9dk-00000002LAw-1DfM
	for fio@vger.kernel.org;
	Fri, 27 Sep 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D24B81BC0147; Fri, 27 Sep 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240927120001.D24B81BC0147@kernel.dk>
Date: Fri, 27 Sep 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit bcd46be2adaa4afc32b836ad6137798544a3d80a:

  Merge branch 'atomic-writes' (2024-09-16 20:23:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e4e8520b374e7e021d289d400ade70c41681d635:

  engines/io_uring: Fix negative errno in io_u->error (2024-09-27 04:18:26 -0600)

----------------------------------------------------------------
HuangShumin (1):
      Fix configure with --build-static which enables static RDMA in #1801

Jens Axboe (1):
      engines/io_uring: don't use abs() on an unsigned value

Minwoo Im (4):
      io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
      io_uring: Support Compare command for verification
      HOWTO: update 'verify_mode' for io_uring_cmd
      engines/io_uring: Fix negative errno in io_u->error

Vincent Fu (6):
      ci: remove unneeded packages
      ci: only remove libunwind-14-dev if installed
      ci: handle sudo in actions-install.sh
      ci: build and run a QEMU guest VM for testing
      ci/cifuzz: update to upload-artifacts@v4
      Merge branch 'master' of https://github.com/HuangShumin/fio

 .github/actions/build-qemu/action.yml         |  31 ++++++++
 .github/actions/create-guest-image/action.yml |  45 +++++++++++
 .github/actions/start-vm/action.yml           |  54 +++++++++++++
 .github/workflows/cifuzz.yml                  |   2 +-
 .github/workflows/qemu.yml                    | 104 ++++++++++++++++++++++++++
 HOWTO.rst                                     |   9 +++
 ci/actions-install.sh                         |  39 +++++-----
 configure                                     |   6 +-
 engines/io_uring.c                            |  63 ++++++++++++++--
 engines/nvme.c                                |   5 +-
 engines/nvme.h                                |   4 +-
 fio.1                                         |  14 ++++
 io_u.c                                        |   9 ++-
 io_u.h                                        |   2 +
 verify.c                                      |   7 ++
 15 files changed, 359 insertions(+), 35 deletions(-)
 create mode 100644 .github/actions/build-qemu/action.yml
 create mode 100644 .github/actions/create-guest-image/action.yml
 create mode 100644 .github/actions/start-vm/action.yml
 create mode 100644 .github/workflows/qemu.yml

---

Diff of recent changes:

diff --git a/.github/actions/build-qemu/action.yml b/.github/actions/build-qemu/action.yml
new file mode 100644
index 00000000..06804b8b
--- /dev/null
+++ b/.github/actions/build-qemu/action.yml
@@ -0,0 +1,31 @@
+name: 'Build and Install QEMU on Ubuntu'
+desription: 'Build QEMU and Install on Ubuntu'
+
+inputs:
+  version: # What QEMU version to build/install
+    description: 'QEMU version to build and install'
+    required: false
+    default: '9.1.0'
+
+
+runs:
+  using: "composite"
+  steps:
+    - name: Install QEMU build dependencies
+      run: sudo apt-get -qq install libglib2.0-dev libfdt-dev libpixman-1-dev ninja-build flex bison libsdl2-dev libaio-dev python3-tomli libslirp-dev
+      shell: bash
+
+    - name: Build and install QEMU
+      run: |
+        wget -nv https://download.qemu.org/qemu-$INPUT_VER.tar.xz
+        tar xJf qemu-$INPUT_VER.tar.xz
+        rm qemu-$INPUT_VER.tar.xz
+        cd qemu-$INPUT_VER
+        ./configure --enable-kvm --target-list=x86_64-softmmu
+        make -j $(nproc)
+        sudo make install
+        cd ..
+        rm -rf qemu-$INPUT_VER
+      shell: bash
+      env:
+        INPUT_VER: ${{ inputs.version }}
diff --git a/.github/actions/create-guest-image/action.yml b/.github/actions/create-guest-image/action.yml
new file mode 100644
index 00000000..ce413378
--- /dev/null
+++ b/.github/actions/create-guest-image/action.yml
@@ -0,0 +1,45 @@
+name: 'Create guest image'
+description: 'Create VM guest image on Ubuntu runner'
+
+inputs:
+  distro:
+    description: 'Linux distribution to use for guest image'
+    required: false
+    default: 'debian-12'
+  extra_pkgs:
+    description: 'Extra packages to install for guest image'
+    required: false
+    default:
+
+runs:
+  using: "composite"
+  steps:
+    - name: Install libguestfs
+      run: sudo apt-get -qq install libguestfs-tools
+      shell: bash
+    - name: Setup steps for virt-builder
+      run: |
+        sudo chmod a+r /boot/vmlinuz*
+        sudo chmod 0666 /dev/kvm
+        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
+      shell: bash
+    - name: Create Debian image
+      run: |
+        virt-builder ${{ inputs.distro }} \
+          --quiet \
+          --hostname fio-tester \
+          --ssh-inject root \
+          --run-command "ssh-keygen -A" \
+          --run-command "sed -i 's/ens2/enp0s2/g' /etc/network/interfaces" \
+          --append-line '/etc/environment:PYTHONUNBUFFERED=1' \
+          --append-line '/etc/environment:GITHUB_SERVER_URL=${{ github.server_url }}' \
+          --append-line '/etc/environment:GITHUB_REPOSITORY=${{ github.repository }}' \
+          --append-line '/etc/environment:GITHUB_REF=${{ github.ref }}' \
+          --append-line '/etc/environment:GITHUB_SHA=${{ github.sha }}' \
+          --append-line '/etc/environment:GITHUB_JOB=${{ github.job }}' \
+          --append-line '/etc/environment:EXTRA_PKGS=${{ inputs.extra_pkgs }}' \
+          --append-line '/etc/environment:CI_TARGET_BUILD=${{ env.CI_TARGET_BUILD }}' \
+          --append-line '/etc/environment:CI_TARGET_OS=${{ env.CI_TARGET_OS }}'
+
+      shell: bash
+
diff --git a/.github/actions/start-vm/action.yml b/.github/actions/start-vm/action.yml
new file mode 100644
index 00000000..d47977c4
--- /dev/null
+++ b/.github/actions/start-vm/action.yml
@@ -0,0 +1,54 @@
+name: 'Start QEMU VM'
+description: 'Start QEMU virtual machine'
+
+inputs:
+  qemu: # QEMU binary to use
+    required: false
+    default: "qemu-system-x86_64"
+  image: # VM image file
+    required: true
+  ssh_fwd_port: # forward this host port to the guest's SSH port
+    required: false
+    default: 2022
+  options: # Custom QEMU invocation options no \n at the end!
+    required: false
+  ram: # how much RAM to allocate to VM
+    required: false
+    default: "12G"
+  host_key: # If true add guest host key to known_hosts
+    required: false
+    default: "false"
+
+runs:
+  using: "composite"
+  steps:
+    - name: install wait-for-it
+      shell: bash
+      run: sudo apt-get -qq install wait-for-it
+    - name: Start VM in background
+      shell: bash
+      run: |
+        ${{ inputs.qemu }} \
+          -cpu host \
+          -drive file=${{ inputs.image }},format=raw,if=virtio \
+          -enable-kvm \
+          -smp $(nproc) \
+          -nographic \
+          -m ${{ inputs.ram }} \
+          -display none \
+          -machine q35,accel=kvm \
+          -nic user,model=virtio-net-pci,hostfwd=tcp::${{ inputs.ssh_fwd_port }}-:22 \
+          ${{ inputs.options }} \
+          &
+    - name: Wait for VM to boot
+      shell: bash
+      run: |
+        wait-for-it localhost:${{ inputs.ssh_fwd_port }} -t 15
+        sleep 3
+    - name: Add guest host key to known_hosts
+      shell: bash
+      run: |
+        if echo ${{ inputs.host_key }} | grep -c "true"
+        then
+          ssh root@localhost -p ${{ inputs.ssh_fwd_port }} -o StrictHostKeyChecking=no echo
+        fi
diff --git a/.github/workflows/cifuzz.yml b/.github/workflows/cifuzz.yml
index acc8d482..9227735e 100644
--- a/.github/workflows/cifuzz.yml
+++ b/.github/workflows/cifuzz.yml
@@ -17,7 +17,7 @@ jobs:
         fuzz-seconds: 600
         dry-run: false
     - name: Upload Crash
-      uses: actions/upload-artifact@v1
+      uses: actions/upload-artifact@v4
       if: failure() && steps.build.outcome == 'success'
       with:
         name: artifacts
diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
new file mode 100644
index 00000000..4ba8bfae
--- /dev/null
+++ b/.github/workflows/qemu.yml
@@ -0,0 +1,104 @@
+name: CI
+
+on:
+  schedule:
+    - cron: "50 3 * * *"  # daily at 4:50 UTC (00:50 EST)
+
+jobs:
+  qemu-guest:
+    runs-on: ubuntu-22.04
+
+    strategy:
+      fail-fast: false
+      matrix:
+        include:
+          - config: basic io_uring_cmd tests
+            device: >-
+              -device nvme,id=nvme0,serial=deadbeef
+              -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
+              -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
+            test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015"
+            extra_pkgs: "nvme-cli"
+          - config: 16-bit Guard PI tests (long)
+            device: >-
+              -device nvme,id=nvme0,serial=deadbeef
+              -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
+              -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
+            test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1"
+            extra_pkgs: "nvme-cli"
+          - config: 4K+16 w/64-bit Guard PI
+            device: >- # 4K+16 w/64-bit Guard PI
+              -device nvme,id=nvme1,serial=deadbeee
+              -drive id=nvm-1,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
+              -device nvme-ns,id=nvm-1,drive=nvm-1,bus=nvme1,nsid=1,pif=2,ms=16,mset=1,pi=1,pil=0,logical_block_size=4096,physical_block_size=4096
+            test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1 --lbaf 6"
+            extra_pkgs: "nvme-cli"
+          - config: 4K+64 w/64-bit Guard PI
+            device: >-
+              -device nvme,id=nvme2,serial=deadeeef
+              -drive id=nvm-2,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
+              -device nvme-ns,id=nvm-2,drive=nvm-2,bus=nvme2,nsid=1,pif=2,ms=64,mset=1,pi=1,pil=0,logical_block_size=4096,physical_block_size=4096
+            test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1 --lbaf 7"
+            extra_pkgs: "nvme-cli"
+          - config: FDP
+            device: >-
+              -device nvme-subsys,id=nvme-subsys0,fdp=on,fdp.runs=128K,fdp.nrg=8,fdp.nruh=64
+              -device nvme,id=nvme0,serial=deadbeef,subsys=nvme-subsys0
+              -drive id=nvm-1,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
+              -device nvme-ns,id=nvm-1,drive=nvm-1,bus=nvme0,nsid=1,logical_block_size=4096,physical_block_size=4096,fdp.ruhs=0-63
+            test_cmd: "nvme fdp status /dev/ng0n1 && python3 t/nvmept_fdp.py --fio ./fio --dut /dev/ng0n1"
+            extra_pkgs: "nvme-cli"
+          - config: ZBD
+            device:
+            test_cmd: "./t/zbd/run-tests-against-nullb"
+            extra_pkgs: sg3-utils
+
+    env:
+      DISTRO: debian-12
+      SSHCMD: ssh root@localhost -p 2022
+      CI_TARGET_BUILD: linux
+      CI_TARGET_OS: debian
+
+    steps:
+    - name: Check out repository
+      uses: actions/checkout@v4
+
+    - name: Create guest VM image
+      uses: ./.github/actions/create-guest-image
+      with:
+        distro: ${{ env.DISTRO }}
+        extra_pkgs: ${{ matrix.extra_pkgs }}
+
+    - name: Build and install QEMU
+      uses: ./.github/actions/build-qemu
+
+    - name: Create backing file for NVMe device
+      run: truncate -s 1G nvme0.img
+
+    - name: Start VM
+      uses: ./.github/actions/start-vm
+      with:
+        image: ${{ env.DISTRO }}.img
+        host_key: true
+        options: ${{ matrix.device }}
+
+    - name: Clone fio on guest
+      run: |
+          $SSHCMD "apt-get update && apt-get install -qq git"
+          $SSHCMD "git clone https://github.com/taiki-e/checkout-action --branch v1.3.0"
+          $SSHCMD "mkdir fio && cd fio && ../checkout-action/main.sh && git log -1"
+
+    - name: Install dependencies on guest
+      run: $SSHCMD "cd fio && ./ci/actions-install.sh"
+
+    - name: Build fio on guest
+      run: $SSHCMD "cd fio && ./ci/actions-build.sh"
+
+    - name: Show nvme device configuration
+      if: ${{ contains( matrix.extra_pkgs, 'nvme-cli' ) }}
+      run: |
+        $SSHCMD "nvme id-ns /dev/ng0n1 -H"
+        $SSHCMD "nvme nvm-id-ns /dev/ng0n1 -v"
+
+    - name: Run test
+      run: $SSHCMD "cd fio && ${{ matrix.test_cmd }}"
diff --git a/HOWTO.rst b/HOWTO.rst
index 4f071484..539bce19 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2883,6 +2883,15 @@ with the caveat that when used on the command line, they must come after the
                 **verify**
                         Use Verify commands for write operations
 
+.. option:: verify_mode=str : [io_uring_cmd]
+
+        Specifies the type of command to be used in the verification phase.  Defaults to 'read'.
+
+                **read**
+                        Use Read commands for data verification
+                **compare**
+                        Use Compare commands for data verification
+
 .. option:: sg_write_mode=str : [sg]
 
 	Specify the type of write commands to issue. This option can take ten values:
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 7a87fbe3..5a32ec91 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -6,16 +6,18 @@ SCRIPT_DIR=$(dirname "$0")
 # shellcheck disable=SC1091
 . "${SCRIPT_DIR}/common.sh"
 
+_sudo() {
+    if type -P sudo >/dev/null; then
+        sudo "$@"
+    else
+        "$@"
+    fi
+}
+
 install_ubuntu() {
     local pkgs
 
-    if [ "${GITHUB_JOB}" == "build-containers" ]; then
-        # containers run as root and do not have sudo
-        apt update
-        apt -y install sudo
-    fi
-
-    cat <<DPKGCFG | sudo tee /etc/dpkg/dpkg.cfg.d/dpkg-speedup > /dev/null
+    cat <<DPKGCFG | _sudo tee /etc/dpkg/dpkg.cfg.d/dpkg-speedup > /dev/null
 # Skip fsync
 force-unsafe-io
 # Don't install documentation
@@ -36,7 +38,7 @@ DPKGCFG
     )
     case "${CI_TARGET_ARCH}" in
         "i686")
-            sudo dpkg --add-architecture i386
+            _sudo dpkg --add-architecture i386
             pkgs=("${pkgs[@]/%/:i386}")
             pkgs+=(
                 gcc-multilib
@@ -60,8 +62,10 @@ DPKGCFG
                 librdmacm-dev
 	        pkg-config
             )
-	    echo "Removing libunwind-14-dev because of conflicts with libunwind-dev"
-	    sudo apt remove -y libunwind-14-dev
+	    if apt list --installed | grep -c "libunwind-14-dev"; then
+		    echo "Removing libunwind-14-dev because of conflicts with libunwind-dev"
+		    _sudo apt remove -y libunwind-14-dev
+	    fi
 	    if [ "${CI_TARGET_OS}" == "linux" ] || [ "${CI_TARGET_OS}" == "ubuntu" ]; then
 	        # Only for Ubuntu
 		pkgs+=(
@@ -77,23 +81,22 @@ DPKGCFG
         python3-scipy
 	python3-sphinx
 	python3-statsmodels
+	sudo
+	${EXTRA_PKGS:-}
     )
-    if [ "${GITHUB_JOB}" == "build-containers" ]; then
+    if [ "${GITHUB_JOB}" == "build-containers" ] || [ "${GITHUB_JOB}" == "qemu-guest" ]; then
         pkgs+=(
             bison
             build-essential
-            cmake
             flex
-            unzip
-            wget
             zlib1g-dev
         )
     fi
 
     echo "Updating APT..."
-    sudo apt-get -qq update
+    _sudo apt-get -qq update
     echo "Installing packages... ${pkgs[@]}"
-    sudo apt-get install -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
+    _sudo apt-get install -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
 }
 
 # Fedora and related distributions
@@ -101,7 +104,6 @@ install_fedora() {
     pkgs=(
         bison-devel
         git
-        cmake
         flex-devel
         gperftools
         isa-l-devel
@@ -119,9 +121,8 @@ install_fedora() {
         python3-scipy
         python3-sphinx
         sudo
-        unzip
         valgrind-devel
-        wget
+	${EXTRA_PKGS:-}
     )
 
     case "${CI_TARGET_OS}" in
diff --git a/configure b/configure
index eb92cde3..715f0602 100755
--- a/configure
+++ b/configure
@@ -1005,8 +1005,9 @@ int main(int argc, char **argv)
   return pd != NULL;
 }
 EOF
-if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; then
+if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs -lnl-3 -lnl-route-3" "libverbs" ; then
     libverbs="yes"
+    LIBS="-libverbs -lnl-3 -lnl-route-3 $LIBS"
 fi
 print_config "libverbs" "$libverbs"
 
@@ -1024,8 +1025,9 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
+if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm -lnl-3 -lnl-route-3" "rdma"; then
     rdmacm="yes"
+    LIBS="-libverbs -lnl-3 -lnl-route-3 $LIBS"
 fi
 print_config "rdmacm" "$rdmacm"
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 96a042a8..85cebf83 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -41,6 +41,11 @@ enum uring_cmd_write_mode {
 	FIO_URING_CMD_WMODE_VERIFY,
 };
 
+enum uring_cmd_verify_mode {
+	FIO_URING_CMD_VMODE_READ = 1,
+	FIO_URING_CMD_VMODE_COMPARE,
+};
+
 struct io_sq_ring {
 	unsigned *head;
 	unsigned *tail;
@@ -99,6 +104,7 @@ struct ioring_options {
 	unsigned int readfua;
 	unsigned int writefua;
 	unsigned int write_mode;
+	unsigned int verify_mode;
 	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
@@ -194,6 +200,26 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "verify_mode",
+		.lname	= "Do verify based on the configured command (e.g., Read or Compare command)",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, verify_mode),
+		.help	= "Issue Read or Compare command in the verification phase",
+		.def	= "read",
+		.posval = {
+			  { .ival = "read",
+			    .oval = FIO_URING_CMD_VMODE_READ,
+			    .help = "Issue Read commands in the verification phase"
+			  },
+			  { .ival = "compare",
+			    .oval = FIO_URING_CMD_VMODE_COMPARE,
+			    .help = "Issue Compare commands in the verification phase"
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
@@ -443,6 +469,7 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	struct nvme_dsm *dsm;
 	void *ptr = ld->dsm;
 	unsigned int dsm_size;
+	uint8_t read_opcode = nvme_cmd_read;
 
 	/* only supports nvme_uring_cmd */
 	if (o->cmd_type != FIO_URING_CMD_NVME)
@@ -483,9 +510,21 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	ptr += io_u->index * dsm_size;
 	dsm = (struct nvme_dsm *)ptr;
 
+	/*
+	 * If READ command belongs to the verification phase and the
+	 * verify_mode=compare, convert READ to COMPARE command.
+	 */
+	if (io_u->flags & IO_U_F_VER_LIST && io_u->ddir == DDIR_READ &&
+			o->verify_mode == FIO_URING_CMD_VMODE_COMPARE) {
+		populate_verify_io_u(td, io_u);
+		read_opcode = nvme_cmd_compare;
+		io_u_set(td, io_u, IO_U_F_VER_IN_DEV);
+	}
+
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			dsm, ld->write_opcode, ld->cdw12_flags[io_u->ddir]);
+			dsm, read_opcode, ld->write_opcode,
+			ld->cdw12_flags[io_u->ddir]);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
@@ -528,12 +567,9 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
-	if (cqe->res != 0) {
-		io_u->error = abs(cqe->res);
-		return io_u;
-	} else {
-		io_u->error = 0;
-	}
+	io_u->error = cqe->res;
+	if (io_u->error != 0)
+		goto ret;
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		data = FILE_ENG_DATA(io_u->file);
@@ -544,6 +580,16 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 		}
 	}
 
+ret:
+	/*
+	 * If IO_U_F_DEVICE_ERROR is not set, io_u->error will be parsed as an
+	 * errno, otherwise device-specific error value (status value in CQE).
+	 */
+	if ((int)io_u->error > 0)
+		io_u_set(td, io_u, IO_U_F_DEVICE_ERROR);
+	else
+		io_u_clear(td, io_u, IO_U_F_DEVICE_ERROR);
+	io_u->error = abs((int)io_u->error);
 	return io_u;
 }
 
@@ -557,6 +603,9 @@ static char *fio_ioring_cmd_errdetails(struct thread_data *td,
 #define MAXMSGCHUNK 128
 	char *msg, msgchunk[MAXMSGCHUNK];
 
+	if (!(io_u->flags & IO_U_F_DEVICE_ERROR))
+		return NULL;
+
 	msg = calloc(1, MAXERRDETAIL);
 	strcpy(msg, "io_uring_cmd: ");
 
diff --git a/engines/nvme.c b/engines/nvme.c
index 33d87477..18010c0b 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -363,7 +363,8 @@ void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm *dsm,
-			    uint8_t write_opcode, unsigned int cdw12_flags)
+			    uint8_t read_opcode, uint8_t write_opcode,
+			    unsigned int cdw12_flags)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
@@ -373,7 +374,7 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		cmd->opcode = nvme_cmd_read;
+		cmd->opcode = read_opcode;
 		break;
 	case DDIR_WRITE:
 		cmd->opcode = write_opcode;
diff --git a/engines/nvme.h b/engines/nvme.h
index b5fef2fb..60b38d7f 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -77,6 +77,7 @@ enum nvme_io_opcode {
 	nvme_cmd_write			= 0x01,
 	nvme_cmd_read			= 0x02,
 	nvme_cmd_write_uncor		= 0x04,
+	nvme_cmd_compare		= 0x05,
 	nvme_cmd_write_zeroes		= 0x08,
 	nvme_cmd_dsm			= 0x09,
 	nvme_cmd_verify			= 0x0c,
@@ -431,7 +432,8 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm *dsm,
-			    uint8_t write_opcode, unsigned int cdw12_flags);
+			    uint8_t read_opcode, uint8_t write_opcode,
+			    unsigned int cdw12_flags);
 
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
diff --git a/fio.1 b/fio.1
index 0fd0fb25..356980b5 100644
--- a/fio.1
+++ b/fio.1
@@ -2675,6 +2675,20 @@ Use Verify commands for write operations
 .RE
 .RE
 .TP
+.BI (io_uring_cmd)verify_mode \fR=\fPstr
+Specifies the type of command to be used in the verification phase. Defaults to 'read'.
+.RS
+.RS
+.TP
+.B read
+Use Read commands for data verification
+.TP
+.B compare
+Use Compare commands for data verification
+.TP
+.RE
+.RE
+.TP
 .BI (sg)sg_write_mode \fR=\fPstr
 Specify the type of write commands to issue. This option can take multiple
 values:
diff --git a/io_u.c b/io_u.c
index c49cd4df..b699169d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1956,7 +1956,8 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%llu\n",
 		io_u->file ? " on file " : "",
 		io_u->file ? io_u->file->file_name : "",
-		strerror(io_u->error),
+		(io_u->flags & IO_U_F_DEVICE_ERROR) ?
+			"Device-specific error" : strerror(io_u->error),
 		io_ddir_name(io_u->ddir),
 		io_u->offset, io_u->xfer_buflen);
 
@@ -1965,8 +1966,10 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	if (td->io_ops->errdetails) {
 		char *err = td->io_ops->errdetails(td, io_u);
 
-		log_err("fio: %s\n", err);
-		free(err);
+		if (err) {
+			log_err("fio: %s\n", err);
+			free(err);
+		}
 	}
 
 	if (!td->error)
diff --git a/io_u.h b/io_u.h
index ab93d50f..22ae6ed4 100644
--- a/io_u.h
+++ b/io_u.h
@@ -22,6 +22,8 @@ enum {
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
 	IO_U_F_PATTERN_DONE	= 1 << 8,
+	IO_U_F_DEVICE_ERROR	= 1 << 9,
+	IO_U_F_VER_IN_DEV	= 1 << 10, /* Verify data in device */
 };
 
 /*
diff --git a/verify.c b/verify.c
index f3d228ba..2e113862 100644
--- a/verify.c
+++ b/verify.c
@@ -901,6 +901,13 @@ int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 	if (td_ioengine_flagged(td, FIO_FAKEIO))
 		return 0;
 
+	/*
+	 * If data has already been verified from the device, we can skip
+	 * the actual verification phase here.
+	 */
+	if (io_u->flags & IO_U_F_VER_IN_DEV)
+		return 0;
+
 	if (io_u->flags & IO_U_F_TRIMMED) {
 		ret = verify_trimmed_io_u(td, io_u);
 		goto done;
