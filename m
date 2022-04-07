Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86B4C433F5
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 17:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiDGRmn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 13:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiDGRmm (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 13:42:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524881F124A
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 10:40:41 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 237ExrkF013331
        for <fio@vger.kernel.org>; Thu, 7 Apr 2022 10:40:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bKMZQ0zfQYoqcWK3jrZK58GC1zRs18VLqioukN44io8=;
 b=Auvb8pDY15D+HftVfU4idScH1F9aTc23x/cFBrRXXhMmwI+i2KkGK4Hc+krwy9qH+UzT
 qmoJkvPNaWMZVh/ojQ/DozZRWWcGWpFEnnav2KSUeA74varOGHDEJH7p9PaOis7wEVaD
 H1yx1Jv7n5pzS9fht0FxpA8PjJ0JL0D472E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3f9bb3k4m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 07 Apr 2022 10:40:40 -0700
Received: from twshared37304.07.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 10:40:38 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id 5788920EC408C; Thu,  7 Apr 2022 10:40:34 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH v3 3/3] iolog: update man page for version 3
Date:   Thu, 7 Apr 2022 10:40:31 -0700
Message-ID: <20220407174031.599117-4-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407174031.599117-1-mogeb@fb.com>
References: <20220407174031.599117-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Z15DZNCOxfZtKzPHvov1fmAqSrvpmULY
X-Proofpoint-GUID: Z15DZNCOxfZtKzPHvov1fmAqSrvpmULY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_03,2022-04-07_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add documentation for iolog version 3, mainly the differences between
versions 2 and 3.

Signed-off-by: Mohamad Gebai <mogeb@fb.com>
---
 HOWTO.rst | 29 ++++++++++++++++++++++++++++-
 fio.1     | 35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0978879c..a5fa432e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4391,33 +4391,60 @@ The `filename` is given as an absolute path. The =
`action` can be one of these:
 The file I/O action format::
=20
     filename action offset length
=20
 The `filename` is given as an absolute path, and has to have been added =
and
 opened before it can be used with this format. The `offset` and `length`=
 are
 given in bytes. The `action` can be one of these:
=20
 **wait**
 	   Wait for `offset` microseconds. Everything below 100 is discarded.
-	   The time is relative to the previous `wait` statement.
+	   The time is relative to the previous `wait` statement. Note that
+	   action `wait` is not allowed as of version 3, as the same behavior
+	   can be achieved using timestamps.
 **read**
 	   Read `length` bytes beginning from `offset`.
 **write**
 	   Write `length` bytes beginning from `offset`.
 **sync**
 	   :manpage:`fsync(2)` the file.
 **datasync**
 	   :manpage:`fdatasync(2)` the file.
 **trim**
 	   Trim the given file from the given `offset` for `length` bytes.
=20
=20
+Trace file format v3
+~~~~~~~~~~~~~~~~~~~~
+
+The third version of the trace file format was added in fio version 3.31=
. It
+forces each action to have a timestamp associated with it.
+
+The first line of the trace file has to be::
+
+    fio version 3 iolog
+
+Following this can be lines in two different formats, which are describe=
d below.
+
+The file management format::
+
+    timestamp filename action
+
+The file I/O action format::
+
+    timestamp filename action offset length
+
+The `timestamp` is relative to the beginning of the run (ie starts at 0)=
. The
+`filename`, `action`, `offset` and `length`  are identical to version 2,=
 except
+that version 3 does not allow the `wait` action.
+
+
 I/O Replay - Merging Traces
 ---------------------------
=20
 Colocation is a common practice used to get the most out of a machine.
 Knowing which workloads play nicely with each other and which ones don't=
 is
 a much harder task. While fio can replay workloads concurrently via mult=
iple
 jobs, it leaves some variability up to the scheduler making results hard=
er to
 reproduce. Merging is a way to make the order of events consistent.
=20
 Merging is integrated into I/O replay and done when a
diff --git a/fio.1 b/fio.1
index 98410655..a2ec836f 100644
--- a/fio.1
+++ b/fio.1
@@ -4110,38 +4110,71 @@ The file I/O action format:
 .RS
 filename action offset length
 .P
 The `filename' is given as an absolute path, and has to have been \fBadd=
\fRed and
 \fBopen\fRed before it can be used with this format. The `offset' and `l=
ength' are
 given in bytes. The `action' can be one of these:
 .RS
 .TP
 .B wait
 Wait for `offset' microseconds. Everything below 100 is discarded.
-The time is relative to the previous `wait' statement.
+The time is relative to the previous `wait' statement. Note that action =
`wait`
+is not allowed as of version 3, as the same behavior can be achieved usi=
ng
+timestamps.
 .TP
 .B read
 Read `length' bytes beginning from `offset'.
 .TP
 .B write
 Write `length' bytes beginning from `offset'.
 .TP
 .B sync
 \fBfsync\fR\|(2) the file.
 .TP
 .B datasync
 \fBfdatasync\fR\|(2) the file.
 .TP
 .B trim
 Trim the given file from the given `offset' for `length' bytes.
 .RE
 .RE
+.RE
+.TP
+.B Trace file format v3
+The third version of the trace file format was added in fio version 3.31=
. It
+forces each action to have a timestamp associated with it.
+.RS
+.P
+The first line of the trace file has to be:
+.RS
+.P
+"fio version 3 iolog"
+.RE
+.P
+Following this can be lines in two different formats, which are describe=
d below.
+.P
+.B
+The file management format:
+.RS
+timestamp filename action
+.P
+.RE
+.B
+The file I/O action format:
+.RS
+timestamp filename action offset length
+.P
+The `timestamp` is relative to the beginning of the run (ie starts at 0)=
. The
+`filename`, `action`, `offset` and `length`  are identical to version 2,=
 except
+that version 3 does not allow the `wait` action.
+.RE
+.RE
 .SH I/O REPLAY \- MERGING TRACES
 Colocation is a common practice used to get the most out of a machine.
 Knowing which workloads play nicely with each other and which ones don't=
 is
 a much harder task. While fio can replay workloads concurrently via mult=
iple
 jobs, it leaves some variability up to the scheduler making results hard=
er to
 reproduce. Merging is a way to make the order of events consistent.
 .P
 Merging is integrated into I/O replay and done when a \fBmerge_blktrace_=
file\fR
 is specified. The list of files passed to \fBread_iolog\fR go through th=
e merge
 process and output a single file stored to the specified file. The outpu=
t file is
--=20
2.30.2

