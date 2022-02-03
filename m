Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B9DC433FE
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353774AbiBCTcU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiBCTcQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916737; x=1675452737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gRO64TEjBBGdGXE0K6xDNJqDJRtLfNJvDHqCZ02CjXY=;
  b=ehZzYsUiFj8QVkw6owqpJuJBapoR7+dPDwIFZylm4Np1PrPMOv4pMhqO
   zWRs1SKmBTNi/QMnJmSFNvYZWsJ9ELqmYge/+8+bwuw8rezXml5418OO7
   bW+8EU8Xe25N2pIIvUe5mlxOV+jJXv8S1wDEQ4NhRzmFhI0L1//iaE8HA
   /UN3fyhqSWcK7IQfDLotQfcbIktiMqGDCG0jNRZbn3Ae16X6e74TrWI/D
   NXTA275Wpr7rHnGb6YVsX7TE0Fhv7ExYHzuCMBaUb6W45diInWAR14ewE
   nUIdMEmuk3rj3I1IiEBg8lVu5pzxOHBoSGq/h6CmM6RWV2zJ/AjJUMr0v
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095710"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BazbUHkbnqpx4wbrIcknmt3tnb1quXwBEteNMAT3hXCVqb4Ks6ItBxUKBH9SL8YNCwhJ+hziaP2+XuZSCessAPdnshiRvwNQkzyh8kgfV/a9aVb5L1x6JPHFovJSRCymRp5iY5/lyhIjhK9SAsp6IUR4Ks9bbHlYot0Efx7vO5ZXK7ktu6HOa+2dNRQ3VR4JOyalmdf7tFumk4rqdseM3cJbUwE9b9HhRUrbrmJCeNZaaDqnpVwYZXyeGc33OSXjLug4n07jWuGDPCd3xl40esBY86PI8gVdRyGvBfuTJbPRv7Rs9Xs38qaz1m3DfrmsRoNf0mfofeNny+YmT+dGlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ADDbve2kYkV4rIkh1dQg4g8yWB3WKNm6htbrFfzdtI=;
 b=KI3pGnof+cbodRMY1FNbzO9wXX8lRRrH49LR7ED0PTYhNOJyzK41VcFXfbuVYBrlO5jSu+pqXq+AtU1aEReMJziIqcpfOka/sdn4VsZKoQS6UqVOudNhH7ikA7hZPjNNP477IZRuenzDJo4sK7HlLiqBWe8BoLaNXkLFuRqqlC511chCPUOG3NQvmy8alrw3nh758LZJTPygyRZdpycYt/q+GkM5dW+WGquMNZMCnmJU3Wmn/hiCVTWTIy/g/w3EevSLo8rXQ1X5Wfed7xPLgumEYbupxNzJKyyse7RE35m6DOjDI+Dm99oWk+3KYf2Mku+oiZysMuWCPiWVtMRcVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ADDbve2kYkV4rIkh1dQg4g8yWB3WKNm6htbrFfzdtI=;
 b=aT/joiI9PnzWv4d+GkR+afg1VGj5F5CYyMha/jfELSnTMXDiwTo7H2uRb64NAL0chh4MwIVN4vUKQ0ioMP3aTIFYUHTahNlcSoZXjjBdApQbxZAveUwiymVW7N5VUojNaJbLN4Tlbir+vpA/emFKA1JUwZELtHR/kV487sA5YS8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:28 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 07/18] options: add a parsing function for an additional
 cmdprio_bssplit format
Thread-Topic: [PATCH v2 07/18] options: add a parsing function for an
 additional cmdprio_bssplit format
Thread-Index: AQHYGTQ3VDpxMn7OjkKinkq4sCEZkQ==
Date:   Thu, 3 Feb 2022 19:28:27 +0000
Message-ID: <20220203192814.18552-8-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 7f6289a5-27af-4d8e-e07e-08d9e74b5b2a
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB463272E81605634BA266B4E7F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xRbGCO8+wXBJuRKgzovkvGXCnCC6SljjpxABBNspCZUHNE0FLOBSlLuuIF+2JaaCqGd2iKzzj2PUN0v4Ov9C2xKQprU447Dt7aUpkndnJyarrubUlUhO73Lt7zUB+a421G/ee6zEQlVY2MdFg7GydmM3LljKR7aEwYuP0qzfCHYNDp3kuJSI8UJdlazQx1r+pExcr5pKDdOlZ3lZSOVgb/uoJw8eGAzZ0Vg51UIniPls5Led1YaogvKZIrQQHhTbc2qfbD2ATahXApYc+D5RXT6hQPytGwqm171ojgzNBl0iUYfYWzWdM1hNJFQ53YG8yZJz+MNzDz8U7iPVDjtGrN0iqCExVQHGt+utAd4ayHOaVmxk9Dx68LnGpw1KCZiZaIJS5uteKdqF980FljVeXpqGqtKy8VQJ1klMU3qUtEj6JFx3ihxMOeIZ2a0qp7LcW6vDlvK8NoHOVn2CYs9c6jHqRiF5s8C1sOGMCOjyMWUnzOKFjVAoX4jEU8JCpRB3LRWCPh6WtufbnFZjz+5HK0iDor3q3d15IYtEtFf/3kS57gl5IX3h150wVYxLXHb+FdHm1nnvdS0WSz1P94lUAEOjgfOSG8QhHQvGXKugfyqS3zWwq11vCjD9oVcF12fyfXHtok0p7ANxiPAPSSXC+NAK6g6cjFi+YsRxJrNZuI1d5n2flUbZYek0J3g3XAjJza5y1A/vNuytDauXxFN8OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?e1IYgWjPmYYkmANYDjk8oewyW2PuAYM3w6ZetA60CY5+M6/W4BYe1e21oi?=
 =?iso-8859-1?Q?zo8b7Lin4EQQ+Pp8QkXqjEXFENLWAd95se3hYye2yAXQeMdGQlbi1NT/IC?=
 =?iso-8859-1?Q?IXqThSkzJuKomqa/cdnoKuGwQ9NW2gWd1R/LhfOadO8MK/Yt4bruE29/LR?=
 =?iso-8859-1?Q?RHT4ukvKtuaNJ3+vW0o3418fXXOtrKdMdiykIWuFLNbf5YzqhthAQ14IDR?=
 =?iso-8859-1?Q?UjUyEIw/yLBzPullnLT3ZWgIcdQsGOrzouQyqGOvbk6kjoiBhvS27SIW41?=
 =?iso-8859-1?Q?ZrbXCGw4vBqUYcEtlGx5lp9yW5FR3KQNJ25pW3zLmxuudV8NXlWfgXunni?=
 =?iso-8859-1?Q?81u/Rat/rabtRUXbfD6DauW/OsCEd81F9miJL7M2cpYTgNuDBXcfM44RRk?=
 =?iso-8859-1?Q?nHMFIvsXRKZBvjm68lwbCCPL5ZNLOqbgfMZR4mwyyKbzgDSzo9IC2VFC3s?=
 =?iso-8859-1?Q?awVqEEP3526v+VO1uVbmw59jQrPrtJYdYaKcLyCJTApykMt+rOT2cPAqDS?=
 =?iso-8859-1?Q?vfklj0fBJ6P5qKlyo/EwmdR0X3Ajfhq4oGPCdPMFAQqml+YYcqmwdF+TkE?=
 =?iso-8859-1?Q?pBWLIXHBtNZQ0qme9i+avThyeLqBlUr0v4WW2pNU5TFQtU8eHEFzAmwCOj?=
 =?iso-8859-1?Q?vc+cGuXKws+XdbLXRRh0eP36AvOtO+caNWzkd+/XvuHZ2M5xQQh/V/fVvc?=
 =?iso-8859-1?Q?CUdUZ+8J4EHAqqTeKeMAU4m8YUFVDioN2U9QUNE1ErUM6Kd+PLOGm/XRST?=
 =?iso-8859-1?Q?e8BFp8CT9r7G+QYyy5tKJMl+0J/eER5YIVZ48oKi4Jnukw55n9dZyysx0r?=
 =?iso-8859-1?Q?dHvrREESqOGJdb6++VIyLktNESw2FEwANOjC60AdtNEQxQa7EBp7JdJL+g?=
 =?iso-8859-1?Q?Gdb0FmEo/tWj9VPQivRi89Dnorig85nJsc5AmYsPxpa9T0TiapEiaGl7jv?=
 =?iso-8859-1?Q?vh/1JH/Py0EXLq+3Ldp419S1cv6Iq4Ge1Abul51Wu1ITIgR3msvQVfD7t1?=
 =?iso-8859-1?Q?x6d45H2Hiqufm5/xUByxbnAdNhhnSyEYbm+Z2DlWp2ew/+biGFQLbpVtZ7?=
 =?iso-8859-1?Q?BXLeHvzbmFWswrzFvdGsMQfoJX1bD3ULfio0l8cjtSTEc14PIJvdnAlB2m?=
 =?iso-8859-1?Q?RJLnFBN4H2Flq/YCMb30tezUQz4hAKpkzD67tp0SjKJHjqxi2ZTWZyBOu5?=
 =?iso-8859-1?Q?MSxcLfZK3OgjKQUnDG+RIFypo/LUCXHDH/359gNrtpsWrPXQeqohZjsu0/?=
 =?iso-8859-1?Q?GZCcg5XSgFPwnXJLb3HtQxjAoojMWhh43DcXbAogXoqDXaukA88PCHjPV+?=
 =?iso-8859-1?Q?qe+e244KmYnq5iVoGRVStecucyMoNlGIqkMwgyG58wQ1zV1JFiphxSNlR6?=
 =?iso-8859-1?Q?2ZH9ry8tboSUsbS1iKELBx9rfTYDVFz+Z/0R2kPCZ1fPZhJIsjfTMA4FJ3?=
 =?iso-8859-1?Q?XTkqp4dPR+MHuAmwIQWxDIneSnbXKbdcPKEUmx9Lw9cTje3kuy3H5wGavV?=
 =?iso-8859-1?Q?ReCuv/idQ3/1Q+1YJLJVpoKKa5XDbsa2Ke3A318BDPb3zuFKZrjdxqN4IV?=
 =?iso-8859-1?Q?5J8FOUc26zwSgVjK9aBg3cOzSpmU5XVJmgfZjA8mqNOEVc8O7+kl2JrMt+?=
 =?iso-8859-1?Q?RZMEKexNeUKDNDwagru1DDrMKxFJEgRV0A622CnMTMZyaIWcJN++Lb2VUh?=
 =?iso-8859-1?Q?2IvUo9JhzCwwTJSdNs8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6289a5-27af-4d8e-e07e-08d9e74b5b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:27.3832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G8iprzx/eUvVEWkUK0Pckc0w0mCWIa69wrk8oN/UJzLbSMOwdar4Obgs4w4QhGtIFOjkfKiTpW42E04Sl2XtpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
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
 options.c        | 122 +++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h |  10 ++++
 2 files changed, 132 insertions(+)

diff --git a/options.c b/options.c
index 102bcf56..dcf5e09f 100644
--- a/options.c
+++ b/options.c
@@ -278,6 +278,128 @@ static int str_bssplit_cb(void *data, const char *inp=
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
+		class =3D min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
+		level =3D min(level, (unsigned int) IOPRIO_MAX_PRIO);
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
