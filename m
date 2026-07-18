Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D3D34403A
	for <fio@vger.kernel.org>; Sat, 18 Jul 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784376013; cv=none; b=Wv+rf1YWdmIkzMjehEvZTcS1NyibaRBc7zX+GoV2CG0xqhn2P1+ZT4p79AFNCIik12aEw4Aj9M/qT+TbAuBO9biJCA2u6aRKT7PIcIoEh1j9pwYOud7V9DTVht4JDFP0JHVFf+SV91PdmCQg6/bVo75+i4CilAHMRK/oDPE/UMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784376013; c=relaxed/simple;
	bh=TOpGI32Fbn7/0oLvFlAvowTqaHNbqCPhKsatDLkFSiI=;
	h=Subject:From:To:Date:Message-Id; b=dN4vrls3Hh942maaKGoJfger3vFS9MhRYD4pVI0n0/gktkwRgvZj4o/zfxO5zmLx3MXEN9ez9uER3uJicp4VJyymfUx9/U4eIgdYWUhx+oDLPeuUqMGQNOkYXMXwPZbw5qDKY88hmKsVi4jgLx3Zf6V2NrvoI4DgXO7VzCxS3DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cj8lgbmY; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cj8lgbmY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ETCSOLDjoTPAdgZ0kBK6nS04vVICcdS6kwLVj8TgxMo=; b=Cj8lgbmYoc7mYVQwBKS0oUsNIz
	W8aKUXig3iv3/Xed+yO8BVyu7UouoyVDm1Gu2/hZ8PofyCPhKKZhOyHTGIOeLdQrtT+NNhlNIVCMd
	P6cY60iNfAEkIfGtQf4BffrEa+4+KcWIEU8tgjmZNrenJNyyGa78X/mnlxhaTwquIoCESjITXih/S
	kcIBWEidzJ0eoS3kXUBFnlREdKtHLlrI+FqiLShQthu4U5tbwqIvE6jm2dgtYpU6aMoiVM2bDSn6v
	+nBPPItIhWkZYZFPvSVpLO0PBMagOVrqq4NlaFBuvzIZHL5t//YhgL4oWaLtAInHNwnjhDMc2kecG
	i9RJe7zw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wl3i9-00000006qqx-0kj4
	for fio@vger.kernel.org;
	Sat, 18 Jul 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id BCA801BC0154; Sat, 18 Jul 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 18 Jul 2026 06:00:01 -0600
Message-Id: <20260718120001.BCA801BC0154@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b75f951c8635c0718c4b1b756f649ceb53b68481:

  Merge branch 'prv-y-verify-bytes-issued' of https://github.com/malikoyv/fio (2026-07-15 12:41:48 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cd29b7a64de2d5462a3b72e46d098679ba16b3f1:

  ci: drop Ubuntu container test platforms (2026-07-17 11:43:02 -0400)

----------------------------------------------------------------
Vincent Fu (8):
      test: drop scheduled tests
      ci: switch from Ubuntu 22.04 to 26.04
      fio: fix const char * warning
      fio: resolve const char * compiler warnings
      ci: use newer platforms for container tests
      ci: update platforms for QEMU tests
      ci: update macOS platform from macos-15 to macos-26
      ci: drop Ubuntu container test platforms

 .github/workflows/ci.yml   | 26 +++++++++++---------------
 .github/workflows/qemu.yml |  4 ++--
 ci/actions-build.sh        | 10 +++++++++-
 ci/actions-install.sh      | 23 ++++++++++++++---------
 ioengines.c                | 16 +++++++++++++---
 options.c                  |  2 +-
 parse.c                    |  6 +++---
 server.c                   |  2 +-
 8 files changed, 54 insertions(+), 35 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 2210f971..27ea58fb 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -4,8 +4,6 @@ on:
   push:
   pull_request:
   workflow_dispatch:
-  schedule:
-    - cron: "35 5 * * *"  # 5:35 UTC which is 0:35 ET
 
 jobs:
   build-containers:
@@ -15,13 +13,11 @@ jobs:
       fail-fast: false
       matrix:
         container:
-        - {os: 'debian', dh: 'debian', ver: 'bookworm', target_arch: 'x86_64'}
-        - {os: 'fedora', dh: 'fedora', ver: '40', target_arch: 'x86_64'}
-        - {os: 'alma', dh: 'almalinux', ver: '9', target_arch: 'x86_64'}
-        - {os: 'oracle', dh: 'oraclelinux', ver: '9', target_arch: 'x86_64'}
-        - {os: 'rocky', dh: 'rockylinux', ver: '9', target_arch: 'x86_64'}
-        - {os: 'ubuntu', dh: 'ubuntu', ver: 'noble', target_arch: 'i686'}
-        - {os: 'ubuntu', dh: 'ubuntu', ver: 'noble', target_arch: 'x86_64'}
+        - {os: 'debian', dh: 'debian', ver: 'trixie', target_arch: 'x86_64'}
+        - {os: 'fedora', dh: 'fedora', ver: '44', target_arch: 'x86_64'}
+        - {os: 'alma', dh: 'almalinux', ver: '10', target_arch: 'x86_64'}
+        - {os: 'oracle', dh: 'oraclelinux', ver: '10', target_arch: 'x86_64'}
+        - {os: 'rocky', dh: 'rockylinux/rockylinux', ver: '10', target_arch: 'x86_64'}
 
     container:
       image: ${{ matrix.container.dh }}:${{ matrix.container.ver }}
@@ -59,21 +55,21 @@ jobs:
         - windows-msys2-64
         include:
         - build: linux-gcc
-          os: ubuntu-22.04
+          os: ubuntu-26.04
           cc: gcc
         - build: linux-clang
-          os: ubuntu-22.04
+          os: ubuntu-26.04
           cc: clang
         - build: macos
-          os: macos-15
+          os: macos-26
         - build: linux-i686-gcc
-          os: ubuntu-22.04
+          os: ubuntu-26.04
           arch: i686
         - build: android
-          os: ubuntu-22.04
+          os: ubuntu-26.04
           arch: aarch64-linux-android32
         - build: android-recovery
-          os: ubuntu-22.04
+          os: ubuntu-26.04
           arch: aarch64-linux-android32
         - build: windows-cygwin-64
           os: windows-latest
diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index e01b4061..16d74e29 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -7,7 +7,7 @@ on:
 
 jobs:
   qemu-guest:
-    runs-on: ubuntu-22.04
+    runs-on: ubuntu-26.04
 
     strategy:
       fail-fast: false
@@ -82,7 +82,7 @@ jobs:
             extra_pkgs: sg3-utils
 
     env:
-      DISTRO: debian-12
+      DISTRO: debian-13
       SSHCMD: ssh root@localhost -p 2022
       SCPCMD: scp -P 2022
       CI_TARGET_BUILD: linux
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 861ed3a8..2aecbe85 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -38,6 +38,15 @@ main() {
                     ;;
 	    esac
 	    ;;&
+        */linux | */ubuntu | */debian | */fedora)
+            case "${CI_TARGET_ARCH}" in
+                "x86_64")
+                    configure_flags+=(
+                        "--enable-libiscsi"
+                    )
+                    ;;
+            esac
+	    ;;&
         */linux | */ubuntu | */debian | */fedora | */alma | */oracle | */rocky)
             case "${CI_TARGET_ARCH}" in
                 "i686")
@@ -46,7 +55,6 @@ main() {
                     ;;
                 "x86_64")
                     configure_flags+=(
-                        "--enable-libiscsi"
                         "--enable-libnbd"
                     )
                     ;;
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 6940e5b9..41ab8439 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -79,7 +79,8 @@ DPKGCFG
     # Architecture-independent packages and packages for which we don't
     # care about the architecture.
     pkgs+=(
-        python3-scipy
+	python3-six
+	python3-scipy
 	python3-sphinx
 	python3-statsmodels
 	sudo
@@ -113,7 +114,6 @@ install_fedora() {
         kernel-devel
         libaio-devel
         libibverbs-devel
-        libiscsi-devel
         libnbd-devel
         libnfs-devel
         libpmem-devel
@@ -134,6 +134,7 @@ install_fedora() {
                 cunit-devel
                 libgfapi-devel
                 python3-statsmodels
+                libiscsi-devel
             )
             ;;
         "rocky" | "alma" | "oracle")
@@ -141,18 +142,20 @@ install_fedora() {
                 CUnit-devel
                 python-pip
             )
-            ;;&
-        "rocky" | "alma")
-            pkgs+=(
-                glusterfs-api-devel
-            )
             ;;
     esac
     dnf install -y "${pkgs[@]}"
 }
 
 install_rhel_clone() {
-    dnf install -y epel-release
+    if [ "${CI_TARGET_OS}" == "oracle" ]; then
+        local ver
+        ver="${CI_TARGET_OS_VER}"
+        dnf install -y "oracle-epel-release-el${ver}"
+    else
+        dnf install -y epel-release
+    fi
+
     install_fedora
 
     # I could not find a python3-statsmodels package in the repos
@@ -160,7 +163,9 @@ install_rhel_clone() {
 }
 
 install_oracle() {
-    dnf config-manager --set-enabled ol9_codeready_builder
+    local ver
+    ver="${CI_TARGET_OS_VER}"
+    dnf config-manager --set-enabled "ol${ver}_codeready_builder"
     install_rhel_clone
 }
 
diff --git a/ioengines.c b/ioengines.c
index a2816817..911a286e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -711,6 +711,7 @@ int fio_show_ioengine_help(const char *engine)
 	struct thread_data td;
 	struct ioengine_ops *io_ops;
 	char *sep;
+	char *engine_name;
 	int ret = 1;
 
 	memset(&td, 0, sizeof(struct thread_data));
@@ -724,17 +725,25 @@ int fio_show_ioengine_help(const char *engine)
 		}
 		return 0;
 	}
-	sep = strchr(engine, ',');
+
+	engine_name = strdup(engine);
+	if (!engine_name) {
+		log_err("fio: out of memory\n");
+		return 1;
+	}
+
+	sep = strchr(engine_name, ',');
 	if (sep) {
 		*sep = 0;
 		sep++;
 	}
 
-	td.o.ioengine = (char *)engine;
+	td.o.ioengine = engine_name;
 	td.io_ops = load_ioengine(&td);
 
 	if (!td.io_ops) {
-		log_info("IO engine %s not found\n", engine);
+		log_info("IO engine %s not found\n", engine_name);
+		free(engine_name);
 		return 1;
 	}
 
@@ -744,5 +753,6 @@ int fio_show_ioengine_help(const char *engine)
 		log_info("IO engine %s has no options\n", td.io_ops->name);
 
 	free_ioengine(&td);
+	free(engine_name);
 	return ret;
 }
diff --git a/options.c b/options.c
index a7535e5c..29b86386 100644
--- a/options.c
+++ b/options.c
@@ -34,7 +34,7 @@ static const struct pattern_fmt_desc fmt_desc[] = {
  */
 static char *get_opt_postfix(const char *str)
 {
-	char *p = strstr(str, ":");
+	char *p = (char *)strstr(str, ":");
 
 	if (!p)
 		return NULL;
diff --git a/parse.c b/parse.c
index e2ec4fcc..92de7785 100644
--- a/parse.c
+++ b/parse.c
@@ -484,7 +484,7 @@ static size_t opt_len(const char *str)
 
 	size_t prefix_len = strlen(str);
 	for (i = 0; i < FIO_ARRAY_SIZE(delimiter); i++) {
-		postfix = strchr(str, delimiter[i]);
+		postfix = (char *)strchr(str, delimiter[i]);
 		candidate_len = (size_t)(postfix - str);
 		if (postfix && candidate_len < prefix_len)
 			prefix_len = candidate_len;
@@ -799,7 +799,7 @@ store_option_value:
 		** number of digits after period. Find first
 		** period in entire remaining list each time
 		*/
-		cp2 = strchr(ptr, '.');
+		cp2 = (char *)strchr(ptr, '.');
 		if (cp2 != NULL) {
 			int len = 0;
 
@@ -850,7 +850,7 @@ store_option_value:
 					ret = 0;
 					if (vp->cb)
 						fn = vp->cb;
-					rest = strstr(*cp ?: ptr, ":");
+					rest = (char *)strstr(*cp ?: ptr, ":");
 					if (rest) {
 						if (*cp)
 							*rest = '\0';
diff --git a/server.c b/server.c
index 16ccf52b..34f3f5c0 100644
--- a/server.c
+++ b/server.c
@@ -2702,7 +2702,7 @@ int fio_server_parse_string(const char *str, char **ptr, bool *is_sock,
 	 * If no port seen yet, check if there's a last ',' at the end
 	 */
 	if (!lport) {
-		portp = strchr(host, ',');
+		portp = (char *)strchr(host, ',');
 		if (portp) {
 			*portp = '\0';
 			portp++;
