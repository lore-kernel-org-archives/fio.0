Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B723F20551D
	for <fio@vger.kernel.org>; Wed,  5 Mar 2025 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741178192; cv=fail; b=NYvdKlM4sEqK6WLWkQJALJHlrvX6fin2Yzds1YHDDT7VKjf/9KEw+3n6v0KMGdIH+raiTAq9tYyMF4C5XxKv+Uz1BBMO1yd0AzGAr/a5tHyvpJIJDyeUbic5ZmKfHuozdCHTJUlEw+IFi++T3NNw72OEli5n0F7hg5pgdHS4WUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741178192; c=relaxed/simple;
	bh=PpAN9A+B0LZ1SE/fkAWDE1jhLBXZzYkdjXvfVP1K1EE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pU+J3LJiF4I/n7M1n0+7t0m3vpPGQANsWvXXs/GtdXjoWlP6uFcavEzbdD8imblaMq+hmk1OwmZkMMbfNMnMNRg7Pdalk9ti08tK2L57R9VwfKw25Ev5H1C0YMa2iWN1rolOK4rd1ZJiewp83vnbBWJDs2kf0tKLeo05F7zVNXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a0iLSlTK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=sSWpKK5U; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a0iLSlTK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sSWpKK5U"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1741178190; x=1772714190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PpAN9A+B0LZ1SE/fkAWDE1jhLBXZzYkdjXvfVP1K1EE=;
  b=a0iLSlTKyslZV5LomGNfWhZTMmEBNfMBjdsQZ8JGPrQcq8Rsk4kUGEa0
   x+tAHXTHgTGebZRHbLGbEAmoavAouZSRWb398JiRpFb1/jbnoVE2J5EbZ
   XWR61kqHYnDArcc6jJ7h46m7kANrtieynEFbB9ULtLrdizzhWlYroTWMQ
   T8l062VboovCyqRRdK13+RwTJsEn7q0tsOb1GsI8VjVvLFddDuxnTsCpN
   Bd8HSN/aSbbpGZM4UDvif5OgAU70QxgO/rO5e1R8XQxy8Wqt02v9BRqh1
   BTtqFeur4g+4jYB0/mW0WCmegFZeLQtINGkoZU3ihUg07WHClk608t+2e
   g==;
X-CSE-ConnectionGUID: J8ecTbI0QWeIYO3f77ik7g==
X-CSE-MsgGUID: W+aGf3ECTmWUBE/4ssEkVA==
X-IronPort-AV: E=Sophos;i="6.14,223,1736784000"; 
   d="scan'208";a="42211788"
Received: from mail-westcentralusazlp17011030.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.30])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2025 20:36:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCQW7JtYymBKcu02tYEA70lEnvnUrmyvfFHIsdQ3coVC/y/pH9pWvRHZqZFbNOABzMvzIjYtLAM5/9GM1e10na2pafFonyUJxF2FwjTcYl8MtICPtP7D9jno5LZ/lCEc3v946mfxItRg58BXtWYMSu5q3u3X9bJVzHGSmntrHQcG1RxRU8VSVW2sUrcByyOmgVzZaLs3YJyt/cSddIx11/pSnPuNBLtuDvjJhNW3SGtgXUDWkqAzHp8HPos14D+eoubXU8t/L4y/tHh52TVLOJm2Taj1T8wpYRXAQAVxdnu2GVKDVIK9OXg50MArfw7UtytNL3HH6zBGdG5OUXFhWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpAN9A+B0LZ1SE/fkAWDE1jhLBXZzYkdjXvfVP1K1EE=;
 b=w+x2g71Z11TvRUr2MF5Dh9RCTZJdtFmbhWFtAT4WdPesBozmGAADiwq22lBLhgHhCcoMX91Hpr/QcfPX0Jd3SW54hVtzUem6v4dgq+FPwZduro6ifRinXFkFX/7n5RrPPERvLJ49N+bEwjBGhF5N325TVdmRr4dBK5u2YQcLUwKwOr4YGxHi1KZd+IUB5f0SDeONCnJjiWHRTVqcezsqU5yCtlXyvyoSS+WzHJQiZhPJoRxmgr06gL4B4sDlEp7qGpY3Aqy829iO5jP3Ngu51cUqquOV8/RaTlBzpVkXRks2FUXDY6ZlJzU9hZpiTFne4L4smsndUJKWS2spDfLCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpAN9A+B0LZ1SE/fkAWDE1jhLBXZzYkdjXvfVP1K1EE=;
 b=sSWpKK5UzZpoKkpHHNUa20svN1E168nWivTmUDIowniYac9c0IAYywoA1Zxcb//X3nGed8a0gHvzUeWxFNJnNFgPmTDp1W8ym1vWXDA9AHIktJst/5xPd2FUIFs44Ik6xbk+nLmHq2dBRLAJbTWgqfBu3h7mU+EVYFruCcmXtuc=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA2PR04MB7529.namprd04.prod.outlook.com (2603:10b6:806:145::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.16; Wed, 5 Mar 2025 12:36:22 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 12:36:22 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: Ankit Kumar <ankit.kumar@samsung.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>,
	"john.g.garry@oracle.com" <john.g.garry@oracle.com>
Subject: Re: [PATCH 00/21] verify fixes and a new test suite
Thread-Topic: [PATCH 00/21] verify fixes and a new test suite
Thread-Index: AQHbiThWkVhemomNEUelrPMLjFL75rNkg/WA
Date: Wed, 5 Mar 2025 12:36:21 +0000
Message-ID: <kkdwksy363kqx5q74kccnabibbvuwdvrsyizyxoqnhtlj44bng@kjjwksoai77g>
References:
 <CGME20250227053350epcas5p31b3b5b47590d70804dade59842d87b27@epcas5p3.samsung.com>
 <20250227104727.1794982-1-ankit.kumar@samsung.com>
 <35bee198-cb20-4a29-9960-075c510819d3@gmail.com>
In-Reply-To: <35bee198-cb20-4a29-9960-075c510819d3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SA2PR04MB7529:EE_
x-ms-office365-filtering-correlation-id: 3b35c4e9-9ac2-4839-bafa-08dd5be255fa
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?xBa5ZfRDGLjxF1r2nq19l++tRqfLx6UN7JTCP/tdZ+Q6mCU8Cr9zRUo3zHwO?=
 =?us-ascii?Q?ghlGAXE6ALUe2r44g6dLVh6X3kaVTzTCUI7CMI9zUbajG//vFlYy4VhpKbJg?=
 =?us-ascii?Q?UsOmTdlvlhW2IVmmxeBXtncfPaMeQDTEg5Y7ORfe1qCQmooDjMk2F/WvIpOR?=
 =?us-ascii?Q?vz32qAYGNLdPcE9gkQ/GahJLBMsITI6OPCAto1YEqNI0U172vBmuTYBA9ag4?=
 =?us-ascii?Q?jAvhP+svMp6hGbEZ+lflwA5ZXFHUeeXclYY+ez/0BbipMBJ50jfPPL863+Mj?=
 =?us-ascii?Q?rr9PXTi43Ats8X6p/mh+o7IBVZ5jbzG9iuSVo1cPdngrTnANhtSVEwWuk05B?=
 =?us-ascii?Q?vCkVfk6Av+qYj3YUvSREaDAgUKHrFdPcQrrgFFzkgVtpHq9jE32pEMZZAuTO?=
 =?us-ascii?Q?h1tm6dnzeYRWJRrAqB75PigUtleR6YP90osTHTC55d26pZmjw3aY3zfxLawx?=
 =?us-ascii?Q?vJWjO8GtiqkOY753AViMAd1+j7MFtN459xG3ZlSSC+acm5bxobHFZqiWUkJC?=
 =?us-ascii?Q?uOR0OJ2T4npm5rIxblJVjnm8N7ebNll0LXW745xn2qXquZofpn771kcMyU10?=
 =?us-ascii?Q?uqIzXqz5fzbJVBH2UwGzcMeLDcpRf3cenMJyBFgaE1OuI4YoKFg0TuYVQUfx?=
 =?us-ascii?Q?OKYYouGS88zwpRT7EbIhKaz9kUOQpcpA0MlH0llSdWCxIFOVKoNp5kycEukj?=
 =?us-ascii?Q?Xy+CTZT/KkbcH/uesjsj2hjrsPqDNMQVCSc8GcaAORJFBTmT+TMSSKMle5/x?=
 =?us-ascii?Q?DLHeNfA+QGQ7mpWrVb/UuALmG4v+0cmwIRG9cA5xKIcTTrbQwnV9xg0oF3bt?=
 =?us-ascii?Q?o47KTQRoTGkU/fWjssvJQQAo8Dh+HVlLcmKlQSNYC02zEYCNVHBKTeXhpbPK?=
 =?us-ascii?Q?BmrE1JnOThRR6/ogqOI236dk5iBqGgqfo093IRx7F8IrP53YJwGwAqQPXH6a?=
 =?us-ascii?Q?PfrVDg96TVsN5OoLOpp+PVaScoTjK4+KBQDhIwynz7ude1r7mUMoX64thqWV?=
 =?us-ascii?Q?L3ZLdu9EYTRFsHeaPYDcFxVWA6ogDLGe4029+fmiVPuud+RbdduKwmh0TsQr?=
 =?us-ascii?Q?EY0iVJ3eA12PEa+Qx99oD8ay4tXTV8C1pjc/Wk76HXgrR2YJFBNiPAYX+Nxf?=
 =?us-ascii?Q?SAUtsSr3i+IliQvbHGiG44g2yLLMipk+shqw+8P9upFYt8/pOfYVuqR4k9/n?=
 =?us-ascii?Q?H9tQot1Qf9UYI+0hvZDfKaUxyBFePAVb/vp4YvSbVuCdjKSNgj9bVqFd28RU?=
 =?us-ascii?Q?HLxCKJTimqbGI2Tpx3VLEuF3+42U/6j1NhzJUzK5KKGyj4xyQuCoYeO8D8op?=
 =?us-ascii?Q?h8hHW/SCZZQ/kdZMuL/6LEhTuuYZlDM42CJna3K8D5jOHwfM3Z1NhRbsOpwp?=
 =?us-ascii?Q?AUlaQgUYJwl32mZ3mE+h+pWdptMTXrQwr04Fh7TvYNycrJJoPE4pVKqDq1qs?=
 =?us-ascii?Q?8J/is83Oovmf2IrdUZ5ticI6Uc22Sbyv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?J0sKL5I2j3We5x0WRT18Myyn2E+7O3DflGgpD3ZQmKBsYW77+aDVrpQso04X?=
 =?us-ascii?Q?vzklgAxcqxued6zF6ZUhP68ue6yEFlowQGswS/b2ASr9ezPCGT+RWdyxj9vn?=
 =?us-ascii?Q?ceD7iXb1bJuSf4sPwWzs5Nj1TQyi4kZY7oknPEyY4c3GRAaiBM7VL9DtunfF?=
 =?us-ascii?Q?LMNtImaj9IeBzbDo4JV7prZLrlZkWjDlGWboWs/v2gK70b5HZNXV1eBA4j56?=
 =?us-ascii?Q?OhR28wcrNR6qO/scguTVYy+kH5idVbLLFkjooQ7UX39EXB9CSqH2rP6VCPIM?=
 =?us-ascii?Q?iXgEP/flObADNaa3jbrc+OIe+D+SnzwdRDCL3xjyVZb7g+8guK9O+epfxs5F?=
 =?us-ascii?Q?LEEwXIHHfa5Y0vRLfMtcihqV9P/zrBsBaqQMKMlKMmo3/Tzu73jPjVkDrGqp?=
 =?us-ascii?Q?POZ2tv11tELna1GgYFxNL7HdYSBfGACIAuaZEe/WApJvQf21ctx1+xfxVPjf?=
 =?us-ascii?Q?ygTqxWkQakiMbzPmiqb/QtuM5ZWEHEpR+UFwyeTmG+0PxtYYTc2PBQAvCPuK?=
 =?us-ascii?Q?ouQ8w//pkkA0phfjUuiOmABoq+TvuwNQhThvw9tzPeI5Sv4CpdBjU0mFjZOV?=
 =?us-ascii?Q?Sz8gAZ4SxOHqyfS1kphUbm9AVI56g+3p9NCDpcuf+udyQdVvGXNgq4Ngk5EJ?=
 =?us-ascii?Q?DZYAmcbJBGv9qCEuxwCGii1OdRm+1H57mzWt0VAMRYhmTlZB0RhZG8+d8F51?=
 =?us-ascii?Q?14W4NZ36okE90bmC26/7MHQTF6WrkXq3RR664ozD7hiXJmg89si8refCY8xj?=
 =?us-ascii?Q?gget3o/ZBb68CnOQtv/rUfW6j5CA7hTzgEjmT8yavgXeGKIn1I0FxTWGzbEO?=
 =?us-ascii?Q?7pnEyq0VQfOHQKEOYpBLGtzeY9nTcg+qr7oPMaor4Mm0hBM0lJo2wCprcLWM?=
 =?us-ascii?Q?ixBl5ETpHzAnfY62yDxGunfKWip98eQfbaXiheTw98L72kf2MCf3FFf2jkJL?=
 =?us-ascii?Q?McYOmSErc7MZ1i92kYwcxAKpfqbWpxOSHQayHgPjhanpN08zhNmrDmAhG6Qn?=
 =?us-ascii?Q?nGQDneb+M8ntuRe4I9HHZ5qqpZ86PcoRT6/UMPPRKjzZQbf/H/t6VwHfmpO9?=
 =?us-ascii?Q?Kz4RUe8fg6ZKum9/6Ixyi51sVXsy95KWdZURyM4Hkgw5TKeTZwVAVYcqUw9m?=
 =?us-ascii?Q?n/ajCHxKAnNs3pOqncNHRVi7mJSy7XLMOGL9BWoovBZFrDAZB3kbidNTyYkK?=
 =?us-ascii?Q?9Fl7wRTnFiDSlF1Rc47cHICa4HhVYseVcR9d+c5dWy1+JhDfvXzUgN0v2rya?=
 =?us-ascii?Q?zd0XpJLyZA5idWhXSjjGsuMLQ4sdG86JHfWIV7uQ0KbrJq22HeLpI+6gze4f?=
 =?us-ascii?Q?MPhWRFinIyudVjFn9YIRl/B3Zl4tEShVlPurB7uE+OxDQZUQ7ziRy7z5XLi2?=
 =?us-ascii?Q?XYP1zG6mkflzyCdgZNR0iqSwtbXLdr5OlVQXMkmQmqldRE593ahahFcJk2Ih?=
 =?us-ascii?Q?TJBrRwDDD6NdEypDHei4yGHsZZKp4guTg5pWO3YUr5f2a7ZCJ8+qvSoFgl23?=
 =?us-ascii?Q?G1/xhpSBcKovQJRPk0tykh4oZqab8RhP3csUmQrkbkJ+BdougSwIg0Y4PwoK?=
 =?us-ascii?Q?O8xkwOCpPIvuUFvKP5g7qKgS7tIV313s3+0Y9uMCWbOh1k+a2R+DLDC1uvGc?=
 =?us-ascii?Q?AEV0jviW6lzB8kQVq3MBChM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D07EDEBB4E6E274987579BE38F659A13@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	beSbH9VTPtad48fOU/gwbO3MN/Py3yNDArnQPAIp7K6XP1hkK3+lfBP+NoSk/w968gbSfM3yPI1zUNZdF59INejm4sBv7XIzz60Z+pPCna/3u9sClc0nW0uli+U19J9R1ZYeRBRaOK0fD4jjt/iH8kQpjOiCGT6A5JT2vr4KSTDsaWyu2POvpramcteXD26qzAAsbtnWo1D9t9RMBAT/DN6hVLwk2cCnNi/3hAtRyJSnrrI0zSiaZvhpMaYvSuQUszrLbDglJUKdrErKWHi1y9bHsGbuEbgt6h/GN8ucAE7l8L7uv1tKoH2zEtUuDr3ZbqDOAB04NKK/oDXaDQ3RIkgzAHzYoPxqcIm9GqrC/Evbbl9s9QyhfoRu2Fx0SZ0jQweTlXksleuadsL0EUFlDG0ZLjVt6/2onsTd8MPjnDxD+rZWkSTxBIV2N/fiHETmN7BMUeGyqgIohHYYHzvzEzQG6g3o8iY003whQKTFUMH3ahKWeblgesf567HaWHsdKfSlGgIeBz8erZH8RwccOtCZqOFM8m+FRa4muigqF8fqg3OKWbm4QwWU35Zzkh81TLZnT+AiiecKn27AXlaF/UUO5rDNwCXPmh903Sbfgn/7wWWWCqF4gQxLdydfjN6Z
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b35c4e9-9ac2-4839-bafa-08dd5be255fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2025 12:36:21.9326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDqVTyCkzSBWz4CiC2wGoEFMV2I6BRZT17un15m0cfFrZL0uTu628915oQoG0844OmIfZjBn5pcPJgAGXg/MvMJSL+vbiT2R18bdLV8nT5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7529

On Feb 27, 2025 / 11:54, Vincent Fu wrote:
> On 2/27/25 5:47 AM, Ankit Kumar wrote:
> > This series fixes few issues with verify, and introduces a new test
> > suite.
> >=20
> > Inital few patches add the missing client/server support for
> > verify_write_sequence. This also changes its behavior such that if
> > verify_write_sequence is explicitly enabled fio will not disable it
> > under any circumstance.
> >=20
> > Numerous header seed mismatch issues have been reported. This series
> > introduces a new option verify_header_seed which is similar to
> > verify_write_sequence, which allow users to disable any header seed
> > verification. For certain workloads which used to overwrite header seed
> > before verification, we simply disable the header seed checks now. This
> > now includes a few more scenarios such as verify_only mode, read only
> > workloads and workloads with norandommap, where the header seed match i=
s
> > not guaranteed.
> >=20
> > Few more fixes related to verify_offset, workloads that have offset
> > modifiers, verification issue when multiple files are specified, are pa=
rt
> > of this series.
> >=20
> > Lastly this includes robust test suite for verify.
> > CI run result: https://github.com/vincentkfu/fio/actions/runs/135522484=
90
> >=20
> > Note: The fixes in this series doesn't cover experimental_verify and an=
y
> > workload with variable block sizes.
> >=20
>=20
> I have worked closely with Ankit on these patches and hope others can tak=
e a
> look to point out anything we may have missed.

Hi Ankit, Vincent, thanks for the work and the heads up.

I ran t/zbd/run-tests-against-nullb with this series, and observed no failu=
re.
So it looks good from zonemode=3Dzbd testing point of view.

I took a glance on the changes and did not find anything wrong. It's ok for=
 me
to apply the changes.
