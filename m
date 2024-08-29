Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861A3D6A
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 08:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724920844; cv=fail; b=lpocWsuNs9mFi7NTKRZDsr+gFO6gddnkBgWsCdMM2U98azqLq2QKMKONAfBi+U81MywgBWpk4ER4au/HSlJRRZIXNfr3kDZqvGSutRFCmv5QV2mNBL9IPnQG85yYnR6rDx6uCC+/ltF1C27gmGLT8EHabeLd/nbXhLsQXD+3JEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724920844; c=relaxed/simple;
	bh=aIz7S0CBoK1yn3JYjSfb3o1sH2ZQruOe5WfwKoIx/Ik=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AT95OGbqKw9hOZjjjUJy3NP8/kX73hNxPgfKSh59wGiRZcRmLigFcGclrrcng/8/G7ozj58fUM+L0F5CNofyyKknqVvURPwu2xI3UVO3WCgsyUiFm/BPJkaOSwQFEg5zKBt8SUYmQHFKgn3mAtlkg03ufHRr7he90eIwvEJzZWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hd4cMVd8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Svg88jPp; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hd4cMVd8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Svg88jPp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724920842; x=1756456842;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aIz7S0CBoK1yn3JYjSfb3o1sH2ZQruOe5WfwKoIx/Ik=;
  b=hd4cMVd8qpZBXYrgdMUmyRt/sR1h4uUDV7WiKvNkfAXtQhiN1GCubx2D
   4EatFNiPEN4o3Y34SiDxgAfOAE8RPnlOg4gFEu7HmhBcByQrtsw3/HDAR
   CR0orcmvDpzMLN+odukRJGfrPDrNk/TzEOoUV8M0OV3cveKi9VU/osPV6
   SJA0L/AN8DvRXYdA0uwm815A3/ydv3DzM6tS+QknsaPXLrOgg/4bZddaK
   OP2gkBLcB09xatkYAS74ZOqT7I/oogHsMYdN/FyrsfftNYLvzAWaIhYvj
   itfMcpqAQwE/EHAKPLfeWbeCdHkotBUzuFR7xtOb8p6oJewI1mLN8ZkdL
   g==;
X-CSE-ConnectionGUID: XJeIfoBRSbWAQHZEBOFZEg==
X-CSE-MsgGUID: 7REQd7mBSsSsw0j3bSxIYw==
X-IronPort-AV: E=Sophos;i="6.10,185,1719849600"; 
   d="scan'208";a="25822716"
Received: from mail-southcentralusazlp17012052.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.52])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2024 16:40:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+6zp75uONdfsW9bjCV58XVHJWZp1Vs12MRqZeQfqdhRIdBWW2MQqrmRDDLspCYF74WcqAroPJdwfdlKhiHMisQHmsx9HBELeQicax+UVVbBCSbc6FrTiNUq8I/2UnLzKEk9FMnMida/cW2QUeUeBzBjGhXfa5SDtaHuLAsh0HI3gnZC9rqZFprvflDLRC1T1qao5pJtZhMvTd8QylC2ZKvFlgiW5BsNhANHu8yGRJ7ZbxBVvOyFG4h/QPAXKPJz1OkbX6bE2yaRUPYnyuKT9rPbhb1edr0S9Ir/1WlrWUiRdVEKXJ9TRR0qyMrrEVLW501bz9Pk4XwuLqBVKlbuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyRNGyGCHiPad5npVByWsekv9IvC7dBHM4x3YdxLtwI=;
 b=AdtHILcNt5LzWPAulLYp53YPwxuecIxweolbXqMy9v7vDJElzLTQar3OjN/zdBXWp1PAyvFHkhczxEwXcl3Z/Bd45DSgotlVDA/Z2Xg5aFJzs0iSB7dfRaCQ/Z+KCdK0C4g0EMVLPhTF7bv7U/u9EOL0aEznHkW/z+uQ7BH4ABTmzFbC5B/MLSVbBTdf04NVKb1WIzsF/4woC3YAYmBtMArThQNITGv9n4x0iiSRW29E6hOshQI7swTbbmGgDEVREuWH8i9egUELba0FWRRzVSSqumkJ9qS9+TRlCKv+JHp9CkfboMdZyzXjNUB0uHNe3W4wZRZb3omi2X+JVp5aeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyRNGyGCHiPad5npVByWsekv9IvC7dBHM4x3YdxLtwI=;
 b=Svg88jPpXcWJrDGLtGLLzOnVhbwSH14bKtItNQb7EGZ4n1jdqWp4/h+NyXZe1BQZblv6ssaZViLbuZc1ElzBBjlW2Sx145gATSc1svxB3/c76jOX7GHD7sV0EPohuFoXqggfzM0YurBPT59o4XRkGvUX9oJv3YUdTmk+9+0Xizs=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6568.namprd04.prod.outlook.com (2603:10b6:a03:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 08:40:39 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 08:40:39 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>,
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 0/9] introduce the log_issue_time option
Thread-Topic: [PATCH 0/9] introduce the log_issue_time option
Thread-Index: AQHa+E/8LhKYUZlW1EKtCrvYIT0Mw7I86KaAgACEKoCAAIDQgA==
Date: Thu, 29 Aug 2024 08:40:39 +0000
Message-ID: <b3zxz2f3amxd57h4icu3jl4ahheqxbckxuc2b6ywe4sqzw4a3n@5z3uzfz3umvh>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <d056a445-52c3-4407-b792-fdd2b6be204e@kernel.dk>
 <696d408a-b36d-4648-8eb4-93384cf2d65f@kernel.org>
In-Reply-To: <696d408a-b36d-4648-8eb4-93384cf2d65f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6568:EE_
x-ms-office365-filtering-correlation-id: fa456e9f-2ed5-448a-936d-08dcc80642e1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?bwNrPL+qlsIZPDtJql7/fxlS4HVs29v5NY24YoAVdVrEz7Qn7wOLHhuQcUkT?=
 =?us-ascii?Q?r5fD0xWKeS5JwqfYBgFfTbkxoDKGfninB9rVjQ+NpPKme7fSnBDPFEmFG+CS?=
 =?us-ascii?Q?F0ia8DYiqULhKoyTtw6GVlUoNPX1lXDujnJNtrq4b9+OC4AfSzKg5Q1/QPUY?=
 =?us-ascii?Q?VXmnpjOifIe9RjIg6YMc4lN9v557JqUK8amUSemt0uqsj/sZB/mvbnQCtH4A?=
 =?us-ascii?Q?UK7IkUw2pBBOCZjKaQKXKivfn2D5ku7sO4N6k1WMO0B6XWT48/92TYjO3yes?=
 =?us-ascii?Q?E7qww0upuwiFnCzf57uA0nzlsz4W2S8eLk6DQTOMbCcWZPmknyjVE+IWsO14?=
 =?us-ascii?Q?6MtLNHGhPaKDHryV58iWiDhMY3X8Nu+MFm6mwI+4K0JkLxgCqGWZDvzHpR4s?=
 =?us-ascii?Q?EtVhnfTE+NDw2RzYxnbIdyxfGzZYMrvpJD0pneRTB28Kl1cSLIow0elUg82N?=
 =?us-ascii?Q?uCFCRB4lH/C6RBNTlGGyDTv33V8IGqklUCFWAWA4DBWyVbHzY8vuAfdtnEKH?=
 =?us-ascii?Q?6iWiWpdgGhwNZwboyqJDw/rJFCsIpIq/9xdhBRWGfW3a4QHX35H2pJttJF+B?=
 =?us-ascii?Q?HCdocJ9pPBwIQluidzkxoAlrTspErLDkDGRXtagjymrgb2smuk46FsALblY7?=
 =?us-ascii?Q?V1srj2BLz4FIkhZgCOkZNG1+tv4Vt1X+81lHV41Qgw7sdrrgCfXoeNoOjtN2?=
 =?us-ascii?Q?KTt0luPZxINH9GGnqqR704nZ0Iz0BnYi0vW6cQp82FmjyO63FATwxb+pIzmR?=
 =?us-ascii?Q?s1nIw/w0R55Ar9SBCtt9ZxpjQm/gfemQkdcwVF/zqxttzlwlMEsJbUA/jM4t?=
 =?us-ascii?Q?LY8kXfVNclFp1OF2ltQKZhInK3TRFI5vrSb4pjFf0re7cZMtRqyOXYiMCDkD?=
 =?us-ascii?Q?t0xterR9r/YJCa8RRKlIbzh53Lg1KewgtDfNhWoVjsTEJF7NBdNdkB+lERbu?=
 =?us-ascii?Q?dNeJmRiRa6KGbG3ztGxWgwP7C7/QLP9CdyjZ1JPRr4yJCQKzC/fNLHVBvqAf?=
 =?us-ascii?Q?ZveAJNSOui5pjWAyK6CNRGFKBKVz9tZoW3rzrNrT0tNaewF67UjAUPNT5+4P?=
 =?us-ascii?Q?qwgZTLFqLSoGFm/+URtZG/cu4TIzYHEGdbxHT9ozaUv1lRX2WpX/9w04bV2r?=
 =?us-ascii?Q?NmVU96e7B4KDzag/ZBHQpBfj7ruygoWvva6p9Nbmqaq3hIbNinOG2ILhIDFL?=
 =?us-ascii?Q?T2I9/9N/hrM+4zcrWutUksKfkJkpY1rDghO39d+z/WmRHy9qgRoTXU+k9S+j?=
 =?us-ascii?Q?ipikudGUzhCG/KctuTxZxalrV0kNlBx87kRVlw3Y57rqUN94B7eth8lyVDdv?=
 =?us-ascii?Q?ZIFFps1Q2TTNbHlIINuFTj5r1An9Y53//zgLKNtu68fI+DtvxXHngxtbck78?=
 =?us-ascii?Q?kFaMOlwJwJFcrTuEPlILzG8w70YF4yBR9YGoLEUOiOUPopl7Gw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?558LHXPjYvEFgO2+/zlJ7W8vW28yi2NUYU+w0tdq7hIqro2+rOGQOmKAezOl?=
 =?us-ascii?Q?0QJRHtwPuFpXozdOknRX8yZWvRuh/l1zrlqBQLVGhmmr82xAXKZYeawkHzLl?=
 =?us-ascii?Q?bmwjBnfTT0L9y5dKNsrVEWEK3Y9VHQ41aLll+14hItQ+95bGzYaIjnlFBH6z?=
 =?us-ascii?Q?XLCH97GefiKrBAIVw+hFQzvDWRINsBpInG/j93W/kH1agwehBIwf1/599dbU?=
 =?us-ascii?Q?LJR8iFuNN0H43ZWnRHRsLQZpyGbDqkTMud5AhD/tSJPnxULNFBSd7nXmKq6w?=
 =?us-ascii?Q?uZc2+L2nDo677L7fynx207WYPaP0xdiVRq2IFC1cRpTbQ7WzsWUVE6tv7BEi?=
 =?us-ascii?Q?+RxlRK5rEf3TUmj1cLvvdAUuToaeI11rdPRbYjT0DVFgg7Ekje1T+WpAHrix?=
 =?us-ascii?Q?57jrQKqbIMmbOQMEf9Z3xQ4I5nEcfVZANpPIMa6RlalnYJVOrOXHmIvs29tN?=
 =?us-ascii?Q?1q16bCu3GF+ZR9s8t3Q1waE33BxqKUhWGH1zs6I5B8ZikcOYVb7p2Xoq//ju?=
 =?us-ascii?Q?t2fktD3CLWrMkIwoYbNdBnrsehGhDueXD8kR/EHJ5kW5fgEzAtvB3ZitF9ou?=
 =?us-ascii?Q?WKNdadzPcDq1xyVFzh3T8KeQZWvpU8UxBasf8z5520ILvbmPsZeB0LfqakWV?=
 =?us-ascii?Q?XTiLz1EKNJjYbvlUzbAEIeCnneIoQZ60uEynG7YMHiGvPA2DjgXCpSAgv8V3?=
 =?us-ascii?Q?uKd77ShbNzkJ625WqLlURKqiM2X9sjX7ulKcRAyrrw1C/3QKBLoPK/rS7S3f?=
 =?us-ascii?Q?a+1bqYZax/kEE5pW5Nz537mKqdi1+n5Itjp4ES7oS4kz9JWvaNbIOFVhfWUf?=
 =?us-ascii?Q?GxvwVvNf08EIgs/3Usfls/DBDnFDYZQGXo5S59t8s3OU7x5kXVvhAUlB0GBt?=
 =?us-ascii?Q?0xS8TXvO3YD+x/jUsLZthJHHmPefM6qbPkMgQGi6ZL8hVcjVwiQ7NP4WG1Ls?=
 =?us-ascii?Q?kxzgjPoE1LuDbviyW5nLwN35DCAeLOifDubCwck/TsAqO7yDqFm4Y8kAt8Q6?=
 =?us-ascii?Q?5jctWqnUMM974rlKnJmD9uYInkv4dscfTJzJJKbWtiAjGKT0A5r98Qqu5RNi?=
 =?us-ascii?Q?jJoC81dwFfgEHHkm9DERbVrJPZvk6cPODFEHlx4mtMPWxQeWwGudrsuHySDL?=
 =?us-ascii?Q?9GA8L3l/0JKTlBVmeanjJ/feO3DCGEezvjwM1X6leSc27z/azFvmgKza/Qw/?=
 =?us-ascii?Q?Ib6VBTVoP0jMvmritgZMdLgQLotkhMKSDw93kh4pjFg1t43AEY6/o91jxodu?=
 =?us-ascii?Q?FBU4u/VK9t0vrl+ID+o/KzNSHjJdL7vN1YpMo+xg2UbhitrSmpjILN6gbFp0?=
 =?us-ascii?Q?3WkfZXsLDaqW1pDs3qrTJ6XtRw9mFF6o+/vM7h7Jr3r0tpnibam39EKUv+93?=
 =?us-ascii?Q?IyJ7XXk6POWKRKdWv/SIrKtFy/PdWm/8zm2wqmMuBdBugHJejJT9XrGxc9k2?=
 =?us-ascii?Q?K6olDi9ZGNL5cFfIuSEOs0PI617sxA2u9Oz2gs3hlNt9VMtWRDANd2nok4BX?=
 =?us-ascii?Q?4LzIlvZyKTuv8b2QV+4tCpFwlietOazWjR0w8HdOBY3tjeE6eYgqk8HEsbTa?=
 =?us-ascii?Q?uBnhPFRAt6EFYc5g4CHri7ey3u9w3O6tCWKBrKEi9ufKgQaIUX+CGZ+YsrIX?=
 =?us-ascii?Q?PTPSwOb1eR2VzxHijlIU2NE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40B4D6AC11533248A9B5870299898FE8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bbWyb2RNYvR1LHBVUl9Mgf1k7qRwuTXLunsKxnj3s8KJQJFmuddYV0uO+2WRLbOaqpQ8l7olF4wWHkUI+0pgSpoR7bGGHuBp/Jq8GqLe0I7mo3HySR440orC5fHYjYN1o7InG6AoNf3c890HUddKgY0EKcxrLWsfMTFNByutHcGMaTRHkq3Kq34pm+rdSfKuhSXhbnXopuN1Doxkr70GdxKz4qbw8VdMD80OKo7fpRxZk8JIZJa8GeZqz0hNOejpQBg5sATrRaarMOxGKvLsWLr/H+eojbCQM4ZVogB2NsZ76RYB7//45fILQNKnf56CayIfI0SFR9dr3t8js4iKkc6h4uinU6w61ScTD85zt1+YeeZ1Gt6jXqtMKwII6bLAvx+G058oU9uhNHBM/AzkzOEjeHomzDejHl9/glKRtMo6p9WLBLd++v9NjPKaPnfO6hTGjU79I5mydcc/ijW248QR4I/Uq/paU/TUvAUQvcIcPB8NCHrvEHC8DeQJGxbEpI5KiPsUBLFhjtZs7UgHeiO4QTvYRTJaceTCPPnIadGHNgELoto5vqnDQiiXdt1RYYgUcvFpoydXym41gylNwsVsZ721abm3guaQMEYgcsrGgCpI4TAoev+3j4Hch8Bv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa456e9f-2ed5-448a-936d-08dcc80642e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 08:40:39.7114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3tO7YdJOyUXp9LSBV9xDLZ5tQ65kYw1kJEwpaV/2Oc+JJ2pBqBp87cL/5hw6whyHoAUr69asW3U0czPGTVZ/BLCiykhPcWx9A/Au1nu2slU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6568

On Aug 29, 2024 / 09:59, Damien Le Moal wrote:
> On 8/29/24 02:06, Jens Axboe wrote:
> > On 8/27/24 1:08 AM, Shin'ichiro Kawasaki wrote:
> >> When write_lat_log option is set, fio outputs the 'clat' completion
> >> latency log file. This clat log can be used to analyze IO latency. Thi=
s
> >> file can also be considered as an IO trace file as each IO entry can
> >> fully describe an IO when the --log_offset and --log_prio options are
> >> also used. However, using the clat log file as an IO trace is inaccura=
te
> >> because the time field of each entry uses millisecond units, which is
> >> too coarse for fast IOs (e.g. when using SSDs). This series proposes t=
he
> >> new option 'log_issue_time' to address the inaccuracy problem. When th=
is
> >> option is set, fio adds another field to the log file entries to log a=
n
> >> IO issuing time in nanoseconds.
> >>
> >> The first four patches in the series clean up the current code as
> >> preparation. The 5th patch introduces the 'log_issue_time' option. The
> >> following two patches document the new option. The last two patches ad=
d
> >> two test cases to check the log file format.
> >=20
> > In general this looks fine, and I think it's a useful feature. However,
> > should we have an option to make the generic time in the log entry be
> > in nsec as well?
>=20
> I am not sure if it is that useful given that the entry time field does n=
ot
> directly correspond to any I/O time.

I noted it in the commit message of the 5th patch, but did not in this cove=
r
letter (sorry). Quote from the 5th patch commit message:

    However, using the clat log file as an IO trace is inaccuate due to two
    reasons. Firstly, the time field of each entry uses millisecond units,
    which is too coarse for fast IOs (e.g. when using SSDs). Secondly, the
    time field value is recorded not at command completion, but at log
    sample recording. The time field value is slightly different from the I=
O
    completion time. It can be used only as an approximated completion time=
.

That's why we propose to add the new field for the command issue time, inst=
ead
of the log entry in nsec.

> But to be consistent with the other time
> fields, I may be good to add this option. That is easy to do.
>=20
> --=20
> Damien Le Moal
> Western Digital Research
> =
