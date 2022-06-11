Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75971C43334
	for <fio@archiver.kernel.org>; Sat, 11 Jun 2022 07:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiFKHeo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 11 Jun 2022 03:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiFKHeh (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 11 Jun 2022 03:34:37 -0400
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DA7DD0FB
        for <fio@vger.kernel.org>; Sat, 11 Jun 2022 00:34:34 -0700 (PDT)
Received: from pps.filterd (m0209319.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B7YXTZ009308
        for <fio@vger.kernel.org>; Sat, 11 Jun 2022 07:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=S1; bh=WbbE3gMMyqvcXgf7jir9U667pSWcTp13Z03MdIgoltQ=;
 b=Fb8GPtxyCAOdxi8t91DWRIGFqyTMOKPur9q5iONc7wdeOlHekgm9iCKGDb1SRAGr6A+8
 nteKFxVMqOebq0rUJl3rp0PGTFpbBM3omoQtOrCMtSKO3E9WpSQ2PGD46mOiHKrnq1sX
 sNHOS73ShZQ4Rt+zz/v6biQtDvt/wQ7j2zd/ELo2eFH8Dviu/gCTF/m1vslkGlXhM7wO
 zWgDqN7AQIJMuaamPe0dwgtH0HlGY/l/Z7fiwpwshD3MTvOlBRLR/VInJdcEAz4285D+
 QSAE0BPb/HkNDcHY0Ygzef+yUcqGQoBoOWyirgYnAHevXNtAKhAUY7hrSVjNe7drklt0 pw== 
Received: from apc01-psa-obe.outbound.protection.outlook.com (mail-psaapc01lp2041.outbound.protection.outlook.com [104.47.26.41])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3gmkes836r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Sat, 11 Jun 2022 07:34:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXXIGJ1xLyvxpMe8y/Yj5N+DddjFl8bb70ygFVOJIAFlCxrjalSsak4lYNJlvoz/a8JM9ZHPnXQdr/bOIMwBU8h4GMBxg1Co+4lUBHlZcjt5ElMfD1AkJfvpy2gMAVgycI5sSo7oMn22qV8EFRMKNe+x9xhrV6kxSqhh5dH593CFxI+s+ZPv0h9m5IdeUmp1e8OK4OzbmONCDkL/KX9qXMS/V7xkEtOKkfGsX7PoZqYtbn89AxLFzW9xWC+J7w5g9vslaAf4Mz5U4jp8z/+LyFphAjPpbeESQlu3mRrujxE8lvhCAnlVXxONwYey/pGN3qr8n2kUY37AYsbgZNDMRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbbE3gMMyqvcXgf7jir9U667pSWcTp13Z03MdIgoltQ=;
 b=k6ur6G+D3vSvljcD8FbxRtTolUExc/ICq9lCnfhF9P2BtEEtTHHb2lcS+YInzW/CxnjKWD8VOwm4khnxaKUopKQ5MdO2rPe7BYa9qmpBr1uyDyW1IFasSzJCOLFJrTS3/yPUUIFARE+SoJldmhwkUPi4FIQLxeP7y1/3tYYn/4YclFFLsQGLPd+7dvoRfgT3XUU1jsli87JzULEynlFkaBnGJkpR9QGhFxtzPyxyXFYOvQHzzmGLdzVXpJUQ8rUYR7j/l2oG3Uonildv0gnINb8hZssjIzzh3zcHFGnTfEMcEnq6YaW8EBbckJcbOtj1PEHDbg6k2lQMGM6kVYDvDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by KL1PR0401MB5533.apcprd04.prod.outlook.com (2603:1096:820:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 07:34:22 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::b975:c618:a553:56a3]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::b975:c618:a553:56a3%5]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 07:34:22 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     fio <fio@vger.kernel.org>
CC:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
Subject: [PATCH] engines: add engine for directory create
Thread-Topic: [PATCH] engines: add engine for directory create
Thread-Index: Adh9Zadb9x5EFX0pQZqAz8T1ID5Mag==
Date:   Sat, 11 Jun 2022 07:34:22 +0000
Message-ID: <HK0PR04MB23884338D98BC24EB547AB9BFDA99@HK0PR04MB2388.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ddbfe5c-a39d-4002-7217-08da4b7ccdcb
x-ms-traffictypediagnostic: KL1PR0401MB5533:EE_
x-microsoft-antispam-prvs: <KL1PR0401MB55331F6E6EA9CBC2944BA9CAFDA99@KL1PR0401MB5533.apcprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sc31Zmv+c+EV9DMthrowe8DUmAdZ824c5Kn3LksYDKKvlZF5LpJdCBbdYvAxCZX1e+Pcg5zOtw4D/v+CAf/BnsyxeZiAH4nYvKvc0LUull0yVkoHCEKFjC8M1mfhjWoxBcnXjPs4ALCJ4ALsKDIq6WuqO6t9zk8tAanpGRhKheLV+3zu6V1mI80gRLW20SC+lmd8vFmGDGtajE57YMFWu4xBIHPs2hSyc5ioplO3eejmiOsDMMY0tnz+GCEQSPpTFFFVaagU57kdkTf6pAZpYByzf1g5NdW0Ve2ycPus0FP+7ND8PbZ2Kq/JGDlawih0xnstEc1qdV1q3TzVAp5FiqPFYV3X70dh95qOg1A0rfEidUf/QTTJbtwcA+SBQHhhOLP7Rd67QD5Cn5vryZzb+zZTU6Zd6UCX41NZct7SDY8JXJKJVI9aRkmPaEK126Ej6iZhwz03/0Se6mEqWrOeBWsEbP2khGW0kryPhen68g+QABGczAUhrxRBoncMSgxU+sF9Qz1rYoAk4E/1pAoNEt3w3hBd/QjT5rtIqYUdWIVsJmrLzvDvgSjwHW0C3FQEuRYB8ONGK9dGj9aXxEwLb2L9FcxsQwIbNp1NKdyTElnW/zuZ6htPYm8MRDb4KZyTWOLZAXWn3zab7lKzYcW4CCB4zT/ZT1SHkCOufn5UJDYrjLu+hjMDPu6+OuWgL3aCGSyl/Z2h5YF+HKa/DRf9VQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(26005)(9686003)(38100700002)(107886003)(7696005)(6506007)(33656002)(2906002)(5660300002)(55016003)(8936002)(52536014)(122000001)(508600001)(76116006)(66946007)(4326008)(86362001)(8676002)(66476007)(66556008)(64756008)(66446008)(38070700005)(83380400001)(82960400001)(71200400001)(186003)(54906003)(6916009)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LmmDo7+MnQVWhE5BFt0QoyR2vPLbsSTvmIr3ceriou6iha4QeitedUHQtEgz?=
 =?us-ascii?Q?iqv26n7pnENtNbWODkp59EUeGN3/m+Uk3Yo0swcPi7fje3JaYSKmhtLZ9jpA?=
 =?us-ascii?Q?cVSgR5YPugA5nAtFnDhyoL8Mj7kcxJ/7XAf5hzsOLwXMu2G8gbe75XnbgMmR?=
 =?us-ascii?Q?ccru/PNSZStHSx0xmAJcUHYceC/KHTpa8of80tyoBFa3eokaziVvQZklLNnP?=
 =?us-ascii?Q?cSfX0h5Bv7GrFsQqJvAlfjrnZb8sDdLFg8WTYwJAjDcMAJBNAV51OBIIgpFh?=
 =?us-ascii?Q?I+mPNvErEnYXVRn5yiyMHsDwh3b7vuZqWPIoXNMb8rpu/44ZcTFYXCeSOv1I?=
 =?us-ascii?Q?TZb+VW7gpDD/y2jGeWPxqRF/MUHpUucF368xUFtnfJ6lD9r/Qb/kLFjQUa1j?=
 =?us-ascii?Q?epPb4UGhsTOya6ZVtOrnJsdF59L/7mdcWlDRYnERdgM2zgAdnf6GkbFVQNkC?=
 =?us-ascii?Q?IM1/sck+nBAxtvVnjYbWW8/caEVq4gFQgFR39QLHbq2oR2OtNpbNRtc38Cqu?=
 =?us-ascii?Q?RJlkT7w2vifVBuWIujVP7e7nzGQHlOobT1qNHlTOIA36w6IQ9E4w1YETQu2W?=
 =?us-ascii?Q?LfdxjNN5jSzY6/jHPT6zd9Wl8d3E4DZXil0znQCJZ8tcejTlz36AF88QX7ZQ?=
 =?us-ascii?Q?gxVFy6DOrR0OsJroKSe0EjRMFKUiXx0UIt5e+hgaUGBsi8DFHmqaKapRKGXT?=
 =?us-ascii?Q?V6eoOYuF8t85duGsfJ8HPeW00CSqbcfLCTt5lsL2BXbxnau/aK9QLW7ax485?=
 =?us-ascii?Q?z5FFdG1S5J+M2mpkxyxwwrLCBu8pxJdNOzhEvNUD2tgcv+7gf8FGNwUxUFzZ?=
 =?us-ascii?Q?HOQB7nUkXV5rWZdDuPAS/c37Jnbl/4ZJY8F4Tl3qF6VOQQBNd6mkTIgZiS6J?=
 =?us-ascii?Q?Jqz2fA2eodSTSNhdI8K/5l33aLnjtKGCfxuN8dYBlCLmCHYKzwencp3Xrpb3?=
 =?us-ascii?Q?aXyyKtZz8sWWiE7VzS+oNNDhDwQ35txCPiJkOnzBu8c7CmT5XQ7aMA7Gk2Cb?=
 =?us-ascii?Q?NKleVUZzi07+H+PcSvhV9J5kfNHPBfHTOzC8eiJwXhkh3mc4mk/v2gsz+Llp?=
 =?us-ascii?Q?walmccGcY7oE41fxa24UUHBg8l+axfBvKlcLMa0pYBb7YEelOvSjHGNDeFjD?=
 =?us-ascii?Q?o6e2nMDRQOJeyF+kEotgRu3MEqrXvw3EWNR5o6xXfKnN+3kwjOsrQ5LbYVf8?=
 =?us-ascii?Q?CrmUm3yWfJVnWI4RyiGdi8rlrd8OWDMrY3TtCPF+WbdGA76M2nDf8cHM6uTe?=
 =?us-ascii?Q?89l9eU/yl5CdrBd6XlOnmQ/ccsbBpMj1Go3sLZG4DGK0mWBjbm4Lot+AHwm6?=
 =?us-ascii?Q?dc0sQsjNAZIs6LuRGHVvcNGr45US8ejfV33eaA3yt3AB3GDquBe+ZI+Fr4iS?=
 =?us-ascii?Q?UTGpPLG+WsUyHGpn2sMc6gwsaeZHhrNZzlpmdP8CRYw8nPWQyA+qC/OZYChW?=
 =?us-ascii?Q?9/WxlM1itFPeR+wtcNTF0+9OuXXR9GVrVzFwKvoSINaG49rIMXXCIT2dPD/A?=
 =?us-ascii?Q?B5fclopjkzRwWDJIpce8rG8GOwVu4THRQdc3696R5mhVqHIE6654Diikdjvp?=
 =?us-ascii?Q?HPGLbNWPzGT2Wve3R7ad7Srhy0u6P560JiAvthtm1jgogIRXTyPVxCKuJSIV?=
 =?us-ascii?Q?PFsW24rPSqKy4gotgJXFLnPqgqWPD1lhEqyaqSgsB2rA45BCkyB5+fRjIaPy?=
 =?us-ascii?Q?5PZp/yOZH56iHusoW/WKwU7A7GxO6+3s8i9dD5Mfx8jOvQg3Ro52Kn66E5pY?=
 =?us-ascii?Q?TqcVitdlzQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddbfe5c-a39d-4002-7217-08da4b7ccdcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 07:34:22.6880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ohi/MnicKxaZ8yH+SIanEFfuWeUbliNe5XsZv+X+km8pnYoqI6DJNJtD3kJqrCTx7VZhAaB2vIPUyNFBX2Fo4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0401MB5533
X-Proofpoint-GUID: SFiVeTXTBnsgdFzRdRm5CYQRSELCYf1L
X-Proofpoint-ORIG-GUID: SFiVeTXTBnsgdFzRdRm5CYQRSELCYf1L
X-Sony-Outbound-GUID: SFiVeTXTBnsgdFzRdRm5CYQRSELCYf1L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-11_03,2022-06-09_02,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


This engine is to measure performance of creating directories.

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 HOWTO.rst                       |   6 ++
 Makefile                        |   2 +-
 engines/dircreate.c             | 131 ++++++++++++++++++++++++++++++++
 examples/dircreate-ioengine.fio |  36 +++++++++
 fio.1                           |   5 ++
 5 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 engines/dircreate.c
 create mode 100644 examples/dircreate-ioengine.fio

diff --git a/HOWTO.rst b/HOWTO.rst
index 28ac2b7c..d7ce45da 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2121,6 +2121,12 @@ I/O engine
 			set  `filesize` so that all the accounting still occurs, but no
 			actual I/O will be done other than creating the file.
=20
+		**dircreate**
+			Simply create the directories and do no I/O to them. You still need to
+			set  `filesize` so that all the accounting still occurs, but no
+			actual I/O will be done other than creating the directory.
+			This engine is to measure the performance of creating directories.
+
 		**filestat**
 			Simply do stat() and do no I/O to the file. You need to set 'filesize'
 			and 'nrfiles', so that files will be created.
diff --git a/Makefile b/Makefile
index 188a74d7..2894f874 100644
--- a/Makefile
+++ b/Makefile
@@ -56,7 +56,7 @@ SOURCE :=3D	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(=
SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/file=
delete.c \
+		engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/file=
delete.c engines/dircreate.c \
 		engines/exec.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
diff --git a/engines/dircreate.c b/engines/dircreate.c
new file mode 100644
index 00000000..933fc336
--- /dev/null
+++ b/engines/dircreate.c
@@ -0,0 +1,131 @@
+/*
+ * directory create engine
+ *
+ * IO engine that doesn't do any IO, just creates directories and tracks t=
he latency
+ * of the directory creation.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include "../fio.h"
+
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
+static int make_directory(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+
+	dprint(FD_FILE, "create dir %s\n", f->file_name);
+
+	if (f->filetype !=3D FIO_TYPE_FILE) {
+		log_err("fio: only normal directories are supported\n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	f->fd =3D mkdir(f->file_name, 0600);
+
+	if (f->fd =3D=3D -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e =3D errno;
+
+		snprintf(buf, sizeof(buf), "mkdir(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data =3D td->io_ops_data;
+		uint64_t nsec;
+
+		nsec =3D ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+	}
+
+	return 0;
+}
+
+static enum fio_q_status queue_io(struct thread_data *td,
+				  struct io_u fio_unused *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+/*
+ * Ensure that we at least have a block size worth of IO to do for each
+ * file. If the job file has td->o.size < nr_files * block_size, then
+ * fio won't do anything.
+ */
+static int get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	f->real_file_size =3D td_min_bs(td);
+	return 0;
+}
+
+static int init(struct thread_data *td)
+{
+	struct fc_data *data;
+
+	data =3D calloc(1, sizeof(*data));
+
+	if (td_read(td))
+		data->stat_ddir =3D DDIR_READ;
+	else if (td_write(td))
+		data->stat_ddir =3D DDIR_WRITE;
+
+	td->io_ops_data =3D data;
+	return 0;
+}
+
+static void cleanup(struct thread_data *td)
+{
+	struct fc_data *data =3D td->io_ops_data;
+
+	free(data);
+}
+
+static int close_directory(struct thread_data *td, struct fio_file *f)
+{
+	f->fd =3D -1;
+	return 0;
+}
+
+static int remove_directory(struct thread_data *td, struct fio_file *f)
+{
+	return (rmdir(f->file_name));
+}
+
+static struct ioengine_ops ioengine =3D {
+	.name		=3D "dircreate",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.get_file_size	=3D get_file_size,
+	.open_file	=3D make_directory,
+	.close_file	=3D close_directory,
+	.unlink_file =3D remove_directory,
+	.flags		=3D FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static void fio_init fio_dircreate_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_dircreate_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/dircreate-ioengine.fio b/examples/dircreate-ioengine.=
fio
new file mode 100644
index 00000000..7ba835c0
--- /dev/null
+++ b/examples/dircreate-ioengine.fio
@@ -0,0 +1,36 @@
+# Example dircreate job
+#
+# create_on_open is needed so that the open happens during the run and not=
 the
+# setup.
+#
+# openfiles needs to be set so that you do not exceed the maximum allowed =
open
+# files.
+#
+# filesize needs to be set to a non zero value so fio will actually run, b=
ut the
+# IO will not really be done and the write latency numbers will only refle=
ct the
+# open times.
+[global]
+create_on_open=3D1
+nrfiles=3D31250
+ioengine=3Ddircreate
+fallocate=3Dnone
+filesize=3D4k
+openfiles=3D1
+unlink=3D1
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
+[t6]
+[t7]
+[t8]
+[t9]
+[t10]
+[t11]
+[t12]
+[t13]
+[t14]
+[t15]
diff --git a/fio.1 b/fio.1
index 948c01f9..51ec9649 100644
--- a/fio.1
+++ b/fio.1
@@ -1921,6 +1921,11 @@ Simply create the files and do no I/O to them.  You =
still need to set
 \fBfilesize\fR so that all the accounting still occurs, but no actual I/O =
will be
 done other than creating the file.
 .TP
+.B dircreate
+Simply create directories and do no I/O to them.  You still need to set
+\fBfilesize\fR so that all the accounting still occurs, but no actual I/O =
will be
+done other than creating the directory.
+This engine is to measure the performance of creating directories.
 .B filestat
 Simply do stat() and do no I/O to the file. You need to set 'filesize'
 and 'nrfiles', so that files will be created.
--=20
2.17.1

