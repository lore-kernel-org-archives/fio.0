Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1195AC43217
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 02:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbhKTCLz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 Nov 2021 21:11:55 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19124 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhKTCLx (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Nov 2021 21:11:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637374129; x=1668910129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4umJecYCp46vT8wAkHbLIH70RVRc+YhpsOqO7ZDRSKg=;
  b=of7FUB5lUi5JkR7pQKg0OgLwkFjMdTsc3kyr8Gukj/W/j5iV7R6BZINT
   q8kBqG6cLZO8r3cHPH6xQC5jHa7Jb+7THDoaafYShW0F7gDWOQOk9zVZS
   BNU9j8zyDmSurgprSDuDWvSUDCmtRlBT+DaBS6WhLlxRlf8BQYK40Pj1n
   i/Yn+YPM7767ou0Fx0iOn8coox/avxP30Ua8NBv+Jft92DKtf8LNbMzVA
   fYvD90nZSKbmpVfSPB9Nw0vgF2yun++fC9O+7IpqEmtS4to7hErDD+9zc
   9m8ylF6isrVxisxqnF13chVC0gKmagYPB5G6I+mofsUucIh9zem2z6OgR
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,249,1631548800"; 
   d="scan'208";a="190965465"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 10:08:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tutk4AukfRQppPiNUN3zVFN13OuXuCHseHdYD0zmxXG2xBAQzPOC5ijW0vw7u2Dw74/4lw7J/ZPhsW7L5N7EbaXuKa28XgsEvMoxnSgn2AW5wR4yWVI4KId3VO1frLPimz4xk9uI95KKpbx5TntHdtB0yQw1v+DbVVtGhjJ37yVqLWrzm378x2ZouN4IHxXj7NkKFg0CSM+jiW9gBJSUUJtNxy72LIopT1/tly77GkiAq1DanpfzCpPdeOzaEIiysWogcGp525CbGkiTZ9T+X4/MGezC0hQYI6zVCTVWCamFkU+EbPyPjXWfDXAS7WLO5PdnW9sfvMWoNKKQsHLnRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/uu9jxywMUpcK5Ix444SQhozpPY8aMLWDw/XaaUeVo=;
 b=e8UkyxfgD9E8NUbzUz/YOuwJ0KI56L/SJXrN+EXimvKCIHByBh5oliKu/ADaZfYFMoyZH5hWfl/EEUgLClR7GmYOI6DEr37bqWxjafHb3kXLfcrBu2YCmoZGdmeQsNITadNujYq/Sw4gurI1JvTv3dgZVfpbnlwV8zv3oMc/3bsl1MqIjJhTPoZSNdllP7qQA1GM+ZmG/ZsDwGIuC2cL9xs08rnWqo+/spKqvIo5nkqlVtywDYr+fRS2cNjwyIzwQqjT69bnygW9uZe+5eZOl4LmbZuI3GUn9Ft9jZVEXa0QfyTtNHsIm4XtlCmyTq/9I0MPevsYKgBS4ElUZxIYMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/uu9jxywMUpcK5Ix444SQhozpPY8aMLWDw/XaaUeVo=;
 b=eTL8E/uz190r2ngn20+N09/RHSkwQInI5Di+sRDn+DWaqJxM5LU5LVQhADAjaSnhOjTUzSYH4UkTL/8J9j+LEyh2M3zjDQntxoK1h3PDLlWhTqVOxf7s6WyAyc1/JO2CTPXhYjIFWNGJCrcCWsMM2QYvj4S9JNUH/o6u/800qmI=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 02:08:48 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.022; Sat, 20 Nov 2021
 02:08:48 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 4/5] stat: make add lat percentile functions inline
Thread-Topic: [PATCH 4/5] stat: make add lat percentile functions inline
Thread-Index: AQHX3bOO5qA6nJXvTkux/4cqMHYf7A==
Date:   Sat, 20 Nov 2021 02:08:48 +0000
Message-ID: <20211120020837.127453-5-Niklas.Cassel@wdc.com>
References: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55ae67d7-7fd3-412b-1c80-08d9abcab0d8
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB76226F1892F896CCC5FED9B2F29D9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:46;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sa4kr1BKCfb+E+m/RIjKmzbQHIIN1wGkXIReeM4bkE4Z91zg5DPoLQdxGsNem9E+WEPWNXTKOrMWxw7F7QMFD8RfQRkAYgvv4o63CBgJJCIUHylC55DtaaA3VfdIm6GqZWogzPX9ZOKIKaXLzpCNcvPW+ohRb5m2AIPZB25L7jQRF/GOtq8P+WlHjlHn0X8P6FzzWfg0QcMLKDt/wO8GdMLAct+U03bagZ2u/+w7QAjtUZ/8XSPt9FWJT20cjiveku1sjTsjCAdHeG7KuceIdCDotZXqdDWDPfy+G6uqlvAHKX9dTWWRwQ/2ezPc49NhxjgnNZzRItSUXKpyJGEFr1b3XQH99G3h7JsX0MmANOPzi2hyeZQyoK1XfM7x1HIuytRQ59FSsSs7hbVEEql1roy1X9sX1VKvNkuNRf+3/Rlu+5GS9B/xaqXrVZEQ6AU3TZCwZFlo7zstpqjzeB5+ZLY4Tvxpod90fpFDN7Bnzhq0AQNJGfdDgqAD86jE0cNs3lV8QO7hLLa0GENXDSa7hVbkU2LvBsgBmh0Z+sPMhEPPtLF9aqnsiR/pdqAwwARgz0uHdGVqCjDrFfAMBmMYbI4+2bD4BK8COChBkqPo8fUf4QMdsFPYaucDm/iaAzcjccqkTTiLY04B9dusQFk521QPnBxwPMlkHPpoNp9TNY3z3rcSoiFhTrpLeip4Gyvo7hNKxFWJPiUBBqGD3CAj+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(8936002)(4326008)(38070700005)(8676002)(1076003)(26005)(86362001)(2906002)(91956017)(76116006)(66446008)(66556008)(64756008)(5660300002)(66476007)(186003)(66946007)(6512007)(6916009)(71200400001)(508600001)(316002)(36756003)(6486002)(2616005)(122000001)(83380400001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?LUQ5tVeXuR3EDSGXj5GLMsmobkfRPNR8K3rOUCd+oT0lZ0YfgjW5SVjKk+?=
 =?iso-8859-1?Q?Qd6yi3Cr6TNRiAVg6CsULrzgkli3wMnDfpIlJIYL5Bd8Mty/azUvLlS1ja?=
 =?iso-8859-1?Q?dVv5Rj6OS6fnNCWWBzYMmFf5jv8frcBCIsJnhYmUZM2fBifEUZrp3Q7LKX?=
 =?iso-8859-1?Q?+SxdSl9/2QEF0yangxmkfyIUwfbxyzH+/tlqqSVQUet7hTHaDeD4MIhtA1?=
 =?iso-8859-1?Q?TEKadhCkmVzgZJXDsEA5TWQioNd+jFKV118xuQaX/41awVYAFKENc9WdOP?=
 =?iso-8859-1?Q?sTSbs2K4E2TwczfeBjQPDLoHHWN9dQebRzQQDgmXpLg0oS+8SkAYKlKoia?=
 =?iso-8859-1?Q?yxycPj5FwGmdDe/xHmuU04WUOYwM9vKfq20I/VLmEPtdIU9KP6+I5Lea5M?=
 =?iso-8859-1?Q?p9djMFeGsqJlW52LwHYZm8XvgbAIIFNVGhdx6mpdiRSyi+B65cYXsTeAON?=
 =?iso-8859-1?Q?BZ9AWoG0m8HibSoCqbJdEu+kvvzMpH+Wwrfz4+N3fQt6ia6zAqO+eVDVdn?=
 =?iso-8859-1?Q?oGpGQHaP3JGgFNK0+5XmWVEfo2ZhgNcUJ22NwaJVmw8SfoZwf3bFk6UaIY?=
 =?iso-8859-1?Q?WTcwBgmgFw2g8Qt4HUlwa7gRqrpJllnb4FaP/A3aM4Q1Kap+waXfHfaVIR?=
 =?iso-8859-1?Q?5k9UeN17yUNfDJ+adaC0pSe7jhwNdOfnDB+E1X8+rv1k5P1AVL7E0t1KKM?=
 =?iso-8859-1?Q?TL5HgyLfzcAxq2sL1wL/i8w7y1o8C1nAwVjEzv9mS/5P/NTMRGWs+2lEsS?=
 =?iso-8859-1?Q?0Sn93HSvo3rqPIsMyEcVMjGmCCalcsu1m18Ik5bXaODyjHzZNYw9AHcZs0?=
 =?iso-8859-1?Q?E509sXdBkFyUWdOBpwr076/lyEuJgRh89PFaPc6W+2A8dWq7ktwUQiNDtE?=
 =?iso-8859-1?Q?KERzkQZ0cvYo5HFHxf+phaHnVyPF6q9eO0KXrYBTby7mVNWFaocCG1O3XH?=
 =?iso-8859-1?Q?dDzaQ3fL1cw0nFL8cNZYS3KTiNcC8opdeH4E2mAXhmzoKRn8l2RWNFVb2S?=
 =?iso-8859-1?Q?VpHiSzKDnoh/s6G/qnT+ztd3rBBqPQbuiZXFRNFS9Ix4WWVZxeUcQcgS8g?=
 =?iso-8859-1?Q?StcL49sz62EuL18niO5/eprA/4vRBwF/DbHqxmNvlbVS8PMskBYzsCy/Me?=
 =?iso-8859-1?Q?2bqeDzbbvRhjp9HN2O1q9taDEW6O2ADoS5IwTwf4DpLUvpzz2RNfBEa+Dl?=
 =?iso-8859-1?Q?eyhlvBY9bSaeSyGGZ7ua2uaLnEmRupRg0LPcN0ecfy53v6AztYMDdD6/CO?=
 =?iso-8859-1?Q?1vaGNQO2RXhke2eA2qFLG+CF8lEOGd55VM6ET8PqVeyzk+tZbkOuygbnq8?=
 =?iso-8859-1?Q?rz5vyLPhFVQ6RUl/l1CxH3NROuLH0gElY/ST7TD0rR5ujOFTJ4zYgLfzWl?=
 =?iso-8859-1?Q?J4UceKnaeciHeufG4zkmxlXC6ltb1cBVzGeEreohwDWZ0MMjhxx95xTFPS?=
 =?iso-8859-1?Q?8iU1g3+x97Ucf6Yx3TXvzbp+MyngQ8zXLsyOhHIjScLQ99m72vCoLYpiBb?=
 =?iso-8859-1?Q?d+OyP3uLdtqINxDNy5GylkDhcd3RXwwyHgmOd+w7Iy5Ay8ddIay7RVkiWp?=
 =?iso-8859-1?Q?jxI5YYFXnc2GVG5oyVTq7aJIkdfDUTv0MveZSBXPDHf4RfHWbvsm18JRdO?=
 =?iso-8859-1?Q?LvBcwuYO/Zcw5orIg4qvfpabli8d747aXq2GYL0pK+Yd3LD0xXW9AW5NXZ?=
 =?iso-8859-1?Q?RAygmvIjtyUPZivmU1c=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ae67d7-7fd3-412b-1c80-08d9abcab0d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2021 02:08:48.7147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ZvZKTkZR0UCHg7tgXs9BPcupQf/WomUWI0ZDir6O+Ai5bS0A/8qR1KTeMjWZo1sWk5yvl1nO+XNlqbJQGBgnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Now when add_lat_percentile_prio_sample() has been simplified,
make both add lat percentile functions inline, just like add_stat_sample().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/stat.c b/stat.c
index 74f48dee..514f08eb 100644
--- a/stat.c
+++ b/stat.c
@@ -3052,9 +3052,10 @@ void add_sync_clat_sample(struct thread_stat *ts, un=
signed long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
=20
-static void add_lat_percentile_sample(struct thread_stat *ts,
-				      unsigned long long nsec,
-				      enum fio_ddir ddir, enum fio_lat lat)
+static inline void add_lat_percentile_sample(struct thread_stat *ts,
+					     unsigned long long nsec,
+					     enum fio_ddir ddir,
+					     enum fio_lat lat)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
@@ -3062,10 +3063,10 @@ static void add_lat_percentile_sample(struct thread=
_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
=20
-static void add_lat_percentile_prio_sample(struct thread_stat *ts,
-					   unsigned long long nsec,
-					   enum fio_ddir ddir,
-					   bool high_prio)
+static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
+						  unsigned long long nsec,
+						  enum fio_ddir ddir,
+						  bool high_prio)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
--=20
2.33.1
