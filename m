Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793903687;
	b=XUxAVUeAlByHTcIiOjcOmvIfj2rd7C1xkSqFoJQ6MArI9ndYcLVJXJPiBHdQF1aem00g
	 /kydKjjzTexGaAIl9k4n9iYFxal2E45dyGXay0QbfG02KH1zx+l/NxMbjQ+FvtHgdluqX
	 ZErMCp98ciO+ji7gmNV9BGyaVGv2Pd4d9D0MhlWtxXVoMNqFjcZ6uq3o3jpEnG0HxEamm
	 cRgQqxY/eycZsyfF9neNbcq/5w/PtN+W+k7tM/zrIdWQ9oWy7mRSA8uEkT+rXeki/sxBL
	 VF9WS+wxtofbjmESAAhTCEPl2V+OfCjFGMEYjjxWoxej/Ylo807J1KbQiBK7lsB5z4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903687;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:wdcipoutbound:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
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
	bh=ZVeeAmnUQc1ej0R66yDhYDUINrrWNjegwNKC/ebK1WQ=;
	b=aKz0lgcLRNhmZl54DOrcCQGWBpbZOBAU4aMDK0SA/r4pkhui6WY/B7XkKPHVG/OU100k
	 v7wCR2vsJjFIW7IuAaYW6US6wtgSbwJAB5pE4Oz5J7SajASs3mfWjK/CsftTzqsYiVeEe
	 QKLEFXEKsq2x3QOCyghEoOGN1NalEUzjQnrLpH0ddL6yf/nfz9ZFU6YgMdZcUumFHqg1p
	 9TuEf5v9dwOPGbChBqW4faDTUDHAH2f/hjWcapVOoPn9Tiyeb7VLlmzSCfxKGFAhsIwn/
	 vld3T8q23iZ9KwJgkMsifNI5wzK6Eq5055OVcUbSgShdPDqMpaU0KIyfsp1ETvKn3nw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=S8Rj7dIS;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=i4AxwTwX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30753606A31B
	for <fio@vger.kernel.org>; Thu,  5 Nov 2026 18:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30753606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=S8Rj7dIS;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=i4AxwTwX
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793903693; x=1825439693;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ZVeeAmnUQc1ej0R66yDhYDUINrrWNjegwNKC/ebK1WQ=;
  b=S8Rj7dISMeOkXnlu62R4S2+npLFj7RuBJiMy1CFCo3aEZkw0cpO6pw9o
   B3eWAY+KQayy4aGlo0gkF+LN9P4z4i41ay6l5gIxxzzFovqsRdwqQwF2N
   zFQA7L9wCPx5fCrW15w8ns7WfzmTksXl8GN/N7s0H7pWbbvZagZ9VqsfF
   nwkFjzCVPEjO01ZoB0a2C8FeyjyGzOJ+eiNrpCgNeuGMIKo5yWWxIkw5p
   qNPdDnjab7LQ+q5ipXvRNcNa45P9mdZYHqxC6f6zibgiIIPZN1a62Jo45
   fFYQm0ku3VREdXbiy2zIkr6XlLE/uaKaJlxE3G9W8V6EayzDzWeTRfb9T
   w==;
X-CSE-ConnectionGUID: LTHfM4OWTBuP6Ms4Y1jxag==
X-CSE-MsgGUID: bsJqbCXeSQyNEHRSLdyL6g==
X-IronPort-AV: E=Sophos;i="6.27,197,1786982400"; 
   d="scan'208";a="159917348"
Received: from mail-eastusazon11012025.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Nov 2026 02:34:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FaysBG37uUjUAAaUxjs5f/FaCcjcudwVE/CQ45WdquQGN0HJLEbwb0nq/Fj76TejF77gt+XkSA4OPkauU4FcFNy12yC0DuerDwI8Yxjc/EDvuG8Ty49mAmVPX+p6QSUrvyDuUD+bDkKoajkE+JBe2v7Kde4oNrEXGWIZ7NM2dXsDngQCqHPTok78lvUh6a9zgIIQTyRSiQ+uY6TDSaswsobTVGTh840yNM6hbKNH2NPzuynhNh28emxpxpgzZZyXpxCt3xJ7nTLfGoOIjGuUIWIw7QenLCbujmf/GLZuMFQXDzPesCMe4WOEnW/HioiS8mW4lSiBkrrCRSUQiHyUzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVeeAmnUQc1ej0R66yDhYDUINrrWNjegwNKC/ebK1WQ=;
 b=rtr22Pq5bCsCw+y2ZEwT4eUnyHMw2gADcowGVY+M78BsdNtQsXM1Ukx1oxWqRPjL89aW2bSdD4PaotLwsYCOOllOURxs2hqp3T1Ekhivm+GGey32B2y3R4Se/yHCngR5lopHoB/PgbEz3tvr6oQU0WEkjps/Pt/JMVlXaEzQuaEj4gYlEMLqFFTUNrm0yCamFV+QSqq0eih1ZBIqo45NtWGXg7zWrKSRH/6lKFJf3wlvlgQV++yWOI+iIcHHghknDKcfaNXPGQPQs9cvhgP4zFzuh+sAsNEnD4pPPxF8CQG3bplFh2dBZ/h0seRT3WTYoVK8oIoRsjEsrHfst0yxmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVeeAmnUQc1ej0R66yDhYDUINrrWNjegwNKC/ebK1WQ=;
 b=i4AxwTwXe65vkD4YLN4tN5ZYv2gtRWdgnPVutxoBoP2X/zPuGk6Zj6zOgrAqik1rVw8HBZovDmAhUYpb5U/51bi3qNYZWJ/dJUriCzmu4e4DJQIJfdLyHmiV3Nu/Alx3JnQ6nZ5R41mflWZZ7Bgb8nN5fSqIKeIgrKD8IQPF6T4=
Received: from PH8PR04MB994107.namprd04.prod.outlook.com
 (2603:10b6:510:704::21) by MN2PR04MB7102.namprd04.prod.outlook.com
 (2603:10b6:208:1eb::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.27; Thu, 5 Nov
 2026 18:34:43 +0000
Received: from PH8PR04MB994107.namprd04.prod.outlook.com
 ([fe80::decb:19a9:b964:825d]) by PH8PR04MB994107.namprd04.prod.outlook.com
 ([fe80::decb:19a9:b964:825d%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 18:34:41 +0000
From: Siriporn Swart <Siriporn.Swart@wdc.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
CC: Siriporn Swart <Siriporn.Swart@wdc.com>, Jon Whittaker
	<jonathan.whittaker@wdc.com>
Subject: fio Write Workload with Verify Enabled Aborts with inflight_issued
 When Write Error Occurs at Runtime Start
Thread-Topic: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
Thread-Index: AQHdbVLY9jozLnKT4keAHV+sEWtQIQ==
Date: Thu, 5 Nov 2026 18:34:41 +0000
Message-ID:
 <PH8PR04MB994107D250DB2434D563DC57E88A772@PH8PR04MB994107.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR04MB994107:EE_|MN2PR04MB7102:EE_
x-ms-office365-filtering-correlation-id: c7522578-f3af-4190-6361-08df3b6b74b4
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|376014|261021123027099003|261022105027099003|261022075727099003|261028144727099003|38070700021|261026121527099003|261026140227099003|11063799006|10067099003|56012099006|18002099003;
x-microsoft-antispam-message-info:
 exhu0iaS9+TdsAeCoIpZKDCGsQKLd/sCUSB18PSIk9HFOCDnNF95EBuhZU8mZt3NRUIV+nJw/WY4gWqUiJka1hQMq6qJ1bpvICuSIU26LjBNlPrc7MgsQZ51mIeo9rVs+PLsHdtBgVNgFoOX5j1GE/LCXX+gPfoW8RJ3RWvTL3AVEogA9yO88Noa7FNn5XyYk/wLnK2FJkLw5yw5vNMfEM3X/Mut7/il2Hmpc+rjcduN+8aQ6C5AVOq+WBByVFDDXH4/cMdxfZV387YTUSZlq2TyEMp0rhwfVVuyBNYFKYNsqqsz3mxvxHckCN4qdh1W4TWDCQemovw/6oskaAOoGcFXaei6UtrepGHHoJMJ6Y8kPgwxLu3t5rzbWWNsTkQvPpjdGEh3ZXvJ/pHmNwEF0Tcm/jKw/T4VahTNhEKYWe5+7zUjy5muPKRA8H6OQUtNj4v6YDM0klhqHTA//9scluR1ZYTit8GhXpSGwS2onBVRStIhLMJVd5i6H700QeLvPNJRoUOEoXFy5z6MKmAva5PiKACrSkdkyeqRV+/SaoeEv9hJGItyR9dNEunKiUtq+7gXZ+hWfPPJIC+Ui2uLKIc2mRlLnkyKRcaIP8agOG54EPcoVOfX1y1VNi+hJPvfn3Wt/NJX9ZyD9b+XmigEcAf/ZV8zyXOVyZKBm/kf6woHNhVtzT6uOcoek1yWgs1SeSoRboXpIWhbiX51KLaipNEHh8OagH21UjF0pz0Xpps=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR04MB994107.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(376014)(261021123027099003)(261022105027099003)(261022075727099003)(261028144727099003)(38070700021)(261026121527099003)(261026140227099003)(11063799006)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?B8DmTGlN3SNnqLKXku8YOd04IuV3k56sE9L48i3xuI3O+NonjeYhJ7w93B?=
 =?iso-8859-1?Q?NJOWXUF1cUNYl9BkciMwbq/HTgzWioorPTLEk0dQqCXvNX471DJS5OoDRq?=
 =?iso-8859-1?Q?6U+QHHs6CM27rb4ydkDBihpmKmC8NjXybWLQF+UN19krN2YOOsAd6OOtMQ?=
 =?iso-8859-1?Q?uGtUe6nKVCGiT1ZL3JOniVNkQkf4PYiFvtJB1FrkpbCHGsyAqLiTWKbEia?=
 =?iso-8859-1?Q?iVwpCz9NO7LhRbQ3lS46iI0BHXU/O+QtjmxmcADImnUwHiXi8xT9qUXbrU?=
 =?iso-8859-1?Q?ydFDprCP1sSxNxZgBXM6su0MEBP9PziO8CMvQ0vTD+FqlzRXyM2wP6QQnB?=
 =?iso-8859-1?Q?68rmEg8TJzwls0HVxDDnj3ElE6RgpbC1JmIP0Nn5gL9NA8KFlEG8ZITbzU?=
 =?iso-8859-1?Q?3CyN4QF9SM4p7blgQL5OSFXIcVHCvo5BY/XUHZr8UKbSqHnyaVJNG7gcc/?=
 =?iso-8859-1?Q?2sO2creXO9B9BBGeqCqP7Refk8UHvgouYTE4LDUqRLNS+2MgQJsRgiJqKa?=
 =?iso-8859-1?Q?mEq1wrDZFgHOqQm+7pdoSWeLeX7xn4f9sWriiyvArWqlxoek58SAVKMtty?=
 =?iso-8859-1?Q?50oDntD4SShRv4uK8DrfaE9/Bn2xi1rwAfS7lyXKmss+iGYCVFLe/EL0nf?=
 =?iso-8859-1?Q?5sU/a9WxV5BCsggb96QQNKLepCjx8n6LY6Skd063oGVatBBE+IBOu8cTYY?=
 =?iso-8859-1?Q?RN2ksou09WfrFxPgZ5/H6U38qFMJmHZ5u0OzUF9iHdXL60XScIe3YxIY/u?=
 =?iso-8859-1?Q?TnJ1XteS/7XmCdpJHN2KhE27sP8TMOjhlD+lqxlDcMADaP7RCVO46cWVSe?=
 =?iso-8859-1?Q?dHDRBJPwF3dEI92oa9T6RKju0IvSi884kuNtiFuQf/YW6+C6V46ZDG1tum?=
 =?iso-8859-1?Q?L3gficVWbnEzxcQcjRxwap6Y73Ak9B6wqGUAWlw7kSnQUT6MJYB2Odl2VP?=
 =?iso-8859-1?Q?5dSR8TCOyzIvwNeuFtcapeKCLWt5qb7EQHtTDsSF+1X7KprCVh9hbIIebv?=
 =?iso-8859-1?Q?FE23kvUJh5w0WaXv4ANez82tLiBQTAqZgi+0KDoS8q2OPeaEQrSnHTeJsH?=
 =?iso-8859-1?Q?B9niXFTrVFbKZ1rzwcfD0g/ZNqo/RwWo8TijYkz3mnX5iGkABkDiAG1Krv?=
 =?iso-8859-1?Q?A0DBgdMmoGDsY9c0UeUoL/mPN2wCwv4yIhlJxKCabtQvz3ST0tdgUIhUjy?=
 =?iso-8859-1?Q?FoZgfUQl3zIpRYpOFEBwsymvY5j/n3coQXfnxhmpFdUG9oC35kAl1L9ixO?=
 =?iso-8859-1?Q?JtDrJRGT87byYEDZobEmPhprwwqeQmmILD0+iL9BDATv2CWAq/FT7hxFox?=
 =?iso-8859-1?Q?lpUt3OJOywLpUqz493ANsbO1Ondx3IHwViF41FK9S74GVrOMC3yGFCVzCW?=
 =?iso-8859-1?Q?ilSuz/+zZiPwsIHFkT8My3kfiGinNptjkF8uL+i1GWkt23o6a6pkqoXATg?=
 =?iso-8859-1?Q?NubIwZPYEDQS5dnbFX0ZAB60haVf9pZ1q6EbMWfS17wsjHXX72q6SF1dyx?=
 =?iso-8859-1?Q?DJ7CZZeHDzBqlyPbTExbZFF23SRqshSpOwA05LfrkZh+l31EjV93vSlooE?=
 =?iso-8859-1?Q?qglasrhwlmqpCPrrccognal9RwY9oVoEsDw8Hf53v8S78EVwh0Y3kZhiRy?=
 =?iso-8859-1?Q?Jgwsg3umJ7dzHIV0RtaCzgRTlFfjN5zxDC9yd2pPQZfzlfoWbl6g3O7zDP?=
 =?iso-8859-1?Q?qOVQDtNwZv5aIoj2A1CljtnGDCpgkdg70mrpBXOW7nEVIPVsRyI27VvDFz?=
 =?iso-8859-1?Q?v5OO9cTvsrIS0TxfObf8QjLogI4dT0qFy38zyBkd0LrTDC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
	yvvsIP+plngS+z1c+yGmEuNNeb0NNAL5nT8kFNn/M+Nhbaq9RRXYZ2YoQXZJHJ4WQ7baTR/MJLJaJEUxAh13gkYoZ/Ai7CHtsumGutjMnhXkQKU53dR4lUmF0UN36C+vHWWUsftyxRni67/tdWk0UvglcbvAPdD9+hayjtAYkVmEfLgNMNb9mIGcccB4NgLimK1EQB6UK47bSZIIYgd256arAGzrfPkVCoM1a6hTrlwmXtgVYQyln+So+W9+2bDYqrYM/Yqy6jH9ocKD+5wghktPCClgoRsH3AgV2cR6kgOvKEYThWgDbwp2x4f8MWw6vJTZhIG9TdTRCLQ+EK9OvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ONu0gfHdSMwuFvj/EuAD54uyAS81szTl5rg7+vqzMtvpx5wC42/Z+aWJ3903CS+45ZA1NqaQPFQVhChZFkZ2Dy1BIxFSmDjpIWajjP1D8MezSvtKL5sypmXF4R/co7BhQ2hXFdUDzZypQ9X6Smp/FbLMSSU1gxSU4JTgtlXUdge6Ri5u8LTcgQcA7MROr53J0bxSOAV40hXbQCuEiuFMgYd5WV87ImS2K+C0YPCxTRLrXuIXttDTtFOf47uSwNMp7KVSl8C1sHwONalsCJoeX3wc1rpiIRiU3y/eNl7DIRZF9qDLC/q5oaO+xY3eQOabdUNifE6ciE0WG03UFW3YjWty0rMLB09bAuYx1n8zXXt8/IlUz3IdAsxGc05oR2/p3+xMuJpweBclAMlgKhFuMMfDRjOTdcqGfQlEruIH6Py0GP5imgeef3wFzUsKbeGL5LSP41xEM+d/1Vn8GyFje/FcAmWxwykSvE6pYcT24h77MaGDMfNYOpY2MqllnysnZn1bL68flos1fdh95Ak73ziR/mhyITSG1MITTtgr+9FoKrqhlZl8Pg2HXN0Kykc3QgO7cXUl47x2hepSSDee49EEtEl/lu2urrl3R97M/xw2EMdkIiGw+n4diC57qt8m
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR04MB994107.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7522578-f3af-4190-6361-08df3b6b74b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 18:34:41.5153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +R/PZxBxXnIpKwkFYelq1SukU3gDuk3QtAVkGz9+2+vx5PUbL9al/6I7k9fape/JcntF1/N08ylMShnZBX6WFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7102

Hello,=0A=
We observed a problem in fio versions 3.41 and later and would like to repo=
rt the issue.=0A=
=0A=
=0A=
Summary: fio v3.41+ verify-enabled write workload aborts with inflight_issu=
ed when a write error occurs shortly after runtime start.=0A=
Regression: =A0The issue is not present in fio 3.39 or 3.40 but is reproduc=
ible in fio 3.41 and later versions.=0A=
Environment: Windows (windowsaio) =A0and Linux (libaio)=0A=
=0A=
Error message:=0A=
<Windows>=0A=
c:\>fio .\random_1_4k_0%_fio_job_file.fio=0A=
fio_getaffinity: pid 14376 is associated with 2 process groups=0A=
4k_randwrite_1: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-40=
96B, (T) 4096B-4096B, ioengine=3Dwindowsaio, iodepth=3D1=0A=
fio-3.43=0A=
Starting 1 thread=0A=
Jobs: 1 (f=3D0): [/(1)][-.-%][etainflight_issued does not match: numberio=
=3D0, inflight_issued=3D7109=0A=
=0A=
<Fedora>=0A=
[jon@111-perf-jrw ~]$ sudo fio linux_4kb_randwrite.fio=0A=
4k_randwrite_1: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-40=
96B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1=0A=
fio-3.43=0A=
Starting 1 thread=0A=
inflight_issued does not match: numberio=3D0, inflight_issued=3D24377=0A=
Aborted =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sudo fio linux_4kb_randwrite=
.fio=0A=
=0A=
fio jobfile:=0A=
[global]=0A=
thread=3D1=0A=
rw=3Drandwrite=0A=
group_reporting=3D0=0A=
iodepth=3D1=0A=
verify=3Dcrc32c=0A=
runtime=3D120=0A=
ramp_time=3D10=0A=
ioengine=3Dlibaio # Windows use windowsaio=0A=
direct=3D1=0A=
=0A=
[4k_randwrite_1]=0A=
filename=3D/dev/sdb =A0# Windows use [\\.\PhysicalDrive4]\\.\PhysicalDrive4=
=0A=
offset=3D0%=0A=
rw=3Drandwrite=0A=
bs=3D4k=0A=
startdelay=3D1=0A=
norandommap=3D1=0A=
randrepeat=3D0=0A=
=0A=
Best Regards=0A=
Siriporn Swart=0A=
