Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795536116;
	b=XIftYXwyr/aYjh8Mxn+viEbPzfJ+GWYnzuR6iq3zVof43bGMjX3aBnOdOvjdzwVvacgh
	 xjAWrng7C+6y2ags9FhAG+pjDnoGs2y/Gey3YQd+ABwYyMfSNVbLF9Wl0npg7OVfqP6LL
	 KvabqjrMERq8oYUen1NWMt544DPdboIOwLPSKwJrLv/yHSzMziGh+KINqLNxZICukmhsr
	 b9wvxzvoRu/FMxm2X2YQUWVfsImfseYiJW5hG/gR3+N100EF1eannnvMG2U2cgpmOS+Nz
	 OIUBuohCg/REBizs5oN8xLqWHk2JKdYGAQR1RiFSTvQ62lHfHflviCYs3RYnry0p0lA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536116;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:msip_labels:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 wdcipoutbound:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Cd+nqdZGL7FbbsnLzZzcHmCcpLwF03rmgVxul+L+/Lo=;
	b=Qp0gop5BsR1cFXOCnQVKuOff8/gNhzHFfRHUws1AnOr34mH1zfbaxcGGrbF8j6CQuNQj
	 1E+j4iGk2elZ5sLv/livr4nucIUSl+Jw+uGN2qTQjA0vlI+kEznbW3OoYePmeXkUq37Gt
	 Rru8Bu4zVYnltxlhOS2DIoRVnK/aKZnKf4jEjCYBuohbMc6F5w0bKBN6B4U09j3NDAaLY
	 9nIe/WT46/2UHtva/FBj4ahQk1hl666eszj7zZHtiJQY8MwY3a87PZ7s+Xc9X3FaIacX6
	 C2Z5wB+F/eq5JbrAeWFwrvWXQ/1I68BgNlWTOEdWLpDoHibmeIKS6G/pzdS3Q/q/xqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=C6E3h7hn;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Bt7ByvYJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C220606A321
	for <fio@vger.kernel.org>; Tue, 24 Nov 2026 16:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C220606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=C6E3h7hn;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=Bt7ByvYJ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795536115; x=1827072115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cd+nqdZGL7FbbsnLzZzcHmCcpLwF03rmgVxul+L+/Lo=;
  b=C6E3h7hn4wvov8BB+LkYh0NethW/svCaIrFPON8N1m1G4Dbj0uUpBlAy
   LBims+lPYcCurQgDwSYx5RRskE6ld33bNeApPowispU47Znlt5g+Ex+1z
   e+PDpd+BLUyi/xoupujFoC4XtreWcp9myph3h/gjj/ALd6vuGZl/a8r6Z
   v8D9OQvEEdd8BXG2H3m7YJUe6IY+E0ITv/FdVDMiAz7gvgdRkuLxx8mip
   iME1UngwJDuRLe8XjyNrL+mJtr+Q2bwtAtbPiBY9T69h6fl66qyXKtY9F
   z0+MmpGgOAKItvM9Gxe3onuTacsglHL07LD2SgVbp36SnXjhUngzsDC8Y
   w==;
X-CSE-ConnectionGUID: sOjErJSPQ4+MC0W00QnJEQ==
X-CSE-MsgGUID: 998OiygiTDCn3LSP+7j9iw==
X-IronPort-AV: E=Sophos;i="6.27,231,1786982400"; 
   d="scan'208";a="161659058"
Received: from mail-eastus2azon11010010.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.10])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2026 00:01:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v85KPzrUDY1X7r1W6p+3WnJwjd3sHyUCJ7+sa1g+xeefHlct5jsSJ3hIMR2UVCVW8w1+NKw27Q54PzmeRQOJCLkQPkiJcYFj2efdpf90UZnkESU5pFG4ojl1xchmemm1or1HidPQZr9PEz2uDrNxUPenqgMJPdOPYyMqs5+C0Xj0zI5cTR6nGd6zw3EJUPN8OGmD7IuIhy9OrJCqKAYo+1mpleFNhTZ3rZVOaveMvs24Y+hP30UaHSJTVVwFRk8Ea/iARRF6ItGrLM8n82FKvJ/nLUDqvPIpkvooAdMZ5xBW0Is/runzzUPEhJlVCOYjaLiV2aqsr11uRlXU0YOYlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cd+nqdZGL7FbbsnLzZzcHmCcpLwF03rmgVxul+L+/Lo=;
 b=c1MIduPkGXgqdypGGGFjXO9HxUp2pQOOI/5mrlCHPLHUaUARxGdtgsuQPN5pFtvnmqg5R3WjmQySe7bM/yQ+Chent7pWZzcsQ1er/vXrIpbjw+RoB+e6bXtu7JHWYhBkMvWr9m4ZmWZ21jGZl2YimFjU2S6rg3dIwzdrBKA6gy18btvyq+xQxSCDhNGdUX2JjLdENLjWAr9u8Q9NYeiCi6RUBApbcs6lh69vLFAZ+Rw5GsChLK1agB+xM25Tv4fZA6Wsy5yReS5FLADFF3RtcC4TTzmHfiCRY4pIw3CvHgA64O8Iw+V3pjiXcPRynDNskLmtNCZCbWIKiuwn555pRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cd+nqdZGL7FbbsnLzZzcHmCcpLwF03rmgVxul+L+/Lo=;
 b=Bt7ByvYJu/6u37NB46A+1Yk408UvEbRBE//V1qsqpV4ypRrV4PA1vVW/bemKvtnIyzhyklOmO2oI9/hQamo6xBS/DkanQVJFFYF9FSCgLkiP+Veo+cGdAKGMAhhrfn9JJoOb3nuEo775iCXShf1oZ3ZascreiQ06CtnA0BRsT7g=
Received: from PH8PR04MB994107.namprd04.prod.outlook.com
 (2603:10b6:510:704::21) by SN4PR04MB8414.namprd04.prod.outlook.com
 (2603:10b6:806:201::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 16:01:49 +0000
Received: from PH8PR04MB994107.namprd04.prod.outlook.com
 ([fe80::decb:19a9:b964:825d]) by PH8PR04MB994107.namprd04.prod.outlook.com
 ([fe80::decb:19a9:b964:825d%5]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 16:01:49 +0000
From: Siriporn Swart <Siriporn.Swart@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jon Whittaker
	<jonathan.whittaker@wdc.com>
Subject: Re: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
Thread-Topic: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
Thread-Index: AQHdbVLY9jozLnKT4keAHV+sEWtQIbcy49eAgAlYcaGAACwTgIABFhyg
Date: Tue, 24 Nov 2026 16:01:49 +0000
Message-ID:
 <PH8PR04MB99410721C03B387482BAD846708A442@PH8PR04MB994107.namprd04.prod.outlook.com>
References:
 <PH8PR04MB994107D250DB2434D563DC57E88A772@PH8PR04MB994107.namprd04.prod.outlook.com>
 <CAOp=CXnuSiNwChAbsWhXpCWyJb7NGFL5EMnL4ZHk0pRm3iaMWA@mail.gmail.com>
 <PH8PR04MB994107DF1ECA9BFA2015637E198A452@PH8PR04MB994107.namprd04.prod.outlook.com>
 <CAOp=CXkfXXFqC4XbsOLzpDC7FR9-p06HgdAvVcDATnpW4jaqHw@mail.gmail.com>
In-Reply-To:
 <CAOp=CXkfXXFqC4XbsOLzpDC7FR9-p06HgdAvVcDATnpW4jaqHw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR04MB994107:EE_|SN4PR04MB8414:EE_
x-ms-office365-filtering-correlation-id: 71ce077e-7111-4fe3-1796-08df4a443fb6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|38070700021|11063799006|5023799004|10067099003|56012099006|4143699003|261026140227099003|261028144727099003|261022105027099003|261022113327099003|261026121527099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 fPBfTd+I6hvK5Bp6cRW81SI9x6YHy57OcO64yniHImxrNQiwImp7UaDZBqIg0BpGKfZ9e8H6BPZw1K+BfqpxQJsORZHZ8odd8L+tZRUPcvDza52Q/Xm9mU8NL0Pa46fLxhLPtlHx7bqY0MM64DEJGpKmRPYAiqxrJsKYw9kvtp75Zv2qbCVGQMWBfMuQTu1lQpPx/WoJHCqi8ys3/JJP5UJGueb1hbQeOr4Qe2lklR5WoBPSok1cA1PsyICXy3A6XI8Qsv5BG+rlvhnd7sy6T1TDL56Py7ROsENXoC4ojTMtCpEz6YuVk+Ug6Fw789aICzlyTRH0fbi39r/A9tEbxCFn6siJ5SIftsDeziYMuRvOuk/9QoFS+USNIysb+KxBxj6UHM8k6x7xxtZNV+6XcEW/O/Us+VqiEcYcqjNTheULhFr62t9heLyu9jSL8Ll8+rmubh6z7U1OwiJ1XPCExWL0kNSwBNGSokJvuz1x1F2ybQZ+6nzetTzJsfoEOQ8OgrWr5NMTHwusozsedwzeSSiU+z8jeJ5Rw5QsUVL2Kf6JLBCzAsuv4unUkmPcbRhQwI15VtG2ToQAGKdEIy7f0tdBpahimqHhmBWneL/MHCFxhofnDC7XUy48n4ztv5xdyOgG9esEsICEg76cm1A2xsbDbhIfEuKc+SWNCUVyttD629VsXLyJVyLwUfUI/fIbY30f2EC9GsyhBBDa8HALX3Pc9jP/UHYYjikEY0so+SU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR04MB994107.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(38070700021)(11063799006)(5023799004)(10067099003)(56012099006)(4143699003)(261026140227099003)(261028144727099003)(261022105027099003)(261022113327099003)(261026121527099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WG9vNE1RWk5NSko4WE9WMlI4dUUxNGc0V0EwaFlFSWRFeTZkUVhEUUdiOE82?=
 =?utf-8?B?SktPTHN2cWc2WEQzcVUzbHVYRG5jOEhicWQxcWJvUmJMZzZNemVHVktJdFk2?=
 =?utf-8?B?dXZ3K3ZCNWMrTWViWFd5YW81OXpHYUhXZVlxRGpSSnU1V0V5VWhkTUFtZGNa?=
 =?utf-8?B?ejV0d1JTK1RlWmdaekczK2ZHN3VIWnRiVWFMN0F5NFYyUmMrTDdQTUtNTkdq?=
 =?utf-8?B?dFZMb2Z6eHdhUnRDa2NjMzV1b2RBYTNQMFpGZXBPd2hkYTc2SUNQbWg5clpX?=
 =?utf-8?B?dUFhSmM3TmZJaWZGai9URWZaVEMvYjdSd0QrT0lOTU1ocmpyQWtwOC80a1pW?=
 =?utf-8?B?anN6M3p1WFhnMmhacTJKYjFlWElNMDdLQ1R6RlpkTWc4UHM5Y0RxOXFhaWhm?=
 =?utf-8?B?TmxSeSs4MDVmT1JNYUZrc3NhSEJ0S3ZuYmNYT2djdHQyd3VEZWdieFU2U0RZ?=
 =?utf-8?B?RFpJY0s3TStGdGZsUm92eVJWb1JZL296ZGxhbFMzZFdUakgwMVA0V3EvZzll?=
 =?utf-8?B?TWxmcnJqZVdJZFB6OTV6em1WTDYxTlhZQWd4LzgxRERlak80RnVZWjdYU2dw?=
 =?utf-8?B?eEFvZVFWWHgwaFkyOVBEeVp3RjVoVUZYNS8yNEhSMmVDVnplUzFYRTZaYkh3?=
 =?utf-8?B?L3ZCSnZmTGpTZVBzLzhvT0ZwUzJCc1VmdkNIZVhIelRIS29LNC9WU2V4NnUr?=
 =?utf-8?B?ME1FbG1vbHdiQ1VkUlN0bk5tNUlZb01yZ0YyRTR1Vlk4ZDdOQWlJUnVBcXZr?=
 =?utf-8?B?dEgwZVJiVTVVQmNOaFpKWHZBOUZnUkE3SmZJeHFUa2JLWm80d05Ld3hDQ2JL?=
 =?utf-8?B?dFBUQXNKaG1McC9XbHljRHk2RitXYjRqNXhQNFhxcUdHZlNCY0pKME5BWFJW?=
 =?utf-8?B?MTFmRkhjeWZhUEVTa1g0WTNjZkNwalk1SUJSZFpaZmdSREhpakJHRU9VSEs5?=
 =?utf-8?B?ckpFY01zdFFpa29TWk5QOTFHTWQ5NURWOEkrSVZWWjJ0ekNhK2FHaGlyZjhh?=
 =?utf-8?B?Si9nRjlqWHlqK1ZOc3diaFdYcnNOa1BjTnh3WGZoY0xycDNBSVk0UHF2anNB?=
 =?utf-8?B?SEhOZFh6c1BqdkN4bjM1YVNwcW8vT3lldGFNNkJweVJSTmZHa2pSQ2VyVUlX?=
 =?utf-8?B?NUhjT0ZsT1hTK0pzbGFyWWpQazRDa1RxTDV5ZGJiM2MraDBKRFBPMDNPUWpJ?=
 =?utf-8?B?eG84bm45L1d1TThwT3VWUDRXWWNMSG44MENPYzUxVW5ackxrZ2VsSk9BVmts?=
 =?utf-8?B?SXdwSnZ1ZXFyV2pPRnBBWUtzQ2Y3ZEsvcnFVb2ZSU2t1dDlHUjZ0ZkFkZ0xX?=
 =?utf-8?B?VTJJT1pFYkxsVkE2c0hEais0VTNMbC91c0wvUFBXaGZmcGdTMHNISGdITXYv?=
 =?utf-8?B?SzBEcSt2NWF3czdic3oyNGZRQStGN3ZJaG1OVTBjejd0cDZHbXV4RjBoZlJV?=
 =?utf-8?B?bUcxdTh3WlNjTURBZUZnQ0o0NFZ2K3czNGN6WS8yNnBuYzFUb0h6ZnVLck4y?=
 =?utf-8?B?V2dyc0V2N0ZkbjlHRkRZd0xqYzNwOUtkWGhScjMrVkhzTVQ1STRVamMvL1NF?=
 =?utf-8?B?a01NSmQ0d0piNkFsQWd4bWU3VWZiZ3d2MEIyNHk0eUV0UElpcDI3bmZhci9R?=
 =?utf-8?B?aUI5VkhrbTBmNXZtdlV5a285V2kzZkZ0dmUxQklTKzRiVU0xRWpQT3VQN1VG?=
 =?utf-8?B?QXJpbHNLaTFoUERPeFJKMHZxVGpOZ3VVL2hnYkFGd3NsYjFKN2RUWTF5cmNQ?=
 =?utf-8?B?bnBLNm01Wml4aHlUbkl0TkkrWU9aOVY0aHpaVUkrNXdaaVluNktZMURVTFlo?=
 =?utf-8?B?QnNXRjNVUmE0RHROUThSaTlkUU82VE1MVTN1cmxoaVpCS1VUbXJ3eElmOW1j?=
 =?utf-8?B?Q01FNlgxMGpVNnRGb3ZxUVVNc0FKVEdCNk9EVzZpb3hBVCt6NVBWTDY0WWFl?=
 =?utf-8?B?WjJPRGZPa3JtR0VMcHpmeEphcFVCUUQ1VDQ1ZFBUeGwvaWEyMDZodlZFTDVX?=
 =?utf-8?B?b1UxZFVON2t3UE1MM2RaZSs5UUcrVlAvRFE5bkZJUEVYZnlYQzZLZVF6Zjds?=
 =?utf-8?B?Ni9EaU55eEpTbEQ0NE5FeFZrWWp3MThBNm5oMUZRM2hyeklJSzFlam1PVDRS?=
 =?utf-8?B?dUYxMWlueGtoYStLL1FldkdrZWxmVVJBL2pMdEhyWGQyZFJ2RUxYeFBSb3Jx?=
 =?utf-8?B?UERKemN6TlI5cmlBZXU4THJCQUxZL1pXSFlzeEp4a0NOczdCclAzM29xZDR6?=
 =?utf-8?B?VU8xMHUwNkdvOTgzdVhvbjhjUGZMVk9WMWtXNFN1Nk9aRXE3bkQwUHM0emZV?=
 =?utf-8?B?K05LdEZGNTRFa1hoNGlUcnpxdEpOSDVUWTNPZXplaysvZkRjdms0dz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	UD8XQTwWaMWePjAp+nMVZs4ejPqM1fY80QkwMgZosBmrjB4EhDbbbBRxQUEB8SgAcwC3TA6H59xSH0Ywhbi+FhBwOxu6C1unAtawmiEQhtPOtc9qs0xK8/Ad0uraFA0gcUlMM9iwyu1Q6JiATh4EiFRJ1vmXifnY1LMiGzOk9k3Y9w8xcHohYCYVEK7K3mFwhXO9AQbaPeJ0HYEIuSeweqZfV4uDKUtpo2YBb6PTdKvG79Fx10R+BFKGuAgFowqJCNU30T86VYF1Lqn3lmDWFYozHq9aFhSf9cdT/FBvaWL8OCGAqBU2uLDft2herwGsjRNSgEn++L6kXqt8YbunmQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0wHyskPnf1BEJTaIxPntwMWqN+iv5zq4nhLYSMeNemIabh8yMGNszRocnUW8HpJ3+dnmvUg9FMT0g1axeUJ/0fvjDSqlsWeM6LeM7lu4eTxr6Yla3n7n3DTZ6wFfXN1caBxzHZ8hs7p2Cny6I0TfOtczLSF00fYnLEIK8eAyiCSGwiteWpGTUsdzFxuw+NpSi/76L6EuuqO9oPfsV2s6Gk4zbtRNMp8od2LbMpTETyzrFtKJXSKwck08F9hy49xI0jZtZTeQpTWgVLvMiyHTDSl6piqOK0/S45j9c+aUcvw19K/iK7O8v14I81UcDN/tiDYwOfI0bIi55TVaNvHLNaairxOEbzi1CNsr/R1EmGBr/9yaWboH17csIU5HgHi4qWlrSlHQmJMyMHbKG/wNhY3dkyBE+M0QJlGoa2M5wOkDopPXpiNfZardWy08UaDFLFu7FncgldeVsIbQ18bdaW/s8vv9lyf8rX7q6n8FQC1NyoEsQtI2aWphJDwJhPE3xm/7u8UzrTa9h/nUA2Lpm/xIJU8TqfDPMDCOIJjeixnmQjEEH5C+X53R+uWFEMT4eKEFGv93o+H7kjxL7WP6dngRunWjIoek1JzmRX3DOjudZZ/kZchL04mLV8cAV1Be
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR04MB994107.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ce077e-7111-4fe3-1796-08df4a443fb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 16:01:49.6857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u613J099oLhp0AgSjHnnKjPDmj7Q/IbV0TbZgn4p0lEXf4WKNU6A+6k3Z8o+YDw9EcXa/9on1GN0vt5zedPKgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8414

SGVsbG8gVmluY2VudCBhbmQgSm9uLCB0aGFua3Mgc28gbXVjaCBmb3IgZ2V0dGluZyB0aGlzIGZp
eGVkLiBKb24sIHRoYW5rcyBhbHNvIGZvciBoZWxwaW5nIGRlYnVnIHRoZSBwcm9ibGVtIGFuZCB2
YWxpZGF0ZSB0aGUgZml4LgoKQmVzdCBSZWdhcmRzClNpcmlwb3JuIFN3YXJ0CgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkZyb206IFZpbmNlbnQgRnUgPHZpbmNlbnRm
dUBnbWFpbC5jb20+ClNlbnQ6IE1vbmRheSwgTm92ZW1iZXIgMjMsIDIwMjYgNToyMiBQTQpUbzog
U2lyaXBvcm4gU3dhcnQgPFNpcmlwb3JuLlN3YXJ0QHdkYy5jb20+CkNjOiBmaW9Admdlci5rZXJu
ZWwub3JnIDxmaW9Admdlci5rZXJuZWwub3JnPjsgSm9uIFdoaXR0YWtlciA8am9uYXRoYW4ud2hp
dHRha2VyQHdkYy5jb20+ClN1YmplY3Q6IFJlOiBmaW8gV3JpdGUgV29ya2xvYWQgd2l0aCBWZXJp
ZnkgRW5hYmxlZCBBYm9ydHMgd2l0aCBpbmZsaWdodF9pc3N1ZWQgV2hlbiBXcml0ZSBFcnJvciBP
Y2N1cnMgYXQgUnVudGltZSBTdGFydAoKCkNBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBm
cm9tIG91dHNpZGUgb2YgV2VzdGVybiBEaWdpdGFsLiBEbyBub3QgY2xpY2sgb24gbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFuZCBrbm93
IHRoYXQgdGhlIGNvbnRlbnQgaXMgc2FmZS4KCgoKCgpPbiBNb24sIE5vdiAyMywgMjAyNiBhdCAz
OjQ54oCvUE0gU2lyaXBvcm4gU3dhcnQgPFNpcmlwb3JuLlN3YXJ0QHdkYy5jb20+IHdyb3RlOgoK
PgoKPiBIZWxsbyBWaW5jZW50LAoKPgoKPiBUaGFuayB5b3UgdmVyeSBtdWNoIGZvciBnZXR0aW5n
IGJhY2sgdG8gdXMuCgo+IEpvbiB0ZXN0ZWQgeW91ciBwYXRjaCwgYW5kIHRoZSB0ZXN0IGNvbXBs
ZXRlZCBzdWNjZXNzZnVsbHkgd2l0aG91dCBhbnkgZXJyb3JzIHdoZW4gdXNpbmcgdGhlIHJhbXBf
dGltZSBhbmQgdmVyaWZ5IG9wdGlvbnMgdG9nZXRoZXIuCgo+Cgo+IFdlIGhhdmUgYWRkaXRpb25h
bCBmdW5jdGlvbmFsIHRlc3RzIHRoYXQgdXNlIGZpbyB0byBnZW5lcmF0ZSBJL08gdG8gdGhlIGRy
aXZlLCBhbmQgdGhleSBhbHNvIHJlbHkgb24gdGhlIGNvbWJpbmF0aW9uIG9mIHJhbXBfdGltZSBh
bmQgdmVyaWZ5LiBXb3VsZCBpdCBiZSBwb3NzaWJsZSB0byBpbmNvcnBvcmF0ZSB0aGlzIGZpeCBp
bnRvIHRoZSBmaW8gMy40eCByZWxlYXNlIGFzIHdlbGw/Cgo+Cgo+IEJlc3QgUmVnYXJkcy4KCj4g
U2lyaXBvcm4gU3dhcnQKCgoKU2lyaXBvcm4sIEkgaGF2ZSBwdXNoZWQgdGhlIGZpeCB1cHN0cmVh
bS4gSXQgd2lsbCBiZSBhdmFpbGFibGUgaW4gdGhlCgpuZXh0IEZpbyByZWxlYXNlLgoKCgpWaW5j
ZW50Cgo=
