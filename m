Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9F2C433F5
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344409AbiAaVNW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:22 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27065 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379839AbiAaVNT (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663597; x=1675199597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d35LhhsLC1lY6gmU4V7ty+aM6abJI9UumWireb0GmIY=;
  b=L2JGKaN5kr9bgL+sJg1woE2HYkeYwVr3uT7K7VWbvMVzvd8aSwoEwDaT
   D6Qe4X9/xqKTTWXjfC0ZdhpcqKxwIgMBr175gfz6zmEN3FKO2SeFa6T2q
   mOnmHhksUBWmdQKSyp0xS6qEuSvZGBN9dx1VXki/Do+fmWF2KhpzV67Ya
   Q5GOtF+lg027A0C74Kii6friWDfVmnDigLZ2ncKd5FeK/0nrylX3AfNEB
   iWuG3KNVdxsAv0PKGjF8Kpjgo8BtcEg+Dj2+L2lXzoTs04a2slgWc/ajQ
   F5GKmrrbPO5Ov8l4JzvkTnaKJ0vrOrJ8mAlyXnJqynkKjF09K6lx489IQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="196633910"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqQZJrA6swrwCX5SEueRApXYOd7hFLiIZdrdmJRImLBD2Bt71mlE6d4n9oLYqNTNKrCKgoppWkvqJpBe1DE7KsolIvB8QlZiC6T0AhrDj81xaxOQRuzKkOl/LWh+wPwDh7PZ14VZAO8ETNw97CicPb4lmw5QJmzifDWYk1qi05XIOhEPpa3na0SRI/OLbOHRuNAp5oODMCLn5tM6TIeghomkZcy+gyptYDoEtQx51xvOfg6vQEZEGpmN5RQfF+bboIQavRDsDlujayrw4lgRSHfod3kvU4XQWKgrEbVkhDD65rDmcRIXHY1uk4ZMmCY06UONFP4p6fjpQNWL+IqF8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcWC4DT6i7c3Q3NtDPDrHBN9fxj8jw9NZHv7mXZX80A=;
 b=YoeKR/6GymFHZT2D8NdIKlEUzfKBSGVBeYC8GzwXflVnnS+01x7hlVorMZFgMozUsBtViAbK9hsJ8moZod0AeLvT3Et67K85FJIIUC2B7tEsLpSrhlMbVF0nzC0GbapNMqT9R2ai8+F0NvjmNCnBYsSueFQtWzvpkU26gXACJaxzcYZ6yXXZkskQ+rvm8hy5dsSharN1LvCUU6871FQ3fN3390/Ohu3Rgvji15CJhTU6x7ac+kInOYrqIMW1zApFVf4YrDVX+SAQTpqHujc4eT11XVmmLeY5APmPj5IZPy8TMpmHJ0GhmAHZBF7a51f0v8guW4fTFKGuex62DAQyeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcWC4DT6i7c3Q3NtDPDrHBN9fxj8jw9NZHv7mXZX80A=;
 b=qCxYITraXKKQyDbtmKL1IlqQWerKhmnxDZCYj7CGgB3acP05Ae06X1PbworcLzDmZ7tMLnjfGaAvvMiZ20YoHWE83GcjzWLKjGB8SQBaqp7nVCKupjaiqFOkzTOMrALidisHrRRXpRbNbvErKx4Ip6lzn5fT6bkuTHv0dZroEfs=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB4881.namprd04.prod.outlook.com (2603:10b6:208:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 21:13:12 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:11 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 17/17] t/latency_percentiles.py: add tests for the new
 cmdprio_bssplit format
Thread-Topic: [PATCH 17/17] t/latency_percentiles.py: add tests for the new
 cmdprio_bssplit format
Thread-Index: AQHYFudaow/5HVSpk0uYgXpUhoXhkA==
Date:   Mon, 31 Jan 2022 21:13:11 +0000
Message-ID: <20220131211249.106820-18-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 9625e4ac-9ca1-428c-e0e9-08d9e4fe7d05
x-ms-traffictypediagnostic: BL0PR04MB4881:EE_
x-microsoft-antispam-prvs: <BL0PR04MB48815064C668C10A2760A85AF2259@BL0PR04MB4881.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mQJIrdc91UXtPNspF+QkTXJn0cEpzKDrzloXQBoTeGaY2LHg70iGfw+X2JSgZOgFdLOnnBF7+wNnPND1xyI2ZOOD/RWYzVsqsI7ZZdOmRyc5Wm+uiAISx4Qnq4VBgy/CWefWB5nu6QNlY7w4+9YMQrMg2e+50D4zsS6VaxOgN3lwAZXVlLfGzOQcdTzXjJzy/lTr1lDSSf1VwQaBvkp7cwH5BxiVEo6t4CuNdMd109AgP3c5/2GX81+bTND4BQLhypYTesI5/l1d4k3ycp8+N9TSsLKaiPEXCpfu5JJptvjb2qnLCTBwEkOSnL3PR548//Pp6ncmMcOSJ65lvGBJc3BuzVsWz1x6oxVGy9ddO31YrPlc5G3oB0l3wuL1Cl4+wF7hEi3dSZUpofJFsnzOX8EEBhbLiEyc0ky0HgJ6VJt/1v9pzC7ddFFCsuVGCy8Rdv6tZC0YBFTQ8FNHIqQfbDvYXit27OUnox463FEhxFIJZoPIcrqr7mPKLXgYY+loz6fvHbg19qvboDPdpb7TZf3KMepfU3wBsCwcC1ufQPNyZnBdzZLbfOSjPewdH74Yz9lc0Gkc+CkcE0v5Y/FcYm2nabyM+hONdgbiLM/KPHtyQmst81yQeqD02DGGu0MeoTMLq/+OJB3XVH7q7rsuzNrlWO7Pi9UVTB3OGQZYmt56ZC462rrYtKxsNsGVC9L09BvWrcbdsa7muSF7jDmtJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(54906003)(91956017)(6916009)(6506007)(76116006)(508600001)(316002)(5660300002)(71200400001)(186003)(1076003)(2616005)(26005)(6486002)(36756003)(8936002)(86362001)(4326008)(66556008)(8676002)(2906002)(66446008)(38100700002)(38070700005)(122000001)(66476007)(64756008)(83380400001)(82960400001)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4ipLevLgsmX6ltK5mWyzlfrZK1iybLy/Zg24LG6BlolIDVZo2qRUYEQhQW?=
 =?iso-8859-1?Q?1IiZzTu+Zkd4g/6jx5nfkcBw4+/SVQ2Qf+8NGiM+U3y4T7AiC6dkKmVP7X?=
 =?iso-8859-1?Q?lGrY5gJE5E7q/CbqRLY0CPuqJNEd+CLiUBVS8h1iLiqamzud1VMCB0yxQy?=
 =?iso-8859-1?Q?K4DwzELaup0eGbJAgXWy37MALhv9Df3wWSVw3RKEXLNQBuI+EFUhkS9B7W?=
 =?iso-8859-1?Q?XVfeYQx9c6qj34GZnGEmKkJPHyc0WMnUzEpZZXSY8iC5iplAv7GroMzmHK?=
 =?iso-8859-1?Q?xTZcXVoyjHHNJNmhGYc+yz4EvlI7dCsjnrv0jLgVSjo7DiLUWXX9RENcFq?=
 =?iso-8859-1?Q?27UH2RKjf1YYgrL598U4PSYETPuP1PBOQv85vIR6a0rxfut8JYEEcctXX6?=
 =?iso-8859-1?Q?IBw07C4dqtZ7s+RmPZBQlbpvGbSu2NCyGykeN2uhrKu5US0OTRYqRZ71+A?=
 =?iso-8859-1?Q?l7mAxl/GjG8MmuUDO2r65G79kP2V0Tef9alDJIQhz7+CRfl3OouL7Fw1jz?=
 =?iso-8859-1?Q?s6EwarnGJoJ4VSdfmgw0Lw7cqgaIe4E1/OxbRa0t9qOWyLO61K+439EDPy?=
 =?iso-8859-1?Q?qJDvHceEoUyYQ01FYYBX+rveeG93tLOx9fxW1RGMYvoYNrwGHX2g7pq7qP?=
 =?iso-8859-1?Q?j7rvKX2WbyO/G7A+ZNu3654SjDTWo6fL2yMA+A0/c9lXRGXzHv0WDOpeZb?=
 =?iso-8859-1?Q?556cDKdoqBfZch9uIYkZca8gxGqEbHoKNdYxzncZ3nCu+iP/ZKg37IrJ7y?=
 =?iso-8859-1?Q?5xPL6HI89YbpEGnTe/Cd+k3WXJs2zTsi//fex2Tm1c85K3TO3tK28g8ceY?=
 =?iso-8859-1?Q?OT+MyEktwVKwZx9eawv27lyCdcz+bmoAjgAZGXzi6SrRa/ahCN0r3xiyG+?=
 =?iso-8859-1?Q?0BCHPUm39dIv+lc95p3peZeGYqVnz5f2hr9+LZB6KdXQZfRoB1xuo+1A+P?=
 =?iso-8859-1?Q?wvkDt/IWdYj8HW0rIid9fpqhzaM/kDw4iNT7ecFrwPJ5L/+Flmfo69WULF?=
 =?iso-8859-1?Q?YbBezbnElGbipS6MZWgeR4V5l6226J25m8nMpcdrjmaGi+Riyeqddfc6XS?=
 =?iso-8859-1?Q?n+ffoPtGuvgWvZBaT5mOphTvsjNDTUxGGoYu20D+jJfqDQcgoCAaIRHUe5?=
 =?iso-8859-1?Q?G5GPLVxd2QTAztZayWgfH4k6cS79MntMzN/VygR4gn7jlzx+TjonGQPcc0?=
 =?iso-8859-1?Q?ewsiqpFySfc8sSiYRo8xoImzqvL+AF9zH0CgVPibFJZHe9Kccrj8A5/UX+?=
 =?iso-8859-1?Q?iS/zmCZ/l8OuQGKGcdN6VVAjM6K/z2Xp7Jor5ZXLTexsv2IjTlfPb2sGqB?=
 =?iso-8859-1?Q?XjMvs849tbGnSKipi2jlT5k5a4BS5F3C2JWDuh3IdpHHkHk8kw0cKNoguw?=
 =?iso-8859-1?Q?RwlnPZAoWSXbRtIRHsH37CNVQWJ8fuCuz8zVtZ0+ifDrHRNfEViI9xvo2r?=
 =?iso-8859-1?Q?NpteayNhFtoNF56Rf/mpkYYdf5XCZ5EKKAIdHqnPbhGeMlxv+IyFCXNzVI?=
 =?iso-8859-1?Q?P+KM8OJMzHvoT8nBF73drWRJjGqY+j+yv+J/ME4OIJwNtGinqTKWuC9ADR?=
 =?iso-8859-1?Q?hm9zDRxI1A8g1rMXO0TXqpVv+jjIS+DpgZU5Upe/CDP9bWFiCe9AgU9vtc?=
 =?iso-8859-1?Q?fsEFSPxIFwAXZ8Xlk+CBCy4igbTH7CfgSHoPuPCUUnYyaAhpYG5iytezwH?=
 =?iso-8859-1?Q?wh4bebffOidsO2Zj/JslTu4aXLhVC4nY7ieS3qPu?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9625e4ac-9ca1-428c-e0e9-08d9e4fe7d05
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:11.1863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9D6AW7iuLvJRSczVfpHzSoRduI8VxCWWmL5r86PyVbOHCteQPWbK99U6LZh2NEVmEAOoYawGSALYr/R39nTx9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4881
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add two new test cases for the new cmdprio_bssplit format.

While at it, fixup some small typos in the existing code.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 t/latency_percentiles.py | 93 ++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 18 deletions(-)

diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
index 62c4cc91..9e37d9fe 100755
--- a/t/latency_percentiles.py
+++ b/t/latency_percentiles.py
@@ -126,7 +126,8 @@ class FioLatTest():
             "--output-format=3D{output-format}".format(**self.test_options=
),
         ]
         for opt in ['slat_percentiles', 'clat_percentiles', 'lat_percentil=
es',
-                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs=
', 'cmdprio_percentage']:
+                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs=
',
+                    'cmdprio_percentage', 'bssplit', 'cmdprio_bssplit']:
             if opt in self.test_options:
                 option =3D '--{0}=3D{{{0}}}'.format(opt)
                 fio_args.append(option.format(**self.test_options))
@@ -761,7 +762,7 @@ class Test008(FioLatTest):
         job =3D self.json_data['jobs'][0]
=20
         retval =3D True
-        if 'read' in job or 'write'in job or 'trim' in job:
+        if 'read' in job or 'write' in job or 'trim' in job:
             print("Unexpected data direction found in fio output")
             retval =3D False
         if not self.check_nocmdprio_lat(job):
@@ -953,7 +954,7 @@ class Test019(FioLatTest):
         job =3D self.json_data['jobs'][0]
=20
         retval =3D True
-        if 'read' in job or 'write'in job or 'trim' in job:
+        if 'read' in job or 'write' in job or 'trim' in job:
             print("Unexpected data direction found in fio output")
             retval =3D False
=20
@@ -963,6 +964,27 @@ class Test019(FioLatTest):
         return retval
=20
=20
+class Test021(FioLatTest):
+    """Test object for Test 21."""
+
+    def check(self):
+        """Check Test 21 output."""
+
+        job =3D self.json_data['jobs'][0]
+
+        retval =3D True
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval =3D False
+
+        retval &=3D self.check_latencies(job['read'], 0, slat=3DFalse, tla=
t=3DFalse, plus=3DTrue)
+        retval &=3D self.check_latencies(job['write'], 1, slat=3DFalse, tl=
at=3DFalse, plus=3DTrue)
+        retval &=3D self.check_prio_latencies(job['read'], clat=3DTrue, pl=
us=3DTrue)
+        retval &=3D self.check_prio_latencies(job['write'], clat=3DTrue, p=
lus=3DTrue)
+
+        return retval
+
+
 def parse_args():
     """Parse command-line arguments."""
=20
@@ -1007,7 +1029,7 @@ def main():
             # randread, null
             # enable slat, clat, lat
             # only clat and lat will appear because
-            # because the null ioengine is syncrhonous
+            # because the null ioengine is synchronous
             "test_id": 1,
             "runtime": 2,
             "output-format": "json",
@@ -1047,7 +1069,7 @@ def main():
         {
             # randread, aio
             # enable slat, clat, lat
-            # all will appear because liaio is asynchronous
+            # all will appear because libaio is asynchronous
             "test_id": 4,
             "runtime": 5,
             "output-format": "json+",
@@ -1153,9 +1175,9 @@ def main():
             # randread, null
             # enable slat, clat, lat
             # only clat and lat will appear because
-            # because the null ioengine is syncrhonous
-            # same as Test 1 except
-            # numjobs =3D 4 to test sum_thread_stats() changes
+            # because the null ioengine is synchronous
+            # same as Test 1 except add numjobs =3D 4 to test
+            # sum_thread_stats() changes
             "test_id": 12,
             "runtime": 2,
             "output-format": "json",
@@ -1170,9 +1192,9 @@ def main():
         {
             # randread, aio
             # enable slat, clat, lat
-            # all will appear because liaio is asynchronous
-            # same as Test 4 except
-            # numjobs =3D 4 to test sum_thread_stats() changes
+            # all will appear because libaio is asynchronous
+            # same as Test 4 except add numjobs =3D 4 to test
+            # sum_thread_stats() changes
             "test_id": 13,
             "runtime": 5,
             "output-format": "json+",
@@ -1187,8 +1209,8 @@ def main():
         {
             # 50/50 r/w, aio, unified_rw_reporting
             # enable slat, clat, lata
-            # same as Test 8 except
-            # numjobs =3D 4 to test sum_thread_stats() changes
+            # same as Test 8 except add numjobs =3D 4 to test
+            # sum_thread_stats() changes
             "test_id": 14,
             "runtime": 5,
             "output-format": "json+",
@@ -1204,7 +1226,7 @@ def main():
         {
             # randread, aio
             # enable slat, clat, lat
-            # all will appear because liaio is asynchronous
+            # all will appear because libaio is asynchronous
             # same as Test 4 except add cmdprio_percentage
             "test_id": 15,
             "runtime": 5,
@@ -1278,8 +1300,8 @@ def main():
         {
             # 50/50 r/w, aio, unified_rw_reporting
             # enable slat, clat, lat
-            # same as Test 19 except
-            # add numjobs =3D 4 to test sum_thread_stats() changes
+            # same as Test 19 except add numjobs =3D 4 to test
+            # sum_thread_stats() changes
             "test_id": 20,
             "runtime": 5,
             "output-format": "json+",
@@ -1293,6 +1315,40 @@ def main():
             'numjobs': 4,
             "test_obj": Test019,
         },
+        {
+            # r/w, aio
+            # enable only clat
+            # test bssplit and cmdprio_bssplit
+            "test_id": 21,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 0,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'bssplit': '64k/40:1024k/60',
+            'cmdprio_bssplit': '64k/25/1/1:64k/75/3/2:1024k/0',
+            "test_obj": Test021,
+        },
+        {
+            # r/w, aio
+            # enable only clat
+            # same as Test 21 except add numjobs =3D 4 to test
+            # sum_thread_stats() changes
+            "test_id": 22,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 0,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'bssplit': '64k/40:1024k/60',
+            'cmdprio_bssplit': '64k/25/1/1:64k/75/3/2:1024k/0',
+            'numjobs': 4,
+            "test_obj": Test021,
+        },
     ]
=20
     passed =3D 0
@@ -1304,9 +1360,10 @@ def main():
            (args.run_only and test['test_id'] not in args.run_only):
             skipped =3D skipped + 1
             outcome =3D 'SKIPPED (User request)'
-        elif (platform.system() !=3D 'Linux' or os.geteuid() !=3D 0) and '=
cmdprio_percentage' in test:
+        elif (platform.system() !=3D 'Linux' or os.geteuid() !=3D 0) and \
+             ('cmdprio_percentage' in test or 'cmdprio_bssplit' in test):
             skipped =3D skipped + 1
-            outcome =3D 'SKIPPED (Linux root required for cmdprio_percenta=
ge tests)'
+            outcome =3D 'SKIPPED (Linux root required for cmdprio tests)'
         else:
             test_obj =3D test['test_obj'](artifact_root, test, args.debug)
             status =3D test_obj.run_fio(fio)
--=20
2.34.1
