Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641FCC433F5
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352346AbhKYN1r (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:27:47 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44957 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355299AbhKYNZr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846557; x=1669382557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NPe2kiEno0gC3YFjg/bNX1/h5UaEYrdFgdvo4K2OSWw=;
  b=fOKM7hHoQ1mpTxQJRleIjx28leBR2uCjzsuSeropwkrtDcwhAskrOAbW
   h/LWOsX2o+7dyBBBlu9mVeBqnQhlc2umv5D0zcuLomsR6a3SeDHaNXtx8
   Nb8RgoiTkkIdbrdCD7IKEU+7h8a1Oi7SZWG+zeQmE0YuPmnz3NqEB5zrA
   fVR8V/s7pCXorDfk5dQY1kiZ0rkUYUHuZK6tNr6H23CunPf2vFPWXLf35
   aRSnXnyAv3n029N5KySkX5xQG/9MslC3AhzURPHH6LnniS9WjwjdiAu0A
   tpo9OYtCYKs6ZaHOZRESxzqlU26dpm952egiv7LJ7Ho04QhKJd3ashFIc
   g==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="187633913"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRKvEGyPEe28GLA+cXEPhvlLXg8IAVUxBJi3GpSk3f2qScMHndRX6EGMsAxIBx3tUg3WftNyrfkvrvQefHTDpLZOw32N2zCZglXO40lvypCjtt7T/4gHRvHkRhjyxOe1gJe29CrMiI7R1nIkvf1S2TgmHX78ZvvGDc5CP4WoYMovHGvWM8HeP7Sc+hP7mmounN9/15cFXn6y0xPPOsf29wPz9RaFVBcTb0y/RES095IS1eYtXeWRULI1tOJ7esZkhrmK9nTIhWkhfcofKOIAnRjp9XBCSaFJPVgan9ENwbKrCoEgfz5ByqCRliDv2jRlib1YTpxqBKp2hNhPAWhY/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xI946lWsucj9S40xSVIV/+QW3OouxeGSJv27FaLlWSY=;
 b=NwCFaM04eKN6y96R+SWVQ8QYzKEnMWDlJzcHdtqIbIAjzehvdY2FB3KmwFAnP9sutF0vmNkirKBrtmK21DJrdgVr63jrLTd24j6eECWu1c3+DN1gdtztBlbBfjsyxLooI3qKRv39RXKrBCz9PgJFJDz9GXHycFD3bip3EunYxJICJhbEknueZshziz+klPN8+5FBYQIAARXHSl2CuExidMNHebggDsz0ACd+vBfCqSyRtYL42pycfnJhPMolcfCzz5zVsVZnXtfXtHp2Vg44vXTUQi0d3fV8/6k3JrMgxOycgta1HIMJyxAB+jTt/Tl8jcaTWWKfg0wWWkELGlKJxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xI946lWsucj9S40xSVIV/+QW3OouxeGSJv27FaLlWSY=;
 b=TY2oWU6KGNgUoy3j70HUA2W3mcwoOwqNfmlHehRFeQ4+YO1N6HVCr/KY0UZm+yJZIJDjjtFUJ695/u1imuk+32w9P7IllGCbmqoc1KrGW0IDDL2d4a327AyvmdKC8TWLYLSX6jYkgFE6MeGamDlnh6shiuWWpm2GVacWCw+KQpg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7478.namprd04.prod.outlook.com (2603:10b6:510:4e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 25 Nov
 2021 13:20:32 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 13:20:32 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 6/6] stat: make add lat percentile functions inline
Thread-Topic: [PATCH v3 6/6] stat: make add lat percentile functions inline
Thread-Index: AQHX4f85fE2p9dLWuEize0k1MsYd8w==
Date:   Thu, 25 Nov 2021 13:20:32 +0000
Message-ID: <20211125132020.109955-7-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 85437f4a-eaef-48d3-8016-08d9b0165c02
x-ms-traffictypediagnostic: PH0PR04MB7478:
x-microsoft-antispam-prvs: <PH0PR04MB7478B8B9A4297351ADFB8036F2629@PH0PR04MB7478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:48;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FsINvEnWqei4jROHwYEbRxmHgfyFxoIkYAWJj+6y02zAMllE2Hb3YxB49P0/J8AWLpwU8W0Yq93FmYFZLOHOpTPqjTpATMReplE145ZYvCIA3KbmdQ6SxttFg2TPbL32L8fB4QR4AiLVHLolHM6zS14aXn8SVWj/htwe0uTOMZcSfAoE9ALlI6jSzeteCdTenoh7WstPXz66jEMcOq4C6F06Hy+q07GipAi3i5WcNH+XqLUmrvdb6RRwkm4pO0VJXM7sjFQTuHcR78Z6vl2Maeh5PnkVi7MjcsMFo2dpGAM3YkEjz4TMfdu9qxw+l5VupPEHdxlaabMZ2JHSf6DSfiFTfBu38KtH5H2e3ETCdktbiiArt0Uz60I/7Xspf2Lh2myEI/x3z3DFavy89LV8OC4fMbyHjZKYgNXCGSufAxbID587YIp3L4TAWJrk019eDBDEtRYVAzPi99QE7WbTejSRQzKH86jOO5nbYxj3cwAkoJ63j//fl+S1O4Lcz8pnmSGuHgEUR3H7QFqEhO5ra5SF3AsxJauxSY38rYVWrOWZPz+Ppk3CmGP5I+5Ua52wY9YDBGPhPPDFWr1kCYRN4FEVjMxwRKis2QDbhEJ8/Z6XZ1QAHNTXxf/fLwC57+8pEorx6saK0tWpwC8ltmz2dp3UmaHCyI72+8oOA93n2zf3scLSNHIJNxlNH+bAwWiUNDqBZju2cgDnEoLQmR+Kvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(1076003)(6512007)(6506007)(186003)(6486002)(86362001)(4326008)(5660300002)(38070700005)(2906002)(508600001)(6916009)(316002)(66446008)(66556008)(64756008)(122000001)(83380400001)(82960400001)(26005)(54906003)(8936002)(91956017)(38100700002)(66946007)(36756003)(71200400001)(66476007)(2616005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iXwI8HbxQb/F6WzQs1+5x5QonCznKO4vOsqErk8VAzo8IPipwADYdqPytW?=
 =?iso-8859-1?Q?ci1tmvOvRy2LJVR6Qgb2gr7Q2ytr/QgqJw7OA0WNdUgLuklI9JFgG3KTG3?=
 =?iso-8859-1?Q?SWuXSq5atpAj+eQ9ln35ZlQsfWTb5ydqIyqjyPukYDKk4kZUYAGP7NIZiV?=
 =?iso-8859-1?Q?84m5OQlchIGLnXn20osN/RSWxv00s3irL4lDSrBgNaNybt8qyPDubBR3dl?=
 =?iso-8859-1?Q?ERCeCLjeHKSiYVWxo8XyagwBGeafI4srbcw4Uvp37T3nmf40Ow0X1ic9vU?=
 =?iso-8859-1?Q?sTAi4xJZisfHt9MufZBhq9aTRz3SlqbFoowCd9ZDdrgJFYu4B3sfpa8k5c?=
 =?iso-8859-1?Q?ujJTvAO/1i7c0aZI+2PYvafIx98tTmNRF4Emq7z6qylb/aqhGsolFOt4kt?=
 =?iso-8859-1?Q?r0EsfGxWMooYgMzSDeJXWGHc0Dm/f78Uat6FA8Yl8DeGHEXQVH3R9DrKY1?=
 =?iso-8859-1?Q?0hn2cuWi2u6dK3wKCN3CjPybF+I1ZlN6DEqLk4Yye6brbNDxO7GUoSoMri?=
 =?iso-8859-1?Q?MkheO4sBaDVdMLHfRQoLTYrQ7uweJLtlcMEYNPCsoUB4ajSRL152tFJ9eU?=
 =?iso-8859-1?Q?QtNK7GknbMhprXy7RwfObqde7LXP1E6vtEHGaBIMfNeChxgQFxha2d8SIY?=
 =?iso-8859-1?Q?Jjy9qUy9kh7NVmm6xTEvDqPdANgLa4gwdYByLKGmYvq4NVoi2YCAeHpC6G?=
 =?iso-8859-1?Q?YuiKfePja5QUp2mdOUDjT5AcoSDi0TR7ISi7o5DZfz0Df8d7wVeZCJtKYV?=
 =?iso-8859-1?Q?0N5JveWFVavE1wdCL5gb30iYAiS+OfsepHglw+wKnOPZ5s5BdzyhbJTyvq?=
 =?iso-8859-1?Q?vBDr4GrZtA1u9TPZIwCSAolRagrYTCq/u3OkkIKbgR+ai4CY9UenRCf5h7?=
 =?iso-8859-1?Q?hvigpOR83sR+Vp+ZhZ29XmZUZDUTqiVA3KjosPzjylCXsgzbymjeM7s9q/?=
 =?iso-8859-1?Q?Vl5FobkZ8FNjmgksfonvNNfSeqkA1FI+7UQhI0Qf4MhHDCRSHEQskNWuNu?=
 =?iso-8859-1?Q?8xDoJJfyj94kEwZoCEGuY6yPuuieUkHxMHhb7E0iXCFuoD8zLEy5UmBRfn?=
 =?iso-8859-1?Q?2XAT/K0UT7QFZjy8BSFxkXN5Qyq6WM5wPVXwO+9MZzWe7orp2TQuyoFtnr?=
 =?iso-8859-1?Q?EB15I8cTVd8B9I6MK+4+apNV/LwqV5LzT/7/+yuiIXSsnQQXiNMMhtr72O?=
 =?iso-8859-1?Q?C/GhOi8iuHCW7HrjXM4tni9mXBGuwsG+jfVTxUU4qLJ8cTYNqy4h5Df+SB?=
 =?iso-8859-1?Q?OUZ6M6l9Ms+IPwSZ8Y48812492Ga9vUUNG9Kqh+ywsBuWfwM+udu8+Lc0P?=
 =?iso-8859-1?Q?6+dTYrydtzAYXHp3Ghg7OVPSLctKoGzrrXMXoQbtHW+BrUhbhapVUmsKsa?=
 =?iso-8859-1?Q?7aDGN8JVden6LgbU9i1jg2vYtrE4LhYvBMlif0hd3pjxyDXxSAyRj18zDU?=
 =?iso-8859-1?Q?EEfqY7xUFvKHnyN1hKpZeCvnLERhj2+MHGn+0Mh/1rUahLe4EUcXPm9Uwg?=
 =?iso-8859-1?Q?JGyAWkjQroq/5TEWK1XPGVEa6vV1U8D1ivBXoecojPxmBqtUGlR6js20RQ?=
 =?iso-8859-1?Q?cniD6jPKjSQSnOA0//2wwjXrxSvb+ahlh2iC7kG3v29bZIv6VcJdoWGUlc?=
 =?iso-8859-1?Q?sPI1aFypmOfzVqmgThoEscpUpVcc5jLV3A06DrNjwghVs4xTRv3Cl6xR7C?=
 =?iso-8859-1?Q?yiwqWtdsWvkX8lsTYRY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85437f4a-eaef-48d3-8016-08d9b0165c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:32.8037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4uq6N2Y5C14nczQMYzYoAXRGNCjtmE21kOU1aaNyRFTJdcs2dc/yMfQXYcDq+tQXkd7VLng3jySyRLmedSQLPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Now that add_lat_percentile_prio_sample() has been simplified,
make both add lat percentile functions inline, just like add_stat_sample().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/stat.c b/stat.c
index f78899c8..7e84058d 100644
--- a/stat.c
+++ b/stat.c
@@ -3052,9 +3052,10 @@ void add_sync_clat_sample(struct thread_stat *ts, un=
signed long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
=20
-static void add_lat_percentile_sample(struct thread_stat *ts,
-				      unsigned long long nsec,
-				      enum fio_ddir ddir, enum fio_lat lat)
+static inline void add_lat_percentile_sample(struct thread_stat *ts,
+					     unsigned long long nsec,
+					     enum fio_ddir ddir,
+					     enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
@@ -3062,10 +3063,10 @@ static void add_lat_percentile_sample(struct thread=
_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
=20
-static void add_lat_percentile_prio_sample(struct thread_stat *ts,
-					   unsigned long long nsec,
-					   enum fio_ddir ddir,
-					   bool high_prio)
+static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
+						  unsigned long long nsec,
+						  enum fio_ddir ddir,
+						  bool high_prio)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
--=20
2.33.1
