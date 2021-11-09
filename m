Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92083C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6434461059
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbhKIAbB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:31:01 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241224AbhKIAbA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417695; x=1667953695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B3JbSAg+ZStyyCvJ7YlmvleMg3J8VtZpkXnooJgT6Po=;
  b=gyuf33qZmjJv1gkfxGFnMC9GkrTWcaEL1MJHPdRQIhmZR5uNY6bAqQwV
   bujIub0beOJcg+X2YgwMxUCqdEHt46Evt3ZHnwYKkyvN3jjE8A1S+lZGF
   sLqqWj6aN9o0KRafH3eTHyy4HX3Yf9HQCNg55kDrOpAn4EC5eGBARxtoD
   ti+dzv1S3TEjm4L3DhoXsK2/eecL9uF8//Yeop1r88SEhKrI+JJtOFgJ1
   7MNEf+S+OtFVYLk8fI5aIrMIpDyQyW0lsvYn7DrNs8qO8FFpxFGTn0P5D
   SrYrF2kZTw34aQ0tkfSdw31wreQjVA9wiOdjhyiU/l4Zn3edoJDjM6nY8
   w==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068529"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNJXc0k0t3CI2WebycI2mias7vu/R3xQvAOov1l0kY0LTcOF9wDQTdfV28WaH/u/T2IuhKt+S80AoVmRit62bU+wdW6BFcIpm0eeYQwZlw3C9jLAahH/HbnJzUuric2lyDQdjyt45gAEJWa22kG4HZdoj95hgaUX+5kFQ4ehjyLD26S7Q86XH0EzRGFZ05Y8NTzruRmVOvQBlcDydX94+GSXRb9o8UbN5rNPFDP77c2QTLU1vt4G9n7Q/4ki+e+TvljN4dqm4cr5O1xikyX2NIzX03K+Sr/G4paYsCltsdXRTSaXCKEp4fqPSZJ9sPrWxmqlK3m0zFZez61+LuIQLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiaPs37LU56WPprnSJ9OHP/4l+QXT+/0OXhM1Zf1cXQ=;
 b=TvSkMtQzJZYZob44iy+uh3pvhPiG/U+UjJ2SVziCpxqYCSaw/y517EdcaoYLpLo3Il/gYVMJE6Q4/sfR1KZnH33Wkb2khxV4+o2pxisLTumsEmq0DyayT405G/h9tPdbFtKdejA0GDo7nvT16LedpZUz/VnXqb7XiGiHj7cxgYJQ4ZNcXV14wCJFVvz/PgMFYCqIr5oo6Vf22t3gDHBNaJTWkqSyJjHSTgvT8ltXx9hqFfflMLXceNZPP+5PDCaxCYzRiGAx995jb/2jyjHbxOQOVAzkvDVWq9R/lgalSmdQlH+wNCEcLH43HEPuzIM8jD6/bJPIvwzOtpJkkixfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiaPs37LU56WPprnSJ9OHP/4l+QXT+/0OXhM1Zf1cXQ=;
 b=Z+u6SenjxoP12ZgbbRW+zWlcIdW+X+HFiXE1crCAkCUkRMuqXY3hRtEEhauWmV9qGN11ND5JhYjrE5s+dVF4seP2VRgdxi4h6FkPCsgETaf03zRso4b6CYId8bJCE1uKAtfFhAb9sB/ZKbNlZ0AGiZOh3zjKb68isoit8sQswF4=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:15 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:14 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 5/8] libaio,io_uring: rename prio_prep() to include cmdprio in
 the name
Thread-Topic: [PATCH 5/8] libaio,io_uring: rename prio_prep() to include
 cmdprio in the name
Thread-Index: AQHX1QCvLGmSC89chEyJvIh5tBOyMA==
Date:   Tue, 9 Nov 2021 00:28:14 +0000
Message-ID: <20211109002655.117274-6-Niklas.Cassel@wdc.com>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8b562a1-6be5-43c6-363a-08d9a317d1d8
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB7144284C76A5A04B9A762373F2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I/bzeWt+Y2YVo3AcvMiauf8sRIU5RAv1Jwl0GMTo24MpzcHpMenOyxMxyS9cxWcVSS0ZRipp5zysE0kxVk9WrfzLBu5ItnCA+cEON+2eQDkEZ1FbqlVQJPM+bRWFAFQpYnlSRQ5S95331caAUJZICBvjIsY/jNbW3PczXdx0Ea8adpsYcJNLFzJivj+r8wDKYNjGsIVEqoxfy/DkK5t/7FDw33/xvn+SbWT5z5brDwyCTD2+9VY9/KChfbTBQYYTxBPegzjSDwEZUA2FJKDAkVImtRlgVQR6E5MTMgl0Vpg+xy7fSzfaZBQz7yIiWZlGsQbfh9idfg33fLg0vKjRRb2ibdiBR8qRH9erVg/r6IsPUselwHuWKKIe/xYNyeCSHAKYKPa7oU+FzZSLijfNk0eZzur7BA0NEbr6WT1qoIbn13YoJC+9mJ5o304DBg9BGs/ASIyI3RbTB6/EmeRcPytcRVNK9xXFwl/VUmod9DrommVu7TmQf1Ni39EeUlHH4dssNyTJueKU+n77DZtgF1eWtF8y7qL9B/uI65ozCsMdRFNTeZ8JEHuqSu+fC4O6AOcxJ/1zO25So7ditrktJi6pXvUOKC4tNcm7dLEZvOx7j6ErgXTc1xj8j7QQFxOdQGncD/Igze16cVhiyxKRaHBk9Ma9YSIzgY13YrUTw2mmTd+PE44Twbbq056NSBVAcTKzZl7mxIF948WlD3PM5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/NM/gF031A/s8LuDsFSY3IhjgIZTFE4hWLkXwTEDBgc9mKYbjmco58gupv?=
 =?iso-8859-1?Q?QV5FrxPWzDLzAcHA3iIxL6ouKCT+/25b/txvIszrsm9Edwu45ef7HTKe1j?=
 =?iso-8859-1?Q?QTEQ+olVe/YjslMkysXOI7OqOeMe3Uiv+AR1BmMMzhfXfCC2vgt7Bl4dtu?=
 =?iso-8859-1?Q?QHvpFykCYArjcB9qtgizNZ1nur9cBTHT06tDbT4ftYa8xjABom2Oxt3y2S?=
 =?iso-8859-1?Q?meeXgqiDRaL+s+YsFXPp7Uw6tnbPZ7WuapYdkFwEk804DTeSNT4KSm77cw?=
 =?iso-8859-1?Q?Vk/mxowYYlRdPmVcajOwVtZUlYvpI3pJm+6OEzFAFlxunYLfp+8NHHGhG+?=
 =?iso-8859-1?Q?dGKj0QKRc1DvMW3kDg5KMTjmboz01jiFd8phNTFR2Ddv151M2y3xAed5RA?=
 =?iso-8859-1?Q?IkamJbLhWot+uLmOhpvt6Hi8+o+evOhPNj1cbMeHLWnKhy0UnHd9fzulD1?=
 =?iso-8859-1?Q?J3TGL+lrds61l+5rPoP3mscsXfObOxc2rAlzRZTRwao3glVOiABAynL9lL?=
 =?iso-8859-1?Q?hA8b9c7A7/k/fbup4wHNtkws0on45F9hK++4TH2jtqt8wIPjvuPOeQhU5J?=
 =?iso-8859-1?Q?J3nf7ZPRsSk/rDJ73YCLMc6lmxqhfRQuQd1P7cxarmqG180BFC9EUGAGla?=
 =?iso-8859-1?Q?UoL8aZn4LuFyTUHqGWg9bXe7ECzASSdlbqrwcD2qM5Xc7BpExfg7UDIzM/?=
 =?iso-8859-1?Q?u582ZDyGf90FH7nfS9FiWbGsEdVDCJSs5fNgtiMAUP8btqARKydMtZA4OR?=
 =?iso-8859-1?Q?zlbfm9s0uhQyocBrSs7kFMKdqkkdynwuA/zwjI/L1y0uzq7Dt/MVqilI+o?=
 =?iso-8859-1?Q?mTU3IQv89+7grfwKvTTV/D6CfGOSXGU+jWMA61rbppm3RseL3SYh21/p5V?=
 =?iso-8859-1?Q?h+vbxBhMRmqkKAoPINpqumtUJW7l/5nR82HC7qkx9pzDNPmuCCYnizfXzJ?=
 =?iso-8859-1?Q?zyoziAT89sDSZIxr5hpcKQ6wi4xtgDWzaGfY3+/cHBEnlajBgzWib4NQCC?=
 =?iso-8859-1?Q?QIdr6aopN+5xYRHWeAiAMMMiW7b0u7ieLHvFgsXbOEM2d/V0TjqJaR+Euo?=
 =?iso-8859-1?Q?cPwVwc1634XQRNSzGLOQmt1WmXBd471D4m9bjF6h29hQedHzqTFc77wgMW?=
 =?iso-8859-1?Q?aHVUmV8j77EJVGzC+JWN9aqPaR0zm6TzFf9VT1B7oP3QAPoEGNa/5mGLa4?=
 =?iso-8859-1?Q?3N4O3OhrGwY2Ko0MTNZnoYbORib3GAXwxUUO1KTQoOyFTq0sP+dSZK9ZC0?=
 =?iso-8859-1?Q?v5smoy5eDFldskJVUsmt9z/12Lg4Qb29F22JOr+c9r/M4tY5rq1Kpn/5eu?=
 =?iso-8859-1?Q?jLyD9DE3HFeWu692IMCe0iH5Ze4h+cgd2k6Ti4rr8yreQlkyd+iEdHcF8R?=
 =?iso-8859-1?Q?z30o3xV2Lao95J8elixNFPJf+Qp8pW/tIlL3nj+MF9hXQ6wKtf2WDFrtuK?=
 =?iso-8859-1?Q?HOxBbS/QW1vW2Z73r8fVdvj+sY/XUCGQWAG6r22V0yQhmyqGDolNNRganb?=
 =?iso-8859-1?Q?Gj3izR4o0t2OSuaAfQj2rfPC2C61ahsZWoNCt4n/SDHXVh1SnzFLTrzfIS?=
 =?iso-8859-1?Q?+yib/XEqaluYhaLM6uqW1q9J9HgCV11LdgqRlBdXmcK2rnFVJ8NW5HQysD?=
 =?iso-8859-1?Q?4s9s8OsNScbacBfYt9vSsa5SAbZY75EIhCTCPkrg5C5L5PzukmWmD2hneN?=
 =?iso-8859-1?Q?WSBnWFnRqo/98bzm5/w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b562a1-6be5-43c6-363a-08d9a317d1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:14.7847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hwTU9e2d2NkLXswlAI1BaWL4J5DmMJLUK8F2WQydzo5T9LYMStcNO91xXxlK+3uLbY6ozfSBz3dCn4CJTImAEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The default priority (which is either 0 or the value set by "prio" and
"prioclass" options, will now be used regardless if prio_prep() is
called or not. This is true for both libaio and io_uring.

The way to think about it is that prio_prep() is only called if
cmdprio_percentage/cmdprio_bssplit is used.

prio_prep() might then override the default priority, if the random
value happens to say that this I/O should use the cmdprio_value,
rather than the default priority.

Rename the prio_prep() functions to highlight that these functions
are now only called if cmdprio is used. (If only option
"prio"/"prioclass" is used, that is handled elsewhere.)

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c | 9 +++++----
 engines/libaio.c   | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 8f3d6c39..de1e6cc9 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -346,8 +346,8 @@ static int fio_ioring_prep(struct thread_data *td, stru=
ct io_u *io_u)
 		 * (option prio/prioclass) to be inherited.
 		 * td->ioprio will have the value of the "default prio", so set
 		 * this unconditionally. This value might get overriden by
-		 * fio_ioring_prio_prep() if cmdprio_percentage/cmdprio_bssplit
-		 * is enabled.
+		 * fio_ioring_cmdprio_prep() if
+		 * cmdprio_percentage/cmdprio_bssplit is enabled.
 		 */
 		sqe->ioprio =3D td->ioprio;
 		sqe->off =3D io_u->offset;
@@ -456,7 +456,7 @@ static int fio_ioring_getevents(struct thread_data *td,=
 unsigned int min,
 	return r < 0 ? r : events;
 }
=20
-static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u=
)
+static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
 {
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld =3D td->io_ops_data;
@@ -517,7 +517,8 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 		return FIO_Q_BUSY;
=20
 	if (ld->use_cmdprio)
-		fio_ioring_prio_prep(td, io_u);
+		fio_ioring_cmdprio_prep(td, io_u);
+
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
 	atomic_store_release(ring->tail, next_tail);
=20
diff --git a/engines/libaio.c b/engines/libaio.c
index dd655355..9c14dd88 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -205,7 +205,7 @@ static int fio_libaio_prep(struct thread_data *td, stru=
ct io_u *io_u)
 	return 0;
 }
=20
-static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u=
)
+static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
 {
 	struct libaio_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
@@ -369,7 +369,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 	}
=20
 	if (ld->use_cmdprio)
-		fio_libaio_prio_prep(td, io_u);
+		fio_libaio_cmdprio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
 	ld->io_us[ld->head] =3D io_u;
--=20
2.33.1
