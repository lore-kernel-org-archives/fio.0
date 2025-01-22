Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2761CEE8D
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 08:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535569; cv=fail; b=nKUn2wV5Qfanrp2b7mW7rVTU8GVjV6f5M/yXbdkTfkqSDmypm+HXLM1LQm83ErucAo7581dKiIFY+wHMp8ON3+H5kC0UwJnGbUuDiQYxgDkNrXh5Z8iMNgo48CxHgYhe9DnfBrdU9M/cS3F60djBgAoB0o0UholqkTYPWftmedk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535569; c=relaxed/simple;
	bh=V91SQVErdX05uwDwWTQgmsTfhmyyNNjujOByB7g1Nmk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DiKTifOEekEl4O8iCwX/xJXmsJVk4uMSIupgobog6Se2Tt4duU2Smgjj7kYKCvVEaGM2nrrt1CgCjeIplj8Bo+FSAyCQzSDhDMKQ1xbyMPLhPQ1b/1pe7aRyIBhzrzaLMwsdseui36aLcN4gMyRwOgNn6ASzuXDEAlvjqcJGoLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=r2BsX72B; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XHWfkH+x; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="r2BsX72B";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XHWfkH+x"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737535563; x=1769071563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V91SQVErdX05uwDwWTQgmsTfhmyyNNjujOByB7g1Nmk=;
  b=r2BsX72BkI+GF8/awqZN68N4/zZHQgyMuEnLfq0nmjs/H7yW6RkGI47g
   WMC1IY8nN2RvhsjOqHIUQUMdl0JWJPG0qWQpP2PJnJCuoVsrdbF0if/9l
   UgOcVuvknWhB/hIH52iVCB7z9ywh0TyCNDR2+2i7Ya5ubrALEJmJ02RGv
   toHqGeD5+LM2pZKXSBJPAv3P2DOEqr+ePf9zVWQtrywbmCHmAnaGB5gpM
   MSRQc0givyKpRgxqLBAB5kzPoT1kpr2ivzKhfQa42xnJhP2Cg1iMHdrxP
   Bs66wlq7duVpSLypdw4vQ7WaJk3Ca/W7oJz9lv1CfijCs232gAclUPNKs
   g==;
X-CSE-ConnectionGUID: YRinQ7paSxSAisWXKjSTRA==
X-CSE-MsgGUID: DfwiW62JTOqBrtSh6ojFCQ==
X-IronPort-AV: E=Sophos;i="6.13,224,1732550400"; 
   d="scan'208";a="37528395"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.11])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 16:46:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ah2EwBWdt48UMbKDLx1KClWMRIDwUzGiEHL+nRUWpadHg6oe/SeVFXKfM/D+fAXiaDsoyl/4Ei5n3gqc4pv1TWHhn4X/ZEBXMH5tiU50nYOm5KqLFhSi/UxPko2tu7DTV8nXuZIo/7gFLNxe2ET2KJVkI4hDO2PfasWOdNRco2KFVGiKcvxVuI0MGDhbjJKJt82zoR6ncwUi9/0InfsLNPdyD2xoCLh+gJvi52sRajV9t0WqYdEa70s9TU86XDaeoM3ikeLiWyYieAzdB4DsTMgudLvprLKdSxdASscfIe324r3Tf0j9BYLC8JoufoFcXP+CtSSUoVxIS0CHINqr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Faw0QqnaO8HAV6jjFwA83aOoNyT7LxV0wM5PMZ2FUJE=;
 b=wmqJj8++17IOMnTDdy4K4W6DW2FodxRQ4OMsOrR5w/tPStQ3VpPzd/3kuwq8uCufsnjY2aHY7q3B6iSHREgmhuUuruorMoJRwJh/iXLgUQ3h6/wLhfyvrADv+I1tA/5uLYnTXQonKQEeqQC3rfD6kuHbUtDY+PT9/+94M0Ec6umYjlBu6WSR/aAZd55/MnAJlqM5S+xPY1aOvczgjVARo59cB+400kJ1BNJ2zws+0BpIKhr0zDa/YoyT8vy/NKfukgwV1KL/OAjH8i2BVXSGjVGibt8rReHamHhakjSRcXNJUw+UIH6oUileq+1XbksCUlHoYyXgt167GzyYnuYD2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Faw0QqnaO8HAV6jjFwA83aOoNyT7LxV0wM5PMZ2FUJE=;
 b=XHWfkH+xDbFJTiAsQdDj9dnpIMYHs7lGk1uvWc9CTsP1qqW1wL3FEVgAJWTZUMveZVWiPkJxb2jy8rdyw8KLqbXpeyeth/a7axbHhlnp8P4h24M6YSN7i0ItvDHJHqpATufJtZC4C6lmhrV6yKGHq8Jp3Chol58f+bVIFH9Bm9Q=
Received: from SJ0PR04MB8326.namprd04.prod.outlook.com (2603:10b6:a03:3db::16)
 by MW4PR04MB7268.namprd04.prod.outlook.com (2603:10b6:303:7e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Wed, 22 Jan
 2025 08:46:00 +0000
Received: from SJ0PR04MB8326.namprd04.prod.outlook.com
 ([fe80::5088:5f08:45a0:9a8]) by SJ0PR04MB8326.namprd04.prod.outlook.com
 ([fe80::5088:5f08:45a0:9a8%4]) with mapi id 15.20.8356.017; Wed, 22 Jan 2025
 08:46:00 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 1/2] zbd: do not check open zones status and limits
 when jobs do not write
Thread-Topic: [PATCH v2 1/2] zbd: do not check open zones status and limits
 when jobs do not write
Thread-Index: AQHbbG5gst7VcIVgmEyGTVSaE5UTb7Mie0GA
Date: Wed, 22 Jan 2025 08:45:59 +0000
Message-ID: <Z5CwR9QR_HM1vLjy@ryzen>
References: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
 <20250122013835.1223725-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20250122013835.1223725-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8326:EE_|MW4PR04MB7268:EE_
x-ms-office365-filtering-correlation-id: 20e2ef4d-9826-49fe-d8d5-08dd3ac1321c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lLVE41vnMb1VJkYa1ABRlNhmVorpepVg5lZRuHwurWj3AWHBN8IV4gVvEYJf?=
 =?us-ascii?Q?Tvr3UeiIAsx0h3aDIgMKLJIxEqMn5eE+aDlhFbkGLBSG5YxYwHTVVuv/JStl?=
 =?us-ascii?Q?xt7ILU7ZhsehaeYZ8VL5ywp/mmCNuq2q7wQbEjoG1sJKn9znn3cfLj0DzXi8?=
 =?us-ascii?Q?hUR0TjctiZT8FVEMSrSy5xgk/XrjF479bAq92T4wBTFDLPeJEM5Oo06cTZMX?=
 =?us-ascii?Q?BJeAwK4+66asV5S/ee5htQv1BjRnYcWktt5fyvgLJDFG2zXdeBe0cVOhsR8X?=
 =?us-ascii?Q?5ODR2m/KvHnB8Vcntjw0yv9cZ1kSId0u+imJ20f/alu308NmQs0bcVMiJfON?=
 =?us-ascii?Q?mq5zRtmMX9WEVMxvVzRJEyCqaaR2DyCHnXzf9iIE+xRZEp3NKcNFNmKVoEEo?=
 =?us-ascii?Q?rTyJuEma9O3/WjPabTiIQCYhTY/HTmGIGkTnFT2jH4YMNURIKhQk3edU3XeV?=
 =?us-ascii?Q?G7lbMbrOwPyiXtICNxYtwHoGLKXbABUwMicsquDwyLh4CGY2nEFQ+RNEW4oQ?=
 =?us-ascii?Q?qH5/7FTV7cAPY4m01AUGM9QE/KFv26DxHjYQut1Dzbvl823GTQ6ghMDPgL4u?=
 =?us-ascii?Q?/y5SIxJ9pC6xZwjY3cl/Uk8cuQcO08ZG3mA3svZrEK0cqYUfFGYnFyTZ+nDx?=
 =?us-ascii?Q?lQzUgWhPOblXeGxxxnFWgT8fjhzFajJxpFOGG3bvi7D03peiDLoLW4/Eh6OD?=
 =?us-ascii?Q?3i4nrEBw8v2kMLoLrIPvm53yipW7dj9ZVo1MAw/GbBmw+z1PpuIed2tLKcnr?=
 =?us-ascii?Q?8hZrNX9JbolzKJMMpDKyl/jolwXW8WfvBALy3qdBFb08oo0ytPs50RdvNV+3?=
 =?us-ascii?Q?yzhr1X0RS/Qx7i6+lSueadY2QmdZaay8l+Wfr1LtlBub4bJB6Gwb2FigPYyt?=
 =?us-ascii?Q?B3QfTpgDRbfh4dS2fRcIxgFYCpZ5JyIwMdiJmpvXyNj+OJfkKtjL8VOVkGGA?=
 =?us-ascii?Q?aJm9PzqkZVNCWX/8wRHPOffwXmB/1rkZhLx6r2MI2kJM2v4P9NEQnqjFEcFV?=
 =?us-ascii?Q?gQI1QEjlC81aahzu8F5J75zOu1ghRnVOs7gQYRrMXr3oLIgxOkgfPHOb1iB1?=
 =?us-ascii?Q?MtYypiqkAocdooIGSLd9mOBI0MzwFP7xhTiKItygHiScc2aIpf48kF2+R1Tx?=
 =?us-ascii?Q?ZHHEBNo/L/PXZh5O9tTraQ+Dd3PTkQUy1ZKNQLuTNNPvwUSJ/8pNfUjS0pdW?=
 =?us-ascii?Q?GUByFHxcr5hRKToSDt/UGZnCAjg5GeR+Dmci86vd+O2wjrwtqLaad3xVGUMd?=
 =?us-ascii?Q?C9C77qRqBHV2UQ0n58bakl5OngsRNIL0pAJ7SELVKTE/LFNpOYBYN162fgTb?=
 =?us-ascii?Q?ropphBOHtsTASl4/46ICWzNAlV+RIScWo1JewIanQA31OdI2slEz6zekGUug?=
 =?us-ascii?Q?x9YX3MAeBv2O1CVff4bEZJWxphtdAJT+GgCdz56tdA31cYgw2X85UCUtPL7x?=
 =?us-ascii?Q?sa5q2e4dtNrhsRGwq2Jgfla4O+LJjVm/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8326.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?LAbaLMZ5TNeh1R7IuunWe6T53zvjziU9r9c4p+qLfYbtRIt5PyR4nuCzoNLY?=
 =?us-ascii?Q?MY0A9sGker1+s/LPmM5MXe85dkufVlcVuz5gJvmc4DSs8sPYc8+Gf0hOfMND?=
 =?us-ascii?Q?eNx3WIeOkUeZcIkQO3+M3TUNery3qM+a8n0cqzevgfWA+CGMZTHpcRFw+X7c?=
 =?us-ascii?Q?gFo9wI1N9m1GLPcNAM9Esk4jmYg+uwY5af3x+JtusH48GxIf1GzGWGW01Wiz?=
 =?us-ascii?Q?yahL9gssuSAVb2yw3RBXKBQWnY7Dc2O+cRJ+pScAb+8GR7zlmUwCmG1dSozs?=
 =?us-ascii?Q?Nujq6tUbJrzu6GO/xE87VmPJux6dZlA38fJtFgjz7COZsJaPRauxh6b/JL/4?=
 =?us-ascii?Q?+EAb9HX832RjO7C9kXqGZZYQHSzj8r7kWjmd0xfZqv1Hq+Ax5QbUhCIQP2X7?=
 =?us-ascii?Q?HX3gpMEUrhwcIoudEcoQVNfgBPUUWxk1fHeD0QZ7NBQeL98Op6aSKeeKg8wr?=
 =?us-ascii?Q?XhActdC9isySOKprzvJUwnHM734QMFVv2WSqY8MjJl+wCw3mgyxKAAwATDk4?=
 =?us-ascii?Q?YJAsg/UzUZFxZpuTMWv9fKwYKEjafYgcmDHnHva3HATQAF9fpPMFuXC/BP8s?=
 =?us-ascii?Q?58s9U9dDmGvKj0iMnEIuKl3ameMgCxTyWEa5NBeJ2VSbMg9TZICABuphRVnw?=
 =?us-ascii?Q?MCbOd8iY/WXnn4PhvJ6IOEJBcH/nFCaKpKF87ZsJPy/I5yceEQH6093K1Aqn?=
 =?us-ascii?Q?CDHoRquexPtxMTGBcm6LH+/h5JiolnngjwIwEdJj9MZXmHz3zDBJfHs25PPv?=
 =?us-ascii?Q?U5SkYr3SLQkOMpfXNbYvM6trOVbg06OXrp/Re0yM2B7v1GQX66OAvsO1Py1c?=
 =?us-ascii?Q?4Vi8ernM4ckQrMuXQCijS8teHxUd6LsBWy7OKYDTW5rNB4D3lOCoEflftWx9?=
 =?us-ascii?Q?ZeoSbli7kegsEy9ix6O2eWNxn+NqJaLl/AV5CqNd8fPkA7ON6yYQjjAg8IfM?=
 =?us-ascii?Q?gtlhGBVlHCx3UcFq9oa5AUsIOGwW7xh18vVSxWGOthwL/BdLiuezmCU5V+fe?=
 =?us-ascii?Q?soey0MDv5B8AmnlyzQ4t37LdkDOO1b8JYGaIMgW2j/pV9dFb8hm2pvcsdiyz?=
 =?us-ascii?Q?07m7I3ZL/jePdfHwDiJlzUV3HKZ6LbgrYhkYWcULVVFA8yOVdFmZ0SX7vm7U?=
 =?us-ascii?Q?25WWjtLmu+YRQ5MA0sFeji05TAIAfspH4Hl8+JtuR9Hcq+66NuA41mmpaNd+?=
 =?us-ascii?Q?gSNSTrf44D/ckZ1h6MHXiZ4s2XQ3zrav0eaxn3TL6pdSuftNkPvB1NvOe8hT?=
 =?us-ascii?Q?LxdY0YakhX4mxc82mURL34t8dElfdxKk6FezT6qvaqV1FSyya6OXbYhPnh6y?=
 =?us-ascii?Q?VC8h4D2nIGpKdN1mjeArfhuvJRh8N0246P2eUCNG1mU9fddO3kHY6eQYLhjf?=
 =?us-ascii?Q?5gtLMPem3DwEbemrtRWB3ya3n1ySGukA/qgqtbBMgd5nH0I/3trvvAcdkMOu?=
 =?us-ascii?Q?MNlJQLcgHoqoDMYy//xBdP+nHzhLL7ZT/7pD0fPd5QBEKw8PR507vxpMqxnQ?=
 =?us-ascii?Q?FTXknL1/XzJSJVk2+g0Wd4xd57A4xuUW9wuP14wSNJiXcxLj3Bh29CMF+kXa?=
 =?us-ascii?Q?lWObNgQcWDINs7HFPO27nF5v868jEXe3/5wFHldxzQkpDry93wkiIAdsX72N?=
 =?us-ascii?Q?MA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53BF067EB9D1E94D97C7310ADC24F85E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/hEi1rxyI3vSo93k2QC3P5D2dRmseiGyQ5CAFpeNgIIHN0JW258FbbPIIdTBiXPlx5PCJqYF0zJ2mxZBub6byONZVSfqCColMe9aFqowRa7e17LEcBJi1QEYlnOBIfsu6WUgbHimKfZU9u/Bn43ZgVsI1pCpfh4wq7eTlkB5SW7d/LtmtGmdahNjru5vBq3ErGHIA6e9e4YIUr+Iol10INAs/MPmkM9spWbN3oS4CwW2fDIZDeA96dszqlkXaTLekC0yVHLDAcb6gNxz9dYwdFKqNTpJjoOMw+o2SzgYBIxS6vangqtcqh7h0LRZBnSb3L/gdc48eoE84eDoE2CLsckxCCcxmH1qsHQuOW3fY2CxVZq/CIycQnEVLG1Qh0f9mNs2IbOMfwLnnYWQwbJFzXuRDSFc9bvtzak4fRk4eB0yPVleE/PFOU/ay/TDSxxQEZgMWtrIz/LTeZg7ftdBuwhF+zR/QCVwM5S9Br55m+rCoWm/rgITIl0H0V7THL9G/2HtGiKED4xJB6SF4vdUzbCb8/F9ocTglDP8U+VPE6v+fOtryyCPeRjCvQruIiBKiCirvMMYkFY5QCyWkCXq6XlGwlI33v3KAC0kVBmtDcCLgt/qI1gyT9acrUdA4em9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8326.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e2ef4d-9826-49fe-d8d5-08dd3ac1321c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2025 08:46:00.0015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F/c7ItIUqbNZpFfivFyLXE3HYC2dyCYSq2KWDdxn+d2NTNMiW3ujVAm5E0rSvITGvgC4ci93megJ2FkgPL9qAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7268

On Wed, Jan 22, 2025 at 10:38:34AM +0900, Shin'ichiro Kawasaki wrote:
> Currently, fio checks the conditions of each zone within the IO range at
> the job start. If a zone is in an open condition, it is added to the
> write target zone array. If the number of write target zones exceeds the
> max_open_zones or job_max_open_zones limit, fio terminates with the
> error message "Number of open zones exceeds max_open_zones limit". This
> check for zone condition and the resulting termination occur even when
> the job does not perform a write operation, leading to confusion among
> users.
>=20
> To avoid the confusion, skip the check when jobs do not perform write
> operations. Additionally, print the message to inform that the
> job_max_open_zones limit does not work for non-write jobs.
>=20
> Fixes: 954217b90191 ("zbd: Initialize open zones list referring zone stat=
us at fio start")
> Fixes: 8ac768899d63 ("zbd: do not reset extra zones in open conditions")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/zbd.c b/zbd.c
> index 8a092cbe..ee095b1d 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1264,6 +1264,16 @@ int zbd_setup_files(struct thread_data *td)
>  			return 1;
>  		}
> =20
> +		/*
> +		 * If this job does not do write operations, skip open zone
> +		 * condition check.
> +		 */
> +		if (!td_write(td)) {
> +			if (td->o.job_max_open_zones)
> +				log_info("'job_max_open_zones' is valid only for write jobs\n");
> +			continue;
> +		}
> +
>  		/*
>  		 * The per job max open zones limit cannot be used without a
>  		 * global max open zones limit. (As the tracking of open zones
> --=20
> 2.47.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
