Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76906C4332F
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351002AbiAaVNW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:22 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15180 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351157AbiAaVNS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663598; x=1675199598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bunxQHif8S8LCtBJmQlmc3xm8Tp1mO/0hetfB1ZEaTg=;
  b=neyTKktB3D7Hmo9q7d1u7SVGphQX0yLmkSc0znzJU5Y9RD5tLHml0i6+
   WBKQ17Z7wSv3TuUQglo6bi+nGoUyw9vK5JOwRo2o7APH0+5mkUytmqeK1
   iaUIfdsvrru7xi/5QE7salDEt6Xt86iyOdYWKpIbIwuC8F8z2VHw4likT
   bHQqOQIpOpBV8UCi+1cEIdPqTlHjFpVsxftXP86hb+cPbOlaaX8G2dDSY
   VHzkG15IhprlXpvZUuG2RQFXJ6qTdNRyNTHIjTqpB3vIAVUapY3vdHdAh
   0cmZdv5qO5sta25mqdm7Vm6TSs+FDhxZGmL3BxGkbqB5iqNDUetfzC81Q
   g==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720266"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnKrqeHTQN7rsb2EYBPTgpgpeMiYMzvvUJpbM2vkpSe3eQXcU5Bdc/EtD/dLktVZJNzPlPMAk1DpD/quGsg6IbysPrG5alzNBwS+Sb5179tKPWy7CuYxRZed+VXi7aHppldGsruc1wKR38g/U4G/wYRsJEULeXrgD7isk/4RufJUfEHbCHon7yC62bok256ebti2e3rM4aB99nN9yuMW7Ns1tXbxLfTK+ackJxAXyUqyWY9hjenb3E2Bzrkvjw7Ees2wgvvb6ytwOEKdrXTKPuKMVPT5ecvoKWKcmnZvxLSEs5j6w+s/ZLQWzC+tWswf+UNCFdE+3ZUcUyQUQJTdVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxXF6leQpZkvTHv1xiJhL1yvrBb7n3AZacA1C8J8uuI=;
 b=CZ4H+LNp3HJx++RaKd/AVitWiQSYDKolgd6qzDyG6Y84463cyVrrTnf6fRqN4dePO4FAvzAjiCR/1vCnu9R+RAn0vcYLPSQHI3Z09rSeYg5el92S8SlwjU5EPQ2nRfQDasJokQkOKROMLXxDl+uGsw52YQwn+YQxnxAmRomUB/A/xn6O+OKTRFRO2MLFzTU0JNbQLX0NNO3N7F3SlYh51UOSQMcNgPcUk8r4ZHTTfd3DTuoYhK8b8fSpUcyO74wWKVW2//GEtViSdU9HMilETp4lUXyUUWUMe7kUB7Kf0GN2OmCjp09TCL/g3X7oUQbA12Avva2eK1BWBPDQ3Cm2ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxXF6leQpZkvTHv1xiJhL1yvrBb7n3AZacA1C8J8uuI=;
 b=EnXRlQAvP1m50sR0J9xd/CZGCix55FzHlQT1dCG97wd85AWLCBBnxGJkCCGhxbl88+9+xVo9zVwDkLUn8y907xn4uIefy7P0idC7NSI4f/wHCESA0pWFyGlaK1dDCWIdGTZJxuAy23JzV1Yg7Uo8nYe0wwU73vCATN/E7vU0eBc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:09 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 14/17] stat: convert json output to a new per priority
 granularity format
Thread-Topic: [PATCH 14/17] stat: convert json output to a new per priority
 granularity format
Thread-Index: AQHYFudZF9uG1GhFEkya0EQLTtW7GA==
Date:   Mon, 31 Jan 2022 21:13:09 +0000
Message-ID: <20220131211249.106820-15-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab5bf394-c29d-456d-df3c-08d9e4fe7b8c
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576E19F5A7ED7F2FD9F41DEF2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JN6hQGD6J7XzCEvcJ9ziyAQCgHzJFJ5YCNjwNkokrtRFF+J1xGHvB1p8xxUPk3+5PHVjkn4KgIjYb9bCu0gVy2mxdf4DNMhq66koPES6IBVni2LTjR0G1Hy5zSpwZ39AsaLxXVYJFmgQ+IOX9cre90+MkzvlJs+2z4z3DVikqLtVC0yrp7B1Awp7W6Gm2Br/XYD7Urvvbq8cCXRGm5ln5XzXLGfpq2A7GNXnyxDpczkj1frRj7vzs4O/P/5UA/z6b83ELbPDUv1ejDGiCGzFAJEHSpV8PRek38KKVCyDcsYaKDguJuXtoWG4+V2I9N/FLtOsB49QGu6HbZw2K7dMPIs3UnZt0kLMgtuw3QhFeMFHCV8/4IEAiAM0OhGVxDzAtZ6FJZo/5UY65fxxZnXFvOSn5I7goqRJVOiRx0/4D3KgrJlVhsYiY7tBAVPvzrWW3SrJvFJhanksZPgcQ6WxcezjbZA5qJdTbaymlWeWfMYPP16ZrUoQ4AqBTTJi+yfO4vczGWTIaDmN0MeqhnvN2HgC7okEvNBfwzchsqvZ2wqkv37O7NW1xC2/l3PADBWDNuM4JExRCiP29NvHiiNdJKl30SWXVJJe8PMvgtBT2j2+Kw2+AYSLPeJPL9nSObb9+IWF1t6D5MF9HXFxrqMxvutfB5+BKJaR38tqWvFk4j/oR40XibCS4BMjZuy6bsO6rSLUlQ6BSGaujzax0/0zZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(30864003)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?o/SjtmleSEJ81bL5zLYuDJw/Nj6prYqn1KKjLlyQKB82Vx4DJnUO7h8f75?=
 =?iso-8859-1?Q?bOd3Jxs2XOIMfCcwX5RqL2hI1q/OYDx0qREw4nz4xWivWZH+TBVTQzr8yV?=
 =?iso-8859-1?Q?Ynpq435jwgtNEqCYfR9vQQI59FICe/DR/zBUjxJd8HdTg9IHh7bK1UGHqG?=
 =?iso-8859-1?Q?bW05ra1ccUk/555w4wHXkwfQuawV0nJBklhwtlhHqwu5dgFOrwh6oMl5ly?=
 =?iso-8859-1?Q?t7jBkxc7U8OZ5MhJGwE3cLiQsgeGkTDX5spVZk0ve9OYm0/QWZLFreF8o5?=
 =?iso-8859-1?Q?MC1chDWe6Q2uaEilvRWh6BMyfFF1JXQSfPM/+I0ttvq3KAEFqf+6VKT+8z?=
 =?iso-8859-1?Q?T+UyJd7PBzXOBW7Hzz7+fbMtwQLGyJ2ygQxwlbOHHe9MCWe2BZ0DO8cpoa?=
 =?iso-8859-1?Q?u35KmpbHf41DqcdwHx40VvDmzpeZdDIy0nqUHcKWOjDSeTx/hegc1g7agd?=
 =?iso-8859-1?Q?0jZaxJcQEZOw5rnTxOdJtzVodt10gOuNG9w5DC1IE0RE0v3hyG0EpLIqhR?=
 =?iso-8859-1?Q?Vlct5FEJfVCdOSSAW6VyY8+JGsUVStsKbd/BxBg8MzoqR39jnKwiTMsbCJ?=
 =?iso-8859-1?Q?/ca871H5APF4a5OIoM4Y1YWLJz273L4XzUwTi6MWqinna55VvT0AWZOVlP?=
 =?iso-8859-1?Q?och4SyEXftgTSJdfsn2Q3WodliCWbiRQV3m40H9nLFozctNdGKH5yEOHMj?=
 =?iso-8859-1?Q?jQWTf/r9PfwJvnSnHGMOXsohgb5uYd65tZX4bqIdbZ/Bm/E9hKpjV5+pKt?=
 =?iso-8859-1?Q?2yoGC2ki4zP4OZ381dglCym+zJe/cnJ3TWhuBA/tPi4Rt7lGDKFy8Cw0q4?=
 =?iso-8859-1?Q?+oKCM5LrKTjpkHO95+tlxjeWtRh7KMlrDsoZBroLUSNnx0YFOE64IkUsmL?=
 =?iso-8859-1?Q?2FF8bMufYX8Pjt+nrackKieujNVXKy4TOmSritmv5RRrFuOTjrPr7nSVay?=
 =?iso-8859-1?Q?LvqWDFUic24iQNxP+/xhwGByJ+sHJOJeD5lr19R+SvVxxPzAvvT/Q1mHUh?=
 =?iso-8859-1?Q?rNPPK16QinB999h4lzQm1o6DHP83+cICxp6q5nR7iy8eIH3sjTIGDdRzGk?=
 =?iso-8859-1?Q?hVfFiyyor9wPxlzo5waM+iS5+FdVZGacVCg9Px+wWlfzGSU+03usTCMGfY?=
 =?iso-8859-1?Q?xXeELfwSFf+detRg6Gk80qK8ZHlghoS7T/Hre+TBnlNtaSAGKgU2RePrXP?=
 =?iso-8859-1?Q?gK9YAAFapcq47rDqJB+z3fzXUXMRLWwA9qMsOnYH+VVYMNORi6pPZDDXEU?=
 =?iso-8859-1?Q?8zKx66ZdsYfv32Y3pQ8Ki54YRiEFa5v6MgCKO67oEfH7Kt2TKy/mXO/XPt?=
 =?iso-8859-1?Q?NQaAL4jmJeHbh9CNFDz76Jan8XiCcblWaKSaSOxCOdguMDCyPSWGlnwnEg?=
 =?iso-8859-1?Q?TroWfKG//ot4dwhe4NyDGpz7VZqUX8sU1CIJ4meFkEIii2uosol1A3XtF+?=
 =?iso-8859-1?Q?mUjhAH5Vv42ArvgNecPv40MLZm5uDY8T36dGNbqCXEMnRgxSpV70j90cZu?=
 =?iso-8859-1?Q?fQMO5jbpna4iyEJOzU+4j50M0+Y2HaUB8rJXO805oUHrvDn18AolU0g3Vh?=
 =?iso-8859-1?Q?qgN9rDhR8JAh+H5B+MA88Y2jZq9XfthdBGjpSR5iSXo2yRfmXz4jegTywi?=
 =?iso-8859-1?Q?pydRutUYxt3TFlAaMkUS1GfhMHvqSM4xEuklFMKWEW9KxNX40GcZbjqeaR?=
 =?iso-8859-1?Q?szvQpQhB8b8bVV69V69eTfYM+L5BUlsfGXXhce56?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5bf394-c29d-456d-df3c-08d9e4fe7b8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:09.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2n2B+zQZuGZ4tWV9/0ik4cdupE67sHjvRZsLuBhMr+Is7XjhR/9uCBa0jvWV38cyC5gcF6+MMAZ2DzXn/GEahg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
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
---
 stat.c                   |  44 +++++++++------
 t/latency_percentiles.py | 118 +++++++++++++++++++--------------------
 2 files changed, 87 insertions(+), 75 deletions(-)

diff --git a/stat.c b/stat.c
index 096457a2..3d30eda4 100644
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
