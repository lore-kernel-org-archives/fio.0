Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417814A06
	for <fio@vger.kernel.org>; Thu,  9 Oct 2025 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759974608; cv=fail; b=eWbxC8KnOgRQW3RPrcVhabDV/gcbSDofcH7+dxHN1JOhykr7NBMNBQm0kkD+u9yd+VKpGf+j6bMDDSXlSk6xjwb+/Jx7ITzDcw4GsryqQVZwQjRXBO+ReHrZSEhSuGZ22h2tC+xxWryOVHeIP1x7YLvAl4qTnDvYj3peoHNXwYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759974608; c=relaxed/simple;
	bh=eo6Ty/eNMNwNRjzqXOsuCWJ5xhrY1SfSAz0Rhxou7C8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z0Y/OPUTXBuBFff6k4EKotu3qOf+7GJq24+hYGIHuEz1juWL/Q9yfI/hvmoUaS8ZcAVpKRus1nMTKNd1GOIXY7mrAhKher/q+Mp0vCja+A7088Gbvd8+A/xkmbesyNipa2IS3X06C8/0OHxv4oXsaMlPZ0b8o92/2cFTkYet7V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fcsyNsfH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=f8mXcat/; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fcsyNsfH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f8mXcat/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759974607; x=1791510607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eo6Ty/eNMNwNRjzqXOsuCWJ5xhrY1SfSAz0Rhxou7C8=;
  b=fcsyNsfH1jH8oGGZ/9g9L8Qg6E+PYszWv8m1uCsth4eKLbnXScc7tywt
   RNAa97R4C3unnHhA0mKueT4Vc6oZJjBAwJuxkTk2Dw/3jkQKAQMbrmPvI
   rdmB2uJrwbIoP8vvhPKtIamSs46gmPojQxoMu7y4vXb90QoYSYhN5VrxP
   ydi9mWnslgcbmvRLygedM0bMHo7ZKI4bqeLnhlW134gVMQmEDADE3fCJE
   w81/IIBh6H17UJO/uk70hNCS9CSUFlG7Dy3qy782akwHfjQG+S/jQ7TLm
   +6OrKyQMe1zLbxpFoLnx9mfHtvss6IhoVTxtX/xh3IS8GXokYmViPKCrd
   w==;
X-CSE-ConnectionGUID: 8DQSojVKQzahC66lCGTmQA==
X-CSE-MsgGUID: sudhwLn6RvO4eQUqg1d2tg==
X-IronPort-AV: E=Sophos;i="6.19,214,1754928000"; 
   d="scan'208";a="129889935"
Received: from mail-northcentralusazon11012015.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Oct 2025 09:49:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojLuek0xtm/y7eOGRpAe8nlSCOk7JJDqzG3EakLD8eXwZRSLGBeWh4+/mMgaTrywfhIQX+RjEzFgjQblziv8FuctPMqT6/fwXx5ZcjiPUbRNgdSC3qS5OmqN7fBai9vOejEanC7wFvNLPIAa31sKeioebrzYigmvfHkmVJLDPcIrrQx8wpHTc4z0sPMhoTtiVkLawMlMFSYLHBOzo/Wq76bFADtBJJHK0a8vr7pNKCpmepKe5LpdT/rqCoVPn1awibiToQsAizcHj/26WcS4t8om6zRNLHJY9mlhFMLp7tHnaVwM0X1TnfeqDNB+NWttM3ZoDcbb2DdRaKFPG7P9aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eo6Ty/eNMNwNRjzqXOsuCWJ5xhrY1SfSAz0Rhxou7C8=;
 b=B0Cr7UitMIHQtX+UqyRTsDEgv+9fB89OYtB3T6j+mDqMGKjjLHRsUOzfJ6NIwTzeMn1ayXy3ewj9REE/NhYZYz2yeBfH4EXHcVqAwFWfH0LtxrlpTUpT80LLd8P4ubjqdbgHfmGmeon/nUzOEfSqbOzzcWTGeEvHCeWpmlP+l9LaQqAnlUCoiVI3r7nlJNueQLx1IG3rTLWstwyQToSg3NOfBWNebLhf6nQT3bjG0hsRIkxu0wzbzsEmT0oOhbymUYnhR4DnZVN392hi2HIwCq4x+xCL5FV8Nz9644V4s6aHzSvB/hX1vm6niKkOYeifCPgkfSgtjMp9G0Cngq3oSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eo6Ty/eNMNwNRjzqXOsuCWJ5xhrY1SfSAz0Rhxou7C8=;
 b=f8mXcat/p6q0j5Fe7PIokn7a9vrjhmK5XoIHUq2FBX7vTGMc/Nk5ALg4Cxh5LpKDk+4KuWktW5kLmmagJGY1vErVslAAS3jUKYS/Y+JUejYKT0oobEUQT9mDD209bKzA9+yEtUYVcBvJZ5kpZBZegVhUdcbarwnFj1lVsrxRGG8=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV3PR04MB9066.namprd04.prod.outlook.com (2603:10b6:408:27d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 01:49:52 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9182.017; Thu, 9 Oct 2025
 01:49:52 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Vincent Fu
	<vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 1/2] stat: report zone reset count only when zonemode is
 set to zbd
Thread-Topic: [PATCH 1/2] stat: report zone reset count only when zonemode is
 set to zbd
Thread-Index: AQHcODjDka1oiKF5cUSJa1wrkloR1bS4TIGAgADBDAA=
Date: Thu, 9 Oct 2025 01:49:51 +0000
Message-ID: <xtbr4pdxvo66ji5z6eugr4ypq2xfa2kjvhprxh5ikc5z7usnd3@fyja5vm2sc4s>
References: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
 <20251008094847.1628954-2-shinichiro.kawasaki@wdc.com>
 <12d613cc-d77b-4efb-99da-94c67a33a0ff@kernel.dk>
In-Reply-To: <12d613cc-d77b-4efb-99da-94c67a33a0ff@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LV3PR04MB9066:EE_
x-ms-office365-filtering-correlation-id: 5596273d-fe32-4dae-c35b-08de06d6236a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?n3V78ZG+hw0W++bH5Bt63UZwL0CGbJt6nMLFbYRd1VYSYKEe2fio1i/gAuBq?=
 =?us-ascii?Q?cAzwWTwuJPn0bvBSny1TGfzsVJOa26Bk27H1Rz00PWCrkieSjbx5S1dsqCvf?=
 =?us-ascii?Q?N14Y/Rmk7End5eCia4DE7+xKodU6GoJWrIscDJHODEzrIDNeo8qmeCIjdWiq?=
 =?us-ascii?Q?abF1XdGZJi/EQrNGp7Iyza0h+rT0ZNHD0R6qL46mAyGIqHmZj1m5QSCI+/5j?=
 =?us-ascii?Q?8I2997yitI3I8IBygazZjKW7moL+q2CT+fBN3z3ZQJpSfStMFPh5n0LBlqZL?=
 =?us-ascii?Q?6aeLiH7oyEtHJqZNxzs9Skqh6j5ORZOAXFqfsE5XK3ISs1Olq9T7sBx3VH9m?=
 =?us-ascii?Q?HNRoOkUwLIEDdJvCc/aAje8AXS26excAgqSgqgyqwrl27bGs0JbxoUwYNjK6?=
 =?us-ascii?Q?nSlE3ya6dHYfw84DYBDA2ZnOCmwzWGhXlCzEta7dKFNW8SYwYxCdOrverbP1?=
 =?us-ascii?Q?CotjHp5WibzTTXyhNyP+qLoMQVPWgw/jMln3uEFQp97pZiyILvamcWg9wZuq?=
 =?us-ascii?Q?jKfqysWpQhfSuNXmY/3alLomWOSAK1ketcAnFRJPl1ElC8LuMUtC6WWBzXUo?=
 =?us-ascii?Q?khGy/BwOmfxXy+L28zeKKfLLvGhHhdU2H02Q8kooApbU2/Thp++CYEVt4jSd?=
 =?us-ascii?Q?sHipA1VInWvTUkE8lMFZRO7y6+gnMwzAiywxGl7S91IuBjnCXMGLycBA4RUO?=
 =?us-ascii?Q?rE2NGADOABykRIs6cL8EknbwNqNTNs6khhykedpuH7ZhXe3GfpZn0S2BiJS2?=
 =?us-ascii?Q?gVAZnVWNEm9lEEPyErRJUmmf58tvkrfMKacxfk2fC0syD26KZwpZg4ED9O5g?=
 =?us-ascii?Q?cQOjaYkV5jZfX/xG+8YCBgcAEoTemwFfMB2ashPyKUvgKaqc2KAZ3vb47zXl?=
 =?us-ascii?Q?5sQXFH02uWjM9GmXXtEpoTFn8HvACX0cBWYi+aclTX6WLB1O0pM4JrGdwRb/?=
 =?us-ascii?Q?l83WK/PmNScpLEatJcPOpmw0IH//wYE2Y6lAHQXBiZbx+lKp2kLF5n7bNPaZ?=
 =?us-ascii?Q?k0Hmh3yru2Moa6fHw1zMG/SfprXsH6BStQEv/MZ98iZPxFY1dPn0/bLaeFlr?=
 =?us-ascii?Q?EUrqvCyXX0rXPZWTHcOrcIRyUgI0maYP7BVMwPFWmacRVCeBi+4eWpEkO1Gd?=
 =?us-ascii?Q?4ZlVxsffijbkS5k4QsZBcAl0mDo3HSDrrpmWPIrwRdva4PJD3iD3DIilxg+N?=
 =?us-ascii?Q?/vMFff/l0cySctWN5AC692A2FWZV8LxKnhSfssarWVRad1qA2TGZUTTpLnY5?=
 =?us-ascii?Q?u+ZMdjaWH4X5qbylG23fJivKrLq53AydwixZZnSId1wMrH6tpFvWwW5UhXi2?=
 =?us-ascii?Q?/X23L3GglT61l2dwl/mYVMENiGrZ+qEAGTzL2EMvEUA/9dRlqqk7RMsgBv2P?=
 =?us-ascii?Q?Q16NUluS4KdFq1fGK905ZLrdVlrBA2/yzilKJJlrAB1vs1DfJTa+JW605AyH?=
 =?us-ascii?Q?EJv+WLNaCY37ek3BDJxG//kcpvwrR7sKUZQ4z+zwoQye+isquB1mC0ti+QJ6?=
 =?us-ascii?Q?WWl0TnXLZ/sKjFcFEIb+/HGyweZHjieFS/sI?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?LqHNdVpWAQx9/5mR8uLYNPY6YjBB5X94pcsn+3vCh7q6OUFU8OHdLqrpnG9n?=
 =?us-ascii?Q?BazGAE3vQuZrgV4tVE2Ri/S5xz2RApcb3PgvL1paD99pKoXFunw3p3zDJB0q?=
 =?us-ascii?Q?zhUJpIkW0TG4dG35m5Re+Q/q+/gm90Z+8VmJb71aBeME/JztmJGSQB8lthcr?=
 =?us-ascii?Q?wgTb4otBO/EG9j9BXX014TBUEwNzCbu3s5yTLCu08Y+QRgcB/eXCgn8VExSn?=
 =?us-ascii?Q?MpDiRiFFkIi0l8lqCUWlDSxJyJp+4rjWZIG24fMxLzkz4juea50FlN3OZv6n?=
 =?us-ascii?Q?xfieZPTZBd6YX3IBQOD1DMGFRa9/Ne12vdp4TXvH9Frb8s2EH8SAaNdBrBbW?=
 =?us-ascii?Q?ePzIe8ybBS01UCb+F8HwsdeM/AlpTDibaGu744iPi8Tlm00jMlzhanduW68q?=
 =?us-ascii?Q?FUxeBij0/4VhSh5dmo5KfgDqY0+QAGEPTZqwmAjDxGO2EI0wsLSCQotZJsBM?=
 =?us-ascii?Q?18FyKGEJrbpC5OXTjImh+sAjD5Fl5RvVoxqBNEG3IO19GybNAhdqL+AHilMh?=
 =?us-ascii?Q?wSWrop+aEBBLh9CPDM9vYW+N7wxWmNKBvqvolKyZmhJWIKGgELRqTHJot9pH?=
 =?us-ascii?Q?xtgPQI2I2065JdZOwPmsy6HPl9eenqy0aPOvOWkLM3myLzLZh8mJpG/hBBHc?=
 =?us-ascii?Q?UxlGh69060z2/PzwtlY/KaNYeCr9GFLCeDsfc8nlANX7aDqoXNIwh8gEhYty?=
 =?us-ascii?Q?Z5Y6EDdDC1PDTc+5JuLtaZKN8fSvVq6cNi92RXBJu901JaGX05nKxpoAB+cx?=
 =?us-ascii?Q?YOl72FtroACPPDHKP9YKQlHRVY4IaAwqoauiRZXFSoBs/2rpvVUZxSGBaluD?=
 =?us-ascii?Q?WMF0R9F05AnXQihsSKkYKEdKM+/AJBIJmiqPu0pgkegvoKyRRiSDxMsKoPca?=
 =?us-ascii?Q?4ty21G2KfXNdVT2M3v18XCp+XUatyRmYTQtR7jWXTb2H1ODzHivvvJWUKNqN?=
 =?us-ascii?Q?zxZvX+0V3Q2NMdZQMP/rDkbBR1I/DZv6r+l1NeH9PeB64WP802lLJXl30BjD?=
 =?us-ascii?Q?uuJvQ+QcX+DcumhM9cnu5zZhc139wkzZngq0PuELBcVCD+2XqvB99BVvIhMQ?=
 =?us-ascii?Q?TB7ytapRG3p2zyi9WjMg3f177JOT2XjZlAC48ejRlfvfeZfXYQOUQZJh+w6t?=
 =?us-ascii?Q?biDZrGreqe8N6GHs5Jqrvj7en4XDUgBNewhzGfbGFUq1Y0v2uq5u4HYgJzla?=
 =?us-ascii?Q?LMvJ+daF51qfDec4v8RJaY4bdvZKBwJNwYBrrpPauYFI2DPN+EAI0pduPRNo?=
 =?us-ascii?Q?2xRv3WMicZgwHuH3QRd3/Lb66gCIETezA4BpNQobVZctefwPyuI/FZ6scO7R?=
 =?us-ascii?Q?WL5aDvpzP8OdsXxq73B4dGsSHq9CprvhlAmj+Dma4ezmD4pMvCfbvr9+MZsp?=
 =?us-ascii?Q?3fxrlipvCy0u5B5H2ZU3/0wEZH2KS90q5KvpE5CoRiNEp952M8CW3le+juH3?=
 =?us-ascii?Q?cX5oEgqRxL0qC4QbrdrflafW/U+GXcrsFiuByWZ4M3h5f/n99nxa53e+KUmF?=
 =?us-ascii?Q?oqAUwGt2/LFF/b5/KNh2Szj3izoE8InUCNaZ3y4WIcrqpr7CusdpQU9l1ij6?=
 =?us-ascii?Q?pg/xcxQKypWHAtrZ4Cce66bo7HXImxuAoHhE9v/C/iLUt2Mx9Ltrjf0I4BDu?=
 =?us-ascii?Q?IG3CxxYiuPDe0zqK0dXXaEg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72D7E449662F3C4F8B5070F615129B61@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	all7K0he3+EABYtRdMcHCnbNlceNJpT7B9E3TSIW/rOgK4s1RyBZtiDplAyIoX0JUjM4m7P7nxjpih5EhQvmseHqA1K9D/D5bMnEBnSB3saRrr5+qpX6Ma5KfgjctUDxf2ewcY5XiXR7C9ia2up743WaG1T9huTo+T5/vdJAEF81klov7wlE3SToV0bCCECKgDU7YXfZ14+Clsz7ZKZw7FZZvX2jg4S1g5/sbpNixtv2A4wRCmasTP43eA7Fh3C0JgXaM6vY+Lw2Oyz0Ub1DLGw2MOyCI8vY5HtSTywaPB6OyCnEbuKUlbLgDVmiqvdlUPHfIsM9RoFSuJThnC8ZHpmUl6wPi9N835Q4IwBYHrbqgmQ7SG8TOwsUpeRUM/MJjlbF4q5OfzXiG7ibMCRD0nEvL57pjYbr5FXyAsBw/OoBV3y+Nm+T7C7M0OZep4sJlr94rOaV5UBwmazovgkevEMK5iYFbLlas0cnVzABWTJEV4oHfaQcvIVuBaCgloKtd/B5MXxS+XmoT5uHx1i+Qni13LPBmjwhNzJE5OYfQ3Y+cCioHQhVhdIIwmBcyNpUFno2FaSGb17qrOfMvHGBXWa7KwfeN46himJRr9Syn5Syzdje/UeRjiZzVIb/+VY7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5596273d-fe32-4dae-c35b-08de06d6236a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 01:49:52.0077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ckXMVrNLRbJU94fqaIWKHoY0X6YLDXd060/51Kibj4d9lOLol+TWM5UR7r/1nDxS07GBfzbFhtLL35BPBrSrvdiVC9QGGhsMN0JCSJXMzYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR04MB9066

On Oct 08, 2025 / 08:18, Jens Axboe wrote:
> On 10/8/25 3:48 AM, Shin'ichiro Kawasaki wrote:
> > Currently, fio reports the zone reset count regardless of whether the
> > zbd zonemode is specified. Reporting the zone reset count lacking the
> > zbd zonemode is irrelevant and unnecessary.
> >=20
> > Suppress the zone reset count report unless the zbd zonemode is
> > specified. For that purpose, introduce the new flag "count_zone_resets"
> > to the struct thread_stat. To maintain 32-bit alignment of the struct,
> > repurpose the existing "pad3" field to allocate the flag. To group the
> > related fields together, move the field "nr_zone_resets" and
> > "latency_depth" within the struct. Make corresponding adjustments in th=
e
> > relevant functions fio_server_send_ts() and convert_ts(). Set the flag
> > count_zone_resets only when the zbd zonemode is set, and the workload i=
s
> > write or trim. Refer to the flag in show_ddir_status() to determine if
> > the zone reset count should be reported. Also refer to the flag in
> > sum_thread_stats() to decide if the nr_zone_resets field should be
> > summed up.
>=20
> This one needs a FIO_SERVER_VER increment as it's modifying thread_stat.

Ah, I see, FIO_SERVER_VER should be incremented when data structures used
in server.h changes. Will send out v2. Thanks.=
