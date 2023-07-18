Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0135C00528
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 13:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjGRNzu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjGRNzo (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 09:55:44 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C123AC
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 06:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689688542; x=1721224542;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jhCTsg0hCtG58uNjM8577uQ0RE3Z7EU+vIwhifZp6MA=;
  b=X3MU1gBwYuYpJjeoKS04FZjgGMjSLRkxu62lxkAfUHujXIHnZS00Cs0n
   8koC/Ie/M70UUzwls0biRS6cD+gugOAL4ZVxfQ1F1iKtYtfliV5cM3d65
   39sVPqAwGtA76cBuOROvlmOLKJDUHEI3OClwIoY5tbs19FOB0mg0IaR5f
   2Ej/csbTuUVQ3fBVgfZuxQFRbjRMn4ZgEYhA8VBq4gpHBBbsdzT4KJ9Fg
   SFIN4nIgZ/mFKuSCM/OdE1jDUaweKPnE69Ddd+fRoVfpz3Vwq9tAVMQKE
   rONGVEHmHdL6SBORmxkJui9SEK71amDypv1ee7Tm6MDACjJ0MAps36XGf
   A==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="236775331"
Received: from mail-bn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 21:55:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3YEhkeeAcaYNBg4W3P8Nn73YGak1F+K4NeqCYxsnVuPKsGr+Uv3z8JEf9pajhIFYLx2ZBV7FJznM2hvR1nS4YlAk0/O6hyDQNWk7VTJf+ueAqrDq86OAvMFmQOJFBcTn80bfLAtIDg9v7unVIBQhNw5uAbgYVtrVwBUMmJu3bkK6rtSq7XsqVMeIP0+g34S8oGSWKh1daTLmt0k80u8ZETIVvv+wWsCST2dSocjsCPVcIqZgc7slKP8ydSo95hHzapsywG5byLRodpZPK4zfZjxNTWPuTGxj1jAzvZxLAtgXqOYE4+zs2aZBe7OWT6gDWDJU50PAWGG2L2/j5ihUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXHxo+g6ULWiUfX9vF0zE/zc2bmNoWRw4DSAD6AdwTw=;
 b=oLz39EbxSpXBMztuwzkadbR0/tbgrzNL+SF9N0C9Gdy2MfiSKWea0StHeS0bHEL6J+uNGnPA2oeviHRVjwmI3Wex8fXeuRvjMANW00fiLTA4kU4lAJvJmb1lISKkTJT1HXKfp4u8jA06BBGodMpJUdnfIuMPgdw/HHGk0V0IG3N8XzSUjPHCy2vdo854KPDK12/wY35mQfHL9ZuTby0zl6f7msqfsB7J2z5ivhT6s3UCyfFzV6yC5U2nGGoIj7mR+0+PJtWcnsShJ51b0JTBqPh/CWsWqFR0f9ekLjk0AG1uQ2BRq/s1EYk7wGir5dWN+cTFPQXJlkg6ERfmJaBmqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXHxo+g6ULWiUfX9vF0zE/zc2bmNoWRw4DSAD6AdwTw=;
 b=gsE8cjlihXJ0jpC2fcmicje+96YWTJuju3jcnf1L0/2pMWSURwRr6NrPBelxhrTPgT41ITXib3O/EDL54p2xD7/Ga1qoGxnvTc9csnoKH6ooh6e5dd9ESxl1udQ5f+rocWqbyp53beY2owH1fZsxDzV0FPDL6CqndtgUf4O4H6I=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SA3PR04MB8748.namprd04.prod.outlook.com (2603:10b6:806:2f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 18 Jul
 2023 13:55:38 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:55:38 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 03/13] zbd: print max_active_zones limit error message
Thread-Topic: [PATCH 03/13] zbd: print max_active_zones limit error message
Thread-Index: AQHZsIFCNi+zI4/4p0aqAa4owRIU9a+/ngqA
Date:   Tue, 18 Jul 2023 13:55:38 +0000
Message-ID: <ZLaZ19LwRUNOSYOm@x1-carbon>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230707031505.3468915-4-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SA3PR04MB8748:EE_
x-ms-office365-filtering-correlation-id: 14dc7caa-3a40-436e-f5b0-08db8796aab8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PbVDs6YqWiVRA2NhSCtJtAvhj1W8ebc6XSoPo1jn8/svfonc3m2wKJKRDYMAwaAPHNp5EWMiNoq+4HQlDlxlh+bPUHZoYHgHdImOQoFs/vX//9ipMfr9tExHApJ5JvRfHy/Cx99mI7iZRTWBJCOr/aupUogUcRGaIbJTAP5Ty9WPdpvnJvIJ/Br8UMcR8rLsdjLSjJ/vKKME/RaEEBGdTvowFUAszvXIiO5YyAHQcJVngSDha1U1g+6z3Pr29dN5R2W4elbycNqtcIhb7hg1iJFXC+W//YevyESBExJrlGdbM3p/O+meusS7AplQuvX5qdktl+2ptDYliIAKQcY6hLyWdDuv+m5Ecx+aWKJUPxRXvdVzPC/swgE6ByaESUSofmOEHS/jjJ1vrjqw1grTAw4vRN6A/AhKBbgXUHRjuoOb+MyeTDSHwjjMCAdOQD2rInG4nCMmAc6TBf7pmW+CJA7eUPuZAx+SHraJfyUoVDnv627KDM9OQM6saj5H/NoQNSdseJXUqmEKtOXpPCnxSpPTlrB6RUEwGFV/1pvK7UCg9rUehM5bXOP8EJMYztFPvHctHAoD3PCCciIg41NpsThhU7vTPu/VI7TB17tuDG7ItIWx8MErQtctb3KS+7Sq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(33716001)(2906002)(54906003)(6486002)(71200400001)(478600001)(15650500001)(76116006)(41300700001)(316002)(91956017)(66476007)(66946007)(66556008)(66446008)(64756008)(4326008)(8936002)(6636002)(6512007)(82960400001)(186003)(122000001)(83380400001)(38100700002)(86362001)(5660300002)(26005)(6862004)(38070700005)(8676002)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u/DD8G61qY6QMXXiKe8x+WgdmYdy4bkqTPhnKg+r19Py7jJUAZjr7T/QEXMo?=
 =?us-ascii?Q?hvH7BD1buYunA1N442rOQfvEbw8gL7sSXyS2GDjd7IVwNXu2GVqni/b96aWo?=
 =?us-ascii?Q?os/snlkYx/QYuaDeTWdtbYZtXizml6kns5QMSiYqT/4JsQz62knd21MCCQ3M?=
 =?us-ascii?Q?g1CIFT2Pq1IRfLjmAUqT0iu5MhFRTWoF6/558UTrbskE7QEk4866sAvENPeb?=
 =?us-ascii?Q?ux6A2VB+J8uiPmVl4c/DUNplpUy3HZIAZqFP3iu7uH/jO6g/MB4fiGWIWnbc?=
 =?us-ascii?Q?2e98xHgATBDV8MnYhAdT6pkXUh91ir7AvtCVTQ+IXSA3Ql9BrZOiVkDeUJWC?=
 =?us-ascii?Q?FcfC3/S3HJYRYKPcoB1307CBQeEmtiK+k66caztSRNjJnsAw0aLWuPX/mRvQ?=
 =?us-ascii?Q?citEtZipZzv3tHZLGrBMXxRuDdtzFs24JeQ+Eh3TSbaU+9Zago1CufjoG8e3?=
 =?us-ascii?Q?yElQoud3AaHVdwEd8OA3KXqTQN+AGXMkL6r48hAjoVQU5D7HzoHajB9SAYR1?=
 =?us-ascii?Q?A4N+E7/PKZYHf5K09AF4j3hauLsmPNnBJEW3pvHzdF3M+4pfzFs//cHmc9Az?=
 =?us-ascii?Q?/3u7V0kNRuf8/OM1qc4W0v/wlQVMMtiVOc/u0BseBmAOcSQcase9b3UyL1AQ?=
 =?us-ascii?Q?ix/o1SnEaoudNj8OLnW3XpBIRf5fb9mkPEuTyx5KGvSLmBLnPG7I0CdMe/nn?=
 =?us-ascii?Q?OlugZrQsITA0bgn0YtWBwpU/0eBaIPxBQepjbTkO1HPNyvoQUPlqqAtUMyen?=
 =?us-ascii?Q?YgIBcIqaBnl4ZlCBoiQlMFomTQG34Yj5FEjnUFZV4ia3ShKPsJoqE/u8qoos?=
 =?us-ascii?Q?h+Xg+B/4AYBGieA8gxieXqcUTlAgZVXsXiiJ/MZEPc5aSO/M9P+8cOTyA7di?=
 =?us-ascii?Q?2nMje857rVAmwVNFXqCdIj8ysNS+g13fKDfWiJ00426Z0Q+F8pctsnjZkd56?=
 =?us-ascii?Q?54s2df0vjtulyldERXWWqKEBtJgsVbh0FMhjjelHq33h4bRFx56pZCW1b5PA?=
 =?us-ascii?Q?+SVA7b35rGSuZiVKsJcexY/h1ldrhFurK5WjBM98GacIncC9VO8sA4+X9v3D?=
 =?us-ascii?Q?URyUgZxcbdmFdJbQ7DMAE70tsvYsm8nlYoVoVCNfJt17x3DUpp1Fvv7y5YiJ?=
 =?us-ascii?Q?lMXh4l0XV2E+2qHxJPIIR4Eq4WGkTN37TYoO6+30+skMpdpMp6pOm3Xc1RMk?=
 =?us-ascii?Q?OetkjvorcXhVPLAQWp0SxnWi0yDOABl3cjxv+AS4rCNFXWtIHDA0sxrdKd4+?=
 =?us-ascii?Q?poLLayq2zpWKRzGylDLhfLLBHcYsW5QwWlrON+VTcZ2th4RqA3+HvRu2LwWD?=
 =?us-ascii?Q?dhnSrR4i9BSE3528cNneMJhaISlVHpnu18O+BooV+SY5rOH202UsqFhe47pG?=
 =?us-ascii?Q?aldbgdfODzhcZhh1B3GoUofZDAj5cA+MZpysuaLeRx+LqjBaIvTLCuupgTQH?=
 =?us-ascii?Q?RvhCowpMbLWRELjDmGLUwwoGAszrDASvPoEUql6PoTR6VMnC34ib/rhVfn3R?=
 =?us-ascii?Q?ITPID4u7/7upes0QpkA95SiXC25OsTCF71CZozkqqSsaVETG/3GRcTdCdmZq?=
 =?us-ascii?Q?g3cAWcxlyvGh+/0rnjG4YuuJY7LUqQmovCuXM8ONFnOncf5ITraZSkPP8sSw?=
 =?us-ascii?Q?Ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <772F623C72342E4799C7757A9ED14F34@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +v2eb/HvsqLkX/QbdFoNkuyYX328Jv6GCTfA5OnL1tdLZ/61QunfNsKguzptjLIk261+58rMuuYygMgLuwmD04BoLWC3pWDjJCNfGpJmkzsp6B8GbVYvKS3aHOiNp+1Pa1HLjhHzemcgpp24dKTXa8E+GJ1ovRkBkBzagPQuFAUp9XooCivDI22PMHx1LzMFHzkwppg8Vi2pyBz+cME1OVbaxCiAcklI6q8orHNI7Hl6wAGZQbXvQ5D8e9MEwqZaZ04ZN1t7avDrQ3qFNbd8nwI85QG2dXysjDyOU9jnSdF6D8jNd0H9z4TKpK4dzz3PSoeg7kkXupYbOQ9kKkd3rlh/AW3SpsrCDy8XjOpEpnvvkDqWeP0KoVzpYXU1PWO0vMMuM4UvSPBcw9u4D9PEQDwUK++gbHizRwXK3HbzFCYUFt7Ex2V0sfGRh9l81s8W8jFPG7UVr8oVgqiYNfOfN6HfTsKm5CfjfQIwcw3ReDfg5+4au5nfrIk1S7YRv5SKUMIyJpEnu6ExwP1ObLfHGUIJ59VonuTV9CVlzE1SWAwhjZKrSZh3vbGkFOHrGAXQFXgDFuzEm/U1El0lSz6rxWaqjSrCOQh8KxvxMBzKlfBR+vqQd2MwD53BL6b57PeloG19r4lA9DYdCEYZj6TYjcdmBeKqKRkCqvXYwfuD9Udt1P65MGpx8XMM/2+TrDJY39w/Lpjr7HF0oVhUN4mNrGLx/qa1JWGwco+GDn55J3l1FfGvd2xoZ52o9hA2mQs90JiQ4J2vZ2Uj0OHBzed83mzHEWuIuHlrL0NTJ1lLmTE6E2+61rbnXpy0VogQHEoIqCsGfiMwl3QgMNIzNcD/oVnuduCgqglcb/kwgRdhlsI=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dc7caa-3a40-436e-f5b0-08db8796aab8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 13:55:38.1880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4j9ebcNyBWFxUdbLtt7evs7q1FqF6P52PjKXLgZ9Oq0ht/dDiTaTMW9kMo+OU+3Of8BnhydONu4DevFmxpUag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8748
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jul 07, 2023 at 12:14:55PM +0900, Shin'ichiro Kawasaki wrote:
> When zoned block devices have max_active_zones limit and when write
> operations exceed that limit, Linux block sub-system reports EOVERFLOW.
> However, the strerror() string for EOVERFLOW does not mention about
> max_active_zones then it confuses users.
>=20
> To avoid the confusion, print additional error message to indicate the
> max_active_zones limit. For this purpose, add a hook function
> zbd_log_err() and call it from __io_u_log_error().
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  io_u.c |  2 ++
>  zbd.c  | 12 ++++++++++++
>  zbd.h  |  1 +
>  3 files changed, 15 insertions(+)
>=20
> diff --git a/io_u.c b/io_u.c
> index 27b6c92a..07e5bac5 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1879,6 +1879,8 @@ static void __io_u_log_error(struct thread_data *td=
, struct io_u *io_u)
>  		io_ddir_name(io_u->ddir),
>  		io_u->offset, io_u->xfer_buflen);
> =20
> +	zbd_log_err(td, io_u);
> +
>  	if (td->io_ops->errdetails) {
>  		char *err =3D td->io_ops->errdetails(io_u);
> =20
> diff --git a/zbd.c b/zbd.c
> index 3069ad1d..047489db 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -2222,3 +2222,15 @@ int zbd_do_io_u_trim(struct thread_data *td, struc=
t io_u *io_u)
> =20
>  	return io_u_completed;
>  }
> +
> +void zbd_log_err(const struct thread_data *td, const struct io_u *io_u)
> +{
> +	const struct fio_file *f =3D io_u->file;
> +
> +	if (td->o.zone_mode !=3D ZONE_MODE_ZBD)
> +		return;
> +
> +	if (io_u->error =3D=3D EOVERFLOW && f->zbd_info->max_active_zones)

Can't this simply be:
if (io_u->error =3D=3D EOVERFLOW)

Since I assume that each BLK_STS_* in the block layer has to map to a uniqu=
e
error code, so if we get a EOVERFLOW, it has to be because of a
BLK_STS_ZONE_ACTIVE_RESOURCE?


> +		log_err("%s: Exceeded max_active_zones limit. Check conditions of zone=
s out of I/O ranges.\n",
> +			f->file_name);
> +}
> diff --git a/zbd.h b/zbd.h
> index a5cf59d1..5750a0b8 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -105,6 +105,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td,=
 struct io_u *io_u,
>  enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *i=
o_u);
>  char *zbd_write_status(const struct thread_stat *ts);
>  int zbd_do_io_u_trim(struct thread_data *td, struct io_u *io_u);
> +void zbd_log_err(const struct thread_data *td, const struct io_u *io_u);
> =20
>  static inline void zbd_close_file(struct fio_file *f)
>  {
> --=20
> 2.40.1
> =
