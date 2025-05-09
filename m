Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D8633F3
	for <fio@vger.kernel.org>; Fri,  9 May 2025 02:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746757038; cv=fail; b=TcqjqmQNpluvmtBvOiHIuwpZtoMcoTsjXTkc1TixmCDIptJ2kLQDubn+GnnAGxud2pLm6KlEIGXbsoK+0EnSVYPCq5FPja23U2HkEUNzx+mqXswc2uqhrP1CfTzwH1OQ+oXZvgRVcxvpZjkVduVL2U36FP0+bnwUwAKWToZ0Ing=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746757038; c=relaxed/simple;
	bh=wozYCfA7hSKW6tJoqXMMaAlcknCWQSxCqWNE5dLL+DM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gZJdM5BF7rXul4Enw5IqD27sQAEe/I51vCNG8X636ttRJ/7h/BBqpw67V5U/ObE3m8rVpDVWmbAJPov3F8C3aex8tQU+Wk9nekQDFIBOLFhLLu0jyE9iKhfz6kdMpSv3595/yjCEqKgzGUBibZBHZWRwL1vZpYDW53lrgDoOUSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a+HjReAk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SWjcyQZZ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a+HjReAk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SWjcyQZZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746757036; x=1778293036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wozYCfA7hSKW6tJoqXMMaAlcknCWQSxCqWNE5dLL+DM=;
  b=a+HjReAk6Cikz7UTZd99UV3ty165TGX0IFQH4o6gq7MoG4rWuoDBgEwI
   Ns7MxPBLLNxY/c2AvfgrUorH14ZjJ2mqJCMlN05FR3/KDJxOyUZSYva9c
   PrlTRg28L8KnwYcp8ZQW2+xgoSbWblnCMWZKa86J+o2NDKuUrgJsBaHm4
   n2ysTnkvsQIQA7sERbWWVWjMu+QizFPhT6E+ILKgIlQ3keEYEoZzmu12m
   IxVhIVwV6z7AaHJpv9Kn2pcDCJ9mEeYskoK6YSbE1P94CXJu7AoPSzEL9
   JYwIe4uPI54yLXKRrW1mKz/HMeT9AW+0mgMYAEI4S9CitWP2IjpTJ7N5f
   w==;
X-CSE-ConnectionGUID: 02c9wwenQoaeQY0SFx43BQ==
X-CSE-MsgGUID: fdy3LZpRT7K/eSUPD/UuLg==
X-IronPort-AV: E=Sophos;i="6.15,274,1739808000"; 
   d="scan'208";a="80596943"
Received: from mail-northcentralusazlp17012054.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.93.20.54])
  by ob1.hgst.iphmx.com with ESMTP; 09 May 2025 10:17:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlO6amYmidh6DkEiLK6Bw0wEiK7haE58L1MndznFptZCR4ZzpJH6iRfiVesIUm5jqko1EK5omaWk9wdKX2AQ/8n4OijUua149seTF6VKj26fhzOCXxA8JKkE9IHL81ONofq3qcnggeU6yS8Iawvxg4QiV6gp+8CsvkBvgc+Hr3WA5i7pGrMnjPCWTqRQuK5HrF0LXr6hBPAUKSJpqctOeggbOwZwRhfZBNghz7yqgQ0fKvNlDrySBmTFOpyvxed5s5iNnedkQoIDiFSIn+rLE6D6ratamIKCGMlVddKEraNDdMdSKth8oS5wyAW4Ty7ot+lXX0lIUXzGFRYXi4Pv6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wozYCfA7hSKW6tJoqXMMaAlcknCWQSxCqWNE5dLL+DM=;
 b=dgSxExyABkoJqSgjavAzWrp2Z9Iye2/qOhRuSp7G/+i0CHTz0wf2oMz+MRTceeOdebMPZKd22rDLPOgMukpgQ6jKLWNIVxpxTSC8FwMbffQ1L/XCUUqpgMf2gylmZo4ZmK4Bd0yOuFOmapYwdB6JyGedZhmb4oXtCEaYeF3tv7cmqVOdX7hRrCOo84gqglYztmFN8cGChrZYto8Ao7CyoL6jsmrXi5uRe4mRJyhmx4iuJFdLVzU2UUWU9FSoLYX+qofYPksw7N4RVQGgM9WbwCIrAJquujcIaGPZxfxFLecNbXre905t4x1IJOKeuRiXTeW3CxQ8Wwr4XuaoWnSEXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wozYCfA7hSKW6tJoqXMMaAlcknCWQSxCqWNE5dLL+DM=;
 b=SWjcyQZZ/UXECRoodr3zseBBE+mG/kRq7SpTufL1adeDqWG6STiSe5rfOWF9gQFspa4PXnZGugB1mbfyB6HBfniKCxfqgF2UcDu/8R5PYqKVdNqcTVK4ECgVCcelFh7P5nht0rNgf/OQVdDc3cT1E8kkb0w9JHzAkcS49uvwOdA=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MW4PR04MB7377.namprd04.prod.outlook.com (2603:10b6:303:7c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.24; Fri, 9 May 2025 02:17:01 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.8699.026; Fri, 9 May 2025
 02:17:01 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Vincent Fu
	<vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] man: Fix recover_zbd_write_error option description
Thread-Topic: [PATCH] man: Fix recover_zbd_write_error option description
Thread-Index: AQHbwIarc5SF4EnNGkGcV5zXoiXDM7PJj9YA
Date: Fri, 9 May 2025 02:17:01 +0000
Message-ID: <jrfpm3ssqtb5fdtgc6cxijybc7v3rd422d4hwi7dbxmjhtmfz3@a5spjgqyrkb2>
References: <20250509020250.483865-1-dlemoal@kernel.org>
In-Reply-To: <20250509020250.483865-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MW4PR04MB7377:EE_
x-ms-office365-filtering-correlation-id: 1616e646-539a-4747-4450-08dd8e9f9582
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ZgqhKdomu1Fi2z+8vgubSTibRRCdX3ceoJuvRs5QE/zrgnSmZaheBEDIp07X?=
 =?us-ascii?Q?2TJ4l3RF69/9b/WzttPliQniGzdF2Y833h2H2INRXN9nW+giF9Xqj7Xm5okP?=
 =?us-ascii?Q?Umx2gVxIO/rO0KcAsUVExoOGwkdXCHAsxsqLmzD0geQTfEolff/TxMutKJX0?=
 =?us-ascii?Q?fPn16YaL8jLuckgJWHaNOlPyCCXc5fOmRvfcIVz1aL2rNZwcjQ0yUt7Yi8Sk?=
 =?us-ascii?Q?E71ZG5m0WdqsnNJMqGM5NizryJU5v0xFkGKjFMHHvfJGJrnczop6DAPPDM9w?=
 =?us-ascii?Q?Ov0Ko1KffoOd9X9Bhm5RdWiguLOK/5vPQTwY8k5Y6Xiws0DyxvqUHLMO8woP?=
 =?us-ascii?Q?kVlLfbXnkxtWhSXq04utEHQ6ujKI/rQUN0qim7XheHeSb7xm6mjjzUVe89EV?=
 =?us-ascii?Q?hh+mnoxHmnZOM9mCI8MtwtT1RpQdCFMX9pOpmEtnWD/J/bZIobVZP9/HdYRW?=
 =?us-ascii?Q?INjiqqL46yHlMyVhetj0REnMFY1Azw3VEDvh2CJEVnz0jqMhGFy5M4NAsHEM?=
 =?us-ascii?Q?F4tKbvNC4q4f3vH3B2bhh5Lx8cmh5YChHqw/OQXGaVYkWs1x3Gw9LVYh/wKj?=
 =?us-ascii?Q?YKQ5BKmtXFLsuiBMywHPSb3aC0D49eY2pNcMIw+o+kktKzF5TFdLMGQM0/Nt?=
 =?us-ascii?Q?Q8pQ/0jAIVRQyYCx+ZEMEBjNyGx2PxDDAKwtrQ6EVM5nTDrJ/c6wiwebOd1d?=
 =?us-ascii?Q?8POfTMDhvuajJSCg3q1KWzafpHOVnLa9TuCMS6YTegDyEO1Dzj+ionpuHfue?=
 =?us-ascii?Q?bIxdNmtFZvNbPkuNEaVNhda9S5LmA6/H2Gpe+4vGp9AbKRqboSaqj6U88yg4?=
 =?us-ascii?Q?Ds5TUxdoBWQRI/OZwRZJ8sFbde42+jBFQrvMrZZvA+Hes8ABRm4CEjMmE8BL?=
 =?us-ascii?Q?uK/DFpsY+JZIX1smqfKOpf65GcD9C/tywPbfvQUL7gyBVSrCHqncrm5CkuPc?=
 =?us-ascii?Q?nbAY4UVLWOY2OkWrIfh2hAKn6jOkQAqbgK4ksqjpzjo5oBPugTVO/LRHkzJI?=
 =?us-ascii?Q?edR93fk8LOT2OpQbPuSUr+FzsFqXwbeWkV5hDn6g5AgHlPwahHZxI5FJT05r?=
 =?us-ascii?Q?8l2EpqhH6DjfLoBEsw0AkFYkUrQD83YDono3KlSoNYwwqGGWMWQcNgii7PDe?=
 =?us-ascii?Q?3KbxFsmBlHZmDDezf4VZ6oopGjl7FdrT/DNOG3s5uqRXPOu+8N8jxwoP4zUj?=
 =?us-ascii?Q?qFc/SIVQLho5WLj5Z81rSGw1c2WaVw+OYQrhwhfcMSjI+CAXSKZPAOAYXMvs?=
 =?us-ascii?Q?cGv8aT94aF//QAffXZI/Qcl1V8U5g7/a0S1tcdiiOcTMgXzEQIztxrr5BjEO?=
 =?us-ascii?Q?UIEqwFj7kJXchJQtmrhNXM2C0HJN5rLkqxQwK+Nd4kufsYWK23bEs1CR11BA?=
 =?us-ascii?Q?kRLF8mgZGmGkH7RWKVKjpKdZpZVLiANts4jToUr5mAh12jH1kUYNbDmIekXM?=
 =?us-ascii?Q?7gbBdB/8eQpLvHW7UHtgcPPYW8dqlHmrDlvtJKzAhiVDIFvDom73QQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TM95cmBmbGbhRSFY/sGteJc4Urtic0K3ZKakRZLy48CIcTaAi2G0wboGSEGM?=
 =?us-ascii?Q?YPm8FfQjmXtbx35lxmFRxtYoNq48e5FO3PPzdAm7g4RfOTB0RQLvqog5pO17?=
 =?us-ascii?Q?UoxwiWTHCK7YANMdWbXm81rKjULs7XpuHPXU8eUtjyxaloZ3KqrdDnTz6cEX?=
 =?us-ascii?Q?3fiRCRxVWhD+sbkIvEToJxE2gMiTGNBt4QhGb2/ofbFhtFYFTErdL+vD2oH/?=
 =?us-ascii?Q?rGWH6ujNp6AAa2NZ0nBS2rHWs/buuxuyfJLKyNeVQiz8+JYrpYvBMhsg6Sd4?=
 =?us-ascii?Q?J7rxqPoTf0mW22jSlgMOBMBFhXoJFQCRh7ByjsFpHRSdTXjOmOJ3N0OT874M?=
 =?us-ascii?Q?IZJcSdxskhbJXzeQlME6pNYtxK9K/OJoDxohUUACr82MYGBCewAxwL9Pmbcq?=
 =?us-ascii?Q?dAFCQtZmZZDI7bF25M+783VviKfciqlqoq5cABnV7ygPP/nKzmpodH6Zy9HH?=
 =?us-ascii?Q?keMAHGZVaVlGsqWv6W3Sy0iOSJ545jLXV7MbVRAI2wb3K/tdxEvchQBV1AuX?=
 =?us-ascii?Q?wMvjEgmgpbf+gBdHJ612E1mAnx/8Qxn6JlbEdW8EVolAc//n6xSwk/qHQ/5t?=
 =?us-ascii?Q?yRkcvO7+NHn6fjsVR6XmCo+zC1wlapEr8+fjUpbK2ZvI7zaVwPJ62G1qqmiW?=
 =?us-ascii?Q?BJ5868WEVqvZsjPLrnwVCgxHphM2W7Dy9h7fSLwHoR08mI1hBlLWwMcXv11D?=
 =?us-ascii?Q?VdqVT2EWRrBPLqbw53BmMFi8aWKh7Bn3acUKRhBLJhz9Bt2lwRSuAPgSBpII?=
 =?us-ascii?Q?ePfclo5vRUu/hoVJ0C8ia8te6GRRINq4BuVJKOKpejTKWQCE5Py/ecWr4aA6?=
 =?us-ascii?Q?zBLbnrKXW8Prqxp7ovZ5o/JaTOeqZangkG1wD6sQrhgAH4A5FcE2IFXJL/7c?=
 =?us-ascii?Q?x2GEZ9vZATZwOFukaIS2R/Ox3R/F6+0IDfGLCw5hnoj8fZJmpJD2v+GeOYpX?=
 =?us-ascii?Q?qhBAxfYML1k2A58a5i8RL3ZNXq7VnHihe5JNjVbVWBXXtnc4Vd4SPxLPSoVB?=
 =?us-ascii?Q?36VM73H2OWgIceHggnL8HWEAZxSESZ1M38cdFxZyUnr1ggy2EdFivOCYcert?=
 =?us-ascii?Q?CxM4MzZuSj8jsdiCTmhjXYraxIsUXyzcj7pJiGFLOnDJcf0L7Z7QItWspGfA?=
 =?us-ascii?Q?Kp/bTr5uClmJyBi3CqvVYZnVPGbhAvuHTvQ6YVG3ojNwXr/Rt+6dQp0vPLmB?=
 =?us-ascii?Q?4nCq3xYjH+SkpnXrgtYuHzbHFM6CmlpF16cRbFomy230wg5JWPoQcBR6IjCy?=
 =?us-ascii?Q?M8d8GxTEXI33odwCAwOPC9GvnOrDjiSIMW7yO7RK8uZIcZwyQVfx/+MTpB/6?=
 =?us-ascii?Q?tnFNYdGWkWgZn9RabT0BZYaH26Fn/Ilu1fziN1/7Lrpu46Z0o92AjD2O91SH?=
 =?us-ascii?Q?oVjpLowq07B+EeQ4KQcEEwe90DKOF+sIg4T0Bkz0KJC2NLsp4tMTQjCJiVlk?=
 =?us-ascii?Q?06gcuusRgl1A6DEESRIRlJ+jzAcmSqqGvckx+BZFc1xUe7SgXBEsKKMR/TEx?=
 =?us-ascii?Q?SmogBqZ3BSA9fS8wsUdexuhK2AyVUXx4i7j6yXF0ZryyTVhtPETrb2oNIvTu?=
 =?us-ascii?Q?rGJ6VRCodeaAepb93KcTqepi6w8dQHds2OYzWtGEhSF1sbVyEqNjkReeTiqk?=
 =?us-ascii?Q?mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8055652030CBD54586BF5A59EAB94787@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qCmesz2Bn9bFlUr/mltuyj6lZjdWkIfw1JTPWFMl6SiD0O/j3+QHpzn1ODqed0J3AgA+eeWmvJHsuEzJeE1UQQ8zWxNxcLZ9/2SgJFWPEkr7N5LxL+amkqj4zE+wcmMRQIiKVTwU52Ya+S0eRkaz1TjVGFyofUobhDpK81j/zIGn8dvwKqdD8Nm+CRV6I+iIzJmqbfJekaGpBLge0QtFhswQVAzckawlDZA5qSh2ICo8WMjWe7kX4fVjUwkIhTmDvicGS0ANxxb1yzXtmkY2MvletWBWaOpThOlpp17sHv1+mUFtsdnQ+boDG7ejjCx8akrZ8DI6e/1hV4xyIY4htL1pOvcSHtPZrw8kFRW/OjwL5bv+v0byLgVY6B0VYhmMqus2nlm6xZyJmdQ4RDpMy46b+MbZuLZmzlc1JzqZHM7poJG5FbJNeudOsKapITvZPzJyu2JSQ5hCA/C3MW0IkxHA+mshKXhiNH8xbO9cxGsXafwi5Pt7iTpOf/mUxRe+MczaBCxX3M6B/CKTxnBnPky88FIwP3GB+xLDyozvrOK9u4qTEoUJN/YmsyL9RWUhNE03uT3Nyeopsv2wl7sjMJAwz2kg9+7S2i8FoByNS09/S4NNvOj8lcMYgePuoEIv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1616e646-539a-4747-4450-08dd8e9f9582
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2025 02:17:01.5329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P0fROOhvsAjHdIJnSKTgDyJFTxr3wu0jaLJrv4pjDhay+Yer9vBSULAyMcdt4RF05fcvZ5k5eRrXGBvxtjZsTZhrc/LMw1vrJ5jW7ZGWbnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7377

On May 09, 2025 / 11:02, Damien Le Moal wrote:
> Add a missing ".TP" statement after the zone_reset_frequency option
> description to get the correct description for the option
> recover_zbd_write_error as a new paragraph.
>=20
> Fixes: 650c4ad385cf ("zbd: add the recover_zbd_write_error option")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Thank you for finding it out. LGTM.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
