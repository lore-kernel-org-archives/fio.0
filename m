Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E93847AF63
	for <fio@vger.kernel.org>; Thu, 23 Jul 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808014; cv=none; b=JSzONIKX9XFE+i39ZG4Z89PF7wXIA/lqmQwWDO0rhHxI1z+SqJsVnPL4WInezJ/v14MAn8Ivvv30AqAzOTGEixRwzSwmQ+2D3omV1gjbOJ0yk07ugH3SBS8I8sYaxnK2ebOGwTWixJCTwSgNGO6ZErH75xuYqEe/cl1/qPI/1qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808014; c=relaxed/simple;
	bh=zVhk/PyiFd7nSTd4/LQ4eOjHpgKbSDF77F6UctXhHnE=;
	h=Subject:From:To:Date:Message-Id; b=NpF/p7qRk3HiQKnVNYIyoUZpflM5ZKMw5I9wev+DvyvqxmnnraPJJ2X/MBpeaxnJgUYX542wfmSI3nTcsoyfbyyCac3cmo9e5HQC+cMHZa4mYI9kITjc8vpnwtyspytnJLZbFPQMhdPQyFoNzAEjFHb9b6xuC40z7wYrL+JSAGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QKsuqsCn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QKsuqsCn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rpRIWC1odHXyCSzwBs19Pn48E96BWTymkTHkHMn5mr8=; b=QKsuqsCnk9Sc5tkE5rwun+oFJR
	BYj1BI5r6gdTqWH/jD0P/Rn9FhOksRgi9tNA4Qf6zvI7SCRGLTtASozNKy5Ji9OKIJWUUAjqIRpPj
	IyxdEGuZpes9+taHbIkJxxu2mtjHLvbNkFxHxiqCdaht/89djEHl/vnuMjFUCxS9Mmn9vYu615nVn
	Eur4r8uX0n9dEnaNQVTbT/CIEp+768bzopjROSncxjADlHVhfRDzx1NkcW9WcVz2xBl4Ca/yag3lW
	eIr8cFH/0boRRNHLvPG6Ax7D17oiiCgXOXUV61uEtJ7uz1ipl2/mBrcpPaN23aEnZePD8ZgtMQUKc
	jcy45LRg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wms5u-00000001iku-0rae
	for fio@vger.kernel.org;
	Thu, 23 Jul 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 0EA061BC0156; Thu, 23 Jul 2026 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 23 Jul 2026 06:00:02 -0600
Message-Id: <20260723120002.0EA061BC0156@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit cd29b7a64de2d5462a3b72e46d098679ba16b3f1:

  ci: drop Ubuntu container test platforms (2026-07-17 11:43:02 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aa079a649f6df4fbda67fe612e74b0c34cea6dea:

  ci: consolidate QEMU FDP and verify-trim tests (2026-07-22 12:34:16 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      ci: switch QEMU jobs to Debian testing
      ci: add t/io_uring_pi.py to QEMU tests
      ci: consolidate QEMU FDP and verify-trim tests

 .github/actions/create-guest-image/action.yml | 22 ++++++++++++++--------
 .github/actions/start-vm/action.yml           |  5 +++--
 .github/workflows/qemu.yml                    | 27 ++++++++++-----------------
 t/fiotestcommon.py                            |  8 ++++++++
 t/fiotestlib.py                               |  2 +-
 t/io_uring_pi.py                              |  0
 t/run-fio-tests.py                            | 10 ++++++++++
 7 files changed, 46 insertions(+), 28 deletions(-)
 mode change 100644 => 100755 t/io_uring_pi.py

---

Diff of recent changes:

diff --git a/.github/actions/create-guest-image/action.yml b/.github/actions/create-guest-image/action.yml
index 77be3a3c..427fb4dd 100644
--- a/.github/actions/create-guest-image/action.yml
+++ b/.github/actions/create-guest-image/action.yml
@@ -2,10 +2,10 @@ name: 'Create guest image'
 description: 'Create VM guest image on Ubuntu runner'
 
 inputs:
-  distro:
-    description: 'Linux distribution to use for guest image'
+  image_link:
+    description: 'Link to qcow2 cloud image file'
     required: false
-    default: 'debian-12'
+    default: 'https://cloud.debian.org/images/cloud/forky/daily/latest/debian-14-genericcloud-amd64-daily.qcow2'
   extra_pkgs:
     description: 'Extra packages to install for guest image'
     required: false
@@ -23,14 +23,21 @@ runs:
         sudo chmod 0666 /dev/kvm
         ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
       shell: bash
-    - name: Create Debian image
+    - name: Download cloud image
+      run: wget -q ${{ inputs.image_link }} -O debian.qcow2
+      shell: bash
+    - name: Customize Debian image
       run: |
-        virt-builder ${{ inputs.distro }} \
+        virt-customize -a debian.qcow2 \
           --quiet \
           --hostname fio-tester \
           --ssh-inject root \
           --run-command "ssh-keygen -A" \
-          --run-command "sed -i 's/ens2/enp0s2/g' /etc/network/interfaces" \
+          --run-command "echo 'network:' > /etc/netplan/50-cloud-init.yaml" \
+          --run-command "echo '  version: 2' >> /etc/netplan/50-cloud-init.yaml" \
+          --run-command "echo '  ethernets:' >> /etc/netplan/50-cloud-init.yaml" \
+          --run-command "echo '    enp0s2:' >> /etc/netplan/50-cloud-init.yaml" \
+          --run-command "echo '      dhcp4: true' >> /etc/netplan/50-cloud-init.yaml" \
           --append-line '/etc/environment:PYTHONUNBUFFERED=1' \
           --append-line '/etc/environment:GITHUB_SERVER_URL=${{ github.server_url }}' \
           --append-line '/etc/environment:GITHUB_REPOSITORY=${{ github.repository }}' \
@@ -39,7 +46,6 @@ runs:
           --append-line '/etc/environment:GITHUB_JOB=${{ github.job }}' \
           --append-line '/etc/environment:EXTRA_PKGS=${{ inputs.extra_pkgs }}' \
           --append-line '/etc/environment:CI_TARGET_BUILD=${{ env.CI_TARGET_BUILD }}' \
-          --append-line '/etc/environment:CI_TARGET_OS=${{ env.CI_TARGET_OS }}'
+          --append-line '/etc/environment:CI_TARGET_OS=${{ env.CI_TARGET_OS }}' \
 
       shell: bash
-
diff --git a/.github/actions/start-vm/action.yml b/.github/actions/start-vm/action.yml
index ab13aa09..a09465ad 100644
--- a/.github/actions/start-vm/action.yml
+++ b/.github/actions/start-vm/action.yml
@@ -6,7 +6,8 @@ inputs:
     required: false
     default: "qemu-system-x86_64"
   image: # VM image file
-    required: true
+    required: false
+    default: debian.qcow2
   ssh_fwd_port: # forward this host port to the guest's SSH port
     required: false
     default: 2022
@@ -36,7 +37,7 @@ runs:
       run: |
         ${{ inputs.qemu }} \
           -cpu host \
-          -drive file=${{ inputs.image }},format=raw,if=virtio \
+          -drive file=${{ inputs.image }},format=qcow2,if=virtio \
           -enable-kvm \
           -smp $(nproc) \
           -nographic \
diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index 16d74e29..0395cc12 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -13,12 +13,12 @@ jobs:
       fail-fast: false
       matrix:
         include:
-          - config: basic io_uring_cmd tests
+          - config: basic io_uring_cmd and io_uring PI tests
             device: >-
               -device nvme,id=nvme0,serial=deadbeef
               -drive id=nvm-0,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
               -device nvme-ns,id=nvm-0,drive=nvm-0,bus=nvme0,nsid=1
-            test_cmd: "python3 t/run-fio-tests.py --nvmecdev /dev/ng0n1 --run-only 1014 1015 1022 -p '1022:--skip 30 31 32 33 34 40 50 51 53 70'"
+            test_cmd: "python3 t/run-fio-tests.py --nvmebdev /dev/nvme0n1 --nvmecdev /dev/ng0n1 --run-only 1014 1015 1022 1025 -p '1022:--skip 30 31 32 33 34 40 50 51 53 70'"
             extra_pkgs: "nvme-cli"
           - config: 512 16-bit Guard PI tests (long)
             device: >-
@@ -48,41 +48,36 @@ jobs:
               -device nvme-ns,id=nvm-2,drive=nvm-2,bus=nvme2,nsid=1,pif=2,ms=64,mset=1,pi=1,pil=0,logical_block_size=4096,physical_block_size=4096
             test_cmd: "python3 t/nvmept_pi.py --fio ./fio --dut /dev/ng0n1 --lbaf 7"
             extra_pkgs: "nvme-cli"
-          - config: FDP
+          - config: FDP and verify-trim
             device: >-
               -device nvme-subsys,id=nvme-subsys0,fdp=on,fdp.runs=128K,fdp.nrg=8,fdp.nruh=64
               -device nvme,id=nvme0,serial=deadbeef,subsys=nvme-subsys0
               -drive id=nvm-1,file=nvme0.img,format=raw,if=none,discard=unmap,media=disk
               -device nvme-ns,id=nvm-1,drive=nvm-1,bus=nvme0,nsid=1,logical_block_size=4096,physical_block_size=4096,fdp.ruhs=0-63
-            test_cmd: "nvme fdp status /dev/ng0n1 && python3 t/nvmept_fdp.py --fio ./fio --dut /dev/ng0n1"
-            extra_pkgs: "nvme-cli"
-          - config: verify-trim
-            device:
-            test_cmd: "python3 t/verify-trim.py"
-            extra_pkgs: sg3-utils
+            test_cmd: "nvme fdp status /dev/ng0n1 && python3 t/nvmept_fdp.py --fio ./fio --dut /dev/ng0n1 && python3 t/verify-trim.py"
+            extra_pkgs: nvme-cli
           - config: ZBD1-5
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb -s 1 -s 2 -s 3 -s 4 -s 5"
-            extra_pkgs: sg3-utils
+            extra_pkgs: sg3-utils util-linux-extra
           - config: ZBD6-10
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb -s 6 -s 7 -s 8 -s 9 -s 10"
-            extra_pkgs: sg3-utils
+            extra_pkgs: sg3-utils util-linux-extra
           - config: ZBD11-15
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb -s 11 -s 12 -s 13 -s 14 -s 15"
-            extra_pkgs: sg3-utils
+            extra_pkgs: sg3-utils util-linux-extra
           - config: ZBD16-20
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb -s 16 -s 17 -s 18 -s 19 -s 20"
-            extra_pkgs: sg3-utils
+            extra_pkgs: sg3-utils util-linux-extra
           - config: ZBD21-25
             device:
             test_cmd: "./t/zbd/run-tests-against-nullb -s 21 -s 22 -s 23 -s 24 -s 25"
-            extra_pkgs: sg3-utils
+            extra_pkgs: sg3-utils util-linux-extra
 
     env:
-      DISTRO: debian-13
       SSHCMD: ssh root@localhost -p 2022
       SCPCMD: scp -P 2022
       CI_TARGET_BUILD: linux
@@ -100,7 +95,6 @@ jobs:
     - name: Create guest VM image
       uses: ./.github/actions/create-guest-image
       with:
-        distro: ${{ env.DISTRO }}
         extra_pkgs: ${{ matrix.extra_pkgs }}
 
     - name: Build and install QEMU
@@ -112,7 +106,6 @@ jobs:
     - name: Start VM
       uses: ./.github/actions/start-vm
       with:
-        image: ${{ env.DISTRO }}.img
         host_key: true
         options: ${{ matrix.device }}
 
diff --git a/t/fiotestcommon.py b/t/fiotestcommon.py
index 04dfb91f..eee9b9ae 100644
--- a/t/fiotestcommon.py
+++ b/t/fiotestcommon.py
@@ -65,6 +65,7 @@ class Requirements():
     _unittests = False
     _cpucount4 = False
     _nvmecdev = False
+    _nvmebdev = False
 
     def __init__(self, fio_root, args):
         Requirements._not_macos = platform.system() != "Darwin"
@@ -107,6 +108,7 @@ class Requirements():
 
         Requirements._cpucount4 = multiprocessing.cpu_count() >= 4
         Requirements._nvmecdev = args.nvmecdev if hasattr(args, 'nvmecdev') else False
+        Requirements._nvmebdev = args.nvmebdev if hasattr(args, 'nvmebdev') else False
 
         req_list = [
                 Requirements.linux,
@@ -120,6 +122,7 @@ class Requirements():
                 Requirements.unittests,
                 Requirements.cpucount4,
                 Requirements.nvmecdev,
+                Requirements.nvmebdev,
                     ]
         for req in req_list:
             value, desc = req()
@@ -179,3 +182,8 @@ class Requirements():
     def nvmecdev(cls):
         """Do we have an NVMe character device to test?"""
         return Requirements._nvmecdev, "NVMe character device test target required"
+
+    @classmethod
+    def nvmebdev(cls):
+        """Do we have an NVMe block device to test?"""
+        return Requirements._nvmebdev, "NVMe block device test target required"
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 2049e41e..f842cf75 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -430,7 +430,7 @@ def run_fio_tests(test_list, test_env, args):
             exe_path = os.path.join(test_env['fio_root'], config['exe'])
             parameters = []
             if config['parameters']:
-                parameters = [p.format(fio_path=test_env['fio_path'], nvmecdev=args.nvmecdev)
+                parameters = [p.format(fio_path=test_env['fio_path'], nvmecdev=args.nvmecdev, nvmebdev=args.nvmebdev)
                               for p in config['parameters']]
             if Path(exe_path).suffix == '.py' and platform.system() == "Windows":
                 parameters.insert(0, exe_path)
diff --git a/t/io_uring_pi.py b/t/io_uring_pi.py
old mode 100644
new mode 100755
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 47d1e65e..c2f73edb 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1171,6 +1171,14 @@ TEST_LIST = [
         'success':          SUCCESS_DEFAULT,
         'requirements':     [],
     },
+    {
+        'test_id':          1025,
+        'test_class':       FioExeTest,
+        'exe':              't/io_uring_pi.py',
+        'parameters':       ['-f', '{fio_path}', '--dut', '{nvmebdev}'],
+        'success':          SUCCESS_DEFAULT,
+        'requirements':     [Requirements.linux, Requirements.nvmebdev],
+    },
 ]
 
 
@@ -1196,6 +1204,8 @@ def parse_args():
                         help='pass-through an argument to an executable test')
     parser.add_argument('--nvmecdev', action='store', default=None,
                         help='NVMe character device for **DESTRUCTIVE** testing (e.g., /dev/ng0n1)')
+    parser.add_argument('--nvmebdev', action='store', default=None,
+                        help='NVMe block device for **DESTRUCTIVE** testing (e.g., /dev/nvme0n1)')
     parser.add_argument('-c', '--cleanup', action='store_true', default=False,
                         help='Delete artifacts for passing tests')
     args = parser.parse_args()
