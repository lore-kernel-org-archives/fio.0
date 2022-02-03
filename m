Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0714DC433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353765AbiBCT2i (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:38 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34997 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353754AbiBCT2g (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916515; x=1675452515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JcSZghBiawmhHyhbKR106IECeTwmCJ4NaeKhYt48xwg=;
  b=EnQJiEN4h2qhYZR43twweLHfOpiJVsLLgTP1enPYDVo7bXvnU5Ncjk0X
   1VuZKVYDWrazRt/Swc47m1FA3c81EWNUR9Mb1FCBzOiqbqUkMsKbwcUG9
   0EBppzB1PwzwDz5GgwWlOgFu3KatbCMW5bXPyCXsJ2i04hR7f8VZ3wDDv
   9lcugTId8Q0rq6Ja7zfT56tSXL9m0osNl7/r8vBK8OkDKIbBYRIaSR1Y7
   dfyJDYEg5ALf8Lo4wpr909rjEJrlq8mhEYVRHTRxPDjgCCPBFHjvXSjlT
   E6urhpU0wMnPkqrnJD/Ca50NO+HyeUjT5vw3Y7rt8pGDrQBTBK4flM91K
   A==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107558"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZM13SVALBNjtE1kgNha/IbzUNYKPwttvAOlB189DdmTCbWXPnlOrjXpnN2zfKVHGkGnCFQi23ADiMthqG66OKNPYvI6+wrIYrKQ7zkQ4uexwQVimr8/37qUzvAflTiRkL5Ov2zXoB0IHj72focGOvpVsCODUSBnaew9L5PM5F8E0OcfPnaFAU5TWUAcI0+1vvTPROeK8LrGI49py1hj5DAmLdHAxQjluS+cIay5nlzHmYTslmxaP8zCe9nf3L1BCQF7+OttU4+7d9tS1m8XbuvgXeT63R8INxAq82xJka9mQ/Hl60oBVTr3KYD4+KQdSkgr+ZYCse2mBST9o8SiTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yi4/4jQdkBWfC9t/oWNLfEB9aqZ9SYE+1RSr6kyATBQ=;
 b=ATqu4/MvOrKCqvNlEi8VgLUQQ5eoLNoNmtBWdVWvba+yxn7XNP02Q/oOhcQlcuQaD7vuzYmqWtD8Vxa/bZYxASoyeJqArU2L/wNYhxStfkgfOBddOr36/nAfcoXHyBf+lv5mySdbXNPIHVbXG5iOq1SPcq1I0W+26ejDjAyZ9CQ+Ag6bGW97lw9yti1WRQmgT6876kYp2p+DuzHiavozO5djFK8dk27juH0P/OzxFXLyUqgJV+nvmvtqW/XZn1JG0Te2Nhkmz8jw9eAm9Y+eN54qvvqNgOCCCmWb3w5pFDFUYwuE23uzUEiltUtstcdbHoeFkDh8Y+wRJNp7HsVagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yi4/4jQdkBWfC9t/oWNLfEB9aqZ9SYE+1RSr6kyATBQ=;
 b=WAUiIivcjrJMSm05XlyJZDLFLIivYkOQQoy04m91WUsawv1sL2hETS3kL2WYwxB++anCHHy7rRcbhxms9jRxOE7/YOlDDaAufXBSM9uj6DN/S8AykUDXsBKvvJdOYyY+NrlDpkswZmICNOUJJCIk9tpQKka3f7vbhgsX5o375iE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5423.namprd04.prod.outlook.com (2603:10b6:805:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 19:28:34 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:34 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 15/18] stat: convert json output to a new per priority
 granularity format
Thread-Topic: [PATCH v2 15/18] stat: convert json output to a new per priority
 granularity format
Thread-Index: AQHYGTQ6dYIgmt7vMkqF4jXlX0pvFA==
Date:   Thu, 3 Feb 2022 19:28:31 +0000
Message-ID: <20220203192814.18552-16-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c09fa66b-ede0-473f-c6e0-08d9e74b5e6d
x-ms-traffictypediagnostic: SN6PR04MB5423:EE_
x-microsoft-antispam-prvs: <SN6PR04MB5423A1F90CFEB957929F6188F2289@SN6PR04MB5423.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P26Lusi7HaRwldiBk6W5JjXO+22VNy4+k8YaWdfuFSmjqvv8S+C5+cBUrowdKTfhIH6ugC5NQ7VgU0hqUsXZ3OkAYPU7wPUmpCBSQRzAwpb0naYrDHkr0VqeE/cKVdsrbY5kFRdvnDNqqiX/3CrNldUDctqYcPqw5haFR/hernRouPlynxWRACQvKj9XaJCNtgg0sgA+fgPemPWEg35etouNM0F0b5yABtSqwiOXB1niPMiZHtZZ6n6zhLI24xGHFrkuKhFM97nxR57DmVZ3m4MPwpRZ6aKlb8vcFye08AE0LOad9F/hI/1LUmj1NT6tzalkidXTY20vuyhqRWmguLgUMTehY9O1eRhnvSCVQH3TE3TNOxFJW27m3BDsNEWrAeHSjaEWGp+xJ71LYHwchi/tc2XQ2z6LCE9bJ3VODZF/BouGQGx4DareCVBJFNdw4XGmeU3vPbKk4mnrbiiC7+Zb2yYBt37lKo31zbo25x4YPgJ2LKOu7s2+/XypCTCLhm5JZQqpb6aFFdAy3GAm0+JBv5s/FvLvMNWQ56F1osP0vpPup42BhlQ7TG8AtAMWVmV7FMFDP/3s4ppBI/xs0qHc/0dCqZzGtUeNxGnJkK/l3RM0nfVcCGXCCs7YrcPaHCEQh+3RzI3xa87eP+BOko+TFL0w2ImnVbeHe+MJIxBNjU1+WPMfHXP2BH4uhObrR/OsPd0fzLsoxS5wMTU4pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(86362001)(66946007)(6666004)(91956017)(5660300002)(64756008)(6486002)(71200400001)(6506007)(8936002)(66446008)(6512007)(508600001)(122000001)(4326008)(66476007)(66556008)(2906002)(38100700002)(316002)(2616005)(6916009)(186003)(83380400001)(26005)(82960400001)(36756003)(30864003)(1076003)(8676002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/5+jrtbSE5TY5GpGY14C8ZWSrN9ibQttdbYc7ztQyKxIVdPxSWohy4ORiD?=
 =?iso-8859-1?Q?3kh8Q76aLfznERcWDfGQ6OV5MllU1E4in88KsojWiPwakmv/VXwNeOjvab?=
 =?iso-8859-1?Q?r1i1IwaTnDEA6RMbGtN+B15vLwstb7lwdpOO/Zy1o9kLeMQ1YCXEQao41D?=
 =?iso-8859-1?Q?eiVlxNagprkO510mf2HpPGZYf94brC7Tb/d55a1r0HkgVpOXbBC9GT/XNc?=
 =?iso-8859-1?Q?pl6Ei6GUZqr9uILuoBpJZ8EQUckAKfXJuSddJY3IkRxYvX7MeAtP9c0Tgc?=
 =?iso-8859-1?Q?oSz2PSwWudT+ELRsIxgiCqEFGB6SrtpJUcMBh5RRElYw9/gj53+VBSim73?=
 =?iso-8859-1?Q?8ZI7v2vi587wDLE31LjOmZJkTvXkDYiWKHVtw87aQucuC/OJHNcyBixrbh?=
 =?iso-8859-1?Q?EJXiOnX9twRH4jeLHVVpkvKCYZBQPRLxxQdRgeHvxkJilWaNiE/Azu969K?=
 =?iso-8859-1?Q?II0gduEqkjmPz2EkpIkWpo7/DuWr34q/0d/vAQCc9gyQzTqHD5vUOw304m?=
 =?iso-8859-1?Q?nHUjvzSxVd8ceVwC/hHi2ZGGvV38890X04uHOZbh50teN05aFXSlkkh1yK?=
 =?iso-8859-1?Q?4k17osxb1H4UmkwNq/397ZJ0+xd3A7fLQGaMvyUidAguqiHtS2S5zsBBrT?=
 =?iso-8859-1?Q?w9ledY6etTQ66oxe+2bohxIO1QsG6m9YpvMxgHDwGc2OJI1f/1IXWm5pXB?=
 =?iso-8859-1?Q?MGe1CJ3CDaAsboa0Ddwu4ECb4V2MzE2L7EixpxF0yugxtgAoAMG4aWL4+K?=
 =?iso-8859-1?Q?wanBGHPD6jrjjsEp0BAX/CF0nVuV1CXB0G94rKzePCK/ZaQ8IoKHHmAg16?=
 =?iso-8859-1?Q?dglMeht26HUCKDaCjuub37YXOXVpY407vfJ93DRI1Hw0zguKyfnWbef3NL?=
 =?iso-8859-1?Q?O6EtOecj4a48P2XMvqqaiOOnrrm84VAOwD+nIn2jJzsjsfMI8zZ1o9rkCi?=
 =?iso-8859-1?Q?IR9Fm22dqWlVo4cbb6f2ZA53Dz4wC8yLO10KUjPab1cA+3SNcE07FaDlhY?=
 =?iso-8859-1?Q?ywlXZMk5TnSU35JgjhfBSPzWK5hWRLmb1d311nKxL6Zu5Pq+Ux2Oad1/4r?=
 =?iso-8859-1?Q?gTb2+oXRpnQNDb5RcJyaLq7QdxJidOqDhsxtdal0xJhfUegBd4LcIBhdQI?=
 =?iso-8859-1?Q?NS7PcXmCoXBUlzwgAOJsuQf1Khpr79SCNxjvE2SmvsnYtBGVNGWhgmomAw?=
 =?iso-8859-1?Q?oHFnRLMmozVQadpZ3X7w+2mFZM30ueP0iG7NHhTY9i7JTDegJISlf2nVTy?=
 =?iso-8859-1?Q?oJKxEbyomiLMBGjg8LkGtWzBfkwYTqarTzzJtNFsOwp5ghqtl0NL+Ua3x4?=
 =?iso-8859-1?Q?23BgNgKOJBbjd6PU7ItbcLu7C6eiW65u8hFiaP8bfACOXyhrITzzJSQ8Lo?=
 =?iso-8859-1?Q?htCSOukEZ+gmOuzbMFRHKW9donE8GekbNvEmZHzExne6J5EKPD7h7emcz0?=
 =?iso-8859-1?Q?ifYK+LmARbtO4D5yh5IApUYj2MhqX3gTHCl8EhEVc/9j01sbku9Iwc4C4p?=
 =?iso-8859-1?Q?4S6WmTs8+MC7MeI/lWV7vXzK1c+HwHto2CVuSFIFtrXU/UsPHfu8s3DmzD?=
 =?iso-8859-1?Q?eaUKnx+X4zu/cbbYc2upT2d3Gt0P+MWt5DfYzTTcFNWGwp640njrzOhF0n?=
 =?iso-8859-1?Q?H+sd35YELCWQn4d6QW9g7V2iqTm9KYGU60RFHoBNbXgFaJqt4mdeMnYn7k?=
 =?iso-8859-1?Q?RWBMqmeu4doullhDt1GD23Swtz3yDcyMrOROgvSQ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09fa66b-ede0-473f-c6e0-08d9e74b5e6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:31.3852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DX+QZRDhGgJW9Pzzo1B/H8IfyuaenAxadb+BASoJ3K2IOCOhqkcmhaFT2XTN+HXH5OgXemZKVyHmpkPHI3rynQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5423
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The JSON output will no longer contain high_prio/low_prio entries, but will
instead include a new list "prios", which will include an object per
prioclass/priolevel combination. Each of these objects will either have a
"clat_ns" object or a "lat_ns" object, depending on which latency type was
being tracked.

This JSON structure should make it easy if the per priority stats were ever
extended to be able to track multiple latency types at the same time, as
each prioclass/priolevel object will then simply contain (e.g.) both a
"clat_ns" and a "lat_ns" object.

Convert the JSON output to this new per priority granularity format,
and convert the tests to work with the new JSON output.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c                   |  44 +++++++++------
 t/latency_percentiles.py | 118 +++++++++++++++++++--------------------
 2 files changed, 87 insertions(+), 75 deletions(-)

diff --git a/stat.c b/stat.c
index a6810d9b..24fc679f 100644
--- a/stat.c
+++ b/stat.c
@@ -1493,25 +1493,37 @@ static void add_ddir_status_json(struct thread_stat=
 *ts,
 	if (!ddir_rw(ddir))
 		return;
=20
-	/* Only print PRIO latencies if some high priority samples were gathered =
*/
-	if (ts->clat_high_prio_stat[ddir].samples > 0) {
-		const char *high, *low;
+	/* Only include per prio stats if there are >=3D 2 prios with samples */
+	if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
+		struct json_array *array =3D json_create_array();
+		const char *obj_name;
+		int i;
=20
-		if (ts->lat_percentiles) {
-			high =3D "lat_high_prio";
-			low =3D "lat_low_prio";
-		} else {
-			high =3D "clat_high_prio";
-			low =3D "clat_low_prio";
-		}
+		if (ts->lat_percentiles)
+			obj_name =3D "lat_ns";
+		else
+			obj_name =3D "clat_ns";
=20
-		tmp_object =3D add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_perc=
entiles,
-				&ts->clat_high_prio_stat[ddir], ts->io_u_plat_high_prio[ddir]);
-		json_object_add_value_object(dir_object, high, tmp_object);
+		json_object_add_value_array(dir_object, "prios", array);
=20
-		tmp_object =3D add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_perc=
entiles,
-				&ts->clat_low_prio_stat[ddir], ts->io_u_plat_low_prio[ddir]);
-		json_object_add_value_object(dir_object, low, tmp_object);
+		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
+			if (ts->clat_prio[ddir][i].clat_stat.samples > 0) {
+				struct json_object *obj =3D json_create_object();
+				unsigned long long class, level;
+
+				class =3D ts->clat_prio[ddir][i].ioprio >> 13;
+				json_object_add_value_int(obj, "prioclass", class);
+				level =3D ts->clat_prio[ddir][i].ioprio & 7;
+				json_object_add_value_int(obj, "prio", level);
+
+				tmp_object =3D add_ddir_lat_json(ts,
+							       ts->clat_percentiles | ts->lat_percentiles,
+							       &ts->clat_prio[ddir][i].clat_stat,
+							       ts->clat_prio[ddir][i].io_u_plat);
+				json_object_add_value_object(obj, obj_name, tmp_object);
+				json_array_add_value_object(array, obj);
+			}
+		}
 	}
=20
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index cc437426..62c4cc91 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -80,6 +80,7 @@ import time
 import argparse
 import platform
 import subprocess
+from collections import Counter
 from pathlib import Path
=20
=20
@@ -363,20 +364,19 @@ class FioLatTest():
=20
     def check_nocmdprio_lat(self, job):
         """
-        Make sure no high/low priority latencies appear.
+        Make sure no per priority latencies appear.
=20
         job         JSON object to check
         """
=20
         for ddir in ['read', 'write', 'trim']:
             if ddir in job:
-                if 'lat_high_prio' in job[ddir] or 'lat_low_prio' in job[d=
dir] or \
-                    'clat_high_prio' in job[ddir] or 'clat_low_prio' in jo=
b[ddir]:
-                    print("Unexpected high/low priority latencies found in=
 %s output" % ddir)
+                if 'prios' in job[ddir]:
+                    print("Unexpected per priority latencies found in %s o=
utput" % ddir)
                     return False
=20
         if self.debug:
-            print("No high/low priority latencies found")
+            print("No per priority latencies found")
=20
         return True
=20
@@ -497,7 +497,7 @@ class FioLatTest():
         return retval
=20
     def check_prio_latencies(self, jsondata, clat=3DTrue, plus=3DFalse):
-        """Check consistency of high/low priority latencies.
+        """Check consistency of per priority latencies.
=20
         clat                True if we should check clat data; other check=
 lat data
         plus                True if we have json+ format data where additi=
onal checks can
@@ -506,78 +506,78 @@ class FioLatTest():
         """
=20
         if clat:
-            high =3D 'clat_high_prio'
-            low =3D 'clat_low_prio'
-            combined =3D 'clat_ns'
+            obj =3D combined =3D 'clat_ns'
         else:
-            high =3D 'lat_high_prio'
-            low =3D 'lat_low_prio'
-            combined =3D 'lat_ns'
+            obj =3D combined =3D 'lat_ns'
=20
-        if not high in jsondata or not low in jsondata or not combined in =
jsondata:
-            print("Error identifying high/low priority latencies")
+        if not 'prios' in jsondata or not combined in jsondata:
+            print("Error identifying per priority latencies")
             return False
=20
-        if jsondata[high]['N'] + jsondata[low]['N'] !=3D jsondata[combined=
]['N']:
-            print("High %d + low %d !=3D combined sample size %d" % \
-                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[com=
bined]['N']))
+        sum_sample_size =3D sum([x[obj]['N'] for x in jsondata['prios']])
+        if sum_sample_size !=3D jsondata[combined]['N']:
+            print("Per prio sample size sum %d !=3D combined sample size %=
d" %
+                  (sum_sample_size, jsondata[combined]['N']))
             return False
         elif self.debug:
-            print("High %d + low %d =3D=3D combined sample size %d" % \
-                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[com=
bined]['N']))
+            print("Per prio sample size sum %d =3D=3D combined sample size=
 %d" %
+                  (sum_sample_size, jsondata[combined]['N']))
=20
-        if min(jsondata[high]['min'], jsondata[low]['min']) !=3D jsondata[=
combined]['min']:
-            print("Min of high %d, low %d min latencies does not match min=
 %d from combined data" % \
-                    (jsondata[high]['min'], jsondata[low]['min'], jsondata=
[combined]['min']))
+        min_val =3D min([x[obj]['min'] for x in jsondata['prios']])
+        if min_val !=3D jsondata[combined]['min']:
+            print("Min per prio min latency %d does not match min %d from =
combined data" %
+                  (min_val, jsondata[combined]['min']))
             return False
         elif self.debug:
-            print("Min of high %d, low %d min latencies matches min %d fro=
m combined data" % \
-                    (jsondata[high]['min'], jsondata[low]['min'], jsondata=
[combined]['min']))
+            print("Min per prio min latency %d matches min %d from combine=
d data" %
+                  (min_val, jsondata[combined]['min']))
=20
-        if max(jsondata[high]['max'], jsondata[low]['max']) !=3D jsondata[=
combined]['max']:
-            print("Max of high %d, low %d max latencies does not match max=
 %d from combined data" % \
-                    (jsondata[high]['max'], jsondata[low]['max'], jsondata=
[combined]['max']))
+        max_val =3D max([x[obj]['max'] for x in jsondata['prios']])
+        if max_val !=3D jsondata[combined]['max']:
+            print("Max per prio max latency %d does not match max %d from =
combined data" %
+                  (max_val, jsondata[combined]['max']))
             return False
         elif self.debug:
-            print("Max of high %d, low %d max latencies matches max %d fro=
m combined data" % \
-                    (jsondata[high]['max'], jsondata[low]['max'], jsondata=
[combined]['max']))
+            print("Max per prio max latency %d matches max %d from combine=
d data" %
+                  (max_val, jsondata[combined]['max']))
=20
-        weighted_avg =3D (jsondata[high]['mean'] * jsondata[high]['N'] + \
-                        jsondata[low]['mean'] * jsondata[low]['N']) / json=
data[combined]['N']
+        weighted_vals =3D [x[obj]['mean'] * x[obj]['N'] for x in jsondata[=
'prios']]
+        weighted_avg =3D sum(weighted_vals) / jsondata[combined]['N']
         delta =3D abs(weighted_avg - jsondata[combined]['mean'])
         if (delta / jsondata[combined]['mean']) > 0.0001:
-            print("Difference between weighted average %f of high, low mea=
ns "
+            print("Difference between merged per prio weighted average %f =
mean "
                   "and actual mean %f exceeds 0.01%%" % (weighted_avg, jso=
ndata[combined]['mean']))
             return False
         elif self.debug:
-            print("Weighted average %f of high, low means matches actual m=
ean %f" % \
-                    (weighted_avg, jsondata[combined]['mean']))
+            print("Merged per prio weighted average %f mean matches actual=
 mean %f" %
+                  (weighted_avg, jsondata[combined]['mean']))
=20
         if plus:
-            if not self.check_jsonplus(jsondata[high]):
-                return False
-            if not self.check_jsonplus(jsondata[low]):
-                return False
+            for prio in jsondata['prios']:
+                if not self.check_jsonplus(prio[obj]):
+                    return False
=20
-            bins =3D {**jsondata[high]['bins'], **jsondata[low]['bins']}
-            for duration in bins.keys():
-                if duration in jsondata[high]['bins'] and duration in json=
data[low]['bins']:
-                    bins[duration] =3D jsondata[high]['bins'][duration] + =
\
-                            jsondata[low]['bins'][duration]
+            counter =3D Counter()
+            for prio in jsondata['prios']:
+                counter.update(prio[obj]['bins'])
+
+            bins =3D dict(counter)
=20
             if len(bins) !=3D len(jsondata[combined]['bins']):
-                print("Number of combined high/low bins does not match num=
ber of overall bins")
+                print("Number of merged bins %d does not match number of o=
verall bins %d" %
+                      (len(bins), len(jsondata[combined]['bins'])))
                 return False
             elif self.debug:
-                print("Number of bins from merged high/low data matches nu=
mber of overall bins")
+                print("Number of merged bins %d matches number of overall =
bins %d" %
+                      (len(bins), len(jsondata[combined]['bins'])))
=20
             for duration in bins.keys():
                 if bins[duration] !=3D jsondata[combined]['bins'][duration=
]:
-                    print("Merged high/low count does not match overall co=
unt for duration %d" \
-                            % duration)
+                    print("Merged per prio count does not match overall co=
unt for duration %d" %
+                          duration)
                     return False
=20
-        print("Merged high/low priority latency data match combined latenc=
y data")
+        print("Merged per priority latency data match combined latency dat=
a")
         return True
=20
     def check(self):
@@ -602,7 +602,7 @@ class Test001(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['read'], 0, slat=3DFalse)
@@ -626,7 +626,7 @@ class Test002(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['write'], 1, slat=3DFalse, cl=
at=3DFalse)
@@ -650,7 +650,7 @@ class Test003(FioLatTest):
             print("Unexpected write data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['trim'], 2, slat=3DFalse, tla=
t=3DFalse)
@@ -674,7 +674,7 @@ class Test004(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['read'], 0, plus=3DTrue)
@@ -698,7 +698,7 @@ class Test005(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['write'], 1, slat=3DFalse, pl=
us=3DTrue)
@@ -722,7 +722,7 @@ class Test006(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['read'], 0, slat=3DFalse, tla=
t=3DFalse, plus=3DTrue)
@@ -743,7 +743,7 @@ class Test007(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['read'], 0, clat=3DFalse, tla=
t=3DFalse, plus=3DTrue)
@@ -765,7 +765,7 @@ class Test008(FioLatTest):
             print("Unexpected data direction found in fio output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['mixed'], 0, plus=3DTrue, uni=
fied=3DTrue)
@@ -792,7 +792,7 @@ class Test009(FioLatTest):
             print("Error checking fsync latency data")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['write'], 1, slat=3DFalse, pl=
us=3DTrue)
@@ -813,7 +813,7 @@ class Test010(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['read'], 0, plus=3DTrue)
@@ -839,7 +839,7 @@ class Test011(FioLatTest):
             print("Unexpected trim data found in output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
-            print("Unexpected high/low priority latencies found")
+            print("Unexpected per priority latencies found")
             retval =3D False
=20
         retval &=3D self.check_latencies(job['read'], 0, slat=3DFalse, cla=
t=3DFalse, plus=3DTrue)
--=20
2.34.1
