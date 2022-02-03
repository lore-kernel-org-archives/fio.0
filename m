Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03D5C4332F
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353755AbiBCT2j (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:39 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18768 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353756AbiBCT2h (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916517; x=1675452517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AzzGwsdWkNtDwEMThSyGB7QQZ2Owi8wCs0NVaT2lJPI=;
  b=mSIkLJSSHeBajSx+iv9Cg9gKt8GoOW7Wm0R24tEIMHvz9tjRN1PmPyGW
   X5Zjw3kwvcZcoi4GdRDMKaMrUImRLFIvNQnnp9blRdpnJ+C+JqdI3rIHO
   9YltQp4njkEyS2ZRFngLLXrsyrt8TFnk1tzmS7wRL3Vugj6CVpLrsYinZ
   RTF2MqnlQIGPjRmBWj3tU6yhU/qzkyO+WjNUBjkhoY3lisZnr6pGEq8JM
   cxi2vdOhAVihZpfGnhemcORCOcIscE0p40g7q2WQRBCvk9N6AsXoUDsKQ
   hX0hmpX967opPqx6cnD6JXeTwsJ793KiaDpz8AOFCrcYCyJEwG9Js9bMO
   A==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="196918793"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNSXhJ7QeXH5gCpxOnuEor/M2pEa9p+QWT2D6lbLjEGJX8zK/0ZkSsFVlgMZFWiX0pCF33EGi4W5h6WXdG/d3M8a6YfYFayVjt1mF58GyyMGGAEmQ80ZP1E8S5TTYsR2EyLeh6DFbt31zze71wbWur75tdU6EAVD7ZM/bimbfxZNjH9+Frv9JsyqYmGU/ain7qRSKxcvduolXM9pHZAzX4FfGPYxTOf6IhDVg+x4npivIYRAlfKB2jXl2MpjowBlSmkaS86QdDxLVYOOd8u5C9+sLQ2ngKuPvdtE4TFBZ6rOjk/ZsIz4MeyKf32JeN8pv6cAkPDL+PwqGREem1hnjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmDDjR/6/IyVCZZfMmjYjoQQKHliuqeXInBbAvZPYvQ=;
 b=ncSTqfv6mcRj9L9NVPc7E3Fvh1eOEPjFwAbMBxNPlU5gx9/mgGr3KheyLdVL+VF+JfZIiNFPopPN47/Pid/z6/i5CNTSNg42xRSJomFMiMjnyktl6282Wruwlr5cTicUASoiB/sBoJagVpScKgBlVyawvK5Oryh+0+8g3JxYF//1YenhxWFjTqE/uoYrFttRfjoMEQleHKIenD+vIaF5Qplmu6gkzHfDu+dNqK4/znJagvzE0QXf2M9YnlVlu4QIKDHYWtWpJ9YVOt2k4dZ/bJWwT6lq3ksIK8AfKi3RAXQ3Tq8XtB79t7DPEfeg9V0qvtSD5IfhbSukHXMxgmeSPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmDDjR/6/IyVCZZfMmjYjoQQKHliuqeXInBbAvZPYvQ=;
 b=nX3sna3MTYZhw9URw07+tJrvUHh2A0qH1KnMpiEoxUfrOI1KWHy94alLu2423Bv19edwu7v0B4hSbOHuWkIJsCCdjM3O1NE3FIpEorVjUyOK1PECMEs5fS4eiTRgZtCy2EqUNET5KnSsPmXHIBpClPPSYxqRXppYFio6xkZ/B0g=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:31 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 11/18] stat: increment members counter after call to
 sum_thread_stats()
Thread-Topic: [PATCH v2 11/18] stat: increment members counter after call to
 sum_thread_stats()
Thread-Index: AQHYGTQ5KLLO8VuZu0uTQZLBts6DcA==
Date:   Thu, 3 Feb 2022 19:28:29 +0000
Message-ID: <20220203192814.18552-12-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 943880b7-619e-404e-2442-08d9e74b5cdd
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB46325B6593A73D855C9F0706F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KKM+vsLLk2+qLlGtvNaxwI0lL4SxQZj8SevL51TVFw86wkxqwYvIUQ35Zt5c+0GGRSXKsukCXip2eqYt3vI30dZvkUJmXfNQGO29ag62lNCA56NoJJM8RFCyTenoX0/t1zkSTFCQ62ewtDkWuJDR+W6sI8OKa2nD5ZiP77H7EZZgWKCrisVGNBldM07XZ2izDVtwXv+KBKYQSWZh8sMXLGFrx6jks4WvmgozFchV19vvAx04BBVjiR+MLkvS27JsOjRGtilaAadWBwRYjwMJhYrs5oRlF7du1h8HwZwd6nd+cvxCxpkfFGTf40cLZstDutnMW9+SzVvavjNt8AOVzBTtRCBW86tUFtRsex+56iQiKIMdV5LeiqG4NM8U/+8eCJftimPWVDmzE7LnZxxJpFFrCBjem/4x4LAdSDoV7r3gsgiuTt1I+CzhJ/cF+4Df+Bsue2tpsDVXwBxpqLhOOJmj08DI1SrSTORofJ1R1dZtjXkiOCA+WQagvZSBcvuGSxostCBXDUkA7WeivVpJHqMhwMNkzLKTw0lCdC07oOAgSUczkouk5pqypOIsHjsIHLvZCUiyVHSWvFrX/+ecahdJUUEctG8+y0KVBjdo2hFJB3TcC4nJiiJQoU98lH+pA7haU5gczIuSvEC9nusyecIxuDFXvFq8aIzT7sPTxulnLNkJ+QO6LTb3n1L67HPYlkCUL0vxlJHEn9sk0tbYMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jSm6MmFSYIDEg2BJkmzIVu0XT8QoLEHCYych0ranpjDvo89nMBitnxREJK?=
 =?iso-8859-1?Q?Bqn4tK1XhJeRP4//lnj9SPCpexoleklyEhalTT+BM5utFDx4jtdvKds4Z1?=
 =?iso-8859-1?Q?stMZMAcjPVD/jv4bstVLEODAK+WNQa67I1oPsHIlKiTEANj3+M9Tjl+7+G?=
 =?iso-8859-1?Q?XPJVFDGfxXUuSIwhpzv/mB5rNUlFU8ysd+N2TcKZaOBEEZicWC8LKWnmgt?=
 =?iso-8859-1?Q?9EjD1pL2nIL4kqTMFxVDCViwI+7B+3u1so2/6CYMF+movlIAYuIJ2kbH9v?=
 =?iso-8859-1?Q?C6BMSniVtFSeBCXb0CP/lvcaMbNg2d1eSt8RbQMZUagtf1/fdQs4cjHi/G?=
 =?iso-8859-1?Q?izDv+5JRtWK4FJoeIYcHzNMSgRjgB74VIZeo7iPzl+MW6AQMvjfrAmmJWG?=
 =?iso-8859-1?Q?45TCzdc2V34j+f7bMu/gtxHJZsCQnUKNLdVPp4IXScVmMCCz0cQCefc6LV?=
 =?iso-8859-1?Q?FPx5jhtLUBMf0Zct9mvJiGLGdG5lTASJR9O4ObqZ0T0noXQnfQpF66Rv1w?=
 =?iso-8859-1?Q?xmd+g3/ailagVTRzoPdcwPludJb1WhxfWDo+QFvDq7IkddBAzD3hX7fARM?=
 =?iso-8859-1?Q?GE6/EgPQEywGTnMkkPlTdw5f/PB/FBWF133tBn+qhoRS3ESOc6U9myY23M?=
 =?iso-8859-1?Q?NgVpkHjVsQFoWHrpFmD6irivFFJLdOJ+kThCNSXUrxaKg8KyQF5XvlgzY3?=
 =?iso-8859-1?Q?O14DAyWTDhONClvy9rm0d++/PfxcST2iziYBGL331dAvotpj4IYXqBVxLc?=
 =?iso-8859-1?Q?xoLS6E5PzYT3pB8lOiXYYNc1YSJKdXCu0U+w9h+/xhlHCjqnDVOKawCrzL?=
 =?iso-8859-1?Q?EpU2p0vwGUJR2fuz5eF+WzjGXp0KiJjnJjIQmIC7J/OTr6C3YZT12RyhUc?=
 =?iso-8859-1?Q?rTxj5lqi0IOdyQ1XWWeNaOCHlc2P1ossjma7+K/858oWJCw0R8mVEsVOiz?=
 =?iso-8859-1?Q?bQiU9OnePd/tz1pOFTFL0QyViT44N26I473iHhiUpbU36IG/TJRYVEhXY2?=
 =?iso-8859-1?Q?l+dRsVuDY8MxuijuBg6omKpMn3Bbjr8lRFGCGSA8HK6dWYY7Wpwjkgs+kG?=
 =?iso-8859-1?Q?iYAg9pgSjmswESHVwBQjY4tknCN3RhLzb+/i+7rZGIUiWOf/552l2G+ZhD?=
 =?iso-8859-1?Q?euPVkh8yxHnFZ1oxyIDJ7EP0ty6EzxRa+wyJ7r9LiTOZau4nhXrZVxY1zx?=
 =?iso-8859-1?Q?cYgKkDhC0lgKGBjr2odW/SpvmctjCxv5ZpgJHbRHmcOim8x4LF0mQZf99x?=
 =?iso-8859-1?Q?s97kdZEcfrcFpv9OoKG05ED0dyfIOgIvR0jdJPhV3Di+2UzFHsU/xcfwmC?=
 =?iso-8859-1?Q?n4ddxXwDroMyXAtLSxvdizFXaErwZkacbJkb6HOwnZPX73Hhx27x1EvT2c?=
 =?iso-8859-1?Q?lh8VBrSzztWePfykP3SRrFT7L20EOcw7wsvIOL+CFSGFfov1E3JYKuStjN?=
 =?iso-8859-1?Q?M5SsqQLKb954K+cY1hoe3Gm3g39ari+UEt33C64EN3I5AMJ5hBv3Be7Dqi?=
 =?iso-8859-1?Q?DiB4m9POTbMs7HUNJhhEYDCyDm9CfZHGCCZMJ+HRatltu2DbmSLuwqPGm9?=
 =?iso-8859-1?Q?xO9qf6sUVOnB8WUVOOhR5fCer4289bytIU39FWLOb8JYUe2cebvt9RYzRg?=
 =?iso-8859-1?Q?IgGRyd/mb/1FlKaXJ7tdKcC6AdKiOCcBo5mulq1HHa0hkXDxPPcufy+9vl?=
 =?iso-8859-1?Q?dkFsAAUeKhq8pyTR+h8R+VSWPkWNL1gMRcQLzGEB?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943880b7-619e-404e-2442-08d9e74b5cdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:29.4154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NshuWgDruaVyKG+1zGevwC1UPpTyfq846DvaPEXEppQm3eD545TrKUtjp+BDHc0Xvcvpn2cwOqm6ae23ljNhNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Increment ts->members after the call to sum_thread_stats(), just like how
it's done in client.c and gclient.c.

There is no reason why stat.c should increment ts->members before calling
sum_thread_stats(). Change stat.c so that it is consistent with client.c
and gclient.c. This way, sum_thread_stats() could actually make use of
ts->members (if it wanted to), since it is now being updated consistently.

No logical change, as currently, ts->members is only used in
show_thread_status_normal(), which is always called after the call to
sum_thread_stats().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/stat.c b/stat.c
index d7f7362b..63341512 100644
--- a/stat.c
+++ b/stat.c
@@ -2241,7 +2241,6 @@ void __show_run_stats(void)
 		opt_lists[j] =3D &td->opt_list;
=20
 		idx++;
-		ts->members++;
=20
 		if (ts->groupid =3D=3D -1) {
 			/*
@@ -2308,6 +2307,8 @@ void __show_run_stats(void)
=20
 		sum_thread_stats(ts, &td->ts);
=20
+		ts->members++;
+
 		if (td->o.ss_dur) {
 			ts->ss_state =3D td->ss.state;
 			ts->ss_dur =3D td->ss.dur;
--=20
2.34.1
