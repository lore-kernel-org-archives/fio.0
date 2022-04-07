Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F88C43217
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 14:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344287AbiDGOwY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 10:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiDGOwX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 10:52:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE081C8AAC
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 07:50:13 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2370fi0r030650
        for <fio@vger.kernel.org>; Thu, 7 Apr 2022 07:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CLdUANlpiOdHtrZWuUWvfR+1Wq1bzvpEYw2dhc7/lqY=;
 b=Mvj78DN5bHqEbsNDf9DheCdcoo7lBOxPDiLSZTwLdFTYjEVn0MOfU373O3sx3W6cah3W
 UPY5XbLTN/temqRh6KR+ZE7Nt2g48PQF6Q4o88zMPmzdc9nTJIS4t+x4jCsoG+j0YQFX
 qE/tER0f9911VNI0+FngUbiNmeHVDR69emY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f9gmqxqnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 07 Apr 2022 07:50:04 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 07:50:03 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id 2F39120E9FF82; Thu,  7 Apr 2022 07:50:02 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH v2 3/3] iolog: update man page for version 3
Date:   Thu, 7 Apr 2022 07:49:58 -0700
Message-ID: <20220407144958.3975622-4-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407144958.3975622-1-mogeb@fb.com>
References: <20220407144958.3975622-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ASPzJ2JIbgqUy_G975i8uyhDl_Sy6KO7
X-Proofpoint-GUID: ASPzJ2JIbgqUy_G975i8uyhDl_Sy6KO7
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
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0978879c..24d4c7b0 100644
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
+The third version of the trace file format was added in fio version 3.30=
.  It
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
--=20
2.30.2

