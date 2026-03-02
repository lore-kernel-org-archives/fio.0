Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CA81862A
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 06:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434301; cv=fail; b=nklcubKvrUT/ZBwAKQJ9iC3yrPEDjZD3+U0wixa9rNPd33iY8HMILBTDgwyoBpjvBerZ4Ke0K8JIEOb9Xc1HLNjAeHK2xI6S61cKhOmcYXrZZQgKtHqY+X4qUCT9Tcwr6AnytALhMC1O9hS+QXkWVcHc3+MrhPlPca+zBRcp2N4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434301; c=relaxed/simple;
	bh=v77SAS3Q2mBS+ofU6D1B6yDJ5lK/GAzegXkprwtMs5A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HeKe4P8rX0plbpwAhgJ4vGlIg9eWdA/cxLBpRMbqP/urOqApD/jMzXV/b4J2gUPUuHOuLK3pwf6Bs3QDtYOrUMxYepy1Ft+ezyu8/XPmXBAqq6ir/oyUdyp0/gmDU9DNzsPkq0OFpSofQkbrDdGLAvihZlEwZZZM1Pth+p7i808=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YXlrOd8o; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZM2KOfX1; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YXlrOd8o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZM2KOfX1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772434300; x=1803970300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v77SAS3Q2mBS+ofU6D1B6yDJ5lK/GAzegXkprwtMs5A=;
  b=YXlrOd8oKx2zYDcJR+DnyV98/pY/eU1APiGFrGufjl0nOCA/cpovZdTw
   NqjPS8s+47T9SPtoB70dmjZW2inskUNhdyfYRUS5HAhOAQBUMGrKXTyNb
   2vm3is4DXP4rm1TYxYnkR3IxfNbxAeQ8+JAQzzqmdZC0PAMQK7FLL7/Y4
   HwfbXYbJY3Pkf+tdzCgkdDT89see9+twvK4iZ4mpminj+1QsQCtxIvBKk
   vAaSGu+bt0L+p3Qu9sOG99C3XkqfxcQ+KChSUjdGVNNaoNXcrTi8cUCJr
   7chYFTxBTb1omrtcPp/31rIcOLr9dNmkS/kpE1xCUknHlVlGi1ltiSBb+
   A==;
X-CSE-ConnectionGUID: y7QzjLG7SqukPtgDtGNaGQ==
X-CSE-MsgGUID: cY01tPV+TJqzJZ+6A71jLg==
X-IronPort-AV: E=Sophos;i="6.21,319,1763395200"; 
   d="scan'208";a="142839217"
Received: from mail-southcentralusazon11013026.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2026 14:51:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cthF2ApXFDzmGgOe1dt+mp4uRnoSBxNVWP/Ect2pHxC0BtGcSteXU2Lzc9l27SEaOrrqtS3+6alenDXkYp4ZZnVhmsVgroVWHVW66D4652JeIdI0N/w7GsjrJelsuGi4Hs8eJwJ2pttCd7lgWidiV2sFY4zjpYg07GJ25fmdja8RIfUYTmiazddl8ANpiagkc2Vl4l7m+/FA1vCYLNp5z1yMS0MYDy9ECxjXEPccRZAFdSC7pCIrpRVnAypcZesoR+5KDQAK/CdVaVXDzMBreAIv6n3ZyUuIEKOHN+Gl/huJSjZ2G5wIz7l5Yh9s7tew8WvxX1G91H1stRoWpRLm4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cSnPPs0e43YgPzXISJPqIadcfeGOXljLvC0ZIwhG/s=;
 b=uvWA2nUzj5xPFwdDCxZshx2plpzxFJhT4vIMmUxpomw8fc3ynswXC7Ie0MTt8y7oRxx6JXROmnNPHt2de0LJMn8aHkQl9QXpIXHugSnIW7VgkNmQQpmFxWzIE71LKFFTpsL27nqBiWnb229s9AbV7EY+jDH5h/uS2KY8D9Ys6kPXk8E7sD6mQ+Q1bFjj67ierjN77KD2XlU7w+cRCSnpr8VuXLlqHUg//A9pqELipydhuhhYYD7+qDKo4w2hFzJHbWaVBJW33iH/oG7TzFOL4ms/uPkKOOaHErgXzIFLgeNxA1Tbvm3glXqovPE2nnaat5/pw8wS3ExGN0IF3hGJTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cSnPPs0e43YgPzXISJPqIadcfeGOXljLvC0ZIwhG/s=;
 b=ZM2KOfX1t/+bTrMrNn7IV8YV8gyqzDaVW2YxZJvokjLJt4ZDkn9f/LxCgLJCMjyPg9HPpxIp8R0vTgiKs0qQfSkhsiMfmV/BbTsWp4LAHU4sNTg+kDYJk3px8OvYVtHNXvNVhVh/7xEH3cn8WEAZP+w+eFO1IOiRbhr6lqJ+AiY=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LVXPR04MB9984.namprd04.prod.outlook.com (2603:10b6:408:37e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 06:51:32 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.011; Mon, 2 Mar 2026
 06:51:31 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH v3 3/8] zbd: introduce write_zone_remainder option
Thread-Topic: [PATCH v3 3/8] zbd: introduce write_zone_remainder option
Thread-Index: AQHcqev1g5MRvoheukK3MQLztGiij7WaqG0AgAAlugA=
Date: Mon, 2 Mar 2026 06:51:31 +0000
Message-ID: <aaUzHH-r9eWM9S2Y@shinmob>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
 <20260302022609.3526823-4-shinichiro.kawasaki@wdc.com>
 <1d1f28e2-cdb0-42a4-ae7a-eaaccac3647b@kernel.org>
In-Reply-To: <1d1f28e2-cdb0-42a4-ae7a-eaaccac3647b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LVXPR04MB9984:EE_
x-ms-office365-filtering-correlation-id: 2ce5a3e9-6c0c-4c41-683b-08de78282345
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 jqkZnzCrHOnphISMtGuNpfMvMmw7CeFpzFuZYTKR2q+e6vmX6AqCJFrGLu7iGNK4ys1GdKsz0OOsjxIGEoVf+/nk4kW6i/v17oEl13kks8NDkMJKkRWp3oaPrAgFz/VkkTqcMiE4UE9dJaat8ZNj+0SNpRdq85DilogFIiRjmaGDPSXLgNqtGHiOR33vL+jt+8S95dv9mA443FA/aWVj3kbGS9pfPA7pA433mJ4CGyeJrxyxw5IER+TUk8oGr5andMsdg62rmPSCBW+5TD6dnA+OiEa+nXz4i4eZD5ecg8vg+fmXDl6J7CJdBd0COBC2nxUbt+U66imX0a/RvYNxT3zS/IfiLraBK/dF1myN4a3g3Z4ziJ7oeeBRrbdqteHI/MJ1YK0NxE4mX8JpC283tztMIUzI1D98vDhSihImR4+f5FF/Ik5v0YQolBLFWBqMVy9MyQtYVMuQ0AhQBPtcKcCsBr6KkNX9gWqbsFbAyoGghHyN1QS+S3gv07d4D9QXBG/O4j9LTtdGz1HJVgCAIshGHmUW0RCVqf94+5RynFhscVDJdp4q+2XP5hLAQx6zKPnRvOBc3nSg5OTah3ffVleiTu8d2tJMPmbKlXcPpIGN8NoF3b0KiIz/T5EubPgW6t6YkXSJyVCZAefBFYnAqoeHZnRXsd+fVF9wQTY7anqrbIntrhIC6gqlDg7HYWSzRxXcaJqijCqp7GEqXW3kbH/RvXxR3Cs0OgPcKJMD7v6m5FblHoI45q5MdTZNHB7OkqtGvMX+zhowcfiJWzZimsSEh20jTYrngu5G78ddmts=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Wz/EDz2QQp0yJX2PP0GVfi52/iWTGelt46wFq8LYUPEyh6upqnTE82bLfO9/?=
 =?us-ascii?Q?6cVETHShHwjh2WCIlLgUcGXdH0Onb31MP22ZYFSqOOY66VgUowcJ4U8cXbCM?=
 =?us-ascii?Q?WYTvgGxJKp073TivnEmQamXPrMeCEOayOLd6OBh0qUoL18ul0hjrjnE2GkPG?=
 =?us-ascii?Q?XrLb5yUq4KOfVRfo47jun6JJJbbUAe0SqdOVauYSRFFP/t7XKrEzFz74rBKO?=
 =?us-ascii?Q?2R0ecoxzEbpMWpoKvVcf9VQUior3JT3ky80nqi50oYy27VsYem886raxWUQm?=
 =?us-ascii?Q?3IFd2UIBm5FEmYLE0Y/tB/vt+dPR4Y9JNoKXLeGdgRJT8TRb5g18H0mxcNpv?=
 =?us-ascii?Q?TLb8KPxPPlfYb907P53ilePDXw9yLHvBEmBQuUAKmCa7j7Jsff/zODVEbIXy?=
 =?us-ascii?Q?0m5izwbRxFe62gKNY47mc61sdOo6qfCRnh+Y+rIv3Ygx4pF8gtLLVbiA+d31?=
 =?us-ascii?Q?3ukH+jWIfxcsIXevcuDscHcO2S7u+ncYMGR1RDUGlxcWUOk0odlKMf9Ud2Uy?=
 =?us-ascii?Q?1l3KT1wCQDqBM9l4Fjhui3qadB/YNziuDfucgH7yPZYLkJDgwYoRjUUjlh5K?=
 =?us-ascii?Q?QNXlc/8nJ2pUK6h/A/aFjvhllNcuMHMH7ZS+3W/S3yTBvQJTa9WEf7Qre0A9?=
 =?us-ascii?Q?rHWqGX/3rkFGxOi6z8KtB48Guc+BhRlSRh1wS3+s1+X/duFy2wUxQAm4GsVL?=
 =?us-ascii?Q?8UcYHD6pQWGOqiOE2n/lGVs5xJ5mmOTB9AaMAUZ90Xg8ZkI8v+34Obfnqewi?=
 =?us-ascii?Q?VFYkZnp8b0r/I8A9/mUGJ1LQGkWOtAiex1/6toCi9Uc7p6ojzOqSDnnVlWPN?=
 =?us-ascii?Q?HGa5zkBfjzvRKuoyF9B8iQx9gLBijBAYoK+TdJgRLQ8kRxEdFc+dEZ1zaMRr?=
 =?us-ascii?Q?+iOjV1NXAIII1hHNu+x07NXZ3sx80KjvEXGY/mZ6Ck8JqNm6l1XnfE6UkmXF?=
 =?us-ascii?Q?gHla0w0zed36pQHtvkxk4hp8tm1i6mcKpbHms98ZTbhOrqFTn0rZ3r/t1tdD?=
 =?us-ascii?Q?NwRGfE92ftbgXOk0+kkskwxXv6NK5lqle0d8rVrKi+9WjU3ZUhklLylSGEI+?=
 =?us-ascii?Q?v7t+LFx6RJl5eKe1VfPyIcE1V/EWzM2lcnDTcoRFAcy3Dq6iKv6sI/0zqGjp?=
 =?us-ascii?Q?4FVtYjXqgbSXBf0uxZ7jSeGNT2aI67KtwDEHGahAiAJ//8IUiZVkpBZSSB+X?=
 =?us-ascii?Q?KeUPcF68EwJn8f/MQ6pQUiP183l1Qi6mpDmoPZPR0iSJKgfUn+vhvrP6DOIc?=
 =?us-ascii?Q?L5g24b4S57SJL/sqFMbaqDG8fhHioz/yGYwx5k1TeMAJ8k+Vxyg3mTsyYTj1?=
 =?us-ascii?Q?FNRHD89BEUnb31XZUVV7/xdUS4ZnAoeVqXb+UESH9NLJLB/jtPxmUpH1pV6O?=
 =?us-ascii?Q?AnDhNfLK7cSAqhgKs61iQwEVmKd2IurMG0hxNz8bK4+YDAZ1hnt1cBzLRo07?=
 =?us-ascii?Q?8ux4y6nsGmqoS6FVldKudUERTdFaZ70qOxwPgf96kejU/inUb+x28fo99wuk?=
 =?us-ascii?Q?uLTjADCJfbun0cSLJZXFJCzYxSoyGE4AlDp0kLEzrzcTXpTtxQI+tCoMPdhc?=
 =?us-ascii?Q?l+fdGAhwhNZLhryRDx+8USUR748OzsdBQRZyugTozSSKquy+Q40ToaCWCGHh?=
 =?us-ascii?Q?gwmCU0qrgNK068YxOWFF03IpNHfpExibL1USdKqQBeps7KZTd2ftob6h2uAZ?=
 =?us-ascii?Q?5MPoHZZgrchl8gspIkmbHYbcgBBQ6wx08zcoi7dnK8rpHORoIVWwkykFj5bQ?=
 =?us-ascii?Q?v4T7IhACus/VqiscdLoU/LIQHiGI6MY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2993659ECC149C419538B0AFA9DA2E77@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sACLwAh0m/6EwwcPTwkEif95qgzEKVD6++/x/UovYRKoQzx13t5GcJP41b7eo0srtg0U04MDmlPXJiPNyr9B08viBsrwINxY+nu7Qi0EU9FIIEAHq/FiNF6y9QIeVFchy0cZIl3fLt4IFqhOv5S4H9rmYzAgHtHn/OXlqe/1e7SaTKGEtfNBxNoyYF6cN8qHYSaP9xO0dvBojFHFYHXy9nIHADyoPgrhVcwAlVjL+fl/bFtHcgQl7ieVpoSxCoErBLmIgv52SdX7W5gUmb82CaObgN0SXgHwG+mB/RMM4ZcFgdFX+iXgYUv37Jy8AKDg8X3tWHE66TDELzSgKIKKNkX337bBt69p9nRJ6PoucQ99sZvW+VJPfwMe4VwPzLeFPRj28QVTuFZy9XpsIAV8aTzkG9x+LKv+c3s5cnm56NkM4gxRhD3CmRl3M9OOko9EFT6qMKlgYE31eVN0iDL9Tfqs/G/QVCvdBTji0a10t/di4DxFg7KfOEhbH4r5muQhns66H7Dp1pcv8b7RFi5+Uh1tLBwX7QxTpWI57wSC/hJaA2VdWeIPUzP2qnNo6XHt7vyhWqqwIDbmlMKOtICB45jzDpqEgfEQkE7iUS7zthB6CLXsbVnaBTL2grTVL4sk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce5a3e9-6c0c-4c41-683b-08de78282345
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2026 06:51:31.1906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fXa46nuIRKhDvHB83gn48hAXoLJ+4k1Xo6SFQFHVeCrA1v7gG7hpWp91s18T2pJ47VRhbZVSVT9YJvwE6koaU6eOLOq7Y5FC+93rbSG2MBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR04MB9984

On Mar 02, 2026 / 13:36, Damien Le Moal wrote:

[...]

> >  enum {
> > -	FIO_SERVER_VER			=3D 118,
> > +	FIO_SERVER_VER			=3D 119,
>=20
> Note: this change will conflict with my patches proposing the addition of=
 the
> end_syncfs option.

I see. Since your end_syncfs patches have just applied, I will increment
FIO_SERVER_VER to 120 in my v4 series.=
