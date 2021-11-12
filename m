Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE517C433EF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A403E60F51
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhKLJ5f (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:35 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31604 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbhKLJ5e (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710884; x=1668246884;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ParaEHs6zhl1IXhx/dbIhwmaUXvBhYDHtbEsXJxAESA=;
  b=NosA/RUFbzVJUE0Mxv+t3hKgQYX37yD/YIcET0kSU7W1lfZP2GuZi/vY
   MHzHluAtT4o5AE5yZHO7+bjBzqSmJmglhW4I6rZWPwdK5KvvU/ZC+ngph
   M89sblsI7XuPGF4pQi2uc48jqqVs3KbA8WwMM1JUX8gJWp8IE7tKmrxDB
   sSdDDx4JT+UM1UlVWsjeRGHxdJBMimK2y5jXRV0v9P6dHjIZeiIvDi+/n
   6tJ0tyuJjKZUuyjQsEXWF6WEkj7yJCUk/cRoTY8yKfh3vnDiccnl+BZZw
   8JupFe24MAAE2AelQ/SheIpfoTHIB/IdgWQb8/dkMUV08cO2ftkHn1Xli
   A==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360585"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EX8+6jNKCDyvRjjuGOWeLY3K1H3Yb3YXKkYE4jj/865463W6e2MhgAXLxORvj5xCRYQ8AIsuv52M2WuHkS00ng3/ptcsP682VqHYqpQwGuyNpSFd5yR7DSuK3JiJRVxGYeSU1sR2ygSWdt5MFYZKWpqvA45cUzkYFUo1YR7fCfjxV8ltjHloKcbP2qPt1Xe951Qnujk5XZ0KKQXgTKrfyY1HJIwnsvJKAXpTFfMyC/VAMpYiD1JfSZKLoJBMF45lkcAGcwafpUg1Cxny7EICKHPikGVbThS4L0mgUtPow0MZ9Jo57oH01udSG262PDn+nKbF8D9RtU9C0vucLjTykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDIEFVY2C4gBby3osVYvBbZS+/hIcI+am8jAE5WOVUY=;
 b=BliospM0ZXcxfy1OL2rjPSNnMc6tea/6uqHR6klFJA8DxzEjnqs6TNNw54FeKTB2mqdgGPLrCQs5Gxb/UY54YResqMhwZ2kAFP8lZs3giRfVYbLQ6fRe7dZg5SWJbcKbowLVkKZhK0iymeYDJn/qyG0EF7NojuQPj7oek9daiprWgNR2BzmFj2qZO+V4oUB6l6btBm2Ejok9oFbRaBBP0nlCcQ+ioF6U4QhW552zu2qwY4E1Z15XrXGMqN3MPbTai7le278Rjytbw4cGikSqIWpvBzZcHqjL/XTNeenLdbsI/fxS7Zl4KBJ2HFuznCeZXmzmfwc5yZnfqC3ob8JBJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDIEFVY2C4gBby3osVYvBbZS+/hIcI+am8jAE5WOVUY=;
 b=tCXEJAf1PKWIWvThqyby98HOqe1XHK9k1spD3zfZk90Nrb6Hm6D1Yz/4kIXrA+ndNTroB42Bd9LOE8Z7EwkZgvzbkssO65GwCUNzjgw5MAKrKDl3PwzvFLzHNkvJ4ndve3ms8OkUzGCyRsTwMmfN/qFg/+J7RGel2Mw3CGZtwxQ=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:42 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:42 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Thread-Topic: [PATCH v3 6/8] libaio,io_uring: move common cmdprio_prep() code
 to cmdprio
Thread-Index: AQHX16tQeop6scC9fkWbsskDNYN1rQ==
Date:   Fri, 12 Nov 2021 09:54:42 +0000
Message-ID: <20211112095428.158300-7-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 8e04a95b-c914-4736-88b7-08d9a5c27366
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB7433BC67E0796928D7C266F0F2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pql6UiJ4Yb8+hafeVEpKL7XGLrjFQnkScfSmwqa0/Lg5Os7+FHsHWVZ2hK76QoldN0yTrq/g0big+ozXPv+VHUCzyICMGFbgM7XcKm7AcmhlL3KAGFXJn/6FHHTUpMrF9NExNS5hkwUnvlzv/32VBzHwO4zcJwHSSdMlOf2GA7sZ0yZfnz6RGFT4HG2gzCCSBd0DbBtAyWgKHC5EMQrS6pVnp17WrqV3jjtnefPSR6Tc4w+5mh+2qpIy2r22samxBIdDXeSamCd2tNTiuKuHNwFr2oAH4fDL2ytcGlRc5fgMaHs3C/V9Xr4/+xRq2nJDnxwSARHVVCHQQ0inoMuj0F1edviUMcuIDl16Nacy1g6OBmyUG4dLPFnkcJJfZw6p8JPpXrGaDfw4tPQ+nUx8v/8qQFWE3m63sgrqbOZz0fuZeab8wHWpNp8Opo1rR3k7xSz6QusbZ4hxtCCRp7rIn/B3RAySS8y4Q7e5GHSRiUbBIIyC/aQTINOTY8PrrzSJMbBs/avImlgc6xxuG6VP43KXmzJQjvzQM9ar6DRiyhn5JaHp+D4B9hXYqe3GOhfgzO/QwoJxTqC1bFawsUESOWPOnxmElwTEBGetz3A9RSAZJP5o9/5NMLaig1GqjuFPRiKkc2cVVNkYCEbyj6fZ5XVDvSNwgr45W9i8b3oeZ9eaTn6bzQcNMeRtm9Yr726JF93dDz5FsBpIqvpPf8G2Iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?K1SuUnEYb1W8ukWVT6wPOQPDi1Xkc0n07yZOHHZephqPQKWAxW1qT7qfP7?=
 =?iso-8859-1?Q?1ZDWOJXav9nbrkpZSPDVkrwnmAJHG0kZHi8ZY6az9FpZPouv3YfS0jQsBW?=
 =?iso-8859-1?Q?tbljCrLvOBvOP4AEPIO8YNaQ1Om3C3HLmBTIkyTam3kajrqWC5CHajt02K?=
 =?iso-8859-1?Q?2Neg+K2eY1lUAW8mJb+I37pgjjgEsFo/0++7zEzTqWbg2Bw67vfjfPS0Nc?=
 =?iso-8859-1?Q?2XPMB7IFW9c6H9r1yKRltFIARX/cfDGzaHTUYDrN8dMAuowVHG1TV44jyQ?=
 =?iso-8859-1?Q?gluZ5v7Qr20C/cLfpVj3Pfdi2SB8TcrKPeV5plogmC/kqUNvwpJdFANjVp?=
 =?iso-8859-1?Q?32CPgS7rvszrgZJvlQJNDjvbZmOfsf1kRXVo2M0YaKVm1EcMcTeT+UXnzz?=
 =?iso-8859-1?Q?n0xL0mAnpgMIV8ZwIzEdygs0Z+diFZ1rqLBTcmQ/hUlSLp6jTeJpT05jD0?=
 =?iso-8859-1?Q?nAv7zhQgU3sDYIo7PaVulZMkfBHoWKL9g3hUb4/0pqmAXWllG0U0UWXq0q?=
 =?iso-8859-1?Q?zt9suFVnJbtbHYBRcOhkEHbvLDwzsX+w2DWYWkDlUymMs/N5iYumcNJhiU?=
 =?iso-8859-1?Q?qTP7J6fkIlan5GCP5Tg2cpyr7gEvT4V1VF7smkmnALHtvvNz6/k3hTNUCx?=
 =?iso-8859-1?Q?igR2FgR0R8loteN8df+dCb3iqOYcvq9D5oAANSIhDbQMgrvwMe1OR5aBep?=
 =?iso-8859-1?Q?4H15Wxv+2RTzNGHcrk1mGRW0I/jlk3IEZ8QWaUJDtUj4nOddswYovdDgYG?=
 =?iso-8859-1?Q?7Wu+38iDucAkC08R7nAJALMeLwrlWs+KX+ARx+tLDkVeMy0s5uG7rNXDKD?=
 =?iso-8859-1?Q?2YzZ4iV+rIhQYks5pVksjRTeQlJPLSNK6bZaBkjmP2nWD0oBLS7FCr3JiY?=
 =?iso-8859-1?Q?ppiKNiwfVD4McDJCcFQEmUfQU10ofRur3SK42QukMHmbKwYq5EV5lF6q1W?=
 =?iso-8859-1?Q?vpzEOrVE6KtyzrMRiylKmnq7Mt55aEjZISc/HcugK4gGgmeAfwCS5K5ib0?=
 =?iso-8859-1?Q?krwIna8+3+H1jgnyXKNOwlcLYuDuEye8xl/rZrifgTv+hyyOFKhrQrGhOk?=
 =?iso-8859-1?Q?QGQyCJS1BnhyIcH1pfOtR+Oyp3qno1jgy4WJL8NlMIpT0B1Tq7QlbAlph3?=
 =?iso-8859-1?Q?sY3OQQHyIYd+cwnu/FecEcD7gNxFpTRsXQzGdO/XocPPujxt0meNm+o6qm?=
 =?iso-8859-1?Q?/u98dywAnaNqVYUTA0viEFaISSw7gpulijjUW3+/4trPL+kXtpQahGCdj5?=
 =?iso-8859-1?Q?Yra4d1XY7Ti388npbIi2NHYgVxvx05mt7bk5AbYlHa3qDPNRxDdV4nk3it?=
 =?iso-8859-1?Q?bCcYJgJakrcDqnZ6JxYpWGwhlW5j9mB0rjsbYn2F/+a+g066Zol8jXKenJ?=
 =?iso-8859-1?Q?iCmGPH8sSLhuXZIDd2S+FXFGOoaWB/euYitWGK+VecjYEkz58l6wbN9la7?=
 =?iso-8859-1?Q?bvjZL2a8CrfIeFrbX9iHXIu/QcS3jFTLlXoWAY47EoHGoEgtrLuubPB19E?=
 =?iso-8859-1?Q?0eqgMC/xmEmc8frg8mrpx9+K7cSxAJQjmU8SQFkUmTSszMfY0gnn7Ul2mx?=
 =?iso-8859-1?Q?UJL8OCeNe7wQEAHsBPcX+4eY0DZvF+zJY7q9+Dtb0NX/MIteZUeiZD1V1P?=
 =?iso-8859-1?Q?laOJ5IlPQPardKI1AINlvPs8ZTPz6T8PPGH5Ph1rj0iikxXba3yddHzhh+?=
 =?iso-8859-1?Q?bg0RWLs6KBhFOshZQtk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e04a95b-c914-4736-88b7-08d9a5c27366
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:42.6848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PvbIgnqyRPdQbqHv1wL/FilP1HGwGLAEhQBucAZIgaJ9MrQzVj+Ca3Of6DGG1t8sVD5lEyfT5J+NXQCL/zUHkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Move common cmdprio_prep() code to cmdprio.c to avoid code duplication.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/cmdprio.c  | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 engines/cmdprio.h  |  3 ++-
 engines/io_uring.c | 34 ++++++---------------------------
 engines/libaio.c   | 28 +++++----------------------
 4 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 2c764e49..d36b6264 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -67,7 +67,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, con=
st char *input,
 	return ret;
 }
=20
-int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
+static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
 	unsigned int p =3D cmdprio->percentage[ddir];
@@ -89,6 +89,51 @@ int fio_cmdprio_percentage(struct cmdprio *cmdprio, stru=
ct io_u *io_u)
 	return 0;
 }
=20
+/**
+ * fio_cmdprio_set_ioprio - Set an io_u ioprio according to cmdprio option=
s
+ *
+ * Generates a random percentage value to determine if an io_u ioprio need=
s
+ * to be set. If the random percentage value is within the user specified
+ * percentage of I/Os that should use a cmdprio priority value (rather tha=
n
+ * the default priority), then this function updates the io_u with an iopr=
io
+ * value as defined by the cmdprio/cmdprio_class or cmdprio_bssplit option=
s.
+ *
+ * Return true if the io_u ioprio was changed and false otherwise.
+ */
+bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
+			    struct io_u *io_u)
+{
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int cmdprio_value =3D
+		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+
+	if (p && rand_between(&td->prio_state, 0, 99) < p) {
+		io_u->ioprio =3D cmdprio_value;
+		if (!td->ioprio || cmdprio_value < td->ioprio) {
+			/*
+			 * The async IO priority is higher (has a lower value)
+			 * than the default priority (which is either 0 or the
+			 * value set by "prio" and "prioclass" options).
+			 */
+			io_u->flags |=3D IO_U_F_HIGH_PRIO;
+		}
+		return true;
+	}
+
+	if (td->ioprio && td->ioprio < cmdprio_value) {
+		/*
+		 * The IO will be executed with the default priority (which is
+		 * either 0 or the value set by "prio" and "prioclass options),
+		 * and this priority is higher (has a lower value) than the
+		 * async IO priority.
+		 */
+		io_u->flags |=3D IO_U_F_HIGH_PRIO;
+	}
+
+	return false;
+}
+
 int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
 		     bool *has_cmdprio)
 {
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index d3265741..732b087e 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -22,7 +22,8 @@ struct cmdprio {
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
 			      struct cmdprio *cmdprio);
=20
-int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
+bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
+			    struct io_u *io_u);
=20
 int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
 		     bool *has_cmdprio);
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 0568b8f7..68c33113 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -456,37 +456,15 @@ static int fio_ioring_getevents(struct thread_data *t=
d, unsigned int min,
 	return r < 0 ? r : events;
 }
=20
-static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
+static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
+					   struct io_u *io_u)
 {
-	struct ioring_options *o =3D td->eo;
 	struct ioring_data *ld =3D td->io_ops_data;
-	struct io_uring_sqe *sqe =3D &ld->sqes[io_u->index];
+	struct ioring_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
-	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio =3D cmdprio_value;
-		sqe->ioprio =3D cmdprio_value;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default priority (which is either 0 or the
-			 * value set by "prio" and "prioclass" options).
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
-	} else if (td->ioprio && td->ioprio < cmdprio_value) {
-		/*
-		 * The IO will be executed with the default priority (which is
-		 * either 0 or the value set by "prio" and "prioclass options),
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
-		 */
-		io_u->flags |=3D IO_U_F_HIGH_PRIO;
-	}
+
+	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
+		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
 }
=20
 static enum fio_q_status fio_ioring_queue(struct thread_data *td,
diff --git a/engines/libaio.c b/engines/libaio.c
index 9c14dd88..dc6ad08e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -205,33 +205,15 @@ static int fio_libaio_prep(struct thread_data *td, st=
ruct io_u *io_u)
 	return 0;
 }
=20
-static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *i=
o_u)
+static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
+					   struct io_u *io_u)
 {
 	struct libaio_options *o =3D td->eo;
 	struct cmdprio *cmdprio =3D &o->cmdprio;
-	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
-	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
-
-	if (p && rand_between(&td->prio_state, 0, 99) < p) {
-		io_u->ioprio =3D cmdprio_value;
-		io_u->iocb.aio_reqprio =3D cmdprio_value;
+
+	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
+		io_u->iocb.aio_reqprio =3D io_u->ioprio;
 		io_u->iocb.u.c.flags |=3D IOCB_FLAG_IOPRIO;
-		if (!td->ioprio || cmdprio_value < td->ioprio) {
-			/*
-			 * The async IO priority is higher (has a lower value)
-			 * than the default context priority.
-			 */
-			io_u->flags |=3D IO_U_F_HIGH_PRIO;
-		}
-	} else if (td->ioprio && td->ioprio < cmdprio_value) {
-		/*
-		 * The IO will be executed with the default context priority,
-		 * and this priority is higher (has a lower value) than the
-		 * async IO priority.
-		 */
-		io_u->flags |=3D IO_U_F_HIGH_PRIO;
 	}
 }
=20
--=20
2.33.1
