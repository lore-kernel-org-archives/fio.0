Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2108.outbound.protection.outlook.com [40.92.22.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEBA42077
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 20:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.22.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836974; cv=fail; b=E8UnGR/zYBXj8Z4Ssk00/n3FqtIUJM6sftvLqXh4G+bTxLyli3/SjPIkYMziTCW2KE3Qinjucs5GOh9U54FmhJsig0Ov055WRFi6qC3hYWOKfjRvXz17jqgkB4u6vTYYf/FM2gfScHacA8ahnK6cnxBua5Bo9Nclwg6JzUb3E18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836974; c=relaxed/simple;
	bh=p/FvAdk03L9rBMVUzWb2aXln2L5qLYm0YPQmkhN3ujo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JDzIN+iOdTIB0SwQ+yJSk15mXTTsXrLR0sQwibPSDC074qXzWSvtOZqSgh9/23R4in46l+YSf7Ldn1Eo6V24WIgTEZhJWGoY+nTa/KHCDJ/jAgUgZhQA1FbkkQohC6X3EhIFffuTxg0h/P4BX+KZgTy3ovGKg8POXNagVMbMrSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=FgsjpOWE; arc=fail smtp.client-ip=40.92.22.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="FgsjpOWE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w8BE164niT2zVjcHPloFy6zaeGR5778z+A/ctuVaOWJv02Ot9ZacBLuvsP9kALxv5xyXNT3Pa+mq10Kl8Vnc8FraKQMNoqcG//RQeujL3uVyQVe4eCNXJCuCyB3zMrEJMiC679IRsc2ozY1f/BctD+KjMpGmjVZ1m0DL9hOFPwG+ENEZ7gO+In1RmMRLq4AzQMjQgb2DmIwgkHIXv0hdpKTlzaGHT40vdQpSk2UcnDVuMQT1R9YJLvG9HbmxAzcxukYh+3ikakTBb3rd+JS6jgAelNllRw2U3HNQJJQicG0HzZ5khJtE/ArY3NPvPp9riP5nfUJPdTwpdWzt2PE35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/FvAdk03L9rBMVUzWb2aXln2L5qLYm0YPQmkhN3ujo=;
 b=dCAOuFmwp9sVpe1tUdTPm3+ooRh+shdxjaecMeygx7YhyGt2yWx7hKeyfBNKnFa38IYdSU0xn95d8xLI3VEIXIcZHHtr4jv5UrEBCLZM/6mU/NIaW1aI2Lf/ZGqb1kaIQhw082q5x4TzjonxvgNvdxVi6mHWu7spyZKhZzB28nye33uKDpwe5tawhWYdNAvnnPHA8EAXzJW2b5nPEfrYbSW6O5N/b/Qqa3pBog+U6H9KTPEj4QiUAQzhlJHloxzoVV2GRuWMqfkGXe4vQdabobRZF4UTMqwaLF31lEOhcbVjqwtYUihYoq9xnrw37s04yNR/JE5u1Q3MWruJfz1r8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/FvAdk03L9rBMVUzWb2aXln2L5qLYm0YPQmkhN3ujo=;
 b=FgsjpOWE4aGWbswRwUm2rplhIZ+/d4m1SaQDMr4LMpj+UPwuxkdJMgtdzLC1hxCbI1XovlE+FMnZo075M3ypk1Tm5PVMY9ZgFJ0ohxo6q8KLVVQtQShx6pF/LC8xVkas47N+2M8rVo/59OJn0NwzMTxNn0zaG63gzgRWOPgksB6Ji9EgxujvDtNlNwdXKJQJvpQ2puViKdrO4muFuJCFcn6zvhfkuLRbonoNw39pRC4ajnnvDntYVad795njBYS7jj32j+ROVBdklIMfl2efjsv3ARhn/c31VZGjCY48jmFoonn9cXXBLBBMnr9v0OjBCKIyhqyneDuiNNw/gV4okQ==
Received: from PH7PR14MB7419.namprd14.prod.outlook.com (2603:10b6:510:1b2::7)
 by PH8PR14MB7014.namprd14.prod.outlook.com (2603:10b6:510:259::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 20:02:50 +0000
Received: from PH7PR14MB7419.namprd14.prod.outlook.com
 ([fe80::da5a:a672:628:93c6]) by PH7PR14MB7419.namprd14.prod.outlook.com
 ([fe80::da5a:a672:628:93c6%6]) with mapi id 15.20.8114.031; Tue, 5 Nov 2024
 20:02:50 +0000
From: Adam Horshack <horshack@live.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: blog post on fio write zeroes performance
Thread-Topic: blog post on fio write zeroes performance
Thread-Index: AQHbL7qs6yd2FBsQoUOO1VkOXrrW87KpG5XU
Date: Tue, 5 Nov 2024 20:02:50 +0000
Message-ID:
 <PH7PR14MB74195A055EE5BF97F7054A32A4522@PH7PR14MB7419.namprd14.prod.outlook.com>
References: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
In-Reply-To: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR14MB7419:EE_|PH8PR14MB7014:EE_
x-ms-office365-filtering-correlation-id: 5e7ee754-18ac-4ea8-0372-08dcfdd4d399
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799006|15030799003|8062599003|7092599003|19110799003|461199028|8060799006|56899033|1602099012|10035399004|4302099013|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?/F6p+GkXAJWhM+2NfxnbDlcLD5LJS0CHQ/rjm9QmDBUkPbABL4MfGFrXlD?=
 =?iso-8859-1?Q?We/dQNJZHX5MAZ8LKn7W0rkI00jskZDS4kqoitNZkp8OeA0fy3NKQyCgvl?=
 =?iso-8859-1?Q?PovHXyLmeTuHk7NtV1+ny7mjJSb8//MGzlnhyT3rHls3R5sSyazSnYsdxQ?=
 =?iso-8859-1?Q?i2ysxw6W4rHY91ciZM+tn7MjwP6KlWyKKxPQrhuCLydVNoLeeBBo/wZc4q?=
 =?iso-8859-1?Q?AAxp8lQe0AkZycVJotLn9tWxnX4H54iWhzOaY2/AECcOrUUITuVdLG5AzG?=
 =?iso-8859-1?Q?07HwE4l43/CvifHOFH/y0JcaNWwtdvP+xeaIb72R59Vq2LqmyTZRZaceJE?=
 =?iso-8859-1?Q?hLBF64tCw+YozCyGQ/BeHS/7p663Lqh2l4KHHmsOrs+CKkfD87ub8lQ7aF?=
 =?iso-8859-1?Q?XdrTItS58oiQL5IMzMqNQKIw3Dk6R3DP00EIVesB8J2Neg7EqbaFN48l3v?=
 =?iso-8859-1?Q?Jhpw1S85rUMegXLyPzfJQ0tmO0f3Kxvx6D0hWR+bkn9txVBAo7jqK//ZwM?=
 =?iso-8859-1?Q?MvOPm7qECE+AScXkU4Dk9CAA3xmt+3wh9dhfNHQUM4dJiFqYPPQ/3m0UAQ?=
 =?iso-8859-1?Q?3PQd2TrhI16krYvTUSGMNd3Y91nGUftqFRXhNtmfdemLWKmlru3LhCvExd?=
 =?iso-8859-1?Q?rBs6aErULX5661vrVXDB+WuXRl+vSBspvqlSPX7l5E8GDEy/9gEVLuERL0?=
 =?iso-8859-1?Q?Sg1OfrZ6J3W9hJTDX2767wBd99BNxdcaDd57AMJnIl4Kr/j4aoLpZ3gN73?=
 =?iso-8859-1?Q?iuRYm1KDYqaXnINv9z3K+wJupFbfZGI9ptjP4f5ZNZqnSJPFaBSLZ6yl5O?=
 =?iso-8859-1?Q?ZSvuiuwsIDw8vzxmZsPAh/XRSiXwbiiuKB8bGjx1eQSmKqY+a/bPJvBfNm?=
 =?iso-8859-1?Q?SGInMMbpMgQ6uwljb7EBYUPZCDUxUXgHoBs0xwhhF+UqH3xseuDDlouutp?=
 =?iso-8859-1?Q?DKiny/6VnUDvy9ND8tK6P+JeRLwVACu+uCuFrpE+d+nqGjrV/FYivIUMtc?=
 =?iso-8859-1?Q?+wGyQ0kNEzNiknfqsp7LStc+1cAYwnXXlebTv622GhLNBPiQbiBxoX/kAx?=
 =?iso-8859-1?Q?gOMS7/vEA2RLHGjNiS94+Sikqa2Y+ib9acGUx74qLl/FnM62YwxFrpcWAJ?=
 =?iso-8859-1?Q?R+Tj3+N1JBZEEhg0adJR49doZy2fTk6o87FSF65LuKt3736NUGYIKYF2eS?=
 =?iso-8859-1?Q?xmK6Fe8oELuTs6H3k3vz8iu4VL6qX0113ghvPR2HwmfsovuIsDM4OW82?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?c8PiucPw9OkFjyereSJCwxvIOusHNYqZ5U/yPvZeXTmXHjEqlgZh5QWfgz?=
 =?iso-8859-1?Q?2MRMlMkmka5mQGSJX12twILhv5n0TupHCYxxD1dkEKn0pmGyNQQwCRubdA?=
 =?iso-8859-1?Q?8+2ryRxTpaIlgdUb3G46sr9iXcvVkkrR9IEijoEx0LsMaQN48fGZWHVw8C?=
 =?iso-8859-1?Q?muNwMCvOAi7Q3Hwk530ninUCBas5OnjWd68GQQd2rXFxBVdxAJXbakZgtb?=
 =?iso-8859-1?Q?wAhdSs9g4ZoICm55gIQCsSAiRzS9Gx/wDmnUBPM9+8Bqbli58q77Y4IEYz?=
 =?iso-8859-1?Q?4j20r+B3nxrJVAY4DG7IO0LG+o7qYBFhF/deFInkGkw0bAJr1M3QzzGtZH?=
 =?iso-8859-1?Q?eIH4fNElkuqodW/htkRW5SYjC6/KGRG2+bvtFaM6SD52ea+iblPazs4oRj?=
 =?iso-8859-1?Q?trh0TdjGf9dWEkGxxwfjrADEPd6hjpl9YH7He6AwocOxyUf5YDHo2kY/R2?=
 =?iso-8859-1?Q?tYw+xph8N34uA0jxYXZ8vPchnVHwFvNiYP7VorsggeSSvldpK/q8Xnpv5B?=
 =?iso-8859-1?Q?VMW5jfyy5cK10cjNRac5z2V+1SGukIUC65l+JhqgFukipIYjJPoEazkI5t?=
 =?iso-8859-1?Q?lB2waMeK+yahRp2W3iPsxIQjx5Sm90AEjq3IVkOcMZUBUAjkTB1fJhKH0U?=
 =?iso-8859-1?Q?3PdDpOA5ZBPpw5uJwraMq/3v2JFF1yiUM7NeIWfKKNnYK05D02HtI9H31z?=
 =?iso-8859-1?Q?/vUVbWsPqkC5aVh8Sn4+jitjM1QBndlkLIoIFpIQRvOF/xIMtKNojTY9V2?=
 =?iso-8859-1?Q?dTgdQU6eZxk2ZIrNsB4j93ybnu2SG1GzPHkpIXW45u/IsJ3sBYB3qwukfc?=
 =?iso-8859-1?Q?7tcfE+jms6T5Iq3mjY5zS5k8eu1IMgp5I7b9Hsmtwxq/zXdomuxyIo0g/J?=
 =?iso-8859-1?Q?sHpO8iNCHAgwexeoTMrHOdSY2ZGciI+Z2KBr2xj6qGkexphPL68M3tFoeS?=
 =?iso-8859-1?Q?/79zVJVoJ4hHUMliz3tEv6ecPdTryV1p72K/lf42unYRDdruT6i5tFRnpI?=
 =?iso-8859-1?Q?V6uEbAFd9fEZGJnaSYn9M1gTg/sdVHI6AVTtFiyK79DuRUAIQjBglZAuGZ?=
 =?iso-8859-1?Q?ReaUIEKJPiYKZlb9S3No5S+AK0RBeTLcBxuKh7oIMSXw86Bcz1ftghxFcl?=
 =?iso-8859-1?Q?Bk+OYYzmbmSkWelArJf1dDJUk8Fene52MRP6hABmo4GRoZDHjIW4aBebIT?=
 =?iso-8859-1?Q?6Q9Vn1E488HZSMfOKp5kuX/pPMnmPbZrOgm7D6TYrjdU6nVZkG3eibvZRd?=
 =?iso-8859-1?Q?KFS41E9vlukcY6dG2TvA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7719-19-msonline-outlook-e4812.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR14MB7419.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7ee754-18ac-4ea8-0372-08dcfdd4d399
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 20:02:50.4492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR14MB7014

Nice writeup Vincent. It's been a while since I've looked at the NVMe spec =
so perhaps I'm asking the wrong question but why is fio managing a data buf=
fer for its handling of the Write Zero command? I would've assumed there's =
no data payload associated with that NVMe command, thus nothing that should=
 even be subject to internal buffer scrambling inside fio.=0A=
=0A=
Regards,=0A=
=0A=
Adam=0A=
=0A=
=0A=
________________________________________=0A=
From: Vincent Fu <vincentfu@gmail.com>=0A=
Sent: Tuesday, November 5, 2024 2:41 PM=0A=
To: fio@vger.kernel.org=0A=
Cc: gost.dev@samsung.com=0A=
Subject: blog post on fio write zeroes performance=0A=
=0A=
I am pleased to share a blog post about fio write zeroes performance:=0A=
=0A=
https://github.com/vincentkfu/fio-blog/wiki/How-could-write-zeroes-performa=
nce-be-worse-at-higher-queue-depths=0A=
=0A=
Read about the unexpected performance issue we encountered. Feedback is=0A=
welcome.=0A=
=0A=
Vincent=0A=
=0A=
