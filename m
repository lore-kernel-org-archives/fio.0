Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9461E5B79
	for <fio@vger.kernel.org>; Wed, 14 May 2025 07:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747206553; cv=none; b=Qo6UTKwE/Wadp8z2i54C+R7SCSm6kdIrs84HiM+1D29pe+SO2mJ/fw1D04TuzLnqhTJZ0ghSL6rnO7WVQeG15O1507BaC3gxaATKbvK5reRPIAElhln+dbKvykaMbkArsqqwKakYUblccKmxjlOeYEBURc8fhnYRdtPJsVmX9VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747206553; c=relaxed/simple;
	bh=/FU5N+GrptE32EORiXRhgKTCrz8hFOYX1KDASiOQUtk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=q0N0OYGKNw/ZuBpN7E6B89O8f+TnrBDJlo0tKPvYL5+axtQOA9tUYEMSz/cNrbBSfJVEkWUhM6TS6wO0Uyr+X95oT6fcxu4FYc8lOwNw/Y80gBFxixYUNIfWE0ZVo8IUWRPoxjG6ccVjco/pwB+79wdrW2tJqjrpqCymWAxPEf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2Im+h2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2Im+h2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0129C4CEEB;
	Wed, 14 May 2025 07:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747206553;
	bh=/FU5N+GrptE32EORiXRhgKTCrz8hFOYX1KDASiOQUtk=;
	h=From:To:Subject:Date:From;
	b=V2Im+h2zKlzZ1TjKoIaFfUgSp4YxuSeThnbCLyl2/XeYazRN2I34prpeojqTClWRY
	 jDlFGPjGIA98jpvDbyhQtv5tIm4RjP0KMQ9inde5mHaUDalE/xXz7gV6P8sGiuu9np
	 +nKC6VisVslapBtSHoPzCpbcLvSj1sBHjaKwzlkSv+cVjo3nIOucir7aU3AVKQ+7PP
	 fPWQcNL7Y8Gp7+HcivIOQ3S8bFTbp2R/aJnmZ8ivMLs+5xT8YqqAmJGhNriWTIiKMT
	 83Mp3il/hBoJ7CmuASIZi/a/5k0inU4Vpb5OdngHoulS9/iXRB0D7ODy/nme9fdjsJ
	 nNTkhN9t+LEpg==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Vincent Fu <vincentfu@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] configure: Fix libnfs cflags and libs
Date: Wed, 14 May 2025 16:07:54 +0900
Message-ID: <20250514070754.38281-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libnfs version 16 requires the gnutls library. Without specifying at
least -lgnutls, builds fail:

  LINK fio
/usr/bin/ld: /usr/lib/gcc/x86_64-redhat-linux/15/../../../../lib64/libnfs.so: undefined reference to `gnutls_certificate_set_x509_trust_dir'
/usr/bin/ld: /usr/lib/gcc/x86_64-redhat-linux/15/../../../../lib64/libnfs.so: undefined reference to `gnutls_transport_set_int2'
...

Modify the configure script to add cflags and library options for gnutls
to correctly build libnfs engine.

Also make sure that the CI install the gnutls library header files.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes from v1:
 * Modified CI install action as suggested by Vincent

 ci/actions-install.sh | 2 ++
 configure             | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index ad352317..30b815f3 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -32,6 +32,7 @@ DPKGCFG
         libcunit1-dev
         libcurl4-openssl-dev
         libfl-dev
+	libgnutls28-dev
         libnuma-dev
 	libnfs-dev
         valgrind
@@ -106,6 +107,7 @@ install_fedora() {
         bison-devel
         git
         flex-devel
+	gnutls-devel
         gperftools
         isa-l-devel
         kernel-devel
diff --git a/configure b/configure
index 715f0602..986eb0a6 100755
--- a/configure
+++ b/configure
@@ -2361,8 +2361,8 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 if test "$libnfs" != "no" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
-    libnfs_cflags=$(pkg-config --cflags libnfs)
-    libnfs_libs=$(pkg-config --libs libnfs)
+    libnfs_cflags=$(pkg-config --cflags libnfs gnutls)
+    libnfs_libs=$(pkg-config --libs libnfs gnutls)
   else
     if test "$libnfs" = "yes" ; then
       feature_not_found "libnfs" "libnfs"
-- 
2.49.0

