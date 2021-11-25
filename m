Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C12DC433FE
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 13:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355347AbhKYNZr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 08:25:47 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44960 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355360AbhKYNXr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 08:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637846437; x=1669382437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ji6KZ8YxskAr96vkhWvW0TTf1QnsCQFSQKO7D52aEAw=;
  b=ku13+tgpNxBquA+uGBq9cRrNKAmyL46j2TUFlQzzK0CXDiYsl+ifk5He
   IkSrse02UZCjl9L/jKTTBZZ5vynj0brJPjG2cfE8wHvqvN9j5gc6FHnGb
   p8hR52Y7RoMI8p5BWONMl6PdpGCUz5EeozbjTf3q51I1GP1SmUlRsynI4
   WHMd2Oq9vqbP+lWPTk+QYNTbl4wQLguLjysZ0HGeEez4sD0vZj4x13T5+
   daCvShCIQqkINHOyXQ2e233bdoTjjxR7CX3WQPdo9bKHLjeL7sZ6gt9Xc
   Gr1wi6C/8D6r6ItqZ96l5nEPEDKTFZtN3cI3ZkGSMmiXGcA88Mm2CEduZ
   A==;
X-IronPort-AV: E=Sophos;i="5.87,263,1631548800"; 
   d="scan'208";a="187633912"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 21:20:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nANXxw+e4BPaOr3vMcIW4yyAVRr8Slzb81CbKEDSE30YaTHtvch8SuOA0ma3gj6z7/etm8l6x2xMHtheats43J4/FxdtUnTiTvW0kaAEhHCwE5+Gz0rm82tOuR5NFf+v+AU/Xmxe4S9zGHc6e2WYmX0q22QGFWaiV/BJz9XMyCywz5QUH2asCSbu2m781cr7bLbzR9as5D9Hnjj8/HfNiNc1wm1i5Zckx0x1NLhR+SR7tf5je8KSfXgM4mHzVSNDvUZyg5gP7Di/4NDpRVjSMoEpGr54PaTmMdSM/XzA37LwaVYlnasXq+nKSr7ZhpAt8LKEz4RosHnKCYqjZtlYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Psykt5mh8C0NgdsWmZew/EkNSPRwbfJ8z9lZhzTKND4=;
 b=OdmQYj6S9A8x/CpRToArqzsuPAeoYl9aRs0zMRkZhSr3YWyrk8PNEJJMqkFARhgK2v78KnDNZ4+bSt5lirN83q8ubwy3M7AmXMNNdREngkpT+nFjDl9IztKA9TRastlyx2/oHlmVF4pYP6b0fUtcWIJ0uHwVcahBqugtkletIxuVq48hIrTJoRFcSFxgJsiQdFGNUjyX862GaIuOFHrtxwtgcJdgjBnSYwJ2zFnpmGr6ZatzGmnaf7Fk6uQ4gS0XWWWlwzIOzyVg0rnHMAOtjIFIeFnxHNGjiwU8tDE8UFbeaXKhwu9zrzcEboEcWtyu5F1Rx6BizdAVgNvxg4e/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Psykt5mh8C0NgdsWmZew/EkNSPRwbfJ8z9lZhzTKND4=;
 b=Ll5EzhW5dVQ8gXmRdjkU36tCZS3dSpr/rSAyu622EPkM+uD9/qu0lMsYp2O+mljXmpjygJGL/n2RRph6AbvD/lv4U2bwr7wRrnsyM28T0hsSr3WE5eGC76pXmQwlYcJ0dVKOgE+3GwipP1Ono8uYCouCc4ulQ7XJ3/2hy0WqjgM=
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
Subject: [PATCH v3 3/6] stat: rename add_lat_percentile_sample()
Thread-Topic: [PATCH v3 3/6] stat: rename add_lat_percentile_sample()
Thread-Index: AQHX4f84gXEaENyf6ke3nkGCAY05Kw==
Date:   Thu, 25 Nov 2021 13:20:31 +0000
Message-ID: <20211125132020.109955-4-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: b468a5bc-0845-4a36-8c14-08d9b0165b24
x-ms-traffictypediagnostic: PH0PR04MB7478:
x-microsoft-antispam-prvs: <PH0PR04MB7478025EF1D20CEB9635C344F2629@PH0PR04MB7478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: swoGv9hlfmf8m8080Obsh+Jh9zIGoNM8EqqAPBF9BgKsZn6TjRHBriHkr2N7yG+qDNCk1HAaJEzZ3brTbFrZBOLi1h2Z1MviODvJh85UjySA9I2dr4mMtl6JJk7e9dj46NYksa6ife7wrz3WEVzk8xpHHTMQxahz8hVaN3x9DRdSzhfwUyvESu7U82a9c7wJpu/XC2HIT3O7oSgWgPFW383k0Fg+lUd0L/29WoKW3ibXMa6xz4dSFeRjUIHYzPofWuquvGx7vWIT4W2s3WvloyQ5C1davfz3V04DSRsZ9YcW6NyFOIvlESU4AyXDbknE11sz+sAG5UBS5JQzOzZPEnJaYUsb3ZMyWuNxqw7iKZeuvjNoZE+jEl09egGH7bdwOyolR7cUv1Fq4n1yr4DoyLWovjiyjCOYXT6ncSV0iLSONev1GY5mOnoFd2ConZfBRJSPvylLL7aUtr+ZXUcblNRaOLdDOiBvcfI1PJGVnD3uaD4f4OJviTjojBqSZ+ivU+DGRQTzFSnpa9qevNu26xjEmsisUhWLUrbxCAARQroL9ZwL9+hHxXBPxnSmpXI+xuTLp1iTkOGJaorQXShRIm8m/E4KbBkVAFNSONmClqKlSy1f9I14CGokErQkSokgTOQj8IsuwZTZAhq7cJHfykWtL9/9o5l2Ld/SD4Br2i54nqsjKJQ+4kpVnY8lEoHOuFT1mcVHU1AzMgU4Q2BEtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(1076003)(6512007)(6506007)(186003)(6486002)(86362001)(4326008)(5660300002)(38070700005)(2906002)(508600001)(6916009)(316002)(66446008)(66556008)(64756008)(122000001)(83380400001)(82960400001)(26005)(54906003)(8936002)(91956017)(38100700002)(66946007)(36756003)(71200400001)(66476007)(2616005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gWd1tZySy3w3RhovpVl+Jj6UT+YGyMxaYKYUaPZ5E6Oy6o/fA8qfw5i5j+?=
 =?iso-8859-1?Q?9msmfSC4nr3W+xJd6y7mJ7Jn3TQFSsIQPdidn9L2P4UfVe5iBfKXFO+3PO?=
 =?iso-8859-1?Q?vuEZnWLsVWazV0ioA2fJRiafkCF804EvjPBRxZilChXUxiHUerPZ3Wj7TF?=
 =?iso-8859-1?Q?ziQDqriVbhO/qkylIrpJN8NxqkghmC3D4nWeoINBTcUGEsAS5ZNDu7PeC3?=
 =?iso-8859-1?Q?jRDVGtfnhmHZt+ZifHXWeKyqIvOmyjrNWMINvQ+Hmh282/1FHU0m3oEyrP?=
 =?iso-8859-1?Q?t2x6VUYg8bHhOibNUkqs3kfJQNcuQPlQVjQ4zxfqMYeQynoRZHrkwMZLGm?=
 =?iso-8859-1?Q?kHrOYWa6v7j0ttFWc4QS1A6/0FjkhMf0xm/kCSn4i+6YQ767ciwdpsbiVE?=
 =?iso-8859-1?Q?GEMW16qSE0UeuYZL/UqW5nqgMDWEC5BnA61B1YyUOq0FPiwGmwPy9n3NIq?=
 =?iso-8859-1?Q?oPFCbr7YOva1QneB0kpVEt0hS7DucauXtyagFFLMu1nECqL7FbFG6GZbcr?=
 =?iso-8859-1?Q?sfXbbux+D3ECawY2KwVmLYF8qU6AAqqWsdXixft6p7ZUyId0gW8LNIrStQ?=
 =?iso-8859-1?Q?WBzoePjpDTenOEmO/BJKWAkZ2n9SIIHLL7Y6u41emeYtaCPeyfN/HrbADT?=
 =?iso-8859-1?Q?QOCEd5AeYgBZ+ppIPCdCVvIrSxyKsGwdpxCODUXsX4uUslIcpdyBeJ9QM6?=
 =?iso-8859-1?Q?lJwhuV5l3Y5lhYRngQJPA9mFLV3Q1G0MgrBFbMxtirdmO4ekhCKjJrnrlW?=
 =?iso-8859-1?Q?kz4IhjY+8iIbAhQOQkWpf+LNh0TH0fyPybSKNMYH3HEKEi4d2lQFObkyLj?=
 =?iso-8859-1?Q?d6ipgnvB46V5Ka0Kv4p8jkdmm0ExxBz8mdLW7W03CJ3crkFC2bsQ8Ar+/u?=
 =?iso-8859-1?Q?2klrKH+9CeNt11ruWHo1RnBQtPivWsIfds32vtXkD6XSSVHYsT9vJIAm8C?=
 =?iso-8859-1?Q?+tGzt6358i0flM6pGy/XdhayyD+Hjqrt/cjm+S2yyDF55n31LmFK1hjG7I?=
 =?iso-8859-1?Q?qZHl3FSTtbNtGLjAdTLf6hUGi+Byzx23ZB79lqfrOi4TDhM13zFJDPdE8F?=
 =?iso-8859-1?Q?ccQmO7itTMwAWh8IOcc6aLvRXxyuctPDDmEwSMVIfiybEAXufBFPWEgcX1?=
 =?iso-8859-1?Q?oYdo/qt9WBZAkCIKhC9eUJUd8Ioa1zYs7azU8Xedqcb/N6pGjbCuATtifD?=
 =?iso-8859-1?Q?47gEk57CafleFG6unCPjA4ezc6VT7WnT78TdhMhPS1opbrd/fWjpTWYEji?=
 =?iso-8859-1?Q?DQB5GH+jbQQTkmQ/y6TDxpJhMlcqUYmb13fjzhfw5vz4hDzycfxEPlThi1?=
 =?iso-8859-1?Q?WaUBvpmBgQCgMkKmiIWvfow4WjX4BloaPgwtkzPi4EaFd4b9UwDYsdx9Mp?=
 =?iso-8859-1?Q?SpnVrfpcybvE/lT+dWgc7TSqdaz8TQCG/GeLPrAoezYeCir/IVgtZ8TrMH?=
 =?iso-8859-1?Q?AsP4rVb+LH+XeF3xtZMLVW5XPEZs79UFhSa1AZ1EUsIw1agwcwEhoY0RBw?=
 =?iso-8859-1?Q?Sqgf2CIvzaB0n+E453kcjEFCAETBekSkVvn5o72FOOuxFH8VK3FxlCU2Sw?=
 =?iso-8859-1?Q?28N8Gb5qrTKQPiZ+1ZepjST39m7h/bJWtQkA5ZykxnESuSP4NmIpWiC5IP?=
 =?iso-8859-1?Q?82BFBJ+RnIn5kCR+k5LLZl9rdWVowYJqNRQPIhyDreZJG9Bg/Jtqo1uxPv?=
 =?iso-8859-1?Q?3IVc7+oNYRiAFvR7htU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b468a5bc-0845-4a36-8c14-08d9b0165b24
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 13:20:31.2595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pLtEUpTZipvAWKVojkjI3/Mgxo8nwxMD+QpPQ6OA+KT119lOmdhRC7l3TEr9rL7P3aojUw9EpWLvRFIuRVYe1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The name for add_lat_percentile_sample() is confusing, since the function
actually adds a per priority percentile sample (it also adds a regular
sample), yet it doesn't have prio as part of the function name.

Rename the function so that it is more obvious that this function should
be used if you want to add a prio percentile sample.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 stat.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/stat.c b/stat.c
index 8bb49e4b..1e0da99d 100644
--- a/stat.c
+++ b/stat.c
@@ -3061,9 +3061,10 @@ static void add_lat_percentile_sample_noprio(struct =
thread_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
=20
-static void add_lat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir,
-				bool high_prio, enum fio_lat lat)
+static void add_lat_percentile_prio_sample(struct thread_stat *ts,
+					   unsigned long long nsec,
+					   enum fio_ddir ddir,
+					   bool high_prio, enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
@@ -3118,7 +3119,8 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		if (ts->lat_percentiles)
 			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
 		else
-			add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_CLAT);
+			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
+						       FIO_CLAT);
 	}
=20
 	if (iolog && iolog->hist_msec) {
@@ -3219,7 +3221,8 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 	 * lat_percentiles=3D0.
 	 */
 	if (ts->lat_percentiles) {
-		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
+		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
+					       FIO_LAT);
 		if (high_prio)
 			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
 		else
--=20
2.33.1
