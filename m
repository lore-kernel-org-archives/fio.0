Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DAC312803
	for <fio@vger.kernel.org>; Tue, 26 Aug 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209610; cv=none; b=nf6drF2EJQPZPBT5wtclpvkmPtArs141I1ToKqP57q0kydAYzbTiyMQmXaKil80HCvsGkt9WVBGFUL9Muk/hW9DrI24Wsx6kwwNC+qxzC4/zQwvJ03J/pO+slI63BxP+KKIVhjXyKUJpgYyhEIAszHZNkgptrQPbw6NWvRzX+GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209610; c=relaxed/simple;
	bh=JylldFcCH9WZOA7at5wu3PIe08lYwaaCkEqP2TTOgF0=;
	h=Subject:From:To:Message-Id:Date; b=BeCvymauvLE48phpDKeoCzETo3i3fteDzXdMYy66ysL8rgYObmGYeUkpzXFP7ZEVMvJyPYgDGnb12s324BeNfZxHayQCoP4Y/4KC2/r/tRXr1xEBdpYs+WP8Gl3moZJ1YRI8Ctue/nu4S67Nvyaq7GwrtMtmORy0nPsnUUwGhFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hJonqOmy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hJonqOmy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZTC6rbWM3se8I1HDH8q8+ST3U2V8bbF1n/1onqY9gmI=; b=hJonqOmy7xo/W3K3cajca/myge
	83C5Aj/GRNb5Qb0liJ1RxxbcrkVue9VsmbkYAO8/debq8JUqtU6NrwGKw/jN67HGbYBPHsigJoX+p
	epxvZmHOduZbnFiuOi2PvnlsSCtnT5A1J57ZMlMu4fUNvK0q+lrUt/HHxI6fhfK7sDaNQQFvlOtzt
	liRr6HyOVA36qL9Gr1k+tEVE1NMfScjp7L973ZHI1yAn9M70A+P2+hPtu5Z/7dDsoa1JAUOMq0D9c
	i8sgDaou4q5cNnsxcaG5OzIjXqZRBSaRm88beHbRNgAMftyXU/A8ABrH6zRwWCvuI9PM0pSPHvAIS
	5xeu4cJA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqsLM-000000015Vp-0YKv
	for fio@vger.kernel.org;
	Tue, 26 Aug 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A71CF1BC0152; Tue, 26 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250826120001.A71CF1BC0152@kernel.dk>
Date: Tue, 26 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1fb2d4acde3d7e205cf941167c7efad49baf525c:

  verify: use new buffer for threads with %o format (2025-08-22 13:57:09 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2a85ed69d8ef0525b50691aede23f1e10d264634:

  Merge branch 'fix_mandoc_warnings' of https://github.com/sitsofe/fio (2025-08-25 09:51:36 -0400)

----------------------------------------------------------------
Sitsofe Wheeler (3):
      man: fix mandoc lint errors
      man: fix mandoc "PP empty" warnings
      man: update date

Vincent Fu (1):
      Merge branch 'fix_mandoc_warnings' of https://github.com/sitsofe/fio

 fio.1 | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index d9f4fd15..bee06048 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "August 2017" "User Manual"
+.TH fio 1 "May 2025" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -1016,7 +1016,6 @@ that would not result in any difference. \fBidentical\fR behaves in a similar
 fashion, except it sends the same offset 8 number of times before generating a
 new offset.
 .P
-.P
 Example #1:
 .RS
 .P
@@ -1033,7 +1032,6 @@ The generated sequence of offsets will look like this:
 4k, 8k, 12k, 16k, 20k, 24k, 28k, 32k, 92k, 96k, 100k, 104k, 108k, 112k, 116k,
 120k, 48k, 52k ...
 .P
-.P
 Example #2:
 .RS
 .P
@@ -1683,7 +1681,6 @@ Note that by using \fBworking_set\fR the dedupe percentage will converge
 to the desired over time while \fBrepeat\fR maintains the desired percentage
 throughout the job.
 .RE
-.RE
 .TP
 .BI dedupe_working_set_percentage \fR=\fPint
 If \fBdedupe_mode\fR is set to \fBworking_set\fR, then this controls
@@ -1956,15 +1953,14 @@ A job never finishes unless there is at least one non-cpuio job.
 .RS
 .P
 .PD 0
-\fBcpuload\fR\=85 will cause that job to do nothing but burn 85% of the CPU.
+\fBcpuload\fR=85 will cause that job to do nothing but burn 85% of the CPU.
 In case of SMP machines, use \fBnumjobs=<nr_of_cpu>\fR\ to get desired CPU usage,
 as the cpuload only loads a single CPU at the desired rate.
 
 .P
-\fBcpumode\fR\=qsort replace the default noop instructions loop
+\fBcpumode\fR=qsort replace the default noop instructions loop
 by a qsort algorithm to consume more energy.
-
-.P
+.PD
 .RE
 .TP
 .B rdma
@@ -2117,7 +2113,6 @@ instance is used per process, so all jobs setting option \fBthread\fR will share
 a single instance (with one queue per thread) and must specify compatible
 options. Note that some drivers don't allow several instances to access the same
 device or file simultaneously, but allow it for threads.
-.TP
 .RE
 .P
 File/directory operation engines define how the job operates file or directory.
@@ -2158,14 +2153,11 @@ Example job file: dirstat-ioengine.fio.
 Simply delete the directories by rmdir() and do no I/O to them. You need to set \fBfilesize\fP
 and \fBnrfiles\fP, so that the directories will be created.
 This engine is to measure directory delete.
-.TP
-.RE
 .P
 For file and directory operation engines, there is no I/O throughput, then the statistics \
 data in report have different meanings. The meaningful output indexes are: \fBiops\fP and \fBclat\fP. \
 \fBbw\fP is meaningless. Refer to section: "Interpreting the output" for more details.
 .RE
-.P
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2359,7 +2351,6 @@ to specifying \fBfdp\fR=1.
 .TP
 .B streams
 Use Streams directives for write commands.
-.TP
 .RE
 .RE
 .TP
@@ -2627,7 +2618,7 @@ Enabled by default.
 .TP
 .BI (http)http_host \fR=\fPstr
 Hostname to connect to.  HTTP port 80 is used automatically when the value 
-of the \fBhttps\fP parameter is \fRoff\fP, and HTTPS port 443 if it is \Ron\fP.  
+of the \fBhttps\fP parameter is \fBoff\fP, and HTTPS port 443 if it is \fBon\fP.
 A virtual-hosted-style S3 hostname starts with a bucket name, while a 
 path-style S3 hostname does not.  Default is \fBlocalhost\fR.
 .TP
@@ -2638,8 +2629,8 @@ Username for HTTP authentication.
 Password for HTTP authentication.
 .TP
 .BI (http)https \fR=\fPstr
-Whether to use HTTPS instead of plain HTTP. \fRon\fP enables HTTPS;
-\fRinsecure\fP will enable HTTPS, but disable SSL peer verification (use
+Whether to use HTTPS instead of plain HTTP. \fBon\fP enables HTTPS;
+\fBinsecure\fP will enable HTTPS, but disable SSL peer verification (use
 with caution!).  Default is \fBoff\fR.
 .TP
 .BI (http)http_mode \fR=\fPstr
@@ -2758,7 +2749,6 @@ Use Write Zeroes commands for write operations
 .TP
 .B verify
 Use Verify commands for write operations
-.TP
 .RE
 .RE
 .TP
@@ -2774,7 +2764,6 @@ Use Read commands for data verification
 Use Compare commands for data verification.  This option is only valid with
 specific pattern(s), which means it *must* be given with `verify=pattern` and
 `verify_pattern=<pattern>`.
-.TP
 .RE
 .RE
 .TP
@@ -4508,7 +4497,6 @@ to complete one file or directory operation.
 \fBdirstat engine\fP:\tthe time cost to look up an existing directory
 .TP
 \fBdirdelete engine\fP:\tthe time cost to delete a directory
-.TP
 .RE
 .TP
 .B lat
@@ -4549,7 +4537,6 @@ It means how many files or directories can be operated per second.
 \fBdirstat engine\fP:\tnumber of directories can be looked up per second
 .TP
 \fBdirdelete engine\fP:\tnumber of directories can be deleted per second
-.TP
 .RE
 .TP
 .B lat (nsec/usec/msec)
@@ -4939,18 +4926,18 @@ Following this can be lines in two different formats, which are described below.
 The file management format:
 .RS
 timestamp filename action
-.P
 .RE
+.P
 .B
 The file I/O action format:
 .RS
 timestamp filename action offset length
+.RE
 .P
 The `timestamp` is relative to the beginning of the run (ie starts at 0). The
 `filename`, `action`, `offset` and `length`  are identical to version 2, except
 that version 3 does not allow the `wait` action.
 .RE
-.RE
 .SH I/O REPLAY \- MERGING TRACES
 Colocation is a common practice used to get the most out of a machine.
 Knowing which workloads play nicely with each other and which ones don't is
@@ -5040,7 +5027,6 @@ running as a server backend, it will send the job states back to the client for
 safe storage, then execute the remote trigger, if specified. If a local trigger
 is specified, the server will still send back the write state, but the client
 will then execute the trigger.
-.RE
 .P
 .B Verification trigger example
 .RS
