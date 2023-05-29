Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5D5C77B7E
	for <fio@archiver.kernel.org>; Mon, 29 May 2023 12:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjE2M5t (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 29 May 2023 08:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjE2M5s (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 29 May 2023 08:57:48 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB58799
        for <fio@vger.kernel.org>; Mon, 29 May 2023 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685365066; x=1716901066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TIsdg0iqEMxchpAcV/YMB4c+hpqFqlPcKppxTIq3fAg=;
  b=SXVDzM/8BeuFtit42dPB1YWKoM2cyEVHC4p/Z3wBrpqO8KZc7mCOtng6
   zyeWYDoG1JBwgJMkhTm6WmTyHsB0NTNSF2oCWuRh3Ge8FVIb2oSJ8M6hv
   HN4/Q3MvJ4vNSI1Ua9PQLM5YP1wZSRcqtZj7V6dj6Do0Tg9WHr7YPkUJt
   Rb9Q7gnkJtoEj0nx+IY1H6+/aRk9d75rsPlgsEja6cFflSmp3Ehy9eY1n
   7W+LmiJoceCcn6QMIDotqQFB8DE3MuLvEu+kY+5zahqWmAGkWL5r3AlOp
   FRzgQBt+TXg7tiRaDkMBGI6POi+0CfBk4GFTrQK2by1fQT2XtvCl3DHV1
   A==;
X-IronPort-AV: E=Sophos;i="6.00,201,1681142400"; 
   d="scan'208";a="231816491"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 29 May 2023 20:57:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxH0x1hJusOARRMSzeacy9SSI2yhkq8I1O9yABm6jCoP7TFzcsYWRcHvxBAbzxRhnI7tbLg/G5yfZwRXEhTT+Kaz7R/jm5QUR5eHGhb10h6QwJYwjlAkrCyipFHIYnIi7JN1BzRIEOyS4uk4gLFxOzhzUsO1xnekZH8K8vbHxomUe7v4QE0SdwKnkL5ILABsAQDMSJrLLosaoATMVHfPL2/aiVPdq4lvrdqbare0XDqbIP/SMLSeqywBxB21mk4bqxcHyd2pCUUJut4isKwD+emyfuEkjMrFVWG7Ch7QCwaOEV6BG3gWzOwZRaAiIilhb/ybUWLRdBX48zCBD3tuRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXB5+LfcMZMpTiWo7GapACwQBX2Nl0OBjpfIToGb/fA=;
 b=l8BBfR75e8i9zJ527Jphdbp4fRYoAtk9lzY8R53I+u1LNVP528O7UXeYJxJ6lglxiuZtdv7R2l5BAvMiGsByQrFAFdgQqhRrhKXegpWqsbx7+ghdn7uNtfq5I43puHi5L+xnjBFvWDAamsFVEFubuJjU7Fpnw+tmcANTGnB5DTuWf/gk+JTmGwEBK3LA3HSKdmpzvQPaTlSo88nwqcSrW9DXlK9m8EH3Nwr9bhBHPYMswTgqjyCNwvpVReXGx9lpXLd3k79zGppVXj/iJqfuoqA8EuRaZ6JGj0Fy3f37Yaaz5RSYqWOiCkYaCwSQHJAnnL1zIH0U/QIrx1iFJxfgBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXB5+LfcMZMpTiWo7GapACwQBX2Nl0OBjpfIToGb/fA=;
 b=yx3BwQee+5RdBl0QLDh/gq2IU+ryrPk3TsI8WDIpDsgemKiPcy/UkfJLV2Vmh4dQHqbV+7rDsv9tHpTmiXg+ZnXzuKYzhVTxwygA4YVmJa/6X9cBJ5CFJvvChB1FX4WTW5DXc9KeOx8Tn+BiYe/eI3rasI2KdsEYVhvegnhUAvs=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6641.namprd04.prod.outlook.com (2603:10b6:a03:22b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 12:57:42 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 12:57:42 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "jashax64@gmail.com" <jashax64@gmail.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "dlemoal@kernel.org" <dlemoal@kernel.org>
Subject: Re: fio reports "io_u error: Value too large for defined data type"
Thread-Topic: fio reports "io_u error: Value too large for defined data type"
Thread-Index: AQHZkBdHSZIYAaMAFEi9D5EjpcxtwK9xOhqA
Date:   Mon, 29 May 2023 12:57:42 +0000
Message-ID: <ZHShQdVGkyRfd6v0@x1-carbon>
References: <CANvHRkAN5_rMb0gZbo+EXQVbNxPrSDWTnFGsSHCb3+o5AZd2VA@mail.gmail.com>
In-Reply-To: <CANvHRkAN5_rMb0gZbo+EXQVbNxPrSDWTnFGsSHCb3+o5AZd2VA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6641:EE_
x-ms-office365-filtering-correlation-id: 158b552a-1608-4d42-72b2-08db60444a39
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iDlwgjBWp7/665HblL1e0OMwqli6rHuY6/NqHk7VclX1+Rz+66VuCLoLGuJgEd+vp7MfH/iP73aPCPK+lX0xpVu5OIIGoAfTTZjGQenubQdeu2t3f4y3PV7OjcWqXRZnHgc9wZvY5OGV7YH1r1A9eWoyEOx/dfXPdr33OHl2rA/xhjxQ6dG3K1i/pYImS24VKAC80Ct6XxDOwCButGxxpTWxrsIJL7QYbcYljrMS6v8PE9Bq05qPxmalOg1UObPvF37Wn5RgUDb3iwMfPNkx0Qb4fRQGxVAOBLdNksMDPqfcyrOmKIs2dHNdsviSVm89POhtwFdsFbSQ68XmTahN62dOpadIPa3ECZLC9rFmrrtq1KoMJJ75mLZTDd8pAXJxCyIGn7wAWY6+jL/6DGoJ1PGzh3l3suQzsSIsVYVnmyt1sNCLphkfRYc1oBA330K0pM13YJTWnu5BaBIPLUGcGoqfCHGAPyEdIYKEMTR5Ee+LVm5yf76WHHOxINXgDF3zXn7F3MUH227LD6tKb3p15USurdGoD70FOnnFgS2XsaSeeMyNm7TqYj2qpiNfpz1qZSPLY/VgrMfm0J81j/v78rl4/i4ol4CFG07rRMwStakYs6RaX6XZCCUqYbtXhJ/P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199021)(2906002)(186003)(6512007)(26005)(6506007)(9686003)(5660300002)(54906003)(478600001)(8936002)(122000001)(82960400001)(8676002)(83380400001)(38100700002)(33716001)(6486002)(38070700005)(41300700001)(86362001)(71200400001)(316002)(66946007)(76116006)(91956017)(64756008)(66446008)(66556008)(66476007)(4326008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nbf9LjtphGl+H/pXyZk5uOHEpy42DCe/6HIxsOxxTAVak5IG06HQAWsO09dg?=
 =?us-ascii?Q?c3tY54/pAHDOijYHvukD3iUdb4rKs+5qupyVS3sp+mzp/+yVgqIYFOWJ20hR?=
 =?us-ascii?Q?U+cisvICMEff0Av+7VDZsrNj6hFLUYS3vT9j7Lcka0L/oPKwMImSsntUFd4T?=
 =?us-ascii?Q?STAA5+9I9sotEt1kgBe+x5DvUGozpJkEBglFady+GWlg8mDQ2ZU4HuPhX2ce?=
 =?us-ascii?Q?pNfibxFoWRtam/pDy/2A43Fm4qEty7zLngjutLIusMPAYrL9ZepfKxItlpcg?=
 =?us-ascii?Q?yg5k8JrqdYparCBgl7tRhoVm0oBrr1qKi2UJl0lKUZ3ffljodzhrl20Ekvrf?=
 =?us-ascii?Q?RfXvkoxIeStHXgsouXQkBS22fWvOegBpEDwB1P3imFPgBn75YZfMvpagJgyC?=
 =?us-ascii?Q?wTIlwD1W6NLnEsksCSMaj6LsYS65s+6wKtAbw46fVgi+Uoji4kAr2nRbix17?=
 =?us-ascii?Q?T8MUVddy+VDP9YL5j/u3D4c/cDFakRBFbyz2DhaB1DemY836kzCkxDrhuOge?=
 =?us-ascii?Q?bqz+pZkEeNINyXpII47lESxaGEmzwuceIVCzwbOlDxHkCDacqauvxafvhSPN?=
 =?us-ascii?Q?I4G0SrA467APTV0LbPtr2YslebL3FBZJ71CvUQd6rEFHkv1/sG9LWmXZlzQ2?=
 =?us-ascii?Q?2KtngOe3cnuq2jzUrdIBcwCHebD48VEfalb2cUGhEg6C9EjcdMrHvRqbUos9?=
 =?us-ascii?Q?dUjIZy+S/9Gn5WAdU6ZD9Yte4TqjhTwUfem0beuvi9GPBcI4/sC3c9qfP1XO?=
 =?us-ascii?Q?y4M852Sb0v3fNooHGJVucSsh8E2Z/hcV2cZrhbQr5gCCMvY1UPXWjpxqdrdz?=
 =?us-ascii?Q?B/DUK8hiN67xCTbGX4dSEiqBabcSS8ebYqNlM1L5ki/shvjQmev8kaUqjYbk?=
 =?us-ascii?Q?AuE+KPyWLpuOyvq0Zi3gxUHfUU26rggkuxNAKcTJL0WUcF4i3xHr+wUefRhq?=
 =?us-ascii?Q?yAVpH4jET89+m0Y+/yPGZoQrjvMEDFXZrgT8yioXjQh2xJhdXiZN8ohpde+t?=
 =?us-ascii?Q?jRTIBkxLMul181ntCqv0w658E0YH0UNmJZvmPCr8pxvd5p5UOgm4PHWXDP3V?=
 =?us-ascii?Q?dSPo9BXzzayuBgW8veXHdcA921MvisSCgqwpZKbebxdndmohpK4triS3RuYu?=
 =?us-ascii?Q?nfog6qQMDyGC3i8DGcaED+W3L0ioJv0dGWcEO2kcrpzFb+RNxbqfO+ljLz10?=
 =?us-ascii?Q?GHlKcyCeDSQMZDBLlodkd0bSIjIJ3cdEhO1LQB4acIhN3cTMLGm9b/2Ie/4t?=
 =?us-ascii?Q?n8TAfCNnTm8lLR8cm3Jqs5FUhsIjoMNn/iqR8/83ZCwWdYoiOA2hmA5ePXhe?=
 =?us-ascii?Q?UJm8Bfa9eOKZUW2Vaanxty2uJTBuE+5YV0YT9YW7DARKhk4IAYipieZKUCK7?=
 =?us-ascii?Q?m9qq9Ufln//iIrvsMn4JBbwYqyFCdlJgop3ddClqBBnakfGmMQgn2NdtHMfq?=
 =?us-ascii?Q?C9b0OJKLqVkyBAujFBAvnIZvQxxIi5OnfY+jYgg5Ye7K5pNKBRcvxQvCymHj?=
 =?us-ascii?Q?nGHbnUMdhe7nd2ZgUCWzl7sycJZRYu+3/TXg9ts8XONoOQYsRBruIjjIrkDK?=
 =?us-ascii?Q?DvJrbePjt7QK2uWno16Jl+Aq1GgN4CWnsQRG1SYbaibJiv4Y/Hhn+vzAKP39?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <133E00631EB02A45A4B2510074ACA3A7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: meNr3mLx40Ph05QBN08NSlb6f5rdUmukdnE8YCFmGCoY1aQ+XJBBvITAk9N8dpKIymc8uuru+EeI0sGalpqbTLEejHvhSXisv4U/9s9v63W1bEJRwEwbrjK1VWQ6zGxAvCBiOGZjPkjrTIGl9mKPhbEGqSn1MXfxVPvcoz8Tly2GQlzVvzD+uioodcmRmc2P1NEDg8iSpy9UYd3J7p8ajbfgZvc8FPj1xUH1LYgI01v8bvP3+e+Bfm+dZwPKwrWxUiRntMR69sPw1LLOfx2G2g8S0lwbo5L6W4P9d4UoSaDExzEtsULFYAb5wS1mGa6n/mRvyLS1ClJYkGBb0wU4xbmVbxH4bAj4AxC+LKdi4llTqlA0GWiOeXq+pSB2BB4jhIu3aLC/kdFJ+XBcxavjbjmfUINLVjbRFf+4NJaIBUlnF7DSCO257GqxReaF1a8nIaoj4aYM4PcWSJ1di0pPFmi3XfwLFhwUzQrqcl/Emogo4ZhatPUXSueXqiDHx0rw7LyNjfkQPeXRWJObt3sK05LYJIQTfvLdCjgpZWJYbdh5Ml/TYEzIBck/WdJjxMYNxh4fSkaEQt72ElPV/qIDjLLeMuOpXE1pciT8g3dXUrVTCbwlbados5Q/EwHwiIbQcR7CcTIRqMOV4ERlNkDcxVJslVwkS6dXTE4aIbdy+M4U5l3SDHgynOnhhXV5epXD2uMaWnVgOuZid4lieQou3dcpfpRXJFCLYZKVWvJQwA4t6muAi7oGJNcnk/7edSt5PAq9vnOiDNeHt3q7JUzyTXOQwjvw71t9iFF1GBS4oe2nEN9zFtoTFFoUG6gasUQ80431ej5L11XGlCtoSZ8d+g==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 158b552a-1608-4d42-72b2-08db60444a39
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2023 12:57:42.1813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3+Detfb/f5o1WvFJL6DamLfFZbyymX0rBYVZvmCLso3tg38LanhcgXeqVJn7mFEijY0A1uVm9KbAnw0tBHcgQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6641
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, May 26, 2023 at 11:15:13PM +0200, jashax64@gmail.com wrote:
> Dear sir or madam,
>=20
> fio reports an error "io_u error on file /dev/nvme0n2: Value too large fo=
r
> defined data type: write offset=3D51539607552, buflen=3D65536" on my comp=
uter.
> I am using Western Digital ZN540 1TB. Do you have any idea on this? More
> importantly, **when I ran the same command a few days ago there were no
> errors**.
>=20
> Thank you!
> -Yijun Ma
>=20
> P.S. The command and original output are as follows:
>=20
> $ sudo fio --ioengine=3Dpsync --direct=3D1 --filename=3D/dev/nvme0n2 --rw=
=3Dwrite
>     --group_reporting --zonemode=3Dzbd       --bs=3D64k --offset_incremen=
t=3D8z
> --size=3D8z --numjobs=3D14 --job_max_open_zones=3D1 --name=3Dseqwrite1
> seqwrite1: (g=3D0): rw=3Dwrite, bs=3D(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.=
0KiB,
> (T) 64.0KiB-64.0KiB, ioengine=3Dpsync, iodepth=3D1
> ...
> fio-3.28
> Starting 14 processes
> fio: io_u error on file /dev/nvme0n2: Value too large for defined data
> type: write offset=3D51539607552, buflen=3D65536
> fio: pid=3D76338, err=3D75/file:io_u.c:1845, func=3Dio_u error, error=3DV=
alue too
> large for defined data type


Hello Yijun,


include/uapi/asm-generic/errno.h:#define        EOVERFLOW       75      /* =
Value too large for defined data type */

block/blk-core.c:       [BLK_STS_ZONE_ACTIVE_RESOURCE]  =3D { -EOVERFLOW, "=
active zones exceeded" },

This suggests that you have too many active zones open.


Currently, fio does not handle active zones very well.

I know that someone in my team was working on a patch series which
adds support for the max active zones limit in zonemode=3Dzbd in fio,
but I do not know the current status of the patch series.

A possible workaround could be to perform a:
# blkzone reset /dev/nvme0n2
to reset all the zones before starting a new benchmark.


Kind regards,
Niklas=
