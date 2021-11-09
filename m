Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0A8C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0AEA6109D
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhKIAbG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:31:06 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16464 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241224AbhKIAbF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417700; x=1667953700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+hf0knbnLySb2T4G7i9XnH0YG/NckttDTUeQKBe4sww=;
  b=OdSwHeqDEPJL66zv6tWLeFdhTjf4hac06niL+UrXV4tiFAr1RUlAPe8T
   r+md7lL8TmselGOI2lOQQFOMgVO0pdqEiwkE9P+usgpHoe2VDp887ReLl
   P+miHS0rRKVLxus0YFlz0v3rJ6feDv71oICKJQAvqhskVO2gG78sRjQk5
   pm8HUHRycxRVyBEQmoBczw/6y/HND4CXEPs1Zb7Mtm9o4/zq1U01uCPdG
   vh+dUpW1OleGWfTDR5dEdsH0vmgUf16AG0CIUDzbFkDEUPWGNNzCh+xib
   2/AZbNc4V1OeG/WE5BZxMdC5zJkqKyI9ibsLCkQ3zt+QLW9jk1OXquFRA
   w==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="184063274"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtgzNA3j8aY7D2r1msWqN4nqxrGAVNH1rCzeg4SEVmlvQWGZ3kat46gU9CEEC8NEL5PcakMqe406T+lEJ15YWhs2QTshpeUuaqP/XJ8cJT9H8J5+99RGojDXBCSrMtRw8UJ5aP7mr1nQ8eGewqNEWzZ+59Q8ucfaqX3fZxtIUzzV25iaX5+IcAYDLD9B57LeMAhwykYHv4GuchQebftXIc4HXxp+Bhjad+ytH/Hp5Zt3qE8qC1UWjQ9XmnbShchHbK3yx+u0kuGV8IHe5Uh3dgtIYk0DtcYnPvBNrFQL06R3gJVP3BdPtN75n8Fsva2+0npybwLcysukS0vpcdjAGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wDxMY5s3LNmmxTsi65X2V+cd8ysNOtlq3exJSr95Wc=;
 b=TWslhp/f1u7NJxags7+v75y3f5jhgrrbCUhvvkLv+KkvI5FOocFNWOHTMm0A9qZAx7hdU/qFzY8NBAQ4wWHRqHZgQBIJv4bHVAkd02ZWmrgj1pu7rBoYYrRznC04pimAePCznsidvsFVB5UakFnVCMZ7zAnlUr24PtbEwk0q5Ygte2Pe2pxPMvrfFyA8NUXVcNEd6IFBkVfXhzcJ5RCsOPLHHN32dw+jEJqxe+f8x6q6xxYWO2w2CG7VVmRaPJE8U38yZ7m3F4DgwgP70fGb8NCu8Fn/Q5iOPbiHW2f6yCfIELXooQrrkplKHo2cVNhga5bKcl5lf1XnLoWiukyaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wDxMY5s3LNmmxTsi65X2V+cd8ysNOtlq3exJSr95Wc=;
 b=nW6xoMC6Bm2GSwjwzxdD+eEzSWVdmHkPaIFw7AtUNrsZcjlIgm2xlAiJOjDwXHQ4lWcSTx4dFVjxSrO3JeMjZSSJEw/Q0ZEErShdOGGIER9w7bxxj33Qqt+NkclNF6KTuZkemjVSzroBKMsByj6iF6vg573/IX5SUkWHwPolWD4=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:17 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:17 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 8/8] libaio,io_uring: make it possible to cleanup cmdprio
 malloced data
Thread-Topic: [PATCH 8/8] libaio,io_uring: make it possible to cleanup cmdprio
 malloced data
Thread-Index: AQHX1QCwX5lCJhxRS02xuSmb8Lmw2g==
Date:   Tue, 9 Nov 2021 00:28:17 +0000
Message-ID: <20211109002655.117274-9-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 436b31de-f3d5-4898-1112-08d9a317d325
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB7144C097F170A632D678ED75F2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lwfrh5JOgyxRFQ+jnUMJ3mIbX+5oYoeIudPo00OmYxuhoxXSMHTWti8+w/WFUcSZbWiiAGQDkPYAxCR8ADwoim6y8ojX9eqwL/1qWN2ox/WqfHSkyHy+8Joiz2EAkiITt/FbUb37F1DtB9IvDXbJ8w2Qoh7ZGFhm6vxzI0pXy3n8TuTXrNGRO70XbUrBHL34dEToDaPmigIbJ6f528ZWRe3/ZEj0uVzUPuflXLdOx3lHIoxIx10Z813HQ94A9hleDQDdiLbK1g3NRZsNnX0lGTKlt1Cc9swCYuqSAWtcdLIf3UcMhUWLSNAOd5DV239m9poHFWPsjU7O4WZKGUSxw1lBTsZS+Pd0eNTbrNZe4qqTmPsRVgUhkhUKYT8maigHzt2Ap2TXUtO8w08ShlScW+YHBBwbjijAZIQw1iJKj+b6Gbu991OVZSXZTEGQwQ56m2pAhZXcgYUN6AlgZJB8IXNr5x/LVB0PKwbHcLaogyLGMNUjx9LYXFBmej/Uuc9MZMIhuJThokgS15bBptfP+Y4jnBJ8IHIpZgCjST2dd/uFXgaXKh6IHMIjayoeBP0yRzoFnJo+j3h0Gq0RGZ61jFTittDfb7v2Vv5f9rFQLiCXc8EihzlN5j8dyOi1Zt0PwHVMYoY/aHvJMDc4GEB8W+ytjy1KHeaVlIJbyGO4ELDiWkLEAEDskxeC8q3p8juWpHeqGL206mR3QW8PLr19JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(30864003)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?wJgQTCgZfL+rJeAANJBoA/wHh27ma4LssTexzf8pKs/8VdMZisqFzGb8eK?=
 =?iso-8859-1?Q?7kd+UZk+whQuSbGuOTXAW2vdH+msFWvSXHyqY42blMWQ+dBgzXxmX09tdw?=
 =?iso-8859-1?Q?plW6oCci1IJq0baXiVJ1W4kFrLVDw03cf7MjcfRdZqF5oUrWf+4B1RHnb4?=
 =?iso-8859-1?Q?G4A8BD36+jHe85IoiSiBuhsOHC1I7pBVuF+sgRnsX5l20vtvS9UFKBcr9C?=
 =?iso-8859-1?Q?Z6dm8F0p+ofzTSLp2vhvxKh4YHovRgMTZ3v5Fgbva6L0ihxVBtBIG47b4Q?=
 =?iso-8859-1?Q?arSC6tHNPtV817zi1r5wgMIYb75cvasyXheWbkBoAjdY4Z1leEqpXlc1AR?=
 =?iso-8859-1?Q?VGQ8auMdRQQz92WPpvCModG/ehhr8UmtMyX5KPJfj2xNWMhxbYG1O6qZDM?=
 =?iso-8859-1?Q?D1DPLnKgEx3Om61vyNE1yd1kHD74fWnB+ty6MRES/fyqmarJlL1Vp7CNo4?=
 =?iso-8859-1?Q?YU9cvYboWwlla56H52LJFYh1dLNzqQJ64CeFJFSlJ0g2pFfq+Q4cajPAvq?=
 =?iso-8859-1?Q?d75SLDktHp+xuripR3VrB52jfDw+ybZpXjL5EVyp6AXWCo13q65b5SoT8W?=
 =?iso-8859-1?Q?1XD7Rg8cbpOdEjijUf9LqCBPRhA6twWqngIWz3Nvygu52TgZuvQMw+5xpO?=
 =?iso-8859-1?Q?KN6tsUukyiloW3cJztMftqn5HKb6RncPvUcCuqDAn976OdJxuuavzoigwb?=
 =?iso-8859-1?Q?E0bx8xi42Fdz0gISVqVib/Z3ZoahOhRYVmhaMyn9xTXUnmFwB3QU122uhl?=
 =?iso-8859-1?Q?mDQm2mZwtYcjdKPY+2e/msNH9USmQ5DRq9DiXsOMBwnFB14efYQnRMOeuf?=
 =?iso-8859-1?Q?niUXtBBZ66r/RvGPGhpjFI64vY6pvYleceJ1wQSE6jvkN9DtOXd9fyHpTP?=
 =?iso-8859-1?Q?Vm6DwptAVcJczUHwWErGgpE0oaxd/6aUoo02M98HN8SKXPdNwFm+gEeOaM?=
 =?iso-8859-1?Q?+ncVEAkaZzCEx1LKuMoCR3aOkPpO/YTIyzSWhc0chghH7jdyqNaXg1v36y?=
 =?iso-8859-1?Q?thld53Xkj1H5dZq1Fum09xR+MvcMtilPjcPL/19nslu57CXNTzUvXnuSfy?=
 =?iso-8859-1?Q?jyIUsmPpdECpCQgtYqAgxRR5bsQHK+6E1J0DzwQoojmYfSa3TmO76DJO0K?=
 =?iso-8859-1?Q?yW3Z5VNRcDXgRBYWisFOLqPD4LH1Uh5SfkP4pMiaHKS+vNdO49AqQwTO99?=
 =?iso-8859-1?Q?pObyz5OvQXA8E8+Txo3cUtbV1uWZl0kTzBzoMv2aOPsDl9WivsUlcCQZaW?=
 =?iso-8859-1?Q?CEA/GKdxEn8qBc6WLo3TbWWF1kwcjj4Svon+5knab64ZRTSGiUaBJqBDXa?=
 =?iso-8859-1?Q?+pxxwixHtqShcxpmYa+Yk9KsQjb0Wx6W+nItmE5EJMliCxMNbpjmzBwTf2?=
 =?iso-8859-1?Q?hr8cvp8g52QXNyjyReM4ufih0mX0kFKZeX8DTslaHB8d0w3Tdmi1whIo8D?=
 =?iso-8859-1?Q?skaJrtWrTWKXhbeKG09LTR0IVLC7B83e5rTfFvwu9B4BhtP2IMU+O6M+du?=
 =?iso-8859-1?Q?r+KbbrxVGHiOpBW6LirbLECYnAEMS1R+sXpOFSKwWdsXopE9iqkOkN86pB?=
 =?iso-8859-1?Q?Ur8A9zCilZuEuoZN2IP+5ikWUci1uwYzl4PbBkYye29viAAJTrqK5GbV1L?=
 =?iso-8859-1?Q?xJqlA6tFGQX2yPNyQ3Ufn2sS8bL59l3hx0W4Bi9Y5Cikxq6jUTjGsfLDLV?=
 =?iso-8859-1?Q?1tSJ3gCD9IPfkVvdU3Q=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436b31de-f3d5-4898-1112-08d9a317d325
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:17.0278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HENGe6MUgmyqTgqX8x1mA3TCU0K9rccIodeR5HqVLXsHUHq1YYlA9AjuDumYL5xfe1UTIXbNNCYtHlJ3w1khKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The way that fio currently handles engine options:
options_free() will only every call free() on an option that has type
FIO_OPT_STR_STORE. This means that any option that has a pointer in
either td->o or td->eo, which is not of type FIO_OPT_STR_STORE will
leak memory. This is true even for numjobs =3D=3D 1.

When running with numjobs > 1, fio_options_mem_dupe() will memcpy
td->eo into the new td. Since off1 of the pointers in the first td
has already been set, the pointers in the new td will point to the
same data. (Regardless, options_free() will never try to free the
memory, for neither td.) Neither can we manually free the memory in
cleanup(), since the other td will still point to the same memory,
so this would lead to a double free.

These memory leaks are reported by e.g. valgrind.

The most obvious way to solve this is to put dynamically allocated
memory in {ioring,libaio}_data instead of {ioring,libaio}_options.

This solves the problem since {ioring,libaio}_data is dynamically
allocated by each td during the ioengine init callback, and is freed
when the ioengine cleanup callback for that td is called.

The downside of this is that the parsing has to be done in
fio_cmdprio_init() instead of in the option .cb callback, since the
.cb callback is called before {ioring,libaio}_data is available.

This patch keeps the static cmdprio options in
{ioring,libaio}_options, but moves the dynamically allocated memory
needed by cmdprio to {ioring,libaio}_data.

No cmdprio related memory leaks are reported after this patch.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/cmdprio.c  | 100 +++++++++++++++++++++++++++++++++++----------
 engines/cmdprio.h  |  15 ++++---
 engines/io_uring.c |  41 ++++++++-----------
 engines/libaio.c   |  43 ++++++++-----------
 4 files changed, 122 insertions(+), 77 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index cafe21d7..4bebdf9b 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -46,22 +46,15 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 			      struct cmdprio *cmdprio)
 {
 	char *str, *p;
-	int i, ret =3D 0;
+	int ret =3D 0;
=20
 	p =3D str =3D strdup(input);
=20
 	strip_blank_front(&str);
 	strip_blank_end(str);
=20
-	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
-
-	if (parse_dryrun()) {
-		for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-			free(cmdprio->bssplit[i]);
-			cmdprio->bssplit[i] =3D NULL;
-			cmdprio->bssplit_nr[i] =3D 0;
-		}
-	}
+	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
+			      false);
=20
 	free(p);
 	return ret;
@@ -70,10 +63,11 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
+	struct cmdprio_options *options =3D cmdprio->options;
 	int i;
=20
 	if (cmdprio->mode =3D=3D CMDPRIO_MODE_PERC)
-		return cmdprio->percentage[ddir];
+		return options->percentage[ddir];
=20
 	assert(cmdprio->mode =3D=3D CMDPRIO_MODE_BSSPLIT);
 	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
@@ -94,9 +88,10 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_data *=
td,
 				    struct cmdprio *cmdprio, struct io_u *io_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
+	struct cmdprio_options *options =3D cmdprio->options;
 	unsigned int p;
 	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+		ioprio_value(options->class[ddir], options->level[ddir]);
=20
 	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE) {
 		/*
@@ -132,11 +127,29 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_dat=
a *td,
 	return false;
 }
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
+static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
+					     struct cmdprio *cmdprio)
 {
-	struct thread_options *to =3D &td->o;
-	bool has_cmdprio_percentage =3D false;
-	bool has_cmdprio_bssplit =3D false;
+	struct cmdprio_options *options =3D cmdprio->options;
+	int ret;
+
+	ret =3D fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	fio_cmdprio_cleanup(cmdprio);
+
+	return ret;
+}
+
+static int fio_cmdprio_gen_data_structs(struct thread_data *td,
+					struct cmdprio *cmdprio)
+{
+	struct cmdprio_options *options =3D cmdprio->options;
+	int ret =3D 1;
 	int i;
=20
 	/*
@@ -144,12 +157,51 @@ int fio_cmdprio_init(struct thread_data *td, struct c=
mdprio *cmdprio)
 	 * is not set, default to RT priority class.
 	 */
 	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-		if (!cmdprio->class[i])
-			cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-		if (cmdprio->percentage[i])
+		if (!options->class[i])
+			options->class[i] =3D IOPRIO_CLASS_RT;
+	}
+
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_BSSPLIT)
+		ret =3D fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
+	else if (cmdprio->mode =3D=3D CMDPRIO_MODE_PERC)
+		ret =3D 0;
+
+	return ret;
+}
+
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
+{
+	int ddir;
+
+	for (ddir =3D 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
+		free(cmdprio->bssplit[ddir]);
+		cmdprio->bssplit[ddir] =3D NULL;
+		cmdprio->bssplit_nr[ddir] =3D 0;
+	}
+
+	/*
+	 * options points to a cmdprio_options struct that is part of td->eo.
+	 * td->eo itself will be freed by free_ioengine().
+	 */
+	cmdprio->options =3D NULL;
+}
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options)
+{
+	struct thread_options *to =3D &td->o;
+	bool has_cmdprio_percentage =3D false;
+	bool has_cmdprio_bssplit =3D false;
+	int i;
+
+	cmdprio->options =3D options;
+
+	if (options->bssplit_str && strlen(options->bssplit_str))
+		has_cmdprio_bssplit =3D true;
+
+	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
+		if (options->percentage[i])
 			has_cmdprio_percentage =3D true;
-		if (cmdprio->bssplit_nr[i])
-			has_cmdprio_bssplit =3D true;
 	}
=20
 	/*
@@ -169,5 +221,9 @@ int fio_cmdprio_init(struct thread_data *td, struct cmd=
prio *cmdprio)
 	else
 		cmdprio->mode =3D CMDPRIO_MODE_NONE;
=20
-	return 0;
+	/* Nothing left to do if cmdprio is not used */
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE)
+		return 0;
+
+	return fio_cmdprio_gen_data_structs(td, cmdprio);
 }
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 7d14b3a6..ad03190d 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -17,21 +17,26 @@ enum {
 	CMDPRIO_MODE_BSSPLIT,
 };
=20
-struct cmdprio {
+struct cmdprio_options {
 	unsigned int percentage[CMDPRIO_RWDIR_CNT];
 	unsigned int class[CMDPRIO_RWDIR_CNT];
 	unsigned int level[CMDPRIO_RWDIR_CNT];
+	char *bssplit_str;
+};
+
+struct cmdprio {
+	struct cmdprio_options *options;
 	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
 	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
 	unsigned int mode;
 };
=20
-int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
-			      struct cmdprio *cmdprio);
-
 bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
 				    struct cmdprio *cmdprio, struct io_u *io_u);
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio);
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options);
=20
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index f82fa1fd..3f191f0a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -68,12 +68,14 @@ struct ioring_data {
 	int prepped;
=20
 	struct ioring_mmap mmap[3];
+
+	struct cmdprio cmdprio;
 };
=20
 struct ioring_options {
 	struct thread_data *td;
 	unsigned int hipri;
-	struct cmdprio cmdprio;
+	struct cmdprio_options cmdprio_options;
 	unsigned int fixedbufs;
 	unsigned int registerfiles;
 	unsigned int sqpoll_thread;
@@ -104,15 +106,6 @@ static int fio_ioring_sqpoll_cb(void *data, unsigned l=
ong long *val)
 	return 0;
 }
=20
-static int str_cmdprio_bssplit_cb(void *data, const char *input)
-{
-	struct ioring_options *o =3D data;
-	struct thread_data *td =3D o->td;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
-
-	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
-}
-
 static struct fio_option options[] =3D {
 	{
 		.name	=3D "hipri",
@@ -129,9 +122,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "high priority percentage",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct ioring_options,
-				   cmdprio.percentage[DDIR_READ]),
+				   cmdprio_options.percentage[DDIR_READ]),
 		.off2	=3D offsetof(struct ioring_options,
-				   cmdprio.percentage[DDIR_WRITE]),
+				   cmdprio_options.percentage[DDIR_WRITE]),
 		.minval	=3D 0,
 		.maxval	=3D 100,
 		.help	=3D "Send high priority I/O this percentage of the time",
@@ -143,9 +136,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority class",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct ioring_options,
-				   cmdprio.class[DDIR_READ]),
+				   cmdprio_options.class[DDIR_READ]),
 		.off2	=3D offsetof(struct ioring_options,
-				   cmdprio.class[DDIR_WRITE]),
+				   cmdprio_options.class[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority class",
 		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
 		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
@@ -158,9 +151,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority level",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct ioring_options,
-				   cmdprio.level[DDIR_READ]),
+				   cmdprio_options.level[DDIR_READ]),
 		.off2	=3D offsetof(struct ioring_options,
-				   cmdprio.level[DDIR_WRITE]),
+				   cmdprio_options.level[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority level",
 		.minval	=3D IOPRIO_MIN_PRIO,
 		.maxval	=3D IOPRIO_MAX_PRIO,
@@ -171,9 +164,9 @@ static struct fio_option options[] =3D {
 	{
 		.name   =3D "cmdprio_bssplit",
 		.lname  =3D "Priority percentage block size split",
-		.type   =3D FIO_OPT_STR_ULL,
-		.cb     =3D str_cmdprio_bssplit_cb,
-		.off1   =3D offsetof(struct ioring_options, cmdprio.bssplit),
+		.type   =3D FIO_OPT_STR_STORE,
+		.off1   =3D offsetof(struct ioring_options,
+				   cmdprio_options.bssplit_str),
 		.help   =3D "Set priority percentages for different block sizes",
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_IOURING,
@@ -457,8 +450,7 @@ static int fio_ioring_getevents(struct thread_data *td,=
 unsigned int min,
 static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
 {
 	struct ioring_data *ld =3D td->io_ops_data;
-	struct ioring_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
+	struct cmdprio *cmdprio =3D &ld->cmdprio;
 	bool ioprio_updated =3D fio_cmdprio_ioprio_was_updated(td, cmdprio, io_u)=
;
=20
 	if (ioprio_updated)
@@ -470,7 +462,6 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 {
 	struct ioring_data *ld =3D td->io_ops_data;
 	struct io_sq_ring *ring =3D &ld->sq_ring;
-	struct ioring_options *o =3D td->eo;
 	unsigned tail, next_tail;
=20
 	fio_ro_check(td, io_u);
@@ -493,7 +484,7 @@ static enum fio_q_status fio_ioring_queue(struct thread=
_data *td,
 	if (next_tail =3D=3D atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
=20
-	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
+	if (ld->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
=20
 	ring->array[tail & ld->sq_ring_mask] =3D io_u->index;
@@ -599,6 +590,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 		if (!(td->flags & TD_F_CHILD))
 			fio_ioring_unmap(ld);
=20
+		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
 		free(ld->iovecs);
 		free(ld->fds);
@@ -805,7 +797,6 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
 	int ret;
=20
 	/* sqthread submission requires registered files */
@@ -830,7 +821,7 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio);
+	ret =3D fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
diff --git a/engines/libaio.c b/engines/libaio.c
index b33461f4..43ddcda5 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -51,24 +51,17 @@ struct libaio_data {
 	unsigned int queued;
 	unsigned int head;
 	unsigned int tail;
+
+	struct cmdprio cmdprio;
 };
=20
 struct libaio_options {
 	struct thread_data *td;
 	unsigned int userspace_reap;
-	struct cmdprio cmdprio;
+	struct cmdprio_options cmdprio_options;
 	unsigned int nowait;
 };
=20
-static int str_cmdprio_bssplit_cb(void *data, const char *input)
-{
-	struct libaio_options *o =3D data;
-	struct thread_data *td =3D o->td;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
-
-	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
-}
-
 static struct fio_option options[] =3D {
 	{
 		.name	=3D "userspace_reap",
@@ -85,9 +78,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "high priority percentage",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct libaio_options,
-				   cmdprio.percentage[DDIR_READ]),
+				   cmdprio_options.percentage[DDIR_READ]),
 		.off2	=3D offsetof(struct libaio_options,
-				   cmdprio.percentage[DDIR_WRITE]),
+				   cmdprio_options.percentage[DDIR_WRITE]),
 		.minval	=3D 0,
 		.maxval	=3D 100,
 		.help	=3D "Send high priority I/O this percentage of the time",
@@ -99,9 +92,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority class",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct libaio_options,
-				   cmdprio.class[DDIR_READ]),
+				   cmdprio_options.class[DDIR_READ]),
 		.off2	=3D offsetof(struct libaio_options,
-				   cmdprio.class[DDIR_WRITE]),
+				   cmdprio_options.class[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority class",
 		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
 		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
@@ -114,9 +107,9 @@ static struct fio_option options[] =3D {
 		.lname	=3D "Asynchronous I/O priority level",
 		.type	=3D FIO_OPT_INT,
 		.off1	=3D offsetof(struct libaio_options,
-				   cmdprio.level[DDIR_READ]),
+				   cmdprio_options.level[DDIR_READ]),
 		.off2	=3D offsetof(struct libaio_options,
-				   cmdprio.level[DDIR_WRITE]),
+				   cmdprio_options.level[DDIR_WRITE]),
 		.help	=3D "Set asynchronous IO priority level",
 		.minval	=3D IOPRIO_MIN_PRIO,
 		.maxval	=3D IOPRIO_MAX_PRIO,
@@ -127,9 +120,9 @@ static struct fio_option options[] =3D {
 	{
 		.name   =3D "cmdprio_bssplit",
 		.lname  =3D "Priority percentage block size split",
-		.type   =3D FIO_OPT_STR_ULL,
-		.cb     =3D str_cmdprio_bssplit_cb,
-		.off1   =3D offsetof(struct libaio_options, cmdprio.bssplit),
+		.type   =3D FIO_OPT_STR_STORE,
+		.off1   =3D offsetof(struct libaio_options,
+				   cmdprio_options.bssplit_str),
 		.help   =3D "Set priority percentages for different block sizes",
 		.category =3D FIO_OPT_C_ENGINE,
 		.group	=3D FIO_OPT_G_LIBAIO,
@@ -205,8 +198,8 @@ static int fio_libaio_prep(struct thread_data *td, stru=
ct io_u *io_u)
=20
 static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
 {
-	struct libaio_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
+	struct libaio_data *ld =3D td->io_ops_data;
+	struct cmdprio *cmdprio =3D &ld->cmdprio;
 	bool ioprio_updated =3D fio_cmdprio_ioprio_was_updated(td, cmdprio, io_u)=
;
=20
 	if (ioprio_updated) {
@@ -318,7 +311,6 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld =3D td->io_ops_data;
-	struct libaio_options *o =3D td->eo;
=20
 	fio_ro_check(td, io_u);
=20
@@ -349,7 +341,7 @@ static enum fio_q_status fio_libaio_queue(struct thread=
_data *td,
 		return FIO_Q_COMPLETED;
 	}
=20
-	if (o->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
+	if (ld->cmdprio.mode !=3D CMDPRIO_MODE_NONE)
 		fio_libaio_cmdprio_prep(td, io_u);
=20
 	ld->iocbs[ld->head] =3D &io_u->iocb;
@@ -468,6 +460,8 @@ static void fio_libaio_cleanup(struct thread_data *td)
 		 */
 		if (!(td->flags & TD_F_CHILD))
 			io_destroy(ld->aio_ctx);
+
+		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
@@ -493,7 +487,6 @@ static int fio_libaio_init(struct thread_data *td)
 {
 	struct libaio_data *ld;
 	struct libaio_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
 	int ret;
=20
 	ld =3D calloc(1, sizeof(*ld));
@@ -506,7 +499,7 @@ static int fio_libaio_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio);
+	ret =3D fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_libaio_init");
 		return 1;
--=20
2.33.1
