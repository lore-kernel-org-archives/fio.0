Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CB3C38A2D
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 10:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiJZKlN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 06:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJZKlM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 06:41:12 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F1F9E0CD
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 03:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666780870; x=1698316870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/vA+GQXwKRU9+e+Uqa5727K2O3tSNIJ2s/cgVT5joOw=;
  b=KY8SMAunni+T0Q8mewwCH683NN01yXMbQ1au4QIavrcjs5rNSF/lowkK
   g4SqFFiTQ/aIUClqG32NViKK7EV6KRKYGMkcymTLYYbwHHliQ4jXuz9Ye
   mOtd7DCjN6mHCfIWheKd3gIVQzogXUlURuU1PSZM1ilkIdPKOfDlqiZWO
   ZvPXTxa8toIcf0FyhSoHKE6g7ipLN4w/8hBP9xqof4l7Sm/O+vZ8+tPTo
   aPmcLevcKZXlYMF0Uu/siukOMDYvoebIVLyamTWwXc5PF27z+k1Xn3Tpg
   aPY8ffIkDw9IudLnHnRT3exbDwcrNhPRlc+7FOB728DOUAa7ZqpLXB5rg
   A==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661788800"; 
   d="scan'208";a="219937931"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2022 18:41:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6iguF2467tsiPMwa7O6X9kEn9Vnqaz14t7dTgeiR35tPjuj+3VHYRl+/ppaDjGx4FivwSvK3uviLLxc4or/u5bRtwuLrcwCognPwO05AIU6kqvY1cysrXbq+nYJ2g+3OlpRIwiIezyxaPo5KKPPEu75CiGbo+2nPMwEC2LlqE7qpqkG21Lml6YIDO6SHklGXj3vGE4FXMkLuU+w2lqXDK4ev7ewNVa3FQ5Av+XphCWO/Nqnxr0PVZYEIGJKoL7OzX7sqYq5BPAYdmErgmsKmEbtWRiva+zVFkOYN6eUSW1Sn6MpGcPlQI6VMAmhK/eppFjTgCqDmJZ3vpq5ipIfiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5tvYEDZvj1mDoO3WFSxYuDd/yoh4WHFRShJ1WoEWIg=;
 b=LulsqdQBgOVVwngzkwHDn+EoQ8CPPHiCsvSpy6e7wpFYv00wfg1qR5OzAruLGxZy0QZNRh9FZ2m1xiqhzKSJ/Q5o6pJ/Kjk2q21PkulS/DeaTQ0F6cfOMjC4Xsb34DjadyIyKNEFMdDMqJG8fcUkWlr7NFodZ0qL8fj7t/1Tv/w9+uwArfwoUYyy/2drISUvd0EYPOJOjlMEwugBxslDQFW+eYkCT49Kqiu3lKeZwl8TKkY0Uld5nIfutvE8CgU5GUHas8hjna1j+ausXDTklHwU6mBHq2pw5THSmA5lzi/ccm/nq1SzoaLEICnTMIajtm4e+g/5MK23ECYYo0P/SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5tvYEDZvj1mDoO3WFSxYuDd/yoh4WHFRShJ1WoEWIg=;
 b=kxg6AOSn+LCl0ppxYGkW9K4xHI1Tf08ticDhpcxFYYNUxxzTBmopK1+oB5p6YPHMcKBqS++xdqmPGhnUGnDDJxajy540ipXuDMvoSH53OW42XtrLBvYQwiCA/Uum924+8poXW0gyQSeNo71sm3WgWezaPntpKGlhKaOCjeOQGDw=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB3948.namprd04.prod.outlook.com (2603:10b6:5:b8::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 10:41:07 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%5]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 10:41:07 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 03/11] zbd: finish zones with remainder smaller than
 minimum write block size
Thread-Topic: [PATCH 03/11] zbd: finish zones with remainder smaller than
 minimum write block size
Thread-Index: AQHY5RcqwTrD6cEdlkyOrxt0p413iK4fz3UAgAC1RYA=
Date:   Wed, 26 Oct 2022 10:41:07 +0000
Message-ID: <20221026104107.4tn6m33wn24g4tin@shindev>
References: <20221021063416.860438-1-shinichiro.kawasaki@wdc.com>
 <20221021063416.860438-4-shinichiro.kawasaki@wdc.com>
 <5ea1e64b4119d597539a4bfba037f42f08ec298f.camel@wdc.com>
In-Reply-To: <5ea1e64b4119d597539a4bfba037f42f08ec298f.camel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB3948:EE_
x-ms-office365-filtering-correlation-id: ddf3305b-6e7e-408a-7001-08dab73e9712
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PU6B3OTtatpt/cCX8CFwkZZMQDnubyi5vDRlHEukle2q37KBhatRSB90F1vsBjViQ6Vy/8USvQ0gJT/IjV4ZlhScbDIME2FNgDDdrxjSoeSbJvJjqOBES8PMN8NEi9zFPZHs4qyAPFxCqz7PRHTLqUe5cAP8yeOWDrbQgvqTJVjI2geyAn5nfnZN63FMz2Bj2ZVGo/BIC5/4zv6QKxIpvV88G6f00msR2e0sPZBDB1DO44708gnJaAiB6S9ULF5JGCbOPa9AYxjiqzQ6bgCbs5J50fNGxc1jFL9u4cac5p1e+QvssVz72nVOsoZzFj77MXUccn++Zf6p2SnFzufz37yy5UdWI0T2Li3EhX2KDAEwY3mMg1QuBV2Rj5eqy6zBtNlmK7zG35csUFWjYDiMWUtOfiLxovQEFp6rfjwVPWuVmY6JNF6cYfyri+SJ52ESaOCFdTU0w8P7epekopGXc1OSCYKT/nC66P4uZDgl8s5VTBX/vjq5/ZY8Gq/eWNK9rO2HQYVj93tJ5AjvCNagS7JP0FIvBIu1EdNcplFdFFCUnMG6JkzdSuqzMJMmuyOo6DJa9ePLxkebwHZng9XznKR6OJPyZa6pHEiLDERFGDZC0EzpkznEl4Su8ouwBWb5dyJtHcXL0HW+bD7AFCnoD4YV12hjToly/KE8RJcdLCVVhxUxl2thOrtb+kNtygdOmawFMg2KhRXiQRjkKHq+jkk9bl49BDOOuy6dfvrALIn3kZjrRfjKlK8YcR4akkpMhOgIecrXELcqWC5bcGzjaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(478600001)(71200400001)(33716001)(38070700005)(82960400001)(6486002)(38100700002)(6636002)(1076003)(6862004)(54906003)(86362001)(26005)(6512007)(9686003)(91956017)(76116006)(64756008)(4326008)(8676002)(41300700001)(186003)(122000001)(66476007)(83380400001)(66446008)(2906002)(4001150100001)(316002)(8936002)(5660300002)(44832011)(66556008)(66946007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jWsaLQG4Wf5580i80txDAXzUdSuKf4lfiNIzU+BqBouFITL5T8vdsy8z25?=
 =?iso-8859-1?Q?g/l/5/Wd3bdMaQJVGMs2dK2+X23G/Bx9rmHBIRiK4qbzQiF1JFWk+ZsnxP?=
 =?iso-8859-1?Q?f/wQnZL4apKF1aM8JVJy+zKyj1HktMGvdTo2Hgdb5HsKgvrH5+yDu84k9A?=
 =?iso-8859-1?Q?hU04WqcV65YJ471jHB/qfIz/2vqP3IbJxPMZRcLLOYD32mntZzYU8h3kFX?=
 =?iso-8859-1?Q?aYNUOEeUCb2gfemm5kdDl6NnHRk7MfDQpETOySMe0HcHbfeP/6WK85KaFg?=
 =?iso-8859-1?Q?KSRRwZy/dDqVNcnYnpB2OuSQlqFgVikTyWjnPvWAGJyvwPEUtxhszN8pvA?=
 =?iso-8859-1?Q?/kFkKgAsp63ADFsPE0f7xFH5TQuXyBR73USUOSLfwxgQoQcE4MEU3gQ74z?=
 =?iso-8859-1?Q?K9dfTktMxv62JcTnSxhrQEbp54Qw1rK55hi0NdO3pPV8nS/fuv+N1VXk4N?=
 =?iso-8859-1?Q?3rn7D3UHuPI9mB+iK9q8Y+lZ2tAi+wQmUx/c2nJgr5tPmfZB94UrhhZeCP?=
 =?iso-8859-1?Q?A+C7b85rCRQe7Md9FVirr7N2VF4ieGthJGvdGFW4NCsIiASOBMm4j3Kd+5?=
 =?iso-8859-1?Q?gA1YVVz56PkQNK2svqWZSbMI1M+szs4QcmtWUMFnU1NZU7szP8rfp0OdzV?=
 =?iso-8859-1?Q?AQS2riN6yF0zrCoBFIH83TqtEgms8e2/yyUOFDdf/3Rex4+RgROylkF9Lh?=
 =?iso-8859-1?Q?pZivqCPO/Ke4kMb9qX2XvLtMryPE9qb5/i29hrJKVByNs6XI0pPNtyO1tW?=
 =?iso-8859-1?Q?wVuE2NYvwoBITy4yArYhaqtTWh3GoJCQJlOVT3lg5aYcSmsm/iaGBMbE0c?=
 =?iso-8859-1?Q?Lz5qrAMDMbO1xHmE3auO0GtuQeNQymjB99mDnz0gESe91syAfSsUdOdW68?=
 =?iso-8859-1?Q?Agtn+UYqDarvpVGAISx+l8lv0G7NwmEV1djhl4pGTHUBczMAl+dUhefF8w?=
 =?iso-8859-1?Q?VG2uuPsxEXXDDI/ahbSn8YYc30xVXyJzJ/F+1w3mz7rK4juHxoXq2o9UF0?=
 =?iso-8859-1?Q?zexPWa7DsXi6fhwxqdm252PzGeVUBmyNlBvV+BiXYwtKi480xAL7fCHRbK?=
 =?iso-8859-1?Q?vNkXj/2wUkhG/IFDngnzSiDATllkGTyIbLui5HNxOb0uMeQVQJPgNMdtkA?=
 =?iso-8859-1?Q?ZJBGlHB+e8eEnMscrprUr+p75lHlLbb/PIkp6X8waKCcxGdrre7M/R/vkX?=
 =?iso-8859-1?Q?OF+5TAPQV8b/WEw/+mzIhgpl4kf9QiPREBcqwiwE13RqX3Sx/BdzAH8JZn?=
 =?iso-8859-1?Q?D6FTNX8AqVocGpdZ57yFZt6D8xL7cGVfVeBrhGk8AooL4rQht5BO8LqjJS?=
 =?iso-8859-1?Q?Do9ehWNsFYy2dA0Ag6/WmDmi4gwI7cV3TDV6wI/YHt6I+ZvBwxaF+Z4Qis?=
 =?iso-8859-1?Q?ZHcEtY1NOwSJlOlKcWuZSdXkiSv+I+NoKqm4fB/RkBIE/PdoPsmhdP761B?=
 =?iso-8859-1?Q?3uy9Gd+op701/vreY1u0hSPf3JDIgKr4ib6pccWc51Q2UsAYJEEh2XdqqY?=
 =?iso-8859-1?Q?RMpR2i33uY45NkikudCGxqJmcJCt+9BIjLZO6q9460EVe7PNMCTTQp+PEQ?=
 =?iso-8859-1?Q?n/MLPfeTUklDz/tpIQyb2E52xUosK5Grb3XfqT0AkTrCHCbHVra9EtSeFh?=
 =?iso-8859-1?Q?WIpfkHwJrKupeDVNKv5mEAIxxBankyPrT75SPab1MATmfH3t3b6yu7JvcF?=
 =?iso-8859-1?Q?oUu1R4dII86dvQB+GTw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <2BDAE25846EE7B46912CDE618D83E35A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf3305b-6e7e-408a-7001-08dab73e9712
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 10:41:07.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +BKFN9IjsK3rEbZOFe6DdtpHK9BRb9eru4mM75bI1U9mlqAtsbEMPZvOxkdOm7uazepCdlOycqvrs+No4ld8OOPPNMh9P09EyonUz46fOf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3948
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Dmitry, thank you very much for testing and reviewing.

On Oct 25, 2022 / 23:52, Dmitry Fomichev wrote:
> On Fri, 2022-10-21 at 15:34 +0900, Shin'ichiro Kawasaki wrote:

...

> > +/**
> > + * zbd_zone_remainder - Return bytes can be written to the zone.
> > + * @z: zone info pointer.
> > + */
> > +static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return zbd_zone_capacity_end(z) - z->wp;
> > +}
> > +
>=20
> This new helper has a very useful semantics. You can get some more mileag=
e
> out of it by using it elsewhere to clean up the code. I tried to add thes=
e
> changes -
>=20
> diff --git a/zbd.c b/zbd.c
> index 55c5c751..a19b3a34 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -92,8 +92,7 @@ static bool zbd_zone_full(const struct fio_file *f, str=
uct
> fio_zone_info *z,
>  {
>  	assert((required & 511) =3D=3D 0);
> =20
> -	return z->has_wp &&
> -		z->wp + required > zbd_zone_capacity_end(z);
> +	return z->has_wp && required > zbd_zone_remainder(z);

This hunk makes some test cases fail. When a zone is finished, its z->wp is=
 set
at zone end, not at zone capacity end. Then "zbd_zone_capacity_end(z) - z-w=
p"
becomes minus value and cast to uint64_t makes it a large value. I will cha=
nge
zbd_zone_remainder(z) impelemntation as follows to avoid the failure.

static inline uint64_t zbd_zone_remainder(struct fio_zone_info *z)
{
       if (z->wp >=3D zbd_zone_capacity_end(z))
               return 0;

       return zbd_zone_capacity_end(z) - z->wp;
}

>  }
> =20
>  static void zone_lock(struct thread_data *td, const struct fio_file *f,
> @@ -487,7 +486,7 @@ static bool zbd_open_zone(struct thread_data *td, con=
st
> struct fio_file *f,
>  		 * already in-flight, handle it as a full zone instead of an
>  		 * open zone.
>  		 */
> -		if (z->wp >=3D zbd_zone_capacity_end(z))
> +		if (!zbd_zone_remainder(z))
>  			res =3D false;
>  		goto out;
>  	}
> @@ -1415,7 +1414,7 @@ found_candidate_zone:
>  	/* Both z->mutex and zbdi->mutex are held. */
> =20
>  examine_zone:
> -	if (z->wp + min_bs <=3D zbd_zone_capacity_end(z)) {
> +	if (zbd_zone_remainder(z) >=3D min_bs) {
>  		pthread_mutex_unlock(&zbdi->mutex);
>  		goto out;
>  	}
> @@ -1480,7 +1479,7 @@ retry:
>  		z =3D zbd_get_zone(f, zone_idx);
> =20
>  		zone_lock(td, f, z);
> -		if (z->wp + min_bs <=3D zbd_zone_capacity_end(z))
> +		if (zbd_zone_remainder(z) >=3D min_bs)
>  			goto out;
>  		pthread_mutex_lock(&zbdi->mutex);
>  	}
>=20
> and these seem to be ok. If you decide to include them, you may want to p=
ut the
> introduction of zbd_zone_remainder() into a separate patch.

Overall, these changes looks good to me. As you suggested, I will incorpora=
te
the changes and separate the zbd_zone_remainder() part as another patch. Th=
anks!

>=20
> > =A0/**
> > =A0 * zbd_zone_full - verify whether a minimum number of bytes remain i=
n a zone
> > =A0 * @f: file pointer.
> > @@ -322,6 +331,44 @@ static void zbd_close_zone(struct thread_data *td,=
 const
> > struct fio_file *f,
> > =A0=A0=A0=A0=A0=A0=A0=A0z->open =3D 0;
> > =A0}
> > =A0
> > +/**
> > + * zbd_finish_zone - finish the specified zone
> > + * @td: FIO thread data.
> > + * @f: FIO file for which to finish a zone
> > + * @z: Zone to finish.
> > + *
> > + * Finish the zone at @offset with open or close status.
> > + */
> > +static int zbd_finish_zone(struct thread_data *td, struct fio_file *f,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 struct fio_zone_info *z)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0uint64_t offset =3D z->start;
> > +=A0=A0=A0=A0=A0=A0=A0uint64_t length =3D f->zbd_info->zone_size;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0switch (f->zbd_info->model) {
> > +=A0=A0=A0=A0=A0=A0=A0case ZBD_HOST_AWARE:
> > +=A0=A0=A0=A0=A0=A0=A0case ZBD_HOST_MANAGED:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (td->io_ops && td->io_=
ops->finish_zone)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D td->io_ops->finish_zone(td, f, offset, length);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D blkzoned_finish_zone(td, f, offset, length);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > +=A0=A0=A0=A0=A0=A0=A0default:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (ret < 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0td_verror(td, errno, "fin=
ish zone failed");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_err("%s: finish zone =
at sector %"PRIu64" failed (%d).\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
->file_name, offset >> 9, errno);
> > +=A0=A0=A0=A0=A0=A0=A0} else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0z->wp =3D (z+1)->start;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return ret;
> > +}
> > +
> > =A0/**
> > =A0 * zbd_reset_zones - Reset a range of zones.
> > =A0 * @td: fio thread data.
> > @@ -1941,6 +1988,33 @@ enum io_u_action zbd_adjust_block(struct thread_=
data
> > *td, struct io_u *io_u)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto eof;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > +retry:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (zbd_zone_remainder(zb=
) > 0 &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 zbd_zone_remain=
der(zb) < min_bs) {
>=20
> You can avoid using this label by putting all the code until "goto retry"=
 into a
> while loop -
>=20
> 		while (zbd_zone_remainder(zb) > 0 &&
> 			zbd_zone_remainder(zb) < min_bs) {
>

I don't think this suggetion does not work. See my comment below...

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_mutex_lock(&f->zbd_info->mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0z=
bd_close_zone(td, f, zb);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_mutex_unlock(&f->zbd_info->mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0d=
print(FD_ZBD,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 "%s: finish zone %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 f->file_name, zbd_zone_idx(f, zb));
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
o_u_quiesce(td);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0z=
bd_finish_zone(td, f, zb);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (zbd_zone_idx(f, zb) + 1 >=3D f->max_zone) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (!td_random(td))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto eof;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0z=
one_unlock(zb);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* choose next zone with write pointer */
>=20
> "Find the next write pointer zone" sounds a bit better here

Thanks, will reflect in v2.

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0d=
o {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0zb++;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (zbd_zone_idx(f, zb) >=3D f->max_zone)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0zb =3D zbd_get_zone(f, f->m=
in_zone);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}=
 while (!zb->has_wp);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0z=
one_lock(td, f, zb);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!zbd_open_zone(td, =
f, zb)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0zone_unlock(zb);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0zb =3D zbd_convert_to_open_zone(td, io_u);
> > @@ -1951,6 +2025,10 @@ enum io_u_action zbd_adjust_block(struct thread_=
data

These zbd_open_zone() and zbd_convert_to_open_zone(td, io_u) calls must be =
done
regardless of the condition,

  if (zbd_zone_remainder(zb) > 0 &&
      zbd_zone_remainder(zb) < min_bs)

Your suggestion will make the function calls only when the condition is met=
, and
will change the behavior.

Except for this, all of your comments on the all over the patches were valu=
able.
I'll reflect them to v2. Thanks again for your comprehensive review :)

--=20
Shin'ichiro Kawasaki=
