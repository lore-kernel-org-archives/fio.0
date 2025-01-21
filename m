Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737E1BBBCC
	for <fio@vger.kernel.org>; Tue, 21 Jan 2025 09:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737450851; cv=fail; b=dKCCPzzDerUR9bKy++wwjv0uCDoIZuHLMWrut6DpxSL2vZVYeUGP3xOPuziGy1ILaX6I1wqyxeC88mTOvvELIgC6YVjyDCJ827ozV6xdRNvYMaAmj2Yy5GkwJGtGnEbHWcidVwYmFrQhdw3abLKZfQJS8XMBhLJMhPp+DmUW/GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737450851; c=relaxed/simple;
	bh=B40xcbjngEQqCW+NU1GMcmP2bBe7lXF+tq2W++scO5Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qR/n74xO7LWShgaVUc7Y1pfJn9poFf2d57rQcyagO0F15y41aanL7X/1dC+NaOxXafXi3VmuC7+vL6d8NE3Yv8cusSR17kLgN5LNK/n8Yk7eB+pBC++VGwD9bQnLzO3GWEy4xp3GsK/pJJvRvhy90LeX0b7Ufx/3mzyOlID8y0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JH4xJ5TS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=whjmj4LT; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JH4xJ5TS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="whjmj4LT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737450850; x=1768986850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B40xcbjngEQqCW+NU1GMcmP2bBe7lXF+tq2W++scO5Q=;
  b=JH4xJ5TS7oaQtSjkEhrgozDo3syYJRG0S8v67AV2o7ewzmYulQlZfZuG
   taxK/1R9+hSO5x6N6DfRa+wJf1Ni+vVdaPf8p0Uh+KlRHzBJ/0DuP2yb9
   ZdnInEMS88J23WETtDFQ26cvR0RML9/gO3P3OcAe48HsY13/DvPVVLDrb
   eoBargEfOkeDEKDs+pS27BpnR9LnBPvv6UaIAbLpKmX8X0KY5gJ+ALepH
   nFNBhu/FOA1IVA/KjQ52MmnVuWhfej0SXqOXefO0z+fP3RnEeM1L9Incq
   QCHVAHi2pPb0Ycu/cOGMz8Sg3GvYi+86Gebs3zw7daSf7VOR9cvJaW/vh
   g==;
X-CSE-ConnectionGUID: lixI95EhSdCCQBPf4TSTZQ==
X-CSE-MsgGUID: DFPPjArtTfmGswR3fkbBAg==
X-IronPort-AV: E=Sophos;i="6.13,221,1732550400"; 
   d="scan'208";a="36411328"
Received: from mail-eastus2azlp17010018.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.18])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2025 17:14:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wv0/pbxh7gFitSKb5B5BkUhIkgWL4Ez3rrWk/w2uECy3EZ+cZBf7h1Ag6mZI56fIBMA5YQHNYzFKG4OHfX1Y/EDyNgCbfXic8nsx5mozoCI5OHXyDYTqWIhZcQRD8FEW+rEIrInNBZvkmSd1mS+xi9ed9jGZV37O/0CgRUxZUE0OjR4Ry6BkyahpmHIeV+YNq4p7lK9XwidRyRyQs6PVMN9FEB9Xb9lcSkr7XHyB6tMpJb2dYwQDzVXqcDo0igpo01sQPA2XnHXRat+a2ks2YRafOwpgML95zcCL8eZAXD854Puizu4PMLuZdU+/gulHHKKfVEilrf+MjEJ12IlZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OraVymRs2qoIL2fgsPDDNOQvQ4cJV923HXNDNGkA6A=;
 b=HJLD0hddudABma0k3nin3KJcYT5clXRhLkIFeNgOadm1GtIBbNfCderPwarPT/DcdjcIV6lzK96azwp2NLIDcpYusrizL4nUX4IKhV4Nx+DvhpVOW6QGtKVo34mCZou4MBAZ+7TXCjfTeWNfEXc8XLIshm9Kb5QLgQadun1Gk8q5vL/I1rJ7TA1rxufKZrLujt1qCbNVLtjfINrytFUsLSmnMJbKJycMbMAhqq2FZ9jBIXi9udXXMPioicDGDikm0uGXap6PhYCzEYQ15QYzWJ3XgfKTgmQEPxSdNT2jMlCfkHVYpg6eJidVfRLqv63lOMJuGpBOgir7Z3BBrEOxdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OraVymRs2qoIL2fgsPDDNOQvQ4cJV923HXNDNGkA6A=;
 b=whjmj4LTaXJrDP5C608TWkkKyI5ZgybGsOo+OcB1YGga34OlQaXe/4ktZjguKZBPw9ubi3cTmptnejvczaTKVC3K8kswL5/7qpA0cDtt4fSG8JVNSRyBO9172phZS/5UniBFsg7PMYgd9vEB23k5hhnR8gNaDzKux8FoX7psB4Q=
Received: from SJ0PR04MB8326.namprd04.prod.outlook.com (2603:10b6:a03:3db::16)
 by SJ0PR04MB7581.namprd04.prod.outlook.com (2603:10b6:a03:32b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Tue, 21 Jan
 2025 09:14:06 +0000
Received: from SJ0PR04MB8326.namprd04.prod.outlook.com
 ([fe80::5088:5f08:45a0:9a8]) by SJ0PR04MB8326.namprd04.prod.outlook.com
 ([fe80::5088:5f08:45a0:9a8%4]) with mapi id 15.20.8356.017; Tue, 21 Jan 2025
 09:14:06 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 0/2] zbd: fix open zone status check for non-write jobs
Thread-Topic: [PATCH 0/2] zbd: fix open zone status check for non-write jobs
Thread-Index: AQHba9/6o3N3wK29yUCiDInBR26YCbMg8eQA
Date: Tue, 21 Jan 2025 09:14:06 +0000
Message-ID: <Z49lXkn6UvcohDum@ryzen>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8326:EE_|SJ0PR04MB7581:EE_
x-ms-office365-filtering-correlation-id: 8ff5d756-b943-48b7-f9d9-08dd39fbf515
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?X659YI3MbT0nCqW+B7W1jaeM+FM6R3qR65CIa/tGxZnhflhdCkZy8Mvav6cu?=
 =?us-ascii?Q?OcXdAHgarfg0uNW97diHES8/LarBZY83GhbA4NNUBCsc6ac8BEd+VwmRIEfj?=
 =?us-ascii?Q?+uB6T7Zwj5c+KnP606qa3ghf4oHtjjCTZLTK+nC/QFzP92+qzNBakiR1eI1p?=
 =?us-ascii?Q?bqvv+QxIUxJOKmmzazu0VEbmxX9wt8IPMwms62KTivF5IyGGo9k/SOeHAI3F?=
 =?us-ascii?Q?9zfKqlDSTp7S78OyjxyMoC66MjAWy1rTJVc3AlLbCD+qLHY2ecJ5wtL+x+L3?=
 =?us-ascii?Q?5jl6mmQhKYOBtFcbaWyXkcKRHRaFi6vAmQmE30JZJYWfI2B9Q+wAHB2HqZjU?=
 =?us-ascii?Q?Ng9WTt8DrK3QSiHPsP2Mb6QVAPFPcXoKCCoHSzLDkj/kbtztGs+z8Lk3aELG?=
 =?us-ascii?Q?gmR9b3YCXaikr781agtD+UyW1r69HMKH/6kVkoR/GiSuJcYGZye9GXcKcMzW?=
 =?us-ascii?Q?OuhawRE+aP1WGsGFYkXOu6pjKk+A0y5bvOi37Dd2woMhZfHnZeMTy1eDpULn?=
 =?us-ascii?Q?OSV0TqDEUqaQ5g5+zf9qtdwwB53plkB101ls8NNmLZ6zBbSCZbff2SbLq7Ca?=
 =?us-ascii?Q?07uxe8d1MT9Tarlt/hQwLfzCcqPGn+zbMD0m9bGSnfQDnIWnjD6b2HWEphnW?=
 =?us-ascii?Q?VPBMUHSXDAknFUl4HKSazc3YOG2M1LMjvEvqcN67wLsRzf1dkoXvShrq2aqe?=
 =?us-ascii?Q?0+HqTFKcgPt3WMFiyObXDQLOkExtvAj0WFE3GRA4XmA5U4TmpvhK3Em4yGLe?=
 =?us-ascii?Q?5N7NSaAbHxCsioUfhqagFsmBjKEfPqxGO8KiilpO1hhyvM6yOH/ZQemKOKM8?=
 =?us-ascii?Q?fId9LxBCWePzcLnS5qzamdwz6lQ106v5FVjG/NKCMRurHw12ILXYe31w/01r?=
 =?us-ascii?Q?iOOeNtF2WbpW6DD0sGQ+gLMFsDMtXBHwzYPwsGmnu7MrBH9ZRBOYIeKnq4SA?=
 =?us-ascii?Q?Vg8tZeonZi3AYZjGgl/u/B8PUdgoI/JZ9nhV7oZLFO2PSWAmjZjh4dQeQw3M?=
 =?us-ascii?Q?A7HOlx3OUMPInha4j87CPfD1QPNuY/ni1j5GGDubo4lHq3CVwg53p+v1JEhE?=
 =?us-ascii?Q?zoth3mtww81djvHEsQGXEJ3i4gve8jI5w275RbuzZ/e9zo1aQskDFBxShjFy?=
 =?us-ascii?Q?yEx8Y/w7S5FQByWN9k/uP+YR4FdLjihZswkxyYLz8N5nyN8KY8mvhq+GGQkh?=
 =?us-ascii?Q?jtH+Vt7sKl7CJ/NrGfZHQD7JmWQBBxr5VTgRRT9ttSXSg1RLVivtWj4SfyNm?=
 =?us-ascii?Q?wUdBfFyDi1Uc6pvhd5RBmLjfPtWqIlsbd0IB7PUyMxL37A6Gmo4oBYt3xz+9?=
 =?us-ascii?Q?ZjjcoZkl6pLCy8jx3lnL3aYnriq0ityazcOa4xJQrzB0IBns64s/Eouqhq+5?=
 =?us-ascii?Q?WSo87BmZRFZho79Qf+MDlJUSsI5fNyHvZTKrm0TJc5YKvrzxuMj3Q/LnCoEL?=
 =?us-ascii?Q?VndZ67+vjNCK5ZN7aRuAcTbTq4uYOK8h?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8326.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?c3bRWXqaYUFzS3GefRb1h+65xrNPjuxIFSXhvO+nJms3qAeO9E3jcRFfJyjS?=
 =?us-ascii?Q?JwqzJMfOGh7QsBrzbvPDRorkSOPTXQ2YkPres8sRJvSohYqdX6I7Wn++eWKa?=
 =?us-ascii?Q?jhjM3HWq7odoXtCtnxx4XY201V4jm5r/iOLA7M5fW1H5toThU7CoOMxLJoI2?=
 =?us-ascii?Q?lol9V6E3ZkhlGnfgoBDcTC8JCLNRb/e9W4P6oFjErVqxdO9ziuL2YFm2cpuB?=
 =?us-ascii?Q?EISV/d5u1kTUhoLxrots/LzLlsiRhYBrYUvfjH6pHpyouXJWL3OSRCTEUiNB?=
 =?us-ascii?Q?77WIv7r36zqy0jS3WJ2uv7DnEaFBzh/ANLY77sgXuMIJqiX2PDUBdpEnFISg?=
 =?us-ascii?Q?Jj5dMsY2JAWyOLdM8eqZzaE8TXW/Kzw+/aL4oPjRw1BuFyQnSDDLtyTz0wg1?=
 =?us-ascii?Q?Za7ZsunLe15QKTkVj5T6bcVt4qB6MeQS0gMCX5Lm3lKznOA9P1YjmcZcMXbj?=
 =?us-ascii?Q?L8NtZ8jktEI7onyQV4R2+b/CA4hxlSTepeq6CGOxkHlUa/Ijks2zLFSexpDp?=
 =?us-ascii?Q?ti6aDiMNqVLj8kiThx7Dc9LmT+KtaRcc6FsuKfC0oCqZjRqRf1R7KBB2gMxs?=
 =?us-ascii?Q?20UbTtKuRPb1p/p4kUQmnhNqDls+AGOnF5BAv3vNycRaq4ylI8Bra7SPcaQH?=
 =?us-ascii?Q?9z4dxgA0pP22zsnYebIk5ltBz5eiDvkCX3QtFjZSqdkZyfDd3n4SfbFS8/dV?=
 =?us-ascii?Q?jDqcKarxfGmb8XpuCwlIGyJmkUBPpYaldg4di0QZt0hzhicCW3huk8IKZnch?=
 =?us-ascii?Q?mbRNCxplRCL5QkXhyRoEE0x+1ww0h3didUMzsU0wA0vNNzAUGDgG3O2b0e6j?=
 =?us-ascii?Q?5b1OMSB6UY2V+KwemClucLrhc4ewxEAnBiTixg9XR/asUz1CcbKLwV1rM+Cx?=
 =?us-ascii?Q?Cv+U6+8JEVB+utNqolJCvxJbG97P+KmRnbseYXgGtw2HiLEqBhtnJh3KuOip?=
 =?us-ascii?Q?jynH9F9hralvyQYtjQJSCxhUzOKJLRliml6khc+Bo+V1XG3v89aO9gGQ6azb?=
 =?us-ascii?Q?TBvNreaQ9w2aKdpWHTsbB84NDLBIPlgzc7dbCDQtICrTEz0QkAK2Mh9kDQ8X?=
 =?us-ascii?Q?WzuAXRzvnD+B+lsFfAZ5+9+fi5Wr/J8OjF0MlUjep1uFgYFvASwjnAvI3hVa?=
 =?us-ascii?Q?UtY0DHBpfIVFhqTEWR2VQORBy/3jVAvCxafCu8qYXeLe+cAzN8nLEs89KlAv?=
 =?us-ascii?Q?mgRohj1KExdD9Ah/M2aLdGIi+9Msfaog/OvOBCa19WlA+0xIFlzHnLFNyrvx?=
 =?us-ascii?Q?GYU0EvRwh9/3I7D2vLiDOsyw8pK3mMu2CWAZQr2QbGhy0BgpTJTW8YYSpQfI?=
 =?us-ascii?Q?Dj+pIj66Fhb8Oq/z+fFjZm8r/7vyDGYAS4XLuUEtGGsNdsKK47l+puDqrCPV?=
 =?us-ascii?Q?qBKX6xSucHfxCwXq8qoJ364CLIrO09rAI3BoRvitlpfiTyR3BI0r7vRIaMGr?=
 =?us-ascii?Q?e1+P7+Z9YNCVMvyWClnS8PGqLlBJWMzvkuDn2HcGBz4WXU2yEdBzAZLzFiRR?=
 =?us-ascii?Q?YM/mUMiabm/q4nSted0AOeIpee8PZ5dgXsIYnUG3FWyc4W+fqiHavTe+ufUz?=
 =?us-ascii?Q?bQ2TcXW3/ZnTkgo9+h/6I3HJWe+oPrsUxVEshO50wutTkzxpWLq6sIjMpIOD?=
 =?us-ascii?Q?Uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3720E171167694CB5D772C2D4C9C8DD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bzqFwV1kIDGcmzmesmZkgODxADj+oDKsz3IY2oy3mtRBWb6LRm+49xeSMWKsUq9ppADvTwQx1VB3l2ZcX7B4sysyRMuDq7ZzlcKO8ngc2qew08RqV1gIPNsPX9Or8Wh0cm35JRw5MrFsz1dKkg8zHrya9oIv11DviR/MvZWAzrxW3hq/bXrlyq6HNziYhpAYMRMkGDPjbrAGjsqYq9PxeJ6RTh6bg4VUVwzDDzAhzM3brzfLb7K8t4gWWTDuscNZ90hhlwrocDRJKeeJRJy4T3vCPbi9o8ahO6R5VVW8CbHBRoq9lh1dlojQgAbYhfU7pEQfFzQJoUql8YRNRGt0ADxRa1mxeJmv9xwnzCfv2MpQtc8lPCcQ8TFveJjP1+arPYwFWjEeKf3De9UedQMwZmsKddTOR289gA2TZDuYKhZX+PwufIXcipCNOmqsJaw9tl1b10b1mm2UqnQuTmSeEvloCEKmSIwfAIfDOXMOzzkOr5YgBW8aDh5N5f9YoKVWzGrpDVmyPTec4WL/54xbyE0c5u1rbyxEgHWaDQyVrwaM1Lv5jhhxnlXw5tpJEQY3teZ49silATskaxzaIKMIh7llL4nd2x2PL6kaO7xSxe0078QFzpeIOogMo7DcaXAg
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8326.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff5d756-b943-48b7-f9d9-08dd39fbf515
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2025 09:14:06.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NVvNZEVnq02PQTz/fEzLtxBdEQq5TKnPWkZggtmbbcJWRxHThaC0FnG1aE5ySx6qCqV2e0u5CqEeVPhVcgt+Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7581

Hello Shin'ichiro,

On Tue, Jan 21, 2025 at 05:39:11PM +0900, Shin'ichiro Kawasaki wrote:
> Currently, fio checks if each zone within the IO range is in an open
> condition or not. This check is done even if the job does not perform
> any write operations, and causes confusion among users.
>=20
> This series addresses the problem. The first patch fixes it, and the
> second patch adds a test case to confirm the fix.

If the first patch fixes something, then perhaps it should have a Fixes tag=
?

I guess the commit
8ac768899d63 ("zbd: do not reset extra zones in open conditions")

is the proper one to reference here?


Kind regards,
Niklas


>=20
> Shin'ichiro Kawasaki (2):
>   zbd: do not check open zones status and limits when jobs do not write
>   t/zbd: add test case to confirm no max_open_zones limit check
>=20
>  t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
>  zbd.c                  | 10 ++++++++++
>  2 files changed, 39 insertions(+)
>=20
> --=20
> 2.47.0
>=20
> =
