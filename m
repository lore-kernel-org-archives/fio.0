Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F76C433FE
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E070660F51
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhKLJ5h (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:37 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33518 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbhKLJ5g (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710885; x=1668246885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zs5+AkZ7yVcxcLO8CY3z0vPb1ZbrdQfMw/SreSiVb7o=;
  b=pvQMLATxCsqz4tkfRA2Z8AXdGDD08xmOPR4K1Byibb7zi2gU6clrPBhh
   iHOfthUMvjaWbmTQwh4Xq9OTPtKMjowgM1V1rB+KO/JGzomVwy/8fsW//
   eXW0zjikgNytonh1u067fiJRlLqfmQozAkYd9RMftgl+7GSJHHx11xbvR
   ycQzpsz3QjWs+Qz/vgVfOQeSboI78XesA1JJZmr7BkrKAR6cXs/dSVNZe
   wcgCwwKntY2P7f3IBb7+ZYGx7ICckhicWCBwxeJ5g8lCZCtTt23FqaHYE
   jcZBnOJYPCNEF2gzBwlFUnSF4FopD5mx8W+cFbW41Cj8+YFFJ5AJG+yul
   A==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="185430182"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXB6kDmXdndYMcP2OB05V5v9/f5ojj/Rg3WyqzvdHC2GMosxvt1533GRE3Mb9Z3rn7+CcJHhW8/kljcjQDHx2Wdc2z6i2VnTqID2ZHg/IAXAplEVaXckrjqgRjKT6O265JQcmodul9i6tYHtU5zPiz/Mg4Wzm+o1yif30PqYNOZlME45ZWhp0u4xvM5SfSQhVFqhFfPOLjW+yfFJDQ03Ik5Bf7rAyLud4pC2yVavcNYzzdCPVwUSIb8roS/N7pkqyFAzJem5LpAX1ynrgKbB5z9P41igzHCKPytRgdi3SraClrXpAlhYVkvVFQZSwFnpNosySZoX2DpLklfyTemo2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkNijvC9/pThZbMm814IC6yzA99adBjUfLSUDFgy9cc=;
 b=ODeG35fWsHRRb71lzZqT4ebBjhA3Y8xR9WSuTsULMQdUNXsfTR+yVcJXcTMnhECNREREtdtB3/Meh03EGUNJrusL6Ir0kDJHYHnzp6PDuh1GW69OTZrlOek7hmwHJqiG4pf7jpLGVDD+eTObfbwci9sLrWx5hNV9jUAz0zq31TFcOsRLkQu3bJE86wyumtyYkJITQTBA54iRM1F3F9YSQEzehqmRnUMZsTu4nEAPr261mznWsvt7KLFaXV5DdH3SBQMa0fswMNBgSR3D0U69WHcOS0ATPJ45f/pfr2ChWqLHcJBgSs2cycfdce45YBYUFpo8cvwQ/6VcBWXoRsUX5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkNijvC9/pThZbMm814IC6yzA99adBjUfLSUDFgy9cc=;
 b=r+KTLkoN24we1qSyE7Eqmfa4u4OnvDTNcPvAOZ7xYcHNCkHnWRco0F0xvBRIYQzMu0KS4KxVy1Ml2/vMq7Jr0iHBDXSeROIhRV5cryK6Vy7S4Swe0fzS41maI7wjIzh16oVfqls4tKc+MwOtSU3y90xaKZlzhIyct81mj+ZvD00=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:44 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:44 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 8/8] libaio,io_uring: make it possible to cleanup cmdprio
 malloced data
Thread-Topic: [PATCH v3 8/8] libaio,io_uring: make it possible to cleanup
 cmdprio malloced data
Thread-Index: AQHX16tRVmjwxnq/ZEK2CT5/5WdzEg==
Date:   Fri, 12 Nov 2021 09:54:44 +0000
Message-ID: <20211112095428.158300-9-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 893e891c-5a8f-44b8-d23a-08d9a5c2745a
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB74339A24F9B58C1614F2F08BF2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: in42yLdiAWqtrqRiCFXRoe5wNqONuCHaJ0E4XtroATmv+Mwh/OpjrRRZYzXjkCmf5JWemqaK8oHrRgry7IMeK+ETlGYHKtxav64pN2jNpen5G6d0OUhbOOfh72Pnhczhz0yz2wh1RXciW1xdVSXoW74nzBJ9JpL0B0jECoonksh+C78cx92Qk56Efgpty0g+Q3YOUBQiUT8BcvZeTY2qPS11avaryNjOJCUOLhWwS9iFORjeI330fHDO0Nwlj4kPsuFA1OyqM07U/Gxkl0UFLUnbsEzJw38WNtKiszsx4S8Azro6gSJxQk/L7GRx5RrGib0UYv3yohNP9n2Ge3mDsqaIuB/wHRHKbcpNl7aP+3U74uBWqo30PSrk5VUijlUw35c1Z+RM8IVk1IPkuLA+VBkAlxP5NaeBBqpx1HJILJAwrJIKNSIfoe5NcJxZG8J6R8nPsVP6CuXHCyWo/PJnC2BygM7oXejlKYjvLwpxr4W8WvalNP10Ek4+Fw9NAOZ+qGrUWnRCRPVpfc3rNjHwtw2SO1zKlpV3GqkcdZleutjJCHWhDF1rISchIM66XH2Dydskdk5h+FJBNGymaXnTwEhnZc6dqDl/LgxTBAquGYEFXeqb7XUcYA4ekYGDCYlOaO7TKC92ouOgnn3fsUXCzcDp8SCYSIvCiNApEGpi2NdEZ0W+Wyl2g2blsuH38OdfLyzC4qPGhfChvZPaSsVyzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(30864003)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lzlt+ZlRAvY2A7ssQM2NAUruaIb4H/qu5kXrl8KU1qh4ok7AhTC2hz13a3?=
 =?iso-8859-1?Q?imLbIk9ai9itqNWu5WHc3+S4XSzpwRpX2gjy8ySNwcUtZk1rZ3Bq0mkoPn?=
 =?iso-8859-1?Q?AcxXqlPsyNY8mK/VNRCRnn7Ko9wmvkaysYkV3TJ0UfbZ7jVAqnnHAFJMaY?=
 =?iso-8859-1?Q?Yg+U7+1S2POFU71Zq/jTQb58OnHbRqJSNN4ef89dGDgh7ASqwTMED1YgB2?=
 =?iso-8859-1?Q?zyJ6guuDs1gq0XDbmeQjirwbYwUMTzU86mz9QN/mxqJrEvLo+F8F0F1UOi?=
 =?iso-8859-1?Q?OeabAmu8sSdRZmK6pR4jYWbOd1BcCp0X306RZsXl3PpgHNhpGlpoI1JYyk?=
 =?iso-8859-1?Q?ex2qA4ztSSH0+h2cjeQo5veqrZ1FJWcdwkr0IzG1igeoTgbp/qMyFk8LYU?=
 =?iso-8859-1?Q?QZJlNhEq5Bv6OvygYlFnyLZlGE0efgICn3rLUqIdYyWSZj9plB3UhzDxzj?=
 =?iso-8859-1?Q?cD/2B6gS8n3cghqexfuLT4MjzGviJDPzhWR9anhBWj6IHsf/Tr3OS+GzZH?=
 =?iso-8859-1?Q?khND9FNh+CxgHlTKUQmaO0n6tOTFrf8kVX5BI8YXYgRxnunEBNjRKtZmW1?=
 =?iso-8859-1?Q?5fQgCZYXf6UyLs5dpJ67xap4SM6GfO4iLXCOe2ICrQV5fFiLv6ne9BqNis?=
 =?iso-8859-1?Q?eUjdr65bOGAeRBDlOi1TyVY/hs81lwKPck0maEkGwNOorKoCwI6Xvv4ijH?=
 =?iso-8859-1?Q?vOl/MOiHxVRc/2QpvYvCRlcAg8mCnbD5H7v4tQ/XJlYzg005cZ3kA9o4b9?=
 =?iso-8859-1?Q?ty5lvZOtS9oucflauMqMWfNsH2HJGiuMJChg5Wj+QeXx4IiKFQpz9CW5rd?=
 =?iso-8859-1?Q?RPWKA4Z28vPv03LEyNZ/lw3WBRiQetgWjz+B9Xk7Gdrffw73m/kXWTMscO?=
 =?iso-8859-1?Q?4o0LDlxtx2tJc3S+1ZF3/z380lXuaeiwDWstZ6NekLJmD9z+1hsSHH63fK?=
 =?iso-8859-1?Q?ygGOBZq1oZ7YFpO3UAhc+GY8lwMeW8FfZpTTA1UvmL0XRvAHngo0lgwG1Z?=
 =?iso-8859-1?Q?biQUWN9F82qmYxQFc8plRUYFAJqAwqwc/TJvEvD830whgue8L3KsvbInIE?=
 =?iso-8859-1?Q?HrFfvb+gYFzbYtxi0JUKgwPFRqapOTOI/ZOafmwXnpY8ETg59kti1TRwow?=
 =?iso-8859-1?Q?93Pr+GU6gkarWPa8lcVeL7fFqqfd0MCRN8WqVKTvvuDYuZ1Lo9MXI6TDNb?=
 =?iso-8859-1?Q?WLo12/VLqmbdqVbrnYrL8Y32ZvNhEu4YLP78NkRsgIFMUTMQHoT4Fsuxym?=
 =?iso-8859-1?Q?E2RZLxSrNJoj4mScRNktgpWp9tkh6TSc9mY14a3diQqhLB+BCxMIwu3sHL?=
 =?iso-8859-1?Q?jL/qKdt0mU6RA4O1Kuz1cXZfvIoq8dMnWktjzd5B19PxuaHg5kAIlp+3KT?=
 =?iso-8859-1?Q?2uRPVUh2fza4GCpyhUzbl86WgsEDygiVFardUCwYU65oaL12qXUJmgqYg7?=
 =?iso-8859-1?Q?hyUFpLZ1dLkpkKQXmTJOcIL03nLAwiolN1ZCPgptBuGgpc3nGhP1dJb0F9?=
 =?iso-8859-1?Q?Ynd+GYQ4NOderOHph0NhiaU9tueiGbpMsWKeHJ7MisheeGCJC7xb+++RFv?=
 =?iso-8859-1?Q?YubYNyspROpogosNvpwsx2Lbu5mMzM6VL45RCi3Ov7eLB3DSju4FRAKRSn?=
 =?iso-8859-1?Q?OOBCacB0W93JPF90OgiAuG8CSjXvCRxhBQACWm0sm5mehDM8OguTXAaOHn?=
 =?iso-8859-1?Q?2IohchvAzMkFHpgAAPpLROePPzHo9k/0D5wY8eEA?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 893e891c-5a8f-44b8-d23a-08d9a5c2745a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:44.2121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlFWQGOx+oYokxraCHVOeGQZfGLE3VGnbWwM0+fMqKAFrVNjtJN6p2feqZFhb8UagGdhFgXc069lqpKVPoHcHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The way that fio currently handles engine options:
options_free() will call free() only for options that have the type
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
 engines/cmdprio.c  | 114 ++++++++++++++++++++++++++++++++++-----------
 engines/cmdprio.h  |  15 ++++--
 engines/io_uring.c |  41 +++++++---------
 engines/libaio.c   |  43 +++++++----------
 4 files changed, 131 insertions(+), 82 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index 8c52dabd..92b752ae 100644
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
@@ -70,11 +63,12 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, c=
onst char *input,
 static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io=
_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
+	struct cmdprio_options *options =3D cmdprio->options;
 	int i;
=20
 	switch (cmdprio->mode) {
 	case CMDPRIO_MODE_PERC:
-		return cmdprio->percentage[ddir];
+		return options->percentage[ddir];
 	case CMDPRIO_MODE_BSSPLIT:
 		for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
 			if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
@@ -107,9 +101,10 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, st=
ruct cmdprio *cmdprio,
 			    struct io_u *io_u)
 {
 	enum fio_ddir ddir =3D io_u->ddir;
+	struct cmdprio_options *options =3D cmdprio->options;
 	unsigned int p;
 	unsigned int cmdprio_value =3D
-		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
+		ioprio_value(options->class[ddir], options->level[ddir]);
=20
 	p =3D fio_cmdprio_percentage(cmdprio, io_u);
 	if (p && rand_between(&td->prio_state, 0, 99) < p) {
@@ -138,30 +133,91 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, s=
truct cmdprio *cmdprio,
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
-	int i;
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
+static int fio_cmdprio_parse_and_gen(struct thread_data *td,
+				     struct cmdprio *cmdprio)
+{
+	struct cmdprio_options *options =3D cmdprio->options;
+	int i, ret;
+
+	switch (cmdprio->mode) {
+	case CMDPRIO_MODE_BSSPLIT:
+		ret =3D fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
+		break;
+	case CMDPRIO_MODE_PERC:
+		ret =3D 0;
+		break;
+	default:
+		assert(0);
+		return 1;
+	}
=20
 	/*
 	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
 	 * is not set, default to RT priority class.
 	 */
 	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_percentage =3D true;
-		}
-		if (cmdprio->bssplit_nr[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_bssplit =3D true;
+		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
+			if (!options->class[i])
+				options->class[i] =3D IOPRIO_CLASS_RT;
 		}
 	}
=20
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
+			has_cmdprio_percentage =3D true;
+	}
+
 	/*
 	 * Check for option conflicts
 	 */
@@ -179,5 +235,9 @@ int fio_cmdprio_init(struct thread_data *td, struct cmd=
prio *cmdprio)
 	else
 		cmdprio->mode =3D CMDPRIO_MODE_NONE;
=20
-	return 0;
+	/* Nothing left to do if cmdprio is not used */
+	if (cmdprio->mode =3D=3D CMDPRIO_MODE_NONE)
+		return 0;
+
+	return fio_cmdprio_parse_and_gen(td, cmdprio);
 }
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 7e4fcf6c..0c7bd6cf 100644
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
 bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdpri=
o,
 			    struct io_u *io_u);
=20
-int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
+void fio_cmdprio_cleanup(struct cmdprio *cmdprio);
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     struct cmdprio_options *options);
=20
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1f55ad17..8b8f35f1 100644
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
@@ -458,8 +451,7 @@ static inline void fio_ioring_cmdprio_prep(struct threa=
d_data *td,
 					   struct io_u *io_u)
 {
 	struct ioring_data *ld =3D td->io_ops_data;
-	struct ioring_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
+	struct cmdprio *cmdprio =3D &ld->cmdprio;
=20
 	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
 		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
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
index 53fe7428..9c278d06 100644
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
@@ -206,8 +199,8 @@ static int fio_libaio_prep(struct thread_data *td, stru=
ct io_u *io_u)
 static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
 					   struct io_u *io_u)
 {
-	struct libaio_options *o =3D td->eo;
-	struct cmdprio *cmdprio =3D &o->cmdprio;
+	struct libaio_data *ld =3D td->io_ops_data;
+	struct cmdprio *cmdprio =3D &ld->cmdprio;
=20
 	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
 		io_u->iocb.aio_reqprio =3D io_u->ioprio;
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
