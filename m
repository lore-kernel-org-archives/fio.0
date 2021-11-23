Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AA8C43217
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhKWOai (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:38 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbhKWOah (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677649; x=1669213649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DZIz8JZsw/BrAJHVuC6LO0ijM5mSNGw/HIJOrJydOSc=;
  b=Aa7d94HGNjhA7TjL0IOBQ8QzbBcbeq1Tul9lv7vUYXnVdy1Poau7Dhcb
   t0KQ5A85CULSB4BSgwZqb0yd6O53FZfy0D41JiQG4yNtjNjCmP0MmY5vA
   ybgLlb8Ids+xlKbybTIHgijzJ3aVPnms/IrE5eBFCZjtG1YEP1OgdPEfl
   to3ZJLF/cCHeS4SDYBFsxaGifs1Z1P2k+8o/3MezfYHg5AklVZBA2K2Tj
   4EoWroLPkmkcHoczTeWyybvfiiYDgRa2pTKCM496N4IUKa8DGaFE0J0Fp
   BpW+nev+A3bWvUbb4np01DldW/n3NYxmFKYfiiqYpueHihh7m9Wn3AjIi
   w==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250423"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntYcWbOtmh3LJU+5xcWEEnkrIcBoI33RN/HfGZ39HB61wFZEKgK7RmpBLwqxtwVWWQR3JimwSrzIw7uPJkHYuThtpi5h+But4LZXPD3UxlFObG59evUX8aiNWN/COZI5pDFY2xxvkzmrZukSlJ4YlWIzlhy2SGAe8O8qr7uUcRpLkYhO+feXvtWlbf3dqxPXl5YA5/SaJgNgDOn4XfCK5v73a19N95afUgFixRMI/aH8IV2WKRlUCv8eddvNsgvRPtFobbGZc5j4/oikDr1rKvWzA0JR1iZmOcsDRGMeDOzEvqSBgoxmtunBJ+esG9Mvs19ow7W148X+WHrGUgaMow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zitfYD0fiwUBXDkEUfVIP+cg6YZXhjPgiqiasyzH8tI=;
 b=lyvkAMljKD6o8Uf52XT6QV0Gr+GIa/dt1uEQGJ2Nq2bbXTMZpm7fRcNf0NqGMKAKp8vUO7GNgN052VG2pWfi3QufGCCoTMKO8h2LEhFVCs53cg5RHdFokeEr8UnHny185oU2FkqsSj62z0y7ddFKy1AMQlSX6bcPO8gy3VQXwo1q3uH+Mn2EUEd0z1G9NJKsg1SjhjwBS09TwozxYecj4c/sGA8uHs3i5/XsVT2evg9ZYWKzLxFLeRS7xO6r8jIl6tB1q4aGKX8IWwPBp2sI/BbTxbPAP5w6T8wdx9deuCmda+KnozBJHgVMhle9CwetHCq2qBhZl6mWtX9tp7BfKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zitfYD0fiwUBXDkEUfVIP+cg6YZXhjPgiqiasyzH8tI=;
 b=IXxHyqFaO0lrPq7d3kdKhsYv6tcFtfBL/6cqfhu1BoM2J7oXD2pfN/Vz6/BwCiR3bdPN8Jnlor6IpX4CZyZbrFrzIkkSe+av1HxXk0FD/YJqzTcK6az1mrVPZqwk3lDtT/2tSZmn/+qj04qV3dq3ayqCAILd3zOI2Vngz4JfoXQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:27 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:27 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 4/6] stat: rename add_lat_percentile_sample_noprio()
Thread-Topic: [PATCH v2 4/6] stat: rename add_lat_percentile_sample_noprio()
Thread-Index: AQHX4HY9TYdSWi05mUCWPeSWOljuxw==
Date:   Tue, 23 Nov 2021 14:27:27 +0000
Message-ID: <20211123142708.48867-5-Niklas.Cassel@wdc.com>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09b00350-a79b-4410-3af2-08d9ae8d6055
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB758901DF90B36E541480B3A3F2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WLjfUtE8yd/YQ/PvQlCwyQ9LVYr+Fpx8txDTh8cNmGm3lffDnH356d+9VUJBnbOwGQT5Tsl1qlnwZeSeq9BHPYITWcLQaqNGdY4tpMA5Ww0nifV+d5Ik8t9fTE4cisW2syIU5+jQgZIOUMLaJAXk/sWNGjVtJ8/V1yC8ApHDtILC8hOj48SLPVKgOYkJz8DJDmhrMSTvZ1yps4BzYPctqanJ1EyHsQPb4Bb0fvbyoKhW1d/xIxRblMVrL+B9PUKGbfSli0o+sN33jEZ/0Q3Se4g/bMl6ZjmUdXenPVfo73XIfCekPl/vjICQEt7okpfuY5XSxvdPnYAYWAMpIEF4EQVi3A2G7FSaBjnVEEVbIetMSCpGe5xrjXAP9pZAAKLzGIcBE544ScYBMnggZYdS9gt4bRMvanRx+UNtCK/+gx2FzgzO+EAFIkf3hSmXpPNUwlXp0L+pHrZ/S+C59FYM+T3f3GhCWLfpBveM7CkWwELwOhmax4pAxi+vxEz9zj1DnUF9Za5nMkVRMPnRw1D6RBh5Uy9hClDTydtovdpob2lHFgs06Tk1t6iQZYaNOzmL53nmIWJflbsMoAn23M5BKmZwKDSsHFzr8oE9olf9xzRz5t6gKI27VMwwcFu2y2pm3AvR7ZPovwBvLfUdpvxdsGxnktX8t3PNy63jISQc/ts3LZF8lfyKmVoZa2JUzNBOmYjj1e+irtwHhMIj3odi3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(83380400001)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?32mnFCfV3AVZjz6APfxddVMBT+JmuBm+HMMO9gHsa/IUGSouYbJpo3wBFK?=
 =?iso-8859-1?Q?UH4pybyAGfWcODuy8k1adNuG9F/kZfnWm5lTHy1/QyiaQv55nLhZ0dW3Cb?=
 =?iso-8859-1?Q?SLrzGMEATB5sPrQslbZr+YcHab165r5jn5QoSelOHdidRyzYMFE4lJWVEx?=
 =?iso-8859-1?Q?tZFQ4oXn6FozvkSRtXfRK+PsRZL46Xsx93pzxbfXj+xrSykpz78h+7DNvi?=
 =?iso-8859-1?Q?RccoR1PKjNn6H1XZ3A8qmf3HHvSXcthR0ye+YW7ixdOXuChwpu7ucv5cuJ?=
 =?iso-8859-1?Q?Yb1OWOqfa+LD1cdcUgAR0/QhZLswI+CP+LjZOzrmzDJ2N/Q8kgerTnPExW?=
 =?iso-8859-1?Q?BpwVK4EOeQKqyFoajkysTwBlV21oin153n5UIupPlMPYgz9kaZgfIRgEKK?=
 =?iso-8859-1?Q?rFO1sNiH5kUKGcgfyXZL8U9c6X+fzgnd+6vojPwRyqhF1Awjz3XMm97Z4K?=
 =?iso-8859-1?Q?Iy5YIKLLkc7Ho7CHyfxrPEq0b5MM5WS+WfEhNpt0UOdK2iB+apbvW9PzfE?=
 =?iso-8859-1?Q?m3EvsIm0UjpehtWj3kECaJh8W8OQf5Q+FCB6VA6kPjSfoaS1mjFp+GqLaw?=
 =?iso-8859-1?Q?HKaHHZ/tApQpX0xT/dUqw5SZPSUnqXN9Ig5LF5PG9EizwAAVkm9McXvnsx?=
 =?iso-8859-1?Q?jNFOsRRTzMOLkspbyHrx9zxfzSMx+zz3F4VUJ1AZ+fGT5zWkFLUhlpDx+r?=
 =?iso-8859-1?Q?GURcJJCodK0B3bAeDEZittKYOsycJObKYI2jARPuJSllC5BzjmvLlpwOrL?=
 =?iso-8859-1?Q?0iFLpKxFbJ+nNVn20Pk23+HKb+X1Ff+lH43fDQRpFY7ceaXXIgnTEbSjhX?=
 =?iso-8859-1?Q?jRczqWiqfwPCjpWzQfrUOKBPb/yvroOShD9BmBwWs9IqgLCwP1TbPlPg9b?=
 =?iso-8859-1?Q?wjymkC2pNhkx19g6WwfKmioiqVhUqjzfx4f07BeYW0zpMhb8Jeuygk6Uu+?=
 =?iso-8859-1?Q?031LdeKycwfCfGo4vz0GMrvh30k8O6FhQZ+wsgU40owii1wzFzcwT2tYIs?=
 =?iso-8859-1?Q?sFdicQBUOkuWud2bYmU7UVYczcdr4m02MNivHtdoBjTugIrI5/AOwmgqyL?=
 =?iso-8859-1?Q?0LvrP2uL8qIpeXreGtlhPbYxfP10p1iOVF/Yt9ZbPOrJvhVzHgV/nfkGhe?=
 =?iso-8859-1?Q?Sz2B/PQRLmbe8wDtKV8u2selngm8OTmfTVLzFeEH0o/Bq0vazoBRmiEoYo?=
 =?iso-8859-1?Q?nmFdezOl72nsp2i0s8t7/XrRmX80AFCg1Ec5PTY0dni1xJUwxED4jEzk8+?=
 =?iso-8859-1?Q?EMX7l6y6/IerJEUVAYSURi26THAPkhoryDkM/PN2/HzoNWc5Em7BpSt4aV?=
 =?iso-8859-1?Q?C5wExakc/IFn0ZzdHIl01x1oyN4XoJuarwem3Oo4bHtPlvVakKkiQNcjpi?=
 =?iso-8859-1?Q?Z/ZfoNzwnSPqWHzTmpR7i5aGJTfPGUxXNHDTSNdPUJ5FxksabAiu8EmY2w?=
 =?iso-8859-1?Q?+13+PDE8iJRK8PtiVynqKaYFFpSEIuLNKDWcQQ3sAaTsdzCq/7Wuc9vlA+?=
 =?iso-8859-1?Q?704Wbpvl7q1RSJ9QDx07cF8tCU5tEXHrECmd39fh9mugpbX0M9R7qbTyNc?=
 =?iso-8859-1?Q?SPXlp3YDtLiNBQklcnS0TqbaRb6CkPpoxc8fJaGG6AVo06apLry+Rn3418?=
 =?iso-8859-1?Q?mFBbxt5yHso23zrHbCjrFLABH41hfDsdK6rLj0a19copFICzReggzNiQZa?=
 =?iso-8859-1?Q?zsoUCp7bogtvSs9m5cE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b00350-a79b-4410-3af2-08d9ae8d6055
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:27.8569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1pbrvOjTFm8mO3qzd70D/qUPL0Kac3/tgyF3ULiyPu3i6yLmHpv/f8ohb97u2LgdgtVqXsYyINr0d0e3yEoMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

add_lat_percentile_sample_noprio() is the regular function to add a latency
percentile sample. It adds a regular sample (it doesn't add any per
priority sample). Therefore, it makes sense that this function has no
suffix, neither _noprio nor _prio.

Drop the _noprio suffix from add_lat_percentile_sample_noprio(), to make it
more obvious that this function should be used if you want to add a regular
percentile sample.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/stat.c b/stat.c
index f5d5cd24..4eeb1c02 100644
--- a/stat.c
+++ b/stat.c
@@ -3052,8 +3052,9 @@ void add_sync_clat_sample(struct thread_stat *ts, uns=
igned long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
=20
-static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir, enum fio_lat lat)
+static void add_lat_percentile_sample(struct thread_stat *ts,
+				      unsigned long long nsec,
+				      enum fio_ddir ddir, enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
@@ -3068,7 +3069,7 @@ static void add_lat_percentile_prio_sample(struct thr=
ead_stat *ts,
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
-	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
+	add_lat_percentile_sample(ts, nsec, ddir, lat);
=20
 	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
@@ -3118,7 +3119,7 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		 * when lat_percentiles=3D1).
 		 */
 		if (ts->lat_percentiles)
-			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
+			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
 		else
 			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
 						       FIO_CLAT);
@@ -3186,7 +3187,7 @@ void add_slat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 			       offset, ioprio);
=20
 	if (ts->slat_percentiles)
-		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
=20
 	if (needs_lock)
 		__td_io_u_unlock(td);
--=20
2.33.1
