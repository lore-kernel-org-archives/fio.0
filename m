Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F01B13A24A
	for <fio@vger.kernel.org>; Wed, 17 Apr 2024 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713355213; cv=none; b=rlGV2S5a5ASqq+NYRYUBnGtrAcdT9DfSZG3clgXSxUJvzFNicKOJHiVyaaie7wAnLoSoDIm+Mx/3cipDA2B3wRk0/fUgA0VB7X4S36AYFQBhZn2mDSBEtpztX88EX0vYVJMKLvBe5rEQ/Dw4lPFKY9C+xqppAroW7BuncQXYgno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713355213; c=relaxed/simple;
	bh=Pp/p71/wOMnoHx6Y7kCug5KnCF53iRZVNXoSV2HuYj4=;
	h=Subject:From:To:Message-Id:Date; b=FM9upNd4yJ5masdjROuPqxBPc33gKo0R0T0qMcq9yPRFd7lvhbOkI3/yI4ihIstxeIGk0apIPV/iVOQ7KlZ9IEHyLdPkSMMVc8lT0EVDSdOp3MNjTOzIdJgA7bXcn3oTrjRqwreZun5LYBDjTGJMpMrg1djUdRDADWvRPZTVX2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FVZaoYiL; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FVZaoYiL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CXrpv4lVfI1TnBYt96G8VPRtalMbw8cvnVjKY2QObH8=; b=FVZaoYiLVCJRcJV4mCW6OCOQ3I
	mAdGPbcbexYWdFXylPxldEfN+Yy8t7+0vhJl5Svth1s7cr84OK8RmHcanDM29pSebdw60BQ9e07/q
	76TH98LQZ0Yw7HHG4kyQYwR/hawC95fzmwTBhZIz6qPrcpXXf/GoTPGKXTc7k90/hF+SqOpZDr8f2
	teLc1GysgmW4Lood4Vp8TXNfqzTS/el/m9hJrTwdRc3tTGGo0yas0vVKwekMHdT4UKRpykf48Ki1v
	+Glx8/FKHohGsKyhtjuD6YTJbMk32eQ8ixB392VB2K2IV+913KLHrcFvBU7CIb/pWpqTA5/hxR6mY
	PQyb28Ng==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rx3xN-0000000BWPx-0khf
	for fio@vger.kernel.org;
	Wed, 17 Apr 2024 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 824241BC0147; Wed, 17 Apr 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240417120001.824241BC0147@kernel.dk>
Date: Wed, 17 Apr 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 8bcd4cb42931996575cb4430f3d630810f213434:

  Revert "ioengines: Make td_io_queue print log_err when got error " (2024-04-15 12:26:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5b347a1d4e5fd81b6a1b515843b834c39fb3463d:

  Merge branch 'directory-operation' of https://github.com/friendy-su/fio (2024-04-16 11:04:58 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'directory-operation' of https://github.com/friendy-su/fio

friendy-su (1):
      engines/fileoperations: add more description for file/directory operation engines

 HOWTO.rst | 111 ++++++++++++++++++++++++++++++++++++++++----------------
 fio.1     | 123 ++++++++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 171 insertions(+), 63 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 25fdfbc4..2f108e36 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1992,7 +1992,9 @@ I/O engine
 
 .. option:: ioengine=str
 
-	Defines how the job issues I/O to the file. The following types are defined:
+	fio supports 2 kinds of performance measurement: I/O and file/directory operation.
+
+	I/O engines define how the job issues I/O to the file. The following types are defined:
 
 		**sync**
 			Basic :manpage:`read(2)` or :manpage:`write(2)`
@@ -2177,36 +2179,6 @@ I/O engine
 			absolute or relative. See :file:`engines/skeleton_external.c` for
 			details of writing an external I/O engine.
 
-		**filecreate**
-			Simply create the files and do no I/O to them.  You still need to
-			set  `filesize` so that all the accounting still occurs, but no
-			actual I/O will be done other than creating the file.
-
-		**filestat**
-			Simply do stat() and do no I/O to the file. You need to set 'filesize'
-			and 'nrfiles', so that files will be created.
-			This engine is to measure file lookup and meta data access.
-
-		**filedelete**
-			Simply delete the files by unlink() and do no I/O to them. You need to set 'filesize'
-			and 'nrfiles', so that the files will be created.
-			This engine is to measure file delete.
-
-		**dircreate**
-			Simply create the directories and do no I/O to them.  You still need to
-			set  `filesize` so that all the accounting still occurs, but no
-			actual I/O will be done other than creating the directories.
-
-		**dirstat**
-			Simply do stat() and do no I/O to the directories. You need to set 'filesize'
-			and 'nrfiles', so that directories will be created.
-			This engine is to measure directory lookup and meta data access.
-
-		**dirdelete**
-			Simply delete the directories by rmdir() and do no I/O to them. You need to set 'filesize'
-			and 'nrfiles', so that the directories will be created.
-			This engine is to measure directory delete.
-
 		**libpmem**
 			Read and write using mmap I/O to a file on a filesystem
 			mounted with DAX on a persistent memory device through the PMDK
@@ -2276,6 +2248,50 @@ I/O engine
 			several instances to access the same device or file
 			simultaneously, but allow it for threads.
 
+	File/directory operation engines define how the job operates file or directory. The
+	following types are defined:
+
+		**filecreate**
+			Simply create the files and do no I/O to them.  You still need to
+			set  `filesize` so that all the accounting still occurs, but no
+			actual I/O will be done other than creating the file.
+			Example job file: filecreate-ioengine.fio.
+
+		**filestat**
+			Simply do stat() and do no I/O to the file. You need to set 'filesize'
+			and 'nrfiles', so that files will be created.
+			This engine is to measure file lookup and meta data access.
+			Example job file: filestat-ioengine.fio.
+
+		**filedelete**
+			Simply delete the files by unlink() and do no I/O to them. You need to set 'filesize'
+			and 'nrfiles', so that the files will be created.
+			This engine is to measure file delete.
+			Example job file: filedelete-ioengine.fio.
+
+		**dircreate**
+			Simply create the directories and do no I/O to them.  You still need to
+			set  `filesize` so that all the accounting still occurs, but no
+			actual I/O will be done other than creating the directories.
+			Example job file: dircreate-ioengine.fio.
+
+		**dirstat**
+			Simply do stat() and do no I/O to the directories. You need to set 'filesize'
+			and 'nrfiles', so that directories will be created.
+			This engine is to measure directory lookup and meta data access.
+			Example job file: dirstat-ioengine.fio.
+
+		**dirdelete**
+			Simply delete the directories by rmdir() and do no I/O to them. You need to set 'filesize'
+			and 'nrfiles', so that the directories will be created.
+			This engine is to measure directory delete.
+			Example job file: dirdelete-ioengine.fio.
+
+		For file and directory operation engines, there is no I/O throughput, then the
+		statistics data in report have different meanings. The meaningful output indexes are: 'iops' and 'clat'.
+		'bw' is meaningless. Refer to section: "Interpreting the output" for more details.
+
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -4583,6 +4599,21 @@ writes in the example above).  In the order listed, they denote:
                 commit if available) functions were completed to when the I/O's
                 completion was reaped by fio.
 
+		For file and directory operation engines, **clat** denotes the time
+		to complete one file or directory operation.
+
+		  **filecreate engine**:the time cost to create a new file
+
+		  **filestat engine**:	the time cost to look up an existing file
+
+		  **filedelete engine**:the time cost to delete a file
+
+		  **dircreate engine**:	the time cost to create a new directory
+
+		  **dirstat engine**:	the time cost to look up an existing directory
+
+		  **dirdelete engine**:	the time cost to delete a directory
+
 **lat**
 		Total latency. Same names as slat and clat, this denotes the time from
 		when fio created the I/O unit to completion of the I/O operation.
@@ -4601,12 +4632,30 @@ writes in the example above).  In the order listed, they denote:
 		are on the same disk, since they are then competing for disk
 		access.
 
+		For file and directory operation engines, **bw** is meaningless.
+
 **iops**
 		IOPS statistics based on measurements from discrete intervals.
 		For details see the description for bw above. See
 		:option:`iopsavgtime` to control the duration of the intervals.
 		Same values reported here as for bw except for percentage.
 
+		For file and directory operation engines, **iops** is the most
+		fundamental index to denote the performance.
+		It means how many files or directories can be operated per second.
+
+		  **filecreate engine**:number of files can be created per second
+
+		  **filestat engine**:	number of files can be looked up per second
+
+		  **filedelete engine**:number of files can be deleted per second
+
+		  **dircreate engine**:	number of directories can be created per second
+
+		  **dirstat engine**:	number of directories can be looked up per second
+
+		  **dirdelete engine**:	number of directories can be deleted per second
+
 **lat (nsec/usec/msec)**
 		The distribution of I/O completion latencies. This is the time from when
 		I/O leaves fio and when it gets completed. Unlike the separate
diff --git a/fio.1 b/fio.1
index 545bb872..5fd3603d 100644
--- a/fio.1
+++ b/fio.1
@@ -1794,8 +1794,9 @@ started on the result.
 .SS "I/O engine"
 .TP
 .BI ioengine \fR=\fPstr
-Defines how the job issues I/O to the file. The following types are defined:
-.RS
+fio supports 2 kinds of performance measurement: I/O and file/directory operation.
+
+I/O engines define how the job issues I/O to the file. The following types are defined:
 .RS
 .TP
 .B sync
@@ -1989,36 +1990,6 @@ ioengine `foo.o' in `/tmp'. The path can be either
 absolute or relative. See `engines/skeleton_external.c' in the fio source for
 details of writing an external I/O engine.
 .TP
-.B filecreate
-Simply create the files and do no I/O to them.  You still need to set
-\fBfilesize\fR so that all the accounting still occurs, but no actual I/O will be
-done other than creating the file.
-.TP
-.B filestat
-Simply do stat() and do no I/O to the file. You need to set 'filesize'
-and 'nrfiles', so that files will be created.
-This engine is to measure file lookup and meta data access.
-.TP
-.B filedelete
-Simply delete files by unlink() and do no I/O to the file. You need to set 'filesize'
-and 'nrfiles', so that files will be created.
-This engine is to measure file delete.
-.TP
-.B dircreate
-Simply create the directories and do no I/O to them.  You still need to set
-\fBfilesize\fR so that all the accounting still occurs, but no actual I/O will be
-done other than creating the directories.
-.TP
-.B dirstat
-Simply do stat() and do no I/O to the directory. You need to set 'filesize'
-and 'nrfiles', so that directories will be created.
-This engine is to measure directory lookup and meta data access.
-.TP
-.B dirdelete
-Simply delete directories by unlink() and do no I/O to the directory. You need to set 'filesize'
-and 'nrfiles', so that directories will be created.
-This engine is to measure directory delete.
-.TP
 .B libpmem
 Read and write using mmap I/O to a file on a filesystem
 mounted with DAX on a persistent memory device through the PMDK
@@ -2079,6 +2050,55 @@ instance is used per process, so all jobs setting option \fBthread\fR will share
 a single instance (with one queue per thread) and must specify compatible
 options. Note that some drivers don't allow several instances to access the same
 device or file simultaneously, but allow it for threads.
+.TP
+.RE
+.P
+File/directory operation engines define how the job operates file or directory.
+The following types are defined:
+.RS
+.TP
+.B filecreate
+Simply create the files and do no I/O to them.  You still need to
+set  \fBfilesize\fP so that all the accounting still occurs, but no
+actual I/O will be done other than creating the file.
+Example job file: filecreate-ioengine.fio.
+.TP
+.B filestat
+Simply do stat() and do no I/O to the file. You need to set \fBfilesize\fP
+and \fBnrfiles\fP, so that files will be created.
+This engine is to measure file lookup and meta data access.
+Example job file: filestat-ioengine.fio.
+.TP
+.B filedelete
+Simply delete the files by unlink() and do no I/O to them. You need to set \fBfilesize\fP
+and \fBnrfiles\fP, so that the files will be created.
+This engine is to measure file delete.
+Example job file: filedelete-ioengine.fio.
+.TP
+.B dircreate
+Simply create the directories and do no I/O to them.  You still need to
+set  \fBfilesize\fP so that all the accounting still occurs, but no
+actual I/O will be done other than creating the directories.
+Example job file: dircreate-ioengine.fio.
+.TP
+.B dirstat
+Simply do stat() and do no I/O to the directories. You need to set \fBfilesize\fP
+and \fBnrfiles\fP, so that directories will be created.
+This engine is to measure directory lookup and meta data access.
+Example job file: dirstat-ioengine.fio.
+.TP
+.B dirdelete
+Simply delete the directories by rmdir() and do no I/O to them. You need to set \fBfilesize\fP
+and \fBnrfiles\fP, so that the directories will be created.
+This engine is to measure directory delete.
+.TP
+.RE
+.P
+For file and directory operation engines, there is no I/O throughput, then the statistics \
+data in report have different meanings. The meaningful output indexes are: \fBiops\fP and \fBclat\fP. \
+\fBbw\fP is meaningless. Refer to section: "Interpreting the output" for more details.
+.RE
+.P
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -4236,6 +4256,24 @@ submission to completion of the I/O pieces. For sync I/O, clat will
 usually be equal (or very close) to 0, as the time from submit to
 complete is basically just CPU time (I/O has already been done, see slat
 explanation).
+
+For file and directory operation engines, \fBclat\fP denotes the time
+to complete one file or directory operation.
+.RS
+.TP
+\fBfilecreate engine\fP:\tthe time cost to create a new file
+.TP
+\fBfilestat engine\fP:\tthe time cost to look up an existing file
+.TP
+\fBfiledelete engine\fP:\tthe time cost to delete a file
+.TP
+\fBdircreate engine\fP:\tthe time cost to create a new directory
+.TP
+\fBdirstat engine\fP:\tthe time cost to look up an existing directory
+.TP
+\fBdirdelete engine\fP:\tthe time cost to delete a directory
+.TP
+.RE
 .TP
 .B lat
 Total latency. Same names as slat and clat, this denotes the time from
@@ -4250,12 +4288,33 @@ xlat stats, but also includes the number of samples taken (\fIsamples\fR) and an
 approximate percentage of total aggregate bandwidth this thread received in its
 group (\fIper\fR). This last value is only really useful if the threads in this
 group are on the same disk, since they are then competing for disk access.
+
+For file and directory operation engines, \fBbw\fR is meaningless.
 .TP
 .B iops
 IOPS statistics based on measurements from discrete intervals.
 For details see the description for \fBbw\fR above. See
 \fBiopsavgtime\fR to control the duration of the intervals.
 Same values reported here as for \fBbw\fR except for percentage.
+
+For file and directory operation engines, \fBiops\fP is the most
+fundamental index to denote the performance.
+It means how many files or directories can be operated per second.
+.RS
+.TP
+\fBfilecreate engine\fP:\tnumber of files can be created per second
+.TP
+\fBfilestat engine\fP:\tnumber of files can be looked up per second
+.TP
+\fBfiledelete engine\fP:\tnumber of files can be deleted per second
+.TP
+\fBdircreate engine\fP:\tnumber of directories can be created per second
+.TP
+\fBdirstat engine\fP:\tnumber of directories can be looked up per second
+.TP
+\fBdirdelete engine\fP:\tnumber of directories can be deleted per second
+.TP
+.RE
 .TP
 .B lat (nsec/usec/msec)
 The distribution of I/O completion latencies. This is the time from when
