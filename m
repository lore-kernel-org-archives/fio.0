Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544F6C00144
	for <fio@archiver.kernel.org>; Mon,  1 Aug 2022 06:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiHAG5y (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 1 Aug 2022 02:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHAG5x (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 Aug 2022 02:57:53 -0400
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F572182B
        for <fio@vger.kernel.org>; Sun, 31 Jul 2022 23:57:48 -0700 (PDT)
Received: from pps.filterd (m0209327.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26VNhJuN029146
        for <fio@vger.kernel.org>; Mon, 1 Aug 2022 06:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=S1; bh=C6NCWK9cTLnCogopME6Rxy3XNcMfNlzIG/PjTV6LZnA=;
 b=ODbEx+r4430plwT+NJuvMLD7RSLIt7EavtZGaCVeOuVZDNIVLZnpU+pJsvSW8903uNJb
 7jq/Hi4uPNfkXJDIpK8VeOMGV0J3/x0905OK4lQUABNMN/ajA4lueKgWeLI0AZyy8Rjb
 G85wLJ180pWvh+4T0LroAIaS8iD8OiQBx53iAKsH026UO5uNZtEDFgXRxbGo+f/U8RqN
 wu/wWuKFJilkRnMbNT3CsusTdCfhpx0FhZPKHJTIc0bx9P7gP1o60bBnSeGLyVt4r/I4
 hDzeDll7tA3A2L22JT4E3lWJ0ZgbAlSN+zZsw7YSn/mxv5VQoa4YkBQHGf6PmXxWrciF sw== 
Received: from apc01-tyz-obe.outbound.protection.outlook.com (mail-tyzapc01lp2047.outbound.protection.outlook.com [104.47.110.47])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3hmuh11hp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Mon, 01 Aug 2022 06:57:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m42+eLQ5coY1MomKmCC7K1bwoLiuLO2dOHFSusDQcS8lIuY0fqmNanA6W1EzqVb2xCWLCPrz9Dpen0LHKMLwkT2heb2qD5R/xD/7goiefuUF63QDDbOmGmvflrbxvFmqY+jO7EaNcd/8A5GsYlfaGeU20spS3SGQFiIuGdywSBrgRq8UG5uLT32vNLQVW9jjKlST6nBXpA+yC92BPP2qIql9sR6m4TzHczQ3cs6wwgxUCqYejXuvO3bhkxutfkbFJC/eWlcDkWePC7yvO6fDHrxEBnZ07Slb7o3Jr0jLeq0AnRv5MBWt4tcoj8BrqYEedeVQOul/T5yIbKrNG3ksig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6NCWK9cTLnCogopME6Rxy3XNcMfNlzIG/PjTV6LZnA=;
 b=iGKZsbSRP4X0ztmSWxRGxGQtQfbKlE54qXoXOL5r4YC6Mve6vsFOJM7V2zRRxIjOySEXdvB8pqKD1l8hPB4nFunPhTNg09BKQvezKhZRcG/hDg9ASq7iyo2pctU1N8r1ACUh4R8DWiSrGrlMz+xxl7UPbhWf8lIAzf2IDX96cb/mBxb+H10q5F1G7qf6/zRBoFHjjUxETTc3Uvk4Ub/y/L01/SHXGLwgIBKvMeRp24hrPJ4r0fboRYQI7lE/XDbdP1EPfiPStSGXsMmOJa0A3gHyf0O4c6P3K1uStHxNKrtWb1SveeN6fGNzq0UAFfryJclPp0zcefd/6I2bS1OL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by PU1PR04MB2504.apcprd04.prod.outlook.com (2603:1096:803:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Mon, 1 Aug
 2022 06:57:36 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::ad41:9b0c:99d:76f8]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::ad41:9b0c:99d:76f8%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 06:57:35 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     fio <fio@vger.kernel.org>
CC:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>,
        "Friendy.Su@sony.com" <Friendy.Su@sony.com>
Subject: [PATCH v1] ioengines: merge filecreate, filestat, filedelete engines
 to fileoperations.c
Thread-Topic: [PATCH v1] ioengines: merge filecreate, filestat, filedelete
 engines to fileoperations.c
Thread-Index: Adilc6ZtyCoBTMSpR7i69Cx3/5QVjA==
Date:   Mon, 1 Aug 2022 06:57:35 +0000
Message-ID: <HK0PR04MB2388AF0A140EE14FAF3604BAFD9A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bde9ecce-79b5-4836-30ba-08da738b1d81
x-ms-traffictypediagnostic: PU1PR04MB2504:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jHUUETIIMg5p0k7xcgAN0hgWB+BGdg/WGf0gzBO47XxF0P4yTBYLFvNwx+P0Cntmb9J9haKJLKqiSQHVqmaeIDXQLBbyw5DH7ni/L8cBQTyI4KpGKouiodQe+XmrSMjyE+158CvjgYl4nORV5lAOaQwZQhbtzlmYwltl7TFzsXDt7kicoaOAt6gKDanWaiw6ye+HroNA0fBFjucfbdtZOTIKJoV9+i5wuFhFsUjuuVnXYsRs8tagVyaaUoVMT0EYx/1XijC++mYnE3e8L2o8qi/lIzV7MxTbSUvDbgFIcpyEbOKNv96LiiNVx7tUNCorz7MozJ4EwsmmjZU7Gw1652l10yYa0ld4uyXJ1P9LYQU40OeYPpNm4EN9J4RaQl2OxUxtgapyzmFdYH9Wnf/y6VUxL+MvoouCzkE/Jp0if91YuKVA90WbtBA9Te/tGGGfnp8OgXjLCkIX6kiho9MJJ1Fc463Xg01ng7UAcSs/jkdFuxGOD9fG3nBxDGeK8qxj74Qo9NTSCkXLPIEvcnO0nt9ApzUNlPpyutfs37LWRIcg4TBffo7NbT87vF1XsbZiMISA0IB70G2++8qTqp5VQig9rrfci/Qs/345Pb6jY1GCjev4C/rbnSZkQ/0M6e/hkvHt1Q3bBAANrFEmkr0OrKWhyRurWPnZV0PpIyzEOXnXJ9INeaDc5/Sk08n9Sjq2sR6iS3t2q8lU38flxqLKYWmQPmhyBKxTrO82HwxmN6lby04LYu8Ais1ARC+IQVGs8IwSeThHU9HQHtN28NxKVrMnkSDImN1PnrCDSbRy3HMGZ4c/TizTjxSDeZrkXlfV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(66446008)(64756008)(66476007)(8676002)(76116006)(66946007)(71200400001)(66556008)(26005)(41300700001)(2906002)(52536014)(86362001)(478600001)(5660300002)(30864003)(8936002)(9686003)(6506007)(83380400001)(7696005)(33656002)(122000001)(4326008)(38100700002)(316002)(54906003)(38070700005)(6916009)(55016003)(186003)(107886003)(82960400001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B/9cFYWsvYcbX3z1q+qDD3q6PRf8x57HizeHbysNpM2r3B+rrXVDnKddJjBc?=
 =?us-ascii?Q?DAxQeL8c4djjzQPiz3KPjvZTIIgaCALSEgbKvcVasI226dgWvacur/Lh+ure?=
 =?us-ascii?Q?ZLUQ+6sLeUTQy9ZaflP+AqLKUrwUkTCRqWrE0X2O2yW9HLnaN2W/gY8KuiFz?=
 =?us-ascii?Q?WYSuoZc3a7soEjrzvDsYWC88yh1RkZ806TM8ltOSmapg4Fw0IiP+yRCyp4j3?=
 =?us-ascii?Q?bYA2/ZWiq1GxVeyHxC9r6ewHM4iRcRwmQTesjcsJ3JW5JYQdJ/CMPJ0tQVHI?=
 =?us-ascii?Q?8TB2fBaiYxbssWvAEYNo6KP2rB3QP/Cq0YW6HrL1IcCkgBR/ravEzDCeadyQ?=
 =?us-ascii?Q?YBg5d7BNWutvZSX0Zk2jPhGuXHgB2j1uhsyMPrU/oUtgcDBY3dU1mq84cncl?=
 =?us-ascii?Q?w3fr579uzeA+LNbX18crrIB/8WluaUoc3wfCn2Ws74jCwK1ABjK/nnY7nAMo?=
 =?us-ascii?Q?gvoy7/XofFSqa7m/9u4OBSjhrwTjS8BVK9za3S/bJ54T/TnUBzPqxOgecBqA?=
 =?us-ascii?Q?tMS13iIs8k1OoKhaTUjN+obSFzuuH9F1Fha89xWDLLXLyZwdKDhB4y3wtbsz?=
 =?us-ascii?Q?N5v00c7VxqsmQsftgEKd/op0eJPQd2YH2sTd3kC/rvVwYasICa4dosa4nocl?=
 =?us-ascii?Q?tP21o/Us1gBJiLC34VAl5d7MmGE9BlOVAoGcxjkmqkt/I6hd5GBxplIH9n07?=
 =?us-ascii?Q?lantFmoIKQdPpdX3prDIsjLvTHIks68RKPPulWN+Ugj2knK4ZLOlLnctROv8?=
 =?us-ascii?Q?qoT0oDykqELK8CKdN5b50Fcg7JeXc+sgjZhulzh75nMdjmbRVTqfRKaO0k+z?=
 =?us-ascii?Q?v02oZUwthYq5Ng3jL7PNQ7gj22PqIe2gmFS0HsNO1xctMm6/zhZoaDYjsbyn?=
 =?us-ascii?Q?UVw0Udf1+hZcKPhqI4O9BhUHd7yZegzX6/WnOfWwDa2LGfKBiVpqzNTCrjU8?=
 =?us-ascii?Q?zwadGF2xW5NgmcAYZ33MB/vnpRML5rY7MI7lBR77jRQJt/JlR0IqvUqvmOIn?=
 =?us-ascii?Q?SGUfHEG+YfFpf1jI/RkuUO0nSokRBdzw6daWniUhUzpu6+Ks/Z8aKW+e23MO?=
 =?us-ascii?Q?xiEjzt3j+YyuNBCQoEpc0OVJQzewd64QvoXVkxvViSGWM5BK/9oGOutC8zrz?=
 =?us-ascii?Q?a/DtC35MIwRVuLIJ0d94LvXVn9TwKiqRBlzzAN2Gmcm8KjlNbvWOZuAy4RZY?=
 =?us-ascii?Q?g1vKZzkIG6zWcAKbkpDOm3F1v9muHBzU3AwaTjHT2XFDRSxeVeiAkeaSgrat?=
 =?us-ascii?Q?cL17Pg0p/gpkR7l4vyrPPebb/nLhPv42HFuJDqgsflpUvDy1LGpJe87lD6NV?=
 =?us-ascii?Q?YHtzrwBsFslKktpGzTSPHcb4xrW9o/ISQN8CfetJ2kq0cMADQ3TJh+3WZmI6?=
 =?us-ascii?Q?shD1snHyTslMUT/dAMiiHcJTxxx75SSe4V4uNR/0vWQjot55LdO03k9lERdQ?=
 =?us-ascii?Q?HSKpringS6/wRSRWbkj+VmoA0QJzsaVngx9WFEnALbf6F9liGtBdS5QF3iDe?=
 =?us-ascii?Q?1WLUo+gtJ4d3KKAlWDetSg9CO3raiijOODnOrfcTTCis/t6PRPpMePQNenb1?=
 =?us-ascii?Q?ev0b1cRoy0TSY6yZrtSlRiwswH7UV2LVRatsBb2S?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde9ecce-79b5-4836-30ba-08da738b1d81
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 06:57:35.8688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8XjVZvnoq0MqdU62eimUOi+yzx3RYRt6Z3LyiD4zYtQ3z6OZYi2nXw+r7uLNc+/TR/VF7NNT9hiNG13VKvPxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR04MB2504
X-Proofpoint-ORIG-GUID: GKPMXkN7gFgxzHYA_c4AaCavArrJSKrX
X-Proofpoint-GUID: GKPMXkN7gFgxzHYA_c4AaCavArrJSKrX
X-Sony-Outbound-GUID: GKPMXkN7gFgxzHYA_c4AaCavArrJSKrX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_02,2022-07-28_02,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

file operation engines have similar structure, implement them
in one file.

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 Makefile                 |   2 +-
 engines/filecreate.c     | 118 ---------------
 engines/filedelete.c     | 115 --------------
 engines/fileoperations.c | 316 +++++++++++++++++++++++++++++++++++++++
 engines/filestat.c       | 190 -----------------------
 5 files changed, 317 insertions(+), 424 deletions(-)
 delete mode 100644 engines/filecreate.c
 delete mode 100644 engines/filedelete.c
 create mode 100644 engines/fileoperations.c
 delete mode 100644 engines/filestat.c

diff --git a/Makefile b/Makefile
index 188a74d7..634d2c93 100644
--- a/Makefile
+++ b/Makefile
@@ -56,7 +56,7 @@ SOURCE :=3D	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(=
SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/file=
delete.c \
+		engines/ftruncate.c engines/fileoperations.c \
 		engines/exec.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
diff --git a/engines/filecreate.c b/engines/filecreate.c
deleted file mode 100644
index 7884752d..00000000
--- a/engines/filecreate.c
+++ /dev/null
@@ -1,118 +0,0 @@
-/*
- * filecreate engine
- *
- * IO engine that doesn't do any IO, just creates files and tracks the lat=
ency
- * of the file creation.
- */
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include "../fio.h"
-
-struct fc_data {
-	enum fio_ddir stat_ddir;
-};
-
-static int open_file(struct thread_data *td, struct fio_file *f)
-{
-	struct timespec start;
-	int do_lat =3D !td->o.disable_lat;
-
-	dprint(FD_FILE, "fd open %s\n", f->file_name);
-
-	if (f->filetype !=3D FIO_TYPE_FILE) {
-		log_err("fio: only files are supported\n");
-		return 1;
-	}
-	if (!strcmp(f->file_name, "-")) {
-		log_err("fio: can't read/write to stdin/out\n");
-		return 1;
-	}
-
-	if (do_lat)
-		fio_gettime(&start, NULL);
-
-	f->fd =3D open(f->file_name, O_CREAT|O_RDWR, 0600);
-
-	if (f->fd =3D=3D -1) {
-		char buf[FIO_VERROR_SIZE];
-		int e =3D errno;
-
-		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
-		td_verror(td, e, buf);
-		return 1;
-	}
-
-	if (do_lat) {
-		struct fc_data *data =3D td->io_ops_data;
-		uint64_t nsec;
-
-		nsec =3D ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
-	}
-
-	return 0;
-}
-
-static enum fio_q_status queue_io(struct thread_data *td,
-				  struct io_u fio_unused *io_u)
-{
-	return FIO_Q_COMPLETED;
-}
-
-/*
- * Ensure that we at least have a block size worth of IO to do for each
- * file. If the job file has td->o.size < nr_files * block_size, then
- * fio won't do anything.
- */
-static int get_file_size(struct thread_data *td, struct fio_file *f)
-{
-	f->real_file_size =3D td_min_bs(td);
-	return 0;
-}
-
-static int init(struct thread_data *td)
-{
-	struct fc_data *data;
-
-	data =3D calloc(1, sizeof(*data));
-
-	if (td_read(td))
-		data->stat_ddir =3D DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir =3D DDIR_WRITE;
-
-	td->io_ops_data =3D data;
-	return 0;
-}
-
-static void cleanup(struct thread_data *td)
-{
-	struct fc_data *data =3D td->io_ops_data;
-
-	free(data);
-}
-
-static struct ioengine_ops ioengine =3D {
-	.name		=3D "filecreate",
-	.version	=3D FIO_IOOPS_VERSION,
-	.init		=3D init,
-	.cleanup	=3D cleanup,
-	.queue		=3D queue_io,
-	.get_file_size	=3D get_file_size,
-	.open_file	=3D open_file,
-	.close_file	=3D generic_close_file,
-	.flags		=3D FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
-};
-
-static void fio_init fio_filecreate_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_filecreate_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/engines/filedelete.c b/engines/filedelete.c
deleted file mode 100644
index df388ac9..00000000
--- a/engines/filedelete.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * file delete engine
- *
- * IO engine that doesn't do any IO, just delete files and track the laten=
cy
- * of the file deletion.
- */
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <unistd.h>
-#include "../fio.h"
-
-struct fc_data {
-	enum fio_ddir stat_ddir;
-};
-
-static int delete_file(struct thread_data *td, struct fio_file *f)
-{
-	struct timespec start;
-	int do_lat =3D !td->o.disable_lat;
-	int ret;
-
-	dprint(FD_FILE, "fd delete %s\n", f->file_name);
-
-	if (f->filetype !=3D FIO_TYPE_FILE) {
-		log_err("fio: only files are supported\n");
-		return 1;
-	}
-	if (!strcmp(f->file_name, "-")) {
-		log_err("fio: can't read/write to stdin/out\n");
-		return 1;
-	}
-
-	if (do_lat)
-		fio_gettime(&start, NULL);
-
-	ret =3D unlink(f->file_name);
-
-	if (ret =3D=3D -1) {
-		char buf[FIO_VERROR_SIZE];
-		int e =3D errno;
-
-		snprintf(buf, sizeof(buf), "delete(%s)", f->file_name);
-		td_verror(td, e, buf);
-		return 1;
-	}
-
-	if (do_lat) {
-		struct fc_data *data =3D td->io_ops_data;
-		uint64_t nsec;
-
-		nsec =3D ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
-	}
-
-	return 0;
-}
-
-
-static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_=
unused *io_u)
-{
-	return FIO_Q_COMPLETED;
-}
-
-static int init(struct thread_data *td)
-{
-	struct fc_data *data;
-
-	data =3D calloc(1, sizeof(*data));
-
-	if (td_read(td))
-		data->stat_ddir =3D DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir =3D DDIR_WRITE;
-
-	td->io_ops_data =3D data;
-	return 0;
-}
-
-static int delete_invalidate(struct thread_data *td, struct fio_file *f)
-{
-    /* do nothing because file not opened */
-    return 0;
-}
-
-static void cleanup(struct thread_data *td)
-{
-	struct fc_data *data =3D td->io_ops_data;
-
-	free(data);
-}
-
-static struct ioengine_ops ioengine =3D {
-	.name		=3D "filedelete",
-	.version	=3D FIO_IOOPS_VERSION,
-	.init		=3D init,
-	.invalidate	=3D delete_invalidate,
-	.cleanup	=3D cleanup,
-	.queue		=3D queue_io,
-	.get_file_size	=3D generic_get_file_size,
-	.open_file	=3D delete_file,
-	.flags		=3D  FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
-};
-
-static void fio_init fio_filedelete_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_filedelete_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/engines/fileoperations.c b/engines/fileoperations.c
new file mode 100644
index 00000000..a0cd4322
--- /dev/null
+++ b/engines/fileoperations.c
@@ -0,0 +1,316 @@
+/*
+ * fileoperations engine
+ *
+ * IO engine that doesn't do any IO, just operates files and tracks the la=
tency
+ * of the file operation.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include "../fio.h"
+#include "../optgroup.h"
+#include "../oslib/statx.h"
+
+
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
+struct filestat_options {
+	void *pad;
+	unsigned int stat_type;
+};
+
+enum {
+	FIO_FILESTAT_STAT	=3D 1,
+	FIO_FILESTAT_LSTAT	=3D 2,
+	FIO_FILESTAT_STATX	=3D 3,
+};
+
+static struct fio_option options[] =3D {
+	{
+		.name	=3D "stat_type",
+		.lname	=3D "stat_type",
+		.type	=3D FIO_OPT_STR,
+		.off1	=3D offsetof(struct filestat_options, stat_type),
+		.help	=3D "Specify stat system call type to measure lookup/getattr perfo=
rmance",
+		.def	=3D "stat",
+		.posval =3D {
+			  { .ival =3D "stat",
+			    .oval =3D FIO_FILESTAT_STAT,
+			    .help =3D "Use stat(2)",
+			  },
+			  { .ival =3D "lstat",
+			    .oval =3D FIO_FILESTAT_LSTAT,
+			    .help =3D "Use lstat(2)",
+			  },
+			  { .ival =3D "statx",
+			    .oval =3D FIO_FILESTAT_STATX,
+			    .help =3D "Use statx(2) if exists",
+			  },
+		},
+		.category =3D FIO_OPT_C_ENGINE,
+		.group	=3D FIO_OPT_G_FILESTAT,
+	},
+	{
+		.name	=3D NULL,
+	},
+};
+
+
+static int open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+
+	dprint(FD_FILE, "fd open %s\n", f->file_name);
+
+	if (f->filetype !=3D FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
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
+	f->fd =3D open(f->file_name, O_CREAT|O_RDWR, 0600);
+
+	if (f->fd =3D=3D -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e =3D errno;
+
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
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
+static int stat_file(struct thread_data *td, struct fio_file *f)
+{
+	struct filestat_options *o =3D td->eo;
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+	struct stat statbuf;
+#ifndef WIN32
+	struct statx statxbuf;
+	char *abspath;
+#endif
+	int ret;
+
+	dprint(FD_FILE, "fd stat %s\n", f->file_name);
+
+	if (f->filetype !=3D FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
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
+	switch (o->stat_type) {
+	case FIO_FILESTAT_STAT:
+		ret =3D stat(f->file_name, &statbuf);
+		break;
+	case FIO_FILESTAT_LSTAT:
+		ret =3D lstat(f->file_name, &statbuf);
+		break;
+	case FIO_FILESTAT_STATX:
+#ifndef WIN32
+		abspath =3D realpath(f->file_name, NULL);
+		if (abspath) {
+			ret =3D statx(-1, abspath, 0, STATX_ALL, &statxbuf);
+			free(abspath);
+		} else
+			ret =3D -1;
+#else
+		ret =3D -1;
+#endif
+		break;
+	default:
+		ret =3D -1;
+		break;
+	}
+
+	if (ret =3D=3D -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e =3D errno;
+
+		snprintf(buf, sizeof(buf), "stat(%s) type=3D%u", f->file_name,
+			o->stat_type);
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
+
+static int delete_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat =3D !td->o.disable_lat;
+	int ret;
+
+	dprint(FD_FILE, "fd delete %s\n", f->file_name);
+
+	if (f->filetype !=3D FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
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
+	ret =3D unlink(f->file_name);
+
+	if (ret =3D=3D -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e =3D errno;
+
+		snprintf(buf, sizeof(buf), "delete(%s)", f->file_name);
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
+static int invalidate_do_nothing(struct thread_data *td, struct fio_file *=
f)
+{
+	/* do nothing because file not opened */
+	return 0;
+}
+
+static enum fio_q_status queue_io(struct thread_data *td, struct io_u *io_=
u)
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
+static struct ioengine_ops ioengine_filecreate =3D {
+	.name		=3D "filecreate",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.get_file_size	=3D get_file_size,
+	.open_file	=3D open_file,
+	.close_file	=3D generic_close_file,
+	.flags		=3D FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static struct ioengine_ops ioengine_filestat =3D {
+	.name		=3D "filestat",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.invalidate	=3D invalidate_do_nothing,
+	.get_file_size	=3D generic_get_file_size,
+	.open_file	=3D stat_file,
+	.flags		=3D  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+	.options	=3D options,
+	.option_struct_size =3D sizeof(struct filestat_options),
+};
+
+static struct ioengine_ops ioengine_filedelete =3D {
+	.name		=3D "filedelete",
+	.version	=3D FIO_IOOPS_VERSION,
+	.init		=3D init,
+	.invalidate	=3D invalidate_do_nothing,
+	.cleanup	=3D cleanup,
+	.queue		=3D queue_io,
+	.get_file_size	=3D generic_get_file_size,
+	.open_file	=3D delete_file,
+	.flags		=3D  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+
+static void fio_init fio_fileoperations_register(void)
+{
+	register_ioengine(&ioengine_filecreate);
+	register_ioengine(&ioengine_filestat);
+	register_ioengine(&ioengine_filedelete);
+}
+
+static void fio_exit fio_fileoperations_unregister(void)
+{
+	unregister_ioengine(&ioengine_filecreate);
+	unregister_ioengine(&ioengine_filestat);
+	unregister_ioengine(&ioengine_filedelete);
+}
diff --git a/engines/filestat.c b/engines/filestat.c
deleted file mode 100644
index e587eb54..00000000
--- a/engines/filestat.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * filestat engine
- *
- * IO engine that doesn't do any IO, just stat files and tracks the latenc=
y
- * of the file stat.
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include "../fio.h"
-#include "../optgroup.h"
-#include "../oslib/statx.h"
-
-struct fc_data {
-	enum fio_ddir stat_ddir;
-};
-
-struct filestat_options {
-	void *pad;
-	unsigned int stat_type;
-};
-
-enum {
-	FIO_FILESTAT_STAT	=3D 1,
-	FIO_FILESTAT_LSTAT	=3D 2,
-	FIO_FILESTAT_STATX	=3D 3,
-};
-
-static struct fio_option options[] =3D {
-	{
-		.name	=3D "stat_type",
-		.lname	=3D "stat_type",
-		.type	=3D FIO_OPT_STR,
-		.off1	=3D offsetof(struct filestat_options, stat_type),
-		.help	=3D "Specify stat system call type to measure lookup/getattr perfo=
rmance",
-		.def	=3D "stat",
-		.posval =3D {
-			  { .ival =3D "stat",
-			    .oval =3D FIO_FILESTAT_STAT,
-			    .help =3D "Use stat(2)",
-			  },
-			  { .ival =3D "lstat",
-			    .oval =3D FIO_FILESTAT_LSTAT,
-			    .help =3D "Use lstat(2)",
-			  },
-			  { .ival =3D "statx",
-			    .oval =3D FIO_FILESTAT_STATX,
-			    .help =3D "Use statx(2) if exists",
-			  },
-		},
-		.category =3D FIO_OPT_C_ENGINE,
-		.group	=3D FIO_OPT_G_FILESTAT,
-	},
-	{
-		.name	=3D NULL,
-	},
-};
-
-static int stat_file(struct thread_data *td, struct fio_file *f)
-{
-	struct filestat_options *o =3D td->eo;
-	struct timespec start;
-	int do_lat =3D !td->o.disable_lat;
-	struct stat statbuf;
-#ifndef WIN32
-	struct statx statxbuf;
-	char *abspath;
-#endif
-	int ret;
-
-	dprint(FD_FILE, "fd stat %s\n", f->file_name);
-
-	if (f->filetype !=3D FIO_TYPE_FILE) {
-		log_err("fio: only files are supported\n");
-		return 1;
-	}
-	if (!strcmp(f->file_name, "-")) {
-		log_err("fio: can't read/write to stdin/out\n");
-		return 1;
-	}
-
-	if (do_lat)
-		fio_gettime(&start, NULL);
-
-	switch (o->stat_type){
-	case FIO_FILESTAT_STAT:
-		ret =3D stat(f->file_name, &statbuf);
-		break;
-	case FIO_FILESTAT_LSTAT:
-		ret =3D lstat(f->file_name, &statbuf);
-		break;
-	case FIO_FILESTAT_STATX:
-#ifndef WIN32
-		abspath =3D realpath(f->file_name, NULL);
-		if (abspath) {
-			ret =3D statx(-1, abspath, 0, STATX_ALL, &statxbuf);
-			free(abspath);
-		} else
-			ret =3D -1;
-#else
-		ret =3D -1;
-#endif
-		break;
-	default:
-		ret =3D -1;
-		break;
-	}
-
-	if (ret =3D=3D -1) {
-		char buf[FIO_VERROR_SIZE];
-		int e =3D errno;
-
-		snprintf(buf, sizeof(buf), "stat(%s) type=3D%u", f->file_name,
-			o->stat_type);
-		td_verror(td, e, buf);
-		return 1;
-	}
-
-	if (do_lat) {
-		struct fc_data *data =3D td->io_ops_data;
-		uint64_t nsec;
-
-		nsec =3D ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
-	}
-
-	return 0;
-}
-
-static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_=
unused *io_u)
-{
-	return FIO_Q_COMPLETED;
-}
-
-static int init(struct thread_data *td)
-{
-	struct fc_data *data;
-
-	data =3D calloc(1, sizeof(*data));
-
-	if (td_read(td))
-		data->stat_ddir =3D DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir =3D DDIR_WRITE;
-
-	td->io_ops_data =3D data;
-	return 0;
-}
-
-static void cleanup(struct thread_data *td)
-{
-	struct fc_data *data =3D td->io_ops_data;
-
-	free(data);
-}
-
-static int stat_invalidate(struct thread_data *td, struct fio_file *f)
-{
-	/* do nothing because file not opened */
-	return 0;
-}
-
-static struct ioengine_ops ioengine =3D {
-	.name		=3D "filestat",
-	.version	=3D FIO_IOOPS_VERSION,
-	.init		=3D init,
-	.cleanup	=3D cleanup,
-	.queue		=3D queue_io,
-	.invalidate	=3D stat_invalidate,
-	.get_file_size	=3D generic_get_file_size,
-	.open_file	=3D stat_file,
-	.flags		=3D  FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
-	.options	=3D options,
-	.option_struct_size =3D sizeof(struct filestat_options),
-};
-
-static void fio_init fio_filestat_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_filestat_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
--=20
2.17.1

