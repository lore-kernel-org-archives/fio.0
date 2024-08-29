Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E861FDF
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 05:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724910660; cv=fail; b=Q3p/uEEld5pZSqwYPEYQ0myfG7QaV9p7hkwoBd15XWkRoC2rrqD6vJpUSmaVqucXn3+0O3v6qmQ23BRNuuNP4Mi3/ZELMT8qVj0ezSsjOoRoAu3ifLkX7tCXqh1918LuMt9S0KrsQroO6ok7ngMdgLcl/f8wmlb4wbA/doBedyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724910660; c=relaxed/simple;
	bh=oLvExZv8BUmoiPEr7uCTfZX+Ek94eQcPzuJopHc9ZsU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l9MGe61evkMTEb9Xg5w06nOnsaXi2gvW5UyqAZ8YK4/jVhxy1Nq9lI8MbyX63Jx7qNfodnuRmwcx64WFcp2vHnQldFKHVoGX1oChi7le8Bxa4Iv0itR/WepYRW5z5RFFLvZYNpm2WMa/tRpwMI1+KiT57Qj+j0bGTkmZKOTPoH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P+aAiN0Y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=jSoCD8C6; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P+aAiN0Y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jSoCD8C6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724910658; x=1756446658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oLvExZv8BUmoiPEr7uCTfZX+Ek94eQcPzuJopHc9ZsU=;
  b=P+aAiN0YOrqh2isFXCyTq4kykBDV5BTIPV4MkWEd+tRuCcDpqSHxUCHr
   z72YUywYugPzjyvGJjCqjRB1jlrp1/lATMUMGq8NcySS2bpCeylgvUxzJ
   WSCWQPW88CfzLnHjkcqzrjI+1BjPhfjzJ2GEldAPFIgu++tRyQKHOAU+H
   96PwfhqEicVXgL9oHUG9ee3GmUKktTR/kt2XLXecBggitn8G8/DCi5G3G
   obsy1KvFS/jV46AmKPLao/I/6Uq5j0qYwAoCpyNEafovILhyq1PSnAlGz
   mYFos+eb8alZsQtnFYiz3rjVCy9cNpFSDS7j2jJvI6a3XJUJzfI8pm9ZC
   w==;
X-CSE-ConnectionGUID: gPn5EqMEQsytcMvD2MJBZw==
X-CSE-MsgGUID: 7Bod7EzCSuuIk1m4rq69Fw==
X-IronPort-AV: E=Sophos;i="6.10,184,1719849600"; 
   d="scan'208";a="26240418"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 13:50:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCO4zOVm0iG4lgqcoXrfnz0uuZ7oP9FDjPnDGCYT7dJrUIGWbKZkZ0zn6WFFQz7S8lMSWJe2nwzTe+7GkAnj0y6dXjgeXgI6MBNbjktvYdzjCPrR00enF4ST1rRkB9fah+fg1pFy331lWy4VjfI1SnXEXrC4pYNk7qS8SK/ZghzazhoZX08qVpeB+yA+gQMD08eQ6SSWDjhEoBYmrxLpxdX/QS6mF0ovtgiVX4mI6+EgJbSAFW95Y+h+0nSamX7hMbC1Bj11J4A6nhLG7l5KlLeq9VYc/c9jNK3Wbw4oeVS0igr4ztAg/Ptm//mag8p8gw4iKVHLUc/+bZhUVK2nfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLvExZv8BUmoiPEr7uCTfZX+Ek94eQcPzuJopHc9ZsU=;
 b=C7OOJ1n+bUecvSvXv4eqHBX/SckUCk3m2H8PPBXKvWy3Bcrg+hOijSXEBKwaS5Vr/EQb7MlQJiV/mZKeC4erGYVJ89AWRKXHmodoDAM64gpZpC+2rCMvaK6eeri/lZVFpcOte4tPmLHxgNNc8PNBqunYHvNr7f4KM29Sz6VlGhZqw1eLY9rBIxLv2PwY2H/JAsp27gO0TrN4CRCURz5tjiqCifsUNyJqvjJoBHPXUz9V5rNlTW16LrWtHzg2yD9FHW9mDbCSxFoRSBiaPVs2ql079TgSUuKNaF7mq6ExmR+TqN5jP3VJyUIeTbuCrK50WZXrO5+Eaw3xMl/mitIilQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLvExZv8BUmoiPEr7uCTfZX+Ek94eQcPzuJopHc9ZsU=;
 b=jSoCD8C6ktp3ED7jaY++9G/zkiPhb2G/4bOxg7L1SGydbSseSzMIe2n4KITD8Hbr3Y6hrgVH8s9NvH4BjV8gDNMrKE/SPJXZ8X6kXKJRCXp7OClN4U2GMZcOyBJWr1rzoT5YyyqMX+xrLFzOfx5fSSLNSMx6JHB/jlh0sk0GLF8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA1PR04MB8918.namprd04.prod.outlook.com (2603:10b6:806:375::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 05:50:49 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 05:50:49 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Vincent Fu
	<vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 5/9] introduce the log_issue_time option
Thread-Topic: [PATCH 5/9] introduce the log_issue_time option
Thread-Index: AQHa+E//k/wYq8WDPk+oSjlVo43uOrI854GAgADWq4A=
Date: Thu, 29 Aug 2024 05:50:49 +0000
Message-ID: <gsxnsr7whvt7fl76yd57sepe24hbtzktxz5fyw4qyzjtj4dqme@xktkxgslnoba>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <20240827070850.947037-6-shinichiro.kawasaki@wdc.com>
 <b6c35fb6-5306-4b4c-8fdd-1357af057315@kernel.dk>
In-Reply-To: <b6c35fb6-5306-4b4c-8fdd-1357af057315@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SA1PR04MB8918:EE_
x-ms-office365-filtering-correlation-id: 00a69836-3c6f-4ab0-058b-08dcc7ee892f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700018|27256017;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?gQgxVv7TdndWiK0yA03c8QoXCoOsf8+/leTcpd8WCyNI6tQAi7qDqxCVueLP?=
 =?us-ascii?Q?wilGL4wskWd4D0FCh7JigfLyZOyuabCmmEdGCvsRaOggq7vaFwUot0H2t4Hj?=
 =?us-ascii?Q?gZzIHkZjIDnC7bsPmMo99yEwTAAQUajBRSVqJvUyzlPdYhBuEQfatkamy3PE?=
 =?us-ascii?Q?r3j3WDQO6xATyesimU1E5BkUTDVsq1d/UJeuoWweuPCbIvywHjRoH4tNAyW6?=
 =?us-ascii?Q?frRMQRUMOvSGhJ43MLeE0iNuao29OE0rsoboZ17UESheLhHRMW1njyevzVXI?=
 =?us-ascii?Q?qGNKBxu/tzEBS2h6kW6ax0A6RpHGBdL+XqbQH6bdibUJSp0VDDzAcJnozRaP?=
 =?us-ascii?Q?i+hPG5lNXqEkcyxXUmjFokKLptAzfPTYhn7VYpg8NDfWA5eWdU/piWlldsl6?=
 =?us-ascii?Q?Lg67Gj6SUU5YrKqzxmdpFzTmDsiLDXmAcglwUHnoWybEl38s0zK504Pf3OoN?=
 =?us-ascii?Q?wGqJnulEalWdZwf61i9ysJnNuQJNPqvzgRvbISG4ULG3pEatv10TEn64H6gb?=
 =?us-ascii?Q?q0DVhQ7lScS5Sl72R6MwjehPKwvxKNf9FlCF7FXybTnnnsmrgxvpfCy37ryS?=
 =?us-ascii?Q?y9H4q88dMNTzbGqgGsIE7S2ykktY9I6vHcMa9luhQvztO7v6ryWdzNjlEdq5?=
 =?us-ascii?Q?Q+4VLWdvppjJPI9dJe1t6/JVdxZruygPgd5GW+naFjayXuIdK644FVvYDqwJ?=
 =?us-ascii?Q?kPtCcOust/uo1ip1nig1JkDKhIt+zdzmekHsadRAtRLVRlp+wmixoSr8Moop?=
 =?us-ascii?Q?82vWpWW9jXc64GTIQ3IIKRrScD5UG1Wcqg9D6JvWukSksQEHDJsfSR1MEu1P?=
 =?us-ascii?Q?Qgb8Xcf1E9cdiIXX2on8+uSt2x+H4R7N8RDigRokX2IxFayjZziTXT7BTsH7?=
 =?us-ascii?Q?coUC0PTgPGua9pUmrkDbJ44DgrXPKd/cULgwu734X0W4StN6MMh6aWq6LHXd?=
 =?us-ascii?Q?lIRK98fz06iB7GjvRoFSaNOkuSMRkbITV6FWd4wbruT0aBSc23A69I2CfvVb?=
 =?us-ascii?Q?HtiTDazUOCy9pg/MdzQA7F35ocbLbI2wYtLPEPiU+evdpBmn++15bozjz7Cz?=
 =?us-ascii?Q?FkUg388CtPjX5jkEt9m67gnKgQNLpBXljVOkrzVq1t/FR8lonngrCRjVV7sz?=
 =?us-ascii?Q?c3+r+Spxl4QTHOeX6RPNq8kLgTvqmlt8k5hk9HywpkG1a+9YpYwt4UXNOhr+?=
 =?us-ascii?Q?H0KVPrHdS5GE/u1jpxA9VvKK/q3S12xMa58lAaMtowH0kixri+rfJT16Uf5R?=
 =?us-ascii?Q?3BRxqat3feFt5zOUKhJ/+gU0CUdOzUsWft1I/PeJJkMgFosv2x7c/pHQPOe3?=
 =?us-ascii?Q?gRxkTm/4LY50NZ9gibRrnE5CEkjTYcqozOWXohqTsNFCkS5qucnwKUL2Y8+v?=
 =?us-ascii?Q?p2aeQgkMnrCE27KCundLKmO/Ax8UYMG6+gKZoGONfB1nMpcCDUq55wU8TH3f?=
 =?us-ascii?Q?VwHTC2oX9Yc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018)(27256017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?89VdcbXlVqelZ3xNM25KANyAXyWo/xoZX8I2gV7oLpsfi7gSYJnM8QnTvSXM?=
 =?us-ascii?Q?2wNS0oNq2Ff7N9w6jzqapEx95wzfAy4ryvmzPXrACT2ZqAqwulSV1t3W2AOO?=
 =?us-ascii?Q?mf3Hk7CNOcsUj+iU7j42ia27yU16dmJpZlhs259WbD9m107L76yGidB1YqiQ?=
 =?us-ascii?Q?z2SGkWRq8EeE+kmiPpWWclsXL2FuQ0In15ttxwANUk6tIs2lJWLvSLDUG7kP?=
 =?us-ascii?Q?Kg7crxRBA6cxSgjwOVYe4L7aQfO1vFjs1MVMpL8aDwF1IaOMrupUBg3Jk2CM?=
 =?us-ascii?Q?yABkCODa/lTvJtzjsqlf+6eF2J37ZMAQsDgHm4zRRKeUAjsrl6N029DaOlQO?=
 =?us-ascii?Q?uVKFVMxQnoU6w1LHFJCQmso8fxhzfWnnzCywtCZwK2HJL3Lh05tgVadtJDRN?=
 =?us-ascii?Q?7gNPwLFTzl+8uOq1MfRlH/g2w4ZkbB9g1+90nFTNHxm31HMl7VRKFOaYW2nR?=
 =?us-ascii?Q?rpv5w8oi9OguMLlSUvhGY1BkCwct2NdCse4e7r7T0ReC5ZT7GyJB7N44pV49?=
 =?us-ascii?Q?nQm9zIvJclriDGavcXhn5BgEoBe6UH9nHM3tSh1lM+kDs21UR/BpEI8m4YqU?=
 =?us-ascii?Q?rBxg4MSu1r7NB83MOpqLabAQq1T8ii+kp4uQ3P1bEPh7/lnY8qZTG6ApURAX?=
 =?us-ascii?Q?e2fcULBxwo+HVcfzCnxyZEPfESK1Jh3wNAVDxQRFqxkkbyhbg9WP7YW2p+PK?=
 =?us-ascii?Q?mSID9PORp1/Q+60gMqQMJkk9rxfnOkylhVhqrYX8AS+QGZ4LXyY5+KYBowTC?=
 =?us-ascii?Q?0ZM4VN56KZQWe9+P8dn+JDTVEihHUxlUo3nvTT5cOdyi9ArXXqiEZqys/CRF?=
 =?us-ascii?Q?OHVQIAW7ZnU/99ydv+UZoomNtPpAW6oXDhXwaT/MQpu+HZ7ujZf7R76CqAcs?=
 =?us-ascii?Q?iplHTHvPkZFtNRAmm8+h/luAhbDCqy7P22vE3LcGBMMjTPPwHigjU0s305eS?=
 =?us-ascii?Q?whecyFAr4paVaGFTXiZfAzpQMOo3Zx09ZNZ9y7Hi1EN/nGf55nuhwRFfxkDz?=
 =?us-ascii?Q?xysKFSYbTPZG5qPTz4U5GGiQ0CU8SsnwMbZnnspGtVnfyREQg/eI3pul4q7u?=
 =?us-ascii?Q?NeLcbFqvsQQ8AuWVoGdVlyx0IhZF52qqgWMQ/2EEoLyRAoeNgGSS4fMTbUYR?=
 =?us-ascii?Q?eYDKJ73C1V7J59VS37Lz+kxjC3ybwpoDL++GkP40IyXeg6KkRNGyDShs8gkv?=
 =?us-ascii?Q?5oiFjcdSlT4wRwzOyth41monrJqqetrwHRm4zoqqnfUTJYcDwM7JsoUvkN1k?=
 =?us-ascii?Q?bSrdklVzZyGF97afRWC6d9e+BSZsJ5f/McllxoZzP1s0v9KNiL075m9xeAqJ?=
 =?us-ascii?Q?KpoiOJINAZUR4L4VIgX72ocNqo+sp1Q6+fZrMW5V3jGeoAOboJTc5vSU4OVJ?=
 =?us-ascii?Q?P8Q6AYBgHf4aI/nRg61JN3yp3/si0P4Z8j2g9doxArVbPSug0gLXsXE4anmh?=
 =?us-ascii?Q?w04FMrpsxYOLmpmHjvCyiu8bDMB/QsN1lYKA5htoz6k35h6Xl242da8Up8ZL?=
 =?us-ascii?Q?GlbSH9gnCbSvWxO+mKqcAifMXDJCo/kVfhoMnLmOJ1UBIbAAyyBf3y5rTG/O?=
 =?us-ascii?Q?Btjg/ejMpAluYAIH2mmRaCGE050rcIFeN5ntQ8yJEV5MiOuJHkXebdZd3Ob9?=
 =?us-ascii?Q?omIZNoThrzqhH8glKylfbhI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4F4DF5927BAE44FAADD3E2304893406@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m1OXk/YFCwAtT4cBAKO4Ll3QJ4IOXzmLZT/GlrQQDyYChfY/ftChfnFJK3IjWnrlwyDFUyTPe7wa3VoMknYmWa7Hgt3woy9b1Jg7b9G5tMhybaPfa8o++zZETjFP9nHNdmdWei1ip2HZf1Gu+Dy2YabH9HhsRTa1dYP2mjlMC7TxRssFRGcGyLrFCFQinR7MWevXhuh2xVz1b5kepm6Y3WUdsZ38fcow+gTEI0sk33ytVyghRtmGu6OA2ULLCY65MIVa0FTEoGdZTKzWaghtRbDxEHzgZz4ftqyAvdwHgHrmH9tcXmuXbyhkEeucgBk2VzkmH3y6hssqAMMs96zcoiKEFr5VQZFiscNTYzk52YqKyGExoVzYTeAl3+DeQLZ+SGtgjloyVfPYfA2Oe+e9IpFuvc2waMIKoehRvg9YHUAQHujeo/7KyQtGhjYgiJb0ZVN1tD/NsGG1eUGdWA1lC/UYWkGxGxict8MChzNzEbzMqlihX3re+S2S5eP3cWe26zkfKszgXJAULZzgoHH48eeEH8v+bZ/Qrlc/ydGrzQ2P0TRsAYTbBJ72uZ6WIp/ZH8qYRIR2zP93gqeA2G0ry0a4Oepuph6zhsKnecn4dh6mG9/mNQpfZk0JDu+mho6E
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a69836-3c6f-4ab0-058b-08dcc7ee892f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 05:50:49.7278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywGiA52NdXnYFYhVefMvqmCnJ04564SHQ5+t3O9ppKzjnBGhQZ7ZglSTV8X+ojAyZ7Txmnr1MF/91YDLKCH0uJJRQPVLdVndoRE4e4daINw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8918

On Aug 28, 2024 / 11:02, Jens Axboe wrote:
> This one needs a FIO_SERVER_VER increment.

Thanks, will increment it in v2.=
