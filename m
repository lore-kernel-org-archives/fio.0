Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C29FC433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355323AbhKYNZr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:25:47 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44957 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355358AbhKYNXq (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:23:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846436; x=1669382436;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mjk8BvbjoJb4+RJtbKnNxvzKxDhUVuQi8zoaRGbPs58=;
  b=R62wdWhXUzxWbM5mkt3ixu93PD04dc35FWmWumYqN4zw95wCpo46BjB+
   /KAdn92rz7vKfsrMnKc8QABPR5UUwvx3M42C0cWBtTFJq1Z6Ag4JpPc8z
   Ezr4RAnlh50UIM8wFJV/0u2eF/6TWGlDogsjx0NYRROxOeO+x8Hrw75Wn
   mlxVnHV/tNJtH0bC+9OQO0SZjoa4mQzsE3Nn7hbW1KVdLBek3t1FDxtJm
   8nvixrNmsq97lSepzp2gZ2/nvQ8IDJQUGbIoRe6v4Ilxy/yQvQT3lEf80
   JVW7pyCtFrf6nKaPM5Ox5F8j4o3WVtDqbDQ06DBX9scvGJnnTTz7TRYCT
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="187633911"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0gXqybUXEEyjlUZk2pq1BGCXsQT39hf4wEOPpnh+qqCJ6/BEuQTXfEX33sxA5nbn/VBcDdGp90IIU35UebcVbNWVW/RDmH/BJdBxbVRXFAQYmjSIeTN5UGbRzhWBp4q+7aC9aksouajznlXueADEpDJ59vbCO5H9aemecZoc46K55q+kuiEh8uBgqr+Pvk/CJ9AwdQFyxp2YV3TLL8ABvLevVJmk/6gnJe5y5+YM9zwkUnQ8/0s2PqB6o9cUzk9vjqgO0IvyJsQRNoWhB7pcGqb5ouURtGKtdbHpfOGJr9We9lbZBjW9jHrpJ8NnvXRRc4CHADu7rgneKDLVbskcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjJvRo+TrbZ4CuggfFhjCATUrUzDNzow5/nnEripZpI=;
 b=brA1dei9aAxFhSevg/6zA7OzKtlLNXT7EXSl3D4XoXPJVypSZDj9fnXXPasKeRirpPF/Ok/0MOF5SxKGwf4RwXUTKsgCfPpr0K5ZAQ+l5gYYUOK1pW8AF/6W/JcWg1Ip/8ss9F4iXDeNKiR/Ui96siHQp0qKfB1LRYFmtZrQDukCIO+9QTLrXdzW6if4wS0kb3WWJqTBGAyh+/K+/iAgXMGKUpGYXP+U7+LF7ZoVbVLkeBPhuxhHMaMmk3Wqbkgu28bGHK80M0ca4YSdCtUIdHwFjbvZPZ3UQuKQ5kJJHBOCzDraMIPin9j4E+PUV7L3CuYPmHEmBca6h9XSNd/GaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjJvRo+TrbZ4CuggfFhjCATUrUzDNzow5/nnEripZpI=;
 b=oWlWGZhmrZ/vpJKOnlw7VH4HzI5x3sJtg4uEOZ0ISFnAIRxMQHNMPWH9RADHSUza5VA56LSXPtrRB7oW+0hMh38/804kdYtChYzusCB50JrL3Lq0HZkz632M9Xa/Jk0pp2P2UWOd3wV/NH8pnEWsBiFz1NGPEfGsVsFL6J2pdqg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7478.namprd04.prod.outlook.com (2603:10b6:510:4e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 13:20:31 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 13:20:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 4/6] stat: rename add_lat_percentile_sample_noprio()
Thread-Topic: [PATCH v3 4/6] stat: rename add_lat_percentile_sample_noprio()
Thread-Index: AQHX4f843uGbSnj2WUyp4RiIbgnGXA==
Date:   Thu, 25 Nov 2021 13:20:31 +0000
Message-ID: <20211125132020.109955-5-Niklas.Cassel@wdc.com>
References: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 784ae6b0-14cf-4eec-8b14-08d9b0165b67
x-ms-traffictypediagnostic: PH0PR04MB7478:
x-microsoft-antispam-prvs: <PH0PR04MB74785F143D600060893AB1A2F2629@PH0PR04MB7478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OvO/2Tw5+kapujaXL1m4gdWJWz/g4/E4VW8rPDBmAuSbiUqofefg7lb2oynAwG/5HMcgrl34EI9aIWsywPekvOl34opVoKYSYf9P5SX5PsnaQZjnLUAWfdPZH4SUdE9lbvVqOIFY2z46qYDop/eoBPGUJ3TMlavvLs/TkZxhX6l8uKO4hoc5CbZa9e6ZfJqD4bEr1GKt4iwh0b08rDCqNTCW/EZgt+Fyl68FRFf1X6OM9DzyaysyTyWyPO6zY8lrKXzdDAwiu6hegFk2KA+w+0UifPC/ZJXWCn55gDYffTRvduJ89WJENK6IHia/XK6Irdj7X6i2i2huYAb6YWok4kMvCTh37SJKwNXyMiyaP7+HS3CTf9iArvX5oJO3AMSWhe2hTuGY2WezE/N1BNrsF9cUkNdFZa+MG1Xg0afd+KkBIuLNnDVwr5mi0nquq6PtpaUpxrySjQWQVggu+nmQCCXmpgC3WwG0TrHnn6TLCoiFJzAaO1U8roDmKraG/dyQpZTamqbp3N2N1n/cR0q4fH2E6U5BX1E8U4EIVFstLvc0SaN0i6Ff3mFcr2k1u51TqL656vMHEodvmFCtuUlIK6eQTkaV3A8hpAzZ63NTOFIXxBOdfFcizQHwV3kBm3Lu+CFPOzaeCVZf1vgaPWr3ovt1FszLGNw3zcnx+jXo2XYCnrYfNc6nt/ucafbDTJVVKYTgI3K2FKG6n8qUVqKIiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(1076003)(6512007)(6506007)(186003)(6486002)(86362001)(4326008)(5660300002)(38070700005)(2906002)(508600001)(6916009)(316002)(66446008)(66556008)(64756008)(122000001)(83380400001)(82960400001)(26005)(54906003)(8936002)(91956017)(38100700002)(66946007)(36756003)(71200400001)(66476007)(2616005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZlubqWDr/2AdFTom6cYpx484V9EpKoN5FNwQs6GSXVsVxTo6zOHmIzZ9Ss?=
 =?iso-8859-1?Q?KuTJOnpTFC6GBVJzFXRBTlbu6k6bIBcb62kvwNESioI2wiFAuQTr4mglH3?=
 =?iso-8859-1?Q?5jpI3WJVqNZ+yHgIm/uJ4b+2AR487Xr5xGBgCA4Uyov+/3f8pkeJs/H4QV?=
 =?iso-8859-1?Q?rBY/dWuBfJyPrkmbRAkxhPSUOAtA5teVq6dtWZ4KUN3l4JkZloI8B2g+XQ?=
 =?iso-8859-1?Q?Tj0z8TANtiwl/07HYKbvG86uIZUM60uC6udYXcQAFPxczNNvh5PYyy8Nrr?=
 =?iso-8859-1?Q?51C0KSt73sV0LYq6ceXTK/Hgx2Wq5Hd5B44f7qKK9TtBvhqr5V1rxctQWV?=
 =?iso-8859-1?Q?IUYoOvLhII3GvJOrHZTrVUM5Dsey4rtmdal0JKddaJdOtZTycW1GGnitye?=
 =?iso-8859-1?Q?kV1kjavJqn3CYDiauOxSjaX7dCdbvWcmGAFIhNfhtLuERTDN+qa94lOWPV?=
 =?iso-8859-1?Q?p+QItajx9TQty4imadeCs2xl4OoTGqFDOcQi/3sBZTnRPUhCVEIU1dxeWl?=
 =?iso-8859-1?Q?V/Pw+ZCMp5fn0aAoUDWWWIJw2a+7Oejg7RhQ79ys5TcUGgvbP339NKxTWA?=
 =?iso-8859-1?Q?TLlj5AhSi3yZI0x7g3q3g9qQhyBTceMSnG8Zf2NSS0nblOvmKHvwxowNWL?=
 =?iso-8859-1?Q?L2EkBuseu1CvlZwZg86HCapO6NXqRearTwVl5WIqIjz4tZEwA71GBDi3Sd?=
 =?iso-8859-1?Q?tG3q0hmz0DQnFz5C8S1aUBejSvdOSWB5Mh+i/HX/7dz3nH62bT/t/W/jva?=
 =?iso-8859-1?Q?uCeKihR37BSgsDvx19uNz1jsXN4t9Cbzh2HFIpR+qltpMcZ+s8OHoq0rEt?=
 =?iso-8859-1?Q?YC4/PXm0ea0jjRTwjzxQgTMsQH84HkD5wgKcFWBwpwfDayZdzMzvYUNthJ?=
 =?iso-8859-1?Q?v7rkqePuAOrGACn0XnKG8SBv7xh4r3IyaaPo3D0R9OVnIq9pznEm2EJbKh?=
 =?iso-8859-1?Q?jM8slIMG+gj8nQ8nqgXf8c4rqYjS69aN3Iu6Zzhhecf2jrjfeCNVTRFFlI?=
 =?iso-8859-1?Q?Fl4IW+OKdbmBc+GNKKbvWB8FUjsCByoM6BTnk0b9adwi0s0J0PQb3uc+Ke?=
 =?iso-8859-1?Q?smxIG1TgK4n47+ARdMfxp8oOEGwxVblk2HNwKJtBfl3hXogpuUPQQIm0Wq?=
 =?iso-8859-1?Q?4xocf7nMdcOH7U8LXM+0erzQjOZzF8w4VmzRyNMaDd9jAZ2dI8epYV/oES?=
 =?iso-8859-1?Q?iZMtoxbnUly7rGpoFFx2yn6tZapPr0LV8lj5u4BSRgQ0j0arqIYGyrAO+4?=
 =?iso-8859-1?Q?gwqWRlRId9Zb1mVI9olVjc7Zh2OnG8Cj4x1Xm4Ws/dy9X2S8smU+Nn0seH?=
 =?iso-8859-1?Q?5U0+6uYPk5N71s+50J01R8LpnmdGcigwu1awQsq2IrY7flSjtLJ0ewPW5r?=
 =?iso-8859-1?Q?cbG5XI2Z72/hIE3qpMCXFDFuUyT8eMOC0ubE04v7KttIyzuEx2lboMk64k?=
 =?iso-8859-1?Q?f7gl9HsBeWHE8Um5vCT6cWfawg5GZSa+/45XhwkTJp94D0mLne/l92Qwjl?=
 =?iso-8859-1?Q?LN80BaoyNtDUe+h/16qIpwDicW8yJbuaQQkqWpDbMrWucEXy7vlISWndYv?=
 =?iso-8859-1?Q?w6hpGR6B+QjPnzYQEyKez+kGa+Hf8ART4+WZNeWZbA82W707aeBfLGPKwV?=
 =?iso-8859-1?Q?bsp8dc6whqY0RtU8LeTa5SEgQ1ScXEZFyRvfLYLAtZpkQXwVIuRUTzHUJq?=
 =?iso-8859-1?Q?AjwP07XzwSupxpvX+yk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784ae6b0-14cf-4eec-8b14-08d9b0165b67
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:31.7702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GGYB5IQVVfuKUwKZ2TGfizzn9zoNCX+YCtQlvzF+xO3uBdDnbCcdQdfhbQpd3Y3SL8xpy3BofUEbFmciRyFnJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478
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
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/stat.c b/stat.c
index 1e0da99d..28e49a89 100644
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
@@ -3117,7 +3118,7 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		 * the prio lat percentile sample when lat_percentiles=3D1.
 		 */
 		if (ts->lat_percentiles)
-			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
+			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
 		else
 			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
 						       FIO_CLAT);
@@ -3185,7 +3186,7 @@ void add_slat_sample(struct thread_data *td, enum fio=
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
