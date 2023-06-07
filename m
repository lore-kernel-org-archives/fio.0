Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44232C7EE25
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 13:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbjFGNQN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 09:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240392AbjFGNQI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 09:16:08 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3EA6
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 06:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686143761; x=1717679761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ryxnXiI19Y+RZ1nibV0sDtlhCTM4zw+eX5tNXZmDbOM=;
  b=bUWGne1vGYbzc9xwCYn2i2dDTCH8hmQwXsTu1YmfbzzJLeDuS41G9pdc
   8ZiEe3JQzVEETUnOCsTlHn1IRNom/24KuX8CZ4cw2m79MjuksILjW4ceo
   Y2qUrTzszalSqmEcLM7Qyw26UM4UTmP63oZaCVSUdkzkNZuvbyuFLONU4
   afdNLJtneropiLXToGWj8dKMhK54hVR23ZSEa6WIDsQW27eyfw/VrdEaH
   6Gym3afcM4lSYhnmzSLGIQAg0m0fhz50KDD2mQ72tw0stUNiv7fF9ehhG
   2JxcIBw785Jtu9VyyXy060vOV59NoMV0r8q3DY1TrhbcKWRjhguHzuFUv
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="232872151"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 21:16:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjZN8NLJHPaQ+IrGCizx7Pljs2tz7/PVaAxKI2PICmJTT6bJRvJloHf72X7+DBX9BreCxmPtFMyPViCpOSTpR3HXWtc1AxpNA7GFAOMsfuG1EflnOQCbEi9sTG+fNdnPPMWKlgDazo0h66E5euTk1pi4V8xnD05Tn8FFmjwP4XSHm1OEmqz4aPUQxwcD+g9VuP6lP8Mml1o2/hNzNltKxn3BxEF0EJ5ebsW6xXi4WPsMaxYcUQ6ZjFDDrjhDHZ2DT+0BxywMgLZF7D/bVEbKDAyq5TefqsNpK+EprCkOw0dwBTCYj50hcLoPE+2dTplqRGu0xJRQNorAQDDDMyZVog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpXPao/NmrNbY1l39hYRiQJg3sVQuJZ/WNe3W8VFx+U=;
 b=hfq+KQ+g+e8zG5376F9PJKM17IKz3DtrusdE/HLEnwSasEz+YVVcMaBf18MM3BCAlVOoZ4OKuugzXmCLjd9kCElo5ReNLVefez6SyvWN80bPE8DQ0+sscm6sfgeIMP/5GdP0LzesFFzhpnHu5U/QgwbTJ680WUPzudCnqqZKWOfrkDQFDITGpQG4MtwPj8j92l/0RaZybz52nGXj9jX1fpjphMD401IRqECOP5w74KILYebDZ5d7rtpexoZkpagt3xQwOG7PzMECpHvxg40dtY9wWBePuf2OTyE6CrfFYf0n7YRFAkkI8b6zvyandDNYsYGAxoFYCRPELrKgSKy5CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpXPao/NmrNbY1l39hYRiQJg3sVQuJZ/WNe3W8VFx+U=;
 b=FtWpzk4cT1cfuSoiFCIE0yD2pndZm4Tqvl+nmoABiYArl74NFwETlMFu8cHw0rgeDCM6/ekF/6A7dIGwWZ6bI6/x+3OU2hroxb0T0Awpf481nLdgGG5pdtKDCjUbfXdJ+QqLFr/BcCeh7dIbupec5JGYZJwTMy/tNhfiY8+NLYQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7636.namprd04.prod.outlook.com (2603:10b6:303:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 13:15:57 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:15:57 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Topic: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Index: AQHZmRqjagW66pJkBUCQGUt1g3SDNa9/UimA
Date:   Wed, 7 Jun 2023 13:15:57 +0000
Message-ID: <ZICDCbgaQiZWdMpN@x1-carbon>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7636:EE_
x-ms-office365-filtering-correlation-id: 5d64a487-a2f0-4642-5af1-08db67595490
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fhnSI+LQM5FKr6/V5l+OJQlJF5dAfQn711qoLmOw8S9Z4Hm2ZtShKOAZTFVzm+4eTCmJT6RuYfAV7MtQMwcjqZkRzJFANSmZaQGTa56ACIjFW7Cpp5ngt2+RFoYorFsUhF6umsjNAYzXvY9PQdYiB582Y4ERQCFXiP1Z5b22MqY72H4tunlCtQCo3BE2Mmm2XydT7ZkatSGfD8ayTtAxisGKViiMuRk7h6jTq2dfKLX4zQDu4XgiyDwwYZo/h56zyPanOE6oiuTwXtQdytzln731kNXDMhLwPwO9lSHFkj16X2fjHHjrjNCt/fCuaGbLwr/npdauKOnKUz1NO+k4dHi041mmQnzY/tyKVsg1yHZFm3jxyJp38a3Z97ZpJc8xE+XZ5IO+BO2Wv+QO1AQ/ksiUAB0jAtWAhTTdqiW1+FpB7dtUss82jeQgbpSWYDObIJpJ52EolVGddFQj6Am9UfCHi9GJCCdmzoYN41WnzdWEHiMAEXMjaG6ijPL2TOqcul6Q4fwP0+iNGeFdhn8Ec0Doc09RR3Pfjd7BpjgXnvrYsFZiUUBJVFZ8YiA7xk2hNP5vsqdAVniP3KxPj3l8H2/ggkTqVMssbxJrxKusinIdh+e+Wn41LNfp5Lnq8JB0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(6862004)(8676002)(76116006)(6636002)(4326008)(66556008)(66476007)(66446008)(64756008)(8936002)(66946007)(91956017)(316002)(5660300002)(41300700001)(54906003)(2906002)(15650500001)(478600001)(26005)(33716001)(82960400001)(122000001)(38100700002)(9686003)(6512007)(86362001)(6506007)(186003)(71200400001)(6486002)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5hSEns/Il4fwwQgiDivmgSxjCCt+FyQl1+o60RKNQ6LFLPr2Vju9ohHNDps6?=
 =?us-ascii?Q?z6t1JEYQvPH/jhEQNgKnYjd81eyjmDmwOXzf8xKc5NCI0hiqJTcmGSwqBT1I?=
 =?us-ascii?Q?ztkelU19B+TcvE0mYJrq9y7GEXtF9svcZxtNEFHIAIfpTYgK3eVkuk3jAtex?=
 =?us-ascii?Q?iCY5UQEePXIpUN+q21BmYM3/M6+LQ7DaoKFFvfGpRYIYrICISsxzfi+knerk?=
 =?us-ascii?Q?EL24SCeS3kLF0A4e0u3COyOnlYCoSTazb2UiwcnRBoLPxnv9JHsb31aT07kR?=
 =?us-ascii?Q?7ryH+p+6BncIpGoHfbp5a2xh3eelZAJRyrrBNz1PIoOazHOlPW4AchLsl7gJ?=
 =?us-ascii?Q?rb8wPykwdP+qxMLXK2LYEuBZtsuPG+Hq8SJ+v4J1jHDF48AxpUd0smdaVzN5?=
 =?us-ascii?Q?EKQyquWjz1+gbmRlkWbWr7cuF+PjYPOx9CJXi1QDIov2/w1xEKRxApAeJbiR?=
 =?us-ascii?Q?ReshtNl3vMhQqDJmygkDJ63RyV3C3l9I9EDjTY0xTYl/AQAJRTxuZ5P9TVIA?=
 =?us-ascii?Q?y/TL9pk6riHZFKQEIFByT4A4ec7Wp5RzMupsTFGVeTQCJ2FK+PWga9KtOMFd?=
 =?us-ascii?Q?2UFC7oSSQMOUVq01lhs1RBSPAKKdYqoQHwJwfF7Zp7ShZhPgyaFDtIrSoDqf?=
 =?us-ascii?Q?0EZBu2ZQpv0kDRRD082CvRXU3iKSoTU3WS5M3jNHR9lPmGODo8dSyf/q87LV?=
 =?us-ascii?Q?lyEiR9rRAMfxTTCMD2j/FT4AYwI6j1U4AZmMIYWb7S87MKbl5kbMuRpcp/8z?=
 =?us-ascii?Q?jHN2M4CLUdOWILVJHpsbTb9eqUmRa63utZtuywsALU5MusIqirxoXKTCBSXC?=
 =?us-ascii?Q?Ii3gQUKlUC6TNm+Rd3vmfY6369Y6AvBv4iYyyTsxWUZiiJJnXt36jbYYep7W?=
 =?us-ascii?Q?1d6sajMONyklFaMRvwAnF5Et2m1o9FB31YdEu92LwiUY54nScXuBVgGcvqBL?=
 =?us-ascii?Q?4HNMhjALVphEmWgGfvB2Hm/eL9pwtCOfDhU64+V+v8aQC2jPwst7RCYZlSFQ?=
 =?us-ascii?Q?im0rjDKYk+PKHAW1S+9EYkz4sqrQTBJ2mTZjsvhK+HEDG8ma3rX2oT5PndIe?=
 =?us-ascii?Q?90FEcJaRLqsyCYDatC5RHyZyZtfyH5IhUvC3a5F0/U0oqQmUK5zwUDAX9KMB?=
 =?us-ascii?Q?6BdraWxlYEGL17NPzl3aOtVEV1WNxjscLP1PyRDxqxsYQIH8Bpx0Xb+VReqK?=
 =?us-ascii?Q?qkfVBLektmxMWwViwP9Vrgf2n45dv305fJBUQl3koQajcHu8LXo0ZtmbRoOc?=
 =?us-ascii?Q?GYgYM3qpfnB9etmr5HYjKM9I1A4jLNXoqWiSnUyAqLQBm0yBJ7xd+ZTS2Tm9?=
 =?us-ascii?Q?0yZndz+F5QzKhMwruZdNacw2Jb7CKO6vzF5E47mqqkwZK29D65f7VFtNyauZ?=
 =?us-ascii?Q?Bw2uSrEtjcEqfkr0ZbUvr7Y9vMl42SYnCkfDRQLLt+HoPh38UJ8mlf9PcuLQ?=
 =?us-ascii?Q?7LGqTA2+peKsHAcFzkiikVmzql7Aohd6BS6pb4TcQUHFjmZYOl8Q2A5jBDH3?=
 =?us-ascii?Q?0GFDyl03joNVqDTESgJ01hClb8zzvEfie7OI0nSuCn1c7DD/4/0cyLTcxZUR?=
 =?us-ascii?Q?WapBrL2DrH9vfojTonF6BeuotxOkBd7eWpnNfStlEGrLyZNDRyfOiLLxf8i3?=
 =?us-ascii?Q?uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <002E14FB7ACC5B4F9594BFCB7DA69B74@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +2P5T6x5ZoxwMXm6Q9Jpqm1xRAp2UqI+6VcecFBCNq1nD4c1RstEJxGRwBlgm28JPdUbLwuQFb6xw2xJtuKPD1ChALwGkDyz8O1KzkaBtQoLxbtpQxe1ykeIjLidyI8w2/Tqqbn/+WlYcwN8/1OpBYq9xl0hXnbhTx08fMJtDPn2RkKO+F7Suq7EtAxaaYU+3vT56vK5S27JgN9khVXN8dUx89babv0Bm8VwpG+JPWqTxJHuz8H8QPhVD9pN5pZiOnq+z+fU9aIckIoARpJDnt1dN3knfYXa4JxmtEzIkIExQiAvGzGQJerNaLY6NYUlIQTgPK/D6BUfKRhT8jVjI+7KifblO/SZEEs7h1PDFDyiLuB3gIbvnxOpdi4kzTIP1Mimfrw/BjB7c6+qSkyDnt2Y7vzLS0v7Efz1E8ibQRoI+sFFDmPsUggKsh5naYbU6cARab7XCR5WHd0A5VrawVSszmetgd/mtvTD//PL60Bsso2pEnDJRC3nEMS7KcpEHYmQkyCbuwwNddzFd45l+6r7F8vZSnpsmEtpvFUJwpou8faiobrT5RId8SzNDfW9tEVkpWRWJ7zgYcNsgbxMuH3q4sqNKxYgCf8Z642GDyeGFoqmX+SG2WSqRYhdtdJWpic2412cUUEMrfT8lk3n0GRQxkbjup2IhgGJpUHRIeNRlnOO4a8xFL6Jq6l+phaVkXcOeGWPl6o2w5hb+Cu85pbNKhpEDFEvR2AVCXzJd6PTsv7eRN2t+QHbZqpp/txxh+D+btToDcaOOnw6AKTPEZqTMflUMAMLu9tgMto8bT+g+HpvYUZb0noifzM+sFNvvXa9NQxVmRay4MVEZ1YQv9A4YqOKrA0aYtM33lBPsh8=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d64a487-a2f0-4642-5af1-08db67595490
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 13:15:57.1492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OX4cW6p5HmdEjugGnzNBdnQtmiK38iV83GW0OsjykEJRDctfEPRAzS0gkmQjDbLAjQl9LxXcrRZ8gfh5JmWRWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7636
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jun 07, 2023 at 05:32:27PM +0900, Shin'ichiro Kawasaki wrote:
> The commit e3be810bf0fd ("zbd: Support zone reset by trim") supported
> trim for zonemode=3Dzbd by introducing the function zbd_do_io_u_trim(),
> which calls zbd_reset_zone(). However, it did not call
> zbd_write_zone_put() to the trim target zone, then trim operation
> resulted in wrong accounting of write zones.
>=20
> To fix the issue, call zbd_write_zone_put() from zbd_reset_zone(). To
> cover the case to reset zones without a zbd_write_zone_put() call,
> prepare another function __zbd_reset_zone(). While at it, simplify
> zbd_reset_zones() by calling the modified zbd_reset_zone().
>=20
> Of note is that the constifier of the argument td of do_io_u_trim() is
> removed since zbd_write_zone_put() requires changes in that argument.
>=20
> Fixes: e3be810bf0fd ("zbd: Support zone reset by trim")
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  engines/io_uring.c |  2 +-
>  io_u.c             |  2 +-
>  io_u.h             |  2 +-
>  zbd.c              | 40 ++++++++++++++++++++++++++++++++--------
>  zbd.h              |  2 +-
>  5 files changed, 36 insertions(+), 12 deletions(-)
>=20
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index ff64fc9f..73e4a27a 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -561,7 +561,7 @@ static inline void fio_ioring_cmdprio_prep(struct thr=
ead_data *td,
>  		ld->sqes[io_u->index].ioprio =3D io_u->ioprio;
>  }
> =20
> -static int fio_ioring_cmd_io_u_trim(const struct thread_data *td,
> +static int fio_ioring_cmd_io_u_trim(struct thread_data *td,
>  				    struct io_u *io_u)
>  {
>  	struct fio_file *f =3D io_u->file;
> diff --git a/io_u.c b/io_u.c
> index 6f5fc94d..faf512e5 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -2379,7 +2379,7 @@ int do_io_u_sync(const struct thread_data *td, stru=
ct io_u *io_u)
>  	return ret;
>  }
> =20
> -int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
> +int do_io_u_trim(struct thread_data *td, struct io_u *io_u)
>  {
>  #ifndef FIO_HAVE_TRIM
>  	io_u->error =3D EINVAL;
> diff --git a/io_u.h b/io_u.h
> index 55b4d083..b432a540 100644
> --- a/io_u.h
> +++ b/io_u.h
> @@ -162,7 +162,7 @@ void io_u_mark_submit(struct thread_data *, unsigned =
int);
>  bool queue_full(const struct thread_data *);
> =20
>  int do_io_u_sync(const struct thread_data *, struct io_u *);
> -int do_io_u_trim(const struct thread_data *, struct io_u *);
> +int do_io_u_trim(struct thread_data *, struct io_u *);
> =20
>  #ifdef FIO_INC_DEBUG
>  static inline void dprint_io_u(struct io_u *io_u, const char *p)
> diff --git a/zbd.c b/zbd.c
> index 36b68d62..7eef49c6 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -254,7 +254,7 @@ static int zbd_reset_wp(struct thread_data *td, struc=
t fio_file *f,
>  }
> =20
>  /**
> - * zbd_reset_zone - reset the write pointer of a single zone
> + * __zbd_reset_zone - reset the write pointer of a single zone
>   * @td: FIO thread data.
>   * @f: FIO file associated with the disk for which to reset a write poin=
ter.
>   * @z: Zone to reset.
> @@ -263,8 +263,8 @@ static int zbd_reset_wp(struct thread_data *td, struc=
t fio_file *f,
>   *
>   * The caller must hold z->mutex.
>   */
> -static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> -			  struct fio_zone_info *z)
> +static int __zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> +			    struct fio_zone_info *z)
>  {
>  	uint64_t offset =3D z->start;
>  	uint64_t length =3D (z+1)->start - offset;
> @@ -339,6 +339,33 @@ static void zbd_write_zone_put(struct thread_data *t=
d, const struct fio_file *f,
>  	z->write =3D 0;
>  }
> =20
> +/**
> + * zbd_reset_zone - reset the write pointer of a single zone and remove =
the zone
> + *                  from the array of write zones.
> + * @td: FIO thread data.
> + * @f: FIO file associated with the disk for which to reset a write poin=
ter.
> + * @z: Zone to reset.
> + *
> + * Returns 0 upon success and a negative error code upon failure.

Please add an empty line before the "The caller must hold z->mutex" line,
such that we are consistent with other functions, e.g. __zbd_reset_zone().

> + * The caller must hold z->mutex.
> + */
> +static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> +			  struct fio_zone_info *z)
> +{
> +	int ret;
> +
> +	ret =3D __zbd_reset_zone(td, f, z);
> +	if (ret)
> +		goto done;
> +
> +	pthread_mutex_lock(&f->zbd_info->mutex);
> +	zbd_write_zone_put(td, f, z);
> +	pthread_mutex_unlock(&f->zbd_info->mutex);
> +
> +done:
> +	return ret;
> +}
> +
>  /**
>   * zbd_finish_zone - finish the specified zone
>   * @td: FIO thread data.
> @@ -404,9 +431,6 @@ static int zbd_reset_zones(struct thread_data *td, st=
ruct fio_file *f,
>  			continue;
> =20
>  		zone_lock(td, f, z);
> -		pthread_mutex_lock(&f->zbd_info->mutex);
> -		zbd_write_zone_put(td, f, z);
> -		pthread_mutex_unlock(&f->zbd_info->mutex);
> =20
>  		if (z->wp !=3D z->start) {
>  			dprint(FD_ZBD, "%s: resetting zone %u\n",
> @@ -2048,7 +2072,7 @@ retry:
>  			 */
>  			io_u_quiesce(td);
>  			zb->reset_zone =3D 0;
> -			if (zbd_reset_zone(td, f, zb) < 0)
> +			if (__zbd_reset_zone(td, f, zb) < 0)

Since you remove the zbd_write_zone_put() call, which I think is good,
I think that you should continue to call zbd_reset_zone() here.

>  				goto eof;
> =20
>  			if (zb->capacity < min_bs) {
> @@ -2167,7 +2191,7 @@ char *zbd_write_status(const struct thread_stat *ts=
)
>   * Return io_u_completed when reset zone succeeds. Return 0 when the tar=
get zone
>   * does not have write pointer. On error, return negative errno.
>   */
> -int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
> +int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u)
>  {
>  	struct fio_file *f =3D io_u->file;
>  	struct fio_zone_info *z;
> diff --git a/zbd.h b/zbd.h
> index 25a3e0f1..f0ac9876 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -100,7 +100,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td,=
 struct io_u *io_u,
>  			      enum fio_ddir ddir);
>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *i=
o_u);
>  char *zbd_write_status(const struct thread_stat *ts);
> -int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u);
> +int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
> =20
>  static inline void zbd_close_file(struct fio_file *f)
>  {
> --=20
> 2.40.1
> =
