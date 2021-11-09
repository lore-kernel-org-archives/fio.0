Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9F5C433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF10611CA
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhKIXlU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:20 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43928 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhKIXlS (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501110; x=1668037110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tmNvcYB67DO3GJKFlkTlETBdhka7BurnuXR5AfAQtEw=;
  b=VKnrEFIZkJPw/uHKSvIUKZbLqZbjxZ4D/I2rH4q/R7AFgul/j0XBraPn
   phzLyEEh24BiqcqgXX8XCa9C+knIO8Pf6p6F42OiuIsNx4ul8jQLDkH/Z
   HcH0Wv7PGFejteCIuPIYDNZ8WgduCWrSKazAcm64kGbRBD1H+ENo8E2vs
   VkJ3SHlunIRm8teh9EsNxMRqlHswHHy1s0YyBZbSuijGpc4eHmu3dGoU6
   qaun7AKLGKaCE4WmVRHIcjw9QhM5mWgszwehMljMm5ycHXU38YTw7JUvl
   ukrKv4d1dajtf7EPSHDj5ebDRxjjPb/itjmCRyys4KwRJo+wj/3qq0Z9j
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="185172216"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os1sKIzz1L0Sh/kg62M3fBl75jVi98LhYw0oiM32CGfHwQ4/YsPpD7CMRIgspYBFtGL7A7gCxCz2wnb29l6rZpYKcroQTRBgI3UAS0hYt2BhdOnr6wP9NZztDWXY2whMxyUXx/BSIe2g/lUCvucbXAKDMe7ksLmFd/D/pGXx2JaYcYAwEBWXhysA0m9yOleew4JqNnPTamyeEqvkZiU/l/VGJ5ge7c/GmCsefFSCerVSTDtv+EEV+r0Tk12e5v3LM+6XzE8E0A4PkgjDjxD41w3CX49emZe5sFJhcdNA8ppq5IqXZ7s/w8oJnXlVsq6GREp6EzH5FAU2ONXt6pZI3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UofI6BI9o/PdzA5ekbKFLcdBV4M6zOEBQ+x0ZmTi4Q=;
 b=S2jF6hAGE8UjZ2h1F3R4SFpr7CO5H8qYH3L5iMhBeGAfyeWaeejnnoJq2NV5XFMNL5suF4akgX0DUQUxTo27/ho7xd6eTdtG4zuRmnkahCpmIzXaXUcSoThPuVQLUfzIQSbEh9fXkDDhdks5RPsw4y60sXpFQClg6t5i86sxHsmsYMNetIztJuQ0HoHDW2H74FMYcU4YzgsbOaulk2I/RUDDhzp1qsEdPGh01d5caieyy4NYDpjAfzzGZN8q19VnwvSap4ErnrHLBPS3UujpgvZryrH2RvCh7F5V1xs3ZSgibwf5wmBe+1JomgF3anigl2xcj45ViJCnp8sRK79aTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UofI6BI9o/PdzA5ekbKFLcdBV4M6zOEBQ+x0ZmTi4Q=;
 b=KtXROW2KWVPNFaDZiDT1W6RE6z8XDBeBzoeNYeGFVYztWvBxZpHl5mEQSrjJomzas4c416oU6p4XvRTd85fcyjVR6CxzVGhBN1Nrl/wOsl/67/fV5sn0ZXTWBgMXxab5Xzd2uTAZyQzxxd7my8dNT31x0A1rByVoZIfTm038btQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7736.namprd04.prod.outlook.com (2603:10b6:510:53::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 23:38:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Thread-Topic: [PATCH v2 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Thread-Index: AQHX1cLmRFtXLtfqy0C++n8W/PeXFg==
Date:   Tue, 9 Nov 2021 23:38:30 +0000
Message-ID: <20211109233804.164786-5-Niklas.Cassel@wdc.com>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37689fc6-3581-4174-c354-08d9a3da0934
x-ms-traffictypediagnostic: PH0PR04MB7736:
x-microsoft-antispam-prvs: <PH0PR04MB7736DDEFBEEDBD4C634C5A4AF2929@PH0PR04MB7736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /c8t64gSmcwHZ93uu5jvZVwSg4HpmzpDz9wAqMTL/3SBnIfeQ/V9LB/e/fb2EQjLhForNTXAXCGivX4acMRjteEtI8fXGmuEm67JzDZw4jfNEa/a5w3gHmrzfAeAYKSJNucA+w6n7NqzFBWDVF70z5Frgjg6Pzvx/4lr/ci7z36VlVDwckbRWDNfyFuLOdEYfz+XkJ0ojrea0UmB9BextXZIvnK7SU3M60pcrdnbE4HXWBEeLtb0h/1AHAJbhDd6XdMms7k2mHqt53piPAhPMmE8KTT1fl5QaHlVyTm1Fb7wdg4pToNRaY5jCh7uSdglj4d1BbzGXmL09tPKNxL97DuLh8L5R0h6v44brKpnqmDq87fUBTpl6/AmOWLtq0Lbts4qjEWVaIR6YInvILhquV3RehyrFkEH/JWTq9ySpRLB+2O7/jWeidrKDyvOdW3wMl53Hwquy3u2MSnWW+qlhHVFbQYxvxyc2JIUKJB2h/zCuSqPOEYHU4DWmb8uO2x2O3wn1qytSU62dPK4rSdmCTnJ4zmf8BGDicJheIEe7VFVZk8Nj7A/om3R7/kKjHJVNoEGowwSyf/0wA1qOM5D/u74kw63exddEhyutoCwcBNu04Z/o0ztZMz9CPAqV5iuM0ybdny6HU+Q5SYwVjMj39imasoDpxu7krSe56b2Oah4dQ2sUtYW3qAWSOAYb4/b3/G0vY+fC7Mj9lZAwnwcwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(508600001)(8936002)(1076003)(6916009)(316002)(83380400001)(4326008)(36756003)(8676002)(6486002)(6512007)(66556008)(5660300002)(82960400001)(38100700002)(38070700005)(122000001)(66946007)(6506007)(66446008)(71200400001)(66476007)(2906002)(91956017)(76116006)(64756008)(26005)(186003)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Oii2XA9IRjq+8dMqC6bCkwbou7Lr82fX3FOXFIg2qK0bVZPzKv8fY0nwNj?=
 =?iso-8859-1?Q?jTQabjFGExB/vffSPTED7BzuS3wJrN6iE8JJxl91G8+M6PgJtlfqUc0EfW?=
 =?iso-8859-1?Q?ui2yGKvYzpgKNcka8Xhve1r8PCl7ZP1QoJxytq6be1giaWfNxSG+hbnj3r?=
 =?iso-8859-1?Q?/f113pqBSHIHRz/L6UpyNVJdUE9K1jmBzXXyIQyUWsxEcC8Q2gQGvqgesQ?=
 =?iso-8859-1?Q?/x9FvX11nBn7KWAjROv44eHx+d8Dxe8M+plLjObueC+e3S46yVxa//fV7E?=
 =?iso-8859-1?Q?0/q0Q0dR7CTejxl4RlRgT0kjvpnFsP1XWPDJRoQrXsoH5itbdyYjuc0K/t?=
 =?iso-8859-1?Q?SapT5DkCQxAhH/HSS5Bc0x49gf/E/YvKLKKz7nEkfCbshhjdKfIL6f1eGm?=
 =?iso-8859-1?Q?h9KLuOOG3s9dxElzCBRVg19USZEh8tSNg36eLMHEDKDTyeDF4OJY6ScM7a?=
 =?iso-8859-1?Q?YehjvOZkefsOEtxhxwEJB/6WSb9dbDsNgUEYMyoSYUaGcdcWTdAKdpQnro?=
 =?iso-8859-1?Q?eTVLebQ33ay53xAfLkqmEjuyzL8374Nw1tKauHDRIHeTKqfjQWB+LHSk+U?=
 =?iso-8859-1?Q?ZV6JSsNAM2TUJbfLLEczEYApHtPoFDtV6UpT0eL10HCDvFPsBiuRlpyKS4?=
 =?iso-8859-1?Q?XYbwaIirMsInMIWlgucmxcO+S1p2TgUWsJTHU5999zkboVEYO7YGcERE20?=
 =?iso-8859-1?Q?UIcg0Z0A4ce8CkpbhmX/OyBpUYyqu9qXgJsIUy0WLztLTmtrcFunb3m5kN?=
 =?iso-8859-1?Q?dfrt4JL8MBHp9OrgkGgYt33m1SB51XqqxgmUpZRsnivSFLgqrb7CtypYFo?=
 =?iso-8859-1?Q?0ONXSdezEmrB5PN+oQXG3dL5thHbuUv959tKdThklLWxq8ZKeKxk3DCFY1?=
 =?iso-8859-1?Q?oyxMJqafi2qq2Q+WIFhwRncBc9lOyn2waFMJbYNTUijbSWCnciECA9PeJ/?=
 =?iso-8859-1?Q?fvrQW0RIPXdzzd2Ys+2lJQuaOhGwLHhw/e+MwHzz7ENfDQIJt0aFBVTija?=
 =?iso-8859-1?Q?yqqgLCUJfKS08deRxVXoHGeyYd5JqL3FvRILHRYAhoJdn2TyTasScvrO5O?=
 =?iso-8859-1?Q?pa5W94wglQkoTgYgS5SleDVOd5bCMiPZRNdBgyYg7A+TYr44jcXNKVJZV7?=
 =?iso-8859-1?Q?EqeBTvRj5p8eiuIYigxvH/T87cqlyVr7gxM6XaytdwZO9imofHBTQ6/xVV?=
 =?iso-8859-1?Q?LiUX7RwyzqquX5/yp/bG80Ovy9If00ZzXVf7tyWweJlqfYSOKpQ4ucgJyE?=
 =?iso-8859-1?Q?O70Xu1ChZISw2hq0sW+dyIHQS4OeRnIxF4LNELPt31Rg2NvwyrwIalQPK5?=
 =?iso-8859-1?Q?WEnIVs2wJWD/2ALueAdhnTmrqkVTEtvnQrXd3jf55n31X8S5BvbM8o5/f5?=
 =?iso-8859-1?Q?194Jdjjq954Oszaa1z+bQ1d3gazezV5Y802ae+PDKNfmxW9PuBa4sb1/0l?=
 =?iso-8859-1?Q?QXvOE8svoi8UvXVZNQhv277rj6BVztpcAnDgMKMMXbrGRR7iV4Vyi/R9P+?=
 =?iso-8859-1?Q?SYNPxJn/ZLAWpcmPpP+MD8xe1YEmvCCANlg//fC3teH7YodYxgF8uBIOiS?=
 =?iso-8859-1?Q?jRKt732CeSL4dn7+RM4zzehN/5sxPqEkVHnERWT0DNnvXpk1MQC/eyFfJb?=
 =?iso-8859-1?Q?7O89MkvTQJ12N44cspETpR+LZIgZBqg8bbuSjxqQ/B1P+zk3/XyrnO3qgo?=
 =?iso-8859-1?Q?VpIdv9JcRlR2658SgJg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37689fc6-3581-4174-c354-08d9a3da0934
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:30.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZIMzYmKlSU5p/1yvEBrEMK/jJrMeG8OMxh6CoODBHm7Z4Ejn7XUOcD7p3aZ0By/863F6gCsWDepDCcxFD9whSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7736
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The default priority (which is either 0 or the value set by "prio" and
"prioclass" options) is now saved in td->ioprio.

The simplest thing is therefore to unconditionally set the async IO
priority to td->ioprio in fio_ioring_prep(), and let fio_ioring_prio_prep()
only handle the case where cmdprio_percentage/cmdprio_bssplit is enabled.

Therefore, fio_ioring_prio_prep() doesn't need to care if prio/prioclass
was enabled or not, we can simply think that fio_ioring_prio_prep()
might "override" the default priority, whatever the default priority may
be.

Doing it this way also has the advantage that the prio_prep() function
in io_uring will now look identical to the prio_prep() function in
libaio.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/io_uring.c | 51 ++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 27a4a678..0e66398a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -338,6 +338,18 @@ static int fio_ioring_prep(struct thread_data *td, str=
uct io_u *io_u)
 			sqe->rw_flags |=3D RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |=3D RWF_NOWAIT;
+
+		/*
+		 * Since io_uring can have a submission context (sqthread_poll)
+		 * that is different from the process context, we cannot rely on
+		 * the IO priority set by ioprio_set() (option prio/prioclass)
+		 * to be inherited.
+		 * td->ioprio will have the value of the "default prio", so set
+		 * this unconditionally. This value might get overriden by
+		 * fio_ioring_prio_prep() if the option cmdprio_percentage or
+		 * cmdprio_bssplit is used.
+		 */
+		sqe->ioprio =3D td->ioprio;
 		sqe->off =3D io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio =3D 0;
@@ -456,29 +468,25 @@ static void fio_ioring_prio_prep(struct thread_data *=
td, struct io_u *io_u)
 		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio =3D cmdprio_value;
 		sqe->ioprio =3D cmdprio_value;
 		if (!td->ioprio || cmdprio_value < td->ioprio) {
 			/*
 			 * The async IO priority is higher (has a lower value)
-			 * than the priority set by "prio" and "prioclass"
-			 * options.
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
-	} else {
-		sqe->ioprio =3D td->ioprio;
-		if (cmdprio_value && td->ioprio && td->ioprio < cmdprio_value) {
-			/*
-			 * The IO will be executed with the priority set by
-			 * "prio" and "prioclass" options, and this priority
-			 * is higher (has a lower value) than the async IO
-			 * priority.
+			 * than the default priority (which is either 0 or the
+			 * value set by "prio" and "prioclass" options).
 			 */
 			io_u->flags |=3D IO_U_F_HIGH_PRIO;
 		}
+	} else if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default priority (which is
+		 * either 0 or the value set by "prio" and "prioclass options),
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
+		io_u->flags |=3D IO_U_F_HIGH_PRIO;
 	}
-
-	io_u->ioprio =3D sqe->ioprio;
 }
=20
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
@@ -820,7 +828,6 @@ static int fio_ioring_init(struct thread_data *td)
 	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	bool has_cmdprio =3D false;
 	int ret;
=20
 	/* sqthread submission requires registered files */
@@ -845,22 +852,12 @@ static int fio_ioring_init(struct thread_data *td)
=20
 	td->io_ops_data =3D ld;
=20
-	ret =3D fio_cmdprio_init(td, cmdprio, &has_cmdprio);
+	ret =3D fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
 	if (ret) {
 		td_verror(td, EINVAL, "fio_ioring_init");
 		return 1;
 	}
=20
-	/*
-	 * Since io_uring can have a submission context (sqthread_poll) that is
-	 * different from the process context, we cannot rely on the the IO
-	 * priority set by ioprio_set() (option prio/prioclass) to be inherited.
-	 * Therefore, we set the sqe->ioprio field when prio/prioclass is used.
-	 */
-	ld->use_cmdprio =3D has_cmdprio ||
-		fio_option_is_set(&td->o, ioprio_class) ||
-		fio_option_is_set(&td->o, ioprio);
-
 	return 0;
 }
=20
--=20
2.33.1
