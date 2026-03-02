Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574E51E8320
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 06:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434193; cv=fail; b=APYn1OV/O6TalZg4QkorEVw5vPXuQWgPm3QxC5+1wQDmC2D9xhFO6BItXjIpcS/c8AGelrLXPPte1X/tsJhj+Sp7DuXYoaMGsb/QfdgrQW1KZlq4IY27hc6exJink9DbCWKvQ7VVyjtkKfvUu9SRkKEj6tMAXdy5awwKh0/+9h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434193; c=relaxed/simple;
	bh=hOy2xpy2GRaWi8Sc33Zs7xyWM2NJLFx5dUoavyBXbCY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e9/4gkJBEY3yZKSoAFWQ9CGrrIedctFAEFgi+zl8k4GvZTNyqC2L7o88qCaBz2NQ4cmWVgMbzrYIIOboeZOrTBbORigIsgkwohUF8EBX4IUXIKQEs+BEw+BXcJR9qH/d8qqVQl/h624OGhkGGIC4pfryW4igfsBNb2yGZYhXODU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eSZ+Qwww; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yBFg6bEz; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eSZ+Qwww";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yBFg6bEz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772434192; x=1803970192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hOy2xpy2GRaWi8Sc33Zs7xyWM2NJLFx5dUoavyBXbCY=;
  b=eSZ+QwwwExT6379zY1Gbe5W8zl6Fjr17JADeOG3dUyNOqGKhmiASXbcW
   yJc9G7gP76N8x4cugSy3GeGyM+BiX9L99CgvTBG+kCIJ2ITZ0323uJ9mE
   rZU3nFR07fxNxvE2KG5X/+L8bqta0d0emqDuqOAynDkL2mdDkN3STqOrT
   c2l74SDGjNxV6ZHPeKTd3Nh0xIl04pa1aUl4orudkjYUVCLY/Rs3AU5ko
   RWnElEmwYYajDP0M9xBhjTvCKM8JIZcDxYtXPXmnQeCtHEh9rZ9tqKQt7
   epYIwQjn9KCYPehY1eJIMXxx9psnBT1fc+Z/oJfgI0rcxmWeK9fOLt718
   g==;
X-CSE-ConnectionGUID: 4pN7hZdlSb2C+9oyGf+I7w==
X-CSE-MsgGUID: IVDvDG53TPeEM31zPzZn0A==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="138110890"
Received: from mail-northcentralusazon11012049.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.49])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 14:49:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7GhLDjeBGAzh3/7+vtR5VyVBTTaMJkzQ9Txhbdz0I3oyCB5MQ1GGH2cvXQ1rww6+DU83gynsXgYpCsJIvTD/BsDHjuNEmwgvHDY00JVDM0yHXkOj4PaWIymryeKSO21aG6BwkA+CTRS6ZSorRvqTNmxM2AlyoYQL/5sHE8XWO0YjIhsJ4jQxqN2Bz+xbsPo/yT+CD1a5vp/VJqoR8+1XURMA3M5cM+L6T4Dx+wS2IiTyPpc/3SrvMptrCr8uOdmlgfscZXTK0wkVO8z4qUks+P1nlm2MW6cPyFIn8FYt2UVEJALsSVj2y07biRrY4HZhHFQ34Xdd2uTF6ySQpbhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlADPbh2ogLA8k0FO7V36xVxicODFT+OLfxfs27RXxU=;
 b=c/Nl/b4BSkAoZQYhk+tuPJObtU4CnYkEkrHjGN9C+1eMf8K/5E+wfQTtf7kn6jv5Wi/mNdAeMtwNxA0Rh9/1iDQMTOIjpFLcDD8kDKcD3Lum+1WSMjl1hrGzMQgQoHAfzXgm4m9ubAYg0sldokntDwo5LIcDfe1lFsZJwJdDLMIsTIIfZf2qP3CLO1wAyjzb52GXNCL0se4ehRqqGNr7LQayrPiF1rzve8DpBW5v9YNH6N6TQRF9ayBKJhc7PKxe/vxS+qa8khGdcpf4kNJbhgCxgRerAQ0xRE9GGu3u8eKKBgZwTyWoj1ke3Q2Zc8s0ylXZoFd0awoV44Fc3GQjnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlADPbh2ogLA8k0FO7V36xVxicODFT+OLfxfs27RXxU=;
 b=yBFg6bEzRVkd1T/x6UyKbx5MZYpDRam5+hYz9Hyizh54n7mFp4dsNWDNvU2poh/ny3QytMYlmClwgiKSvwUamz9AP4Zam0awOanOozruU+oSpviyI1huucQTZndSLCgi4wcoYNlUlvc/0Qm6rRg/nFVcBO/EgQN5jrIrGR+bg3Y=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LVXPR04MB9984.namprd04.prod.outlook.com (2603:10b6:408:37e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 06:49:49 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.011; Mon, 2 Mar 2026
 06:49:49 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH v3 2/8] zbd: fix write zone accounting
Thread-Topic: [PATCH v3 2/8] zbd: fix write zone accounting
Thread-Index: AQHcqevzMMG+QYrtJkqRzlWwFj1nebWamSiAgAA0gQA=
Date: Mon, 2 Mar 2026 06:49:48 +0000
Message-ID: <aaUy7dt-QeaFOJLN@shinmob>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
 <20260302022609.3526823-3-shinichiro.kawasaki@wdc.com>
 <35cc81d1-ef4e-4b21-88ea-6386075677c3@kernel.org>
In-Reply-To: <35cc81d1-ef4e-4b21-88ea-6386075677c3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LVXPR04MB9984:EE_
x-ms-office365-filtering-correlation-id: 1afb7656-913b-4b8c-843c-08de7827e621
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 JhXKoWqUCnd6Qc3dlX1exAYW+whRw/9ts0F3Q9nrB7xnO/ZEE9sHvQv+46Vl936URHS4XpOsaxxaGy79YTdOAnFj6hyH/rsrbFK2W/ERErshvNNEf62oSBPFyaw9bypQSiaEx4ErdtA7dkMl21UcWBRKHlJBcGFI3fP8DBno5S8f9syXbNDy9f241NyadhPHFJFCWZj7//cJU0TV68ANDNCU+N9jUhI0c1d7Gn8ffygzWlIga/makYX/ecgvdOWwZPwNj4tloO4YveZ/ktjErvD+wkEqGdTiJ3faU2awa9LyOZ7IpHlgar6QtmoB7aSNuzDY6gM3E5wefoz5WYJZiPwoecNGRiF9yLzhzQWmAA1GqTJK5Wt1ryGsUFPbK0vdMz6zQT6uFpUcFKTupkrt4N+Y3j2GQQE7YB4RiN4uMwIjHSeUejFxYb0+rXf99IjVgHU+Rrvzm6e6hItTF8yOnuF2Ign6/yAaJUJ181ILN3h65bSVKZr4x8FP89mE2XX3ZDfV4d9/g5C50JmYrXKpTXOXvs08Y+q4wQ9pallEC0JZyDNSGL8cUjO5H5Iz2QGcyuQiZ9kvB81xX7Mr+tigq/GhEjgPzobRZNjfAJLNyvGUyALYv8ZnN5Ba+AzR5JyIa55+ayhrdLLQLGkYjm8SfnuyTzvkDavEPG9/ctQhHkLzHhO8ukAIHXgE8HIOUc0UbmfitbbgzQaUKj8x/1zOe09Y+C1PvsPhdPM6PWvGhK+MR1NSfVhLcjb4Z+XwaFs5YnOMM6O1gn8nUc2FMXRU5DjttVthuks9v5iOUh08b4E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1euyLNQcC86Bf8KUEQzKXm/dCpGlQ9GM9Mysu5atuhxHdqtagmbziyOUSD07?=
 =?us-ascii?Q?Gj/Fjj6/nqQchdTUaHk6E4juPjp6TX1x9UZdIhPJDsn3gexdO7XLS9xoPxLi?=
 =?us-ascii?Q?HGtE7mF7O7s20+I8XBSqiIlfDCwYzR0unajg1gG8dSYy5MMHzjJkuE++H7B8?=
 =?us-ascii?Q?6ZbAsP6w4OreaZs9NxBzi+IwjDE0b/QWAnG849Rh/m3hV3bpOQg+5vHKMGkp?=
 =?us-ascii?Q?cqCG0v6GtBQBT65BasN8PH/McUF9qjNaSetrpP9LJwYqJY8ueKmUM26DC0dC?=
 =?us-ascii?Q?hF0Tgk/Zg+5oNytDYhdD8vsl1qzK8rWBbqWsZBH6sdDS04oMMZ45Krbxb8Gd?=
 =?us-ascii?Q?p34bqJ+WVa9iC/DPNvVebQxjKz2fAKF9jUPQWfFo9zGu+KzIjOl9z2B+/VIi?=
 =?us-ascii?Q?J9J7Bx3BqekqoXssYoTgh6/HH6D0HO1EefKgYrg5gl/AVufgKH0rl7HD3Pz1?=
 =?us-ascii?Q?U6iwpCaQ0iqc16/WEeYsFuEdRalczheEc98SVX7dAUkYJybJuMIiYBDbp5Rz?=
 =?us-ascii?Q?LHl5/UpPbMS4Ef/lCG6gp+QJVrBtul2ECTKrkiISsePbnucWJ3X9KB1eVv6L?=
 =?us-ascii?Q?TM870sSEzJXEkmXNgmdHibXdsu2UauklrBAF7L66MyeuuKiRp9W3SUn95Jp6?=
 =?us-ascii?Q?K1HDTBQUKMd/9tPLhdrblGWtzqjFnJQ4NWW+hC5U306zG2AOYIp3hboL3pMv?=
 =?us-ascii?Q?xQ1JhTx7ir3FuttECnOXJAnaMdkZTJXfdDxL+YE640BGnyBi8gLBv241zdhq?=
 =?us-ascii?Q?3mkzxI+UZbRB6t/82Vns4B4zKB0jZujoYh5wivW9QHf127dUy4b2FMDEOyH2?=
 =?us-ascii?Q?hvl/PheRKw1DxBVGNANGvlI/ZzkOGrMYfK2OY2APSDX+z+E+hd4xvjuX5JY/?=
 =?us-ascii?Q?JYbhwrK5fL3wz79uee7kMwnyyYYr47W6PETgYgwpAOI/DtTY5dBPyL8VAYj/?=
 =?us-ascii?Q?PgGaQ1hcmzCQ2EqwwBEvEbSG3T7Ud0dp4SJLxTXgzDSaLXA5DfnKDGUU034B?=
 =?us-ascii?Q?UasjgzWNLhO1/tUOTjBr2x98cb8EyqHtjLPwZFwgdJuKzRzdqwDjLb+mFTIX?=
 =?us-ascii?Q?JMILCmKFjvviqO+Q7izI5y8yARow+/Z+w/n6gIKj6wHn9ONwmSM93sGo1ZmO?=
 =?us-ascii?Q?i4xw/5kqJfAe8rHhedqQ0vHJEZUfxpj5UHx/TSPwDCO49DNzA4k9l2PUcj+4?=
 =?us-ascii?Q?SomWYwlCNoVJuuPwlNWaI7/G2+HhqeKj8jOtAAnXxSKs8aArsvcsBY6T5F3a?=
 =?us-ascii?Q?cPOBvsEDTlcYWMUPUYbluqZyWFZvhBV5jwjIdztjnOTzGwhDk36wTQFqZhmf?=
 =?us-ascii?Q?aoQXn2RruSujneIzTUZKn5odp9iCK5U+JtNmbyNpYQSm+2Vt9TOHn4N8cz6m?=
 =?us-ascii?Q?F33EahICtoLJR7q0CQju3MWkyfaLbecjL2YVKDJrBogTVJgD3QdrX8Rvv91e?=
 =?us-ascii?Q?9rgoBzN2GxsKrExni8gtXWuUw+I62/UCyFaWpiLSMM4UdNy5zu6qoV5QoURy?=
 =?us-ascii?Q?5yAaUwRifIUora8B0dDqMrMvo83AaGGBTVDsI+pklcP8mDvFakDr+9mpBJp9?=
 =?us-ascii?Q?UNNY/dJiZZ+MjUoLZ6w9N+edxFaYtzJ21s0rTxd25ieDbedkaoUbHDKGuWzH?=
 =?us-ascii?Q?Uw6X5+XYGQpHlOWn9VT1n2YQSnOowtL51FYPnC2zOdSN0U9EcvoKEpCsqULQ?=
 =?us-ascii?Q?89VBTFU17hgrizuD3metq7DqdA2Vo9EvlFsU/16+QcSpDnFYOUPkGFKCt93+?=
 =?us-ascii?Q?tjnMeGhlCftr7BSVeZuT0Li16M+etzc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <077CD127DF248C4784407E233E3C997E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ppTj44WzFpdO0qSIeIljzqLAdKm1prraatXieXtyEgNGXC4tfcc5XTPe2pAyhY+n9RYqlEnuwOa/6J+gK4p4Xn3kvuppT273FdfXPBH53k2MfDdFhugN6uIdVf5iuUgNyGlMCXpOhfBnKIA9GKd9ajuk+DILM0st7975LrfZr8fnRc7352gajLhcHNCV0T6zGssvOmohDH12Bdsr7+4TTlub0IieRZArfQWYvKRHtQPNpybfi1fmPe758EcsM0Zl5Wk4GUDbaegvs2SaDjRHApMGXwyIohhCrMXfhzDvt8JLJVbnpU8Exk25Co/l56N0/8PlSfKCknKny4fDTU1HE7yjKkbbtnP2AdZgf9O+A1mtiC7xOwRrmsvBkBS6LcqC1Ua5bLqqMWh21fn8r0rH1DR2mPyvQ+6XMfzanEa1bLQJFzDEzvA7VB2MvuwhLqUlxyeqhtFLUjuIQ8iqvVnCrFUriSHUjllRxsOvtAX64vAgmcE2/7AWBA3uQXPDWMd/4wj588xrnSCbAEG6R/wq9a9ssUIeGcPBqrTwX0UhWoCMwWtjLDFtOksxiz4QnbGg6bfZf2pMhvjReuSLFb0gTy3ZZPOAih5JiZyVHTwPFy2OBmLvrb+7kmle7mKKy/g+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afb7656-913b-4b8c-843c-08de7827e621
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2026 06:49:49.3047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BhsWVOxAA7y6geeQN0q++hkRsXHeCw4Fn3OWqNkVAT/5q/hYa05mhXCnDO5ArCXvDmZJ2w6lp6uIp2ozawoIYdHndkFVc/kcsJa4lEo+cVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR04MB9984

On Mar 02, 2026 / 12:41, Damien Le Moal wrote:
[...]
> > diff --git a/zbd.c b/zbd.c
> > index b71f842c..c511b709 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1693,8 +1693,17 @@ retry:
> > =20
> >  		zone_lock(td, f, z);
> >  		if (zbd_zone_remainder(z) >=3D min_bs) {
> > -			need_zone_finish =3D false;
> > -			goto out;
> > +			/*
> > +			 * The zone might be already removed from
> > +			 * zbdi->write_zones[] by other jobs at this moment.
> > +			 * Even if the zone has remainder, call
> > +			 * zbd_write_zone_get() to ensure that it is in the
> > +			 * array.
> > +			 */
> > +			if (zbd_write_zone_get(td, f, z)) {
> > +				need_zone_finish =3D false;
> > +				goto out;
> > +			}
>=20
> Please change this to:
>=20
> 		if (zbd_zone_remainder(z) >=3D min_bs &&
> 		    zbd_write_zone_get(td, f, z)) {
> 			need_zone_finish =3D false;
> 			goto out;
> 		}
>=20
> And move the comment block above the if. You could also improve the comme=
nt to
> explain why we look at "zbd_zone_remainder(z) >=3D min_bs"
>=20
> With that (and the much better commit message), feel free to add:
>=20
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Thanks, will reflect the comments in v4.=
