Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6677F45979
	for <fio@vger.kernel.org>; Sat,  7 Sep 2024 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725710418; cv=none; b=ExWbmnMpdds+nRYYIN8WMQNKdUvvHZbY4wBcW5EtxR6GGkP+/BQJg6YkFuLpHNJ+zHteGFiiodkz0AlVPheU2GvQqHCAAELPZpOlos0QAiI65Tsh3DalG8bdKA0iN5jSRsISKGfB/3R7nGEKeo5HROUwzgQf9379wMqV9XJnsnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725710418; c=relaxed/simple;
	bh=E4VnMEnBfgS1sCDIxHY/i1GduzDsKKHzkuEMYM3Xwpg=;
	h=Subject:From:To:Message-Id:Date; b=Per7TqKaHMBzmHvUiy/VFkbM7hZ8USLWxW8ANM3lnSKzNbZ/prwUeg5WXY7ciNboYMvlhj7FREcc/szzaBXYInsR4jknu69iW4fkHgyopxWabNmIjFHbvPRn/zNw4R9jYH6BPyOnbiJxpC4rXQ3tWz6u/CcVwwlaNZbko4YcMCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Iq9SnOvD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Iq9SnOvD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=HnAbdm7TRGI4R5s+o6hSeIl6337KGKsKgUmfo901PIw=; b=Iq9SnOvDLcDdhE4zk1W6DAPGAL
	eF29iDkxeXf+5e3L55F8Ndnf5QAInfou7mKj+6FpYhYdrC5uJNWlMAeRE0+9FoSD5aWQ2x8GTgnmD
	yzH7jt7dNC3rxwpz+jIFTZ/iHddGgYBB/9fLmotlDZ04Fh/wxKPw0nhMe9EYdMvMf4xiMiblWKd2Q
	UJvQNe9QNwN7ys244i2BSNTWbN0Bset1eU9Q/f+6l6HDaQWXU2d8PO8/2Ox1CUzSNNvpKKoPuc8Em
	+WdhRIVh9Sd9x7s5wjBcgvWInKV48MYKoIc6wSndgZmSvHHpw+qx6uhEcphXHNGG17CYA9osIj/8M
	SlzkRdvw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1smu6l-00000001Rfz-19px
	for fio@vger.kernel.org;
	Sat, 07 Sep 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D60AE1BC0139; Sat,  7 Sep 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240907120001.D60AE1BC0139@kernel.dk>
Date: Sat,  7 Sep 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 65098b11f8aa28e328c225dcd39e3338bb005fdc:

  iolog: add va_end on error (2024-09-05 14:35:30 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f0af0812543d3d9a4019e2979c6e32f479ee70c4:

  Update mailing list details in README.rst (2024-09-06 15:22:48 -0600)

----------------------------------------------------------------
Rebecca Cran (1):
      Update mailing list details in README.rst

Shin'ichiro Kawasaki (2):
      stat: fix the null io_u dereference in add_clat_sample()
      t/jobs/t0035: add test for the file operations IO engine

 README.rst         |  7 +++----
 stat.c             |  7 +++++--
 t/jobs/t0035.fio   | 27 +++++++++++++++++++++++++++
 t/run-fio-tests.py | 10 ++++++++++
 4 files changed, 45 insertions(+), 6 deletions(-)
 create mode 100644 t/jobs/t0035.fio

---

Diff of recent changes:

diff --git a/README.rst b/README.rst
index dd521daf..e672ce64 100644
--- a/README.rst
+++ b/README.rst
@@ -53,11 +53,10 @@ see REPORTING-BUGS.
 
 An automated mail detailing recent commits is automatically sent to the list at
 most daily. The list address is fio@vger.kernel.org, subscribe by sending an
-email to majordomo@vger.kernel.org with
+email to fio+subscribe@vger.kernel.org or visit
+https://subspace.kernel.org/vger.kernel.org.html.
 
-	subscribe fio
-
-in the body of the email. Archives can be found here:
+Archives can be found here:
 
 	https://www.spinics.net/lists/fio/
 
diff --git a/stat.c b/stat.c
index 2cfd6819..c5413f2f 100644
--- a/stat.c
+++ b/stat.c
@@ -3340,8 +3340,11 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (td->clat_log) {
 		struct log_sample sample = { sample_val(nsec), ddir, bs,
-			offset, ioprio,
-			ntime_since(&td->epoch, &io_u->issue_time) };
+			offset, ioprio, 0 };
+
+		if (io_u)
+			sample.issue_time =
+				ntime_since(&td->epoch, &io_u->issue_time);
 
 		add_log_sample(td, td->clat_log, &sample);
 	}
diff --git a/t/jobs/t0035.fio b/t/jobs/t0035.fio
new file mode 100644
index 00000000..fd3488f9
--- /dev/null
+++ b/t/jobs/t0035.fio
@@ -0,0 +1,27 @@
+[global]
+size=4k
+write_lat_log=log
+
+[job1]
+ioengine=filecreate
+filename=t0035file1
+
+[job2]
+ioengine=filestat
+filename=t0035file2
+
+[job3]
+ioengine=filedelete
+filename=t0035file3
+
+[job4]
+ioengine=dircreate
+filename=t0035dir1
+
+[job5]
+ioengine=dirstat
+filename=t0035dir2
+
+[job6]
+ioengine=dirdelete
+filename=t0035dir3
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 47482144..d713c1c4 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -944,6 +944,16 @@ TEST_LIST = [
         'pre_success':      SUCCESS_DEFAULT,
         'requirements':     [Requirements.linux, Requirements.libaio],
     },
+    {
+        'test_id':          35,
+        'test_class':       FioJobFileTest,
+        'job':              't0035.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'pre_success':      SUCCESS_DEFAULT,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
