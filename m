Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CA5C433FE
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351051AbiAaVNJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:09 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15171 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351002AbiAaVNI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663588; x=1675199588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SnwQhXxbW8boBL3NsHknPQAHNI3WUdnaplfZZzEsdlE=;
  b=WBKCsGl0iEhnTLVmr0kH8aPEQtf7ZQQwQIhvc47J6J5Rr1N+691chBwR
   B872nLOdqap7EnrijvVqJMI12Z4xVK+oxvWNR3fQs/grdVGNYPhCTHJKw
   L/6y+xAjq6mHiuLeUrt+w41KL4LtDnDgrQALLJWM+Qe5ZartUnKvyPTxZ
   hjvtoE4RwCsuZc6wPUdwoT8/7/ZSkcos2wasBFrSXYj3WommJaVB1CYo6
   mcliXL4omQnP7n4XIKZQk/26DY+5OoUmU0wPw2NkwkrR69S3zWwIuCRBE
   YqT6QfL/vek0FtTL2i76Rd7KjzmxbEeZtWaqbsYFDX3nZbeKqvO1PRV+s
   A==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720255"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArXQ5wekEG4TQqSlEVSqDOm3DkZO8gIdzLsZnbfBgVZNz2zvQKy1PRQL1dhNf8GLtiAsNXlt5CqADvOu319Zb0o91I16edteSHjCSjc+Wt2OeZJFdhskmU0xEoDuW8TsNIGh6vJ76xZp5hZCu+gDpfHGJ/pl5WbgyqNgAtYZfv39HhodRHQfHIWyUxSCUz0U4jtBjxuuCmdNT9blXJPgLgB4aZvqiYmhNMRLgw9hr63YKNOp769LGeZ7A7PY4+84DuN/4YBAl8gch2BBpADa/4uLFwHpqbHlXwx+6ZijDd+AquUBbzVSS2YFI5FCDQ7vGXPyQEuMvMEQ5HAorP3VOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HZRNjgOEDMEOMQYodi0QJ0M+3+JaBEz/hY2LtPZ/RU=;
 b=bso8AKQzp+v/Wvvo9tcV8Ri455yGgwXcI1tnMLBfLcLgbiIu9xbmjP7JdaGcFruAk/+RDjyLaRtRARIUPLSwvWkT1haFyHoFrH+eWGvzFxm9ewQcLg9bAu4bPreB+DvYr9qugd3ZwGw6NJpnEqAU7SwQXThPQfa5F8J0nqZtyegIECtdRxkCxhCrovx5gKTGClLWkDOb4lh3kMBlHXGXHqoZzg+tfUUcWYgjZp0EXKb86xk3IjRvD2FIn667kvcC41PW7pZIc345iXLI0eJ7g4ELdt4fMlTD4/FbJS5ukOW7Ll8VPSxchTVidu7GcxZvk0qJJa7RV2YAyWs3gQpFaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HZRNjgOEDMEOMQYodi0QJ0M+3+JaBEz/hY2LtPZ/RU=;
 b=J7LVTX0Yb7lpfkk3hrL5iRsm2p7NEN9ccbWYHVtnKLJuH8SduJP4t9oO1kj5oyU1QRJljWjBgipxYK61Ax7foaE1j8oU/repIhaYVjbs2cSOB/JfcctESJxPKYSxN1BoEKNhCLQ4Riw5WlxABwsc3/FuuZpCzTwDMDY8IFoF2DM=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:04 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:04 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 06/17] options: add a parsing function for an additional
 cmdprio_bssplit format
Thread-Topic: [PATCH 06/17] options: add a parsing function for an additional
 cmdprio_bssplit format
Thread-Index: AQHYFudV6Hc1sj36sUmglt3EEACJmA==
Date:   Mon, 31 Jan 2022 21:13:04 +0000
Message-ID: <20220131211249.106820-7-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2ddd0bc-3ba3-4dfd-1193-08d9e4fe78b2
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB75766D654020BF7F4BCCB495F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I2iYChYtT/3YIKj8kpa9wvidVh5hlCMyzngQpMobGAc970Hgzelib03yzJ7C/76oBKkijS6mAGYTvH/Cq+Z/a6WnZo+585F8ohmdyFUUaLnJj/eVyEFh+U9PoC3rk4Yb4qYVBDSSUHHPzC+/9R6K3AiKVI3WryEFDEvbsgvHgxdlpHvDUdKMiom7f5a3fKmxaNxPWWQ9LgoIXIswn8NgvCYV2b81Gjnrys32Ls5MTW0PWkw8gh17/waYQ2WQcHhvgpLCJaBpWXbNv8QAcIbvFo8m7iB9uWSXVsyrw8p9JF6mYKFPJx2OJldYtTOljUChLYI49+amdnWsoRxBEuvmTZ9mq+hir+HsfdVTBQKti10pfeNrUVlHmjmThi9s6dEzBxm0AYEvLYLtUmrdtNF0mZ7O9WRfELj9EP98j6tQHpy7TR4eU3SINSPMJjmzaoZHq++/3ETciBZNVjfD/KZQI8iqprYcdO+PlFic6yo6JISAj1V0/LQ1p5dkjQ9ajZmsI+OlhB4jZA76sP7OHAFbmwJ6hFa+h5vtWFBjGgVm7Bwwcnd5UmfPpR6Eewwsw3Nk+Y7E88SMZA0Ql0NqrHnXCeGp9iY8V2aVgf0oirR3AA0OhgggAszMsM+GcXuHZaC6psrm5MQ8YIFeyKpa007EnnXJSW0J32cwOEixoZtibVbAqDI7DxgoNWrl8PEMzRTwC4tzgaZE9c928uEnIwXY1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YgaGObO3oRFnCfWIV+zuqieDQBfp5+mlN44vSFB5UhssNSSJHnIkwqs6k/?=
 =?iso-8859-1?Q?RgQbqRu/ltwC34M5YA6/7HYdoYJQMwPHg0kKmbB4kbh28BqPOGjCnZkgRT?=
 =?iso-8859-1?Q?YnQYN83entIZzurEPfeo5au8+3sHom6Y9QXO3jJPHAG2QWKP//Df8m7C4M?=
 =?iso-8859-1?Q?h+1VNH5Q7e+Kkmpw+pqjFhht/egLkdcfretmvUbYMt3TT5tQb4/ofp8uFj?=
 =?iso-8859-1?Q?8QlYYjF2lzSkyo1ShU9yXwnGcM36DYQTf2qM/TauWeGJlJdSdnbwa5Mw/3?=
 =?iso-8859-1?Q?6Ygp6uiiBGMcIGpIKdijYdqEBO6zW+jZyi+i29gaKcWzU8MW6ms2anCX6t?=
 =?iso-8859-1?Q?TWXCww50tCr2k62OQAnZZkPzMT/5cA15BO8I61OMt1/M+Jcj3y2aUhoUaX?=
 =?iso-8859-1?Q?ssgNMIQIIyOt+UBGEu+SvXlDkdM89ROjULHQa067eO1Gk5nvF4VwWPfiF/?=
 =?iso-8859-1?Q?f1uL8PW0W1VbQNGJwbVD22ePz/vLj2HIhCiXzZCts+KupJhPMLScsS6FOW?=
 =?iso-8859-1?Q?6Ak+G05N9fua3dbJSAQDhPokJZABbSZWEV49xBu15l3hqmxqnUkXS6JqXo?=
 =?iso-8859-1?Q?n/nul61UFsZa9sELqy5BI3Dt2J0GqxjCxrYOftRHt4eVObFvsG6yQsB7MO?=
 =?iso-8859-1?Q?qlmdzrzEEFkpRq0K0uItkBWJdWl3VbTvxU0jGny01lfPzYmtKqk1wj2fLt?=
 =?iso-8859-1?Q?ftD+ssWUlqEX0FzE+OfllNBltKS2ztIciVSuzJ7QX/vUBpCBEyBg/N/eeh?=
 =?iso-8859-1?Q?PphEGb2zn6V1LFKFzmthWs0oGxtrN0Nd/1saQLaeWk5vP3Kw6elwbe2a0k?=
 =?iso-8859-1?Q?x9iGjHeKTaqsA5XERBpkQCSn0rn1F6Pl6vCE0rC8rjY7EdF1XP3NnpZlc7?=
 =?iso-8859-1?Q?cqTScsApkRcD5+DXFZLAsyNC96JxCryJlQ1Ke17OZCc4m/BSLON7ePgh4N?=
 =?iso-8859-1?Q?tEyB7TSP1UbS2ay/XijUBTTAF7fpta4lp+SwcpbQLGagd1VVYpTg2SoSgF?=
 =?iso-8859-1?Q?b7nwJKc/MFnVTS+lzEv2xGcVAHodjncf25AWiTpeKGrET/9mNGGwcwJSAl?=
 =?iso-8859-1?Q?O+cXveilch1dOUPJql82BsNapCWfKCcdZLQ5+Ct9X+g94FirTaDknBWgGx?=
 =?iso-8859-1?Q?4UKacbzFHswkkBTQTPSU88BYgU1EmAHXfuAvzlk5Wyumqgn8mM2fqI24UL?=
 =?iso-8859-1?Q?ihivsQndhcpqvWeXPclLsPwm8ydiRJbTDIZq4Pd4oXwbsifUeF2z+g57Eu?=
 =?iso-8859-1?Q?Kt/Mn7IdbkKgjmoFlTSjQlIxreD4n0FEz9CmGapeIhl0OlFK8vFtZueJk+?=
 =?iso-8859-1?Q?FUmKPoKCjcLwptvmOMvhgN8GwQqlBoOI5/UWsvw+oACq+E/B6UdsMSX2C0?=
 =?iso-8859-1?Q?QnZzcgyPQJ/ZN13hfaAoLK65Zu4eWZvgM57EjVsNXwP/N+mLlPW4BxOpVr?=
 =?iso-8859-1?Q?bSPI4D8KV5RQviTpyt8sDPYr84rSdyfZ1NfbdoeHjC2dJu/Pp+M+WiF4qq?=
 =?iso-8859-1?Q?j2GQCvJcGdF6cQ33aYwkezfnjkaY9mD138cOhxF3PpFci0yhb8M0vRFuWq?=
 =?iso-8859-1?Q?18qlYJT4i0/1M9l/Ga0rtcrofb6faDFyqK8D6qbQLY+Uv4Z2OZLa7TNehP?=
 =?iso-8859-1?Q?ifghlhvvUsHWfcy17m+tiMV2spaEj9B1eygTKmMQzRxjTcXLAccOJGYpc4?=
 =?iso-8859-1?Q?eXeJdYB5wVXc/MS8jQc+Qu6ZvdX/fmor5tR96YFC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ddd0bc-3ba3-4dfd-1193-08d9e4fe78b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:04.1942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2XAaPpvNY5ALXuzFyH4H9iZTibxk0Mx7m0RBywAHYCNWQfS/FCQneHvWuBpDsuFvyyyu4B9Sv0MMltJWWl2oBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The cmdprio_bssplit ioengine option for io_uring/libaio is currently parsed
using split_parse_ddir(). While this function works fine for parsing the
existing cmdprio_bssplit entry format, it forces every cmdprio_bssplit
entry to use the priority defined by cmdprio and cmdprio_class. This means
that there will only ever be at most two different priority values used in
the job.

To enable us to use more than two different priority values, add a new
parsing function, split_parse_prio_ddir(), that will support parsing the
existing cmdprio_bssplit entry format (blocksize/percentage), and a new
cmdprio_bssplit entry format (blocksize/percentage/prioclass/priolevel).

Since IO engines can be compiled as plugins, having the parse function in
options.c avoids potential problems with ioengines having different
versions of the same parsing function.

A follow up patch will change to the new parsing function.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 options.c        | 126 +++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h |  10 ++++
 2 files changed, 136 insertions(+)

diff --git a/options.c b/options.c
index 102bcf56..4f2ce0d0 100644
--- a/options.c
+++ b/options.c
@@ -278,6 +278,132 @@ static int str_bssplit_cb(void *data, const char *inp=
ut)
 	return ret;
 }
=20
+static int parse_cmdprio_bssplit_entry(struct thread_options *o,
+				       struct split_prio *entry, char *str)
+{
+	int matches =3D 0;
+	char *bs_str =3D NULL;
+	long long bs_val;
+	unsigned int perc =3D 0, class, level;
+
+	/*
+	 * valid entry formats:
+	 * bs/ - %s/ - set perc to 0, prio to -1.
+	 * bs/perc - %s/%u - set prio to -1.
+	 * bs/perc/class/level - %s/%u/%u/%u
+	 */
+	matches =3D sscanf(str, "%m[^/]/%u/%u/%u", &bs_str, &perc, &class, &level=
);
+	if (matches < 1) {
+		log_err("fio: invalid cmdprio_bssplit format\n");
+		return 1;
+	}
+
+	if (str_to_decimal(bs_str, &bs_val, 1, o, 0, 0)) {
+		log_err("fio: split conversion failed\n");
+		free(bs_str);
+		return 1;
+	}
+	free(bs_str);
+
+	entry->bs =3D bs_val;
+	entry->perc =3D min(perc, 100u);
+	entry->prio =3D -1;
+	switch (matches) {
+	case 1: /* bs/ case */
+	case 2: /* bs/perc case */
+		break;
+	case 4: /* bs/perc/class/level case */
+#ifdef FIO_HAVE_IOPRIO_CLASS
+		class =3D min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
+#endif
+#ifdef FIO_HAVE_IOPRIO
+		level =3D min(level, (unsigned int) IOPRIO_MAX_PRIO);
+#endif
+		entry->prio =3D ioprio_value(class, level);
+		break;
+	default:
+		log_err("fio: invalid cmdprio_bssplit format\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns a negative integer if the first argument should be before the s=
econd
+ * argument in the sorted list. A positive integer if the first argument s=
hould
+ * be after the second argument in the sorted list. A zero if they are equ=
al.
+ */
+static int fio_split_prio_cmp(const void *p1, const void *p2)
+{
+	const struct split_prio *tmp1 =3D p1;
+	const struct split_prio *tmp2 =3D p2;
+
+	if (tmp1->bs > tmp2->bs)
+		return 1;
+	if (tmp1->bs < tmp2->bs)
+		return -1;
+	return 0;
+}
+
+int split_parse_prio_ddir(struct thread_options *o, struct split_prio **en=
tries,
+			  int *nr_entries, char *str)
+{
+	struct split_prio *tmp_entries;
+	unsigned int nr_bssplits;
+	char *str_cpy, *p, *fname;
+
+	/* strsep modifies the string, dup it so that we can use strsep twice */
+	p =3D str_cpy =3D strdup(str);
+	if (!p)
+		return 1;
+
+	nr_bssplits =3D 0;
+	while ((fname =3D strsep(&str_cpy, ":")) !=3D NULL) {
+		if (!strlen(fname))
+			break;
+		nr_bssplits++;
+	}
+	free(p);
+
+	if (nr_bssplits > BSSPLIT_MAX) {
+		log_err("fio: too many cmdprio_bssplit entries\n");
+		return 1;
+	}
+
+	tmp_entries =3D calloc(nr_bssplits, sizeof(*tmp_entries));
+	if (!tmp_entries)
+		return 1;
+
+	nr_bssplits =3D 0;
+	while ((fname =3D strsep(&str, ":")) !=3D NULL) {
+		struct split_prio *entry;
+
+		if (!strlen(fname))
+			break;
+
+		entry =3D &tmp_entries[nr_bssplits];
+
+		if (parse_cmdprio_bssplit_entry(o, entry, fname)) {
+			log_err("fio: failed to parse cmdprio_bssplit entry\n");
+			free(tmp_entries);
+			return 1;
+		}
+
+		/* skip zero perc entries, they provide no useful information */
+		if (entry->perc)
+			nr_bssplits++;
+	}
+
+	qsort(tmp_entries, nr_bssplits, sizeof(*tmp_entries),
+	      fio_split_prio_cmp);
+
+	*entries =3D tmp_entries;
+	*nr_entries =3D nr_bssplits;
+
+	return 0;
+}
+
 static int str2error(char *str)
 {
 	const char *err[] =3D { "EPERM", "ENOENT", "ESRCH", "EINTR", "EIO",
diff --git a/thread_options.h b/thread_options.h
index 8f4c8a59..ace658b7 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -50,6 +50,12 @@ struct split {
 	unsigned long long val2[ZONESPLIT_MAX];
 };
=20
+struct split_prio {
+	uint64_t bs;
+	int32_t prio;
+	uint32_t perc;
+};
+
 struct bssplit {
 	uint64_t bs;
 	uint32_t perc;
@@ -702,4 +708,8 @@ extern int str_split_parse(struct thread_data *td, char=
 *str,
 extern int split_parse_ddir(struct thread_options *o, struct split *split,
 			    char *str, bool absolute, unsigned int max_splits);
=20
+extern int split_parse_prio_ddir(struct thread_options *o,
+				 struct split_prio **entries, int *nr_entries,
+				 char *str);
+
 #endif
--=20
2.34.1
