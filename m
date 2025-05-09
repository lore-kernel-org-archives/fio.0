Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB528C86D
	for <fio@vger.kernel.org>; Fri,  9 May 2025 09:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746784294; cv=none; b=n3o28EyGfAKeou6OiVK+AmcuQwWWBEwul86mYWHL+fKEUuVGGIhiGC87G1GtJvPiXD1UmlKhMNEclQhLsXLKLhwFD2TgaMmTlsCH3Hhph6MOopXhxWbXWauPzOw+CtrNQGZVnT6jlQKo/ZW3V95Q8PTJ61EitK8SofK1Blf8yF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746784294; c=relaxed/simple;
	bh=hbzPB7X4+5AMY2yqd7AU1SQ4x3nUyfmJZ6FWZLYQIjY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tCwArLrl1CjlXUQIVJrf0h0r7taBnBpUjaosK/pN8AX2KxU/O3676sgThdo4ODuzP3drL9J00DhDiM7TyFMp4C5Nkv+5uvASKIgNYorSfksY/tDIOrmrHWKXh9d0uzrbRexy7KJI6OuUtp4ili0jKQgFKLnDALBheAvkljlkrrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH5GUzbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH5GUzbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7100BC4CEE4;
	Fri,  9 May 2025 09:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746784293;
	bh=hbzPB7X4+5AMY2yqd7AU1SQ4x3nUyfmJZ6FWZLYQIjY=;
	h=From:To:Subject:Date:From;
	b=DH5GUzbY5sSbaxbC9JmBPWC/UPpKDBxNV5ltimiKGq/bvbDB0aCcdsdjcnQHach+E
	 2N5UfwbvR5b0vDHipR9nXHr/ViQGzd912bGHLkWEc1keVEUtvp2y6NoiJweK0ymdGv
	 vhPIeIsPc9XwFoJwLXoDKfBTKsfWZPCp0DiKw7m42zgtfXeLV8aw8Aobaui/drQp5r
	 imqDIcVwtRIY4bV13BNKA4qzogC9TfU1px1Ea1+gstJbBk+a/Esb/+URLYjhXwMMnO
	 3oIb6CGO3ig578H6M4mExnQ8W4df0e/tKY5aCxz++EB6OxueGmX28ePbdsmknWfnre
	 I9eLLa7iJsbdA==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Vincent Fu <vincentfu@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] configure: Fix libnfs cflags and libs
Date: Fri,  9 May 2025 18:50:22 +0900
Message-ID: <20250509095022.706951-1-dlemoal@kernel.org>
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

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 configure | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

