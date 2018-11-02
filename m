Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:61063 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbeKCCMe (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Nov 2018 22:12:34 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH v2] fix windows cpu count
Date: Fri, 2 Nov 2018 17:04:43 +0000
Message-ID: <MWHPR04MB03200B2DD2F07C83B09550C48FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

This patch resolves c479640d6208236744f0562b1e79535eec290e2b where the CPU =
count returns max possible supported CPUs, and instead returns current acti=
ve CPUs.


diff --git a/os/os-windows-7.h b/os/os-windows-7.h
index f5ddb8e..0a6eaa3 100644
--- a/os/os-windows-7.h
+++ b/os/os-windows-7.h
@@ -10,7 +10,7 @@ typedef struct {
 /* Return all processors regardless of processor group */
 static inline unsigned int cpus_online(void)
 {
-	return GetMaximumProcessorCount(ALL_PROCESSOR_GROUPS);
+	return GetActiveProcessorCount(ALL_PROCESSOR_GROUPS);
 }
=20
 static inline void print_mask(os_cpu_mask_t *cpumask)
@@ -104,7 +104,7 @@ static inline int mask_to_group_mask(os_cpu_mask_t *cpu=
mask, int *processor_grou
 	cpus_offset =3D 0;
 	group_size =3D 0;
 	while (!found && group < online_groups) {
-		group_size =3D GetMaximumProcessorCount(group);
+		group_size =3D GetActiveProcessorCount(group);
 		dprint(FD_PROCESS, "group=3D%d group_start=3D%d group_size=3D%u search_c=
pu=3D%d\n",
 		       group, cpus_offset, group_size, search_cpu);
 		if (cpus_offset + group_size > search_cpu)
@@ -271,7 +271,7 @@ static inline int fio_getaffinity(int pid, os_cpu_mask_=
t *mask)
 	dprint(FD_PROCESS, "current_groups=3D%d group_count=3D%d\n",
 	       current_groups[0], group_count);
 	while (true) {
-		group_size =3D GetMaximumProcessorCount(group);
+		group_size =3D GetActiveProcessorCount(group);
 		if (group_size =3D=3D 0) {
 			log_err("fio_getaffinity: error retrieving size of "
 				"processor group %d\n", group);



