Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634B1C433F5
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6C760F51
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhKLJ5f (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:35 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31604 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhKLJ5f (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710884; x=1668246884;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YD4kkf1ZQdRxZJzuSDf5T9gsvorGkuBZB02GOqJkaKM=;
  b=YvWlmRDz87JPYYcPmJDJyz1LLsPV3YloFgbsLVNrkTwwwNTEDkQsAzVl
   LL+LIqO3x4rDVWUg4xcjcw0MRn1mnqqwqCLrNbeQ3pXPOOQGqLj01B9Q5
   YXlBZKWYSsi9A6gwDzAp+Gnp1DxJ9Gr+Ax7BnvJY0YZ0vpeW8wLjQ9qf/
   IrwIRL4BSpJhlPRBKkouaM2KnoPzkGHg1WfA0W69SVF4wczRxIpWYvrki
   /5khuVLXPlNHoVzqlW+KeLd9GT0Iyxma064lzSx/kGYfxXIx0Fepl94E3
   Guw03myYo5Nq1N2eiGhmW/Qlap3+Uf1irhRHuB/5tejVYXIfCPjzAcFph
   A==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360587"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2eZ0yQcNFm1dGVGJawakUM4aqm7wmJCS4yXIkal2JYfNVbxhKriIpVXWG1wN++AOPISJ0YJthlIg/6po8pATqmRLGzawtfozVY2kumROSlUsQeLdZzpaklGUVOg4i6QFClFhJ1vvCDdTvv/Vqtso6rwaVF07J7i16u2Lyh2wlzSUGuSk4Grj+MYtfSN6Xorc05WkthgH9frwEpbOkgbCfKs4BT9KYQ3ogAJGgeEfkfAPmtGgfC3jf00YLzpknAOv5HMfGYjTILrKg40ekeSog4WZdZsOOiPLrGhXeqzsDo+6f/73G49cN/l6GUhi5Hul8kdBhoHnIoioHpAHaLbpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/hPm/41KYupGbTBXzxdLCLHpkWOVR/tM2vayDgMcpU=;
 b=GvaamXYKecskVPFN67XTfVFzeiEymOI+pe7C+qU3CV/uMtUuHgFDgninYZBiB5EjQk82RmqgxMKymTSeA3MMk2/XKQfY+THoZO/88i6GvH8zR5f0qETO8TcFc5sjgV43i1fh02Efe+jbqgI2s87m/pZqidHuW0MXS51FBmRyS+JYInLifuRxWlpkft/j8evFjSvnu+rrBNZa0IAN/I1cwv9yNMCMvLmk8lSk2KFbYeQQkl2GhC0PRa7FnatsD8a8+olra1N6SBec67W1RdUlA80ZFSwyjgWYh0qaSzpp44AhcCcyJVJvYGG51A8mmyV3Keq3pQiEGKpAMnwJcHjbAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/hPm/41KYupGbTBXzxdLCLHpkWOVR/tM2vayDgMcpU=;
 b=kC4/+RwCfaOg0AGbEzUemds+TIwCsOxpPnR9E0N4QsXXnyJv6BNOKjtF1mLuLjYD95R7n0wp571PVhMexPKTDfYuG96H8RJWko2fqZffO076Sl4UcfNgpOQeihSDZrXJyAwR451uyZibz3h74dka6FRE49qgk7iVNUW8OcKk1sQ=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:43 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:43 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Topic: [PATCH v3 7/8] cmdprio: add mode to make the logic easier to
 reason about
Thread-Index: AQHX16tR9BM++e1enUGy+l1t6pzaXQ==
Date:   Fri, 12 Nov 2021 09:54:43 +0000
Message-ID: <20211112095428.158300-8-Niklas.Cassel@wdc.com>
References: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 299837b5-7521-419d-b74c-08d9a5c273e3
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB74338B55266EC4E57EA239E4F2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Dt92LV+aJysuhvhT5rVUst5x6ES3ZldWlgk1CY7p1jSw4fmVAGUUhl681K5GP/Z84nA5lB//uBL0w9yUaAT0khO9Kzh3vFbh+2bXJurqO4OCeE+lAeEO07uHuJrgqnF4eZBJFknt/J8tgzz2NsNayTkmH3f2qs0K07LPKkKwJIQhktmgO3Ijp8nhC4EHmv+M+T5afpcS0uJa1M+sxX3QruEopW7kdVuB583oxrRgi4/drgySDDJfTxiUJUC9MfTFXsnehechC1fvfAWfWfUrM+5MudxqC1qjNNiD+Gc47vhjClcoBuAH7xTxZdwjx/EQb5YYLEbZpN9CcOpLABFbnW2yccuVTwvMxcZpY6diiLnkgaOPbU5h5mCoiBWRDk5qDznoZSFPXDujQyJhfjGsb/M/2y+jIZN3iF3Vqjh5zVfl8tSZ38Hqlad635xl/7jDf5bkhHwmfTm77280huqbXq5Inq5VKwZ0WkzIovugsrGtvShu7a3SMbR6u1p/kyYwENX8RBvt3y8HNWunEcxOKBgJU66F5w9XrlG3gb4i9zyUoNMCuYmG324lNFksij0tRyFCq3Ji+qIk9WAz9cgT8cDcwS6nhGvtTSA8rdFxXVyej0wH9rNG88T2wzwUw4llsbrFoLJQ51T9Vk8cMFGWbsQ0Sx/tSFA7p7vH983WmHzpKxfnpq6T77bl/AyLPNtL1/nNjJGKrYcSQHjUGI+ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?IwKkZ59oI2PZOo2bA3lyp/PLpM1wmr5Q/pOqIsuQyQUJniY9hfecVpW72C?=
 =?iso-8859-1?Q?AhxMnQtVEa+h5V52SWybS04v4v6INN/PUR9JFVEyrNaUj6Fg0I7rDMPh+X?=
 =?iso-8859-1?Q?00sfnWbt+X3jc5sy0Zakn9cOSuT212qES1lHoi8qVl/z50kaY350M5Jnsd?=
 =?iso-8859-1?Q?NK8GgQB+3McLQBnl5Djiq8HIwg5nDR1YsmfN+fzUbvL9WhSV8NUcEmAMhm?=
 =?iso-8859-1?Q?F3YxoBEsa2Y+50qSr7Hc1tLEPMW1EBPtVKRDSZXYBS8D83iR+FQ52vm4pw?=
 =?iso-8859-1?Q?G4Ju2+OS8SFvbOAjjHa6/Enov44QegeCjpNZEkgNpZjfdTgC8ft0DNwvzd?=
 =?iso-8859-1?Q?Dx4VvRlhEy8xbvILGgko/WI+XkEOoo6sriA1MCHf9qKhihHoSr05IMGaLL?=
 =?iso-8859-1?Q?I5Rzl3AyCQGXhxEI5bfA9XcD1l6XKshlud/dYcFCCJPuXX+FHoGon3oRCU?=
 =?iso-8859-1?Q?cC9Hu6GO4eQU1SVWawlonsf4KSDooB+mClwPiTiR4mALj1RFc/l3RHIuA1?=
 =?iso-8859-1?Q?HSfxrOjpa7Kot2wyLsDt8iUm435vtcKNazf2/K3F0GA1OLJyA9oRuXEdYW?=
 =?iso-8859-1?Q?bq0WYh0EeYzA1vLP7y8qrbf0mGRtOAuJNRg5LcE3UUSdsWMREErbeQ/5bi?=
 =?iso-8859-1?Q?UVMk5+b2azJnRChZFjhFT6sdcnTuiuxwqSZvUjYAOiSGvA49Kbw8ayoMfz?=
 =?iso-8859-1?Q?tBRPv4CJcFEOmSHOZ60vL7fm/KrFycyjrf/df5KzA5fh1KmklsK2kOFt6g?=
 =?iso-8859-1?Q?Z7VW/v77h4fjLZ7S7IyM8igr+WppEvLCRSRaHTGIl+9XJNSxUg7chrF2xG?=
 =?iso-8859-1?Q?L2+6NVXzzQYA3ad4DP1fpH9vGTfC2lH4W4YTMpIHwNqJwn3uLCdf3qlyFL?=
 =?iso-8859-1?Q?hYkhliWe6Re3wqJg+I7OJ+yMcPL/hLXRXlGMmxwjIcknvlDAx8Zm9HqoVK?=
 =?iso-8859-1?Q?pgrp/X0GVHzfFiOztcUjqB4vT1GD1hyj+xzQOqa26kL99MpMZ+ImqNIKdm?=
 =?iso-8859-1?Q?Qb7mpP1Z7aOCxRWUumdT3/2xvwy41IF6FmWHY/bvcHLr2efYd/AJW2DGB7?=
 =?iso-8859-1?Q?4955O8OV+SUxlK/bxOV8ZfigJUohcswB40ViGqbg606kEPb/ELO50gHgV0?=
 =?iso-8859-1?Q?yRfhooTTXDOpOGn5kC27+iZ1bAEj4JiczGBFgsRg57ss3bQX8uRcrRM0eW?=
 =?iso-8859-1?Q?lYwfzWWpt39M5SqasQsytAduC6ErIHsBD2gzhYY3Ed+ty8JffnCu4/rTpE?=
 =?iso-8859-1?Q?Dl20xATPqO8vXndS2RmcShP4HjsXBmqf3wMq0/RqJ795PDKN+VYRc4Co8O?=
 =?iso-8859-1?Q?p1KGkp8WLMX/hfSx35KJVsEX6/D/Akjy8UbWlbMffCBQ9826/5GHpR+E6d?=
 =?iso-8859-1?Q?qLqSuB+1zYerCOxX94/o1KmI9v9gBqPK7KYWAg/BGkwifPRzh2ENRtmB9a?=
 =?iso-8859-1?Q?vDgIHng2ettiC03S97aJLmRFYLASLyyGsHJRyipjFjqRxWHEfgO1uZCL8N?=
 =?iso-8859-1?Q?9/cteN/XdUzyU82JRr/CdXlfNNwRA+xW+8P3hBzXtKHoxccQZbIJc/98SD?=
 =?iso-8859-1?Q?gmBnWuoxPqVbuKYFSf4jWckic3rrLdW3WI5cdRh3TfqZvWSmQ0GoBeVqip?=
 =?iso-8859-1?Q?E1s1Xbytyw2HjZ9FFk0G1y/Lo+M7v0Y1GMfzjjUBW9byef+/znG36iEPXN?=
 =?iso-8859-1?Q?D0tKHc6BhJsyGp7OW7M=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 299837b5-7521-419d-b74c-08d9a5c273e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:43.5371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DgG4KgO5U/KXN9JthZnNAvgmPtVruaRvUfbe7b9hxYP8lbOoPkdvs2XCpgCa+uvQ99UXPl9dOoM0v2PaqKqmkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add a new field "mode", in order to know if we are determining IO
priorities according to cmdprio_percentage or to cmdprio_bssplit.

This makes the logic easier to reason about, and allows us to
remove the "use_cmdprio" variable from the ioengines themselves.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/cmdprio.c  | 40 ++++++++++++++++++++++++----------------
 engines/cmdprio.h  | 10 ++++++++--
 engines/io_uring.c |  7 +++----
 engines/libaio.c   |  7 +++----
 4 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index d36b6264..8c52dabd 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -70,20 +70,23 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D cmdprio->percentage[ddir];
 	int i;
=20
-	/*
-	 * If cmdprio_percentage option was specified, then use that
-	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
-	 * on the IO size.
-	 */
-	if (p)
-		return p;
-
-	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
-		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
-			return cmdprio->bssplit[ddir][i].perc;
+	switch (cmdprio->mode) {
+	case CMDPRIO_MODE_PERC:
+		return cmdprio->percentage[ddir];
+	case CMDPRIO_MODE_BSSPLIT:
+		for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
+			if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
+				return cmdprio->bssplit[ddir][i].perc;
+		}
+		break;
+	default:
+		/*
+		 * An I/O engine should never call this function if cmdprio
+		 * is not is use.
+		 */
+		assert(0);
 	}
=20
 	return 0;
@@ -104,10 +107,11 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, s=
truct cmdprio *cmdprio,
 			    struct io_u *io_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int p;
 	unsigned int cmdprio_value =3D
 		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
+	p =3D fio_cmdprio_percentage(cmdprio, io_u);
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->ioprio =3D cmdprio_value;
 		if (!td->ioprio || cmdprio_value < td->ioprio) {
@@ -134,8 +138,7 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, str=
uct cmdprio *cmdprio,
 	return false;
 }
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
-		     bool *has_cmdprio)
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
 {
 	struct thread_options *to =3D &td->o;
 	bool has_cmdprio_percentage =3D false;
@@ -169,7 +172,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cm=
dprio *cmdprio,
 		return 1;
 	}
=20
-	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
+	if (has_cmdprio_bssplit)
+		cmdprio->mode =3D CMDPRIO_MODE_BSSPLIT;
+	else if (has_cmdprio_percentage)
+		cmdprio->mode =3D CMDPRIO_MODE_PERC;
+	else
+		cmdprio->mode =3D CMDPRIO_MODE_NONE;
=20
 	return 0;
 }
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 732b087e..7e4fcf6c 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -11,12 +11,19 @@
 /* read and writes only, no trim */
 #define CMDPRIO_RWDIR_CNT 2
=20
+enum {
+	CMDPRIO_MODE_NONE,
+	CMDPRIO_MODE_PERC,
+	CMDPRIO_MODE_BSSPLIT,
+};
+
 struct cmdprio {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
 	unsigned int level[CMDPRIO_RWDIR_CNT];
 	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
 	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
+	unsigned int mode;
 };
=20
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
@@ -25,7 +32,6 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, con=
st char *input,
 bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
 			    struct io_u *io_u);
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
-		     bool *has_cmdprio);
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
=20
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 68c33113..1f55ad17 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -68,8 +68,6 @@ struct ioring_data {
 	int prepped;
=20
 	struct ioring_mmap mmap[3];
-
-	bool use_cmdprio;
 };
=20
 struct ioring_options {
@@ -472,6 +470,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 {
 	struct ioring_data *ld =3D td->io_ops_data;
 	struct io_sq_ring *ring =3D &ld->sq_ring;
+	struct ioring_options *o =3D td->eo;
 	unsigned tail, next_tail;
=20
 	fio_ro_check(td, io_u);
@@ -494,7 +493,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 	if (next_tail =3D=3D atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
=20
-	if (ld->use_cmdprio)
+	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
=20
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
@@ -831,7 +830,7 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
diff --git a/engines/libaio.c b/engines/libaio.c
index dc6ad08e..53fe7428 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -51,8 +51,6 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
-
-	bool use_cmdprio;
 };
=20
 struct libaio_options {
@@ -320,6 +318,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld =3D td->io_ops_data;
+	struct libaio_options *o =3D td->eo;
=20
 	fio_ro_check(td, io_u);
=20
@@ -350,7 +349,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 		return FIO_Q_COMPLETED;
 	}
=20
-	if (ld->use_cmdprio)
+	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_libaio_cmdprio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
@@ -507,7 +506,7 @@ static int fio_libaio_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
--=20
2.33.1
