Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792670411;
	b=zBj53cQwkm7bSsQcT/dQnZ0uadePxYMNYXUvAk0x14YYgu/AlJ3xU0qX0qPcixL5Xid0
	 WkgrIcwyVNVT/hFzfDXUEOrnTTY0RYRJCi7LgoHifsCewvo2M7nj0LtnbwpEAixbID1x9
	 frl9SqazUtNcZCjoAGwnPaI2oiwELHAbHs3rb3KNwaKZOcbvCjbHDLWctXnFoo5tcPJmo
	 ZeYjkde5+mij+J5J8RaPp7zO+BXfxH0EQMCMjIQBPT3prcO+lYhk8DAZyJ0B410faogvR
	 o+dP09egdSz77LR7XN46AjxzYTwwM6b1EGAXfpVUCcSyvB9ZXKJKlSgCkHSYR9FqWsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792670411;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=+HzdQGmVGQuKA/bxzQFfn5csnWYDNtyg22kkQA/QMLU=;
	b=ShDC5ThUG3uydKcvKLfyp5EV4dPryDKO8f1AXNj3EsOiAR37VM5YccZ3ACFaHvh4Sg5n
	 XoW8msxSjjLjp4qY7IB8EbvtCLJTOipd7efed1MeSPSEDfPVh6awPZLETu96eM9hFcCPX
	 Td+iw5eqcZEnXs5pS1nCY7xHL4ap/MKOtHfnOOZsw/JeU5TFpjHL5AP45gP3+ZUha/us2
	 wZIlWxVObNz8+rr78Qg+muFMH7Frd9GY/5E2Z4rgGeLDFrMlhoSfoiduRA74DD7I8YlzO
	 q3Tsr0KUeB/H0grzVsQk4ddc7kZmE/hktwk7k38VkZ42NuzVESzibMCWFFBI1AYIIfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b="d8/ugsvL";
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E9C606A31F
	for <fio@vger.kernel.org>; Thu, 22 Oct 2026 12:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54E9C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=d8/ugsvL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=+HzdQGmVGQuKA/bxzQFfn5csnWYDNtyg22kkQA/QMLU=; b=d8/ugsvLpg0x6PUJ1v8lLGyyfA
	6z3D+yttQ97K3ZK77IyUZyWs5sscDD5yTPQZVtbNDe3I3u6J5nU6naBBpeMtrQJytKopnjaf8kX/7
	+mVujDSCJo+HV9z9g9MNVLsMw1zDGNmpBfQkf/3lod9n+5m54tHhRe9h3OOVXmerA8fIrlnlH+fir
	JOmyMyUryteBMvrMBQ/9rKOae0VZSYZFjKxCs7OPJIPJj4x4H9EhS5+NNC3nuoCrbn80bhQrbIkJn
	cEqyoi3TDwqj8s/p6otHpKa2CbW6Bic+9dZ5II3c4M73bPkELq0zGtcyAWGUAubFWsked1M2yegUr
	WhoaET1w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xJrSn-0000000720l-3DR5
	for fio@vger.kernel.org;
	Thu, 22 Oct 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 8E2A21BC014D; Thu, 22 Oct 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 22 Oct 2026 06:00:01 -0600
Message-Id: <20261022120001.8E2A21BC014D@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit 4767beef328a257c4300358ffa2901f3e0f1dc68:

  Merge branch 'write_zeries' of https://github.com/panky-codes/fio (2026-10-19 11:57:14 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 80eb2516037c627d77cd7e8a428cb534b830f9b6:

  Merge branch 'configure-libatomic' of https://github.com/kraj/fio (2026-10-21 10:47:54 -0400)

----------------------------------------------------------------
Avri Altman (1):
      fio: reduce scope of multi_range_trim

Khem Raj (1):
      configure: Link with libatomic when 64-bit atomics need it

Vincent Fu (2):
      Merge branch 'multi-range-trim-upstream' of https://github.com/avri-altman-sndk/fio
      Merge branch 'configure-libatomic' of https://github.com/kraj/fio

 configure | 23 +++++++++++++++++++++++
 fio.h     |  8 --------
 io_u.c    |  8 ++++++++
 3 files changed, 31 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 9dfc9b6d..cb602482 100755
--- a/configure
+++ b/configure
@@ -667,6 +667,29 @@ if ! compile_prog "" "" "C11 atomics"; then
   fatal "C11 atomics support not found"
 fi
 
+##########################################
+# check if 64-bit atomics need libatomic
+# The variable is global and the stored value depends on argc so that the
+# compiler cannot optimize the atomic operations away.
+cat > $TMPC <<EOF
+#include <stdatomic.h>
+#include <stdint.h>
+_Atomic uint64_t v;
+int main(int argc, char **argv)
+{
+  atomic_store_explicit(&v, (uint64_t)argc, memory_order_release);
+  return (int)atomic_load_explicit(&v, memory_order_acquire);
+}
+EOF
+libatomic="no"
+if ! compile_prog "" "" "64-bit atomics"; then
+  if compile_prog "" "-latomic" "64-bit atomics with libatomic"; then
+    libatomic="yes"
+    LIBS="-latomic $LIBS"
+  fi
+fi
+print_config "libatomic for 64-bit atomics" "$libatomic"
+
 
 ##########################################
 # check for wordsize
diff --git a/fio.h b/fio.h
index 84d46414..2be348b5 100644
--- a/fio.h
+++ b/fio.h
@@ -646,14 +646,6 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 	 */
 }
 
-static inline bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
-{
-	if (io_u->ddir == DDIR_TRIM && td->o.num_range > 1)
-		return true;
-
-	return false;
-}
-
 static inline bool should_fsync(struct thread_data *td)
 {
 	if (ddir_sync(td->last_ddir_issued))
diff --git a/io_u.c b/io_u.c
index 9a7422bb..7be78d18 100644
--- a/io_u.c
+++ b/io_u.c
@@ -21,6 +21,14 @@ struct io_completion_data {
 	struct timespec time;		/* output */
 };
 
+static bool multi_range_trim(struct thread_data *td, struct io_u *io_u)
+{
+	if (io_u->ddir == DDIR_TRIM && td->o.num_range > 1)
+		return true;
+
+	return false;
+}
+
 /*
  * The ->io_axmap contains a map of blocks we have or have not done io
  * to yet. Used to make sure we cover the entire range in a fair fashion.
