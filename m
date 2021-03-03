Return-Path: <fio-owner@vger.kernel.org>
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:3184 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1452070AbhCCG2V (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 3 Mar 2021 01:28:21 -0500
Received: from pps.filterd (m0209329.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1236GWWs016306
        for <fio@vger.kernel.org>; Wed, 3 Mar 2021 06:27:37 GMT
Received: from apc01-sg2-obe.outbound.protection.outlook.com (mail-sg2apc01lp2057.outbound.protection.outlook.com [104.47.125.57])
        by mx08-001d1705.pphosted.com with ESMTP id 36ycr02pks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Wed, 03 Mar 2021 06:27:37 +0000
From: <Friendy.Su@sony.com>
Subject: [PATCH v1 1/1] engines/filecreate: remove improper message print
Date: Wed, 3 Mar 2021 06:27:27 +0000
Message-ID: <PU1PR04MB2390272C8DAB7911973D255AFD989@PU1PR04MB2390.apcprd04.prod.outlook.com>
Content-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Wataru.Aoyama@sony.com, Kento.A.Kobayashi@sony.com, Friendy.Su@sony.com

'fallocate' should not be printed in filecreate engine

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 engines/filecreate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/engines/filecreate.c b/engines/filecreate.c
index 5fec8544..16c64928 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -22,7 +22,7 @@ static int open_file(struct thread_data *td, struct fio_f=
ile *f)
 	dprint(FD_FILE, "fd open %s\n", f->file_name);
=20
 	if (f->filetype !=3D FIO_TYPE_FILE) {
-		log_err("fio: only files are supported fallocate \n");
+		log_err("fio: only files are supported\n");
 		return 1;
 	}
 	if (!strcmp(f->file_name, "-")) {
--=20
2.17.1


