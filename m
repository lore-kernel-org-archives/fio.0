Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF67D3FA5F1
	for <fio@vger.kernel.org>; Thu, 16 Jul 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784203214; cv=none; b=qsE1TcZhTSZy78mH/aG18XytOBQ9yw+TtRt8RIxTpQYNkHjTcJW4uAnaxPeYHzs/Am7LuI8DPneyaK2kvjTYKO2k0gnoErvn5rZcUbe83SLp+wloRgq6u10cWit59zVFj+FvMlI4X5hnXYtaghNOb+SLi2IxVnGmh0r6fMipoSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784203214; c=relaxed/simple;
	bh=SDvWld6QKLC6iKrE3zsQCDm6+YBbe5I0QZ1Cab4Hn0Y=;
	h=Subject:From:To:Date:Message-Id; b=feLVe0IC6V4OM5qmxwfpk0fD9EOjuPjjJC8UZcLeLG9zHhCib+cP/+lLBYVYPmkKTCvWXi58V9JJBGtEAUmSaIiIJfk77vGrP76sPG1j2lBwIgD1cgViXxvIOVkgT7olotLoMtYhLSrlhc29CHagsis9AeU/E4Fsj2l6bKXnbEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RCPZP9tw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RCPZP9tw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=h+ZACND9FgvjQzmy7olZHMyYbCUiL0WQ8iU36KVB7+0=; b=RCPZP9twAguSrziziVcRwOmc7r
	muBIGiGCuVrmw9eYzRjY6KTiP/hUhVPm3Y/sYrxj0z8tXYlj4K2ItGQgG2JbbC1O2Sd5G+vKPO/rr
	RSkiQfLxmcdFyPrVAYd7JQH25t+zL9/vV8wfOVGtTGy1pYurybs7shEAVKBvRXWUJuSnk/aDikUZe
	43SQ396698+0SAoEr6fGMHQjDkYZaWxwWHWCDPhtQVPsp5gWjcgxgsofxINeVXGKfdH0C1kFODtkM
	/4orWKRCIb2ttodLspYdXbT1jqG+hNC6Ab7zPWUGlIV6QLG8R9z6Vc59p6KVqVklkboZwv+P9w/BY
	EC45YPng==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wkKl3-0000000E1NV-0TtL
	for fio@vger.kernel.org;
	Thu, 16 Jul 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 566A71BC014B; Thu, 16 Jul 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 16 Jul 2026 06:00:01 -0600
Message-Id: <20260716120001.566A71BC014B@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 179fb9c335020ab6993ace93d4c2de7487f05a09:

  parse: use signed format specifier for debug print (2026-07-07 16:22:15 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b75f951c8635c0718c4b1b756f649ceb53b68481:

  Merge branch 'prv-y-verify-bytes-issued' of https://github.com/malikoyv/fio (2026-07-15 12:41:48 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'prv-y-verify-bytes-issued' of https://github.com/malikoyv/fio

Yehor Malikov (4):
      backend: stop experimental verify based on bytes issued, not completed
      io_ddir: fix -Wsign-compare in io_ddir_name()
      init: disable write sequence checking for experimental_verify
      verify: add coverage for experimental replay

 backend.c   |  4 +++-
 fio.h       |  1 +
 init.c      |  4 ++++
 io_ddir.h   |  2 +-
 libfio.c    |  1 +
 t/verify.py | 20 ++++++++++++++------
 6 files changed, 24 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 7f41bdfa..35f522e5 100644
--- a/backend.c
+++ b/backend.c
@@ -710,7 +710,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 			}
 		} else {
-			if (td->bytes_verified + td->o.rw_min_bs > verify_bytes)
+			if (td->verify_bytes_prepped + td->o.rw_min_bs > verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
@@ -735,6 +735,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					continue;
 				} else if (io_u->ddir == DDIR_TRIM) {
 					io_u->ddir = DDIR_READ;
+					td->verify_bytes_prepped += io_u->buflen;
 					io_u_set(td, io_u, IO_U_F_TRIMMED);
 					if (td_io_prep(td, io_u)) {
 						put_io_u(td, io_u);
@@ -744,6 +745,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
 					io_u->numberio = td->verify_read_issues;
+					td->verify_bytes_prepped += io_u->buflen;
 					td->verify_read_issues++;
 					populate_verify_io_u(td, io_u);
 					if (td_io_prep(td, io_u)) {
diff --git a/fio.h b/fio.h
index 494959a6..d96ad4d0 100644
--- a/fio.h
+++ b/fio.h
@@ -378,6 +378,7 @@ struct thread_data {
 	uint64_t io_issues[DDIR_RWDIR_CNT];
 	uint64_t verify_read_issues;
 	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
+	uint64_t verify_bytes_prepped;
 	uint64_t loops;
 
 	/*
diff --git a/init.c b/init.c
index d1bf6bfb..7f332417 100644
--- a/init.c
+++ b/init.c
@@ -933,6 +933,10 @@ static int fixup_options(struct thread_data *td)
 				o->verify_write_sequence = 0;
 		}
 
+		if (o->experimental_verify && fio_offset_overlap_risk(td) &&
+		    !fio_option_is_set(o, verify_write_sequence))
+			o->verify_write_sequence = 0;
+
 		/*
 		 * Verify header should not be offset beyond the verify
 		 * interval.
diff --git a/io_ddir.h b/io_ddir.h
index c2b6266a..e3f8cbf7 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -33,7 +33,7 @@ static inline const char *io_ddir_name(enum fio_ddir ddir)
 		[DDIR_WAIT] = "wait",
 	};
 
-	if (ddir >= 0 && ddir < sizeof(name) / sizeof(name[0]) && name[ddir])
+	if (ddir >= 0 && ddir < (int)(sizeof(name) / sizeof(name[0])) && name[ddir])
 		return name[ddir];
 
 	return "invalid";
diff --git a/libfio.c b/libfio.c
index a57ede4f..37f2c749 100644
--- a/libfio.c
+++ b/libfio.c
@@ -97,6 +97,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 			td->last_usec[ddir] = 0;
 		}
 		td->bytes_verified = 0;
+		td->verify_bytes_prepped = 0;
 	}
 
 	td->zone_bytes = 0;
diff --git a/t/verify.py b/t/verify.py
index 4c3d0a3c..00603c17 100755
--- a/t/verify.py
+++ b/t/verify.py
@@ -301,6 +301,19 @@ TEST_LIST_HEADER = [
         "test_class": VerifyTest,
         "success": SUCCESS_DEFAULT,
     },
+    {
+        # Basic test using experimental verify replay
+        "test_id": 2004,
+        "fio_opts": {
+            "ioengine": "libaio",
+            "filesize": "1M",
+            "bs": 4096,
+            "experimental_verify": 1,
+            "output-format": "json",
+            },
+        "test_class": VerifyTest,
+        "success": SUCCESS_DEFAULT,
+    },
 ]
 
 #
@@ -541,12 +554,7 @@ def verify_test_header(test_env, args, csum, mode, sequence):
         {sequential, random w/randommap, random w/norandommap, sequence modifiers}
     """
     for test in TEST_LIST_HEADER:
-        # experimental_verify does not work in verify_only=1 mode
-        if "_vo" in mode and 'experimental_verify' in test['fio_opts'] and \
-        test['fio_opts']['experimental_verify']:
-            test['force_skip'] = True
-        else:
-            test['force_skip'] = False
+        test['force_skip'] = False
 
         test['fio_opts']['verify'] = csum
         if csum in ('pattern', 'pattern_hdr'):
