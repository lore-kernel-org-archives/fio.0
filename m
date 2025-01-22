Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B66414A85
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507775; cv=fail; b=RPqraKyzZdYTHbkMf8e8okpvVUGINmS6CUcNeWLQkDc0/3aG3JVjMagPRksm90dEjqtPRK580dZW61xEE+ruSBKzqgws98efuyi1UwtcVVVhnHsxj16sXl+ESYEZlcvDZZFFYekK8fxni1De05Yj1SvijN9b83kRNaTuXNSrz7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507775; c=relaxed/simple;
	bh=s7t6NLDhMG5z27oAEZH0c6fz7vagSb38ygU/gPAkKXY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=haoOP+ov00buHFrr/GfqODMjjEkMz/SGltwRuSNY9G/PZmYt9wYV62gGPFIi9AMSotJqx+QBgCG99fjHPyNpmtaRkg5pq6giK2JgTKCH/5VQlx++Q+ba+UDqbhZuRIsZkPaw55oNmDfc7pAt9UDNYCpwKu/M4FPnioZ36gNOGYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oeerQ9xC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TSM5OE48; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oeerQ9xC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TSM5OE48"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737507774; x=1769043774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s7t6NLDhMG5z27oAEZH0c6fz7vagSb38ygU/gPAkKXY=;
  b=oeerQ9xCWHUWWe6OfigBxEdNUpPBBGFP+N1sWy4n9zMq+msVmJVpWZZb
   i9Kh+AwbNBF8agkne8k/yeH4pFx0/ieop0CSN74kfJLVbrPwjzmNaSgUo
   Zer5XNlKM1hQUw47thVn7SynuD425yekUCrJGnpm7+ASp7ycE4bNTZ349
   54SxbVK8GWvrYvCez5np9urrxUaHkMA9sFAAr/NSxaLCMaBcos54M6lST
   J9u4Yz/KGkqC5MdoMTK4tHhPnfNUSJVNNQ9pemV2w9J6MQkLN+lkfn7zc
   D2Pubm8HlceP3WKuErYSho1Gq4/lEMeBdlZOR6j2VfSaBJBUl9NGBBVOp
   g==;
X-CSE-ConnectionGUID: 9K7JyKTiS9K5E3UL5awJIQ==
X-CSE-MsgGUID: 6JMIJCYHTVaMRd6sb+OCTQ==
X-IronPort-AV: E=Sophos;i="6.13,223,1732550400"; 
   d="scan'208";a="35872643"
Received: from mail-northcentralusazlp17013063.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.63])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2025 09:02:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jLYCku4/S8H76Zmo19EYTqbwJo4NnZQCb0Kr0BhIusDFfiCTm00wLT896nlpU+mE/WnyJzYskcYQ6ToLrknXOcc3ueDo7HQ+ztgkDtagZx1jeWKRjEq7A28CtVv0CGYSH9z32alAskYqLeFqYXVKPwD6gO+k7IR3zCew1Y4LPMiIp0NIhemLjk7m3pyMWdpbjspTzhgxc3JmPEz+bJGOeP97/ofpR8lHdaby97cyqHU8dUTg/3pxtn9Id8EcO4AnKkgcLm6myhA+hDxaDJrJxBLt2tvsCY0uof8t+gzfJoNSnNAN6tyjrurBaH8Zixu/9kXB7x18VfKBryRQPoSkLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7t6NLDhMG5z27oAEZH0c6fz7vagSb38ygU/gPAkKXY=;
 b=RyybOKLtz43yGhRQDfhmKLL0TnnluvSrlLdIdLxHbFDfSs/c1AMPENp6I1Vf6Scx2c5MbYhJ1vWb4Cl3kMzGWwQg0ELF0Utj0lT+cLfri05ROkCmQO7hsLvysorNkkk0JqJacWyzU0KVNcLFkUnzitkT92m8kjm6IGVId21b1Pb/4un/TnptElMHfIVGv0wmxuV7XkSP60hfitiqu04Ni9AhmSSzXAg6g5fneY12aFRH7Rstq/GEHCL+PoXGh1oIRDpC/3q1GSqHzdJbtDcPi3QUQs6kWfOG03JT5hDti541gB1+WmfdbIIxGwlKSnG86wlirs9eekM0yWejbfpXzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7t6NLDhMG5z27oAEZH0c6fz7vagSb38ygU/gPAkKXY=;
 b=TSM5OE48IPvskkGWCBHaxsOfGuG7pPEfW3NPTnFIo5WtEgXL1x7AZECUERhjus0K54YLycITgn9tnuASn5SGqib6goPnQBMVOihl24siRVKNgDL+Ud2QxVJHdrFKA+7b3cdVIGD94B6AEEsqKni14/I50wGDmJg7DTZCfys4B8M=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 IA3PR04MB9307.namprd04.prod.outlook.com (2603:10b6:208:50c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.22; Wed, 22 Jan 2025 01:02:50 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%5]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 01:02:50 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Niklas Cassel <Niklas.Cassel@wdc.com>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 0/2] zbd: fix open zone status check for non-write jobs
Thread-Topic: [PATCH 0/2] zbd: fix open zone status check for non-write jobs
Thread-Index: AQHba9/2Dqmp//5CgUG9OH0zIFYlhLMg8eQAgAEJEYA=
Date: Wed, 22 Jan 2025 01:02:50 +0000
Message-ID: <7gzwm2xrinomvxjorl6feubypec4lts7e6gadkbtl73622j37m@njpu3nvbmwki>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
 <Z49lXkn6UvcohDum@ryzen>
In-Reply-To: <Z49lXkn6UvcohDum@ryzen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|IA3PR04MB9307:EE_
x-ms-office365-filtering-correlation-id: 5a75fc37-22dd-486b-aa9c-08dd3a807e23
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?DemnsRVSs5Sq7nuQS9asr+IKL6u29DiuUFJ1rNYg5ftQ98mjdzP9FZZrhF5r?=
 =?us-ascii?Q?Q3AWIPm2tOjb3y5y4fum8KfLEiUWCjucWvqHvMSBNhdguwUACiJBcYDmZ3lq?=
 =?us-ascii?Q?1Vb9agafsWIHbU0MziNUuIlAUOXYAZD+H6wFnSRFmUyoYLH+HDCJlkzDJBq1?=
 =?us-ascii?Q?elV0LR3+tFK0q+Jm8G+XeqK1jaFmBnF1jljBCTrfYkCyk8Ue4VpXxw39yj7o?=
 =?us-ascii?Q?VqIa7rExz/yaGLhiDW6wXHEpWFRKGqyLCbe9Fx8KUmHnN7BsFJbjt/6/LJCx?=
 =?us-ascii?Q?gqqhTyQe92E90ik+KqHOqdFkRkXiBhRalPOEXO/IBlH42NDa+i1ezL9vPB4x?=
 =?us-ascii?Q?Lc7gzYi8D0q3ie80hYb9Mo3IhMGcSzLt2K+yD0vWfEy6E4+sYKtFBb5HiRp1?=
 =?us-ascii?Q?A92T8TN9CpS4vHY4d8AZG3gAay6Y8BIiunbXZa68BRnKq6bCY5YWvxNswKSr?=
 =?us-ascii?Q?tl3A36M+Onh1y/cwb2oHMZrdvbIZJcccSQ5tvDtfkhjppKI50eN+KOjs8l6G?=
 =?us-ascii?Q?lTmqLNgqPAxNTd9/BqZM6SCxkh+mQJHNhke99HPC3pKk6MmDsYd/5P0IZEGM?=
 =?us-ascii?Q?JepaYubprT9Z+kIY3Dx3XzBikK1sHL7PoHHQy8VN4QueGDpEPsoVBmxIMYMM?=
 =?us-ascii?Q?SmiNjvB5LlCIisWeT82hMNd4Radfjso3mWTQ/jzXyHtjbdk+WTKtnco/DiD4?=
 =?us-ascii?Q?gqniL8E7PuDHDBj1ltGuiLr1zOXuVjMOWMu8/ftuk577aG5laJ9+ayatOLG8?=
 =?us-ascii?Q?bhUI/LHwsr05opOZRpokj1xc+Sv/2kqOpCcSo6Y17WKiFhrO72K8UrqrKv/C?=
 =?us-ascii?Q?m7HQ2RnjilsuiNScRCY9i7JXPZWdk8WNZitoyjm2uRnvCyf87Ct4Hl7d3uJk?=
 =?us-ascii?Q?42n78Q8B1hz5sBGc/Q4tcKD2tjwhWDihcJEqkTACORwD6P/46qCrzlHT78Z+?=
 =?us-ascii?Q?JnGTH5+EFOGob3B022QsAlZ8SeVXw9xbDwiaginyGhoLU+WTEYcqgzF1z/QB?=
 =?us-ascii?Q?i2grQU1aPVeHRTzlcO0/ugatoKHuoCycjvYE/DE4fwJcKdheSmw+9qBkie2i?=
 =?us-ascii?Q?v2anp8MAUbb+YR6dAl8ZgsVNI7czZ7t0vX/hkR1BA85P1hyi+f15mymP1DOZ?=
 =?us-ascii?Q?k/3H/jWHwO/I5eU6VF/ffRgDNjK4r6Q2ATp1vu8tqFE0u1b7x7l3m2GzG47/?=
 =?us-ascii?Q?XjXhhV3w8mf4y0KL21ewqy/cbVe1ygGENxyCJqdnyxBqRQ9GcwwLSNkk35vW?=
 =?us-ascii?Q?FUhXMiuwtmXnus2f8tp4oRgsSD3VUpRI3z3dUg9OCpwVuHRe/9MzD+3cu0aO?=
 =?us-ascii?Q?LPHxRs0CTdJ9Rv2XzmPXbRFDVylYVTqBthVa+CvLN/p3TEWBYNZhs+VEE8DS?=
 =?us-ascii?Q?Z2jUUeHzzOSRN2E7cFnbfIuLHPs/PNHy4px1y+P0HEQWs4sYeZWMYcGYfns/?=
 =?us-ascii?Q?7TKlFVrL/U4wKvzptfRzAkqHlrw4F34i?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UDwozReSsD2ucTHuJyPgPRv3ft2UPpzm1f14Vwm+tkypUVfrWMXbswebkLmK?=
 =?us-ascii?Q?9oVMnHeQw7PmJ7ZfBEGYSp66GE8hrwvYAinhDbHAQKdjCy/XI99cPPTcb7Gq?=
 =?us-ascii?Q?aJTf7eM9mshwOI24Xt+F7d/c4rAZq2s92hJ33mDhEgqBTEwlsSHnN0OCeFiN?=
 =?us-ascii?Q?eBnQUgso2RrHbv4TlMgjZ4RH0Xk7Qze8Rs93LHTBTaHYQ6Mzf8ynHPR2zz+a?=
 =?us-ascii?Q?5TPfM8U8sZTLg/Dlgqi7gjTj+qU235bk3YBH4LEN29mEgmkmBvzA8POyQQ05?=
 =?us-ascii?Q?RBe+Nt+v7OpzrbYGo5fMw44NI7/uazYdih1TGZm54YEMJk5PF5/Ya3UEyI66?=
 =?us-ascii?Q?Gf3AfwZCKMiSP07AWn+9QGy4l+Dl2YOxXLD75N77+v25DiuiXof12OcRQrT2?=
 =?us-ascii?Q?bP+c1LD+djnoS0YW2LBKaot0Q1C1gcWr3nJhzECeoV9VV1YiYD8mGG6AahaA?=
 =?us-ascii?Q?F/ls2itgX7j05Xgnv/6DZ2PlFpBNWp5vHF6CB7ESLgLVMlS/WT5GmqNYWTlj?=
 =?us-ascii?Q?B18ToCJUArfE9rUAxet9r2uE+rO+vLx5UxNlkGuHQuSt9ygdLl1lxUwiyqu3?=
 =?us-ascii?Q?5aUUSTgaAQlFQ8XEedEQz5aKaJtmVwQWAtN+ZGQe9ywXgABQYsPPkgZgzx3R?=
 =?us-ascii?Q?9gpnNHDKb1ob3oYcbYPcFmqAcoMk4VAMHA5aAzk4IglMK80lO98AWIYVpXh0?=
 =?us-ascii?Q?+uTmZjrcMU3B2hQ4EoI/KIZZKwd3YO0D/6VgVxjeL4QsZ0XMdy+kWUBjfFX3?=
 =?us-ascii?Q?22GkXM3HACGmgf0g+jUauuS7Ij/XJFINmQHfJqaxU43bceywq/Rce3E++ZVf?=
 =?us-ascii?Q?DxLbnzoL2HgiDbNEFM145JTCwfAp5EZ7dCT7xtoReqDLUoiEf2ZEy/YSCvKY?=
 =?us-ascii?Q?QO7l6UI5e7+BL1/WWUaLtPlbWm7DB9MKk2kouNnx1R5JoYlykOIP65ZNs3x5?=
 =?us-ascii?Q?L/G7XuRcewjIBxT0BWK1vSIvokazqFQpFr6YFkndn+yCsVqaa+ekDIuZj5Qh?=
 =?us-ascii?Q?07w9RNa2XhfZ/H0hHVoolQR1fQ0eutpQMTUfn5o0nm73MFL822kMAiEFr4sB?=
 =?us-ascii?Q?RYQXQJk2bS4F7NGDz0yIv/uWTrmmAezoriYnWnyb2dpWnqQCZbTDsyT2EPnE?=
 =?us-ascii?Q?z1WHdvIMFk73JmmQGSH7j4ga2/9EcfIC+OPCUvFLlQeXA/zGfyN9LKVZtIhv?=
 =?us-ascii?Q?WTKo1e+80mFkD8cM31SaDKfvJGXu+hrhWDp8r9Adcpnv/H2dW/M/2hX1m7T4?=
 =?us-ascii?Q?o5uIdIBiJ5w96QEScvd/azrXm/itjZ883IrJIWt9bFJdlo5ow/kRZKremGf1?=
 =?us-ascii?Q?9eU7Z/UhgYD4VH5BcuiyePALcTn1bkhm/gscp2O2FLtxee4n2mbvu1jfOqgP?=
 =?us-ascii?Q?Om0tZUY7Mypn3wbPgxwewZpGxxIHM+gZ95557Wi7AWsqUJJJBJ0yXoVYZMnA?=
 =?us-ascii?Q?7bRdMB7+b0GpJqqHND0qqhP1JtnqF6d/PJlYxknWdavx0sqkU1wndjObXOPD?=
 =?us-ascii?Q?QFgs+q9cBnxFZsRvhOaTQ8p/JL7G8SV/qLXBP8JtmO7wOs9Ph3TvthDBOLEC?=
 =?us-ascii?Q?SY1XbHm3N82di5xrVEdOmTDk6T/Bq6r+xslHEv7HKdb8aDfa+j+PVLZ4tXaP?=
 =?us-ascii?Q?6Ab5Lnxhab7M8pbLxESAKzc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F12607DB46BA7F448D609CA4C3151798@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	byuC3zOeMsEJhDD6XLYydVmGr4F/dZCaWPkv+WAKgVnYfUT5rMUXE76FsBCydV0XrP+wak2pXFnYo5fdTArDR5Xpn4+PmatPuchwMp+35kOV0dikXUn+M9Ecd+iRUNp/Wl4u0j2+6pC1wTp5M+OeAMme7/QdhfxqdCGfvVEK7NdgPNiS3LQ+V0dZPkCG5vz365oNVeAvKmuI61YVzfBL0hNxROeyDEaG38tT/5smjU1FBy2afd0/q7NpSy+nMNl2MuLYkRNTb1s6tRQDKra337Pb2xiU2cepS0S/13djGVvuro236YeOnl6+jrJXxHu91lGWO9YqCdHrYubSxN8vjsS3GQaECzuqI8H3vGljEJmkkInXcWSSJt0W5xSPOHroXq7PIZ4jzx00KrihRn9CX8jqBcjYEFohNNut0ZMqfGkga7r1vbdOuluEIfBb+vlp0JdRTS4Hju/lCSURN3GhVp9QsqeWHUYPFpgCyteJGM7TC/Fg/A+H6SOumQNbHZryozHRg6IptrOObqNrModMVgh/EOG9EjhfXCjukcquQAjn5q8jmovEyLdofrvx1OXT5lhJJIg33sXk3N0Tk7vbvIxjp+YVJGfggM4B20YiRtgG5KpyM45PlzyKsjMl7+u2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a75fc37-22dd-486b-aa9c-08dd3a807e23
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2025 01:02:50.2878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bJOESOM3tOzXInczqV1MkNRTNHnhzZlDBqyaXsc9izpvFE7eKvWs62X97ghJ58N7fal9eerj/gZs/PuGm3ZlqPFipzNgT4yuT3+b7CDpMyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9307

On Jan 21, 2025 / 09:14, Niklas Cassel wrote:
> Hello Shin'ichiro,
>=20
> On Tue, Jan 21, 2025 at 05:39:11PM +0900, Shin'ichiro Kawasaki wrote:
> > Currently, fio checks if each zone within the IO range is in an open
> > condition or not. This check is done even if the job does not perform
> > any write operations, and causes confusion among users.
> >=20
> > This series addresses the problem. The first patch fixes it, and the
> > second patch adds a test case to confirm the fix.
>=20
> If the first patch fixes something, then perhaps it should have a Fixes t=
ag?

Yes, agreed.

>=20
> I guess the commit
> 8ac768899d63 ("zbd: do not reset extra zones in open conditions")
>=20
> is the proper one to reference here?

Another candidate is this:
954217b90191 ("zbd: Initialize open zones list referring zone status at fio=
 start")

I think it will be the better reference to add two Fixes tags for both. Wil=
l do
so in v2.=
