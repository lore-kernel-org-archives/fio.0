Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F373E9C1D
	for <fio@vger.kernel.org>; Fri, 12 Jun 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265617; cv=none; b=cA0sWKsop3O5dG2Rzt7Hmj6HWw9dMpToCmQsRlWA7TgcUVxwmF3UxZ6JUE+0pLaB6Bq7JVY/0dAt/5fa83JurQkex3/4+zMPJSHoaYu0Z9ydK1/bjn3eHEjMLYRiuNVMxNdbEz4u17enq2HQT0E2W3LhH5bWLQbqG2dP4nwmoYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265617; c=relaxed/simple;
	bh=4ppYJfx+WjTjs5YUs8ut6lZ0QA3rsEEt4X6OK/XL+VQ=;
	h=Subject:From:To:Date:Message-Id; b=dTyhMezkcQVrdTl8o5XPd0qK+TRNpDR9jssWbcfeuPVwwhI1SYJrp+mGsuZg61oQnxqzEveEj5Mj0BpDXUYe/usq2eRlmeA2tBhFf59Qlk8GSzz5JzgM8p5afrOytow8x3h5nEJA7Ibr2a5kCFyYBOB8ib8BxsnESyF0/nB1S/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M+Mf2F43; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M+Mf2F43"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=a4Q1IkEGSeyPSOCR85DfXH7oZ3zhrzDmL2NumYIeGew=; b=M+Mf2F43W7DRgsYfHbSqgG6wgA
	yOoKzsJAGCgR54iiPSDV1VhW6G6NnHfoKex0JrCpx/yq8hViOmzuEiR7uKrZO7Thr41DrtIWcMrZr
	hytDtEfJU9ZZ9o51blObdKIwbYtGgIk6LIhZx8aSWccWsFO6OFOSK1c/cGGZ0jpwT45JwMnGVhW5t
	GnyTo/RiA8mPp1qHmAK+v4AsdZ4SInhu93LBA7YA3om0WJXopsILqLHNe+HL67OaarGZk6etjJvuq
	CMMYQnWDZaSS3ZHmR8bl6oql2sbGPgZ2CJwJMvTY9O3Wu3cCj7ERdBFcW7kk+wjkyIqU0mNSJsRQM
	3Mpc0prA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wY0YP-00000006Nn7-05DT
	for fio@vger.kernel.org;
	Fri, 12 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B32B11BC00FD; Fri, 12 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 12 Jun 2026 06:00:01 -0600
Message-Id: <20260612120001.B32B11BC00FD@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit bd11387aba55e9dc58c0127437c8c6982e6ac32f:

  ci: skip new write uncorrectable tests on QEMU (2026-06-10 22:28:50 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d8380abcb6756d7356961ac496904acc12181bf7:

  Merge branch 'fix/trim-with-do-verify-0' of https://github.com/minwooim/fio (2026-06-10 20:31:50 -0400)

----------------------------------------------------------------
Minwoo Im (1):
      backend: log trim @io_u to io_hist even `do_verify=0`

Vincent Fu (1):
      Merge branch 'fix/trim-with-do-verify-0' of https://github.com/minwooim/fio

 backend.c        | 15 +++++++++++++--
 t/verify-trim.py | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 8ff3bc12..7f41bdfa 100644
--- a/backend.c
+++ b/backend.c
@@ -1315,9 +1315,14 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 		 * Always log IO before it's issued, so we know the specific
 		 * order of it. The logged unit will track when the IO has
 		 * completed.
+		 *
+		 * Trim command is determined by @io_u loggged in the @io_hist
+		 * based on the percentage of the given value to
+		 * --trim_percentage=<%>.  Log @io_u for trim command even in
+		 * --do_verify=0 case.
 		 */
 		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
-		    td->o.do_verify &&
+		    (td->o.do_verify || td->trim_verify) &&
 		    td->o.verify != VERIFY_NONE &&
 		    !td->o.experimental_verify)
 			log_io_piece(td, io_u);
@@ -1911,8 +1916,14 @@ static uint64_t do_dry_run(struct thread_data *td)
 			td->ts.total_io_u[io_u->ddir]++;
 		}
 
+		/*
+		 * Trim command is determined by @io_u loggged in the @io_hist
+		 * based on the percentage of the given value to
+		 * --trim_percentage=<%>.  Log @io_u for trim command even in
+		 * --do_verify=0 case.
+		 */
 		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
-		    td->o.do_verify &&
+		    (td->o.do_verify || td->trim_verify) &&
 		    td->o.verify != VERIFY_NONE &&
 		    !td->o.experimental_verify) {
 			if (!verify_state_should_skip(td, io_u->numberio))
diff --git a/t/verify-trim.py b/t/verify-trim.py
index cd98722a..e95b2709 100755
--- a/t/verify-trim.py
+++ b/t/verify-trim.py
@@ -47,6 +47,7 @@ VERIFY_OPT_LIST = [
     'trim_backlog_batch',
     'trim_verify_zero',
     'number_ios',
+    'do_verify',
 ]
 
 class VerifyTrimTest(FioJobCmdTest):
@@ -208,7 +209,58 @@ TEST_LIST = [
             },
         "test_class": VerifyTrimTest,
     },
-
+    {
+        # do_verify=0: trim must still be issued when trim_percentage=100
+        "test_id": 200,
+        "fio_opts": {
+            "rw": "write",
+            "do_verify": 0,
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # do_verify=0: trim must still be issued when trim_percentage=100
+        "test_id": 201,
+        "fio_opts": {
+            "rw": "randwrite",
+            "do_verify": 0,
+            "trim_percentage": 100,
+            "trim_backlog": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # do_verify=0: trim must still be issued when trim_percentage=50
+        "test_id": 202,
+        "fio_opts": {
+            "rw": "write",
+            "do_verify": 0,
+            "trim_percentage": 50,
+            "trim_backlog": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
+    {
+        # do_verify=0: trim must still be issued when trim_percentage=50
+        "test_id": 203,
+        "fio_opts": {
+            "rw": "randwrite",
+            "do_verify": 0,
+            "trim_percentage": 50,
+            "trim_backlog": 1,
+            "number_ios": 64,
+            "output-format": "json",
+            },
+        "test_class": VerifyTrimTest,
+    },
 ]
 
 
