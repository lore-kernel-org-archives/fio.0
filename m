Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FC1C433EF
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 18:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbiDFSP4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240446AbiDFSPk (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 14:15:40 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF713D17
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 10:05:42 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2366nokI016985
        for <fio@vger.kernel.org>; Wed, 6 Apr 2022 10:05:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7y/tY77g9qcmUqhw479PofiRbdj4mC0j1dUmnev98C0=;
 b=b/YojDS/AiC/t4Y/Ab9MGqu5UWlKjEeqjI6Lo2DWfDi2IT7nQuOgRvT5MxvAAVBY5023
 yznlm4vczsm1QLx7ouAdMOQEPvmqZdNkLmPC1nTST7DJKxqPimcTk1hJ/P88RM13gXAu
 sAqPdHsf2VjzlsqwOl0BG8ErbsoeQH6ZRpE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f8trxqpkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 10:05:42 -0700
Received: from twshared14141.02.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 6 Apr 2022 10:05:40 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id E6C2720D98DB7; Wed,  6 Apr 2022 10:05:33 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH 3/3] iolog: update man page
Date:   Wed, 6 Apr 2022 10:05:30 -0700
Message-ID: <20220406170530.2198263-4-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406170530.2198263-1-mogeb@fb.com>
References: <20220406170530.2198263-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: IPMvJC1NORk_8jtZ1ZGfvrJOr9qJzebR
X-Proofpoint-ORIG-GUID: IPMvJC1NORk_8jtZ1ZGfvrJOr9qJzebR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_09,2022-04-06_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Mohamad Gebai <mogeb@fb.com>
---
 HOWTO.rst | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 0978879c..fffab1ac 100644
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

