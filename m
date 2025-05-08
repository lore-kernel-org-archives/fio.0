Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAD41FC8
	for <fio@vger.kernel.org>; Thu,  8 May 2025 01:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746667740; cv=fail; b=ZUF0uzpde2g2+CrPoo/C3i+LD5Uqipdht48TdrDvVbo8okKUN2ADccBa+B/rAuyzjsli7sMAIuT2GPw0CLIl+d4A7UhBFbrhvlxZAYWCkczsedhyRuje2fMVE73DLXbFhijO9i0+YXdsGacDbKjTgCraGn0gQkcwW5CDTPr232g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746667740; c=relaxed/simple;
	bh=/YXTSFJPwHzxmJ5SyrRRwwOMYsrf3eqnKMWn9bR6ZMY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eHBxL5UIGd0VisJcKLMwPbx7Dj4J25mi+CWiP85ftw0SKycJK2uua41UzOcsTVHvSApJD2B/U0QZZwSLoqdAcYUhKQ32eIpTEW0to0ED5NixxOBq+Q1YMswEwvVk94qlPTIP7RUiwb6ckNu4DcbapJmk84OFt07DqF+eFf+8jqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RrkJ5A9Y; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=OHMfqYhU; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RrkJ5A9Y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OHMfqYhU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746667738; x=1778203738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/YXTSFJPwHzxmJ5SyrRRwwOMYsrf3eqnKMWn9bR6ZMY=;
  b=RrkJ5A9Yk8Vra5Vvx8S10/Mw9wKjwZNqCTsmOb19aZDexWwH/TmAJe3m
   EnXDfV0Ypr27N1dj5atZmAM2WPqGVkECIwuj0moCMpF5qOYxOUdevKc66
   aJY8felqo0ceRlM0opY5rZzja5U9Prqui5XUBiAzDIVRzlkQsUdzM5oho
   h/kyPiWFbxf3crg+iwgZXA684aWZbkdPKuMl2eebrq1nEBmocH65nKywn
   WdCNfwfpFDrmc2a5Y6cQafgJCh0ybkkZlXxVDuMcHaIo7aiitzdByTmCt
   5vg628UFZVIcNYxgK11WKq+jj7Uud45qx5NwJOi9VabvQOOeiiZ4osG5W
   A==;
X-CSE-ConnectionGUID: bU8CK6V7R4esirAgfcLPNQ==
X-CSE-MsgGUID: cKDZCK0jQvi7im/wmn+9Cg==
X-IronPort-AV: E=Sophos;i="6.15,271,1739808000"; 
   d="scan'208";a="85535941"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2025 09:28:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qiEEZ11UoqbjMPtRwE4bRWFXNE846tFx0a+jhvAwZLCOKIqLAnAkAFcbCCVGC+ZVlaLOeLLxJ7HCyQ+6qgfUanpV69I0HOM4dUpe9suCIUCuwaE7kW7OWhTZUh0nmG5o3bwbTHZE4yJZ1PD3RVLvNPsc0OwbVXJ4iSAuNjx+8CWugTfUGymRw+/G5n/U90k0Wjn+dd8PeL1zrF+OWeME1Sca4kCR0DOT3LXTU414dIh/Y0EXFW16nbifo15mwOROG5KbtZJCU5WI6sNU9ksEUlZzX6LTXQU6Ls3w/r/x1pum+uxi72wuQwK0r0meZ789QHestyU3I9NEGsHPNgW8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YXTSFJPwHzxmJ5SyrRRwwOMYsrf3eqnKMWn9bR6ZMY=;
 b=TQDQNQyvq3yaMsO8Rjw546fJcE0KLtoPYWHgLDgkoLpiTUrEgmogOSDcDhn7krIjzSa/JdK+JvloR5w37Ql+X8h9zghn4qJyVvg+yhPsTo25WffCiAsL8Du0vUXaPKBK0Ic4mKwVDkitP0lzfOiSi6E4ay9lXFd1cq01LKJOS5Onk6YXQy+dRXzuaHxWibcJAvp40Ms+2iLLWB661U6NvAAwtgWbKip0XRfd3ySZhrbJSy5lz7RYqU72GXpbsL1NpQuKAgsG1Z1EYSnEXBzKrYyEKcx+m3FYAo1dL8JBrpfgHnvgOuR/eNew35n1U7NJbZHieJRfAUdfFvj+TI8giw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YXTSFJPwHzxmJ5SyrRRwwOMYsrf3eqnKMWn9bR6ZMY=;
 b=OHMfqYhUDZD3WobZRDX86Pv9Z76KvqY1zmoAJ0zdopcWUbOyAafAFflLpyijfAv9Jxc+h/jXzFcuGGVerBXr3j7PWXDm2WtvlPgyA7Qa+J32NzwM1BxVtJ/+tdlGS8wl8JqnuoqzijDUDSdYTChxuhQ6nLrFi67dxsPDyTGp8fY=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH5PR04MB9575.namprd04.prod.outlook.com (2603:10b6:610:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 01:28:43 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.8699.026; Thu, 8 May 2025
 01:28:43 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Vincent Fu <vincentfu@gmail.com>, "fio@vger.kernel.org"
	<fio@vger.kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
Thread-Topic: [PATCH v2 0/8] zbd: support continue_on_error for zonemode=zbd
Thread-Index: AQHbtaH4YadcJHQi2kakiswWOoVMx7PHG0oAgABh2QCAAADgAIAAh8kA
Date: Thu, 8 May 2025 01:28:43 +0000
Message-ID: <brryp7uhtfs6ujltz5c5v3sq4laqqi4yvrwvndr3masoz7pkrd@5rct3dza32t2>
References: <20250425052148.126788-1-shinichiro.kawasaki@wdc.com>
 <174661736206.1785376.17260834205270367848.b4-ty@kernel.dk>
 <d120fd1e-22e3-46f4-88a6-559f256e20c5@gmail.com>
 <a4728f95-f894-4ee3-80e9-674635848806@kernel.dk>
In-Reply-To: <a4728f95-f894-4ee3-80e9-674635848806@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH5PR04MB9575:EE_
x-ms-office365-filtering-correlation-id: 6b63e980-3f3c-42d1-9d8b-08dd8dcfab7a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?WrhnnNbocNHO18xkckcPH1OApYqG0LtFiA3XsPmWIo82XCJdJt9xsbuOVr/A?=
 =?us-ascii?Q?eJ2ovNF5kHnNjPMCZphDzx5gWLr+VbJGoqTVUyHxWGy4JXrLRbX7Q/TDjXym?=
 =?us-ascii?Q?AkW35R8KDDQpWi4VpJ3dZQws9B+B5XMrVZ+13xIAOMfgKAjqZbaIrvWmWNtB?=
 =?us-ascii?Q?/UJKHl/CnGWaoZzIDEXQrwEgLo2eBmfLEQvApqkExtAXP3SPryHK/4kB3b+/?=
 =?us-ascii?Q?cZr+dueFtEFssXLmIK6HWnub3kKDmIG31tx7nnr1iNxtic9cZxL5lA5q+FM0?=
 =?us-ascii?Q?mptnouc/3Ozm85VVlmHl6ADtaRAv7PHsUpsKh1piln6mfHvWwrqheCEm9reJ?=
 =?us-ascii?Q?gqeZVG8ZiYa0CfknSnNSsRXmz3zwAD1oYN9ftDbn9Q/L7f8TKVMu/2PgtkVv?=
 =?us-ascii?Q?xGpeIVVRCvp5mOK6fIDVi6QSHWfZ4YD1elplXLTs73ZbvJGyt/lIFhupA9mK?=
 =?us-ascii?Q?MyB+1mePH8H1yZYXG6QaZeZrKjaM8soDt4H4IK9ZEutkpbAo8RPwoQLu6EcB?=
 =?us-ascii?Q?3JCADUT9p0pXNzKuO8pMT298EfEJeyACFvD6+JpfNzU13hVo3Wm3jiwGe76O?=
 =?us-ascii?Q?wbK3f9PBqExMCCm7VfTFc+2gsvzuv4VAZCSZLMQfJB3ugJtuE18JgAwkjnRO?=
 =?us-ascii?Q?JYTT2FQVLbrq/6RURkgREcZ1QlpMaOWIJX9U3fN9svNTYsPsekl8OFuklgSK?=
 =?us-ascii?Q?w+AQP/xjKfljwdTg4SiMi/+fC/tZZWnPmLNpA/vhyhxFhcKVEJ5sa82yPlDZ?=
 =?us-ascii?Q?yrcyhGj+A8exDVj/l8L24dTd7DczwNPD1C0yYGe89PMY+M1uct9uf0QR6YGi?=
 =?us-ascii?Q?agRzwvSVOjpYzoSnFCMvm7uJ3kHj+Ab4oOuoAa6c9DCi7Tjhoj/A9rL1DrEC?=
 =?us-ascii?Q?zDcVyEpKKOjRzlFs71BX+HQoTeAK1rbcTqr0okNADH7nJg0IaHiyY4k8Ra68?=
 =?us-ascii?Q?07Hz1dMjcPbuOqVDC5EQ1j6bQXcrYimHDoyZpp6fuCvQA9uvqZcxNscGHe40?=
 =?us-ascii?Q?SJPxu9jbWa9JWKwiToUG/izqyXzlZs0qQUZW0jtPAHmElOUdGArQ1kStjVNY?=
 =?us-ascii?Q?tG0SkLuHRHz5VckqYE8A1cZ1jAogu+dpkGazsmt7Xcny86c3PcxGaxjpjgZM?=
 =?us-ascii?Q?lSCyFny7IYLANdCtp55S/dv/YZ3b2dLx4DV8s6fzCVBRGKp8Zzn0SR90bGJF?=
 =?us-ascii?Q?P54XQH4I6uesRHINJ0lDsnYKdp7do0dJk5wC5wg+v8AsE/Tk+EpermZYHn8j?=
 =?us-ascii?Q?ZlJ1aY+eKIlLYyLkxYmoWhgyV78GSTa/5xZ8kFScVm3q+XK2wK4P1Jf68nDK?=
 =?us-ascii?Q?hnfDDWpPpZTNlQYHk6b+8gmx1n07wVbJQw2lFWNF5sF9gFwpXx8DsIMNP6ZU?=
 =?us-ascii?Q?pV8YN7RBaLrEJF8c9k5PoD6wTIvhrnN0L2L8UigNhEFNxH2hQLmWwYsSoO4O?=
 =?us-ascii?Q?dtupoEoLMcmuU/9ts90Jz2LC6ojpjFve?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?i1hZhEFwLGmbTXWr89d8m+HjZc7WwVRZzebDLGWUF3/T10pIOir39MyAE+kM?=
 =?us-ascii?Q?grAxXzDj09EV7iQCtHu6BNOY4/MuwGwXhM6MV5kmr4MnWduK8nLAt4LpK9Uc?=
 =?us-ascii?Q?lP4PGgT3UrMx+cP4276IOqJQYp+g8ff9xEDqJE4wl4uRQCt1yuy/vkwCnRLf?=
 =?us-ascii?Q?dQfkq8QlsQ2uOE80LAq4xnfyfB5jWaXVqadFfhKaUnuuUfnCPZVpm+MUhrD2?=
 =?us-ascii?Q?EkUZ52LSNPAcFcudMofmEsYmDG+n/eIV+JhAbDeD85lyye748bQKzSEQBapz?=
 =?us-ascii?Q?CI15z/Gqve1yDDT+J7E3yNGt2r59kTVgtUkaDwGaUihitzJ7rcAISH5uds6g?=
 =?us-ascii?Q?E55eChXDPmvNU+Ph3G/SWSs9dskPF+jlZeiTMojH1l+VKVGC19O8PZisfPDs?=
 =?us-ascii?Q?NA9eHyFBmE50DXEX5oEV+E8jbED1XQEPlOh3SlOuR9qiL9YrVbJlNmqDp790?=
 =?us-ascii?Q?gc23oS0Kygs3J+JoK5bgs5W0/VMEd0HWxdmZUbCjsjgoiOScQtYxCaaXTG5K?=
 =?us-ascii?Q?nSBCKBog6Qxqmj5eepdDmEC1h8RONKNz3Kym2ZrjJNnk5Lse3VIfuJpHuGnJ?=
 =?us-ascii?Q?nP0wJYS6iT2K5LD0SQAMA4AdwCSryLVzfFUafYpKn1pzT+MShqlIqzxv6rRu?=
 =?us-ascii?Q?K/wgZUNgECcu1fPMoRkijEXgM6eIJ+LkHtnN+PY/BbWxfqNh5X+niSWo26oM?=
 =?us-ascii?Q?f2xMWwQlr4ht7ZCAXNilAtWyWV2sBTCZxDyMoDToJpV/CJeUzo1puCbpyrzb?=
 =?us-ascii?Q?AwiyEAmzCAlgrz5rdueSzoeG7By+KPXFwfzxasD/RIbmN0jZQDXcsL8sDaAs?=
 =?us-ascii?Q?FHTANqhQCbmXuvN735ys9UEZvrBBHjklj7kkisStslNFi8JZqzTF9Q8gj71S?=
 =?us-ascii?Q?+nBlrZIydUbZSuX1LPYZZARRFR4+3Q0iopCIUaQXmCpXZ5Wb/QNjnhIoCMGH?=
 =?us-ascii?Q?vlT+KZX4t3J9OGvujQDHx2igWzVnCEA/hSRwNfjCHTvaBZ9mFjuuVdhbw1B4?=
 =?us-ascii?Q?9RKDn6RdeNA9bIrlFhzQ43oiP04NC1y3GVkQdmhsUdWlozMm6px6fnOq0/kM?=
 =?us-ascii?Q?6dbHRX6YUiFBedDIvOhn2yk5aY1Bke8fWEN0yDZtN96DwAXwrBWn5K2kiNVI?=
 =?us-ascii?Q?c9GS5tTN6ExLZBFOCXAlToPAhNSEwXyu3gIO5Q0VD+MFhbIXgBYkzUfWpeao?=
 =?us-ascii?Q?8V7qGm4IymftPk3LhcvTi8mkpGSo9+futu7GmRFWp5BO80QnvojeuGuqK4Bn?=
 =?us-ascii?Q?jpNEpyxCK7mz22lvPYrHlAd2wMYsPr88S5u6zc1NRz6tSH6XNB88qkXrZJ8+?=
 =?us-ascii?Q?jDbTY64ycYExVzH72PG0oxp4y/03tAAe3bJJq/ttuQyNVh5VKYTd3la1djVf?=
 =?us-ascii?Q?AlxX+9FhL30efmmv8Rh6lxV4BO2XcFFWeCYIepjOqlfvvJvCuMMnO17secY9?=
 =?us-ascii?Q?Yf76lmk4Hhs05q2OhJoi5kTeMsXuft9YlYC8n+sxSI1pJVC+ut+/OA3AmQQf?=
 =?us-ascii?Q?0O5+IKtha3UMM7G3lghuclMPeUiWVvgcTDg3Rzbkv5uXtJ2hEcf+n2+4+yLp?=
 =?us-ascii?Q?CIg47kz2MTpXtWWQeAtsNrvBocw49NWO+TiuOdzBnl+pfoaJc3kAEHXwSo98?=
 =?us-ascii?Q?M2dq1qMG0uEGnpwHgKJpls0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0817AC55DA571B448035A383580E0B73@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ahvKYKBNBG3DODiegg4+4OEhl0rN2qyByHgEOR6DdZy00vNicLY2Y+/CTF4dx3Jt7Ex14S/Lyp/dFj8qAlKzFsMKbORGW6PPC0NMGeVMLfTmuf67eo9JrUFHXXVYB9n1D4t166HnGI1+8BQyO7jbBVtaJFa8sZCBO2sgs+KPITGaHih4gztdkPRFJBM5ta4f/cicRgdf5iYy5F7gtl+MPxgLkzb1N4tsYrHNVNETFlzx2qEslFyoHoGRp3aCccs0Az5QjGh7fnD+WhTz1cTnqC7BOV9v7rtPyEgTH4F8OWmODFvb//YzvF47o8Zim8Ih+BD/yqq8tc1q5zs2kSO7P4GYVsiRY5dPWzADx0cFL6/n90vMvGPptjf+nHGQepE/LeatQw1qqycW1o8H+qN12T52tAEP/DOYsmy6Zb0uwKh/I0PpQRT3jeHSt5pxS0avKQ8FkigMdqXTyGxubKWkI1fPqXO67ae6AmhIAVEOi5gcr6WjBPxzsYEFqKo5OvmBuHqdsblUZCCebq9QsF4K11hVuoxWxr75vuRIpKvNLb7skXHfR20JIw78Zc/Lgjr/mjz3HXHHGZ96wQULJV48xfDQCs39watwf4R1q2Z9ATsoOB7rW4JIHdtM4rDCbrXf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b63e980-3f3c-42d1-9d8b-08dd8dcfab7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 01:28:43.1072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XlipGktknPX2kJVe++d/W4fDXcAU6BxxR2cZVhEdokRoJ+z/6bjktoUmdvjKx2Aiwpn7JTJ+jZlkySOP/QHCfm9dra3fxCSOQ4shdXBxUlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR04MB9575

On May 07, 2025 / 11:22, Jens Axboe wrote:
...
> > Shin'ichiro, there are some build failures with macOS and Windows:
> >=20
> > https://github.com/axboe/fio/actions/runs/14882253382
>=20
> Indeed... Guess I should've staged it, in lieu of our CI being
> able to pick up and build on-list patches.
>=20
> Shin'ichiro, please fix those up, thanks.

Sorry for the trouble. I created the fix PR [1], and it's already merged.
Thanks for the quick action.

[1] https://github.com/axboe/fio/pull/1893

To prevent this mistake in the future, I will do compile test on my MacBook=
,
or create PR to run the CI.=
