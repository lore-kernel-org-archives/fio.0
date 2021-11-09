Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0656C433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D8161038
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhKIXl0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:26 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26631 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhKIXlW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501117; x=1668037117;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tuft5N//uoPUa4kAHSZC+vTLDWjcBLrB7fR+6yMks9o=;
  b=MfRGGNgsXncRpeuxRoEp7bCH0BsbN44f0J5wycvbDOlE+tM6MNcSkN5T
   B06CLMXiO+i1ZljmJEpCTRVfIL3U8lTV/Tw1TsYEkMnohsLBYiwv7olyg
   NG2tTF7WsdmhORxNeC5W3ISs2txbjgYWprvXm3e8lFAAMNeWk8FT0NP2b
   9QnWj5ACGeFUU8UxArVLSjuN5uPV68hJ1XkPnydhnm3k03HTaXpofm4Nc
   tNJbN1Ulut4qJxcHg6TGjJ/Gc0z1raAmhcfbBcxwI3ds+vloLMedzHZ/S
   fUM6lEL/2dmvbYi42ZFlchxBBPJM0RuMNPHE9AYZdhzsVaUUthDgBUgcH
   w==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="186161349"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DM/AqklvrVnDV0bpHCNbaEDkupOGL7wgmnAjWpCPmI+M7qUg5cGZouuvHt7+DR+GMJx1rltocxEdeG2wCiQn61aQF/tz32wgP3qAGBNv0dY3iWO1PscdAii3DbH70/L7J+oSdd25/jcOFA3URvba0oTMB3CjiHb2uOV3Gff2EvtqVUSC0pi4WjlC1DadImUYSgWW2RMV7XYC/Uma3g6YssYTSI6ckqdfC07RcMGS75hnElCBKwlRHuVzI+gqrN0H8DjeyDTgOXXzd+0Z1HoBpByLlARf7Qbf5nvnIxueK4hLl7Wj/L5nkax0pW6g+iUGuFloBEEpDmNWfKfB4CW8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HP9YWdsDcPQ2qLXmEDABt7R97jBVZHlMHosqP/y+pps=;
 b=eSfT1OGKSLYoj8gBjsAfNUbEMQIr+f4SLRlawnECEtCgp4O0i9LLbUNue9fIHSu5G/Kw4Xmwvsk5tGiFdl6QhoXp1Qxn6jA/aKAPWsprJbfg/drGqDx0vj8rrCljiSh8VV5NMlV5naTH0L6QLzNf/ujqyJf/XZyoq14pDTWyvXuCYdqxusVseK9gYU42ds8qIvoSf/Ts2R02fmAWUp3zDHh3cL4rAcFDpWuKeBH+Hh7KruJc1KnpZP9q4fWuLXpwJ1N+cKHFqcRtnhfTRlOf1pWB/GC9W8XkVq4noe7g+MXAcDBlLdkWjkcYFBYyMJU6ZkB2m0HvMc2gSaEQ8fZLSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HP9YWdsDcPQ2qLXmEDABt7R97jBVZHlMHosqP/y+pps=;
 b=HQjGZfBqPam1YkHCm/2DG2Yy/L+dNOhiwPhhqYybzus/iGxdddKYf+BFYskNYcrxyOg1exyQQfgDi5Y3SyfGqlD54eqqXWUlPY+NqjyfzO4v0gwMGjI4ONSw5c3N6MnhUr2HBqN5qDjsgSL2rCLnPFEGjExO3LT9+JnFm+UeGBQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7511.namprd04.prod.outlook.com (2603:10b6:510:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 23:38:32 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:32 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Topic: [PATCH v2 7/8] cmdprio: add mode to make the logic easier to
 reason about
Thread-Index: AQHX1cLnlDL1l4haLk+m4SMcObnW2w==
Date:   Tue, 9 Nov 2021 23:38:31 +0000
Message-ID: <20211109233804.164786-8-Niklas.Cassel@wdc.com>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d20f8b23-8fee-4591-e6e5-08d9a3da0a4c
x-ms-traffictypediagnostic: PH0PR04MB7511:
x-microsoft-antispam-prvs: <PH0PR04MB751157EDD0674BCDCD8E50FEF2929@PH0PR04MB7511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gvYPe63J1UcMAepadMNiAAesvMqQy+Wp7nEu4AHiCUiMhrH0PGZ8KOdHvm44Ghxn7hLocxY7F/dckBpC52fQh+W67V7l8Pwi2QHvAcyItLwS+v50atlQEf1YezDKwj+RIuilx26f2lHdbhyz8jK2Ked9LKkRvRDD9BwfWdpb0tBL/M+5kii4kGKiNu+BXQU1PO08ySmtPexFZeP8X0actVFJmqFqe++C6IS3+OdLq8i9cOlecUIV3qwPgdW/5v/ZF+/LyXwjXOBI+p/dQl+gDSVGRBxMIS2ByoS70gJbZg7D2PNIjBS6qkdb49jnSBd+xuqcRV9EJEeeL6+bKHV+LczEk8ol5TgmfFx05q5XbWvwQ4JRrUwrQxxsyvXbeBm1Tj0ezfLy9fx/T/+jhFqmhFo5repUaspnqKVkI05pKfHkDxN9SeEINW0qSFfxMLZd5qXH466h0ftSwtO3sChBNAWvtjHEHl67/KMXuoDEb+wnk19Frwa7YtSbVISVIe1+1zYkyn2lCtXVTXe5906BoZkiuOKQIIT0mqytalJX/YFESHQoQyn/Op5UPMfNB0tjI8najkaHzYYgEj6KLxDQ7cbbulgmXqI4PjO6QFW4oRp78IkEA+gk6P9WNEyYXv8Zx9T80/rU5NvrnNxcZiYrfUFHe3dHGzjWYh0JGwVxMWII1qScp830H35OshBeYdSjowbxF9sgct3VxKVBGPZraA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8936002)(122000001)(4326008)(38100700002)(36756003)(71200400001)(2616005)(66476007)(8676002)(6512007)(6916009)(5660300002)(86362001)(54906003)(316002)(82960400001)(64756008)(66556008)(91956017)(66446008)(6486002)(83380400001)(26005)(38070700005)(508600001)(66946007)(76116006)(6506007)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RqUVBqEl1J378fFh8Bou4z+bQnr8BKJBcc4NtyI2RCIn/Ueu/IlN7HYVSy?=
 =?iso-8859-1?Q?A9Zc36yluj/GIUTtq9xbyH9IvycUjf689ddkrs/3penytZQ46QjZETkbxP?=
 =?iso-8859-1?Q?M2eKUN+1JDg2w/J2UdjkOq4f735e4kWdAd+iGQ9Bfgf3PfyodtOljFNln+?=
 =?iso-8859-1?Q?2ATSwc4z/tIhnxuHontUmofp/7W2l+EABt0YGqQ6c/ANyAoXjCTMc3D04S?=
 =?iso-8859-1?Q?LNQWkM7lH0AAmZZ0kCJLv89/MPwHpVEUNgstst2yHZmQnjL1NtvxegTito?=
 =?iso-8859-1?Q?7URJcm55semlb2QuOmHIj2+SDrDg0R9zSQjxyDALNQSxh+urI/Y+GcOYy/?=
 =?iso-8859-1?Q?u+4a2NwrXxoiF02QNj9NYMNYiLpTwBlrI85+K6YiIsAr/pA91WjBrbxcI3?=
 =?iso-8859-1?Q?FhLvoty8j+0BnlAROiBYtvveEYcANp0lgBogbmYdgg31A1V4ybGnRVbxJU?=
 =?iso-8859-1?Q?TDVZQLFQwbUSh3qzkOw7tXhwgX2VyjNb5GpwGg3q3Q+nOI83LsuPL5d0Mu?=
 =?iso-8859-1?Q?r2VmUMdEEXB40uIMPyX9gS1IU4lylJ+TTe/mU5Ptb1aV2DbPzy4fA9e0eQ?=
 =?iso-8859-1?Q?PZSzDpwvZVFz6EEuO/NCiHWDbnGfdSjDaXjKM/Rau4TEIw/2FtOI2Ou5c4?=
 =?iso-8859-1?Q?9P4f8hzsSyWOiAu0ft73EYQdOlrGFCi2A7tllyCtvi/2fDZK4Qn/rHWOJo?=
 =?iso-8859-1?Q?hV9uf4CclgVsJo0hgcT+4htA61i3tD6iyTc0eFdJq1qHrmLsdnZDHH009E?=
 =?iso-8859-1?Q?TYCRAXbztyZHkS2ZHBE1ecQja/EU3VK/6uCZWa0q516NJb1esBIUj49eFU?=
 =?iso-8859-1?Q?w4s3rFuxMWkbHZWNgGK27jX1vA0jP06mnRiwutl0eTDXzVchc0FbQOt3FX?=
 =?iso-8859-1?Q?gficbsAjnzI+nA+aUcu/gq6yNsXOh4KctPZ7ttQ/iINER796iS+6FJpCB7?=
 =?iso-8859-1?Q?qhZTNS2F4tSA18FKGCBXV/qXenmtjHK2jPG7KcwMn948Ex1Y3/FC4rAhFP?=
 =?iso-8859-1?Q?si6RbPdggNuXF8Jkz4cLD4D+Rn17dAfh0h7e8IDDRxgky8har2VU5Kwzko?=
 =?iso-8859-1?Q?GPzzAgZ70yHZv2lJOut/WZL3j+YibBJ3UJAYaXekOrVKW5vtpYsHI2oAA4?=
 =?iso-8859-1?Q?jJaoD1ZCOyv2daLSje/D2nlLg2cMzoF2JuzYsrpmrRC8RUajwgb0vx8EJM?=
 =?iso-8859-1?Q?9AR7liER/UWO8PMM/T5vxkXu6ynQzxpR+ej5iKuxDg++n1PLsgHmfPne7q?=
 =?iso-8859-1?Q?Me4OVMnm2DY3T2mWMVH917gwt9kvELl5GKff+GkFfWDLEff5qoWYDdEx/g?=
 =?iso-8859-1?Q?JbPs6NbSg11zXz8hMBkxQ6yu7hyE5H0vDjhYnogVF9i1i/2cbZao/9KejL?=
 =?iso-8859-1?Q?R4m3aO99dBsLB/M+AfvKg5p9LLiO7+YaCFPPjPurasqMyzfediEYht0CNy?=
 =?iso-8859-1?Q?mfBotn5R3+PRi0QIoQ2Wuaz6MowYHjCd0clG+qM7+q/lvnTAGd9FUJ1kbb?=
 =?iso-8859-1?Q?TR2oBa4EGE5OAVXYKNxflQGyoPPBNJRifSyfXtwRwMFgqOysIIL+xC92HO?=
 =?iso-8859-1?Q?6aJW7LvSuufH33h7P+VCFQbtmJhO4Eqq7P0siO1f2CQSAjtsS3SypxV3pI?=
 =?iso-8859-1?Q?Yxovjv0Cau+qqOjFnB6P9k5hVx6q4IpzlAQ0FgNQ7HHVv1rrE/hzR51wrl?=
 =?iso-8859-1?Q?rnShBNdSlUHGm/iatms=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20f8b23-8fee-4591-e6e5-08d9a3da0a4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:31.9670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XU0wJAAaP6hiw457pDw0f+4kM0umvUf+Htpl5iI7HHyZQAYpD99fIIfAuTAZsCGYZmLlELXIFNVeAlo5UnNqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7511
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add a new field "mode", in order to know if we are determining IO
priorities according to cmdprio_percentage or to cmdprio_bssplit.

This makes the logic easier to reason about, and allows us to
remove the "use_cmdprio" variable from the ioengines themselves.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 engines/cmdprio.c  | 45 +++++++++++++++++++++++++++++----------------
 engines/cmdprio.h  | 10 ++++++++--
 engines/io_uring.c |  7 +++----
 engines/libaio.c   |  7 +++----
 4 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 9cad76b5..174bed7c 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -70,20 +70,19 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
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
+		assert(0);
 	}
=20
 	return 0;
@@ -99,10 +98,20 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, str=
uct cmdprio *cmdprio,
 			    struct io_u *io_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D fio_cmdprio_percentage(cmdprio, io_u);
+	unsigned int p;
 	unsigned int cmdprio_value =3D
 		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
=20
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE) {
+		/*
+		 * An I/O engine should never call this function if cmdprio
+		 * is not is use.
+		 */
+		assert(0);
+		return false;
+	}
+
+	p =3D fio_cmdprio_percentage(cmdprio, io_u);
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
 		io_u->ioprio =3D cmdprio_value;
 		if (!td->ioprio || cmdprio_value < td->ioprio) {
@@ -128,8 +137,7 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, str=
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
@@ -163,7 +171,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cm=
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
index 230f08a5..979d07d4 100644
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
