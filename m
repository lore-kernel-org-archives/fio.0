Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F211C433FE
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349527AbhKYN1o (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:27:44 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63992 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352346AbhKYNZn (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846552; x=1669382552;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N3K/KloeksvHYD46PIwQAeRiX9h4ffVYjHJeTqP7XcQ=;
  b=FzWSWsxCseurLJqkgKXEOESKrJ+EC6lZnOy3LHF5uoInLY2Abs0eQCk+
   z3x0ln57aXzDijxOcbxIvrB29b2aGCNaAicKBgNgp36swOdeeUpn7GtWp
   pEHhqu31XsWIx+mnukAhIBVc366wapQsQR4eD5RN6aOn1C/ELeGhR75Fj
   DCx7jkF5fOkkhUkU/XC/FYiHZrrMHYzBBkmAF2mGDTOuzZ5qEjLF2Rqq1
   kM/xXBu7/U373MDmG0ln9S7gnORkTuUiPBlfq4IVl0kgL46+ztCwYPIdr
   zJX0QFPZoSNKRSMDYG1NsWiRp21fWasroPr9ttZKao/eOZ0Cduvpg7dCz
   g==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="298461774"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWA7hroScLB7udeO17favQz0w+A9P568L9kI0ZuXDnEUJ5V0UBX7Uji9mdv+Cejr/IcTaw/BNFtIwfW37fsLpMXkprGLB+zT7T4y4mcOtFVGOcTP1ZDFuSnvEL0n/Yt+Mwxx1tHK+dA3mFw9mAJLNJ/DdBxAwKYykAc09Haxal9U1uALPfPhr64OgsXJkJBobpwPCnS0tlqzF8ic55u4bZ7jnOUYuYMMtPbtehFMZrO1CY1sT4RQ3LfzjCyb0oFXI1u1E0FShmWVj7JkYE21V+ULiIAbVdDruFzDdKV17tIk0n6mVSECDl1YMeCyXCKwyU1ve5feaY2RHSPkJoXrEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=to2TrV30bQYEVw5Pp/aDkZfg0gY2UOxYz523/2SYr/8=;
 b=Dn3vOTYa6RYrpCLO7qnh3++zJ6zLDxRBfHUYoEmklf8ufjwwj6on6VJA79exJgZueluzre1PoDZaNqJfiUgC2NG72wg4GfFDwu0RBqJGVQ/I/IV75ecbs5JUIZV2kv/ng01ojHdxGf4YLt96xoxtkRFrP1UVcr77RzAP+3lkt5Qw/6YQXKRIL4xmLi9L4OnGVoEyUL/CkZXW29oZkbIjiX5wBEkL+g5aqmikoIe5h59FaqxxgFu34XIWxvu+WSK3lUqKG/j/sf6YCyDfpoa8/kn1duv6yFjl2r6zmdHVurIeACDElWiCcsoWLN6aP+znHHJcXXIGUm5TUJ+sUIcExQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=to2TrV30bQYEVw5Pp/aDkZfg0gY2UOxYz523/2SYr/8=;
 b=PXRohEiXGTrVFpF1nsV32zx6Pc8gEyiQTynx68N9dGayXpnQmoGfemw7jzIoR6Cm2H2UaxfyQy923XnX+dxOaZ3oKyFUQV9rbXPx20P+tYUuZG4SbZreBk048yEsHJbhnfILzIoJPgSWYe8llHRDsssa568cg+0Rg/3uctINf3A=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7591.namprd04.prod.outlook.com (2603:10b6:510:4d::8) with
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
Subject: [PATCH v3 5/6] stat: simplify add_lat_percentile_prio_sample()
Thread-Topic: [PATCH v3 5/6] stat: simplify add_lat_percentile_prio_sample()
Thread-Index: AQHX4f851P/3+K4DB0ekHNvuTy7fbA==
Date:   Thu, 25 Nov 2021 13:20:32 +0000
Message-ID: <20211125132020.109955-6-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: adec3157-3f43-466d-e598-08d9b0165bbe
x-ms-traffictypediagnostic: PH0PR04MB7591:
x-microsoft-antispam-prvs: <PH0PR04MB75915B9E9301C141FDB54CEAF2629@PH0PR04MB7591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OEyXwaC3J0Ztzu0HQvsw+wu3HsqkUSURuD7c4pmMJaitjzEuvCn/9tGZ1hfkbWpfxXzq1KuezzT6zovd8TBJK8guaGwk81NE463nXwppYjTn+Q2o89iT0dz1nNtvexUrh4snK71FwfC3CLF44n8zlLL0F20LK4R1fBZBnVjbK1+Zifn8nhCiM3+nANh0ILLVa+DtGjnsd7yIgOB3hJId67PuTGI9mmromYk7XaRs3AFSTBKOlPdOWhuhtS2ZUBtz7aZ1Md0mNq4yPEYr4lF0bjvbf4JFGSP90/0Jsd5wjba1N9LMMqy7lkK6afaOwaT3oU7v83Ou7KbCgDflQ9gqaJzj5GcK2dwJNQ/IdEo/7hxseKrA50jfdRU58uaVkhZHRup9jQf2dO/5zzXts6t/zLrKUWU3M7VlO7SiweMBJctqPfvMC0yTgan9ZyCT8Q4Yy9OQ7Kgsw2h8DA8JM82yiOOvXlUpWVnSRT6X0uvwaiF5YAdXygrVFskBSl64V+o7iu/FGt4bUzarjWkDsJRQqe5A7h8dKtcMQsn2zX1mgSvqRw6UwqQc42nvSwL1iIQ1prl/RLUzie+wR2H1gjYakpoeQB1WpR79xWjrgP8JPzwyuVbA+TkgtSwwJ19KvTW/vJ/h3f0JRxFE9IvPcaqqoWa5LzXwQg+zY/LhlThVnxAV7Ypty3DgZ08SU1aaT36eUP7A84paduTGqGsFQJnJXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66476007)(66556008)(64756008)(6486002)(6512007)(2906002)(38100700002)(8676002)(122000001)(38070700005)(5660300002)(186003)(8936002)(76116006)(6506007)(71200400001)(508600001)(54906003)(91956017)(83380400001)(6916009)(4326008)(1076003)(26005)(36756003)(2616005)(66946007)(316002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Q6jz2oSNpS9PXx+gxaj61dS9pZ/4ydHyy5Chqm5y4LQCHfHa2belQEvlzb?=
 =?iso-8859-1?Q?0witM1VIHk8MZ8wHWrPzSjXJuUz3HjW19lMebufrcp5fPnZguBccRO0Igy?=
 =?iso-8859-1?Q?NvqxYWyy71TqiBXVW+P74gzJfQhXIU4C10qspTMQSq9X7W1j+IL62Li58g?=
 =?iso-8859-1?Q?mEE+nEMqJszcIsG0wfdADpWft0GBfmzoDKirQlhQ2E93LVKLNizSGex+PM?=
 =?iso-8859-1?Q?JRXWqUCyfDtXabvRrbemYIniPci9EoIshbDRWqq1SMwBOr9ySKD3TOm1Bt?=
 =?iso-8859-1?Q?VjY7DcpKoui2rJiHL02jCtzwhuLShf8Lhz0syO9fzuXqd55eTFDuFNrAXS?=
 =?iso-8859-1?Q?rpWM25X5hQeMt+HNpWGHCP7GdfNl1vwNnOva1DNmdwiUVStmZ49WGor6pa?=
 =?iso-8859-1?Q?2HjxYowFrOqqevD+YKvl5aunS8dH+lpx6Oc8HVJwZk+h/0QM7zt+v0CY8K?=
 =?iso-8859-1?Q?6nI3J8sOVLKyWEdKZZNnR8yxyVvTfc3TNDBM/qNUOJRlmV0xJHUrLQALk3?=
 =?iso-8859-1?Q?Krx/PQDZxM4TAcRk8tHXnoVo/5zHQeHj1CFQpaKYlw5LFKkf1VC7IxBOWz?=
 =?iso-8859-1?Q?NnjEjdb9vQXymYf3YrRHcTJl+AinD4e3/DLZ+MxqINcrW31hRxEilK5cuU?=
 =?iso-8859-1?Q?OZGCpDLsQZHSoPDGjMAuJ6EMG9py/hnVCBrDpeUAZv3PBQRjeeRSuI2Dtk?=
 =?iso-8859-1?Q?Qbw42+PLF2cvD0ubPWcuAyOc0MQAr6xsNgx4VGgN1j0147tfm+8cz6qIxK?=
 =?iso-8859-1?Q?VfLj+/hbBi7lYX9mkJBShTYjpPdIir57NWrf8Z4L6L9ex89KBWmeW1nlyi?=
 =?iso-8859-1?Q?o7Miv+VCJCMvFrQE0i9ymNxt+mJF1jAJHXL5CbKQ3vG/0WJClQXAcsQgk/?=
 =?iso-8859-1?Q?Q+ocYMWVWW87Y99WdjWeQ9xWyUUC0DPcqsc60qBPJn/M8Vf1oOT+70dH92?=
 =?iso-8859-1?Q?CuAi9ie4Cs7V22WWYI75dkTrN1g9Sh4XYYTbv0pYN102jER6OnfWdWW9iN?=
 =?iso-8859-1?Q?iOseLV7Ti9tOiY3W4H9HtO2wUaXD0iFnCmv0sRcnv8vyzrAKePeD5K5KP3?=
 =?iso-8859-1?Q?cFeQvuJFat/5sLEsxxk+rQD8mIeLVBHzgxpPqrj7OA7/kkQtE5ojSRRRps?=
 =?iso-8859-1?Q?PhoChqJxasXNkipyFMFEc+LQeL1qoo0WG3Jrw6vUkIkBn98VpXbXxpaSMs?=
 =?iso-8859-1?Q?cHsqaqdPBYHYeeEx0ZkW/siCnUR6ucQH03i81HqHtCW6MOyR1TqSKkCygw?=
 =?iso-8859-1?Q?e4/QTEW2Yf2DCkYPiMBjY8uzLU2xlVmiQeTxXmXKhzpa+vCm+P70Xw1Vf6?=
 =?iso-8859-1?Q?n4TthIvkDFZXwlHsRR/pn9KYqrMC/y9TqKkzI2rFcKNMfIlvGn0l0sz9OG?=
 =?iso-8859-1?Q?tUUFa2v8HievNBmDtUGtu+Q/xBwMSMTVAh2Ti/ECXl/E7tEYVvH+8tdV8p?=
 =?iso-8859-1?Q?hZxxs8id06zMa7BYK/w4xDK0wUI1z5jigWL9GEdvknpctqcsmR3SbSqXIt?=
 =?iso-8859-1?Q?clR89tXrAjVcjSg5zSHPmhobxzR0X2a13+9Bjqxo2+yVMjuy345cW3zGQ+?=
 =?iso-8859-1?Q?gFBcOy/2BZ1NqwXj1/E61g8nu54g2/UKwzy8FwLXJ65ytPCucdGrO/rV0U?=
 =?iso-8859-1?Q?GGyjMYjl8UcLJWu1hnCmFHx/ILJVZ55SqaoU3RZlTcADSfciEw7S8i5a3E?=
 =?iso-8859-1?Q?fTC37FwbBxnwaLJuCkc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adec3157-3f43-466d-e598-08d9b0165bbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:32.3248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QkypNXdo3M2cGoPAtIWxoww1U2V640Ts7ZXNO2yVb+adBG4aF0g/9meSrehdkiqoJtHxSFEn773msSHGQNGQpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7591
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

add_lat_percentile_prio_sample() currently adds both a per priority sample
and a regular sample.

Since these two samples are completely unrelated, it is very confusing that
the add_lat_percentile_prio_sample() also adds a regular sample.

Remove the add_lat_percentile_sample() function call from
add_lat_percentile_prio_sample(), and let functions calling
add_lat_percentile_prio_sample() call add_lat_percentile_sample()
explicitly. This makes the flow in e.g. add_clat_sample() much easier to
follow.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/stat.c b/stat.c
index 28e49a89..f78899c8 100644
--- a/stat.c
+++ b/stat.c
@@ -3065,12 +3065,10 @@ static void add_lat_percentile_sample(struct thread=
_stat *ts,
 static void add_lat_percentile_prio_sample(struct thread_stat *ts,
 					   unsigned long long nsec,
 					   enum fio_ddir ddir,
-					   bool high_prio, enum fio_lat lat)
+					   bool high_prio)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
-	add_lat_percentile_sample(ts, nsec, ddir, lat);
-
 	if (!high_prio)
 		ts->io_u_plat_low_prio[ddir][idx]++;
 	else
@@ -3117,11 +3115,10 @@ void add_clat_sample(struct thread_data *td, enum f=
io_ddir ddir,
 		 * sample only when lat_percentiles=3D0. add_lat_sample() will add
 		 * the prio lat percentile sample when lat_percentiles=3D1.
 		 */
-		if (ts->lat_percentiles)
-			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
-		else
-			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
-						       FIO_CLAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
+		if (!ts->lat_percentiles)
+			add_lat_percentile_prio_sample(ts, nsec, ddir,
+						       high_prio);
 	}
=20
 	if (iolog && iolog->hist_msec) {
@@ -3222,8 +3219,8 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 	 * lat_percentiles=3D0.
 	 */
 	if (ts->lat_percentiles) {
-		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
-					       FIO_LAT);
+		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
+		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
--=20
2.33.1
