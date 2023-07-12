Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC19CEB64DD
	for <fio@archiver.kernel.org>; Thu, 13 Jul 2023 08:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjGMIpu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjGMIpa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2023 04:45:30 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EA51BFB
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 01:45:18 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230713084516epoutp03d0a8354dbcc86322d868fb6247c8b8d1~xYO96AHbT1419614196epoutp03h
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 08:45:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230713084516epoutp03d0a8354dbcc86322d868fb6247c8b8d1~xYO96AHbT1419614196epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689237916;
        bh=GzZzAJz868BlhA3IOaBQJw6XbZmK7N2OGJXjrUys4g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqdLFd9cEbPSaUlHeoz8jxIj+KrtCGwfV8IBLGUTg16wFXKwYDy+qohu8/LfU1Qhm
         0q+R7jEJAVnbznxGFSRoiUC0pzhmb/YpZ9CwCtvVON6fhaBCj4qW1lQxp9ZcgL4zKs
         eHomzeXAck6h2LbT4hZ9+G8AY/rh1HY+vzQ1Sb+Y=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230713084516epcas5p41f6c767a2224e05682aca3e352f3035f~xYO9omps60112301123epcas5p4a;
        Thu, 13 Jul 2023 08:45:16 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4R1p8V5mj0z4x9Pp; Thu, 13 Jul
        2023 08:45:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.26.06099.899BFA46; Thu, 13 Jul 2023 17:45:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230712050114epcas5p4194863c3b634fc0abab0c5ee3160ced0~xBiD9fUxs1370413704epcas5p4W;
        Wed, 12 Jul 2023 05:01:14 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230712050113epsmtrp17e821c5fb5d05c58313ba25e16025074~xBiD84uHa0214902149epsmtrp1X;
        Wed, 12 Jul 2023 05:01:13 +0000 (GMT)
X-AuditID: b6c32a4b-cafff700000017d3-05-64afb998a404
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.C8.64355.9933EA46; Wed, 12 Jul 2023 14:01:13 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050112epsmtip1c088b602f2d5b54352bc9fc84d6c0c2e~xBiDA_j342840928409epsmtip1C;
        Wed, 12 Jul 2023 05:01:12 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 3/4] fdp: support random placement id selection
Date:   Wed, 12 Jul 2023 15:50:40 +0530
Message-Id: <20230712102041.20283-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712102041.20283-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTXXfGzvUpBuvPslmsufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjcq2yUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
        SCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzrj79idj
        wRftijkXGlgaGK8pdTFyckgImEic3XqXEcQWEtjNKHF+WloXIxeQ/YlRoul5GwtEAsg590Ee
        puHw8yNMEEU7GSX2PP7MBFHUySRxb2kWiM0moC3x6u0N5i5GDg4RAQ2JNXdTQcLMAtkSi04t
        YwaxhQWcJBo/3mcFsVkEVCWWnpzGAlLOK2AjceBgPcQqeYmZl76zg4Q5BWwlPj+yAgnzCghK
        nJz5hAViorxE89bZzBDlt9glti9LhbBdJP7u2QsVF5Z4dXwLO4QtJfGyvw3KzpbY9PAnE4Rd
        IHHkRS9Uvb1E66l+sOOZBTQl1u/ShwjLSkw9tY4JYi2fRO/vJ1CtvBI75sHYqhJ/791mgbCl
        JW6+uwr2lISAh8SGTnZImE1glDg+fw3rBEaFWUi+mYXkm1kImxcwMq9ilEwtKM5NTy02LTDO
        Sy2HR29yfu4mRnBi1PLewfjowQe9Q4xMHIyHGCU4mJVEeFW2rUsR4k1JrKxKLcqPLyrNSS0+
        xGgKDOyJzFKiyfnA1JxXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwen
        VAPTytIig9cPnrCfmO6jxHvXRnHCrLnS633O76r19Lc4vHrjp8jMzb2PEl3+am8XLbRUDNK+
        mBHcn75j9xKLzPD4PXuqhGTmnzljwfgopdTRYr924ctXMxMMKir1xH243MNZ7D8u+fGmZK1S
        7NWdT+Xz73X6bdm+SFvpq4S7beiL7b8+ndtdIuUjuetded7aSa+jWJYGb5iWdkZgiej8Y2Ky
        cg+TSpI8JOYyfitI/r1tuTfnq09zz2y5/f/inlezl257Nr0m2v9kesupewLKhnN15xt0z3tb
        dOngSoNbK5Z37nyhauprl8vs/aP298lwth4+hW15iuvUts+ZX5XctfEvl0J7RU/JnrJtO0uv
        PhZLV2Ipzkg01GIuKk4EAMviaY0VBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnO5M43UpBoeWWFqsufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjeKySUnN
        ySxLLdK3S+DKuPv2J2PBF+2KORcaWBoYryl1MXJySAiYSBx+foSpi5GLQ0hgO6NE07037F2M
        HEAJaYmF6xMhaoQlVv57zg5R084kMbP/FCtIgk1AW+LV2xvMILaIgJbEsXVNbCC9zAL5Etfv
        5YKEhQWcJBo/3gcrZxFQlVh6choLSAmvgI3EgYP1EOPlJWZe+g62lVPAVuLzIyuQsBBQxc8D
        O9lBbF4BQYmTM5+wgNjMQOXNW2czT2AUmIUkNQtJagEj0ypG0dSC4tz03OQCQ73ixNzi0rx0
        veT83E2M4MDVCtrBuGz9X71DjEwcjIcYJTiYlUR4Cw6uShHiTUmsrEotyo8vKs1JLT7EKM3B
        oiTOq5zTmSIkkJ5YkpqdmlqQWgSTZeLglGpgUvzxbuv3QF+n3Tc5+qds1C9RvHz91PLjU3wj
        29sWH6i2X+joIRQTKlglI8KqtS9OOvalk22xzd8iAXFFm46Fx7Jn7jL//8kkc+mST7yh50zb
        A+bMffrr02GrKZ8mKOes71M4pLTi7mk1md1c6dVljh//iMdZZ5068Ohdk2iMLseq6Pz5DuaJ
        Qt99eNe/4ozJTYhc8LH4xun/19eG9j5WntwyS7+A900DUwvXlu1z7fvOMt/6aeR0gufUzIkS
        h7ecW2ez5dC9HYEPwnZUCaRmbpZZ03X/FlvuMUtrp7OpTwvmndl+fNnseQqfrgRx70rJ3B4X
        NnPK0ZfR7NPZM7J/prN9v5Qkbia/QXIPc2fwDCWW4oxEQy3mouJEAG+U7AfLAgAA
X-CMS-MailID: 20230712050114epcas5p4194863c3b634fc0abab0c5ee3160ced0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230712050114epcas5p4194863c3b634fc0abab0c5ee3160ced0
References: <20230712102041.20283-1-ankit.kumar@samsung.com>
        <CGME20230712050114epcas5p4194863c3b634fc0abab0c5ee3160ced0@epcas5p4.samsung.com>
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
index 6e124ce6..49c80d2c 100644
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
 	io_u->dtype = FDP_DIR_DTYPE;
 	io_u->dspec = dspec;
 }
diff --git a/fdp.h b/fdp.h
index 6ecbfcbe..accbac38 100644
--- a/fdp.h
+++ b/fdp.h
@@ -6,6 +6,16 @@
 #define FDP_DIR_DTYPE	2
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

