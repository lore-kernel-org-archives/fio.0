Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBD5C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhLJMLX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:11:23 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:36038 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhLJMLW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639138067; x=1670674067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bJ8ipXEDpMoLKaYwKFKsfCtdRq9XV+/hNzd4TFwY6Sk=;
  b=iKpKrK8z2oZAIC/2jQ2VO1V/ap5m0bvJQ6XbHs1Gj2WKL0fCfjUk4eN5
   leIIMZuZQccFfuiEXjMF3+s2gda3PRIQ2aurlvwQEr8/9Y3XoU5NZg6aq
   /1O1Cb+3kmUslrayl5iMT05hvXgYkaJSdzg4tfcd1WzlALRy3+g6ZJOWQ
   o40Yq48063QShLZKt/MN/arunOuB4LEHnACTsO+TRD6yxdtptoCdCKeVn
   7ibD5ZdYT0hD9KbRD9mru/jG1aSpftVpdT550ZJVWz4PJhOW1FRiPhxiE
   nXgNv+TZmhip5TdCZ7xWrdvZBT0HR4z2DdbAS6sochSFnwb2qiWDPYx52
   A==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="186917067"
Received: from mail-mw2nam08lp2169.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.169])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:07:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HW7d7zNxLPlwaqIqS24R9TUXORm+oImwzQ7LT5PG7xFcAfFv9ZWCaKfn4cFj2U+xJ0BEQd/TLKP9FWxIgPMFNpdi3kEAPwsNWprFqRiTKXRTa3Y7xGRnUVsjg3K26NG8zIm+6lJ2IIikMjNs3B/SIk63Yyfg4pc9CN40NKhzIWbQZ3mEkF0uHT00U6NjgBEllXuhwl/h0aDdko2ZUJnJeLV+Yc9m4RrIdMvR2EhqUjLqwzgjs/x1+wk0Kvjmz6Wk4i+wDLzGTb6MUXacupfRGnFgo562BeHOg/V2UYDV4KmarhxG8aoWql2oaSD4VQhKsbohpNnvICHTl/CzIzYhDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7504C0GQMBsrIHv5UOgvbGbNTKGawZx3bKDnsnPVDOA=;
 b=PFhs5hJSAQVY0KugcANOYzrlNkY7NOX11qjNY2hprIaUeYPg5JutyZNilDAtq8sDxBTF7FU05rcvpG3IjeoIj8BbjyQDjDe72u6leiRYXqqngLyWLF4mz5Tlc3NOeqmDldEDEX6n/vLaci/QbeZuqwlF2q7iCL5gwCcTPho9g/QAAwEfLOI+0rULbqce0uUKgFOPwrrvJRI10AbigNfUYFU5BXylMX38nYtieE6zhTQRCcUZS9mE/tCionP/hbZolJB3ezrjOfXbgsyG5u2uCoHCFI1BgNsEDRNjiG5dtZcDHhqOVAHm+vsCov7EVB4Djk6Mh6IR2+fy3Fc9zH3rpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7504C0GQMBsrIHv5UOgvbGbNTKGawZx3bKDnsnPVDOA=;
 b=yzxK7BBx+EeVFUpBldhN2OFg5Z3v2w5OQOP/yr0bm99lLEVZAx8vCFJhoA3Fi1dcTsFnN6B4YujXbmWaTOsTevDPQGO4I09HnNdCVwRrBomdMRFkJcq+SNHIO0bDIuDhVJb0sKu1yAr35ipymE2CvagZ/vFB1sG7eWQ/w//uZsQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7302.namprd04.prod.outlook.com (2603:10b6:510:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 10 Dec
 2021 12:07:45 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:07:45 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 09/11] zbd: rename zbd_zone_idx() and zbd_zone_nr()
Thread-Topic: [PATCH 09/11] zbd: rename zbd_zone_idx() and zbd_zone_nr()
Thread-Index: AQHX7WwBl2Y0NgcOB029s+z//bp6mawrojqA
Date:   Fri, 10 Dec 2021 12:07:45 +0000
Message-ID: <YbNDDz7cbfn8g8xQ@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-10-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-10-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a15ad0ce-0f93-4b7f-c71f-08d9bbd5ad11
x-ms-traffictypediagnostic: PH0PR04MB7302:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7302B1EF54BCDA2CF182ABCCF2719@PH0PR04MB7302.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OljwHTl5YWmX7yrGVIKNEJN1IW+FKdUzA3VL+p48RKxbmqoDIpJx6/tVI34fpsIRkQSsa1HPTkEXqoZILR5QSMUYOGoSR+e2KjKjW+zA7iSHeteFvGrBybpemxLITwQjQCOMzKdvAn1WZj1xR8jn2TqiRLfw7UeB7GlYVTktNlTqU/sV13edkauJikn+N+oRAcPzzcf1HkTkdlq1pBwN8ry6Ouosu9pWASHcenpiBS8l7ivJ1ZQ9xcj6ezCxdb3DHDKCn69QQZ0W6UN0/gK5rhFWfjwG11FNZLNNulsYAOjY9h2W5OQiWR0VI5jkgyLljF3te9OBtOACr3/9SEgOXRoJ1uf0rHdMNOMdurlPraOIxemj5XUBgbdFYL7odEev06NGy5rh0szhR7jyFuVV2sVNC3TN+XUHkAOqR9jxZc0Ymp+ZXVtFFVzNDdMHBHJzivEqn/l2fjrYk3aSFqJvQRvPFyAytK7RD8BfxOr+UqXQjfYrbKZxjBTdAG110ZZqDwFHCSlv9qtDPx2mtiffW/iJ1lLHu1FEThNq0veARJSCVmpNQudrXuJD2gn6Np5QJRTlHAHwyN/iblvOw9NF0Kf/olH8EBoNouB5yShnPWEKcinMhUCYyLhQNj4YygYHhQrZYF5shkw1Q8pyj6+d8KLp4zHpVVbYKimn2biiPkoKFTBiTxoivBroBSaAsw8uFfpCYvw0WDE4wRT997otJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(2906002)(91956017)(33716001)(8676002)(76116006)(122000001)(6512007)(38100700002)(508600001)(316002)(66946007)(66446008)(66556008)(66476007)(64756008)(54906003)(9686003)(83380400001)(82960400001)(186003)(6506007)(71200400001)(4326008)(8936002)(6486002)(6862004)(38070700005)(86362001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r/Bi8yr19MQvO8g4oxuuL2mqbu+J40+1A92w1wIjx0Gx3mwbjVwVV6djhUjV?=
 =?us-ascii?Q?won8im0i+Q72pM8MinCl9zp8eQwyvSu199WMsDxL9F/A6VlQwZa8HLWnZhe5?=
 =?us-ascii?Q?jtiQNN0298rdSw67eyJqK9el+r4Ebwl7kSDcK29Xc9yFulxkssajiJsl6yUy?=
 =?us-ascii?Q?w/uTIKd6otLHnJ36MFW9NauEAUnqIvyRR0EtUjrJmob3WTDLUGh9sj/L9mze?=
 =?us-ascii?Q?K07j4LPuDpDKY9Z+8gPW93kRWbw8KkdC7I27VIvrrXzI7T3eWZnZns5XvpEK?=
 =?us-ascii?Q?ME80WEQMU5+VrS3RG4d0LRRhI60tXNKpilp5qwNkml0bF+ds/zhyaUEcyjpO?=
 =?us-ascii?Q?xW5U0pZOCiUqcRSSbNq0CG31aGCtE0OIFFhrhweJMFW0qL9pmP+X6w0ZckXO?=
 =?us-ascii?Q?1gfjUvMtAPyhIGxY4GD2TMaUp0WgIGVSnGD0AHjL6ObNp5h8sJkYI0gJWecS?=
 =?us-ascii?Q?wjpgI/lZ1MtN1dRQsqWTbMzeHJT5csPItM7gJy3LQaVvkcG6eoHqO1ycKFvr?=
 =?us-ascii?Q?47It+shkR2GAliQx6Tdv/i8S8DSbEGSo64pRsHkLxclmYrHya2p6LNYb6QUK?=
 =?us-ascii?Q?PE0HNRu/ovdC1luFmILtJ0qD4lddTsk56GDlSzN7XFwiKxlKlILeh+A7sfzt?=
 =?us-ascii?Q?PDn3YQ0dfNTLeJZgEogWtmm+Rlqon/fv+tY2dFfPsv3ggMaVpYCahkXZKGU/?=
 =?us-ascii?Q?V9oXF9Qu4NSKhpwTDtwTYs184DGd5W58STJPPwfx8W1xWn1qNxNAkypMzRmE?=
 =?us-ascii?Q?5qlWyDA7SFmOZHRQ7ENCFP5mIrAxI9VzP7A/uL0P33twWSWSqa/hjmuC8iIF?=
 =?us-ascii?Q?O+DhmH6XzkOt/gqor45PmxGl8XoTd0P+7Xy/Oq/e4D8GoMyslkzTTF0MYCxm?=
 =?us-ascii?Q?ho/MBahBOU7o+O/FVafTyEMJt33zCd9s+7zeJOgn08cWCGIrjrtYumUrfiDF?=
 =?us-ascii?Q?y0VJmPqpLfELvouB4KUYsscHlQhKZvdoh+nVCYKtw0ZHntshCj9lUdFdEKSW?=
 =?us-ascii?Q?e26OwWbLLgmq406ram7tmbugQbj5gN+ZcZ5aRXbnWrBYZV8tj05SLRrNfXgI?=
 =?us-ascii?Q?0S1EgBYMXD7igV5hfRBb9LwxyJthhIL+dcUdHawzq8kL13SCRiUZaaNLfvJw?=
 =?us-ascii?Q?JWRa7q54zQ9fkNjYSmBMDXWr5IL5Yg6fZ9oNS0V4kUbXTAY2IK4B6shB76n2?=
 =?us-ascii?Q?nJQBTCgZVdIrlR89k5Yf8AsRYomywoKbF8cKK7uTtHs8bJPkIqQAGhJUFgza?=
 =?us-ascii?Q?tlQ1wYZEYFgZVGGl1pjAB6M0KtD863ac88K+r4pZNQFb4y+LtIPFAI0z2vv4?=
 =?us-ascii?Q?MSWZkghsC4jNh511ofS5qtBL44uH++d3dk79Djm6wct9dT4+7JX3bdW1Sd7R?=
 =?us-ascii?Q?dbUGejNnH+a3gsCeRxgJfmQbmBQS43Y2WeupUBEWp+Cbnj+LEcyiB4/0rCTB?=
 =?us-ascii?Q?MjDCBFZuzrZ0+EnlnL4K753rIEZZnOfZMj8BvDPlAUptqGU39lp9c7VQJ8KB?=
 =?us-ascii?Q?JxixdRjxDgRvpJpA02le+wrqetH4QSOgIznDEBw96oLcDqqqXwZoAYj7CQZW?=
 =?us-ascii?Q?RyO/QEBGqWzfka6pr5f+G2ufHTrM3NOaZI9+qAaps1alFum/eqhfH1IMq2UY?=
 =?us-ascii?Q?hzgO4crATEGNq9A/TGofe00=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1264B8F761C093489F93435518E55426@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a15ad0ce-0f93-4b7f-c71f-08d9bbd5ad11
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:07:45.4293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bR3D0jWzwdhjIDsGiye39qIWqoLYvQG3avdF2bUMGydTNJgmKNp396mp1absgmJnF/qFfdNhkZJZOipJCU39/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7302
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:39AM +0900, Damien Le Moal wrote:
> Rename zbd_zone_idx() to zbd_zone_idx_from_offset() to make it clear
> that the argument determining the zone is a file offset. To be
> consistent, rename zbd_zone_nr() to zbd_zone_idx() to avoid confusion
> with a number of zones.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  zbd.c | 45 ++++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 49aee9b8..7204f68f 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -27,19 +27,20 @@ static bool is_valid_offset(const struct fio_file *f,=
 uint64_t offset)
>  	return (uint64_t)(offset - f->file_offset) < f->io_size;
>  }
> =20
> -static inline unsigned int zbd_zone_nr(const struct fio_file *f,
> -				       struct fio_zone_info *zone)
> +static inline unsigned int zbd_zone_idx(const struct fio_file *f,
> +					struct fio_zone_info *zone)
>  {
>  	return zone - f->zbd_info->zone_info;
>  }
> =20
>  /**
> - * zbd_zone_idx - convert an offset into a zone number
> + * zbd_zone_idx_from_offset - convert an offset into a zone number
>   * @f: file pointer.
>   * @offset: offset in bytes. If this offset is in the first zone_size by=
tes
>   *	    past the disk size then the index of the sentinel is returned.
>   */
> -static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
> +static uint32_t zbd_zone_idx_from_offset(const struct fio_file *f,
> +					 uint64_t offset)

Perhaps instead of having _from_ in the name, use _to_ ?
(Like virt_to_phys())

e.g. zbd_offset_to_zone_idx()

What do you think?


It does seem weird that one function that gets the zone_idx returns a
unsigned int, while the function that get the zone_idx returns a uint32_t.


Keeping the _from_ name would be fine by me as well, if you think
that having a similar prefix is more important than the function
name length.


Kind regards,
Niklas=
