Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E209EB64DC
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 07:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjGKHpi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 03:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjGKHp3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 03:45:29 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F021724
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 00:45:19 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230711074517epoutp01271754121d73e6975683aef12f9f84ee~wwIBhBJv22178521785epoutp01d
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 07:45:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230711074517epoutp01271754121d73e6975683aef12f9f84ee~wwIBhBJv22178521785epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689061517;
        bh=o51OPJFxDCYKKtm4vBiht5YKFHZxNHj7+lA5+O5xWr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTFGPWTcRImHExNQdj2QfDng66yhOA6bjAGUh9ujqXCKum1pmWQuyWWjvaRfexVad
         2o62uk4okbVmEGUh9pf/j2MRBlYjxR9gvvCpdnz+/FZpfx6Cs6aK6mLPZw6FNrudlS
         qjd+MEnf0+tYppHrqkz3bITAjoRhRhq94EW/CIz0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230711074517epcas5p26079ce7b3dd93e91a75970f30d0af723~wwIA2ppOu2219522195epcas5p2N;
        Tue, 11 Jul 2023 07:45:17 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4R0XwD0qGzz4x9Q0; Tue, 11 Jul
        2023 07:45:16 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.90.57354.B880DA46; Tue, 11 Jul 2023 16:45:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230711073513epcas5p21fedfdc9eb92267970c74ea3df92fe15~wv-OahTZk0873308733epcas5p2H;
        Tue, 11 Jul 2023 07:35:13 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230711073513epsmtrp1ec02ce37ad8b5a6bf7cdec717808e3ab~wv-OZ3AqZ0951509515epsmtrp1T;
        Tue, 11 Jul 2023 07:35:13 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-8c-64ad088b1676
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.7A.64355.1360DA46; Tue, 11 Jul 2023 16:35:13 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230711073512epsmtip1b69d04a7c7004e5c34172e8c0843492e~wv-NfE32D0062900629epsmtip1Z;
        Tue, 11 Jul 2023 07:35:12 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/3] fdp: support random placement id selection
Date:   Tue, 11 Jul 2023 18:24:33 +0530
Message-Id: <20230711125434.14691-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230711125434.14691-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTU7eHY22KwUUdizVXfrNbrL7bz2bx
        cdYLZotJh64xWtztnsFusaFN0IHNY+esu+wel8+Wemxa1cnm0bdlFaPH501yAaxR2TYZqYkp
        qUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QOuVFMoSc0qBQgGJ
        xcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZPbsvsBVc
        1K44trqZpYFxq1IXIyeHhICJRN+ULuYuRi4OIYHdjBLvj61ng3A+MUp8X7eDBc65vuEfK0zL
        yecHWCESOxklPp/ZCtXSySSx/PUCJpAqNgFtiVdvbwAN5uAQEdCQWHM3FSTMLJAtsejUMmYQ
        W1jAXmLz6ZWMIDaLgKrE1q57LCA2r4CNRF/vchaIZfISMy99ZwexOQVsJZZ1LmOCqBGUODnz
        CQvETHmJ5q2zwX6QELjFLnHpcTdUs4vEkU1dUFcLS7w6voUdwpaSeNnfBmVnS2x6+JMJwi6Q
        OPKilxnCtpdoPdUPdj+zgKbE+l36EGFZiamn1jFB7OWT6P39BKqVV2LHPBhbVeLvvdtQJ0hL
        3Hx3Fcr2kNh1uI0RElYTGCVe77jKNoFRYRaSf2Yh+WcWwuoFjMyrGCVTC4pz01OTTQsM81LL
        4bGcnJ+7iRGcJLVcdjDemP9P7xAjEwfjIUYJDmYlEd6Cg6tShHhTEiurUovy44tKc1KLDzGa
        AgN8IrOUaHI+ME3nlcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXA
        5Ov4XjJ+HdNl05WW9/3+rg9si5Za6avwmXNXzvl96pdDji9N0ZJ+UWRk+ahARtbOfeYiwf+7
        l67kUZd+n//tHOdNDoVFfz0Zv7G/tPSTMXpsKXZNU6qFuXXTmt2n3l7M3/BN5KtDdCDb7CjO
        v/Wsx/mPK7iJmltbLDrN2vm07X8WI8+S/b0cwtF/2nMLV5QoFHItsI2+4+Ztyr9r1U9esRVr
        /Nznt01/Me/hmZYLNqn2P1huLzRJaee38i+M+Wi0fuPen6pe9ScdCqoc+y/Our/yXZXTS7X8
        iq9ds++VPGe4aHb3UbztMqnAugaVf9PfZ3IFf+xW8k1ced1EI8K+eWuDk7IB19vkrpsSf/Yr
        sRRnJBpqMRcVJwIAQbkEUhsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSnK4h29oUgyvzeSzWXPnNbrH6bj+b
        xcdZL5gtJh26xmhxt3sGu8WGNkEHNo+ds+6ye1w+W+qxaVUnm0ffllWMHp83yQWwRnHZpKTm
        ZJalFunbJXBl9Oy+wFZwUbvi2OpmlgbGrUpdjJwcEgImEiefH2DtYuTiEBLYzijxc/tE5i5G
        DqCEtMTC9YkQNcISK/89Z4eoaWeSePT0MyNIgk1AW+LV2xvMILaIgJbEsXVNbCC9zAL5Etfv
        5YKEhQXsJTafXglWziKgKrG16x4LiM0rYCPR17ucBWK+vMTMS9/ZQWxOAVuJZZ3LmEBsIaCa
        hWffM0LUC0qcnPkErJ4ZqL5562zmCYwCs5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeu
        l5yfu4kRHLxaQTsYl63/q3eIkYmD8RCjBAezkghvwcFVKUK8KYmVValF+fFFpTmpxYcYpTlY
        lMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1MHJV/j9060HgwnnWjjdDiN8yvRAzqrBNOvHiQ
        sqOvZUaLH7/uUcd1XanGzfs++k/i2b5ml11RIkPWhw9FR0/bctbuMD7UPIPz4Qu/D89OJt/6
        z7p33wbfpgu9YXsi2N/fu3TcTF3cY4NjWG3rHeVJzWo7L83+x3GsI7X38O8FW165ndZnXLrV
        zIzvTdp2PqYO+St8W2xD3TwnFohqB/5yWrB2qmvuwgc/mrw1/9ydeDZlg/i6PSKM/oIRCk1y
        dm6iLe9TE82Wz1kfbWHU0bk7qlryvJFheJxwybRNsdyhJgE7zE4VGLclJyyf3Wjtovt/yaU5
        Wmtqfrv4anK4x3a7sjbM2c1mz1od4n+s/JwSS3FGoqEWc1FxIgAcDnJ2zQIAAA==
X-CMS-MailID: 20230711073513epcas5p21fedfdc9eb92267970c74ea3df92fe15
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711073513epcas5p21fedfdc9eb92267970c74ea3df92fe15
References: <20230711125434.14691-1-ankit.kumar@samsung.com>
        <CGME20230711073513epcas5p21fedfdc9eb92267970c74ea3df92fe15@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Allow user to either roundrobin or select random placement ID from
the available placement IDs.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst        | 15 +++++++++++++++
 fdp.c            | 12 +++++++++---
 fdp.h            | 10 ++++++++++
 fio.1            | 16 ++++++++++++++++
 fio.h            |  2 ++
 init.c           |  2 ++
 options.c        | 20 ++++++++++++++++++++
 thread_options.h |  2 ++
 8 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 2e1e55c2..24789f41 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2435,6 +2435,21 @@ with the caveat that when used on the command line, they must come after the
 
 	Enable Flexible Data Placement mode for write commands.
 
+.. option:: fdp_pli_select=str : [io_uring_cmd]
+
+	Defines how fio decides which placement ID to use next. The following
+	types are defined:
+
+		**random**
+			Choose a placement ID at random (uniform).
+
+		**roundrobin**
+			Round robin over available placement IDs. This is the
+			default.
+
+	The available placement ID index/indices is defined by the option
+	:option:`fdp_pli`.
+
 .. option:: fdp_pli=str : [io_uring_cmd]
 
 	Select which Placement ID Index/Indicies this job is allowed to use for
diff --git a/fdp.c b/fdp.c
index 72afca01..7ac0ab55 100644
--- a/fdp.c
+++ b/fdp.c
@@ -119,10 +119,16 @@ void fdp_fill_dspec_data(struct thread_data *td, struct io_u *io_u)
 		return;
 	}
 
-	if (ruhs->pli_loc >= ruhs->nr_ruhs)
-		ruhs->pli_loc = 0;
+	if (td->o.fdp_pli_select == FIO_FDP_RR) {
+		if (ruhs->pli_loc >= ruhs->nr_ruhs)
+			ruhs->pli_loc = 0;
+
+		dspec = ruhs->plis[ruhs->pli_loc++];
+	} else {
+		ruhs->pli_loc = rand_between(&td->fdp_state, 0, ruhs->nr_ruhs - 1);
+		dspec = ruhs->plis[ruhs->pli_loc];
+	}
 
-	dspec = ruhs->plis[ruhs->pli_loc++];
 	io_u->dtype = 2;
 	io_u->dspec = dspec;
 }
diff --git a/fdp.h b/fdp.h
index 4a5e0e54..86d8d9e6 100644
--- a/fdp.h
+++ b/fdp.h
@@ -5,6 +5,16 @@
 
 #define FDP_MAX_RUHS	128
 
+/*
+ * How fio chooses what placement identifier to use next. Choice of
+ * uniformly random, or roundrobin.
+ */
+
+enum {
+	FIO_FDP_RANDOM	= 0x1,
+	FIO_FDP_RR	= 0x2,
+};
+
 struct fio_ruhs_info {
 	uint32_t nr_ruhs;
 	uint32_t pli_loc;
diff --git a/fio.1 b/fio.1
index 73b7e8c9..0257513b 100644
--- a/fio.1
+++ b/fio.1
@@ -2195,6 +2195,22 @@ file blocks are fully allocated and the disk request could be issued immediately
 .BI (io_uring_cmd)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
+.BI (io_uring_cmd)fdp_pli_select \fR=\fPstr
+Defines how fio decides which placement ID to use next. The following types
+are defined:
+.RS
+.RS
+.TP
+.B random
+Choose a placement ID at random (uniform).
+.TP
+.B roundrobin
+Round robin over available placement IDs. This is the default.
+.RE
+.P
+The available placement ID index/indices is defined by \fBfdp_pli\fR option.
+.RE
+.TP
 .BI (io_uring_cmd)fdp_pli \fR=\fPstr
 Select which Placement ID Index/Indicies this job is allowed to use for writes.
 By default, the job will cycle through all available Placement IDs, so use this
diff --git a/fio.h b/fio.h
index c5453d13..a54f57c9 100644
--- a/fio.h
+++ b/fio.h
@@ -144,6 +144,7 @@ enum {
 	FIO_RAND_POISSON3_OFF,
 	FIO_RAND_PRIO_CMDS,
 	FIO_RAND_DEDUPE_WORKING_SET_IX,
+	FIO_RAND_FDP_OFF,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -262,6 +263,7 @@ struct thread_data {
 	struct frand_state verify_state_last_do_io;
 	struct frand_state trim_state;
 	struct frand_state delay_state;
+	struct frand_state fdp_state;
 
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
diff --git a/init.c b/init.c
index 10e63cca..105339fa 100644
--- a/init.c
+++ b/init.c
@@ -1082,6 +1082,8 @@ void td_fill_rand_seeds(struct thread_data *td)
 
 	init_rand_seed(&td->buf_state, td->rand_seeds[FIO_RAND_BUF_OFF], use64);
 	frand_copy(&td->buf_state_prev, &td->buf_state);
+
+	init_rand_seed(&td->fdp_state, td->rand_seeds[FIO_RAND_FDP_OFF], use64);
 }
 
 static int setup_random_seeds(struct thread_data *td)
diff --git a/options.c b/options.c
index a7c4ef6e..0f739317 100644
--- a/options.c
+++ b/options.c
@@ -3679,6 +3679,26 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group  = FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "fdp_pli_select",
+		.lname	= "FDP Placement ID select",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, fdp_pli_select),
+		.help	= "Select which FDP placement ID to use next",
+		.def	= "roundrobin",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+		.posval	= {
+			  { .ival = "random",
+			    .oval = FIO_FDP_RANDOM,
+			    .help = "Choose a Placement ID at random (uniform)",
+			  },
+			  { .ival = "roundrobin",
+			    .oval = FIO_FDP_RR,
+			    .help = "Round robin select Placement IDs",
+			  },
+		},
+	},
 	{
 		.name	= "fdp_pli",
 		.lname	= "FDP Placement ID indicies",
diff --git a/thread_options.h b/thread_options.h
index a24ebee6..1715b36c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -388,6 +388,7 @@ struct thread_options {
 
 #define FIO_MAX_PLIS 16
 	unsigned int fdp;
+	unsigned int fdp_pli_select;
 	unsigned int fdp_plis[FIO_MAX_PLIS];
 	unsigned int fdp_nrpli;
 
@@ -703,6 +704,7 @@ struct thread_options_pack {
 	uint32_t log_prio;
 
 	uint32_t fdp;
+	uint32_t fdp_pli_select;
 	uint32_t fdp_plis[FIO_MAX_PLIS];
 	uint32_t fdp_nrpli;
 
-- 
2.25.1

