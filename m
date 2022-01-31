Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4CAC433EF
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358853AbiAaVNM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:12 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15176 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344367AbiAaVNI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663588; x=1675199588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OkKbdLD+ivNbnmD44At4CMvJWTSfhcUpcw8CgauJKg0=;
  b=YhprIY0PW/g9bmNwyDbMtZ71jlxwqkx+jHRL9bTxWUECk4VKdiVxK6Nn
   uGKh3oc+jSd8vtXz3kZPAMXTU6VcFwmavJWBVrvMUqLJGqQ+aKj83KQ6H
   ziBTlZBffh6cPZbZg1JIPBRPJ9XhndEUxF2SX2qbnN5Jty5yOZr8dPiMT
   mE//Fm0wA/Ed0E7rpcQfns8179WZk1QwttVhPIDfnZt8zz3p0RB7OdOFs
   r8ODqmrtx50PPOk9NzUiDXp3gufAMu6qXYtrA3bbB69aRIP3a4XEWKTEO
   wk/OfxFBxzpPobT8CqR6Cki/NA9OytushN+iYk6Do+gNzhS2tfRADJfr8
   A==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720258"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFYTJRoniSgrSHORqya9ssLip/IXHdEDrU2a9LBFKRuuIPvLBdKb/qVEBFVQ595AUB2PpWEr3TTH1RYygKizd3D1L4FKFVHp9vDIRPoH+nx515j0Y8Vbz9uAHWJd8X8jkFVzmtOpv+90odofbTQSRF43Yk+akXl8B66Bc7/QxihEIC7A18YnIScoKAZybu75cmCYEzKh2cSNTlJCdAZfiK9bQWS/TbGmzdwJAOCM3iYyeJijPZx9nQT+OcdICiJBdzaSVD9EQd6l4s4svgphsifWOKwA1/EyF02Su0YcZh8VV9huKb0uHcfgTNsZECUQXklPgUn6623Ndn8FjsUU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnvjS+5cZqEgTRc5Phk10SrYmlSxSpmcdNi5kjF40Pw=;
 b=ltNSzHxeO75xf42NjpC0JGaHZyj3IRmyotVead3U+H2wuHUkdyAR+unG8LGj9B6/giYOPaFHaRM+xQ6KKmG08MB9Rc5t3gUFtpPbetncVjlWPTadjHFPI3IhA82a8vwViu34REMMGoCH1cPFjoD8CQugwUzOgudkrIXSsEuQ05tlZhT9OCX9Nq8KDp24ms61YsK9E/AaSCv9T2B4TwPzFvpsfyZw6fY6xw3Z4nt6r06K46NYXxkaWSljo8A9bthY7sSsf81fmW59feRgfkxkDD2WF+48+QPpvMbvl6trrIcpeW+Er8HqcqjlVxQrkD55YH12s76sabkaeh6Dz0cD/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnvjS+5cZqEgTRc5Phk10SrYmlSxSpmcdNi5kjF40Pw=;
 b=STMHPQLhBIVPbek4fr3F5Wtr7Hx2iUd7M2RJtyC82AeQY4mViQyc90n93r8uohWRwRDNAByibqBN+MSx4DfqZD+QeY5prBhBxDLFa0tfdyCYIO6y45rBLog4NELQq6Ur8UFMJAfq5rOmsL38q+ijBeBKADvots+GQg1MWRaVaXQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:06 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:06 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 09/17] stat: use enum fio_ddir consistently
Thread-Topic: [PATCH 09/17] stat: use enum fio_ddir consistently
Thread-Index: AQHYFudX55LCtV/7j0aWU0eLrtDHvg==
Date:   Mon, 31 Jan 2022 21:13:06 +0000
Message-ID: <20220131211249.106820-10-Niklas.Cassel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 7262e324-dd83-4a31-90b3-08d9e4fe79ac
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB75761A3B0B5485972721A8A2F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HBn5uAgemGrUyVZJtCeyUQKJjBk540IWFdB4J4iPFrlVpBWLkzkh0croJ1CGUMyPygT3lu11J12m8iV4wBLP0kQbdEitEt3BnIa7HYY+M2dfF70ZwzNPgOs8hy5G4ynUTTT2ofKum/3q8iObzh+n7A64RnlAAJUi/Xr35NZXDHwQ+w8K6MqWUqlvLpsFaP+3SAEsxIaN8xm9lKeHbDsvbWO8atsAADq+RInAbFeVoUxWsRDfFjky9VCKKwoKDNMFBjNg7z47f1xm57HuKQZ5HBffQOajaYzeyK0FDtij3DcqH9KgpCWT87YmdWMlArY3YfVaOXYLlv90/QHTk6UmxnO0PL2uMF2WkFo3HfcgzIZEWs1wKzZrwaPwjYBBkhdRJLEGZJwscqYjF3DOopj3+CNvqqYz5WfUOIsLBFywC/1bQsJOUT8LQmXWKAD7B2c1FHqd3JO3I/CA4TzNfTYagHeSu7ON9kNuUMJ9KZv3DXPkUxKJvcppscTvuvVtH1tdZ1gKkeESi8Jd2n8lX0ziDuBIW4l8Qzn3FzA/kXn/2XBn9Z73spwHr/figAsyxqpTYVq6daxkVh/etO0thkbae3N59jDghqcl0OWd3DN8DI1hDp04KAQQWxPQzXMHFz8MfZUuKGR46UWofaj1Kgblo+8L03abLrW941kyPLqNIVdMfsg0wTmK6DA8X/nfSSc7mX63ARyF+O2Cclkvhgzecw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?29XXBLv9bTl5sgmkN1zC6tuRv53RXdz51V2C+pU+3rWNPCmEMB5jKZmDuy?=
 =?iso-8859-1?Q?5MwHsRHfKcpbL4ar/3HJ425YEdUkevuxLfdv6DuQbqTr7FAlI+brUgm+Bg?=
 =?iso-8859-1?Q?GYfwbWc9Jjlj8JH8hK44hAeN3FZfPtGxpO0SbrSUptcGGrhqNt45jLZrAV?=
 =?iso-8859-1?Q?A3CCQsmcyCZsCQy0o03u3sYxGjHQ6knAP97+p5sBoXJ6o6ociEhwHmBH1R?=
 =?iso-8859-1?Q?rOEy2u5WiMKgpZdfXc1LzxWC6SJuyavf8XAEC4NiYHdWfj9bsLQlq4tume?=
 =?iso-8859-1?Q?SLioVl2WKaJBJzXKPNcyRSBBsI3Vwt3bw6rpMTmNkZ4L35MqlbX+8A8jz4?=
 =?iso-8859-1?Q?qysaRqRB9oWgxzuKb9SdYfbt9GvnrCL4LNCI8jj3odigw9OlY10H940y83?=
 =?iso-8859-1?Q?IWdJXeA/9Jj3Up64ON29zsnrhN/WhXfyguA4xfj5rH7VN4s2aF+FLlUKNz?=
 =?iso-8859-1?Q?oOBtfeOs/vc8Jxs4hQyqxbInsiui2QSwXjaEVc774oAMLY0Np6yxKlTz5k?=
 =?iso-8859-1?Q?pH7bsBhn0noJWrc7jNnyCusuOI63KLG+soPJqiNzVzZ/0yKX86iWthAhaN?=
 =?iso-8859-1?Q?o9hofFOC4l6ANREvBhcoPsa56YEbzXUVLmGF7DJal/iGhrCkTXZAdrGZiE?=
 =?iso-8859-1?Q?CGd+aVXX4zaq+M0lsNFQif3vYi4XcvZ/nd7nqWrpVfL2QE2mJxl2DeOEIc?=
 =?iso-8859-1?Q?YRnHfav9A7D/jlbdn0MAhRW4H+IXgTgZVjj9WWtTYV7Sv9zI6bHkt333Yh?=
 =?iso-8859-1?Q?1Pt6H0qrFHp4FXiAJLmG4cBHc3yJDHF8rvjl2Xe2SIW5iYObOKayAGBW87?=
 =?iso-8859-1?Q?p+gZWisSqh5sPOpGjrkNnCnqQjL1smgBmJr7sHCzEJV2WY8iVrJKgAfcGR?=
 =?iso-8859-1?Q?dB71bcWS8VhCUm0M8Gl48kCFL4rnmj2KNwF+fkzzpxmMHom40F2P/xRtIn?=
 =?iso-8859-1?Q?z5kMvEwC1QCl7G76FFdXXPQBidigf0AjtEwTtaInxwogwvBDC3mRueOhKp?=
 =?iso-8859-1?Q?mfoM3ynAjbVzD5oOczrC6Ilrsq6N6e+gINMh2Ya+BSGSG/8/dNZigYCSvZ?=
 =?iso-8859-1?Q?b46EQZNUrpQI8wZ3/qMNhzlrjfM4sltgKPxFtIVJ9y8Z7DeLj9LZwC6l2e?=
 =?iso-8859-1?Q?lLW0q34bYAi+EqJvsQmDnyVMeCx05kQc1EEbCZ86hle4UNGEXCDrEuTVdK?=
 =?iso-8859-1?Q?qhRDGTSvR4yzZtmWIkRYDOLnZsORgUeTCrxnvBDvOqzpHC2+npO9ST8pBq?=
 =?iso-8859-1?Q?GKhpeztJHO/UfzhG8fjaYbf2XrVnBOv0LSGPjSsti6NYhnkAKRvWCzqsAI?=
 =?iso-8859-1?Q?NJ2s+9TqVFJL/zU3H075Hkftlp/CoQiJTHRdRbSZ1BtHwFxVqUQVo9su68?=
 =?iso-8859-1?Q?DzuqeA/vwcFUdf+NzqpQP78g8fwaEbF2Fx5/h3VvKCRJbaBUqHHIh2p6lY?=
 =?iso-8859-1?Q?ndVW5xWd2hCb5Sgeyzxc9hJcb78I6/ZL3nsoPNLcmmZ82Yz9SQoRAoK1+B?=
 =?iso-8859-1?Q?vi4WHbG6DMl0nHDxZ80gfVzod/HxC/m4x/0ftd9fMl21ADV9nMPhVPt1J6?=
 =?iso-8859-1?Q?RfOlR1uMvUZiXXRw+dIezH71e7TKfNK4mC2wPm+UiXj3Y+QP5JzGS0Y34k?=
 =?iso-8859-1?Q?ONfU/3rGtxHxU8Vtp3sUO3RrtKfxksmOP9jXsIxYOitP/cJICxzwsL09K1?=
 =?iso-8859-1?Q?sApoESzYM121AnZA+Tsv1APkzjDVYCgHeRJX+G6o?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7262e324-dd83-4a31-90b3-08d9e4fe79ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:06.2095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zBJnKLmY0oHYYDVThCxcal6kS5TPsgkfmth2tgXBQZ0tl0Yt0WA580zAefxSBFT4t8O9OukIkanLsfZJfVQ1vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Most functions in stat.c uses enum fio_ddir dir both as a parameter
and as a local variable in functions.

int ddir is used in a very few places.

Convert the int ddir uses to enum fio_ddir dir so that the code is
consistent.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/stat.c b/stat.c
index 9894ba7c..5aa6d588 100644
--- a/stat.c
+++ b/stat.c
@@ -491,7 +491,8 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts=
(struct thread_stat *ts)
 	return ts_lcl;
 }
=20
-static double convert_agg_kbytes_percent(struct group_run_stats *rs, int d=
dir, int mean)
+static double convert_agg_kbytes_percent(struct group_run_stats *rs,
+					 enum fio_ddir ddir, int mean)
 {
 	double p_of_agg =3D 100.0;
 	if (rs && rs->agg[ddir] > 1024) {
@@ -504,7 +505,7 @@ static double convert_agg_kbytes_percent(struct group_r=
un_stats *rs, int ddir, i
 }
=20
 static void show_ddir_status(struct group_run_stats *rs, struct thread_sta=
t *ts,
-			     int ddir, struct buf_output *out)
+			     enum fio_ddir ddir, struct buf_output *out)
 {
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
@@ -1251,8 +1252,9 @@ static void show_thread_status_normal(struct thread_s=
tat *ts,
 }
=20
 static void show_ddir_status_terse(struct thread_stat *ts,
-				   struct group_run_stats *rs, int ddir,
-				   int ver, struct buf_output *out)
+				   struct group_run_stats *rs,
+				   enum fio_ddir ddir, int ver,
+				   struct buf_output *out)
 {
 	unsigned long long min, max, minv, maxv, bw, iops;
 	unsigned long long *ovals =3D NULL;
@@ -1407,7 +1409,8 @@ static struct json_object *add_ddir_lat_json(struct t=
hread_stat *ts,
 }
=20
 static void add_ddir_status_json(struct thread_stat *ts,
-		struct group_run_stats *rs, int ddir, struct json_object *parent)
+				 struct group_run_stats *rs, enum fio_ddir ddir,
+				 struct json_object *parent)
 {
 	unsigned long long min, max;
 	unsigned long long bw_bytes, bw;
@@ -2353,7 +2356,7 @@ void __show_run_stats(void)
 	}
=20
 	for (i =3D 0; i < groupid + 1; i++) {
-		int ddir;
+		enum fio_ddir ddir;
=20
 		rs =3D &runstats[i];
=20
@@ -2861,7 +2864,7 @@ static void __add_stat_to_log(struct io_log *iolog, e=
num fio_ddir ddir,
 static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 			     bool log_max)
 {
-	int ddir;
+	enum fio_ddir ddir;
=20
 	for (ddir =3D 0; ddir < DDIR_RWDIR_CNT; ddir++)
 		__add_stat_to_log(iolog, ddir, elapsed, log_max);
--=20
2.34.1
