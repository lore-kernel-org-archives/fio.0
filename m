Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DE2C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353757AbiBCT2l (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:41 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34997 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353766AbiBCT2i (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916517; x=1675452517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UdBMoe66MjHXZVoBXW5gLVFWbXanRwCcSjbdJw+ouZ4=;
  b=SewoclLpazEafRNVNspwyUrj4M3CP6qTawRGrzZErw3dOS0akBC9PZWb
   SxJT7wxkqVEbswaNPNXShhjZZBv91UL8UXHMByLaqDijhqGrp1HJy2RqE
   QT4xgd06wh9O1zrILtlHQICwAZcRj5Fs7EoF2OnqfBjbfvsfM/a9cX58R
   ZZI1Uj2cSbQEipHurU9Wzyib7w7s4v7GRehtna5TFksQtK8ko3vWFVvE/
   co99mFE+ZHmIXK1ZuKqCFComFbK0ArPRXyEhlDqCYvbGRrae6Z8Iz/KwM
   n4UvjmeFOrsYz265C6+kZvcQvrNObrEmpecTyidmNxUOXHOdjCgVWDK0J
   g==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="192107563"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZ+7VwXD65emq7AiUWgqAjL/HO98Fj9gcBuM/sKIw9d0O6+gHSzuNJiQtehCQfnt2kYWdpNZFLgrP5bQBel4Ge/ruiI8dYIM6m9ND3Ojm3lfOJxJtbb123zsVXSCSNawTl9lRwP0Zy0wuTpT6R8fQSmOwVp5hSJhr/VSgYU6PL9ptQUq6it7I/OxvQFV0ZtaIV7npySH0sQ2fVrC+cO+UhsOODNuRqT2DUcnr8rxo/w6EcFWIGdd7i0zQwp2jt7nSXgiCG5oOh6Y91iFTXorbxtPb0r4PhnF5eNXV1L6BnOx0sQh7qYnJzgVVuHCiFJUDt2It7xy5Xqa8JDX5+qDqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnAJgD29xAErRbZJNAmBBJ1FRL5NRJqtioZNbhZX3rY=;
 b=ew5dJrB/sznV2oMcHpI5WYf7XoAEl6N/x8KVTMw2ZZsQluxym/k8a27cTz/E5v+pIjY/c/QlobmEHgTpeJNMeIg8S6lxa/TgnCWjDk2skgy83EZ2xQ7PfaIFHUbJPm3P7fsG1svyozU0TAKNy3OyqreKwM+3QKLPoOUYxek8Vshk0MbL0Q9DgFSsi/qgw+iXi4AASGwSoJsebnmGj0aJQcA6vcKcIaESmyQgcHfbvwSLF88nrC66Dhujq375X27tkgJBPtSeW7lTNr0hFTPrftPn/ECrNRFkmyifA49xxwjKN3/WboSUMDWA+6weh61qRIIm7TUqSGb25kiX4McP2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnAJgD29xAErRbZJNAmBBJ1FRL5NRJqtioZNbhZX3rY=;
 b=m/WP/x23je6AWXZup0gNUl0L+cOrII7eLijBVNEfeD88V/jm0bal/zBeYcJbevHQM4N2tpo83EajthHHOhWJyvHJn7F+++pz2kLAwCyOmKckdOXUc8aDnf4s6+I63t2wxCpJ1lJTlG7Sc72rkAjDwOTxSK7Gm6E1pU3aoJX1iAA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB5423.namprd04.prod.outlook.com (2603:10b6:805:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 19:28:36 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:36 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 18/18] t/latency_percentiles.py: add tests for the new
 cmdprio_bssplit format
Thread-Topic: [PATCH v2 18/18] t/latency_percentiles.py: add tests for the new
 cmdprio_bssplit format
Thread-Index: AQHYGTQ7CIeMOzM7SUywjoCoB/wlcQ==
Date:   Thu, 3 Feb 2022 19:28:32 +0000
Message-ID: <20220203192814.18552-19-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 023630d2-fae1-4dfc-27ea-08d9e74b5fb2
x-ms-traffictypediagnostic: SN6PR04MB5423:EE_
x-microsoft-antispam-prvs: <SN6PR04MB54234C1C86FBF836374A974EF2289@SN6PR04MB5423.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4HEcPhUYlblP1MLLLPdeHdNwupFVzcn+hjZH3IdiU6l5A09TzPt+/9phGxMzNiIanDXUFbT/Cr0uaGxqRM5xpCgklR3hh6F35EqmYrG1da9IuH6ifm4Zr7LZHtLKE0uZNFjbLbZakSJqcFaqTU/aBQ8JRQqyVxfmW86K4fG2SA/hyRcF8p8DjY532rBX1zASbl6yLUHfIEW3F3CO+7upanpnFwPWqkX5HLylwBHAM8KyqnosYpiufu7V00PDG7ZY3yq9aDEKHChLVYTjGkMSy3Rf4NgaBOLX1noNMHAeDXvb2tVeQIYDcAmgQjLSmrEaHR0d8td1ZxHx+76x2mtZCFQBwXUOKzma3zQvMUb/fux8HSpoByHVFAdWBWxSwVTbv+4CTdTeaZwql32oAMeKWpBdqyOQbmD9iaac3cPuKRytZInG30MQ1KzmK3emC4Cl5cfbHShmTjrT0I9FYvotfMiozTXP0YgyCLHKFRWHSguk19ZX93/eDnupBEUlqmvGGnZ+DVPHch+8JEzIa5TH1IlFYXgRrWvGaSUYclsiUdrz6BCOS7UMXvIOS+BGIpu8hcCS9KzqYTeVv7/aO5uOU+/gkjyNA/kOq2RSAzcOb0OIWfJ8QIOlS/JkIwejlW39jh0FGrOV+Z9ZD+OVWYcOBQ42wytU3BGlmdks/azD1a6iNSXhgZnCJBECJJnLBive2VCWk6M6i703/F0z+BZTFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(86362001)(66946007)(6666004)(91956017)(5660300002)(64756008)(6486002)(71200400001)(6506007)(8936002)(66446008)(6512007)(508600001)(122000001)(4326008)(66476007)(66556008)(2906002)(38100700002)(316002)(2616005)(6916009)(186003)(83380400001)(26005)(82960400001)(36756003)(1076003)(8676002)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PaYpRYy5KY+C0iHJfrUretzo1jZBf8VXJ9eJjU5Nv1bcfhJBpRV1ZinU2A?=
 =?iso-8859-1?Q?vBnKjkT+uEByPUpq9P08O4/+mb5IxVCURwcLwMtnrSnkQxoSXu8Qv49QA/?=
 =?iso-8859-1?Q?IhxNBQOMhQE8EZKR5WG9NK4BYtmZYmds+me8Bk8ojlYZI7EvBeXmynHmxq?=
 =?iso-8859-1?Q?faUHVAk9YRmFJ19IAzzv/22IqOR1AznDf7B3aYC0JSsZE3C15N9/lkjl3S?=
 =?iso-8859-1?Q?UNGUHze39nJCxL5pSL6QONSIWVIU6LgzDcqzh7K1xMdhfXFyosr9TXpmbz?=
 =?iso-8859-1?Q?b3X8hXYJD33t0/5cAStKM1w6OROxPPIn1skBpVEGYxUhTnffqfCuJZ9bje?=
 =?iso-8859-1?Q?32MLoJwG8CEdKaqdZ95ag+GD4n4V/qOG2+moDKshlM8yBD/jZLPr2X5e5R?=
 =?iso-8859-1?Q?OMP4+xj6R1PQPbhi7Z7GkCCYpjxHEe9QItLLEGqbwsmLDyqNINtw5SvqX/?=
 =?iso-8859-1?Q?ba7M+wpYOjsupCF9guR8tvOrEz2VjQEX7s9laS9tcqyUm2qAR0C4dnRDO9?=
 =?iso-8859-1?Q?mAoNtVrDRIvL/eeDwCLPQrxNHl1wiQf2c1eZvl7OdB6zZOlPOZrcnEx7SH?=
 =?iso-8859-1?Q?kT7/ULmKIvQew5P7v13mOtI4a4yzzkWxjIZY1R9DscZ90fYnKjfnR+UxZf?=
 =?iso-8859-1?Q?lJEog7eu4G47P+P7aHhL451gG60vTUp45WD5tMbYJg5safhTAxsaT50osU?=
 =?iso-8859-1?Q?03Fv0+JuSK+HPTBig9IJZ8R63KjbqGAmt3PSCtw4VjexaQ8MjdxSl648Rw?=
 =?iso-8859-1?Q?Lr24nHdVZl2C/N9h4ATi/kSoD65jmqMdIviIQGzB5EXhdEojlIX05wXp+l?=
 =?iso-8859-1?Q?BHDpv0ZZAsX5g6+hGqvUerq28Vv+mebjFfsH3866GKPf3HtUU1GFdG2GHt?=
 =?iso-8859-1?Q?qMj5UPMsX/3XmwuivM27RMX2cEObxgAWpRQSogQ6RIOLAT8LEc8rZHblWD?=
 =?iso-8859-1?Q?55QNkl8svoYbKaNcQHKS3dhg6wh49m0GZ5SHbwGSkAn3F0W2zYv9R0XX4j?=
 =?iso-8859-1?Q?GrtXSdJCQjVj9a7EltWcSIRN0Xc1btCgE2VKTpmOtyyurjPqDOauPlKt6x?=
 =?iso-8859-1?Q?oMvafSQXNRtUpkCFLXpDu4UpJ+JJtuWqSrAk7BU/1FNEKdj/ZYaGxDD0Bt?=
 =?iso-8859-1?Q?YuNOXAb354Nnw6XkKZhyb0AO/VIU4U0rK6r68dVaA5VGIRXyDk/KtIDh9u?=
 =?iso-8859-1?Q?ws1m968oaC1fKbaGiORtKuXbOMP7OWcIgO+KEmUQqLOd0TX5rnTnWi0yMS?=
 =?iso-8859-1?Q?SGWwrmfcnMRwVguEoukFuUND62Wjqbb89r48RfFJqtQcI+8IcrP8yclu0d?=
 =?iso-8859-1?Q?Kstm2o1dXUa/EmH0Die6lEyyPYSKqjCDQaD3sQoZY5BQKXDfGH3WkKNd/y?=
 =?iso-8859-1?Q?ff+D7kZkpTzF1N4s5KZQgK7UxLEXoHvsKXcQ+9Et5VDOGmWmGss1Ndr2Iu?=
 =?iso-8859-1?Q?hUOmxfcMsZe0i2MfnSdzGTF9r4dbQ/lL0CDqvMDbZAfKCefCNP1x2EgQAQ?=
 =?iso-8859-1?Q?/CucsP35eb9zlfV+eh3SDlY4PXf6E1URm9gZQBnQ3LOLj8jWZdqULckfLw?=
 =?iso-8859-1?Q?HYOEKGAFGQhW6blLByF5SEEUJXWBe70rZ4+XPvYu+MHNjWoYk2oNQnzkm9?=
 =?iso-8859-1?Q?prO0VRb5sqC8T/DM1wHT5qnL53xPKVQ1xAivBMf0U5hJ9GGFlXUM4y9le6?=
 =?iso-8859-1?Q?lBGx3YV0g4Z8W8Gcm+/fVfJSjiHVXNFjU2h4tEnf?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023630d2-fae1-4dfc-27ea-08d9e74b5fb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:32.8537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: siM0zfmbOQrEYO5KKoBnaru2rYbsmSLS7sTSExd7D2jQfY1bwPIiOPVo7E5KKUld5GU1BNktE+Ef2W71PGoCXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5423
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add two new test cases for the new cmdprio_bssplit format.

While at it, fixup some small typos in the existing code.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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
