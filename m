Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970009;
	b=JNLVWjcVs8OebUNq6nMwlChIvdAJ3EUtLbCmWhLqZyeHFgW7mxGtzJNm/ax042NW91gz
	 UuuxSf3ByenwRtPiZY06XzVk2rw6pKClUOqyMO8RJTupqJI3bXRMxeHsNsU/PNt1YEO0i
	 AXc59LeeSPnIYTe7CEohWrctGh9YXdVKOy6O51qsUjd4b6nrSlX9bb1cAeNama8RMYTyB
	 KmTMwk5ih+uKYSGkLwZ3XCzZYMGc1KhCxUI8P5gyeg7umT1VI4s1OQaMBatC6on2D8JLE
	 T7gCxmMFop8x7goZnVz22/Qt+ybr8tO5prQoC4qWD7At2eFFB5sNYkQ/CRkmSph8e8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970009;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=ppAmK+HGYqFucZ1xgpKRKBAMcevngGoRsf8+zw1b2m0=;
	b=08jAk6zuW4TuE+1EqR90Vj8jLF16Z6X5zhkAExT+nIfiGiTmVcY+1ZpCm9pXgfYzrl6x
	 nuf/3K8+Pa7fCFVHNpYmWrRSfBS1oxZ5m+UqnBgJ5tyk8FC3SsYq3tCNS+dYj93j1TyCP
	 cV1sXCxDhZTlWJe6Smv9G3vt/HL0sFuF/Qh+xDTqoLpEiSdRXszsBXbmg0S1wLXJ8LNAO
	 E8+wnFbcy+nPwW8NMi6kCEtEklzFgONoVFg+VRXuRUu4syVKPstoJ6pldA4kugmqMtYuj
	 Zic1iDKh2tawDhSnb++bW+RFwKzQ5Ext8t6K2m6WJyWRuFqgXBcSnS3lQo7cZ0kwc6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=pXBCNop6;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514C606A330
	for <fio@vger.kernel.org>; Fri,  6 Nov 2026 13:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8514C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=pXBCNop6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ppAmK+HGYqFucZ1xgpKRKBAMcevngGoRsf8+zw1b2m0=; b=pXBCNop6T1r50pZKlkH/r9s94U
	OD8uE/F5Az2bez+k4Hgc134VkBzhUJYgKS6f6n/VaDChkXXhoc1m7iCUkUCpBD5BBHmM42bDpzd/c
	9FktOaiU7mWn6NPxGrQm3qtWB1XAm1f63n1YLpWJLnaz1lif9wqvXk8ctRD549xL+3QBdiedv7JN1
	TtfvDXL2QpnjeX0+l5mO2PdUiExK+04WBKbpzJsgA2n0DSvvAFX9xk3K03CmRLzZb53EVD7p0qNBu
	bbkom+NrKdN2ZbKEzmauYJlHCWnHHz/ILqU+WBEHIGD4BJ/D2GZ9gNKwlETutqRZAOi9j5qEXLGpW
	IkEisU2Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPJY4-00000003zEV-3leg
	for fio@vger.kernel.org;
	Fri, 06 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9E6051BC0184; Fri,  6 Nov 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri,  6 Nov 2026 06:00:01 -0700
Message-Id: <20261106130001.9E6051BC0184@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 3a4370979fc878d914db27673f2bd7f8b933b8fe:

  Merge branch 'fix-read-iolog-sync-max-bs' of https://github.com/arethusa/fio (2026-11-04 10:30:29 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bfffdcd1ec9ca694c7ce780975f73e9ef0dbfaa2:

  Merge branch 'factor-out-parse-iolog-line' of https://github.com/arethusa/fio (2026-11-05 14:01:15 -0500)

----------------------------------------------------------------
Vincent Fu (4):
      Merge branch 'libnfs-optional-gnutls' of https://github.com/yegorich/fio
      configure: improve lbnfs/gnutls error message
      Merge branch 'ioprio-set-order' of https://github.com/arethusa/fio
      Merge branch 'factor-out-parse-iolog-line' of https://github.com/arethusa/fio

Willy Yang (2):
      iolog: factor out per-version line parsing in read_iolog()
      backend: set thread ioprio before init_iolog()

Yegor Yefremov (1):
      configure: link-test libnfs instead of checking its version for gnutls

 backend.c | 14 +++++++-------
 configure | 40 +++++++++++++++++++++++++++-------------
 iolog.c   | 26 ++++++++++++++++++++++----
 3 files changed, 56 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 8843cdda..e1529d1b 100644
--- a/backend.c
+++ b/backend.c
@@ -2123,13 +2123,6 @@ static void *thread_main(void *data)
 	if (fio_pin_memory(td))
 		goto err;
 
-	/*
-	 * May alter parameters that init_io_u() will use, so we need to
-	 * do this first.
-	 */
-	if (!init_iolog(td))
-		goto err;
-
 	/* ioprio_set() has to be done before td_io_init() */
 	if (fio_option_is_set(o, ioprio) ||
 	    fio_option_is_set(o, ioprio_class) ||
@@ -2145,6 +2138,13 @@ static void *thread_main(void *data)
 		td->ts.ioprio = td->ioprio;
 	}
 
+	/*
+	 * May alter parameters that init_io_u() will use, so we need to
+	 * do this first.
+	 */
+	if (!init_iolog(td))
+		goto err;
+
 	if (td_io_init(td))
 		goto err;
 
diff --git a/configure b/configure
index cb602482..2a2dcd6b 100755
--- a/configure
+++ b/configure
@@ -2439,23 +2439,37 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 # Check if we have libnfs (for userspace nfs support).
 if test "$libnfs" != "no" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
-    libnfs="yes"
     libnfs_cflags=$(pkg-config --cflags libnfs)
     libnfs_libs=$(pkg-config --libs libnfs)
+    cat > $TMPC << EOF
+#include <nfsc/libnfs.h>
 
-    # libnfs >= 6.0.0 on Linux requires gnutls for TLS support
-    libnfs_version=$(pkg-config --modversion libnfs 2>/dev/null)
-    if test -n "$libnfs_version" -a "$targetos" = "Linux" ; then
-      libnfs_major=$(echo $libnfs_version | cut -d. -f1)
-      if test "$libnfs_major" -ge 6 ; then
-        if $(pkg-config gnutls > /dev/null 2>&1); then
-          libnfs_cflags="$libnfs_cflags $(pkg-config --cflags gnutls)"
-          libnfs_libs="$libnfs_libs $(pkg-config --libs gnutls)"
-        else
-          feature_not_found "gnutls" "gnutls (required for libnfs >= 6.0.0)"
-          libnfs="no"
-        fi
+int main(void)
+{
+  struct nfs_context *nfs = nfs_init_context();
+  nfs_destroy_context(nfs);
+  return 0;
+}
+EOF
+    libnfs_found="no"
+    if compile_prog "$libnfs_cflags" "$libnfs_libs" "libnfs"; then
+      libnfs_found="yes"
+    # libnfs >= 6.0.0 may be built with TLS support using gnutls, but
+    # some versions do not list it in their pkg-config file.
+    elif $(pkg-config gnutls > /dev/null 2>&1); then
+      libnfs_cflags="$libnfs_cflags $(pkg-config --cflags gnutls)"
+      libnfs_libs="$libnfs_libs $(pkg-config --libs gnutls)"
+      if compile_prog "$libnfs_cflags" "$libnfs_libs" "libnfs with gnutls"; then
+        libnfs_found="yes"
+      fi
+    fi
+    if test "$libnfs_found" = "yes" ; then
+      libnfs="yes"
+    else
+      if test "$libnfs" = "yes" ; then
+        feature_not_found "libnfs" "libnfs (and gnutls if libnfs was built with TLS)"
       fi
+      libnfs="no"
     fi
   else
     if test "$libnfs" = "yes" ; then
diff --git a/iolog.c b/iolog.c
index 0926053d..166d2fc4 100644
--- a/iolog.c
+++ b/iolog.c
@@ -451,6 +451,25 @@ int64_t iolog_items_to_fetch(struct thread_data *td)
 #define file_act(_td, _r) (((_td)->io_log_version == 3 && (r) == 3) || \
 					((_td)->io_log_version == 2 && (r) == 2))
 
+/*
+ * Parse one line of a version 2 or 3 iolog. Returns the number of fields
+ * parsed, which io_act() and file_act() use to tell file I/O actions from
+ * file management actions.
+ */
+static int parse_iolog_line(struct thread_data *td, const char *p,
+			    unsigned long long *ttime, char *fname, char *act,
+			    unsigned long long *offset, unsigned int *bytes)
+{
+	switch (td->io_log_version) {
+	case 3:
+		return sscanf(p, "%llu %256s %256s %llu %u", ttime, fname, act,
+			      offset, bytes);
+	default: /* version 2 */
+		return sscanf(p, "%256s %256s %llu %u", fname, act, offset,
+			      bytes);
+	}
+}
+
 /*
  * Read version 2 and 3 iolog data. It is enhanced to include per-file logging,
  * syncs, etc.
@@ -488,9 +507,9 @@ static bool read_iolog(struct thread_data *td)
 		int r;
 		unsigned long long ttime;
 
+		r = parse_iolog_line(td, p, &ttime, rfname, act, &offset,
+				     &bytes);
 		if (td->io_log_version == 3) {
-			r = sscanf(p, "%llu %256s %256s %llu %u", &ttime, rfname, act,
-							&offset, &bytes);
 			delay = delay_since_ttime(td, ttime);
 			td->io_log_last_ttime = ttime;
 			/*
@@ -501,8 +520,7 @@ static bool read_iolog(struct thread_data *td)
 					" version 3 for file %s\n", fname);
 				continue;
 			}
-		} else /* version 2 */
-			r = sscanf(p, "%256s %256s %llu %u", rfname, act, &offset, &bytes);
+		}
 
 		if (td->o.replay_redirect)
 			fname = td->o.replay_redirect;
