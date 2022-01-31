Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D548C433FE
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351160AbiAaVNR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:17 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15176 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347171AbiAaVNI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663589; x=1675199589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HG2fCQsQCthuIeiUph68n/U0itQsAaHnovwF4c/joZo=;
  b=KEi1ky8ZhyVJhXqfOHWJBXz/D50erOf6wGYgK3HmPxyxS0z4a7YZvca8
   i0O/g6Nzi6mBJ+6WVgt45pQP06XOoZHJ1nyppfOVo5S8wOlGcrS3/62pd
   VcaRFNmHB8ANrNCH5729B7Iulf2wdsj6YuWA5EAn74fevqqBq/eIXtxLn
   j1CgZ2jfdP+2anijEk8mrLL3aZOHgA6w4JtBdXwWdKxX+UKPbB7S6dnvU
   44IaiMj2Rm7nMtTeMK2hNI74n1rhVB5Rx2LeV3KCFaFkN5iAed6xvt2Xp
   mdQxEEzeWyTY0kdJkSrFjx5XHQiKA75+GNm4JkGsalmJrW6x5TpFSN2vB
   w==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720257"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBrXTOdLSwR7nvzX1qei9ZfrYZKKYvFrE78p0YjDjOSkgKKLUUhJip+Q1E+Jl4w3Bptlz206vC/dSbx1hj6bk8jUNzMbfQlQXV9V6ZE+pKL42lLW9xQtUp2/PvsX9jZSNTibZKRx8P54Us9x1aeLbU90/S1ctRlFbC+5ihsyT+vlmr1lC9qgZjFNE5I+jnu8T/BaosK9c7SnxcSfnPdMhoN8Wt+Mes1brjyuIDfRJCdmZ/BJci6qQWRYtNQzWTWvR5le5m3dT4ImCrB5e6KShhuQdSdOm9TDxGgDFkTjixJl3r6UtHGgAmZQJyBt7g2GPj6EaXA5Aa0DnWR4KS6zig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HG2fCQsQCthuIeiUph68n/U0itQsAaHnovwF4c/joZo=;
 b=fEgM5ZElkWs2UDW0dlsAUpsYpqoZ1dhoRkXt2sLN5AVHXnE2KStrVX5prsUjuJgEoW4lukRlzFGewsImukA3GTp14kyPPNVGYzqw9oOPpHpV94a1SC2D3XkhcncQ4oRwgLppB55V34SU9WDdY1mirN3MwuzWkTXQqXtI1VEeR8MG4h3Rjj4D1ASsGhJR9MjrXMvUd+vCEBaReGFkuAJyNdUwzBBGGO0umjoqcYU2OVYu+RQmfmhvZ97ne9vezeGffHZXyBNrN0cjM1wElPyLz9/rrqTcrJJfHJSuLtUMcl1N1KjlRxFW1iqAOJrOv6YshPEHOe3nvCloE1i+oVBQcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HG2fCQsQCthuIeiUph68n/U0itQsAaHnovwF4c/joZo=;
 b=LGbGbm0oMiL3KbrcnOZ4zGHGnL90tgfpK/cxvx8e8SJ34d+4ljz30ZGvBwm290hZXJQFsedToJy4nHlSXeeBiosObUIYUeuqbE9wKCbi4gzLCDkdLUU9f7RweDdPkTFBQ+jpfMQ+9sOyuvaz/Q3AHnmqBYEnnJkz7bql4iNXz/0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:05 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 08/17] examples: add new cmdprio_bssplit format examples
Thread-Topic: [PATCH 08/17] examples: add new cmdprio_bssplit format examples
Thread-Index: AQHYFudW4YACMv30zkqcevEUxx2/yw==
Date:   Mon, 31 Jan 2022 21:13:05 +0000
Message-ID: <20220131211249.106820-9-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: ad005826-9e70-42cf-3ca0-08d9e4fe7948
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576F140737EA28B308EC186F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kvsYl30Da3N0l+QAUBcVIh7WgbfbKpG6Ll3b5vS73UVR2QhcR6jfHMp5ftRxo1Asmn657k6/NYtctMVN96/xHNVvlL8QZcih6TlZ1JUpLJ0+HrgmHM9ugjVuX3b32mU87/Lw0p/lCgH/UoYPHaImj+CUUIl2f+pOMGyGB5Ny3Sx0pVG2cT4KZxJb/CyglYqJH5cXqY/pcNd0M4OBMcE8U2ETV+OVIDdzWpkuAF9AVIoEmApxlKbAQ2pKsxCllJZ77FAAY4iWUZREPoIgsG3W44LNJapGlop6L0S9p1bLqN4HFp13r2pmvwXh6AXad/uTKdOBsPMuATklRKL3SLhqYIwE+EIFQ9Xg4xeLXV7iFLYAG3245274x0Zrm9KWNwhgax5FrogXOg49VdJJL96aqdO49bVqzUA1aolZvoYSmD0DI/rFqMhBHbArASXSA8Pj7cchHL3RB02gEuXMIRk6SGsZt6yQdbAgFeFDrEzFWUrWDzwcm/iGbcHQIdeSiA6mIELjjM75zsYP7cx+qGwsU+AqwVI6H0/oPNScI/nYFGiatvAeQTDS6MxvNvIdVp1dkw1BHpyR5qtaR4MTRolOyefJaJ7BbB1aH6vpU8DOo75uf1R4MvQ0S5TRJD9rNEjwL0aNVDGvVVsQCm2xkf6S3kci+DvAOD6H0bQvKeztAhc5AmOc+dBa1azSR/v3im3mx1us0VA0PORlSrE5rhbnHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0OrORYvmmehki2mLqt7y4VLKX3kjchu+jHmApJKay2BkVlHCA45fJahOSm?=
 =?iso-8859-1?Q?GZ++mZW3yC5RBIDsAH/f7mCx1psriKl8aa4dPvgbwY//z7plBjz5o6x8Ip?=
 =?iso-8859-1?Q?v6LeO9sAMkV+FWKLMjjB1utZ7V2QDakSKMTjhEVOwz0OyEbH9e5QQ65OgX?=
 =?iso-8859-1?Q?0QTXabMkwAhUjDwTIk8rlRTjREo1JdP4L5q1H3klsCtcu1AJ2noay6Vdlm?=
 =?iso-8859-1?Q?6B9wXUuQaL268KlbMcfrQ9BXtxo30gUn1Favb9JEBAJ8Oq/0TLFRPqCazT?=
 =?iso-8859-1?Q?6LsQ3qBvoWRfvTHzPHXtiCr8QTEC5tU9uZhflL6P4R7X+/SpOkOCfGrJ5v?=
 =?iso-8859-1?Q?Ag9MttYXsZN6z16rPA/mOUekxUPTfpXzDR0dnxNJQB2uIa6IqR616oW/fr?=
 =?iso-8859-1?Q?vZ6igejkrJAGWCLeRybzASjy5Ahl9W3aEn+K4VSV0oHbiDD9NU1KtVRbRc?=
 =?iso-8859-1?Q?AlKl3A5j+f2EH0uQZqdX5WoeQxlCjIqQMG8/SaWJsyzioCTr10auFRHTGd?=
 =?iso-8859-1?Q?f+shFkLRxaf7IAhHr6qYnEUmRmL2rU84IMuvzFOQSR7W5Vg4VTbn0wFHhb?=
 =?iso-8859-1?Q?AhLLD9F/n52UvBukMtUVmeqDe8TAMXNnYA0lPoMrus99zWDwn2mxQ52GZl?=
 =?iso-8859-1?Q?n3fUs2bZ8N0bhtnsJ2BTKdyrxc0vcYjSX5/4FZQLeGnEWYFjvKTet+xpzO?=
 =?iso-8859-1?Q?AN8KdpQ8G9Mc06I+rLiI5jZpTN3ek0pADhWytkD6J5lptYCy5vm50tAlt4?=
 =?iso-8859-1?Q?5bkFtSdaytOP5sEoS9aGfWpPLiYCZYYYN9v2kYC8LskMvGKPvdlnudMFz2?=
 =?iso-8859-1?Q?Zf7t+I//BaqFCMLGS/599MTrVu4Pm0VZzR36qObC/fbkZQ4+lPBP5KINQQ?=
 =?iso-8859-1?Q?UMHOFfzHDgL1sPKlWvyplrq0UATJZAOmX7kQn6MQS6Clti9e+u4p7mWZR1?=
 =?iso-8859-1?Q?3gXKuc7IWtBeOszsiqu8QoJ0FCqPfOyPelsCQWSzPtDfn4YECm47zLhlSI?=
 =?iso-8859-1?Q?Zx7ORgFsnLJyFAF3PhFHg6i8XKbvvHctpZvh4TBit3AX1L3gItacDrnCun?=
 =?iso-8859-1?Q?UWAj9+1T8xP7JXqkQ1ZHm+3f4ccAT8Gycxnc1rgyl0jWKGpZ2wseRED+02?=
 =?iso-8859-1?Q?U7dXbZFZZcLJ1Yba5wac5j5F6rmnZO5yTpZeJ6By4HYJnMfj9co+DBpX4L?=
 =?iso-8859-1?Q?+JdsNWvJfhsz2OqUEXfbUaptidVLYa9KN4jRYH2ssSUvDvE1cWGgoH3dDL?=
 =?iso-8859-1?Q?vDvuPv9YowROjE+V/fO6TvDpczt934yU0I0ZIkfcA/F7blg7aHjCUmX/mH?=
 =?iso-8859-1?Q?abDkr+FZx6XaSOt/+HyTPo/nMKkoVPA5CG2w8D3FwG3uVnTvN/picBD//5?=
 =?iso-8859-1?Q?eL3mEfPJHlciJ2EHKu2NdvMSuXiijRaJ3/ec+WPdlczEE5WQGZkAVYQeRA?=
 =?iso-8859-1?Q?onLBsE5yq1HnIEdOXt0ycMxJq3fFkjVnAqw6vSKzIYf9PGH32d+A0TAt6T?=
 =?iso-8859-1?Q?NPwz7NJvwL7x0miEWmdXE0Q1vfZAqMB2rkwCxvxg/u1mySIMS701UvdaNn?=
 =?iso-8859-1?Q?0J1iQKUznA9oGjA79KkhZSsFWOrrzscJh8/YZRKYohy4CZ7VXC5lsO1ItV?=
 =?iso-8859-1?Q?P/KKJsFd4cowJ4QofPHPeoAhqloaeRXUQrxP39J3SVxLN1AwJcqkCOkkcp?=
 =?iso-8859-1?Q?RBPfXaAf+NMzgfd7jgZhAPfE2+O+BY9AYcmE9xNP?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad005826-9e70-42cf-3ca0-08d9e4fe7948
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:05.6146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyA0BSmVyN+U0x3bME6Qm1y9zhDLPINSjHsr0KWu5c0nGQMf2wNavq1a1l9r9CJheq9BaZAFsZXiDGU9w5N6Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add examples of the new cmdprio_bssplit format to cmdprio-bssplit.fio.

In this new format, a class and a level can be specified in the
cmdprio_bssplit entry itself.

Add the new cmdprio_bssplit format examples as a new jobs, as the old
format is still supported.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 examples/cmdprio-bssplit.fio | 39 ++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
index 47e9a790..f3b2fac0 100644
--- a/examples/cmdprio-bssplit.fio
+++ b/examples/cmdprio-bssplit.fio
@@ -1,17 +1,44 @@
 ; Randomly read/write a block device file at queue depth 16.
-; 40 % of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
-; 100% of the 64kB reads are executed at the highest priority and
-; all other IOs executed without a priority set.
 [global]
 filename=3D/dev/sda
 direct=3D1
 write_lat_log=3Dprio-run.log
 log_prio=3D1
-
-[randrw]
 rw=3Drandrw
-bssplit=3D64k/40:1024k/60,1024k/100
 ioengine=3Dlibaio
 iodepth=3D16
+
+; Simple cmdprio_bssplit format. All non-zero percentage entries will
+; use the same prio class and prio level defined by the cmdprio_class
+; and cmdprio options.
+[cmdprio]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 100% of the 64kB reads are executed with prio class 1 and prio level 0.
+; All other IOs are executed without a priority set.
+bssplit=3D64k/40:1024k/60,1024k/100
 cmdprio_bssplit=3D64k/100:1024k/0,1024k/0
 cmdprio_class=3D1
+cmdprio=3D0
+
+; Advanced cmdprio_bssplit format. Each non-zero percentage entry can
+; use a different prio class and prio level (appended to each entry).
+[cmdprio-adv]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
+; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
+; All other IOs are executed without a priority set.
+stonewall
+bssplit=3D64k/40:1024k/60,1024k/100
+cmdprio_bssplit=3D64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
+
+; Identical to the previous example, but with a default priority defined.
+[cmdprio-adv-def]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
+; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
+; All other IOs are executed with prio class 2 and prio level 7.
+stonewall
+prioclass=3D2
+prio=3D7
+bssplit=3D64k/40:1024k/60,1024k/100
+cmdprio_bssplit=3D64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
--=20
2.34.1
