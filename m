Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76590C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbhLJMJD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:09:03 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54413 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbhLJMJC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137929; x=1670673929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lmdtYcBeh7WwYU4AWFFlSLD3hFvKrAHk/rJtLEBq2F4=;
  b=F9QE7o7J/MatbVXa6lPGQ0m29reFGtuR0xhaqH/0VkIAvBaE3T74Fw6L
   UBA5jblPj0fRvGe8TrZcB1+eglgidf1C+dnTc0aslr/QQAE+V71Ph9syr
   t+AvwF6yAKH/M7siYVOxzwVWwatc/iJucFezUPr2yrUlv2QXa80wgLujU
   Qpt/NbruuKP11lqsNK5OtnwmvGloabWRvsOW46Dvgo0ODzm6d8urdG5OY
   a17xZJhCmbNnssQGfHZp0vbPHZBhdhZaIfIcf9v2qdfSG4wnsqnru5wmt
   YDJsTPrNwk40HMog63Uzv6ZEmSfVcT4T7tWJZFG0HN430N3ClY1rVQUJw
   w==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="188944359"
Received: from mail-sn1anam02lp2048.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.48])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:05:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCnmR31BlaHkl4WUmcm5TJM/SnThS0J5i4zPdgO4pgDhn4ReyTHxNdCRM/5gIUJfSx1UKF250WlrC3AiNn1Qa3C+EXkGjBoZtQ8WNyNWVK80QxKeFkYDReVZDzrCmPnjzCqlBM5vi87AwKxRc1B7iTrRu2zwR8//NCTe0BHGRmj22qZjKlb35sLf9Om8GybITC6LF0ig7JprmHgpmXpM1G8wskmtpMxfHD8XRy7FPBmGjQZZU6WQaWcViPrkAhI8OpY6T4hf6N7oRq0qumFwUvwu8OOfHUy/e+vXX6Ll9yQTGUKyfNouvclkRoky9naU5vhoIVH+4Uz2Wo3Acugs5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfEeG6lVa9dGPKeLUSrqHDM9e+zMV6vWueGHcRbhEh4=;
 b=YeKH+QBBG6O4M8GFPz9pA/BSH7boxHbMbI2bAbLXr56+iZXFSNptYb4/B1x2W2oqRyNSne63mLdtFsYPHyziCm2wSkbNcvSEjg9eMtwFwzDyL4nRTHZuVwJhqHC+QmPS1AtmswRMPgdRnB6rikWMgLvRCOqE40CK2b7Ax9iy6bQXbSNXebjTLS83pxaL/EmxoVtMWZDa1vz+qXlsVFngBlUoV7kU5DltxlCAUoI2e8oVsv/tQl+EuXnpcctzZzTK1P0AjZTV1+jNLVVFaWUv0NEn4DjsaroLd+HNKjyso9TOu/4SzK/U6wPuDuYEGDNfVYx0u+UFsE3Tg8HCI3gkRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfEeG6lVa9dGPKeLUSrqHDM9e+zMV6vWueGHcRbhEh4=;
 b=cKsSOkOMDSavl/DEdkznpKdt+yPcsVknCLTfH7973IKn+pzrI68InA0GRj1XT0qqiRBIePoWIpFpjsHoDcUnXbRunvXD62m1w5YdJK1fk+vIN2KBLQoKXcv2ZjenFahrwMhdJWpkx9NmfGTOFjqzGvcHApzjrQnfv+w9vbMVbTk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 12:05:26 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:05:26 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/11] zbd: introduce zbd_verify_file_sizes()
Thread-Topic: [PATCH 05/11] zbd: introduce zbd_verify_file_sizes()
Thread-Index: AQHX7WwAo8G11gL/006U44pNHMWBIqwroZWA
Date:   Fri, 10 Dec 2021 12:05:26 +0000
Message-ID: <YbNChXps+eWFEGXO@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-6-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-6-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d79dd58-ff4b-493f-b8fc-08d9bbd55a32
x-ms-traffictypediagnostic: PH0PR04MB7622:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7622953349A2B3F15EBE2532F2719@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7zSlF1XqPN0ScBrbHCuasa3ld73P6YHvPN4BweVLEEnzJi7Gq2ktnmL8u9sRJx4ww0cWiGmgGGhFMlI0mlac4YiLg570JRg37qDpsfwfKVxl6faDeCR3DAFchwue/egP4KtBLaC2/5DE3Mv6RbddnVCAx65yYE0bpAiXl6dfWjXJHF87nMtChwCWgZiT+uA6lR3SWvuiqh/t/uDDF6Vpcnm7BsUsplFabJfQRzm+glwHocyqBdvECAWX+QDtlYQq96x2qtLPwPl32WyJ4+nPR6CSIsJA1cEhSdNv+DqnehkZ1nXqmrtxUMjdqOsXIGNwXYRhKqW1NsUTCNvx8LgEh4DbJ9N3ixKLQMrGrcFWCfLvQoyBHiYoghCw/HtUL1SRXS7pQ0i3Snztlvn3mKlYgvLgWhU3B/m5ZpS8Q0IO8HYSyQwRUhEeZ42R+ZprkjPEY4f6xyzaExYz532qD84hHpetdtaQvaolG+K2nwv9dK8ul0yuQ5zv4h3dNNXizHQ4tK/xl0gS84aJ4jhZcq6taWLgRy29+EaYQo0SKXZ1qJg6DAjWYNZauHIqqeU09EzU01VtTq2Z8FDmkfzt7CfzZ10odRuj+QZ2Fg/B3gQNpAHWoqf8v2j3FnzwrZI+qrJEfC4DEewOTtCtFbeJbbkp8q5RigV7LnCud3RpBczNNYNg0DX9fM++KIFTqsoiQlF/yjU2fE+pN2lUewcuwym2bIsFWpKvUq2HoBScfG/MGvc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(83380400001)(26005)(186003)(6862004)(38100700002)(4326008)(38070700005)(122000001)(76116006)(71200400001)(66446008)(82960400001)(86362001)(9686003)(6486002)(8936002)(508600001)(66476007)(8676002)(6506007)(33716001)(2906002)(66946007)(66556008)(316002)(5660300002)(6512007)(64756008)(91956017)(54906003)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lhn2pMeTw7X8t3T9w7ozvPpK2B0n+QtknFRue8NMyiH8GvOGff85H7CAvTZL?=
 =?us-ascii?Q?KRDX9jSVQkU5C3DqPcVwRoO8z4LVum2c9l+J3lbPqmDvfpL9rwXD1A0w9TRo?=
 =?us-ascii?Q?1oYeLlen7NzKHY/EbHOZkVRIFvlIXElB8L56mhjkqHK+P5SwTs8P56Zo9kyr?=
 =?us-ascii?Q?tFgY7NZYqwKXCJy5GQm4GdTCDGY/YFZ85y9z0IDUVgnKco+uD0+hIrpKszi3?=
 =?us-ascii?Q?h6ZCQR06sPomYy6j2fexnEHIyboRsEC+APyR0A1LrdCbQLnpLy1eZVffyti4?=
 =?us-ascii?Q?hgCu14Fi+G+OVX/K0N2kiq+hYJNzL5E4hIKK3d/8UgQ+iy9XeLjtDfMX21k6?=
 =?us-ascii?Q?AFRsh/vvZveYumFTRMoEQuK7WvN+IU5G0OXefwInSgEg+KwlpGGm454kFgzA?=
 =?us-ascii?Q?A+AbhK3MP6jW67Flaa+RzOUYUL3U+AVNF9WY/ES+NQqBUVoaklRNtz1K5CQU?=
 =?us-ascii?Q?WlV9ENB8iqxslTlnYwqn8weF+spYQyWJhki0qLol+MtDp0rhCGETVxPG9pBp?=
 =?us-ascii?Q?0rxsx28VM4m81X5Tu8KDemtV5mZd+ZN6SoilfdeO7GUnD1EIN/3zV1cj0gVw?=
 =?us-ascii?Q?5y05ytbIhqWgS6sWL1XUTV5KpEneXM0w2Zt5SasxiC9cOFCcZgVCI5WdE/Ny?=
 =?us-ascii?Q?PUqQGLSqKaDli7YykIBfbkE+xjy1qL9aLOctkxP+/ipEzpbsm3dh09ak5uj2?=
 =?us-ascii?Q?K+SOpFde4c09GQrrL1+mIIFrkCG1LkCHexJyogUW9jT8Djqn19FUdi3TRIqj?=
 =?us-ascii?Q?PqTZrbbdH3c84+mlHlj2V7d/ZlA0SP3ULsfDozTu+dQrj1ig2NQMnDfUZZYj?=
 =?us-ascii?Q?ebWWdl91odKCYY2P5OgDwUZHN+mdgRszTAWk45ApAv0VwWl0WAWzg7+0yTBv?=
 =?us-ascii?Q?VwY+p1RXTI3SnIlWIfkcsJxYRO9M8r839IKMrzhuW0DC29WX3RnnvaNxQZq5?=
 =?us-ascii?Q?NqwSr917yCZBisEPYb8tAB7DEjPfitWiydr6gwtkd9TkjPCOnOrXnHTQFMan?=
 =?us-ascii?Q?FYNJulblicAtZSgrMg1fSWD/aHDERlhV1bI4Z1FSwT/nq/yXUZyiXcFnNXnh?=
 =?us-ascii?Q?5QM012WVrv1NQ8aiVzjnKjYfpJeFTb9Yd1Jwp/OekreRiSiwQhtLlqPby9jE?=
 =?us-ascii?Q?U7slcQkvnQB/qnCcXSaginQyEQx5Xy6BF48jqq43XS1tbJJNdQwZGHyGur9A?=
 =?us-ascii?Q?8TSx+oGxAChqQqYaWmtgw4hrqz7b9tS4j9gfLhahvO0nIQFjyUFOudinGXUb?=
 =?us-ascii?Q?vqjNkgcOqV3qdGXGNsBF8RUElSqef8SHPNvx92R5YyAhztHpzGKv8tGjuAi5?=
 =?us-ascii?Q?+/KZt8zZbHa5KuPvJmE9WGifeljTflOw+avDsZlzEQ8Pfuter7qgkVrRkk2R?=
 =?us-ascii?Q?t9c6JHbvNhzPUxWRD8Hn2MGsUKxB27F7zBCAc6jHgDTKT6B1RZ8eYUW8kTKI?=
 =?us-ascii?Q?qd6OtTpOLmKVFq1Yo6tDzIANgVMytTOusCtFvVEg7b6sjuXqZFyaHc1s35te?=
 =?us-ascii?Q?hvmqi3BulmYV3k8FSO+vjCRivaDeukMoyopK9UA2TSDo/l2i6VxQd5lxTmm5?=
 =?us-ascii?Q?eVcxTBKo7k9jkXfCrg0rlhhJXz13Q/igw+5kqhvkl/bV+6v4Xl1Gj+KzCAf2?=
 =?us-ascii?Q?JFuAhAp9VGpyQkl+Mnu9xZk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4636CD96F4E094CA9DFCF9E236CD7A1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d79dd58-ff4b-493f-b8fc-08d9bbd55a32
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:05:26.3426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wng3KFmZhkkQjf68sV3qqrBWNCCCjew5E70xc4dgmGWgbwSQY2C9hNanYooZPlTM7wmdnASBFHk6He8P59LPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:35AM +0900, Damien Le Moal wrote:
> Introduce the helper function zbd_verify_file_sizes() to check whether
> the offset and size options are aligned with zone boundaries for a
> job/file combination. This avoids large indentation of the code in
> zbd_verify_sizes() and makes the code easier to read.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  zbd.c | 135 ++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 74 insertions(+), 61 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 70afdd82..70073461 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -485,76 +485,89 @@ static bool zbd_is_seq_job(struct fio_file *f)
>  /*
>   * Verify whether offset and size parameters are aligned with zone bound=
aries.
>   */
> -static bool zbd_verify_sizes(void)
> +static bool zbd_verify_file_sizes(struct thread_data *td, struct fio_fil=
e *f)
>  {
>  	const struct fio_zone_info *z;
> -	struct thread_data *td;
> -	struct fio_file *f;
>  	uint64_t new_offset, new_end;
>  	uint32_t zone_idx;
> +
> +	if (!f->zbd_info)
> +		return true;
> +	if (f->file_offset >=3D f->real_file_size)
> +		return true;
> +	if (!zbd_is_seq_job(f))
> +		return true;
> +
> +	if (!td->o.zone_size) {
> +		td->o.zone_size =3D f->zbd_info->zone_size;
> +		if (!td->o.zone_size) {
> +			log_err("%s: invalid 0 zone size\n",
> +				f->file_name);
> +			return false;
> +		}
> +	} else if (td->o.zone_size !=3D f->zbd_info->zone_size) {
> +		log_err("%s: zonesize %llu does not match the device zone size %"PRIu6=
4".\n",
> +			f->file_name, td->o.zone_size,
> +			f->zbd_info->zone_size);
> +		return false;
> +	}
> +
> +	if (td->o.zone_skip % td->o.zone_size) {
> +		log_err("%s: zoneskip %llu is not a multiple of the device zone size %=
llu.\n",
> +			f->file_name, td->o.zone_skip,
> +			td->o.zone_size);
> +		return false;
> +	}
> +
> +	zone_idx =3D zbd_zone_idx(f, f->file_offset);
> +	z =3D get_zone(f, zone_idx);
> +	if ((f->file_offset !=3D z->start) &&
> +	    (td->o.td_ddir !=3D TD_DDIR_READ)) {
> +		new_offset =3D zbd_zone_end(z);
> +		if (new_offset >=3D f->file_offset + f->io_size) {
> +			log_info("%s: io_size must be at least one zone\n",
> +				 f->file_name);
> +			return false;
> +		}
> +		log_info("%s: rounded up offset from %"PRIu64" to %"PRIu64"\n",
> +			 f->file_name, f->file_offset,
> +			 new_offset);
> +		f->io_size -=3D (new_offset - f->file_offset);
> +		f->file_offset =3D new_offset;
> +	}
> +
> +	zone_idx =3D zbd_zone_idx(f, f->file_offset + f->io_size);
> +	z =3D get_zone(f, zone_idx);
> +	new_end =3D z->start;
> +	if ((td->o.td_ddir !=3D TD_DDIR_READ) &&
> +	    (f->file_offset + f->io_size !=3D new_end)) {
> +		if (new_end <=3D f->file_offset) {
> +			log_info("%s: io_size must be at least one zone\n",
> +				 f->file_name);
> +			return false;
> +		}
> +		log_info("%s: rounded down io_size from %"PRIu64" to %"PRIu64"\n",
> +			 f->file_name, f->io_size,
> +			 new_end - f->file_offset);
> +		f->io_size =3D new_end - f->file_offset;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Verify whether offset and size parameters are aligned with zone bound=
aries.
> + */
> +static bool zbd_verify_sizes(void)
> +{
> +	struct thread_data *td;
> +	struct fio_file *f;
>  	int i, j;
> =20
>  	for_each_td(td, i) {
>  		for_each_file(td, f, j) {
> -			if (!f->zbd_info)
> -				continue;
> -			if (f->file_offset >=3D f->real_file_size)
> -				continue;
> -			if (!zbd_is_seq_job(f))
> -				continue;
> -
> -			if (!td->o.zone_size) {
> -				td->o.zone_size =3D f->zbd_info->zone_size;
> -				if (!td->o.zone_size) {
> -					log_err("%s: invalid 0 zone size\n",
> -						f->file_name);
> -					return false;
> -				}
> -			} else if (td->o.zone_size !=3D f->zbd_info->zone_size) {
> -				log_err("%s: job parameter zonesize %llu does not match disk zone si=
ze %"PRIu64".\n",
> -					f->file_name, td->o.zone_size,
> -					f->zbd_info->zone_size);
> -				return false;
> -			}
> -
> -			if (td->o.zone_skip % td->o.zone_size) {
> -				log_err("%s: zoneskip %llu is not a multiple of the device zone size=
 %llu.\n",
> -					f->file_name, td->o.zone_skip,
> -					td->o.zone_size);
> +			if (!zbd_verify_file_sizes(td, f))

Just looking at this, I would assume that zbd_verify_file_sizes() returns 0=
 on
success.

Perhaps rename zbd_verify_file_sizes to something like:
zbd_file_is_zone_aligned()

then it is more obvious from the name that it returns true on success.


Kind regards,
Niklas=
