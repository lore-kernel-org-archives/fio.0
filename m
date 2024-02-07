Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AFDF9DA
	for <fio@vger.kernel.org>; Wed,  7 Feb 2024 03:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707275151; cv=fail; b=jv8DA/KMxPaZ+zVzHj/IQCq5/5MmYFE0nUa2GhjBkHDRiadHlhHZBwcpLSIfvu9ECt1IEk8ObE9WRjiU46abBthrJBLGe1NIO5eWxled2SHB2kSL/qtieWqtmIXl+rUIWzCjjud2V3Rjt3xOjzQPD3EdkI8+86vXU2i6zvfWbT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707275151; c=relaxed/simple;
	bh=vSCezLSYiGJQ0B/5pedtETR602EVXIjogHfGTPQTGOA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LwoD2EzOAM0FOhjs/0II1WO2HW87RpioZ+lLFoi3X+0RuzOeFUWhfY5WYnhV+TmoyzyH3N89ja7VYp8zhTdifDUQkVi8n5yhpd5IqZbE/JS+O6ZdXeVG3inBZKkXYe99uRB5yu9Wr1pMzbGKR5qb3SvA4Ck7lEjuipxmobeNYkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=M/fyE6aX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RnSKLh2H; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="M/fyE6aX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RnSKLh2H"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707275149; x=1738811149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vSCezLSYiGJQ0B/5pedtETR602EVXIjogHfGTPQTGOA=;
  b=M/fyE6aXqb9lye5Ojg+j5LMEWqLuMZn+VmChaKwiSCSyRC3CAVA26FhQ
   ESXbsf1g1DhnzmW/cCzS0ZceBcJE+/OZI0Q6iV5qT0q9fc1lyq2k8uJd6
   QVvOlPJD/kG14bWBX8hLxYOGgWPL1SUkIyvIPLpmZsgopsicM2X2s9Xju
   P0lI2oiBS8aFeLTv8UBa+LZlTlV5/KsthSecXmkkkRlkO2jan08zq+gx6
   IQ6HZKvvj1ReBXxQgknPt5gkUJzC47Z+7swjHcX/fpWfOilk+noNyhYHy
   ij1fUC7WphU+H9woeWWncSv5clrps29n/yofOakwM6E0ydSRYYnpDZcbV
   Q==;
X-CSE-ConnectionGUID: BEmv8By1Tj6oPReMg+areQ==
X-CSE-MsgGUID: SDqi9HECTzCHsgatFkr+YQ==
X-IronPort-AV: E=Sophos;i="6.05,248,1701100800"; 
   d="scan'208";a="8728399"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2024 11:05:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeXJ39xk2tFOD9rQiEkeqxfID7vGReHySXd3APaaECtiUk6+WbtoFS0qLg+1v7GzlN5LRKXtD+ikS7m1MfX3bumLiS7edOxqFMZ9loI4H2gxj5gxVG6s7HFB8N6A672UIjK1OTb1G+e6TZVeMtVCyHTsPjDA7lJ0xTGSYabhQuVTMNyClUohpTFxN2Hs88fb3BYwAZv4xjI0FsiS/QiZRDnzK/K3b8RkCrFs/juyr3NDDIwOKC8++Q37qVzYuwpAhFxFT21wnP3xKU4X4uGzRPH718HosdpJOBJx1hHMD1tt9nHslpoXDiLC8xywrJKl3w/D/+UoMKRxIdjXn/OzNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSCezLSYiGJQ0B/5pedtETR602EVXIjogHfGTPQTGOA=;
 b=W1P1uqPK9ybR+hyjYae+qG5kS+efEklUT8bWlagadIKRIKCGHrZ16Z+7qAXFO2VPP62u6ImmtwGitO1Ulke3w/b+ra2sZnnloXqjRgh+SE9+UO0/9XDdvWjWiOehb023QwGIFGcL97Jq5LtGOSl7xQutB0a3ZrKmHA4eYwTvwOUDckGt/uDAJnj/sqzqwAOTVX7gDwdaN1zJUK2ILB4ljF5g6UVLD7wKGKJiofUZPp4drcWBxrqtHmBzBxxeWuaVWjGgF3P1N/ufAMIuKDFXFf0+7HSnjNT4jisMeJBNgawlWkYyuRQhUDwPwRex2YqU6YAEHUSWhPzgWwOw+taHTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSCezLSYiGJQ0B/5pedtETR602EVXIjogHfGTPQTGOA=;
 b=RnSKLh2Hss3y7MXrJWpk5+j1ELjDpBrA0GnCAHQyktH1PyJGzEip4xAVSfvoRmSjIE5rNJP1AP4YN45sp9bKjrEnGUMRYGIZdG7O0r3OOPZ5G+UjIvabUrhzqFQVmMmGwcx4rwRo0jwKrCI9DaqITmfZY2X4yyEM2bKQKP7FthE=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH3PR04MB8813.namprd04.prod.outlook.com (2603:10b6:610:180::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Wed, 7 Feb
 2024 03:05:46 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::25d0:1445:7392:e814]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::25d0:1445:7392:e814%7]) with mapi id 15.20.7249.035; Wed, 7 Feb 2024
 03:05:46 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
CC: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincent.fu@samsung.com>,
	"fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal
	<Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 0/5] zbd, t/zbd: miscellaneous fixes
Thread-Topic: [PATCH v2 0/5] zbd, t/zbd: miscellaneous fixes
Thread-Index: AQHaWOtcKihxx2ohC06Efvrewqiq3rD+Mz0A
Date: Wed, 7 Feb 2024 03:05:46 +0000
Message-ID: <vydywim2nehpf377qaqq6zkiyla42bdgsgyysypftwdajv4h37@4c6dgrvrbmyh>
References: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
In-Reply-To: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH3PR04MB8813:EE_
x-ms-office365-filtering-correlation-id: b1bb149a-1f57-4f0c-6ac2-08dc2789adf2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 duYM1or2xVUUMFtlTVFoRUtKs5uulJxJ5b+UA7c9/k7hrLDPv4BlpotKuHLMCj2dy6+hOuAyJRwxmofQwhQYKeh5i/B+fuAm3BzGJIlBOg3E9FFFQJlFdEr5kUKsO0Q3WFyRd0fYReJJrLcYK/aHQNVLJe5hzt0Y3nRjcTGuMP7VEDf90ooZB+ac0opZGgi2TpLC0tFgbkjq33my31EAGlqYU4PF9c3dEGXs1I4GgvrMVO1c9shd/K9HPXaQRm60R/Ylf3zo4USnhX5m894Vge8I8sPqRZRO8Zp2GqVIsINYvTBqQDYkWDIHmou5hoLno7TWq0oaYkpqCzV2NbwBN8C5BkP6g9QhaOtk/pWWMiuEVS/fFrO0du3N6tn4Z+lpKaRzyNTzhG63CiR2UojNK2y82RpXSSMAs2pDUluniSdCRpSzCYn46Q3bvmq9ZHXOa0r0HUk+j1QIDdGIh7D6t9T+f40XbwejPcDSWz/PRpOmAMa1OqSyUvxeBaxUSrKGCpE3MasyVBUTt7IlUzxD67VTfjpC2rzA+j54U9G4RcKdvji5ItKF5dr+nSfbkfN9oNPtgXlwUxwHknrtoKF6vaH8pG8V9i3ehNa1eUYc+b5ntc7DJF60bd9ixVtggRp/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(396003)(39860400002)(136003)(366004)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6636002)(38070700009)(41300700001)(33716001)(8676002)(316002)(66446008)(76116006)(66556008)(54906003)(66946007)(64756008)(86362001)(6862004)(8936002)(5660300002)(478600001)(6486002)(82960400001)(66476007)(4326008)(44832011)(6506007)(4744005)(2906002)(83380400001)(71200400001)(38100700002)(122000001)(26005)(6512007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nS5L/qcQGc4+Ir9ozEZYiC113WfItpwmwesAwXlpSsA/Gak8fq6h/ne/bvdN?=
 =?us-ascii?Q?2I5D++H6RbfLi+llKuE3GWqyLgefXF7JIai/V50wvopqB6yKNWcakpkax6Uj?=
 =?us-ascii?Q?8pc/REdpk+09Z38iPNMp5m6bA1hIroEjA07Jyw1i/UB7n+Ys9w87yeC1pgnt?=
 =?us-ascii?Q?oVvqJt92/L7QwHNSgqSqNQvDAhrY5nij74xaAxKEfEH4qeBVD515k0i2NYGP?=
 =?us-ascii?Q?hy+H5/AtpNjeNkSbbgipLCKKCGaXYCpBA57il25gA83iM4fuyG13uMw0agnT?=
 =?us-ascii?Q?0bsg4vyVcex9zv2VwXOT1ZsCvWwUPKsRzpJ6i9Hjqxo8pQAenfkUfD6aaQHt?=
 =?us-ascii?Q?MRnBUFeApwP3XhrsCCmcG0dCnbNQ0xyeqn2djGjgOqkpqFgKazU6rKsFR0+2?=
 =?us-ascii?Q?EWOUkAvazEc+kc/O8zPxtSRSmiQLI5HSvb1Ra+FZEv/fvdc50XWb2i8bW+fU?=
 =?us-ascii?Q?VOK3LG+UEz3gNeNHhw7/Nv16g5tO+rorcCcx9Ta9KdjeWQKRbTrL2b8gDupT?=
 =?us-ascii?Q?FKDVjC05shiRfP/iut3XSiVgEb6le/1n0nJFsXlqgfvtM2JSIQoz9GLpY1va?=
 =?us-ascii?Q?2BHgJCj3K7BujRSjQr5xc1PRSYshMJKMKVuzyRGFc7FQbrfSv0jdQb/gvk5c?=
 =?us-ascii?Q?IhXxX70Syx/kHXQ5vE3Uj0ePqCPEOkbnbMnSFWWGateY6P4OG7xqQEGbOl4C?=
 =?us-ascii?Q?YGCcH7X/NRLYX8yVsYR8tcn/wogXcWIhAD3H8lTsFUaVtkUidVNf1BHLbeN1?=
 =?us-ascii?Q?I59ZGIbqm/lNUfyCEzVfDzFX77WygCMr5pkFmN0id0YsPWKSScj4y8LqDk7Z?=
 =?us-ascii?Q?DFHp5voukLVqXb09y45xuyE18xMrKr167P3kR0s0TqhycYDFmXMU/zcNoBi7?=
 =?us-ascii?Q?UPjvtTYcCMU7YNOpgPP+qFf1NzPlUr4v4V2CZMRY+FQbdq9ENFT4T4DkfpoJ?=
 =?us-ascii?Q?l4EDxiVv5t2xXwmcPmY7BSMJbtd43rcjIw9RWdSAQV54OTmntn47WSumE2Y+?=
 =?us-ascii?Q?2BCqkBVNOzt1RZ5H20+MCSY4qc6PT6DVsHsd7F9Wqq9wbwuKA+9qEYToj9/U?=
 =?us-ascii?Q?/MqEdShf0EVZZgbScRT2ETgMcMLp2AqfUXri7rn0jo8QfBD2qVgGt9D+XFA5?=
 =?us-ascii?Q?iOTB0DxMOpx7z1B0MUC8FF/aUlL+Lb84cQj06AvEcVYJ/ELw/KvPvtBsrs+R?=
 =?us-ascii?Q?Msy23PU9PhFVIQ3/qUAei4tSXG5Ygv2uD07HkJGP3M8EGaTKPLvEVvix51EN?=
 =?us-ascii?Q?XLCZVJ1rvFTHktOkYNFNxrLfwRoCZbg8ql9r3NVT3/pFBqelYAVlXpfhTknR?=
 =?us-ascii?Q?FI6NgNW8F8EwExEh8RYvNdvbYqsIGnTWmDfyVNd6z4982iUnPyqvUqoEyajk?=
 =?us-ascii?Q?GZimyAdeJUUSQgU/HhhpMNbSDlp9WD8T8oYkTdop7Oz4aUPSwwYdOPEMBHEB?=
 =?us-ascii?Q?aZ7EjPF7IVM2V37QbZ1ovJzhiS+dm8DdebftLj867oaTmDBE6IgeM4nmgcHt?=
 =?us-ascii?Q?FNze9j5YblfYtRQQISaF8Q0axckNhHoM/rqouzocm95Wm2F1f2iIStJfxRcs?=
 =?us-ascii?Q?2wXNCvdqJhpNkoVNAx7H5DxGM2KCuNhTUjBVuEajb3YXEGSp+lEDdOQ6nNyx?=
 =?us-ascii?Q?ZDkFGJecMNPbdJvF7rry4k4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <789AAB8ED05C4B4D8D104D85BF6CD230@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	al4yatDnnKEXZ5JlTIBP+2FSb/x3PCfctDxBQqCNESgKS+lwtn5OFyW0wGJaj0gkKYlHH9kLU5I4QbSKKQkUt7mDk8HK4q2Zw6G0ZgZM4Rf0cLZ6S9EqSjIdI6id6Hx5XJZLc1CaZGe/V5Zdx9df1bCygDX1lMcQHSkhdL83ec3kG8TAu1V7aPvaNBLLKwodTqgDP4Uuj/LxuO+owV6+f40sfcZC+utMmwtlttjtRpCSPD9YlO2JQ3mNVofYCXsxl9GZjmWaD2wbosDPs7uaMzoNAurxMlkJl/XSPb5eQzav/i20chz3Z3iU4aJ5krvSYCINhEJaeQQEEHrMZ4URwHNJBGv9IY2iMzFP5l3qO/dmxyrm8I5BoJk2odxKj15Ue62SaHlFEenOs3pNg9jGwVH4sF7St+PEIcIdvlk1EWFPBgMhIsGoboDxlrVvRb9tJ4vts7AybIs0BvjbcAzonlN41FlvYEXhNv+rQVgDp35NDuhryZ0MkJuBXzyxyReqvhXk3vmmwgnm6fksIn9cO1BQjUUC1IsY4dswB8p5eWtsHcikOQc2z2Tf+pTwbWYBfM2wP7/efTHQIQBuni3W+L3ut43H4is8X39gBacCwnwDR/Wbc09vDs9hxQHLgrpS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1bb149a-1f57-4f0c-6ac2-08dc2789adf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2024 03:05:46.1850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xZuAyJUswbY3+M1FponvDfFLxpejN/PQCRBS/TG+02dWDok9GaiM3fhYw5KKTIpXl8moq6ortXP4AT3BEv3ysfXgG22C7RwdnAByXmDK2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8813

On Feb 06, 2024 / 19:57, Dmitry Fomichev wrote:
> This series contains a few patches to make improvements to fio support
> for zoned block devices (ZBDs).
>=20
> The first patch fixes an assertion that has been reported in the field.
> The fourth patch fixes a failure that happens while running the unit
> tests against an uncommon class of ZBDs.
>=20
> The rest are clean ups and some minor feature additions.

The patches look good to me. I also ran them with my test set and observed =
no
regression. For the series,

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
