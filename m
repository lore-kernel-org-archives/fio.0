Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A1E1AE005
	for <fio@vger.kernel.org>; Fri, 25 Apr 2025 03:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745553087; cv=fail; b=aXmbSsdOZEw6Rf16D7njguQQNLqlrJxGjIiduLRy0GnYFzHTu2bzwdFi+OqnnB5u9Opl1EXQ7n7hKvP7RYE9RE5LSPYuILDKoRvTxpfmEfTXi1hp40mGOw4JwoLOTwLAuYtGblYQ3NJPpDubEhjiudpbGPWK7+Yk1vdgtUDTov8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745553087; c=relaxed/simple;
	bh=ixvnwBAxd9pYmOpleqDOTr6FZCXDxeCZmfXKugeC7gA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ADreuFeXoltmrBWznRUAphezpyqNIjHV0AIQua5uP+8QdhssDkVBIWxkPTuFy8A4xPHp0AfQw5dTK9nXIXmMUPVaMXq+tvakFj+DC2f/6X7BpcpgQKrCFtmcDfvj0hdZ/oGQI8O1mk7K7vbfHIhCaPP4DbOkfAho/Q+qu4xvR3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iOBaCIie; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Lz1/zU+D; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iOBaCIie";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Lz1/zU+D"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745553084; x=1777089084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ixvnwBAxd9pYmOpleqDOTr6FZCXDxeCZmfXKugeC7gA=;
  b=iOBaCIiefn5mN23KpySJtahG0dVbJZTTFTm5oMTCDbWf7l0C4Zs7ZaOE
   f4b7HQs8bINy6q/Ch5PDC7VOkS9OaYxfEw3w3DY9BlIyBNmRdaoi1rp4V
   ++pvve4hHXRI6pXVaypixMgheenPXnQrxze0VvLzyB+JURj70AtoWS4H9
   +iydSlV+sE7qyldv9dCz6jw6cI82LIqIEaQnoGuXd/uWHbfdk6zej9dxm
   DIhNq5oX5gy7EawTy/MHvW81SY7bE+oapMa55O919w3sllcwJPFVOOaYo
   SEkiR9LpYzJl7o07M2JhvI5PJ53sSJY1tIf1kpdV7TAmap8Ps7S7Dry5Y
   w==;
X-CSE-ConnectionGUID: Nb0V2r3KSPS915fkt6xupg==
X-CSE-MsgGUID: 4jkI5DlfQj6lgBq6s4zTjw==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="76450946"
Received: from mail-northcentralusazlp17013059.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.59])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 11:51:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGOj6y84Z2V/YFTC5g9WvZpVaXUj6JLLrNPV8yWnkv4hhRRlBycKqYOKW4jBn3HS/DGbnJ4ADp7hYzO+hTECsx0MsEyJojvJPSJ1AJ9LK4BQej7Ek1WXxw9a1ozG1SH1M77wZH55xs4AG63ySR3MkkePt1+2+rxTTttm5+zXi+RbRk23rWRGrwe3EE0e9TE0WPavwd6hyBqn8PBBnB7O0ME6K5gEJCJYNkpEnnR6ujmomY0x2zPfmiPfyyAPNir9UBm2WShCIWx/09IZGAsw+GsVwHVCFOw/PdHqPYg/y8NuHWNe2lrfz4QXb7DAwPT38XdEvW6SbOvN2BYoUsDUFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nImq+SFwDg65A13kmBBoAaNuhwI7pfIGpMr4oYY0wM4=;
 b=xNUrXR9oUWIOU6ZG4ooFilkfEIV2Zcgmtc6DJtvklVAPi8k5sAjRVsm+VRoIXZlcdRoCmvFLzFudOFL/5Msh/HwJRzv5T3HSfW7/i48saj4a6stjYEtbWar6zuqRBuZLAMYH0Coi2LIw3OsfScB86V19Tsf6aki1TuLwJlsNZVLtr7NV44y7H8Y8+3o5DOFhQQqgpMGdSbGFkBP7WYhodFBuhDs9kpcW4bpauywL6KsVSKPcOqY0/4WSKaKJSa8WJxcXWqa1Ygs8JN6m+8i50gUsiFWfgAZhVP+QEt5nqrs2XbY7ZdoWABgDQAl7QXKp9T61AX4FqbxzI2ULTqdOgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nImq+SFwDg65A13kmBBoAaNuhwI7pfIGpMr4oYY0wM4=;
 b=Lz1/zU+Dh8bOhNcwrX9JUzX51SQn0hG2NKH2aqTMNL8kDK+OOGVr9ybviEd6XO0aojNc6bdACAeAwrowuDjlir6BOGtxrf2WZnJtMg5iKJIZSuyA4SXjXAnHV5qkXsblF2PmYzy+GQd9qQ33thwZdmby83b6MEdPxl9JwWg9bdU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB7662.namprd04.prod.outlook.com (2603:10b6:a03:325::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 03:51:15 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 03:51:15 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Vincent Fu <vincentfu@gmail.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 6/8] t/zbd: set badblocks related parameters in
 run-tests-against-nullb
Thread-Topic: [PATCH 6/8] t/zbd: set badblocks related parameters in
 run-tests-against-nullb
Thread-Index: AQHbsrpP0/wtPFa5y0KCD9wLiCbxU7Oy7m0AgADWtIA=
Date: Fri, 25 Apr 2025 03:51:15 +0000
Message-ID: <6av6dadluhxmhnt2qfk6kzyhvyimrp7bk4iwx5alvmfpc5vt37@toos36ixa5yb>
References: <20250421123828.82712-1-shinichiro.kawasaki@wdc.com>
 <20250421123828.82712-7-shinichiro.kawasaki@wdc.com>
 <fe51ae80-de19-40e8-ab60-4f02c0cd8761@gmail.com>
In-Reply-To: <fe51ae80-de19-40e8-ab60-4f02c0cd8761@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB7662:EE_
x-ms-office365-filtering-correlation-id: c0dc131b-fae9-4b01-1559-08dd83ac6de6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?kuYTNkTy3qarEBQxJHwi1HbD8IfZCDzUEbWpyWprSevvlvh0ALPztaVrKk/j?=
 =?us-ascii?Q?xgmrvBygsoyF8xHjllTzRKrr+nNDi6Dq9H0NuSF3hSAcrf5aYdvJNyZekWW2?=
 =?us-ascii?Q?dEcuQbC5MoRbBEhmFluSeyi/OBkmB7qNCmlBxCyha7C/gbTY284itFNA6Ee6?=
 =?us-ascii?Q?ihH8Vnjhikn6mmND/m3jbl+Zfc9IjwezDGDPIeTz4/C9G07RDxDZ5qEChj+O?=
 =?us-ascii?Q?VdjLD9ufl96DhkrKuTL93TgKFUAoV2QBnnrZQr+4XumTg/Uo4+CwH71PJXeC?=
 =?us-ascii?Q?J10LDmnWyudiD2ciWq9zj81cZW78+lsU9zswReARQWoE/9QsM+GjQsKKMpf/?=
 =?us-ascii?Q?3AuHwT1QIy1fNlDhW9e7opWhicN2klHM9nKWDViscrJHxedZDbe3sFJxzux9?=
 =?us-ascii?Q?ov87eLvGFebUwd8BGwPwnvj7+lfQbo90UX+hGHYPZbaVnNTUMClZPTmXDu/Z?=
 =?us-ascii?Q?EaT5EtEVo0oLHduYo+VXx97UmHgBkvi57wVonT/voQk4OW+VtZXggi+xMs74?=
 =?us-ascii?Q?IStunZYTCrKZ1bbW8ytE9BmrSoKua+glXgCtrjxdyVtpGmGzlsAidYXVHhC4?=
 =?us-ascii?Q?IvimBb3psM/YimVY0CJrBGBDLlqyIZU/SeGzKjha/iRIJs8BRuDOnn16ERei?=
 =?us-ascii?Q?ulQINj7+ZiV0uZVJxkPf13QiiRFgnJ/IUYMBLZVMsJbV/M+6cY8Kjo1yuNfh?=
 =?us-ascii?Q?m98hmU4hoeQvwmBvuUVbaEWnt45i/5t1e2nSdm7LixPsWgil7zoobWYzEzPD?=
 =?us-ascii?Q?rVvaW3Cat8/h9SEbQfY9DlPluC0MVMYCWy7bdwHNddv6H8gshSFQobFSlz9x?=
 =?us-ascii?Q?KORHkgWhLWQZX/6RrwyBef2t/Ew8m/S+FQH8bx+utM/ErGOcITkIFNdRxw4e?=
 =?us-ascii?Q?aAnNa/yHm7JURjC8mQMTJ6crw11UWfAFRFsvQRzTxCj13yNFsRWjwRY7EZPJ?=
 =?us-ascii?Q?w3G7eJsb3SIw+kj9oURpC+wmTN7GgW7cfNF715n0uQjpZ+j5tyg034njpvIP?=
 =?us-ascii?Q?HubMMg3XwnB4Z02LLEYPlx5+TURS5WSr9YLWvX7br0rgSE0ugt9WEMgpDZJ4?=
 =?us-ascii?Q?bt/UIh7bPq9e6hqDskDySy6e43TVUZRMiTlwpyejVv2W24JpdYblLGSX15fx?=
 =?us-ascii?Q?R07hWb6bG118vlKETxMpefOwkJXv3aV6+Qb2zthetWWZn2+u8YWN2p13Ela6?=
 =?us-ascii?Q?FostwbQvj3auO4dAikbbc5DLn8fw72XZ4UUrbPggdKYE7hU8uCQzgQNIEtes?=
 =?us-ascii?Q?84+sjtc2OC+fH7LDu33ryavWEuybveZHIk8Pi+GlJ0X34DKBux9bnC5IsfSn?=
 =?us-ascii?Q?AAeg0mrCXsoQI6Jd0Rjy+HHAwN2O2Sej7d46YqWFrIVzVbyOsjpXyIM2LvOm?=
 =?us-ascii?Q?tvENCn2GkDjLVakTm+AzYkvTURDXV9ohTBEX1R31Bt/Qnxwc3CDxD/J66zId?=
 =?us-ascii?Q?1SqkWwewcA8AbgkRR7Txu4E8bUv2hk8iWGpEj8d4o0TCOwOtbFzc1imG+HDP?=
 =?us-ascii?Q?bJRV9OFXkntaDyU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?wIqvTxscKJK3gFIJddGLNIF7YJTP2JsCUxpFbfOxoi2OlXgWboELOgBZBq0V?=
 =?us-ascii?Q?0iF8NfCLO4snVGLrFx5WqpniZicghIVK6BScZcUM4X/cdUcuLMVU6slGMVaU?=
 =?us-ascii?Q?s2YWNyCS1ADufWo2zfJ77q5EyDyCCR6s42jC0KY1BKWIOBHXY0ZrEB79gqU1?=
 =?us-ascii?Q?MPavAqXWkJghjBZKU0d3PCL+8NNA1a+dC9QIx83Y9olBbEIk3BFrY2srLIC8?=
 =?us-ascii?Q?DP0PRe11P/InORHNovntKQD50Ocbpniut52jQwScoQlOAbn9MPNbf1UOEExT?=
 =?us-ascii?Q?aG4ClcYlyMXcwomk7OyZu0Oh/vOE3boLo++XZHGRDlW57zoNcAwhgFAKmBvb?=
 =?us-ascii?Q?Zha+Fry42hmGB2YUoziy7vdH5Szk+Jq8TI5R/OzrL10YKX1VrtNc6gA7zI7q?=
 =?us-ascii?Q?jHvZdAb7mEsjwKlITnm/XxDO+e9nu87VYMaOCcwInoQYkcx4+smi1Iu7DeZv?=
 =?us-ascii?Q?UjKqVltMy2mMvxC5h4udOtFNVR0JXmTMBg3pvkjKNISN6Z4mTmlQZ96ihSEm?=
 =?us-ascii?Q?EeiZ1vcPwG6CIb/NwZpPFPHVhZw430nrb7DjRVWx8Lbj941djswQ8TzUMW28?=
 =?us-ascii?Q?Y8anPHGPu6wd+5aO+UycWpjwntji13xxL5lsum5YV82ZAWli4EfLf7wnrwoO?=
 =?us-ascii?Q?E0d2a+ij13SpW3x7FUZgjmZ0iFqU2ZaJxZ9CQ3dV/A6LXZdWFb9QARvvVw3P?=
 =?us-ascii?Q?yBK5RBvYE0ZMurUYurvcHHDXslcF3oq6nTW0D2Q6oQMbSZZ7sD6YzmiL12f4?=
 =?us-ascii?Q?o/MFEp/bbm8bg8G4UJeVeKjaWjRlqs878YwtDV+JCKk9xWdnPVga8yqG7vjl?=
 =?us-ascii?Q?ijt8IN1a+Mda7FGlao6wOdT0IAEOEm7RwOXXh5DYf3k9LIKVGc4MsU/8zSk2?=
 =?us-ascii?Q?+eZP3GKwesc0Nl9xCdruuwa51ci3sCf+AumtLJCocak2RMNbpWLKW0B8EmP7?=
 =?us-ascii?Q?p8wof1821tkq/8aZIZuzfgsE08BRyo+ZBphURtSJ9aaGMevt494GMXPztr1u?=
 =?us-ascii?Q?C6+bIxcPmGnh24wyM5bam0eSUXp51oGw3t2mLtiZqH459BPqkR13S3LmgR42?=
 =?us-ascii?Q?XIxkeqnyzc2bOQninYEO1+OQMMNM3nbaLf/Ag0SUmg9OuFP1hGrrTCwp0RK5?=
 =?us-ascii?Q?lIyuTnflXgOYBlwdvx3jHFj9oOMwWoW2UtlmmL+CNg+NKs2jCt6MKWzRA2W5?=
 =?us-ascii?Q?qxIBeUQckGBfuAGhRe2Gyyc1CtAHwwtuTqd6wqjIYZE8HceLwdZqni+YI7Ib?=
 =?us-ascii?Q?rYiqJUbNHZJquztD+F54D1MulXTzq0QkObSe9Iar3We6SmRkVzkhLcJPmd6V?=
 =?us-ascii?Q?vNRkBY9AlbafrYBvblbB2fuU4PeaovCPIMLkKqEsAl40N/AZnxzQuKZYfDOJ?=
 =?us-ascii?Q?a2ZcQxeodXfQzYPyEn6uegP9+wWRY0HqynGJs4xgQL1owTuMll9Iy7te9SMd?=
 =?us-ascii?Q?q1TEEKzWhIzLPoQEOHC+yEaAUcIL72GSxPIOIS0DGcm0bVeEF3MkSoptZ0NZ?=
 =?us-ascii?Q?eTFFt3eby4TfQaq6voHliT5SoESCzTL3c9le7+L1mjD5U8INmwX6Rzpwqnim?=
 =?us-ascii?Q?pas9A/XF0MxjIPDqeupw0bLUUYbxylmRETpNtvOhGeGwwZpIlVRB1QGNsqkn?=
 =?us-ascii?Q?D2y2IbE72neOwIVWHdN2zwE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <46E021B35027754EB8E8C739313717A2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4c5uezhgaenryZ10biWx9wP4w2gUqzKw8T41UIpYWZesSDQ4SHVrGkcZVamv75SAFTvKbQAtyrOXyie8da4N64g9AUPJYLpldUa5Zh3n0tZq0qWJQHLimY7WD++B+zsBjE1VYGuxuzrZvzZ2FKZN3FVX/v6ZzvFCKARTjbkAX9yiysi4JxhlnRfpC/FaJacF20rwUwamXWFVzxN9EHg+ldCKnecAp3QaccoXMuXCnJl50pWfL2ZdJESIX3giY079nhpgRJdY6WYRxslKW1K3CrYH3IMaJFs+GNdKuIE0hdu+fJQ3d4ZX9sz5+IWQWIUdWPgjJBkcTuGVwLqMRdWv9tNU2/qrK7ulnPRZmM0WbSVW2jQuXYgbJSUVdxW95rFXnCeXcLEN+t8wVr76klh1imaFl2ia6AnZljMnl3/GktDqhexFnCQwcmkR5Ya2owL48w2jX9WtaXINpyn52AdFKEazCB0KqTf1jlc79GZAO3If6MFxpCUyqxIjFJL4RZLjo2j/Ym/K1Hx5rWFgxpAEmTcFt3lX1BOlHIt9xA0LVhY1WWoJGbLvcd3xk7KLdfT/7Kz/t9SRYtx3NwqizD/ux10nkQHmgC0hSwaXhHVbrfz9NkFliWrmb8xL1pCOmV60
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0dc131b-fae9-4b01-1559-08dd83ac6de6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 03:51:15.7565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9v3fh7vJcYWCVG283hs6CCPPUfWp4dHnQmhr2oxBUA1SfhGlskdfh5lwR8lOMPrK07EJ3mX0TfQ/eiLbMnClWaVno522/yoACFOYxa9lNlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7662

On Apr 24, 2025 / 11:02, Vincent Fu wrote:
> On 4/21/25 8:38 AM, Shin'ichiro Kawasaki wrote:
> > As a preparation to add test cases which check that the
> > continue_on_error option and the recover_zbd_write_error option work
> > when bad blocks cause IO errors, set additional null_blk parameters
> > badblocks_once and badblocks_partial_io. These parameters were added to
> > Linux kernel recently and allows more realistic scenario of write
> > failures on zoned block devices. The former parameter makes the
> > specified badblocks recover after the first write, and the latter
> > parameter leaves partially written data on the device.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >   t/zbd/run-tests-against-nullb | 3 +++
> >   1 file changed, 3 insertions(+)
> >=20
> > diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nu=
llb
> > index 97d29966..f1cba355 100755
> > --- a/t/zbd/run-tests-against-nullb
> > +++ b/t/zbd/run-tests-against-nullb
> > @@ -91,6 +91,9 @@ configure_nullb()
> >   		fi
> >   	fi
> > +	[[ -w badblocks_once ]] && echo 1 > badblocks_once
> > +	[[ -w badblocks_partial_io ]] && echo 1 > badblocks_partial_io
> > +
> >   	echo 1 > power || return $?
> >   	return 0
> >   }
>=20
> It would be helpful to have the first kernel version supporting these
> parameters noted in the commit message. This would make things easier for
> anyone setting up a test environment.

Sure, will add the kernel version "6.15-rc1" in the commit message.=
