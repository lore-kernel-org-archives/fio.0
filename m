Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF902EB847
	for <fio@vger.kernel.org>; Mon,  9 Feb 2026 23:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770681453; cv=fail; b=rgVW7AoKUsvKhSRoqu4ugQaRavqxxN5XVVkmIb70hRjZ8/joAJIfdFKJHOmaR8KBjux8dtYFO0EB5OOENdjygeB5YvD3m5Q4bYt4nGrUhP2yBq4eVO3yBAtOZsZCEYjIGdwe7UhvYk8AhZ8+KzrPv/qJL2RqEbhgV3Gi356C0eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770681453; c=relaxed/simple;
	bh=rwBMfmT5qVMFNyYzZpWJWYBOj1OiyFKtCnHO3UHdYNo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ikTlpoogKbpR9zCUKNSmETa10h9gOWJEVhzAtqDNdAkPJfhOGZqImncj3d3hw1wM+UD4KPnksGj2hYuGlxN2l7g4398z5iwnoAi0GQWKlW13LU2GoQIrkDSMvTcwqqEp4p1J8g+Zoi1jHv+rb0Rguzi8rauWQsMwoBFFoVWlQG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=k6pPgLft; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=SszA2XCY; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k6pPgLft";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SszA2XCY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770681453; x=1802217453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rwBMfmT5qVMFNyYzZpWJWYBOj1OiyFKtCnHO3UHdYNo=;
  b=k6pPgLftodApHaxe/0A1u0wnfRWGbUswzHSV2HbLmkEXBvjzgYt+6+Bh
   WQ9GiF+//iDGU5UXztDppejcK6JTE56ruiSFscRd79XLRIwuCwFnN8PUP
   y0kTFHu/WqgaLOaXmOmV/WjvEkuHzuKauxbvfDiJaR6huoeImeFMwJP3I
   4zC3GUK71kKw9MX9o1uvZDqjjMd9oBbQ5e4xC8xaoERo/8Ptstvcl1QrV
   MhIgr17F0COnU0lOA3L1/0UylIM5kJL4s3CbKvRSVuh6eMJIVPb90r0CC
   I8EYSwq1kypm09Smf4I3zu8h23MlEd9qJ0L0sVBDuBeLyGCaPlMGXuIKM
   w==;
X-CSE-ConnectionGUID: +kkOdU5BSEm6Z7YSm4iM1g==
X-CSE-MsgGUID: B8HEB1ntQvyw0GKNoqbcog==
X-IronPort-AV: E=Sophos;i="6.21,283,1763395200"; 
   d="scan'208";a="141025413"
Received: from mail-westus3azon11010063.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.63])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2026 07:57:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3Xmls1HjmmuIsKIa/xGTZXg80XfhzOpvYAPkKiGKfV0sx4iNqp0G5Q3EKP1csKAvMZy9vi52qWtnFx8HrPNSJbXhCfygowV3/pY/10DJyiKRffmHlFlChJpqiLJrL2iYz3n/F+QbA4Dirmd2OL1mF9XV9VAzEsvlZgQILt4yTeVl1enmSJdpE9twBJdGfyy1RB1CIo/O0hwVw1WdPzUdL/BVdk92dB+kDw177q0koiX5lDUuef53mMI+askD0shg1Y9lTjgFh2BIK4U7ACYUjHDQK0SL0es4l6nK8q1+fsJgF5HSDxG1N/aMzoSWwDYgjhq/rBfgWlOswYjuZ2Rzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwBMfmT5qVMFNyYzZpWJWYBOj1OiyFKtCnHO3UHdYNo=;
 b=dcbR1E69X/gydlD8D1dW7u4VlKU5i8D8nvZmwjcjPIPsV7B7OEWplwwubTzeHp3qCEGZoZGdUk1syPG5GXObyqGlmGULAo0N/ipPH9ERRMcxQKZii1mlFcuQRanwH3Iyaxl4uA72zztispZdMUtHoVJVtDpJNIvxx5tkS1qv3G0Yxc6GKZ+FV+MbvUIuF8g/+LGDc3uQ3MVyjyvPVIKmx4+dlinD7FriI723yTVwafa1+IFuArkuaU2u0ct4OC66G0yHXI5DCzwnVv0k72fA/Hoyw5tbVUAyZFBGVVnY2NR0qQGh775GtQliYd0nOmkOoVxPd8m2dfzralWN6ivs+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwBMfmT5qVMFNyYzZpWJWYBOj1OiyFKtCnHO3UHdYNo=;
 b=SszA2XCYdSoq++Zki/jbEFMhGZITFVeNJxzT4PvkZ9JiPSg+ygBxonfJFnkRJFSAVGd1EQGk8cCfPIUTVRzHRcIVpUs69p1fHB2MgnrtPD8H9twqPj/aR+Y/rQIMKLVJwhzwz7ZDV6kuOfqDiyurp1RUm14WkYTvfF3L1P9VY40=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH4PR04MB9338.namprd04.prod.outlook.com (2603:10b6:610:246::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Mon, 9 Feb
 2026 23:57:21 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.004; Mon, 9 Feb 2026
 23:57:21 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is
 specified
Thread-Topic: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is
 specified
Thread-Index: AQHcgRC3+kzZbvpbx0mgbeTQG6UQjbVlWXcAgAA5nwCABbFQAIAP+R6A
Date: Mon, 9 Feb 2026 23:57:20 +0000
Message-ID: <aYp0ONUf0UpZnX7y@shinmob>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
 <20260109023603.2848421-3-shinichiro.kawasaki@wdc.com>
 <CAOp=CXnX9zorei7vwO54OvxBeFEjsKzgKXZaLqDOmu24-X9bbw@mail.gmail.com>
 <aXgleDJ44YFYDQeF@shinmob>
 <CAOp=CXmUB1cf6AgMPqLAVXaKCLxy+B56918MzTGUDtGR1QXTbw@mail.gmail.com>
In-Reply-To:
 <CAOp=CXmUB1cf6AgMPqLAVXaKCLxy+B56918MzTGUDtGR1QXTbw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CH4PR04MB9338:EE_
x-ms-office365-filtering-correlation-id: 9341d11b-3637-4a33-d89a-08de6836f6b7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?czBpQmFwQ2N0ejZMZWNJTUlqQUlQNWh5Q3VyVU5SZTlDczVqcS9SWTdPSG9z?=
 =?utf-8?B?U1haTzA2T1JwRWJWUWprQTMreU14SVV5WklxNmpFTzVtaktxRlRsZWxrb0tN?=
 =?utf-8?B?akdBNUx1UWJQQ2txelZvd3ZwdFFPUDJpeGxtaERZdnhwaFRIVGVqR2ZBeC9v?=
 =?utf-8?B?SFZ5K09wZXhUQmMzVEczb0xCKy9xR0dLTlF4YXNXakczcXpoV3crenorcTVi?=
 =?utf-8?B?dnl5MDN4ZkJ3Z2hQVVkxR3o2VVU5YUdIVUJYdHBpeG54MW1oTU9HMGJlc3dx?=
 =?utf-8?B?SGlJeEVUVk5HTkUvV1BJbHA4NThyNXBaQjV2Z2hpL25HTDl1UXlMS0xqYkY2?=
 =?utf-8?B?TktZVDVLZW1zeHVCeEFBL0lrSy9PWUpEZ0hWZHNJWUpTbFJTN1NGeWhuZTNP?=
 =?utf-8?B?bmlRWUk3QXY2V2hKT3lmelNjeVNTTE9jS3RzQmMxbU5ZS1Arb3JxOStrZVIy?=
 =?utf-8?B?QkIrSU5ndlB5ZE9sQkhGWFNqRkZGT3NoOGVCRndQSWpqOXhGM3NCTUZ2aUVj?=
 =?utf-8?B?UjZSRW55cGNTNE5wT1Nma1lvTXorMlBwNFpKQ1ArMklsUGgvbGo4YkxWNVpK?=
 =?utf-8?B?S2tnblUzNktBTmNHMVBlZkJiS1VDS2VBS3RBVzlpM0tpMi9FSTJNZmlNbmJk?=
 =?utf-8?B?TE9QcGZlUTkxaHJ1QVROZ0t0anNkbVROYnZoczJEQkx5NjlhbDZIZzRUTVNy?=
 =?utf-8?B?WGFYa0lWbytRTXZpZTlUNm1lRGgzTTJFbUl1eHRsc0VLOFJFVlVaTnorT1NG?=
 =?utf-8?B?a1hLUG9LMXJNQXp6YVJPcXdUcWFCd2k4SkFqTzNSUU5OempEM0J2WDJnY0wy?=
 =?utf-8?B?NUpxZjlJY0RSOUh1ZEV1WlJtTUpuWU9NNjJKRWd2ZjJ2VTdVOFRxcHNrN3hN?=
 =?utf-8?B?OTVEN0tVTGtVNTd2VGJHWnA3ejFQNGg2UkNjZStiRUVIbDFsbCtmQ0E3WURB?=
 =?utf-8?B?eVVPNGxVekxvdmZkdEM4anB1Z1daKzZ6YkI2SHJYZEhON2RGejA3bHcvcUht?=
 =?utf-8?B?SVFxbGJCVTBzaE9QQk9sNUluOUxsSUFZcXBLWGpqbEJRdmRLcEtDcVBpMTRs?=
 =?utf-8?B?azV3UXFQU2FBd01jVjZEL3NFY09WWVJrazNTRjk2MEVaUFlrcDU3SEdBY3V0?=
 =?utf-8?B?TzdMQlgvbzVGK3pxR0FoSEtFT29FcStTbmIydUFJODV4QWd6Nk1IWTBidkxE?=
 =?utf-8?B?UXVoSDBxL1pNWmxZeWlWMkJ6SGFxZFJEVklDZVNKWXBLc0VRN2V4bEE1TzJ6?=
 =?utf-8?B?ZTlwZTFJcmY0OFc3Y2Q0NjNaSzEzWSttVW1tcjJUTU5HWDRHand0VEZFNFpy?=
 =?utf-8?B?aHZ1eHd5TmtjLzFyeU90K01saUNPZ3AyalBJTGNHUDNnQnZuamJPUFFXaW0w?=
 =?utf-8?B?MGJhTXFtb0piVVc0WVBYQWdHbFpwMlBscHN3dHRTMTQ3STZGejF1bFE4UWx1?=
 =?utf-8?B?aGlPd3VVS0dHRGFESVBuREhpK1A2OWhBK0xrbXpzWVpTS0t0UTVHOUVoNytF?=
 =?utf-8?B?OGdmdE1IbkJSa3dRd2w2TkVVRDRxZVZUSkZiQ0txMkV1eUNUOFJrSDVVdFhw?=
 =?utf-8?B?YzJOOUhhQWxXc3RuSEtXYVFMaGJnL09OaU1MSGlqRGV4eWpVNTJOZjMzelBn?=
 =?utf-8?B?ZjZjUVpMRFBzOTNwNGRTV3ZoTGlmaUVJUWlQZlhFKzJaWTVqTXNpMkVBL09J?=
 =?utf-8?B?SDUxNjRTN2hNRmlMd0dIVGhZOEhxRGkwNzlhSXlCOGZSMFVZR00yNGdaWFpX?=
 =?utf-8?B?V2lYcDEvVER6ZDFNUDh5eGxXVHNwd2NLQkhpV2RoekhWNjdBdS9BNGRkVXRO?=
 =?utf-8?B?eUQ5ZDdMT2VkWUVscnVrT2JLaVhLczVpNlBLRHBGcElRdnc4dXZYVmRuQUFa?=
 =?utf-8?B?SE1zL0F2NmxQRkh0eFJUZllBTkJRV2NmT3VCLzBmUVRiRjhNSU55QkNUUXlJ?=
 =?utf-8?B?eXVlaVExNHA5UzIyeFd6bWlHcFJyb1Q3aHZIZVJodFFqQkFFZTMyNCtxRWRR?=
 =?utf-8?B?b1BsSElyVm0yQlUwOFpYTUhPNXVMRE16VElzcS9MallzSStTZ2VYaEFEd2R2?=
 =?utf-8?B?b0R4em54WmtLOWR2QzhmZHlHTlp4RkYxaGtrVWY4TkZVbURjVnBLZUhlb2t3?=
 =?utf-8?B?YlpONjV5dndrL2M0eEFQdTRQNURPZ3VQQUhJZWYvdXdJeUh6dXhUV0s0VmdH?=
 =?utf-8?Q?MVxksMmojlEOhcGTjxIuPMM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RVZ5OVhnOTVNV3o4U0FLTk8vWFZDdm5rQ2I2OTZkQTVvT2hIaHJyOVlhSGt0?=
 =?utf-8?B?dlJUN0VIOW1UTjdqc2g1aFV3WERPbG96N1FrRzE3cCt4cTV3RThDS1VvRGlx?=
 =?utf-8?B?aU93WktkV3VBSUg1cnJya2tNbGVjL1gxWHB0aEV0a0hSWTFrTjZOSlV0Z1F2?=
 =?utf-8?B?TUlqRzk1VjdqUjVCZGkyZlFGQm1wZm9xanM4eXhrY2hZRElWbndlVTJ3TDgr?=
 =?utf-8?B?ZVphSGUrek1jZzYrcXZodkF3eFl4MmZqRFBpNHZFS3FEU1J3cXovMFNQa0tM?=
 =?utf-8?B?Z1JTWVVva1M1TmErdUF4TVIxandqcml3YVN2aGdzbzVTcUQyaGJnbmh5ZmlD?=
 =?utf-8?B?ZnRFeDlzaGNLbGhxWkcyclZWTzVyaWNrNjBwYUFrOEN4Qm1mOWFFdjV6SEhk?=
 =?utf-8?B?b25XbCt0SHhkTDc4VVpTNUV0eDNRMWpBa1NKSWlzL05qL0c5aUFaOEpjN2Uy?=
 =?utf-8?B?SFlsL2lqMWxqaWs0YTFwdlAvQ0NBeDRRUFZtQTFSeVlIYURVZFN4bm4wVEh0?=
 =?utf-8?B?R0xGQ2dyeTN0UVZ5SkxpSmRNbVZGcllmYlRyT080QnpxTnpQdm5JaUVIREZo?=
 =?utf-8?B?RklObGc2NlhTNlFCOGxVSUpqMlBmNzFFcXpRMnNHbEU1cHU4YjNab2RaTjRp?=
 =?utf-8?B?ZXo5Vk4vM1VBWGVxamNTNUZ6ZGtWR0JlVkkxdjBDajF5bkt1Zk5RME13NXMy?=
 =?utf-8?B?bVMvWnFIWDNWNGxhOHVpSjZobFRKcTBuazNWZzBRdDd2ajc2bGxnMG1xbnlq?=
 =?utf-8?B?c1dBUHN6VGVNMzloZzN3WVlXTDk3UUlQSlNNR0xuVHhpSHF5TG9waXF4STZY?=
 =?utf-8?B?U1ZtcnI1VkN6SFljSjZxcFJMREdCUk9NTjVCVVFUMlpUREN3ZzRYWGtNRFk3?=
 =?utf-8?B?eDJlU09XSjh2TzdzSDVaUTJ1RWlWMTRmYzNOWDBMZjhiQVVnZ2d1SXp4Mmg1?=
 =?utf-8?B?NWgvdnRNSkxlRmVvdnZmcnVzRnZaUGFOd1FubVlwY2kzMFU0SmhIRHlJV2Jw?=
 =?utf-8?B?QzRZSllmWFoxWnltOUNMVkJGYnBzSGhmMWFjelVSbE5tNTFZQ1pKT2FuZllZ?=
 =?utf-8?B?eGdGNkRDMjdld3RCMml4RjFXTTlTQ0d3aG00bjZlcEdsQzQrYi9lbHBvL0lN?=
 =?utf-8?B?eUdmb0dFYXFacXZiTFJFTjBQcVBLOW9DcHJIMkhSdHc2ZDhZWXEyd3FieDZx?=
 =?utf-8?B?aEZmNVhlR0hsanZrT1FhcEFab0xlRDVvdWRsNHhPSkxwMUFPbXoxN09YUko3?=
 =?utf-8?B?R01yK2VhOUZUam4wTDE3MHR2c3orWnZ1aDVVTEJ5VjFXT0x5TGlkQjlCa2JD?=
 =?utf-8?B?dVlXNyt4V1VmVkFvV1N1V29UWEVRRGFDM1NkOGV1UkpjQVdvRUdYSGRxVEsw?=
 =?utf-8?B?b2xhQ09HYmh2NkMwcmlTVTRVakJFVWk2b0FTcG5SYWs2SXVXVG92cysrZzZ0?=
 =?utf-8?B?dnltaG1mZThtMlhELzI3TENzWmdpeVZPdEFhb0x3M1FJRldHRTFMbXJtVDRz?=
 =?utf-8?B?TXIrVjZuS0t5QVIzeUV1dGgzUURYak5UQlNJNSt6MG5MU29OWkxqa1ZsRmEw?=
 =?utf-8?B?VFVwWVhLODhKcXloQ0x1c3RLWUFXc0UzQ0FTMGF5QktySXM5b2hTL3c3ejZl?=
 =?utf-8?B?RGk0djlQVndPcGlBYXl3MXBpT0wyYUx6Z3QyZnpNM1Z3RHZpQWNXT05Fbmxt?=
 =?utf-8?B?bWNRT1YzcnMwcmV0WVhCaDNUQ2FiUXFoOUVoWHprSTFCeHpkUnJJcFYzYTVR?=
 =?utf-8?B?YlArMjRPUGZicDlmN3NUMk1VcWNhYlUzakpqUDVNQlVzVnhiQUlIOW5JRmRi?=
 =?utf-8?B?dnd6YmxPaWE3d3k5TXc4MGtyN2J4b0pDNU1xdFQ0TTBpTmdNQ1FGUHR3Qk81?=
 =?utf-8?B?QnA0UjRXVDIzOWU0eTMxeC82Z0dTcWVsNVNkeUpYQmk3c3R3WTdzd28xUENJ?=
 =?utf-8?B?TE9FeG9Bb3phS3RWZzB1Z3E5aU01dGRlZnoxcVdwcDllN0NpZHVvYTRUOXdF?=
 =?utf-8?B?Y1FDQzVzcnRtUHR2WDdydmZ0QWFBWTc3bFpOODVkZ0tLakpyZS8vaU44Qzln?=
 =?utf-8?B?MTluM3E4NjFPYkpZQ3piVVBtMGd3UGdtdWRnczAzd3grOXphalZ3bTIyNEhw?=
 =?utf-8?B?WU8vcDhCVzFQNHI5dHUvcUNCYWx6bVZSZW1FZUVKZGs1dm1GVmtucDYrWmxU?=
 =?utf-8?B?SXJwY0o5UFd5cC9QZng0c2dZVmlaQkZyZnpJa2x1Skkvcy9PRmpGbFE2NzZw?=
 =?utf-8?B?aWxpR2hneGJ0REk5Qll4Sm1ZRGlYcHlmQ2hPbEdydEw4bWFodGdBR01GN1pT?=
 =?utf-8?B?eWhYWUZLWU03MzZabGsyMkMrVlFiUDlYTDFhQ0ppbDhkcHo3SlREbmpmc3ZW?=
 =?utf-8?Q?bZ2mRyLKG3AKUgOQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1EE1C164AA65B42B619DE2D55F29311@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+97C39xfgHgxrTzjWEShZGCNSDKUKK0b45tzfSwf6aNCMyBMErShb4k24fc+IjAL1ENBpNgmqw9E+U2qfk6Nzf0bQbRY0R1Or9jQ7KiszRoEV3eUTISmeafH8pU4JyA/wchZXl68qgnBGrCBEaZEUs36a5H2jNtQNRaLhrwloB0ABuHwxz1phh2OSiwo/qZ5epohDrFXnrXkTr5SXY2ASBbH0IcmWbys3V7mVN4LNzayWPNiZeaKJwrSpOgjLCnQ9ZaTvVX0gL13L0Bsi2WTq8T3D0BTrIoIHVvkm35XZ3SjL+L8NrW7p3wguS+pXFz2/CRZdB3A+x5/cVseiY3NMZxA5Hl7f+Bjg0wr8X7aqQr1gf3toDMhSrE2txyXZgUgnVm7hv9CgIDyhDxZMXs36/EmO+rU+QRfFzgmkMjq1RFFNb7m2pGdUmiZCA4XbdpWKTik1ph0OFaSf9LMoZQrxw7yCnNZR0/DenbsQrJ9YJoCBxH5gNXWBOx3iXZMK+nhrZYvIIDCdc92IjFtKHdLeySjON8VdqWn6wCLDJvycwVv3gSoabsIOvj4gjaHE6GsNMAdXsIJe5F7KBhB6cggxzTfAzVEepu7Qz4/UJaaJKCZ+qpw7cdIzrLoYlDLtIN3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9341d11b-3637-4a33-d89a-08de6836f6b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 23:57:20.9893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JpH0smYaKrMIn7qBudMj0soVRYJQSayZSvDJaSZLoJ0h1fYdpwQxxlCHBeEZbQ4Jq92YTMgGaWZlwaEkKHIgiftpORkkYBAccRwzotdfH3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9338

T24gSmFuIDMwLCAyMDI2IC8gMTU6MDEsIFZpbmNlbnQgRnUgd3JvdGU6DQo+IE9uIFR1ZSwgSmFu
IDI3LCAyMDI2IGF0IDEyOjA14oCvQU0gU2hpbmljaGlybyBLYXdhc2FraQ0KPiA8c2hpbmljaGly
by5rYXdhc2FraUB3ZGMuY29tPiB3cm90ZToNCj4gPg0KPiA+IFZpbmNlbnQsIHRoYW5rcyBmb3Ig
dGhlIGNvbW1lbnRzLg0KPiA+DQo+ID4gT24gSmFuIDI2LCAyMDI2IC8gMjA6MzksIFZpbmNlbnQg
RnUgd3JvdGU6DQo+ICBbLi4uXQ0KPiA+ID4NCj4gPiA+IFBlcmhhcHMgeW91IGNvdWxkIGluc3Rl
YWQgZW1pdCBhIHdhcm5pbmcgd2hlbiBhIHJhbmRvbSBqb2IgaXMgcnVuIHdpdGgNCj4gPiA+IGEg
cmFuZG9tIG1hcCBhbmQgdGhlbiBjb25kaXRpb24gdGhlIHJlbGV2YW50IGNoYW5nZXMgaW4gbGF0
ZXIgcGF0Y2hlcw0KPiA+ID4gb24gdGhlIGFic2VuY2Ugb2YgYSByYW5kb20gbWFwLg0KPiA+DQo+
ID4gQWN0dWFsbHksIEkgdGhvdWdodCBhYm91dCBvdGhlciBvcHRpb25zIGFzIGZvbGxvd3MgdG8g
c2VlayBmb3IgYSBiZXR0ZXINCj4gPiBzb2x1dGlvbjoNCj4gPg0KPiA+IDEpIExlYXZlIHRoZSBj
dXJyZW50IHJlbWFpbmRlciBoYW5kbGluZyB3aXRoIHpvbmUgZmluaXNoIG9wZXJhdGlvbiwgYW5k
IGFkZCB0aGUNCj4gPiAgICBuZXcgaGFuZGxpbmcgd2l0aCBzaW1wbGUgd3JpdGVzLiBDaG9vc2Ug
b25lIG9mIHRoZSB0d28gaGFuZGxpbmdzIGJ5IGEgbmV3DQo+ID4gICAgb3B0aW9uLCBhbmQgZW5z
dXJlIG5vcmFuZG9tbWFwPTEgb25seSBmb3IgdGhlIGhhbmRsaW5nIHdpdGggc2ltcGxlIHdyaXRl
cy4NCj4gPiAgICAgLT4gVGhpcyBjYW4ga2VlcCB0aGUgY3VycmVudCBiZWhhdmlvciB3aXRoIG5v
cmFuZG9tbWFwPTEgd29ya2xvYWRzLCBidXQgaXQNCj4gPiAgICAgICAgY29tZXMgd2l0aCB0aGUg
em9uZSBmaW5pc2ggb3BlcmF0aW9uIHRoYXQgc2hvd3MgYmFkIHBlcmZvcm1hbmNlLiBJDQo+ID4g
ICAgICAgIHRob3VnaHQgdGhpcyBsZWF2ZXMgY29tcGxleGl0eSBmb3IgdXNlcnMgYW5kIGluIHRo
ZSBjb2RlLg0KPiANCj4gVGhlIGFib3ZlIGlzIG15IHByZWZlcnJlZCBzb2x1dGlvbi4gSXQgcHJl
c2VydmVzIGJhY2t3YXJkDQo+IGNvbXBhdGliaWxpdHkgYWxiZWl0IGF0IHRoZSBjb3N0IG9mIGFk
ZGl0aW9uYWwgY29tcGxleGl0eS4NCj4gDQo+IFdlIGRvIGhhdmUgbWFueSBvdGhlciBzaXR1YXRp
b25zIHdoZXJlIHNvbWUgdGVjaG5pY2FsIGtub3dsZWRnZSBhbmQNCj4gY29tcGxleGl0eSBpcyBy
ZXF1aXJlZCB0byBtYXhpbWl6ZSBwZXJmb3JtYW5jZS4NCg0KT2theSwgdGhhbmsgeW91IGZvciB0
aGUgY29tbWVudC4gSSB3aWxsIHByZXBhcmUgdjIgc2VyaWVzIGJhc2VkIG9uIHRoaXMgb3B0aW9u
Lg==
