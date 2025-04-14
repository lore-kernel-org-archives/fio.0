Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC5F2CCC1
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 05:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609101; cv=fail; b=Wcw+GvbabwIQCEJUmKIEZqL7GJpYNg1PCYw1kfaV3yod0M4u73HNlLW3pOVrfzbz4bOQuSRGvb10idjyygGuLIIQeXl5LwE60M7OjrSo0BCLvM1/EUz4CGtgs2UABVg6ogjO6BkaoAQgwFFfOfyhPzN8wZbcwkoAU9w8doENJZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609101; c=relaxed/simple;
	bh=mDoSfYYrtCiAouB8s4EJ7bHeMD7mwY50cUaGGku3cVU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u0GBdmbZlhDnaFdwvCwZjgEV6T7ZjnTCd44YF7gkz1DKVUwU+EJjrx2T4/NurCiN4AiGvakXUgVtTkdGCBTpKuYOKgswhHMJG+w2zATr8TK+r6JnKf5VEAKtiLLPqXCaZRJQ6bQ4oMgC5mbjRJ9brgB5twh93UDgpWkDHo1nkUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cjE0VM1X; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=CuBeyeiH; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cjE0VM1X";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CuBeyeiH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744609100; x=1776145100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mDoSfYYrtCiAouB8s4EJ7bHeMD7mwY50cUaGGku3cVU=;
  b=cjE0VM1XE3FUUUudZ38+qcT4njjV9EHiTqpi+Ub27rsmEkEjBOAlk436
   EZt3AWQ7W1q/SYZ387ZtLujLSZF/pS2cZ+kJ+DJkF3oJaSZcZV6XFuh8M
   G/nMO5JEQPFlHq7dQC0ZHgBOHqX234tIoLkUrVxccgrKFDCtl1e3QTLWE
   9TM3Gq93Kw++L6DTjQxugQMkb9cQezMtAcZ+fuc6rkKTsMPYlrdWYAh88
   IcxMpNB//c5ohvy4Vbjh1WMSaVXMERhNJZVjo1GWd79FSed/TDQ99uqhC
   0W9fzqo4k755Ho4a3f2tQmKNdPaN7FCPfKMz8EawAJeaolp/fv+t8YF6w
   g==;
X-CSE-ConnectionGUID: YigxPCbcQi2o89tQANAxJw==
X-CSE-MsgGUID: QfNI9V1PRUeCPlY+F1NB9Q==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="78064273"
Received: from mail-westcentralusazlp17013074.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.6.74])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 13:38:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mo7OEEZzZ8vZZO8W4tNqthbesJqk5soLgYnQpvAt4KuCj38SqTtJtmA0m1IS3PQGgbsi+6qy6us34S7reqJ8C9FplUPAYJT/d0W4gS5Ls+PbXlohyo7hxmLFcv7dE82hwhngglNqFEsM7KnawND1+6i6uxpwWlMzRum9m8whGFhsqxF+uk7kZGwCx+UtZJ9GB+tlCY3/n4SN+mRRqCZC1s3si7KJonbZzBJXAsTjfE4o/FXb4WkFlZvzU6pPhGtdV9GgTRbI8TBo28ifFSr3a3sNPnaN+tYXLVSGkb7yY3K3fyfLoxngFR27G6YP42eR0cTHVP969PaM8Z4dQggRWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lmo8demcMjTHxfGPicaYjd43YuWWyY/KNgLGAgxG+d4=;
 b=LbJAxPd2toSfCTyKceYBvThx+ul6mhDClhCwg7D7llJleO3uuAaxzqY7WYJKRUNMBDLvONKJZdgBPC0tf1ZKYTkd/IYXy6p03yO16dCbP8aWcmZXci4p47+b8dgeYjQXB7GFCR1UbX6kl+xOGFUdx5uVsL6nMpml1KaC2NRHZTfWkRB+tvkqca09PvEV1CNNvTJ7RlH1O0gRHbPjdMNUPOtm2eAyo7Zq9BNcOGtzrHHJMYe89xJBq3sCWdX/AzM7qEPf0LqdVZ4dWOLfTzcsnfyUynkTPeGbyhQKPBoxUPsL/Xw9Qac3t3RYmN8Gw1CLbIguSFJNVRTX1CZtag+uhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lmo8demcMjTHxfGPicaYjd43YuWWyY/KNgLGAgxG+d4=;
 b=CuBeyeiHghT+RPa/mVKP5K73Wdz+DhG8Ba+Pj2At9M3s0MQlA8EqHU41ONBn137ONwXu1jOGkBEZoaMFaInmMtd1+f56KRRKrI95ZQXnRCEEVWN67SpoDUnthurxxWVXjwkz4SHIBjpMpKCWLyQ2YCEZ06F1y4Typzu25ihDJ7Q=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MN6PR04MB9502.namprd04.prod.outlook.com (2603:10b6:208:4f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Mon, 14 Apr
 2025 05:38:09 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 05:38:09 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 2/4] zbd: factor out zbd_pick_write_zone()
Thread-Topic: [PATCH 2/4] zbd: factor out zbd_pick_write_zone()
Thread-Index: AQHbqtKdQGXE8TTBYkCb4OXPqc4fCrOiVIiAgABUoAA=
Date: Mon, 14 Apr 2025 05:38:09 +0000
Message-ID: <qbpvaep67bq4dgc3oxuqsqbqodws3s3ejj6njnp47hppqe5fdr@upstgrkyywyu>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
 <20250411111219.57424-3-shinichiro.kawasaki@wdc.com>
 <2d3ab242-0a2f-4633-9c1e-92fc13e0e810@kernel.org>
In-Reply-To: <2d3ab242-0a2f-4633-9c1e-92fc13e0e810@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MN6PR04MB9502:EE_
x-ms-office365-filtering-correlation-id: 8606f8c5-961f-4088-779a-08dd7b168a01
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700018|27256017;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?MgdLvCFBXNpJygykG6rmLRbg9RMai3bjwSCvUOxb3ZW4PjcVV8ahfb4Zq8sC?=
 =?us-ascii?Q?fsK9/9+F3PI24ooG3eKp0cHNEteFR+16WC6ygNkqrM5JnLoauGPPv0n+ITd8?=
 =?us-ascii?Q?OlWgIVS3hE5DFLrtTeler1fpb8DhqQNzkj89SdJYaw8yI41ayGj4IAxOZIGR?=
 =?us-ascii?Q?IJduaeDdO/tHk1m8oj/rfT10wvJPy291xSILjXrwmp19n99SO5UffY1t3Mj7?=
 =?us-ascii?Q?+6mHf9fNLEdFlo54krZOhjwm+urWRKYsWC7nBe+fnx5DaBXm/zsjbkaw4b4F?=
 =?us-ascii?Q?oO5692lSemyVRfxPaxnGvV1y6/d/idrGvjCjXDAdZKiBMBHuRJ1JWUh4zch/?=
 =?us-ascii?Q?NFx1BvqU58SvTBbRqkmz1mTg0KJdGUvOo1PmC3maGvhdm48o4+Q4UhRGQcb2?=
 =?us-ascii?Q?2AaCavvJV4zXDWcstt8u/XQrHHKPjCbh9exPXnLOC532/R3Pj2WQiH/aFB5L?=
 =?us-ascii?Q?3RrVIIoUbaXWVbuPw+9OjEmp/4uBCWwWQTPDf/KZ4McrbDXIEcIzmyqt6S9t?=
 =?us-ascii?Q?NhLiYcPOzPjuxMBy9VXDXI8tJxcKV2OAfxG1Nr5rgYIOmEvbeL/zoNK1y0qy?=
 =?us-ascii?Q?a2cNERdTR1S4uwyCUiamiUimjIWKO4qTUJTqnlE5ZReWdZI6tof8ObSrdzHX?=
 =?us-ascii?Q?KuvJC6zY+Eh+F19hkEgBRIlxIW5qb38xPcJlYxvWJytbiFpTGucnM/TGsVf3?=
 =?us-ascii?Q?roG9E11q3adlPxp9drL0mdBuIzuPce5NYY06t3WR0x2n8p3wtA3m7iOb0ZCO?=
 =?us-ascii?Q?cLijYIAvHkTJDZ47dQYgSV61micniIN6qy5Ny5gRvUWytltVNngnWLXkk17D?=
 =?us-ascii?Q?QSzSzRTCgXbI+JTAWGVhpHQNGzdd5IB4TDS4zY8r9CX6IlHF9LA+adE2lQ7h?=
 =?us-ascii?Q?piPMKeInVk/PbGg5zQKbT9jD3IHdTgkJuSepLar4Yrv2JeJBzsgJiAOADrWl?=
 =?us-ascii?Q?EPAdmp+Cl2WJZYmCNL/2HQ0daBvDpJFmY+VnTPGoKZ2Q2Q1o0/hBb6e+/VRP?=
 =?us-ascii?Q?5URiNZTZ44vWXw2QS8KtHOJfa1wK8+G+Yw+mxIGvppokR6/xH+pSMSrKJysx?=
 =?us-ascii?Q?1mEooIWLQuLIBq95NQZNakL+4iD+Gdx9u49LH9e7+Imm9ILOJoirHFgou9JV?=
 =?us-ascii?Q?7QXWFTzevjpze0jdlEnNgafUP+NoVnoDrmK3UKC32WRaaffkKlTtRD+SeNuQ?=
 =?us-ascii?Q?qbmwojPyZCOl5qT+GBDHj3ByRusy0jCNw/4F8UzY75RBnC7e3bbA0VX8hKHB?=
 =?us-ascii?Q?rMYnB5OVjFMVdRy4LL7TbAgvhB+6U8YnlvLucrXJsgR7apQeozqm6AUb+gR7?=
 =?us-ascii?Q?9n9hzyGSrtVRkkO8/5iWjW1GHlpUQ56Df9xALkLHFWipIr1Yv8yeulo65WtC?=
 =?us-ascii?Q?ewuFM3k4sC6pMlMYJaTlilElDbN+x8eVaViH0hAr9m06SbmP+vdMNKGrjWzA?=
 =?us-ascii?Q?2auJZ2Fsb8joblNbjo2kyyIlERE4HTUGpG6yCJo9XJ1oyubUpdV1YK85NiPl?=
 =?us-ascii?Q?GXWud86jJtx07/Vm9ulP2+ORRDvBCzTqzB/u?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018)(27256017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Al7Wq5VbKjAjjri46r7XXyVLOrouq/hjpA6uro8oIMvieFEtoAJFfDcW7TjO?=
 =?us-ascii?Q?CoFu4Fp2qIG+3KVNtHdXkhRNIczQyQelM2o5mz58IFvajz2Xuz4VS9YcqKTZ?=
 =?us-ascii?Q?Z/i/t5Nohf6/odnSqykurGkN1U8qSdqujE7y/cvmLAz3bQumUu3fOvdNYUZ7?=
 =?us-ascii?Q?oeqqU35GkTHsqiFQPVem8XM9mHwIKx8j32IVNqXN2bGAMTz50H7yPH9yN1ho?=
 =?us-ascii?Q?SfhvrK9/NhNPcf54Xi0py2J4r9TLF2qdhofoVNylMv2m8l5bylQY03QtVCyS?=
 =?us-ascii?Q?OnmU3nB09aQolCbHSYphpMLYB23YYNz85K+GwvFNVszPvDH1EuGHnkNPv21g?=
 =?us-ascii?Q?D9n97q3HTlLbodYLwmBJZX/8PLnYo0PR2DxAoIFaXxWsFbLRdVozfn+qKjsW?=
 =?us-ascii?Q?j5DjsbodG/AZaey+NcHvYs6+sPVtOBb8mPUc653ql0XxzPztv94RJ08UZ/+E?=
 =?us-ascii?Q?wmnlkIu7Z16cIJtbK2qacsWX6koMgnFH5SVd9b5Xv68FfVHtSi9tlG2eCoAS?=
 =?us-ascii?Q?c9hT1262VQXp85jlvTifflKyhSNOy0lLsPqDxlG+7oc0reO7b6tavLYq+cUd?=
 =?us-ascii?Q?R3LijElB478tXQ/lDojT2kbH6W0fGJS5P3P14pv8+kYkcu4HLfmCJ9Ew8eQD?=
 =?us-ascii?Q?UjKf0Nn/O4ENKPeFzRw4z2v1Lz4GQJ2LT02h26VP0N+vZPmavJOlGMNrJ7bw?=
 =?us-ascii?Q?EXxNkE17lU7lV6EUjRnptqbkmUb047kqonxTWB0qD73tbTeh63rLseQ0XcOS?=
 =?us-ascii?Q?S9HnTGX8A+EwAcm4ng04hMktYo3yHm+zQEeZH4GMzhTtlGaWTclS/TARXpOU?=
 =?us-ascii?Q?Mbfqw0KC9S+ZIgCVQo4zCBHCSD3EHU4ClYLhao1xpEPbf2rSF4qEblQqIbZN?=
 =?us-ascii?Q?uUwon3iqODYxkOZWfukmHUTXi/Tx/I7JDDZrSEu32vBhCoKPabhlrX5ma9Az?=
 =?us-ascii?Q?JjlMMet6iKFLn0Zj2NNfkO81RcM80A0c7h9gWeRgdAiBsc3ZkrYZ2jEgh/Rh?=
 =?us-ascii?Q?E3YEdv4wKkzTQomLU+wITArTDZNAcIEnMWZvFsCqD7m2EMUoqFwjegDSZayW?=
 =?us-ascii?Q?45yur1E8I82WZla2EuEZiRVWdMgBBqD3y95HgnCQyLGKoqH6bFMeZcuOrxnh?=
 =?us-ascii?Q?vsx/8NiN8hJcUkha/uRqE4Avs8KeCz43Pm1e4AgA62a1N1anySRo3MGwQ12Z?=
 =?us-ascii?Q?02gfR2TmOwX/v5+bt4crltVSTGQmAmhcQJ4nfgAYhNHJxbfy0LTe4+NjRaSi?=
 =?us-ascii?Q?q7zcXKBYfsCjD1v73Iw0IIa2e7KGg6n8FnsPWE7Ovv6krD0kOFzLkKYUaINz?=
 =?us-ascii?Q?6NMzkDOoJwB9zlcWF+Jq7clL0eQP6tmcdZk3Kt2GjTv8jm2gGTcr3qbJiOfd?=
 =?us-ascii?Q?JWr40pEBen5GtNGL32+tRBQcVFvJdKYlR5KJCC8QB/toHZzQE75uC9A0uVYq?=
 =?us-ascii?Q?e4+goHnFmkseINY4cXu9W4qSQrNPVlLj/1u6trERmAXSIlJ/7QRyyiFa5wau?=
 =?us-ascii?Q?Y7vb3G9L4CZSPDrVpLXWbagp20nIUU0MHBhayCO4m1R088hgpn1USf+IPAwQ?=
 =?us-ascii?Q?SXu6xs0I2vl1ZpeaKn7lmuQDKJdgNBalzoV0pGqXPYi+BemtDPJB9YFNyQVr?=
 =?us-ascii?Q?0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A8120B7B4C53284BAB16CD0AEF853A51@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ymmKJ57xXO0HtB+AYZYEhejotBfCeEBSPzoJTdSAkP0R+pcbV1Rlbd5i/uF9VzCLPzrIL4R5pN5EIrvinqmbO4CvEVSaCm+yqlPQY7znAlnLre3AGNk695AM60/kd/N7VHPmnBGFWpeUqtGc6r7SPpM2yTcWnFHsS2U5eM+KJc0dGfxxWJjMUDiqlwNx5+B4sFMhjIsCVoK35IxbRjuLYvGPQHz1eqElOCcqTrhp+Oa8PFxkqvNoqn0wSV6c9RyKBb1Zqk4mIeb4qIkkYqPDa9lfSssy4MYWQW28vrqeYcMxdrw3gCXZp22d1sGyEyrRnQvo/lfK50XtD7rdEbuDuPAkwuP8XLQWFuGywYq5Z+Aj+wN71t8fMGf6ER1sIVwSBGlkp0EjjiptkzcHPgvrZ7yaAYb7ydzC543Uy5a/dZnHIlDX+xGw3c6J9jfD6bbjylYu3mmbMbXCDON7fJRUP3ACbe79O9vLJqjgA3CTqihTLTlt3aYQF5juZJxr5SgjzmsffSzurIwXuV42h4QtQJbNEIYGulbzDQzvGVVqRp3CS9nJXHwA65IUiIth0L0RgnU2Uew7PB/oSagBEac2FR+nPZvMVBSe4LnkPndMUOnWSS7Wgb4LWzxyHf7tJUiT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8606f8c5-961f-4088-779a-08dd7b168a01
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 05:38:09.1315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZnccbZBJDN7CZ3WWcrLz0lfgr8lrHLQTLgY7GWj7QdVz9OkOnqA/Q1z8KWsiEzgWoGs+2PO7Lm0Nnag8UyLVWMn9nxbCuoYPhkRu6HYTPgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9502

On Apr 14, 2025 / 09:35, Damien Le Moal wrote:
> On 4/11/25 8:12 PM, Shin'ichiro Kawasaki wrote:
> > To prepare for the following fix, factor out a part of
> > zbd_convert_to_write_zone() to the new function zbd_pick_write_zone().
> > This function chooses a zone from the current write target zones
> > randomly.
>=20
> Maybe:
>=20
> This function randomly chooses a zone in the array of write zones.
>=20
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  zbd.c | 81 ++++++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 44 insertions(+), 37 deletions(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index 5e0f7f4e..23c18bd3 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1386,6 +1386,43 @@ static uint32_t pick_random_zone_idx(const struc=
t fio_file *f,
> >  		f->zbd_info->num_write_zones / f->io_size;
> >  }
> > =20
> > +/*
> > + * Choose a zone from the current write target zones randomly, which i=
s in the
>=20
> Randomly choose a zone in the array of write zones and in the range for t=
he file f.
>=20
> > + * range of the given f. If such a zone is found, set its index in
> > + * f->zbd_info->zone_info[], and return true. Otherwise, return false.
>=20
> I am confused by this description... This function is not setting anythin=
g in
> f->zbd_info->zone_info[]... Did you perhaps mean:
>=20
> If such a zone is found, return its index in f->zbd_info->zone_info[] usi=
ng
> @zone_idx and return true. Otherwise, return false.
>=20
> ?

Yes, that is what I meant. Will reflect to v2.=
