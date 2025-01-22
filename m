Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56808BE4F
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737508318; cv=fail; b=pCs/Dm0fsY7DamWj+TpzPgf3ecXyzjMWGer0s9nj4wEQ6tHRFey2A2hFAoGJOfVIjkVgdgviQqrnatRrDVKftl5FZ9+hy/HTuGLqnOtYZSNc+wlo1GLTXqi0r24Hg1d0Ufq4xSYu60SGhjAdpKX46kN94s5kL7RLupE3SFDJ0QE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737508318; c=relaxed/simple;
	bh=B6QVN9AG4Hl2MVgwJSuV2sccMstRLy6dhaV1EIB+4BU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CTOMJssnBIrx8sqtVzlhKNcbXrT0pv/jD+wClB3FL16xr6HZvuxiSElGxiHWWvJe5Wo/gCb+aX4QT8CuC6IcFpZ7XtYAc4eaKPW7zJdiLZ0Uz8nTNFhcC5pLVDWWLwF/jWYXOo3yO10YyfoY8rFvk2wtwFt3dc83RZznqBvzbq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RHgh4qUk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=K4Mc0jG6; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RHgh4qUk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="K4Mc0jG6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737508317; x=1769044317;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B6QVN9AG4Hl2MVgwJSuV2sccMstRLy6dhaV1EIB+4BU=;
  b=RHgh4qUkgyWMVeuJbCWuuMS/6BJ4jisT1z00LeLtChVS1cOh6oNgm1Mb
   MpR2a5bRd3eyLWWnV11jzuq1dsqSBSSoNYx/sWBHMeHF7wo/MUkv9j9nw
   is8WifJC1rZtJ9JJXfIfsMngiNJ/9ZHYmD1xuG0LTzFadiSczfaZIoJvY
   1y9SeO+1IyRNgEaV6LsGaTkEd4QKsymbFKb2Z7vNmvcfmBhn14KY/MAcv
   5s6hpelXLiwxB+jOq4d0McoTA64pzsxMZkcZ5nkZUmiU65TsK6Gzpf7F9
   kapK70mlBC/FrejX459cdQze3lVh3yLUVWT4KFQ8DyoSGkjU7FT9+JmTr
   A==;
X-CSE-ConnectionGUID: qVO+zqSFTPC6628qW9M2mg==
X-CSE-MsgGUID: /FWuWnl6SACIcWZFU59B5A==
X-IronPort-AV: E=Sophos;i="6.13,223,1732550400"; 
   d="scan'208";a="37497372"
Received: from mail-eastus2azlp17011028.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([40.93.12.28])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 09:11:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JsmIPtJPUjfv32V6JLoJMyyMQMKCxkn8jx/Y4JhUJhvDUJ47rEW2DFWx4v04TyWUlG7TIVcEWAj2R2adR0WfvIGoZajQxSpmnHYWARE/SO66Pt9HVar6+v4kXOZgsm9XkmlVovOoOGf4kmdIHelq0nm+PCNwv9M0UgfMj2Z8TaUJAfc2Xaoq187RDzq/RNSiKoNQTOQf53lCo95shUfN+eDcnw40yVSXOTNnBqF3oO3+NYzKW9nTdcvcmydmRLpp/XNGyUnXrJ/muhn2rwnpBD2HTmdmFN7/dV8GQ3sT0R8IkPM5kUcqtkcumgfs7PUgMz+CJmH+rBWrMhmRqbmgVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kICR5HPBGoPH1CFR33L7qsFim3uxmPW54OjzswiWGsM=;
 b=MssKlsChlzMDGfoibdFLSrYYd2v+kbnN/fxsiPLBPiF7vlz6Zq8Z3SY0FF2iQIYIxVsqVvlScbrg5MBaIkGFvYwaAVdaGxAaXjIk7hWirvJ35Rc085b14yL+M3D1N2pm3N2p8YAjLEJ6CjanBhy29691y7hoUIHCr9BcYF/Ae8frcMkuW/WZZ29xeoN5M6hIy21erUfSmHYBu9C5Dbn4ipZt2EWZPNziVY0b1X50H3YiCNN0qG961bXoROCmyEORSzPyVKTQXb3TEekN0wwA5unQYYu2I3/KW2+o0ffm4suMTTtRok9I9adryn21unlA3uhoU3v0rjCuEUeRWOz9ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kICR5HPBGoPH1CFR33L7qsFim3uxmPW54OjzswiWGsM=;
 b=K4Mc0jG6HpnGR6OBcUUG3VZrhBoCDZXQiRnxVX/ytu59FtE0P0aD3gt/qnTa2exbnDy0SRSDxJhUo2C3YL2E6f41n+q5Jl5xzEJ37RiLadTmwZMFlDmE57y9wZnJsYrbxjcL1HfOplnUrQyeYF9HzV+ZZ4Bw17TWOfXDnAtn+Cw=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 IA3PR04MB9307.namprd04.prod.outlook.com (2603:10b6:208:50c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.22; Wed, 22 Jan 2025 01:11:48 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%5]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 01:11:48 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Niklas Cassel <Niklas.Cassel@wdc.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 1/2] zbd: do not check open zones status and limits when
 jobs do not write
Thread-Topic: [PATCH 1/2] zbd: do not check open zones status and limits when
 jobs do not write
Thread-Index: AQHba9/2Ioy4v/29U0qISeitsXGjx7Mg8reAgAEKwIA=
Date: Wed, 22 Jan 2025 01:11:48 +0000
Message-ID: <iduucpsabgo4b63qyldmqg4c4cjaadklkmsris4tiyolfxwu2w@oawbuq62jqw4>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
 <20250121083913.1216619-2-shinichiro.kawasaki@wdc.com>
 <Z49mDl_xUPaaan8t@ryzen>
In-Reply-To: <Z49mDl_xUPaaan8t@ryzen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|IA3PR04MB9307:EE_
x-ms-office365-filtering-correlation-id: 6d9525eb-af8c-430e-c556-08dd3a81bf11
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?6avCdQpZq1TCv5gt2SIgu72pNicgoJ9R6awPKmOw9NPzFqPR15Pn2Gd1L1ZH?=
 =?us-ascii?Q?ABga2N7VR9sCAQXc/tLF8nR0fkSMXnijfj2h28FEz+t8wDnP/v7wSP/Pbc5z?=
 =?us-ascii?Q?2fiGEjjZmRY+F7txrr/hzyaKYQJPbDYmhiTTpMvH9QSU86q9sSMmTAgeKZXA?=
 =?us-ascii?Q?fsGUpJ5wH1faura0NhPgFYFcRhVHCM2dFGVMzF2/2v1xu/kZryVHdJLgaHQP?=
 =?us-ascii?Q?WlC3O5DeQwS4peUCbUV320IJV+jAsB1pXYOuK4+TSzgLjkl/wpygybi9wDd6?=
 =?us-ascii?Q?5M8O1TbCfG7Xm5PrTU9kyvJaIJyMgviLdfGGRki9YF0KDaREsSxusXORV0jB?=
 =?us-ascii?Q?MGAamu1wngx2oJBfRHcTLVDBIAhEg5YIDd//a5JNi7N4J9DgLAOzHodZmfFV?=
 =?us-ascii?Q?VOuh247p1Hkq4+oguzlnqVARNALDIeCathh4E6+6HTCe7/YrhKEhUvqXzbwu?=
 =?us-ascii?Q?k8evgg1/305TdLPPlrvJSIpOO5FlEVKdpRp6WZYvl2/M551FJQa9aLFgB/aT?=
 =?us-ascii?Q?BGWLhnXjMq67fE7xB7T3tOOKX+n2RiqblHsQKkYD7PbwQFZj67caNUhJfpEA?=
 =?us-ascii?Q?Yhmf2i96JtblJG7AQCB9tU3220zXcVfrmB+Fgc05yDHRZit0Ms2u9eFoUXNw?=
 =?us-ascii?Q?NkCvxouJT/vFDh0x9x6LD9zutSUK65dyoBQIFIKseBXmT/YNsLygTpZ80FUU?=
 =?us-ascii?Q?gHjz3MfubYsF3eO8yxGryIuNdGr61sG/3ArF5ZPjvdK4qfz1qcR8DTsmjcDS?=
 =?us-ascii?Q?KtrusIbOixkD764DY2n06W121BWMPX5GfTchEtOD3J0msxZkuKgU7UFdVF9J?=
 =?us-ascii?Q?y8fm+gZIT5AL1UP+zfTLSKvhxJClk5sB0JBKt9XwsmfISjpTF1hoaNIAtzKy?=
 =?us-ascii?Q?W01hlDXOlAPNR5Uvt0t0VFP5GKDo8oO8pBy34ddQ+CcL3uWElaV1w76Sl4Zi?=
 =?us-ascii?Q?huWhIwouUAN1CgXS1b8adcp+SVi9Hr/Q7WA1As2aCiBdMt8Y98WlDMRtjtuY?=
 =?us-ascii?Q?sWT0Z1fakSiOGZ/4peKNxZQMq6qgehI46O/3JwO3yqzAP2Pv5OpK7ICph7Im?=
 =?us-ascii?Q?jrZZRux+1qlf1q/539mPRfPtSgUXQsc4p0w/XaBFasjrARfC7WSiuY0Ywpci?=
 =?us-ascii?Q?ylSKCcxpSRml7DJyoHbVj4QdPiZyEV/wuKpcOLXJ6EIw/oU8zxVlFcZdUoPb?=
 =?us-ascii?Q?aStatnMYjuETWKxpPHEoGg3XQJyG0BVaCDnIAtleEeuECxGiyHdCVhOvyOqd?=
 =?us-ascii?Q?S6M9UoyyZWyFhfmyW3xN0CXAEXDO3tdohEvqWOyVEZKTgu1aaQ02omKc1lk/?=
 =?us-ascii?Q?ISrC6jBG38Q82I53TVQLu6E6K3/K0LRjnTnustEPAL2ueKNeKa0DF/SSLl/d?=
 =?us-ascii?Q?fSfDD4vdVi5uK8edmXsZ3OHG9VR7jmwsVyPrvtpYn1CaxRtDDctWEYGoF9ct?=
 =?us-ascii?Q?n5EWtpfDUvKbyFaZaAuCbNroEc3/vPcd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?LPvKSAd2qyEwKfFoOsONkrRkZKy182UHmAHpKnkBOFdBrCg3bazIzmhS8hYj?=
 =?us-ascii?Q?YNERd+flFhL6TuBGWa9IgtYglou/cgB2iVYuDtabuYe3wfPy5+ObQOvWsQHT?=
 =?us-ascii?Q?ex7LqfWnGvSq8PZPpnTwuzNy+cQSpZjzcOKVc9eqsOhShAz5dkaWg2l+Ofv3?=
 =?us-ascii?Q?kCDpReQJCVGy0bVW6XnVCVHMIR2zHRS+TStoOXsYEAbmBz53QP4aURwZpAI1?=
 =?us-ascii?Q?62dDJtBRBT2xQj1FWlaGzdSDQ0LcH7zYIf2dLPccUuOEXH0WKwCFs3JLkiuA?=
 =?us-ascii?Q?I5DmlnglZbKgVoV1hYu6dMVSLsN0F40QT+kbCm+pvZVgMl6qPwYF12tLeSbY?=
 =?us-ascii?Q?l9UPEDNAFQGi/y0CgAB9E5Jy7bAHvivuzV6ZGYLBKqrIdbIZqfh0gcbWa0la?=
 =?us-ascii?Q?ktl+OH14+h2JuMrtcD2XYd4YS1WFbK7J61C6T9R9RL8KskAaL1FlweVDO2uf?=
 =?us-ascii?Q?UB8PmYVd2yqjIwvcwLrR3lsYvlM+XfUQ4yF+VD6KWtEowHyeYDCzafvrIunX?=
 =?us-ascii?Q?rbetzZc+RLfcobU3qMK/r86lZUwGTDhUzzJhLneOvGCDKkLrWD/4gZ49nB1H?=
 =?us-ascii?Q?vAWSkngB0PuyQSRo1J9x3+FgSlu76sYOkdJhoL8DHC2yGQRVBj23IUc1IRui?=
 =?us-ascii?Q?wP9lJZFWbXELYccTyr/k15tmn3QukeAq3JNXYgem6UTCe3w8HkxhayMwGpxG?=
 =?us-ascii?Q?9AvSubw9Js0doABlO2cCDr6fA2k9jsga5p6f0gsso+Dy2qOmL+IEOz3uaebK?=
 =?us-ascii?Q?8T4YmNOtdhhd5+myakp31U+zaYaqV7VMHWzlj1qJnFRsqEEX9ZHfN6xYVrXT?=
 =?us-ascii?Q?yJF4GjHWvJ2lYwcB4BcTt2jxMNwu6TvJbdg7TVbOAJ8aYQ5/FVHX9t+Us5xF?=
 =?us-ascii?Q?K48YFvh8P5RxjPuqGWSAGZY6IxamOUmd5sRbhe4eSc3+5pIQiaJKnYled2+B?=
 =?us-ascii?Q?/cX2Oaviv2LvCCt+ReOU3mLZVBAIvXprPlZId+bgoBhcjwrysNgrK3Bi18iD?=
 =?us-ascii?Q?TWXVE4KnF9UZPPzZnbVW+4VnyHUL/DyAw48Oeh8hQ7T7eKoyssHtxrnEdi/R?=
 =?us-ascii?Q?P1Hbp3jF/kdT6v1eSuzNZc98kSeSNpwDoFRbSP5pIyK9b6NZaemRABC1pag/?=
 =?us-ascii?Q?IlSgtFxsmGSY38e+LufBT1Yadnz/6nhWJsYMWQXQ6g5EWa4l2PGWwjLWeQ/d?=
 =?us-ascii?Q?GbKdfzchvatyNw1Z6+CNlZAUBcYxkFgwuXzTYGMYI2jdtQUtC0tgvlm+/KG4?=
 =?us-ascii?Q?qq2+5da4HuAF99UgIFjPNLO0bLJqLk1c1KfkCuWqcPS1F/5xpcGkXZG7SMlE?=
 =?us-ascii?Q?BhSDb7q0zMLvR9mIcPykxhTxLdsSq8oVgrwEw6SRAwFGeNvAuk5fMOkwbVkM?=
 =?us-ascii?Q?42WTLjZm5sP1QpYCCQTpHk5g4XZFk68K20AX8QKXjhAQmYkvjygpWURtI6m6?=
 =?us-ascii?Q?dYjzLkv7Rp23eox7PWvOUObPEdUGv8Z2i2RE9RhxXqV6CLSxXL+qE/qi/tZG?=
 =?us-ascii?Q?NVS6DOhVa1v1lP6EIn5jBu6V214EIk0xCE0IKg/Sxt3WkRRaevqepffI3FK8?=
 =?us-ascii?Q?pEKkJs1g5RdfD1txord+lZCL0xrDav/Mv43aUEPpDSngllEgK3OLYDpo6DIX?=
 =?us-ascii?Q?sj5nqyT0Dd1yXO6q7o69cnE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17E4BA494CCDB64C9CDCD1A42AE91C3E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kWJ7Y+30sxU8jXBrlXqF9OJOHkSL7JXAkGqRCJrW3/fXTBlGwfHgkgqOjR0YPZPz+w7L4o69TGVvReWWhD+cdUTPlcoqDaXaJ3XdcaDJg4l2pBDdkUrJ9XC6NkyArsce/XvbVT0rnb4TnhLQdod6tktbuI58bLMkpAomUX5nQMEDpfRFB+4A//RPx6NOSY6rvlXaM2BpOoSWKzSFqKfKVWkvjvZn77hS74BEi1lnNtUVgjDjBhjJwKsWx53HI7tQZkWm2pm5CC+Sd2UyVviEWPTPvqxzZJqLNBD4Vou+RjkPfaUTmkpOpSiaCKjCZbBwKbIlsEtY7sW6kSFc30QvS4cXpGYRsLXTeBN8grFW3xVYSO4LtO+XNp43630HXT7h4y4UnzyQBw6j+X396MakcuoCV5/NgoChk//0KRjKg/63TBrLGYk8BgOYiGUGsZ6rDSof6L9uzKGdTtN0AytAglDAaJ0RivSyfbd7Q1yGBBH5rpgQbEjC6cyW4VmnezLGUKKL/ETu15h2se/KoaySqPFhiyI/inRuoCBgtv8o1HH36PTSfSW68rBv9Vf8XejbBeOilzWqNAGOi+CA24f7kQirZYT0GipkaXQfwLgKtcY+HPygi/x7u6l3C7TpV0JB
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9525eb-af8c-430e-c556-08dd3a81bf11
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2025 01:11:48.6840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RCXdf+5paLnRSXyomeEB9FOcxv1H5xobHhCR7iEzNvgcP+XRwgs4xUoh18k1OXWbVCde9MqY7n2I+iMCexSSYN+rAcaCozyzXBurbpus3Io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9307

On Jan 21, 2025 / 09:17, Niklas Cassel wrote:
> On Tue, Jan 21, 2025 at 05:39:12PM +0900, Shin'ichiro Kawasaki wrote:
> > Currently, fio checks the conditions of each zone within the IO range a=
t
> > the job start. If a zone is in an open condition, it is added to the
> > write target zone array. If the number of write target zones exceeds th=
e
> > max_open_zones or job_max_open_zones limit, fio terminates with the
> > error message "Number of open zones exceeds max_open_zones limit". This
> > check for zone condition and the resulting termination occur even when
> > the job does not perform a write operation, leading to confusion among
> > users.
> >=20
> > To avoid the confusion, skip the check when jobs do not perform write
> > operations. Additionally, print the message to inform that the
> > job_max_open_zones limit does not work for non-write jobs.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  zbd.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index 8a092cbe..ee095b1d 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1264,6 +1264,16 @@ int zbd_setup_files(struct thread_data *td)
> >  			return 1;
> >  		}
> > =20
> > +		/*
> > +		 * If this job does not do write operations, skip open zone
> > +		 * condition check.
> > +		 */
> > +		if (!td_write(td)) {
> > +			if (td->o.job_max_open_zones)
> > +				log_info("'job_max_open_zones' is valid only for write jobs\n");
> > +			continue;
> > +		}
> > +
>=20
> zbd_setup_files() currently loops from f->min_zone to f->max_zone.
>=20
> Since this check is now skipped if the job does notdo write operations,
> could perhaps zbd_setup_files() be changed to loop from f->write_min_zone
> to f->write_max_zone instead?

I don't think so. Actually, write_in_zone and write_max_zone are not the
mebmer of struct fio_file. They are member of struct zoned_block_device_inf=
o,
which is shared across jobs (td) and files (f). zbd_setup_files() is called
in the loop for jobs (td), so I think the loop in zbd_setup_files() should
refer to f->min_zone and f->max_zone, which are unique to each job (td) and
file (f).=
