Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B8AC433F5
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 09:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F0661039
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 09:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhKJJqi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:46:38 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41205 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJJqh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Nov 2021 04:46:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636537431; x=1668073431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cunxYRNcNL5W+F4VJg+mu4l5ylbFRh21BBiGPTIRvTg=;
  b=YyY43Ec+8CbKQ00zUeFOJOg1NsDuaPJeeG2z9rhNyKp4pvyhu4soQcp3
   3NzHgAOA4nlCPRWthfTRLATVCM2Tr0gghhPt2fuChKzaVn6+xU2P8GLe2
   w0pObLI6CIRpH4BxwYmAkBxitHeltl1+it7hX9VcS+U922088H1GO5z5e
   txWY+nVqafdPVY1t/fNczlbocAr/qPzb9ZwXIzPtTr3/3zX8mrn5U7Kn4
   32ATHAgu9EHQCXXk3Rbvxd4IosuYtobbVtj51wQvWFbW8vH8xu7dwWVnQ
   nvRSkKSYkl/ZBeI0ih0RhmbMFbDNH9mEbOY2/OLdmdzqlUy1Ey4G4R9MD
   w==;
X-IronPort-AV: E=Sophos;i="5.87,223,1631548800"; 
   d="scan'208";a="186213926"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 17:43:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8/zEamB+HAVEpATFtBK9aPTJRrM7tiuWvhumTEIb3nJ+yW6OwuthtU3F8aCr3qEN5IKSvtbB9RLJCWBUzFCY3OKfWbkOh6mInb3+SO8GRtZSzU2wFDJEaD52lvOEugsG4Bd1KFEij0zrYnmGsYdh+9tR/shZeyYu3oALKuCiKSlqd32J8lwaa2ot+DMolPpX4qiuWVm2elI0B15HciSJPNgSho63/s82j+VgUOocyuff5YZDqXT6onsOes0NQMDut7CErgYzK7rEQ77HNWlN19mUnXSigHU1/el8zyIxvPU+InuP5jWSG7SwZMHJnfryIVbMRpkNQbRxuSjXNKK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EnsEOFQxDCZHAhdPF2IiazvVeRPNKNQvozQUoxfqKCs=;
 b=ibox6y06W6sBmPa56/RAcOlp4gqf0Khpk5d7iTXubYVvOMiQbt5A/4/YziksRGeOKQ/i5XvG/jzIfoK6c7HZNNECu+mdZ66Ph5k9Zww8+JP0uXGXq+45pxU+inV+L89+gbhnkTCOfAYSIOqmOz/rHh6Alt9T8wyV7sZcC3lrucisCB58y5oqKzDvkVymaAbtZAUSEmwpUXPUpnDR/zqyfdysJJK7LEXc3cGvTh4W+pxk1xGv7MgAJfRqSm0Pe4v3pdOzU+1k7lFg8g6OzwOjmZ2hEp5FU4XyTxMWG3zEKzDd6v+3JAMJt74P4rkPoXR5DD3m0t/5iS0hE7j3bzdCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnsEOFQxDCZHAhdPF2IiazvVeRPNKNQvozQUoxfqKCs=;
 b=xrs9nvkS0QBlH4KJRzKG/Jfkv/q51GF+CE1b+yI45ayntN3bHJU6tq7oLSljsH1a/6VJvdfgBGGdnlt7+67MINbksed8guHRiTS9YL1HMZ0YUjSXAnd/rCF2U3Vz72X60Y8dUmevFhrPDC5RhvCv/mwEUrbFMv5fsEDu6ZwCyFU=
Received: from SJ0PR04MB7165.namprd04.prod.outlook.com (2603:10b6:a03:2a3::21)
 by BYAPR04MB5784.namprd04.prod.outlook.com (2603:10b6:a03:10e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 09:43:48 +0000
Received: from SJ0PR04MB7165.namprd04.prod.outlook.com
 ([fe80::1cc5:8e51:7d6e:5461]) by SJ0PR04MB7165.namprd04.prod.outlook.com
 ([fe80::1cc5:8e51:7d6e:5461%8]) with mapi id 15.20.4690.015; Wed, 10 Nov 2021
 09:43:48 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: [PATCH] stat: create a init_thread_stat_min_vals() helper
Thread-Topic: [PATCH] stat: create a init_thread_stat_min_vals() helper
Thread-Index: AQHX1KI83AMUEaJ6f0qlKoev9hIImav5nsKAgALm4gA=
Date:   Wed, 10 Nov 2021 09:43:48 +0000
Message-ID: <YYuUUigHbn9gSSJD@x1-carbon>
References: <20211108131143.80158-1-Niklas.Cassel@wdc.com>
 <163637789309.316137.11821147634914478848.b4-ty@kernel.dk>
In-Reply-To: <163637789309.316137.11821147634914478848.b4-ty@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 265f252b-d552-4c03-e132-08d9a42e987a
x-ms-traffictypediagnostic: BYAPR04MB5784:
x-microsoft-antispam-prvs: <BYAPR04MB57843C0089AFBC0341DE45A1F2939@BYAPR04MB5784.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:177;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bfmDBdLYGydhlAGItAGXAaziQ+mUH/Qim+FNyuLPnTsysqTLWAyHMFOl8yuKYi9/AvZi5QBQIEmFJDRkgeja2Z77Wcl7G2r30TBVzVosvwNtCVzxyPHDVcWkWiF3jWoi5nDlkeJsAUJGw26fPg/bIeI8hmNP4umURbPS61+iBvSXP3MY1Bfh7pVBm+haPnartsBDd5dDFd2yLCZl67RQdK4akUeJZvHotm0yEKse7bQmBQndcFz2F5IzDiTc01mjPt17zDLxQGVpXiguCKo6wGqBnKSW8pYaYUY1dbC1IcMsqAkb3wBmWN7idc5h5mqs7Uz5oxHGS1JdLHW0c+HnT625S7vRl8wB7f1TWlSbISyhek+Q2R9UmsMXdxw8nd86tgYQ3DU1UnP+XznJmL/Pud//9UnhonBQihnEIbMYtj/mCONq9OF7lJeOl6IkBzCX+dvXxBJi5GP8NexzNYvOIdFL7vm150snzaWsvMqzJJ38QV/+G3jhyILdY8em0+PZ3bHt8l3r0Qsfymsqi9SqCDQctYe3VpkfzaNP7+wKK80PDk3TV6j3HD2kuRqsPF2atoQQRa5GLqT9V0Mzfp99KBISPHz9bZPHt7zHp5PWdtNt/JUgaFLRCLb0z3hCU1JSqvLM/XNVAEzxkEeM/DuvnXBjI9OgZRnWh0Z5b0wINVA+7r0AObfkUdyn8a7dEZqAydvWhlx0wcw2Ong9D5em+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7165.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(71200400001)(9686003)(6512007)(66556008)(86362001)(33716001)(186003)(4326008)(8676002)(8936002)(66476007)(5660300002)(2906002)(66446008)(6506007)(64756008)(76116006)(26005)(66946007)(91956017)(4744005)(122000001)(38100700002)(508600001)(316002)(6486002)(6916009)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9kV+0gxrIY958YIbub9/16hO435Q7QCgsn2/z10OqhuLvHa2ZJobEA+yPI5J?=
 =?us-ascii?Q?VTF/yH6JMYHgWxUkNFAID2l2q3WqC2H+cIYiOeAVnckbH51aogBM9FwRxtiv?=
 =?us-ascii?Q?/ulmlT2bL5rE0NKSHwLEksnYJJT/eswoy7Z1/Pu9DCyI1dJUpAgLshjxtLIb?=
 =?us-ascii?Q?3lLaeAnoMlp+3wpB0yAQenIAzR2eVm0kmffoRXI1Tta6MXJcEfqvn4vwFE4o?=
 =?us-ascii?Q?BO4XKbpvvxk0I+vdnTZ4eNorS4TtmkuO95MUF8C1XWhteF0FXqF1+KxyP66B?=
 =?us-ascii?Q?Q8hDftO1E/49hX4qNM3zyTt4ymMhiyxEs2UUHiQfrrZKiHAzlg421GAVTpD3?=
 =?us-ascii?Q?bkt59UslDV34FoEFJJGg3/YvQ9RnozZmHwMnu9mT3T6URVfw7fDpnUExgtUA?=
 =?us-ascii?Q?3X3vd6GYPIlkZeibdaIbBm6Sf1kSay3Kq9C3ZlH53Jnrn6fmqIFcOnZ1aw6X?=
 =?us-ascii?Q?OXkLc4JoO4cZDIQIzofljEuyNn3xtZfS0UsRm5ySE0Ce/YiwsK7UCUa8365k?=
 =?us-ascii?Q?ALUNWWVrg25BhPF3ve3rxGD63fuWFDHp0qgmfTTQidY7yZQjFrypKMiVR3mN?=
 =?us-ascii?Q?H0i7rfrIA0sMB23UoOdN2ruLoEH+E2AVI5UwJEqgESaiKj2BKmtm0j2KfVF3?=
 =?us-ascii?Q?Jnc8qVH+Aq9rgdCvnOc4bKk5a6R2QLDe67k/I4ap91TdxYVfepC/L8tyIXey?=
 =?us-ascii?Q?TmL6uEPfMrExatfjDZcQEq/uvxmaA7MZKmltrvQ24rc4qXtQKopzeUeeVaQR?=
 =?us-ascii?Q?1b9wVMdIavbVI30t/1GuBZi71n2b874oCS2I4E0nNzYVn3u7qGizroHCFvF2?=
 =?us-ascii?Q?UJkHg0DWnb5yfQqbUTpQVdsMX8lXUBPfD613/g0yDAY5Z1NjNMpQVWYvZbEf?=
 =?us-ascii?Q?LK/MGV1IRleeFh78IbSlYbyhcFlTzZDjOaeDSR6U5W6yVm5XkO962AvhTi/K?=
 =?us-ascii?Q?FWZXuG2sFZxY4jBpvk+w0RELCWlMMU4MrkaAqP/m8ADl9gG7V5uZALIpRrv1?=
 =?us-ascii?Q?kKs5uPz8jLqZPghjr+9yj1WToCTlSm9wMcKK5K/xIYG3hKuCEO2JAnL0LqB1?=
 =?us-ascii?Q?SSqG2iUbxGDBhunFzXNXhT/ZWMACJZF6aNiHRU1dEhPCoZNW/AnYZ6QzmCmD?=
 =?us-ascii?Q?YHswn1qbEdx7CpBUrbIQ9tacu01jZcHW1I8HC1QJEWkGU+06tWjeEXVYpErl?=
 =?us-ascii?Q?wC1l675APwWOGHpZunTLnMPwWUjLJlVyv7vN6EAb2/BSqvoGEJprV4dDEfbI?=
 =?us-ascii?Q?OCLys7iNMR1wHXioQprRShcWacUHWLUvlW5c7N7ya/AWkkyO0D/hxFuf1cmf?=
 =?us-ascii?Q?dANN8JT+5E31IMUOSLJJD/bYKtiphDtp4jUoNwYIPw4g36WlD/hvCSi1sVPF?=
 =?us-ascii?Q?vDE/3Julf4mQjZmmgGLsP0OAvqLCr17zOi/GTCajuTIXozhJfHG64M13H85l?=
 =?us-ascii?Q?lcZb9toGbXJZldqptJMRrvjQG+YBlTsErqUcmWivG4C3W0Uop9U6Asq1pg48?=
 =?us-ascii?Q?Q3mcPjBo6G9WTkOEfJPmi2DIhXOjvZoqqTvLj7+NSkyGgBRjaZkHeOZH5EIe?=
 =?us-ascii?Q?CRT6BYwOSb62DJ5zPfrNKiugluFf9IDDxnm3uQqe21hg9gIe5+omRW8Alxnk?=
 =?us-ascii?Q?N73ywwyd91QrR2LU4SSg5ognJ8eg0wWAcDfGRx/rGbkY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4C70879B0DACA47AF9F2C1A42F5E713@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7165.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 265f252b-d552-4c03-e132-08d9a42e987a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 09:43:48.1912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uHKsLAXf9NbNJdle88fEAQuxRByo+F81Sm0S1D7FZZy7f+tZUARme09ulWcKIczyvbTOFleoic90GeNzmoNCMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5784
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Nov 08, 2021 at 06:24:53AM -0700, Jens Axboe wrote:
> On Mon, 8 Nov 2021 13:12:09 +0000, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >
> > Create a init_thread_stat_min_vals() helper so that we can remove
> > duplicated code.
> >
> >
>=20
> Applied, thanks!
>=20
> [1/1] stat: create a init_thread_stat_min_vals() helper
>       commit: 6619fc32c413c4ff3a24c819037fb9227af3f876
>=20

Hello Jens,

I still don't see it either in kernel.dk or github.
I'm guessing that you forgot to push.


Kind regards,
Niklas=
