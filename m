Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795466982;
	b=PgVMLCQxM020KuaqFwHpi6rpAPt3zkbGG7DyDPnlljMA4vwcdSOIDiZSU6CGweCZA3P1
	 XblC0ADbTAUNEKPTuVHyXI0xQifepMVQgGePROFjSYhoKeE8Chi1leyzv445NZ9Vetltu
	 PSam3ZmxVNEabt9jyL8JrS51Akr8pB0/02vzFx+ej4frSviqchCORGg5TxLhZuJ5GCFNp
	 w01vxdJgBLov68+hM0rUZwvK71xSqyyhqpBv2i5cjirMl+PhuY4grBgupTtziiy+aq7Ab
	 BUQrg9qOcRGWj1Rz4xYwo/XGHJkGUMoCIL1BRwLZfs9L0wuag/FzyU8xeVgUtPA+lxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466982;
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
	bh=cWL7PhNpnfupResHoY5AGP2nXthWohGpJmtDHZ6RAIk=;
	b=iOAI61r5mC819MvxTqfusL8QIxoJHpGDRqChUleENxEuqDyYznJnDndBOI9AWiqBg9is
	 8ddhiokTL7vL4nLNuSpiwfDoZWS3kIEmO2x80+8NdyrP9Rzz/lUb8OUb+9wxZg1dfFMAa
	 d/mHIGi+CwrWZiSaXG64MA3NiWz5GvP62OozKXzTdKgLEAqaXCy9u0Xsee4LNJPhJ1zfg
	 ARv71Q8iiqTlVeLhq8LPngxnqy1riw4kBwGpbtdlyiiLM0Hgr+Tf/dkIHZByyg6OZPwav
	 3t4tEpwqVCtEhI5lA/1uyVqkPZ2HCw9Akx5PuIYdsc0NTaFChMFpHFvXegGFR0Rpt8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=neNl+f+9;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MIpAk8l5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A0606A33B
	for <fio@vger.kernel.org>; Mon, 23 Nov 2026 20:49:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C6A0606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=neNl+f+9;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=MIpAk8l5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795466990; x=1827002990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cWL7PhNpnfupResHoY5AGP2nXthWohGpJmtDHZ6RAIk=;
  b=neNl+f+96RdTYMYf9d/RSMYIwxlN9Il7LZgKJxX8bvjyBhojZPI31Q/w
   tSK2dNfJRlaSZDLX6HJMGe6lwLXcGBhy75PrpyyKzXQPeWWg8ImsEUEbS
   DTE7erq4sAUlWh1I+gzlg8pTfjMHQIR8c6nY5x7y6Oh7X2egCPXfczN+H
   /YFZ8pxufvCCmRJeaTvTWNZCFdz4Czbby0mY57VwC27B9c1iNktXBr42b
   jF0oPWiaUoqVfUckP/ravHGH7JL8Avb8bNJcfURTjyz2umDlksAUTU8+u
   OB+wfhRHAdok4Raq1a4QSsVpYl480p2s0ceLi7Yh2SNUQg6xKs/cUJ1by
   Q==;
X-CSE-ConnectionGUID: 9bwVPgpNTz+1JNb97Gj8YA==
X-CSE-MsgGUID: MynP5BzfT2icRqgZ6qV7bw==
X-IronPort-AV: E=Sophos;i="6.27,229,1786982400"; 
   d="scan'208";a="159969597"
Received: from mail-westusazon11012068.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2026 04:49:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1aQdb9/tp/cYEW1G3qhht/fH8AQR9WZmJHA4HhffBXg1mfDPNz/0kN8+jSZ+k2Xk4vdYj1ddV8FEdE96c+oOVN8c1uC/B2dSvU00w3OeYYv8aylJaylPFI84gcurHA7/zm0MsdAolne1EOrHpHZLz3Yklc1SSEg0g4svfhRf7OsnQifXyin1U2Dal2j4JbiM5KOUYTR/je6VxpGdQnimqNsdAqZ4jNf63u0ztrA/ou3fpfRAo4HKCz0Qjm+eyPXa/LVfpGq+aFuD45hPrZJYQ4Pf9UEok/ki+82kGSRXjWM/jyljzkf543pikQV+hC2dWtOjlCafxHxtf8vRyaQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWL7PhNpnfupResHoY5AGP2nXthWohGpJmtDHZ6RAIk=;
 b=dfbbqTNwS9rdJS5bGXoJ7enPBsCHcjbhEslwyeYJOG4mLT/2psS9AIPONJR6UtmdYQ7WEbawW9sQvg7zRDbW2BKUNUiXq7j6kiyPexE0CIwj5paYDGbiMEJ7oMbQ5EtZm6bxAtyJ1OUJNWiKslODRHLkNMjT3sx8wzEkzQIseEuhwBFHYaImkPQl6HYRfjitVhPR1sMii6sbU5yhAGOSEXA1YC63FMle6lUpqeN0Axx2UEBlc1cETEPDcbSiGdL0c6pQyrvfhVPbppzfTQ6SHNgf+qE0abGcXLt9yPceej1gndZpFg67XXBMPCGb6Ok2mxBsyAo3c09Vlt8dnG2uOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWL7PhNpnfupResHoY5AGP2nXthWohGpJmtDHZ6RAIk=;
 b=MIpAk8l5nWfkZc0GqMReFk1ZE+7y4KcKDCr+qRqwHJVe4mqAfZzo/VentPJuaijjZTghkNc88r9SEo44wulOoncrdEzSqQOXxZHAFqYAaJ12GqP13AvBsJJjARGC1iVEpQheMmpkV9QXkNOuCbW2ZiXvvn/4fsfXYt7CqOB+hVI=
Received: from PH8PR04MB994107.namprd04.prod.outlook.com
 (2603:10b6:510:704::21) by EA8PPF4EC9DA1B9.namprd04.prod.outlook.com
 (2603:10b6:30f:fff5::888) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 20:49:39 +0000
Received: from PH8PR04MB994107.namprd04.prod.outlook.com
 ([fe80::decb:19a9:b964:825d]) by PH8PR04MB994107.namprd04.prod.outlook.com
 ([fe80::decb:19a9:b964:825d%5]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 20:49:39 +0000
From: Siriporn Swart <Siriporn.Swart@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jon Whittaker
	<jonathan.whittaker@wdc.com>
Subject: Re: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
Thread-Topic: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
Thread-Index: AQHdbVLY9jozLnKT4keAHV+sEWtQIbcy49eAgAlYcaE=
Date: Mon, 23 Nov 2026 20:49:39 +0000
Message-ID:
 <PH8PR04MB994107DF1ECA9BFA2015637E198A452@PH8PR04MB994107.namprd04.prod.outlook.com>
References:
 <PH8PR04MB994107D250DB2434D563DC57E88A772@PH8PR04MB994107.namprd04.prod.outlook.com>
 <CAOp=CXnuSiNwChAbsWhXpCWyJb7NGFL5EMnL4ZHk0pRm3iaMWA@mail.gmail.com>
In-Reply-To:
 <CAOp=CXnuSiNwChAbsWhXpCWyJb7NGFL5EMnL4ZHk0pRm3iaMWA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR04MB994107:EE_|EA8PPF4EC9DA1B9:EE_
x-ms-office365-filtering-correlation-id: 73e00890-03d6-40cc-0d90-08df49a34aa6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|366016|376014|1800799024|6133799003|18002099003|22082099003|5023799004|4143699003|11063799006|38070700021|261022075727099003|261021121427099003|261026121527099003|56012099006|261009223027099003|261026140227099003|261022113327099003|261102123227099003|10067099003|261022105027099003|261028144727099003;
x-microsoft-antispam-message-info:
 PiaKwSmPQqWONi1y3uis+CiZ67qWps3dsnXRaRKxbU1gwx4um5sfxPyxwFBjWE3m/64k6ff7cHMTJfLEQt7j5w4+5ShLBZopOWvVzom7TZCD8PgAlHX+6O5cFjcQrrazcBp4Vl1w7k1KL9/YM/+toZr8FosH91/EYXUuzTIYJi5HIiyxBIxl4vuB3zfgU1PTS5JPr2o2BcUA7aZq3rwwgXT2fp1vC2G1aQOYBMYaz1BQaWnYERKdqmVNL7W8F4YhP2zIIzWNUi2Q1xVXiWbtGBCPzYIn85hG/wtCMDr0jRIQx5nS528vaww8M7h0xJEEeqOuRnfRhEUMVdFtwbI1L3T7eFG82Uu2ejShcFELOB/S84CxxHXLVlDNYhbZZY2rTJfiWikAqPNNW6Eh+1HTv+921jtBEqgnDkoMlNCvtlbGOf+boYR4BhNEYIvqjT3DaRQTFsW46qMOwMYb3ag5QNIhnBQAMj4B0SYSY4zzMXzl3vgu+/ezKyTImdq2YcBE4y927JGw1ySHfo7IL0FbUb/7L19f+BQ4crY2BoawFzwuWqVYkzlgWWQYN+uy3gM91O2yJqwUQuRZZGfvzPssmaYY7NVeiMFUBEds0HfCtP5xSF9NBEpNqn4lGSniGzOwmk/NcZo2YiXFcwZg75qeZ/D0GVzPEeyKh7RLr97m4CTgXzF8Z8wsRaNQhrNG4fR1GdWhbWWt2BMzMsOjosbdRF4B9xKs7v3GLnqzQE+awEo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR04MB994107.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(366016)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(38070700021)(261022075727099003)(261021121427099003)(261026121527099003)(56012099006)(261009223027099003)(261026140227099003)(261022113327099003)(261102123227099003)(10067099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cy9IQVhNU2lFemJZTXhibzRYY2RPelJJbnplZ3MyY1o3QmFySjZuK2Y3Ukdn?=
 =?utf-8?B?TFJyZUZjRHdPMXVYNkl3QWdseno1L2J1YXl0T00xWlJ4NlVlbDZzTjZ1NXNV?=
 =?utf-8?B?azBjMDNMUU9uVlRRWnQweFdFbFRuNCtSdksySjFtZVAzYVVoMkJ2c3d6SVlx?=
 =?utf-8?B?T1F1cTRtZmVXZUdFQXlJcnFiNG0vT3B1RjVleGVwWUliTk9WS2svQjBDVTBP?=
 =?utf-8?B?N1ZrcEdhOGJGRkhLMk5MMlBBYkFKMTQ2VVJKdWdSV1p3OHhmVnVFSElzU3Jk?=
 =?utf-8?B?cUV1bVIzczZMMzFqcGpvNVlsMEVTdmszUGJRMEhnUjJxMUlyTDNLMWNYYkNy?=
 =?utf-8?B?SlRQNjRwMGZDSUdWVDJoTHRORVFaWURoc1dFZU0reERMTTRhTUtMNmRObEM1?=
 =?utf-8?B?UmdqT083SkQ0aE96eUlDOU9TdWZaYmFZbGthUlNFYXNvcnU0RnlIZU1maUtV?=
 =?utf-8?B?K0xNUFBRT2huRVUxVmNxWVY2TU5VQ0l6SU1tYUtVODNvWnUxTHd1b1k5V3ZE?=
 =?utf-8?B?bVh4a3Nmb2s0bXB5TDMyMy9OdHlHNWQxS1ZiNGpDZEsxM1crT3FOSnVPUWFX?=
 =?utf-8?B?UkdFc2R3MUYreStOUkNzOTVuaHU0K1c5b2s5NUFKVVo4amx4VG15NkZaVCtY?=
 =?utf-8?B?K2FYK0NIc0hpTjJJQjhDcDMrTmczY2VQVUFpR2tYMlZjbU45T1hvL3Rybnc5?=
 =?utf-8?B?RS9kQS9JNmVxR2ZFR2d6ZGVDZ0o2L2t5OVNQOVpkekk4bm1iaHViUUhNQld3?=
 =?utf-8?B?UmxnSzFreTUvM2tFbFp2OVdOTkF2U3lHMnlUL1V5TGZXSnJrNVlCQXB3RWov?=
 =?utf-8?B?bUpicGNPRG5SUW1uVjJ3YmlRd1lQNXdobUJVTkVrMUhhajBnbmczS0JyclFL?=
 =?utf-8?B?TW5MdUxkb1RMN1pacE1GM2Q3aFpqcndXMldHbmh0eUQ2TVNJQXVHdzB4SzQy?=
 =?utf-8?B?OXhjRnJCUVl3ZlpjT1F4aEJodjB0RU5OR2EzdkEvK3ptcDhwemgwUU9Ia3pJ?=
 =?utf-8?B?YWpkY3BJWkdIekZxRGx3eE5iUFdpc05CditnUFpuVS9hMVcyOGVKM3h5S3A1?=
 =?utf-8?B?djVnTnBRYy8vVkEvaDdaZVBLRWJMNE44MWRGSmp0d2F0NW9jQjJ4a0ZYbzJl?=
 =?utf-8?B?M0ErNXI2SzExOFJNc2VnSi9ic25Pdmdjbm9YQjAxekMwdU9RQ01pU09VdExr?=
 =?utf-8?B?Ryt1K0E3WVNaaDRDam04RTcyajZSaThFZlZrbGd0ZzNYMmRyTGtSQkJKbXI5?=
 =?utf-8?B?eFRJZ1A1aW4vRXYvUXRvbFpWRHNUUU1ZaEhTMUE3NFB2bXRCTU85YTE3T0ls?=
 =?utf-8?B?OFg5WDE5c2toWFV3Ynp6NUZQQktnZW5jdGVtWXM1UkgrNHBnY0NhdHR5MWd4?=
 =?utf-8?B?dEN2eEgvVlV4dWd1WHFXckxIU3lpK1RackpWaWlxK2lkcmU4Q2xZRkJyNXZr?=
 =?utf-8?B?bWlMODRjb2pTU2NSSXNkZmJObnY4N3Y2OTNFYnlXRXBMQ0lLdEZibUh3ejVn?=
 =?utf-8?B?RnNlQjFuTGFRc2djRnh2L1phNDQrUmM0OWkyRmowdlNWcURSdnl3V2lXQ0pC?=
 =?utf-8?B?c0VYbTlZTkVwdVk1TTZrZ0QyOFpuUnFNYWVhR0lGZ2JuQXpDUWtZQi9Od0Fw?=
 =?utf-8?B?S1VVcklvdW9FVjJuYlJYN3hXZi9XclRCSVdMaUUyRWVxdk9EMW9iR2hnSjkv?=
 =?utf-8?B?RUpqVHFlb0lJYTBCVVhRbnMwSXhCbnJ3dURJV1dqYWdWaTR6M2s5OFdwWUFD?=
 =?utf-8?B?OVU4cm9LeUg3b0l5UzV3OEl6NndNY0U0Q0hDK0txek50NWRCR1ZjNGhJSGZm?=
 =?utf-8?B?M0VYMmhjK1M2djJrQ1MwTlV5d2pqenFVNm5kMGF5ZWRIYmVwMk4rRDF5VHI2?=
 =?utf-8?B?WnBtSVNvcDJWSTJxdGV4Mnh2c0JJTmdnSDdCNG1sdzljWHVoQjMxL0lxcFJ0?=
 =?utf-8?B?R213bG80N1M4YldzdGJQNGkwNnZDc2NWUzhNdEMxajFIc05vc0JnakRkQzJj?=
 =?utf-8?B?dHQ4eDlmRklaY0NZM1VrdzNqRTRndWJuaWp2VGkxck1kWTV5aDFDR1R4cGd2?=
 =?utf-8?B?cERINUs2cVRvQ2RyVm4xUlVkK3lZT2o0QmpBdkNNMFFFTUpnaU9Uc2gySmwr?=
 =?utf-8?B?SmFOS1BsdXBaWkVHbCtIbzY4RTdOOXVOYmpjbWxpc3Fiem1Id29sejdGblU4?=
 =?utf-8?B?bFQyOVMvRStzaHE1U25YeXFFN1d5WUlkSG00SWhFUkU1WW9JQmdldWRrK1Vw?=
 =?utf-8?B?emZMck1tU3RPcDgyQ3ZmaUdFKy9QaUtVaTh4QnZ1dzVXYmFaZjNKSlExWi9T?=
 =?utf-8?B?K3hWc0RVWVVuK1JiWjljYkwrMHF1Rm5BYlpoYWQ1dEk5R2lKZGJsQT09?=
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
	S8oCiR6FrYOE/1YYdfYftqVMpstSYAWB+ZU0UfGlEJ3DNZcFhjqOmoliVZfsq1YuPdK80FBrsx6AK0YC8hn/ZiOWIOdV6vXcpySRz+ETNYPf9KrwNj4TtE7JWGZ+ivUX+uTsJmCn0Y7ZiOZ0T1+CBh4HnylENH1PxFyiHaJcRbO+N7iPUgYWb2qu5h7gFXP2YW7sLaenNc9n0UBMsmFddXB/h2sLL0iCi9RCAw+qRTctUwtkLbveq/CHcQ2fdJpQpP3PM1nb8hapAKS2zNczztq3wME0IJp2702vOYd0CYBF9v4h3dBfusz+Q858ozxN2s9Iq9zPR6xXKwaFnuSu9g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JvllyYNP3JBRYZ/ZJfm/GpAwm28ZpW0Sy06ze04q7ymPjNu3aez9NGAiFzXy+i/pOhuAMNdl+WacJheUd8PlId5bGNL8t6ZNPC0IQwr5KVIgpTHMfHW95/Qu+1fm29t2QzljuHtLDcG2L3sdzu87/diwkV9tzWOOH1QBbkwbfAWhRKJm11KWCFNvqcJQeHG8CYCjhONGT05DmKeiGL8GctibV5G5HNCY51DleaH9HPOKeZitlngl0V/siWBTUkIh6xnJIHb+vV6q6bMZ7wfrDLHhsGBMZGK4LI5+8XjhOFRiuUA9m+ihUN52o9FgMB5wBybjJVWOUX5VNzPzAQ9MCwKf0PDm6kC+Dzc2bPCARF2OsPPxfNj2Iq43ikm65O+vvjIM02juTg3Znpn21/RxqZ5nLg583sezNn6cy/v7D+qRnSb2bTof02ateMqbw6fTqtqqd2q2rh+N6J2+EltofP4rTDvO0cYbSQ5jd5hP5BDUqSBHugRtwLbmn3TKMyoXhiz58FN45rD348rAXMu7RXaBMt/l2ImMMhKWsau9wRp0Psoi224GyoHfeiwDBtLBEzgyKrFiHc9uL0CjGvIdIVd5OiEwFgqfpnA0697hynHwU8h26hT0i7UCCEw1hey6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR04MB994107.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e00890-03d6-40cc-0d90-08df49a34aa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2026 20:49:39.0537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2sfhV700ZjwNUHwZ7zvu4yhpFs4fNVNafExK6v+p0X0rLoAQ/OzzXI4590HXIP+YHE2hoDd8MUPUzgC6hyCIcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA8PPF4EC9DA1B9

SGVsbG8gVmluY2VudCwKClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIGdldHRpbmcgYmFjayB0byB1
cy4KSm9uIHRlc3RlZCB5b3VyIHBhdGNoLCBhbmQgdGhlIHRlc3QgY29tcGxldGVkIHN1Y2Nlc3Nm
dWxseSB3aXRob3V0IGFueSBlcnJvcnMgd2hlbiB1c2luZyB0aGUgcmFtcF90aW1lIGFuZCB2ZXJp
Znkgb3B0aW9ucyB0b2dldGhlci4KCldlIGhhdmUgYWRkaXRpb25hbCBmdW5jdGlvbmFsIHRlc3Rz
IHRoYXQgdXNlIGZpbyB0byBnZW5lcmF0ZSBJL08gdG8gdGhlIGRyaXZlLCBhbmQgdGhleSBhbHNv
IHJlbHkgb24gdGhlIGNvbWJpbmF0aW9uIG9mIHJhbXBfdGltZSBhbmQgdmVyaWZ5LiBXb3VsZCBp
dCBiZSBwb3NzaWJsZSB0byBpbmNvcnBvcmF0ZSB0aGlzIGZpeCBpbnRvIHRoZSBmaW8gMy40eCBy
ZWxlYXNlIGFzIHdlbGw/CgpCZXN0IFJlZ2FyZHMuClNpcmlwb3JuIFN3YXJ0CgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpGcm9tOiBWaW5jZW50IEZ1IDx2aW5jZW50
ZnVAZ21haWwuY29tPgpTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxNywgMjAyNiA0OjAxIFBNClRv
OiBTaXJpcG9ybiBTd2FydCA8U2lyaXBvcm4uU3dhcnRAd2RjLmNvbT4KQ2M6IGZpb0B2Z2VyLmtl
cm5lbC5vcmcgPGZpb0B2Z2VyLmtlcm5lbC5vcmc+OyBKb24gV2hpdHRha2VyIDxqb25hdGhhbi53
aGl0dGFrZXJAd2RjLmNvbT4KU3ViamVjdDogUmU6IGZpbyBXcml0ZSBXb3JrbG9hZCB3aXRoIFZl
cmlmeSBFbmFibGVkIEFib3J0cyB3aXRoIGluZmxpZ2h0X2lzc3VlZCBXaGVuIFdyaXRlIEVycm9y
IE9jY3VycyBhdCBSdW50aW1lIFN0YXJ0CgoKQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVk
IGZyb20gb3V0c2lkZSBvZiBXZXN0ZXJuIERpZ2l0YWwuIERvIG5vdCBjbGljayBvbiBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZSBzZW5kZXIgYW5kIGtu
b3cgdGhhdCB0aGUgY29udGVudCBpcyBzYWZlLgoKCgoKCk9uIFRodSwgTm92IDUsIDIwMjYgYXQg
MTozNOKAr1BNIFNpcmlwb3JuIFN3YXJ0IDxTaXJpcG9ybi5Td2FydEB3ZGMuY29tPiB3cm90ZToK
Cj4KCj4gSGVsbG8sCgo+IFdlIG9ic2VydmVkIGEgcHJvYmxlbSBpbiBmaW8gdmVyc2lvbnMgMy40
MSBhbmQgbGF0ZXIgYW5kIHdvdWxkIGxpa2UgdG8gcmVwb3J0IHRoZSBpc3N1ZS4KCj4KCj4KCj4g
U3VtbWFyeTogZmlvIHYzLjQxKyB2ZXJpZnktZW5hYmxlZCB3cml0ZSB3b3JrbG9hZCBhYm9ydHMg
d2l0aCBpbmZsaWdodF9pc3N1ZWQgd2hlbiBhIHdyaXRlIGVycm9yIG9jY3VycyBzaG9ydGx5IGFm
dGVyIHJ1bnRpbWUgc3RhcnQuCgo+IFJlZ3Jlc3Npb246wqAgVGhlIGlzc3VlIGlzIG5vdCBwcmVz
ZW50IGluIGZpbyAzLjM5IG9yIDMuNDAgYnV0IGlzIHJlcHJvZHVjaWJsZSBpbiBmaW8gMy40MSBh
bmQgbGF0ZXIgdmVyc2lvbnMuCgo+IEVudmlyb25tZW50OiBXaW5kb3dzICh3aW5kb3dzYWlvKcKg
IGFuZCBMaW51eCAobGliYWlvKQoKPgoKPiBFcnJvciBtZXNzYWdlOgoKPiA8V2luZG93cz4KCj4g
YzpcPmZpbyAuXHJhbmRvbV8xXzRrXzAlX2Zpb19qb2JfZmlsZS5maW8KCj4gZmlvX2dldGFmZmlu
aXR5OiBwaWQgMTQzNzYgaXMgYXNzb2NpYXRlZCB3aXRoIDIgcHJvY2VzcyBncm91cHMKCj4gNGtf
cmFuZHdyaXRlXzE6IChnPTApOiBydz1yYW5kd3JpdGUsIGJzPShSKSA0MDk2Qi00MDk2QiwgKFcp
IDQwOTZCLTQwOTZCLCAoVCkgNDA5NkItNDA5NkIsIGlvZW5naW5lPXdpbmRvd3NhaW8sIGlvZGVw
dGg9MQoKPiBmaW8tMy40MwoKPiBTdGFydGluZyAxIHRocmVhZAoKPiBKb2JzOiAxIChmPTApOiBb
LygxKV1bLS4tJV1bZXRhaW5mbGlnaHRfaXNzdWVkIGRvZXMgbm90IG1hdGNoOiBudW1iZXJpbz0w
LCBpbmZsaWdodF9pc3N1ZWQ9NzEwOQoKPgoKPiA8RmVkb3JhPgoKPiBbam9uQDExMS1wZXJmLWpy
dyB+XSQgc3VkbyBmaW8gbGludXhfNGtiX3JhbmR3cml0ZS5maW8KCj4gNGtfcmFuZHdyaXRlXzE6
IChnPTApOiBydz1yYW5kd3JpdGUsIGJzPShSKSA0MDk2Qi00MDk2QiwgKFcpIDQwOTZCLTQwOTZC
LCAoVCkgNDA5NkItNDA5NkIsIGlvZW5naW5lPWxpYmFpbywgaW9kZXB0aD0xCgo+IGZpby0zLjQz
Cgo+IFN0YXJ0aW5nIDEgdGhyZWFkCgo+IGluZmxpZ2h0X2lzc3VlZCBkb2VzIG5vdCBtYXRjaDog
bnVtYmVyaW89MCwgaW5mbGlnaHRfaXNzdWVkPTI0Mzc3Cgo+IEFib3J0ZWTCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdWRvIGZpbyBsaW51eF80a2JfcmFuZHdyaXRlLmZp
bwoKPgoKCgpIZWxsbyBTaXJpcG9ybiwgdGhhbmsgeW91IGZvciByZXBvcnRpbmcgdGhpcyBpc3N1
ZS4KClRoZSB0eXBpY2FsIHVzZSBjYXNlIGZvciByYW1wX3RpbWUgaXMgZm9yIHBlcmZvcm1hbmNl
IG1lYXN1cmVtZW50IGluIG9yZGVyIHRvCgp3YXJtIHVwIHRoZSBDUFUgY2FjaGVzIGFuZCBicmFu
Y2ggcHJlZGljdG9ycy4gU28gaXQgaXMgdW51c3VhbCB0byB1c2UgdGhpcwoKb3B0aW9uIHdpdGgg
YSB2ZXJpZnkgd29ya2xvYWQgYXMgRmlvIGRvZXMgY29uc2lkZXJhYmxlIGV4dHJhIHdvcmsgZm9y
Cgp2ZXJpZmljYXRpb24uIFRoZSB0cmlnZ2VyIGZvciB0aGlzIGlzc3VlIGlzIHRoYXQgd2hlbiBy
YW1wX3RpbWUgZXhwaXJlcywgRmlvCgpyZXNldHMgYSBjb3VudGVyIHRoYXQgaXMgdXNlZCBmb3Ig
dGhlIHZlcmlmeV9zdGF0ZV9zYXZlIG9wdGlvbi4gVGhpcyBjb2RlIHdhcwoKY2hhbmdlZCBpbiBy
ZWNlbnQgRmlvIHZlcnNpb25zIHdoaWNoIGxlZCB0byB0aGUgZXJyb3IgeW91IGVuY291bnRlcmVk
LgoKCgpUaGUgbW9zdCBzdHJhaWdodGZvcndhcmQgZml4IGlzIHRvIHNpbXBseSBkcm9wIHRoZSBy
YW1wX3RpbWUgb3B0aW9uLgoKCgpOZXZlcnRoZWxlc3MsIEZpbyBzaG91bGQgbm90IGFib3J0IHRo
ZSBqb2Igd2l0aCB0aGlzIGNvbWJpbmF0aW9uIG9mIG9wdGlvbnMuCgpIZXJlIGlzIGEgYnJhbmNo
IHRoYXQgYWxsb3dzIHlvdXIgam9iIHRvIGNvbXBsZXRlIHN1Y2Nlc3NmdWxseToKCgoKaHR0cHM6
Ly9naXRodWIuY29tL3ZpbmNlbnRrZnUvZmlvL3RyZWUvcmFtcF90aW1lLXZlcmlmeQoKUGxlYXNl
IGxldCBtZSBrbm93IGlmIGl0IHJlc29sdmVzIHRoZSBpc3N1ZSBmb3IgeW91LgoKCgpWaW5jZW50
Cgo=
