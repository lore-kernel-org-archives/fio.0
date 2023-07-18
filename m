Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D77EEB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 13:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjGRNzR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjGRNzQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 09:55:16 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26C598
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 06:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689688513; x=1721224513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=thv9HCBzg4Lqhqg6cgr6kBpEe63oTyu61ny75V5MEQk=;
  b=JZSacena2N0qSS/wFBQ36bkcfVGEPg/1vYIQV5GEIjl4+6HJQ68g77Ab
   nR1MCbbtpAQW3bIITtXVhV9MkWKzcjbBenGQoJO+Fgzc+PftPWXOEKLQh
   LmbgndsD3IfN/BUzL98KcpAkjMlPF+u9yithRU0g2LWXAiHw93X6lCF+l
   lR/0EIigFDy8NvlmPYnM3gs0pv5KjX4C/kisBMiQvEntHWbuDckf/JMTc
   9+fHt5g6xyKai6SEL9x+1hQ+gUAvKp3Wnb9RR/jLQ3dHE2qhxsLxwrlWQ
   h0CmWXBGOlINiqMxuiTqkcixrtP0dJZrR2Uq2dRoqr6yxH44IR2JadpT/
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="343489023"
Received: from mail-bn1nam02lp2044.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.44])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 21:55:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rs/EX7yNQMLGSY6OknP8+IiCBoItPcd+7YzJEc5zLI9q2BIEFUfDOoP7mOBiDJisF4TGfpRpemUiUItzbTiwOpbGILXyQ5afLaZ7ASPn7FAHggoJdLEwngBARXJ5RV46gXfSD5u3fOtXfZovxa64ABxsm2Vn3uuGCH46j6uTS4BluOALrIEHR+x/p1KMKQqLQ3DlgjV6mVomoMPO7UzX/6C25e8qdPKnc0tCVVfFZoNRJLJT2V07Fw8ZUYv/pFnncVUrTNskbS9gfX/bzQUvKXgVGQWqboxBDirmRLtKvhbhf3m69WmK54nrIICCixWii1VGPtcHZGPOmhB1yGHKVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnSoSc0Ada1nlfKMzxntKcNW65tBFnpsLUqfeaPlh+o=;
 b=DLLZROlF/QBJN5PsEmP0ZgYVJFvUXySJwQHKRDfQlwKVWUB5JaX4HfCmgL400Bs8Zlyy+LnHquIaqbPtUVbOPAncGcjvvBeXTBg6zPATdyCCUP9Av876OFac8kDljnlXK84Z35j+y6MJ32XOe8dPTsU6E0Cixp7Bk00LYVTuoi0E+W7bN12QscXSWtjQw2BygchR5KPZUitKm6Vyc/Mknvu0dXeJGcL17vPqNSrMnzBfssqOZKU1R4SLFTyMHepmLGSiIQZ0bLJAwxr/dbSp4MHHrDhWy7j2XAVgIs5sWbFfNnJDW6Q6CJOQb2ZtawO7uVzKNtrgVMV0TkuYdfBURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnSoSc0Ada1nlfKMzxntKcNW65tBFnpsLUqfeaPlh+o=;
 b=jlIjvSp02CZBHyJO8hc/f8rVtaIwI3DgsD21mhlZdZ3pnNbVTuLvytq9K3EjbmzHKeMelVXn5jMdNpgFb1KEKwQ6roQKflmRAiydfpi6ha8GDLHLcZJ4QRaPAtSzkqsrvsd9WtGU4lN/iAD8cDfVfZgP0YxezgCCD10MMvk2nkc=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SA3PR04MB8748.namprd04.prod.outlook.com (2603:10b6:806:2f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 18 Jul
 2023 13:55:10 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:55:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 01/13] zbd: refer max_active_zones sysfs attribute
Thread-Topic: [PATCH 01/13] zbd: refer max_active_zones sysfs attribute
Thread-Index: AQHZsIFB0RRLjyezikKRNbL7xSZH0q+/neaA
Date:   Tue, 18 Jul 2023 13:55:09 +0000
Message-ID: <ZLaZuZFe5oQBWlNw@x1-carbon>
References: <20230707031505.3468915-1-shinichiro.kawasaki@wdc.com>
 <20230707031505.3468915-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230707031505.3468915-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SA3PR04MB8748:EE_
x-ms-office365-filtering-correlation-id: 2e895f8f-ad38-49cd-7a42-08db8796999d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b4Clmx04DWAlY15g8SVEsL2Z2srB4fB4JlyckUMpc76BSEUW03gl+lLXcH7bn0OsRVAfjruGy/M0sCkozikJoK3vRrxhtjOmVGTs6k0qt98D8zB9i3+b6bsDnldx6E/zlR042BSXmiFFKoLOAT2SAN5HxdW9cSvW/Uzv9HY5zsz7zXubmfKGfwJ0vMxF6JfIWjhPXjN6QCTPtzOCPwRwoyE+wUAj8h15bz2kqg7ypHZ4dzfCh3C9g2H5FoQg09U9zEr6UULnodJSxM2VbJd++QF7A3IvON+sOQPjaSHHnkhp6Vpf5DW73xSlb6QeV0X4B60auU+UyQ9/bOvzfJoNV0BLwvEZhUma/oNpI/jFpveOiCLgLD2N3wV3HzwKd6WCrbTlU+jePygDBQQj9xjF6uvhNnXnyrk+S3GHqbUEQc0hzLES3TWzfGr0CBV4CPIhQHp/XbyDQbNhFl+vka263T+PnwVDvTZFry4RkAxlQT1BBGy9PGBuX9LphBWsweLBb2vOLAZ5A2tgGhL9IJvUGmK6NYsoHxiQKwzQyEKvsLsVYeBidj88EaM4WL4s67z6iufrCtU6dWl63gTwiQR4d0IGWY/nZynqUyEvmracRx5zD6RIFQcObQ59vYaoG3mr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(33716001)(2906002)(54906003)(6486002)(71200400001)(478600001)(76116006)(41300700001)(316002)(91956017)(66476007)(66946007)(66556008)(66446008)(64756008)(4326008)(8936002)(6636002)(6512007)(82960400001)(186003)(122000001)(83380400001)(38100700002)(86362001)(5660300002)(26005)(6862004)(38070700005)(8676002)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+On4xQQWjHDxJH9xpOiLSMRJD3eAw9vXAo5VBWkvbJwvCpVJe85gp2bcOv0J?=
 =?us-ascii?Q?xt+DCHppsbUPV7l5aqTv/m8R0xBdR1bdwwv5FjDy2sbYkFS63BP9kiKfqRcM?=
 =?us-ascii?Q?McYoEQtMkOLvQn9pQBjXeEA7Hcqrdzk/JM1TECiGRkf8zG9oxt41GfzNDyej?=
 =?us-ascii?Q?nPqSkcMaVr/L+yeBnebZNoxgmWGaGusP8U0aqYyu0k+5zMwQX4XoOIgHk36x?=
 =?us-ascii?Q?DdsOsc/QqAc0ATC5zNPgqVcizb6IrKZaJ8I7+nAO3gNKBOKi81N5vaFRfma7?=
 =?us-ascii?Q?ld8X3ZUQ59PovSKlBgECpnF/4oOXuHHsvxuXJTjU3r4XUJnX9ruJkANLsoFY?=
 =?us-ascii?Q?ZPCmxB5gwPsJqVweS7vbzT8fYzFXQyTXDmAR1bbIw3HIKwSEaEx/H79KGRHw?=
 =?us-ascii?Q?41iyQy+21Rg4zh/BsQHvB2zbDLgOFzluG9F9iiQ0IIiuDLF3oFVM17+FcKdn?=
 =?us-ascii?Q?FJddS8VjouEJwXjyMPy+05aGPQze/g17uGjBP3W4wyosw5rypkd55LY0qLsQ?=
 =?us-ascii?Q?SwHZIegG6hduuEpCeBMERRxoTPeXFw7D40c91VFIAXtoIUnbsjH1bq0Hm+7R?=
 =?us-ascii?Q?46ilYhhAfkFguxZBsH34HFluOwxBt3OBpjCZjj8/Ar64XBzQZyuoigMP4Zu7?=
 =?us-ascii?Q?p7YTY7AieOuIl6ryymyQwYMgqLmVMlwHQLHBllOEEpdazhlYckeEh7sTWoD/?=
 =?us-ascii?Q?6OyY0vRYUSPTee5UbjQM04Sbm8ce5mfvmj/Ow3Wdv2WYrsD0QysN4yK1NjPl?=
 =?us-ascii?Q?bB7/9jzOIIuWmD4ZBgk136s5KvjYGE1L2Bkx7xRbIPwXa9YbCrfFvzLUpvp5?=
 =?us-ascii?Q?Lrjsy2jzHFgDRdSvflio1M0qrOHo6JsjT13iFucQELhKeWhy6omiL3JbeXR1?=
 =?us-ascii?Q?5aj5qwiif5ki5ILinwrrnkXyBD6BNedIettYHB9crN8oJIO0oe40VIoPg/nd?=
 =?us-ascii?Q?+TSVqj0D7r95FU6L4OKGsw/WyqcIqPMA1faeLxWpmu4n70ejXvFdYqgPxPek?=
 =?us-ascii?Q?pcgAR/iJ8EsTXVQUNkiA+ZcyCHO0vymjnE/TnPG4qoukCmc6diDSWGUvluvF?=
 =?us-ascii?Q?mEY7EprQ/gHQSmfAJmWXnmpdossduTl7k/YPME19qULmE8b6G4aeU0D8+l24?=
 =?us-ascii?Q?1UOYIInHx6fuggj2VUC/VSaDSDhgVrvyuvxC77S387tSC81L0HtWM/EKlEsp?=
 =?us-ascii?Q?KGbMd2TemtEVZjgF1m8HlY7tqf5n2mjxrMJEqwxNh8uhPlemcRSno8OEzFmo?=
 =?us-ascii?Q?lbsW8+xJ1UI0iF2V1ohatCrrom+knVemGf6yGC5+48BTkmvVT+jvWR0cVWcI?=
 =?us-ascii?Q?Q/pA/QCpGFZTXln/UpN4hJteWPpZwPXKDSbSFPwyHUuGJRkYSQhrBKiR1lh0?=
 =?us-ascii?Q?A8QDh4k3uCcak08piPXp159eo3RQX24Kt2vUIbVKM33i1ffzgFObYC913pMj?=
 =?us-ascii?Q?VYsKvmXesk1yqvmLE5ap6ZqpyXSp8451gMBBVV4KkArU4cUhx4qY2KtrKKXV?=
 =?us-ascii?Q?BanHfpfpr3PIYvW3OpcPFeouqeo81EwPhvYjG3fMG+9L6PKsxRZSV99M6Q1Q?=
 =?us-ascii?Q?HY+/vqLtYABT9iOSCJQExZ6MZ2iJoS9lT/o3TJr4fKcB0xu/7Q/P2s5TEMRd?=
 =?us-ascii?Q?2g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <078BCF3F24308F4E98ED97E26F3D1047@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7fXg9DKlvZuh2+DjKhe/ACbtzERg3sKX9KTvfCHVKGomoetWCr/vsJFc4d58+ezrnoo1Ho0pnL6hzX0fbrGgcLn+Vy1b0dwSIG8X9ydDNRnSEBDwQC1v940g0J0Sm6nkfFY+67PcBRE3n+Wr+SFolZoU7QaC1SB2xbnZ3Sfy0TC0FYdT7sDNimEiKT8Yn7llXYMEaOwOnFlFnck4UWOvCvs/J6pLvBkv70dhbgOymu/kFw+6YF/Y1jKqCK5QVFsPWxF3bqvtw/VLWdo8EdCYQplWp9yF2Ski6iaeXyBxPKm6NJFl/uTuk3JiazVHdpGAal1FRClHBXgPCAmSRMIR9369btVKEuNeAdi1qaFuUIp6gXQIvw5crsIT1K3wKVQLepzUVs/9/bTE0A5upKAKJA9CDjO5PNkW+PEJ+YS53OyVKBvDrsyFAuTXraey+4KSHAAI/+xYKKE3/BE9Nmx4TWBskSOwc56Lz5FBcTXqcjn8Z84gUSKjfHxIdKuuvcL5KxQBLRCC/YBau3e75eJbXkJlNdY402ZmUZ8ChV6K3DwZp7Q2/h5q7O9WUb/BUMCVaCmuaCcabeu+ubd0rLpRqVn42/5JPslgFqyu8Zez6AHNBgcLQ28djbNa8ktO7yrmEi2MCXSYjkUYCV1+6JLdyPI4xRtZQiO5VAfsiJczjmLbazaa+BLlhJJF5z7UFf4VWDZS7iHdd0D3o4Op7qSjI2c1DeIzTnKlfVWOK6qj7dxuRdCVez1TIkgiUFbriB5c/+yS1uCCwiCGHmRSMFm6Il6U7zPE9s+UjCoK7GBuXuY/RGJBLStBjOvak/9w91io4j5ht0JJ80agxwqCcb9HcTptYXARr1pzWMBCDqJfDUI=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e895f8f-ad38-49cd-7a42-08db8796999d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 13:55:09.5113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WiIdQIuV4pSd5AZgHfxoS0hym+WrUc8DYIBhSiL5GXQx1JpnHuKEEcD/i61KXk0wQFCk4cNAuQP0t5Ftn3N5Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8748
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jul 07, 2023 at 12:14:53PM +0900, Shin'ichiro Kawasaki wrote:
> As a preparation to improve open zones accounting for devices with the
> max_active_zones limit, refer max_active_zones sysfs attribute. Then
> keep the limit value in the struct zoned_block_device_info.
>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  oslib/blkzoned.h       |  9 +++++++++
>  oslib/linux-blkzoned.c | 23 +++++++++++++++++++++++
>  zbd.c                  |  8 ++++++++
>  zbd.h                  |  4 ++++
>  4 files changed, 44 insertions(+)
>
> diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
> index 29fb034f..e598bd4f 100644
> --- a/oslib/blkzoned.h
> +++ b/oslib/blkzoned.h
> @@ -18,6 +18,9 @@ extern int blkzoned_reset_wp(struct thread_data *td, st=
ruct fio_file *f,
>				uint64_t offset, uint64_t length);
>  extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fi=
o_file *f,
>				       unsigned int *max_open_zones);
> +extern int blkzoned_get_max_active_zones(struct thread_data *td,
> +					 struct fio_file *f,
> +					 unsigned int *max_active_zones);
>  extern int blkzoned_finish_zone(struct thread_data *td, struct fio_file =
*f,
>				uint64_t offset, uint64_t length);
>  #else
> @@ -53,6 +56,12 @@ static inline int blkzoned_get_max_open_zones(struct t=
hread_data *td, struct fio
>  {
>	return -EIO;
>  }
> +static inline int blkzoned_get_max_active_zones(struct thread_data *td,
> +						struct fio_file *f,
> +						unsigned int *max_open_zones)
> +{
> +	return -EIO;
> +}
>  static inline int blkzoned_finish_zone(struct thread_data *td,
>				       struct fio_file *f,
>				       uint64_t offset, uint64_t length)
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
> index 722e0992..2c3ecf33 100644
> --- a/oslib/linux-blkzoned.c
> +++ b/oslib/linux-blkzoned.c
> @@ -186,6 +186,29 @@ int blkzoned_get_max_open_zones(struct thread_data *=
td, struct fio_file *f,
>	return 0;
>  }
>
> +int blkzoned_get_max_active_zones(struct thread_data *td, struct fio_fil=
e *f,
> +				  unsigned int *max_active_zones)
> +{
> +	char *max_active_str;
> +
> +	if (f->filetype !=3D FIO_TYPE_BLOCK)
> +		return -EIO;
> +
> +	max_active_str =3D blkzoned_get_sysfs_attr(f->file_name, "queue/max_act=
ive_zones");
> +	if (!max_active_str) {
> +		*max_active_zones =3D 0;
> +		return 0;
> +	}
> +
> +	dprint(FD_ZBD, "%s: max active zones supported by device: %s\n",
> +	       f->file_name, max_active_str);
> +	*max_active_zones =3D atoll(max_active_str);
> +
> +	free(max_active_str);
> +
> +	return 0;
> +}
> +
>  static uint64_t zone_capacity(struct blk_zone_report *hdr,
>			      struct blk_zone *blkz)
>  {
> diff --git a/zbd.c b/zbd.c
> index d4565215..9743b60e 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -922,6 +922,14 @@ static int parse_zone_info(struct thread_data *td, s=
truct fio_file *f)
>	/* a sentinel */
>	zbd_info->zone_info[nr_zones].start =3D offset;
>
> +	ret =3D blkzoned_get_max_active_zones(td, f,
> +					    &zbd_info->max_active_zones);


For max_open_zones, we have a get_max_open_zones function pointer in struct
ioengine_ops.

And then we have a function:
static int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *=
f,
				  unsigned int *max_open_zones)
{
	if (td->io_ops && td->io_ops->get_max_open_zones)
		ret =3D td->io_ops->get_max_open_zones(td, f, max_open_zones);
	else
		ret =3D blkzoned_get_max_open_zones(td, f, max_open_zones);

}
in zbd.c.


I do realize that the engines/libzbc.c ioengine will not provide a custom
implementation for get_max_active_zones, since max active zones does not
exist in ZBC/ZAC, however, perhaps we should be nice/consistent and provide
a .get_max_active_zones function pointer anyway, I can imagine that the
in-tree ioengine engines/xnvme.c might want to implement it, and I could
also see the out-of-tree SPDK ioengine plugin(s) wanting to implement it.
(Even if introducing a new function pointer  means that we need to bump
FIO_IOOPS_VERSION.)


Kind regards,
Niklas


> +	if (ret < 0) {
> +		dprint(FD_ZBD, "%s: max_active_zones is not available\n",
> +		       f->file_name);
> +		zbd_info->max_active_zones =3D 0;
> +	}
> +
>	f->zbd_info =3D zbd_info;
>	f->zbd_info->zone_size =3D zone_size;
>	f->zbd_info->zone_size_log2 =3D is_power_of_2(zone_size) ?
> diff --git a/zbd.h b/zbd.h
> index f0ac9876..a5cf59d1 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -52,6 +52,9 @@ struct fio_zone_info {
>   *      are simultaneously written. A zero value means unlimited zones o=
f
>   *      simultaneous writes and that write target zones will not be trac=
ked in
>   *      the write_zones array.
> + * @max_active_zones: device side limit on the number of sequential writ=
e zones
> + *	in open or closed conditions. A zero value means unlimited number of
> + *	zones in the conditions.
>   * @mutex: Protects the modifiable members in this structure (refcount a=
nd
>   *		num_open_zones).
>   * @zone_size: size of a single zone in bytes.
> @@ -75,6 +78,7 @@ struct fio_zone_info {
>  struct zoned_block_device_info {
>	enum zbd_zoned_model	model;
>	uint32_t		max_write_zones;
> +	uint32_t		max_active_zones;
>	pthread_mutex_t		mutex;
>	uint64_t		zone_size;
>	uint64_t		wp_valid_data_bytes;
> --
> 2.40.1
>=
