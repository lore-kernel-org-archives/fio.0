Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB61C07D9
	for <fio@vger.kernel.org>; Tue, 21 Jan 2025 09:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737451034; cv=fail; b=YEbEfASsPXPlSuSxiXNX7DLecSKm+SBj/3K7UTMSfxbGP+srCERYL230la1hhBNqoy/ofnbMd0VDjlbduWJd0tlpoZNIlN8uchdAgKgXaOyjqDbo6wJDYHgG+gKqhslBc2mnHnVzdtnHeIUB8CVS9AnBsHM6R5GDbUDFgpe04UQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737451034; c=relaxed/simple;
	bh=rC5moA90T5TCpKTOmG4/K1sA5IQ7Y+fhH4F/cnfwQXk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GZC8YazcyKHvkxE3pGeVirUZ5AdYMyQMGL0d3d8eGBBfNguHonQl5GelQ+eVJpEbnpfix8AmX4k7jcMkB+1mEWjMi6RTfsOrPmIjTy1dN8m5mqiyhfGD8b0CL1egnaZFtN2HZTjf0Gy3Q+8OP6lUL8IEhPkpDv/a5/lTOTPp3Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qa2kXXRj; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oXvPvDTL; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qa2kXXRj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oXvPvDTL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737451032; x=1768987032;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rC5moA90T5TCpKTOmG4/K1sA5IQ7Y+fhH4F/cnfwQXk=;
  b=qa2kXXRjofKxJ04FClvlqI8WhKN7biUFP1BafwPceSx9sk9O+JqRJifi
   wb34H4hnNkchsMNhJgiQCppN3uVaMGBTfSgy1mLZuAq2H9FG323XWtQzi
   vousn30tuygJMUPWyUM5ysR3FqvSK7f4V6sMFE4PWYRtUR34FNk3PkM2F
   pDLqJDJA20hVKE7Wk5mHG7TmhbY0OJtU1fEvZFyM+TLm5qeeUdbJjRNhH
   dtsuM2LHrpROC0jjjt+RGTy0fyuoTipSI0cMgdTj+fdLfSxerhRAkCsAd
   bueFnej22NqSVjQIbv6HV8J0FgLTd9zOFixELvBV56h/SpqAhkLfcQVv6
   g==;
X-CSE-ConnectionGUID: joi2du7/Tz6Uuv1gfi5g5Q==
X-CSE-MsgGUID: x0uTMpF9TnWpvWEyscb2zg==
X-IronPort-AV: E=Sophos;i="6.13,221,1732550400"; 
   d="scan'208";a="36933877"
Received: from mail-centralusazlp17010000.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.0])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2025 17:17:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LebJH5f6SW00NPvDdtjibni0n7F61rQEJSFzwxaJ+ENZEr5zx0CTU4p71wLSextnYo7huLMdGI76Uw+z3f8uI7VkdG7S3zm7paw4Fuc38gpG5k/V1ipv9U058JD9oujiIbujJFJrqZH/yFsoM09zWdP9OAki/l/SaG+cPMjchiwxL+P9pBbPoETzQ+lAPP2CmTMlLzCWEcsjG4abGBxTf56mAZ+kvwSESaWtYWD1/Fk+9r78Sim8mEHZeXwFyn/lZpmmR+ZQATJVwBfpmX3G0Y2AfeeCgUCKTOTxsbBCUa1EIGLWlDkvYynnXZqJffg+AiUjMrIC+OyqlgiA2xrObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6tIBFt3KFc/oJk4JFkTdbXC0qP4cZuhH8L/Lnt6I/Y=;
 b=rlGH/U4AkfL4vsUuQ3vrQGd5cwURlvBNJ0HFiB3HZR6uBXLRyuw7R0LChnCIRFgcSPWWzra/vw+sgiTw0XyHH1vM+TtBc5EirE/LOnYAbqt+l/sE0Jao+JbhBWHupBP5KxDLacyLlshjtm7TlnBIgm44Io3hGMIukvA+2qCW92Q2Y/AFUsKbqWC3uldXSr5M/+hbxAIK3rtsKFLH2h4DMJ9C0BykSfjP6VS5TSxXee6LykmxzzxqsJGFbBUOW7PB4faIRSZ7tentZhVGiwcW8IpoHpApTqvVrCLmNyvzJvzvcM7h5Fyeo6FRKH4jjneE0XEauKmEoupZpstZc1ui3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6tIBFt3KFc/oJk4JFkTdbXC0qP4cZuhH8L/Lnt6I/Y=;
 b=oXvPvDTLl+uETMDin5wXfG+9kFuEEigMScJZszEM5pNN3AkShIGs82wwjaXZ6+379XDFX+Fg2L5KAC1NnFIoQ/ujnBF9MjxCzqZ79KSB8CmTqODXhsmcBportZQropU3cuwNdWBYjR3u95h5FS0/NOYYPmT3eU7sd0Rjb2vzo1Y=
Received: from SJ0PR04MB8326.namprd04.prod.outlook.com (2603:10b6:a03:3db::16)
 by SJ0PR04MB7581.namprd04.prod.outlook.com (2603:10b6:a03:32b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Tue, 21 Jan
 2025 09:17:04 +0000
Received: from SJ0PR04MB8326.namprd04.prod.outlook.com
 ([fe80::5088:5f08:45a0:9a8]) by SJ0PR04MB8326.namprd04.prod.outlook.com
 ([fe80::5088:5f08:45a0:9a8%4]) with mapi id 15.20.8356.017; Tue, 21 Jan 2025
 09:17:03 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 1/2] zbd: do not check open zones status and limits when
 jobs do not write
Thread-Topic: [PATCH 1/2] zbd: do not check open zones status and limits when
 jobs do not write
Thread-Index: AQHba+AFB9fnD9Ej/Uq0FbZMbFYYMbMg8rYA
Date: Tue, 21 Jan 2025 09:17:03 +0000
Message-ID: <Z49mDl_xUPaaan8t@ryzen>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
 <20250121083913.1216619-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20250121083913.1216619-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8326:EE_|SJ0PR04MB7581:EE_
x-ms-office365-filtering-correlation-id: 626c1466-3348-4499-46d3-08dd39fc5e51
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?dXldioEF3vKwRGVunY4rj0AobHg7849gfaeluhvk7t7IGFuQEPNWuVJHR0ce?=
 =?us-ascii?Q?USxnVmouLqsBRK1EeHs4fBdXZZ4PDMhFlPq3wcEGC15F6EPGdbKCxsdntvzL?=
 =?us-ascii?Q?KGTGS77u5U7YQeGMTg/jCvsIbsVNX/gfrb2hfKKP/b8F4bKQCzMIfNQDJEiC?=
 =?us-ascii?Q?FXvB5XjEDRnetBYXEJGXKEJNPTIBSs5up6nkLTrRSssXdoRQRYiC5vKjwX5s?=
 =?us-ascii?Q?2gwCCXsHG/L1OMTLWPPEX6dil4TBcNoB1YzML7W3c1ohGRl5jyGWke5cTKQ7?=
 =?us-ascii?Q?h7e3hzZkox7fbOuyfSCaK2k642k+xyV4NnkztRnOLFIIgtdTNiCFc3lo0J5f?=
 =?us-ascii?Q?3+AQMmIAlyvi9Y0E5wR+9pDeNDYoStgrk5G7RSLTdjAfSCaev3+6G5IXRBOd?=
 =?us-ascii?Q?eeR1SRlmLv5F2a+UxC471rbp57kI5ixM+fPki6wv9feFF/s+iKPfZe4LEt45?=
 =?us-ascii?Q?nkFjIR7n19sD+VwwkvL/K2arbf9kb1ny0pKLaaKM+6IgX2f8Db1bjLMXs2YC?=
 =?us-ascii?Q?91rxl4pAUCTvKRQgLZEAtBuq0VfxYujCDArbQr7hnwCY1Auqt7aQ9STyIsKB?=
 =?us-ascii?Q?lgi2qvYoNDifxqAeVYpXwUNCZYJYbbnQMa0C3aADMxYKWwz6fuL3ce8q1XD4?=
 =?us-ascii?Q?vVjGfh51hDwK+nH5qNCLA0Ui0HKEd4uy8GQ8WK8uupIrQfTd6H0bpxP0pQq/?=
 =?us-ascii?Q?W0rCu0jxhy+xHmKdJijXXdAwIjNEJXf1la2QkLNYZK7WhkBRVSe8GlJcrAfV?=
 =?us-ascii?Q?Wom9EVRjAtoRv5zshG9xSH5tCDxIANyoLXahJxZ8WBgKrT9ujIiOYlO/yo4X?=
 =?us-ascii?Q?pMvX2/oPZlz2KvllsKUXjY0nLzeD3UD1uSFmAiz6WAmHGnvc9/IxWFB9Gqw7?=
 =?us-ascii?Q?NRCSo7zJn4d1Y4hzaEpkht/b7ARkijHGziHmQ1YHnU4wvlufxeRR8TdNyBHw?=
 =?us-ascii?Q?ThSyaFMCbHNJucchhCZtzNunHsdWSr8W9c86NhXZtzmISzQit+9ycTDIxvdt?=
 =?us-ascii?Q?SkrFRocTYYOBrmtZeNQ8QQ9CYCFzsE06hJN2+aNQYPm8pBiuV1tCyzmLhQUn?=
 =?us-ascii?Q?m1n/ge4+NC7yX6qf6Jyp9ia6d7m/b4OxEKHHd0ygXYQhMNkVuYG6vaRIBiqf?=
 =?us-ascii?Q?lwTxXLmRe1KZ0IdrVMyIqN1KL+XupzvHuaYr+XLoUuOn3D5A9/2N++52VD2F?=
 =?us-ascii?Q?whW5CKyOyGO5QNlS6U/UK7SqMx1zRxmzAogYCprqjWTmzfoIvSKCImkGHPY2?=
 =?us-ascii?Q?LfSmFzjCUMv4POqd8wH6zkeChyBy8kEEzTbMlkSfDaNehO7PzklRVhOhvyos?=
 =?us-ascii?Q?BnD7h5d9M5goDo4IxGY6pF1uNkTYVS9eNRnPRXqgLUN2ve6fsRwyFw4Us7jD?=
 =?us-ascii?Q?kyb2OIpvaq5rD4qD1CqUEiKXdJh//54q5/ryfdefIIw87V3xwzL8t5Buwn5F?=
 =?us-ascii?Q?X0JYG04NmvuKJnQzxws+Yk3t8SdsfnQG?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8326.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iB5BZVNKhb8D49WK/OKXvdlLTzzeHSgXptgNANy+sx0sUTxK9X9mFuqm/5gC?=
 =?us-ascii?Q?o4ZSkYYR+x1OXcLjutGHgIMa3basLTCnSyj0jySqa9/v0+qB3hqltp5G5alT?=
 =?us-ascii?Q?gI7T7f42lDicff3yDiEEom9RVOcFsTEEShqERkRK20Ksw7VNslzSpjGDRyB4?=
 =?us-ascii?Q?CpPXdPavSDVC5ZZ3DwclRzBYTZNoYVKmy1sgPrRhO8gWMXiUb6Z8noao6wHg?=
 =?us-ascii?Q?N3z6QEreG6CSdWUnuXuJrHwpewTJnxZu2gt3OXSpadJQ8Qh1zbsnQhfDIT76?=
 =?us-ascii?Q?MvC0dkm1oWW+mzUL0vKxhIAOc5mAu+Q7mct80pVRJqRsr8PgjO4Jvw/kDPdz?=
 =?us-ascii?Q?jHPNiRsaMUDMz8dRHC3Dy6eKF/BcfC0+b0AB9+knATx9Tv9nmkhD+IOigQUq?=
 =?us-ascii?Q?K470+2r7CKi1Kpj77bi47i5V9hdD5qHqEjJ+S8F5gQERIpfKg8CGQfZfHz3O?=
 =?us-ascii?Q?DSs0yiW3e2cM6V2xSSYYJT1ZzK488t1W0ylbXcEwQvAw8wlUlLl/wxA4vdOJ?=
 =?us-ascii?Q?M4bTCJje+eVGuys4H0+S63OWkSDDrzYiUpLtYRG7A68Fh6T1LlRGlgHsu/+t?=
 =?us-ascii?Q?m1OxJlkuT+k81vJZnCWbw4fmVAirU7AQsclg8iHYwYn1ysk0YpeqeCbLCS6k?=
 =?us-ascii?Q?dgLAQwTUWkB9d2DNSIyrg4+7QyBahl0quaE31URomuIPeAtGjEMXAGfWtAxL?=
 =?us-ascii?Q?nasSICIoG2+9DJTkIgfV0rL7kb7E2HW4/bOvjTWMHPERG1RcwRbm1v+GfFAM?=
 =?us-ascii?Q?ujz8tn0i8nSC+4CeEnDeY+NyfRPNzXiTCRlJojx9tIgp+ban/jcMX/jYlHNY?=
 =?us-ascii?Q?SnrOyZdvyzLI7QvohyQUL/4zbcd7aqZAw0HEfTyWfo3FUQUfVILOumLFHZ9A?=
 =?us-ascii?Q?lmgoNSeae+V+0Hj1C7spUbdq+6K/egAvhR7KG7UaABEsrIw/itGSPg9gStyo?=
 =?us-ascii?Q?+yUV3JOgrqamzz6GwUszR0WGAm85+A+Lx87ocmUUf01Zj3PiLw+ckQYiVSjh?=
 =?us-ascii?Q?gNAxxnBzvt3zwWrk0kEL2aprbdFUAglfAZrcWcP8RwRSQ6p3QsixaNVdEfHC?=
 =?us-ascii?Q?9HXOnIePjtIc3zRFkhlqgYHczR+SpCI67wpanMxwzhALZVcYAoBEY+JHiC4N?=
 =?us-ascii?Q?4QH8Vrg1ENx3w0Ps+W1hvEA46viGFaGkt7LLrNFDg6NDzNSq1H6DZqhXIV4Z?=
 =?us-ascii?Q?pAH4KyhaFFDax5U0djM6+UoQ3Tfag1eclQs+ukhGt5sbSdJzDAI/gKhQawRi?=
 =?us-ascii?Q?MsWNqsYKK05CH5VoYmaRB2WudZHQnZBiQ05CxkcP8pCMEOW9/TLUubP7akiH?=
 =?us-ascii?Q?cPK6+6jafS9sXGpickmPmEhXgWc2pDDSS2R3+ABEFmPPV1VvPUdOTlnXo22s?=
 =?us-ascii?Q?lkxItNcty9+tsU+eIlDnEqvTWw+rKrt1GCzxPy3dEushGVCeANq2cGgDLGku?=
 =?us-ascii?Q?EpvaRz2saFtGGeug1Y3yd3cOinevE533KrMNu3TO1c5D5GZtBQ0eDtnfYkah?=
 =?us-ascii?Q?Oc9ZrneFtsJYHLPlmEgVmMeHbdwd4WwFoqahaqY+5GGrFotfA48vHiWurnHl?=
 =?us-ascii?Q?eIVyu1cmc5SskeYxtyWyoK3XmXeSU1QVq08oROzYtqgJi4peC4dNbdDLZNBJ?=
 =?us-ascii?Q?8A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4841A4B6432F904F8EC0A90BC059F9CC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FnybO0CHocFlbRgnA00zcBLPTb9bw4eOQNQY45WUXtpv4J0brc+khIa2yYXKhwWXedCo+wD0vTaXC40wl0wklXWH+DdFt63CQfo9jPknirAROOM+9Aav4MYTDo5xWs4taF1D8hyK7wAbiVFrPfA1l7dFuFkPEO1vkGGJuNofZjxow1CL3wSya7EzbY0qEQymeB0OnXy+OxPlQQth3xMRA0eJthvUbUFJ3CAk5/Ab2i8Khi+m4t70diRg+/dRjiv9CrprHwfx7jA+SjnYiL+lhPvWqK5baOLwmYfwfV6eZXxJSW4av1EuIImOmE3EqG4mGPc6HOrRHfYqPmg5HJN/lcMQSj+COEHv3haW/MPe2Uw9nKXHfhvXEwq8plG/mJMB2ISasPePKyJX3sZtlhpsaLhIZVJHGeOjO0QF2WsTYu9F8UIPSQtH0DHkDMICmA+GLeCF3KRPJ2e1YvJyqel6QOfawqBoTZD5mgYLB6Xe1dvEvclTlHlrvyPuzsQs7ANCltwdzEJkEQQbJ3i6mGjbrIhXBkOP+up9kIXqGN/AOKO1WIWc7xLM9R6b2uNc+EUZwe0/jyW+uhC9DPrD7N5KbldHD3pPxf33QML24h7/xN5XtEr1H3hYykJ+B5xK3qAS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8326.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 626c1466-3348-4499-46d3-08dd39fc5e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2025 09:17:03.2988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vlL3oiGVm2wdnUwZ1At7gc4TW3wmfwkzSABfHCN9iWqRCACPWbYPrWRDILKfLzO1zF3ew7wZCc60boCTjwslg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7581

On Tue, Jan 21, 2025 at 05:39:12PM +0900, Shin'ichiro Kawasaki wrote:
> Currently, fio checks the conditions of each zone within the IO range at
> the job start. If a zone is in an open condition, it is added to the
> write target zone array. If the number of write target zones exceeds the
> max_open_zones or job_max_open_zones limit, fio terminates with the
> error message "Number of open zones exceeds max_open_zones limit". This
> check for zone condition and the resulting termination occur even when
> the job does not perform a write operation, leading to confusion among
> users.
>=20
> To avoid the confusion, skip the check when jobs do not perform write
> operations. Additionally, print the message to inform that the
> job_max_open_zones limit does not work for non-write jobs.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/zbd.c b/zbd.c
> index 8a092cbe..ee095b1d 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1264,6 +1264,16 @@ int zbd_setup_files(struct thread_data *td)
>  			return 1;
>  		}
> =20
> +		/*
> +		 * If this job does not do write operations, skip open zone
> +		 * condition check.
> +		 */
> +		if (!td_write(td)) {
> +			if (td->o.job_max_open_zones)
> +				log_info("'job_max_open_zones' is valid only for write jobs\n");
> +			continue;
> +		}
> +

zbd_setup_files() currently loops from f->min_zone to f->max_zone.

Since this check is now skipped if the job does notdo write operations,
could perhaps zbd_setup_files() be changed to loop from f->write_min_zone
to f->write_max_zone instead?


Kind regards,
Niklas=
