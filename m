Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94B21401C
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 05:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609054; cv=fail; b=VuXe/gXQOP0WL76f0ZW9T/3RLZalx3EFpfXfQ/pwCEx9tx2cxInzdIK9mX1hLM3bkRNlODwdu8Od5hCF04LlILrbLJjuCmGUwwNGFWq0rfbkq2lYrhRGASDn67PV7uXawbq8PZJfh65Rfmjk3rSp7L3F4IzOsMxgIbc+H6TQpPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609054; c=relaxed/simple;
	bh=K9imMC14qXdQbj6XEmC8oNCgPAwjjAqaHRd2wxnWtQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fygvNJqGAzgyOA7hDe9/14Q0b9LWPzhxawfIi9IFdi7H81166zT/YYgpN5lP3QCNG902pW2qZsdcWq2wzEa8zY3EjDi8k3Um0OoMMLbkMvurs3zgUNRI+/Ggh3drxlx63upmZOuTEUWLAWvnVYMaUqsUXtln3Cb3qEZiA2SctVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YxlhMZW6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=by1tmOe0; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YxlhMZW6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="by1tmOe0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1744609052; x=1776145052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K9imMC14qXdQbj6XEmC8oNCgPAwjjAqaHRd2wxnWtQE=;
  b=YxlhMZW6So0rSHwZTWPA3bEOrnqV/FkhOPNZMcTm1LUfRQ2MYgR5/Lkl
   XIsehICr4KmJ1sqq187au24BF30jAYPVZS7VG98mdLCyldsin8s3upEx2
   cqsnKbdJtJJBSJID9nJPmq73cxkR+xU/QpWF+fTXA4lUMsl0U0GL5ZRzV
   71QXgoINVYEYoTMZ4CNkLeBEYm31+vMDSjZZqWROlHnOTsoyn23BFNlcH
   WiQKisl8x8X+o6cw9GzRRfrgw1d5IYGGH/Js1yRdnkFOsgiIyRE9S67ub
   2RMe4Zt9JCyy0HPbCkSURAS4XQHiJRHUybKF/1x6nrfqD8mmPA3r/SDBM
   Q==;
X-CSE-ConnectionGUID: lWppVJ/9TNS93TEjESoNQg==
X-CSE-MsgGUID: YDjE1VT6TkOk1qCmz9OCFw==
X-IronPort-AV: E=Sophos;i="6.15,211,1739808000"; 
   d="scan'208";a="81202980"
Received: from mail-eastus2azlp17010022.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.22])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 13:37:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rp6DKUXbkpF+9ol/DVUs0kL42T77CjB2U21ANeUArBVOpFF+Rx6CnLMsFi7PQS0mTv/UVb1B1JbAygAztBvDE+z/aNswKKZvwLK6FsA+bvwM724OcOgdWlE/85hg6J0hhPQtCDvqids1YjhCOYesHQQ2xsZkeinCd/L393FNjY0GVuiG9y4kQfSGk48/GOqKXPwVHJWoCx8iL9mZLALbMT9ZzHFnNLW48DhcmrSD68vQ1CxO9Iq3k4cDlvKQZSYzoTr/3ee/tOTBYfuqZU7Sw8nK9098szi4S1wXJpKPOeLOPTatbbBIobLZ3x8y5gKwHZInp3LSKX8+EFsVyz4PWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Inp0jCiAkIM6zPoDNHyeKL10SW8Ofr03Ocf3aK7DgHc=;
 b=R4/2eaJmrn0lqS1nF9HtkVZGcAB3JBYkH2GgPPvNX2ut8ytjd9azeAweqNrWwGM+shLhp4Ey8cnpEI8oGHCVqWle9wrh9Q5UbUBtkn30dVFWFXs0qKrRBZpdzZLzMCxGDpfzBKyGvUy/L6bgStwkmOQ3RkqrbTvvCMGdMSqYjNJTup6oL/nFA4HGMkC/dqDy/J6DPZRHa+dzdHE/FiC/cUCRVIhdK8UelVoO1FZkaOAjgJvS1wHNYtZkJRoIT7zyAUcfm6jqN2EStb8XF1RSV5zyJKmJ8FvsZh5NdC9YxtmwZ69CeYlQiQ+g0IXfGkMNDIfVrv5Nf+eixxcLT+r23w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Inp0jCiAkIM6zPoDNHyeKL10SW8Ofr03Ocf3aK7DgHc=;
 b=by1tmOe0NwgJoAt94nXGiXwCiWSaTCUcZAMNgNFuiauDhlgC8pXYc56Oa8zrZ044UjJTaxOSkNBdXdzRweJrTFvQFsRqeUADBjB5fWFPAj7s32RGhrs7/h2JycvU0KqgqriFHMN8UfYJzISAWF6mFG/dJiq9eSSOrJfgupna79Q=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MN6PR04MB9502.namprd04.prod.outlook.com (2603:10b6:208:4f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Mon, 14 Apr
 2025 05:37:30 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 05:37:29 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 1/4] zbd: move zone finish operation to
 zbd_convert_to_write_zone()
Thread-Topic: [PATCH 1/4] zbd: move zone finish operation to
 zbd_convert_to_write_zone()
Thread-Index: AQHbqtKdJnAOzuFPFku4NEzLWgGI/7OiUskAgABWLwA=
Date: Mon, 14 Apr 2025 05:37:29 +0000
Message-ID: <l4blsdwuni2bozeqwvxctwl2gimjvxsijghrvhai3lupzggx3b@zovgxc7t3tnb>
References: <20250411111219.57424-1-shinichiro.kawasaki@wdc.com>
 <20250411111219.57424-2-shinichiro.kawasaki@wdc.com>
 <ca6da862-71a8-4c40-a6cf-a1b5999edc5e@kernel.org>
In-Reply-To: <ca6da862-71a8-4c40-a6cf-a1b5999edc5e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MN6PR04MB9502:EE_
x-ms-office365-filtering-correlation-id: 9d838314-2c72-409e-db70-08dd7b167291
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?N2l5umMfvtphJiRJDBif71npWTTH7rpYkyjKsl5i0k4RKhaS8VHS894SSXz9?=
 =?us-ascii?Q?UB05jVrNVizStCR9ufVysp2K6gugmdShwuJzZJAFPee7ojXaXOEcGgxAQmjh?=
 =?us-ascii?Q?nL/Q0t2kaTBCGk1sgFCZS9AqPI8iEPryVl/Hq7tr7ihldRDzYT07Gs24COgN?=
 =?us-ascii?Q?oifasIV1LmmvPz2OhylEuSjEaKjBsqVPQlMK+euVNCDqExB1+VReahF7PJK1?=
 =?us-ascii?Q?3bUvhaAoYpniRGAqtczDIaLxhXlUvlz/D902AH4YKMM9gyan+e/R0C0xMzZK?=
 =?us-ascii?Q?mU4ftdEA7x/on93d5JoY99mFRo3WKks7I2KOpWSK6YY8jb2gyYjJLAX4DNxz?=
 =?us-ascii?Q?TZpb8FIY9J1A+da5nGTLB/y4U1W65r7PIgUSvjotFMFmkeFIdpFEVAYcGtV3?=
 =?us-ascii?Q?AkHdpY4j1vxMaBDNYPdP8NfBKPbVmGmJ4J7E5rExL8S/vlg1stAEiitGH5AV?=
 =?us-ascii?Q?MDM5p6ff3GbohsWDC+YaJjESekvoGau+j1vn1q9zKNGBziK129zm4U9q18P3?=
 =?us-ascii?Q?e8qsdHzDIdnShCQ2IXTt7KR7+7Ng2fCXac+ccVV+GXIO3NRjhINOkvEl1lJA?=
 =?us-ascii?Q?5F1Q2EfhbzfKkOKJ8UTWHZwOwt6e0ev+byv7ozM9mQA3LlzWVjGQAFk5YN+J?=
 =?us-ascii?Q?O4YCt3YNb63dnDo2OTrINzaIoV5epYLQ4tTeC7XKfH08+Y8MB40nZgmfRrOl?=
 =?us-ascii?Q?wb2wkkbEPFnatNiWgsOsSeawRuL7jZnd/A8jKsphAQT1xDOdFMGz+3fwQulb?=
 =?us-ascii?Q?04Zaf8S7V/VnlFqLad7t7NW9y5YGhkypPR+a3vgFxz9ndFO8vmae3FhCPQLO?=
 =?us-ascii?Q?FbX6gcmN6BIKfnuQ5G+FYtGzyAx1gtB/EOo7RnqCDTOqU4f8sQ5FbfA4jcUc?=
 =?us-ascii?Q?XIcPxYFpTYc9nBbF8ZbLGpZg5zU72V2WL3Ym2bSyGuD1M6o67KAUOdQY6WyN?=
 =?us-ascii?Q?Ft1eqrTj2Un9CVcYT2slrnoXHt1aWiL3s40wauxoYUtTVKpP+E7e48x+Y1FC?=
 =?us-ascii?Q?NiGr2hJaUL2oSn0j7hc51pw+tjLTYIbNkS1+H1lFk4tnPB3ZP4gx0VTs/vg/?=
 =?us-ascii?Q?pVCn1ABHp9lPWgN6rPv4Fh/7lCjnYVzl4J+HUe7/dPOSu+8iXtFtkhY4nXgk?=
 =?us-ascii?Q?USaOMUhtWqS8712m5i25puqWTB7WzacriX5Dsbugi2/QGrfQspx3LtO1L3dC?=
 =?us-ascii?Q?bCbzZ+FC+9DMsHFRTjzZhura7O9wEbm2Hd5/mAx6Ze7W+MHY9CLfj/6cH78/?=
 =?us-ascii?Q?ReGo9NdEYw8JFp5hg1wj/I3ON6J7tOuyBI6iJHQiPKUIn0lUyTOTSbvsHBlk?=
 =?us-ascii?Q?TRa3yXX/T+zaKRIQN+p1tk50n7NeTv+/mnQJGAiJFeRY/85CPx8jA0WT+D2k?=
 =?us-ascii?Q?1ncGmiSpvBYr4DM5tFtARNO4sCgJ8Bevtzdd0TyiIfEGqLuom4h6msWUbP0j?=
 =?us-ascii?Q?FOrFDmkcHwZCZwfvQEqfoiFnX7cmUHi9lqPfsMJuza/Mj9ID4zfC0A=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PZRjjDwUqF149VhGPQ3A2j0bBgUqs4pujzQz62JHcs+YmcgL2dpekTuT385a?=
 =?us-ascii?Q?TScYhxSMKj5PB4xTGNhhaoT7uEcU2P17QpPU9SlOIS0jjGRsyAEfY+HsI5i1?=
 =?us-ascii?Q?8KEF79TaCdS5mSXQ9FEGtsMiK/M997IjY6gibNIH65QL0lUzXJQBqsZ2lmYP?=
 =?us-ascii?Q?oBPXQAni9AERcV4olm+Eoi/T7lFCp7cPf+UaY3iq6nqfGEgrY5pQRA8X5ugt?=
 =?us-ascii?Q?jlUjyfwxOcY2cE3w4rsIaWPNPlzV/9nuccP/MVdb6DpEVHux3rvLNS2Tj3el?=
 =?us-ascii?Q?XgaHwLP33cNPDN7dtieIkzt07CbrJt7rAxCIfJrufydWRdypStwnaa45V9Ts?=
 =?us-ascii?Q?5FAP2yUnokxfWRU4nJGtGDvsr26tOwwW4vUCtJhKMukXKnHAphrTr1w9DIkF?=
 =?us-ascii?Q?1cvUuYX2233T0Sog/xRYnsFgEWUbJEqOBeAFTyL30c/1lNew3fAoOlYJuk8b?=
 =?us-ascii?Q?RVIjqOTwk72/xW9HYz01IJlTMbOFLdBTpXoTw3Al/tDV3QBHuy5U5pSwQgE/?=
 =?us-ascii?Q?NT8M8MyHfWn3aH6WKoNK0W4+DLCwODJ0wH3rnguIN3IaPofeith9IE6ODYe2?=
 =?us-ascii?Q?pFrrivFVeo/nFy3mhgZmA2NKj6uKZkUPdKEKwfOhHeqB7d0n2ykaOmr/bTRI?=
 =?us-ascii?Q?KiBHUbKnYi6PszZwadWso95nv7KdPNgadbGgxrjNGEzC8xpnh4ncBi2unroD?=
 =?us-ascii?Q?RfQDrj5iK7IJZ19wYbgkFPItArIi9ydo9uNBnwiopxDper8I/o4NG+LmEQUE?=
 =?us-ascii?Q?rl8REvsAKkvOD7w/rKoC3LdwaH6uRgFBXZTqeWaomVVuE/4ayhfL/ISBg5uS?=
 =?us-ascii?Q?1Is6GCffuHALGTTNasLfSTgXCt1U9EP+5qoOpBLshCC1gBqjT1MjEhRgI7As?=
 =?us-ascii?Q?wSTbEC2iyWikMYS0FdoNZSKCA6j9WARPhf03bQo7cEsdI2KjDY6yHpvw9LOY?=
 =?us-ascii?Q?BBoqDgZ9zmNSoBN0aNj6lIFBXBvbStPuDIfNie8da9GdnA8Re5ZQh2E9lTwT?=
 =?us-ascii?Q?jLkwMxNxNh11HQiKE5Gs1LQyw8TnyoDEE3g9WmfZUzEUQrsxLg55svMW8Oz6?=
 =?us-ascii?Q?T/K2LTIGemvvwcna8i9R++azlw3i0YUOGc1HeWrJmQ/L/iMR2skRA0X+bbo0?=
 =?us-ascii?Q?nFq6dcNbvPHi8CXDTptUlb52s4PjeMwU2tZ5CI2lcxrfScvzqXsIx4myz5gh?=
 =?us-ascii?Q?Y0Vh9IM2Th+OOk2eDJL/vu4g7MZtNVSeWzUlBlCHcT7Pi9zzEVatXitC/NCn?=
 =?us-ascii?Q?/+ZgYYOkNLUv2iY4kuNRm+DvDZ0ZUPnQ0ZOcYlOcNxj5XKqhg1ni3Jh1Pta2?=
 =?us-ascii?Q?P4kFpMoVmhWjWeolaQDxvKdtZdm47Z7f0CviEpOgqYuu8zSzirj+sUKPp68Z?=
 =?us-ascii?Q?kxAuY4HUHOGDNitUlm8W/aX8EoCw+stNssu0shkEct+WZroiFFUBgyn7y9YP?=
 =?us-ascii?Q?1K/BEtvN51jXiJx1f34IDI7ZjfeydInq9FtpZMuB62hLYDLRN3OQTgdNtJhB?=
 =?us-ascii?Q?C5KJK+dww0YurU+o4tlemCkj5Nc6f1eylAtPo6Udb4tTcansj4DUFrWpGGkG?=
 =?us-ascii?Q?yCsYhtMZkjC2WtRX+DrTrkKq5YawoZVwkcAVEdntJlVdnjbsGRKk4wlHatn7?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1B5069ACA531A144BC7E1BF5DF5283D6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sqywPaJjjXgeB+4JS9fGVhHJUNRMyv77d2lnZvwoIq3ZIwzEXWD1u70XkVcC2ZoR5+Kh2PT9/SdJ7D3VrVstu1sFu8cbfjtlqfuwt3Muaa+bT1ALOd3f71bh5zDoMZZXCZYt3G6EiGt3mzQ4D7rdmasylm8+TipzU4/oPDlc/u3z6PEinGsQ1cUTWreMpJTg+pBN29YAQcSg7o1mT3NEIN8IOMyVIkJ14JMMss4aKCCsFZdI4tHsDWLicPAOpt8Im4tgOuApociEcOQLAj/cYwrzYyeOjqG7AoeVHlLNjV6cF6TTDNwJSigXsP8GhfMErrYzs+KC+iRAQHb+ztwkJf9/PVnJ8M7iWkIN+8EaIz6eZT8yzmSf60sAZexUMCdCKzn0OlL1+Vcy5ewNv/AIvdY0RDP7y5yUo4KLZ+TuWugEpMVZYCYifTqom5BcgfSadMuYY8+NzPNoFN03iE91qz5xtHMzzw87QL+8DuTcHX+VU+GIuIVx2vEOp0Rw1/fRmcwrHTKfthN7yBrz3HY/Th63M7SGk3v3oTneDXZXGEKhpDc1xN/77cOZnsjGaGqv/yH7gF63dU0RlCa+ELCxTo50cSYs8NnwOXx168KUR/T9lXFkI7trM9V+QZVrew4D
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d838314-2c72-409e-db70-08dd7b167291
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 05:37:29.7533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wgnplCV7FlSQWddCr1FEjV8/tIWzU/m3KKRaH515qjMueh/6A1fHxQCYfnOSbGhR01E/COJ/Fsdpnhyif4YYww6xJ3ol5xsN1vlms1erSJI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9502

On Apr 14, 2025 / 09:29, Damien Le Moal wrote:
> On 4/11/25 8:12 PM, Shin'ichiro Kawasaki wrote:
> > Currently, when a write target zone has fewer remainder sectors than
> > the block size, fio finishes the zone to make the zone inactive (not
> > open), so that another zone can be open and used as a write target zone=
.
> > This zone finish operation is implemented in zbd_adjust_block().
> > However, this placement is less ideal because zbd_adjust_block() manage=
s
> > not just write requests but also read and trim requests.
> >=20
> > Since the zone finish operation is exclusively necessary for write
> > requests, implement it into zbd_convert_to_write_zone(). While at it,
> > improve the function comment.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> A few nits below. But otherwise, nice cleanup !
>=20
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>=20
> > ---
> >  zbd.c | 84 ++++++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 45 insertions(+), 39 deletions(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index ee095b1d..5e0f7f4e 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1396,16 +1396,23 @@ static bool any_io_in_flight(void)
> >  	return false;
> >  }
> > =20
> > -/*
> > +/**
> > + * zbd_convert_to_write_zone - Convert the write request to writable z=
one
>=20
> Maybe: Convert the target zone of an io_u to a writable zone
> ?

Thanks, will reflect to v2.

>=20
> > + * @td: The fio thread data
> > + * @io_u: The I/O unit write request to convert
>=20
> We do not convert the io_u, but rather, the zones it targets, no ?

Agreed, that will be more accurate description. I will modify the
descrption as follows in v2:

        @io_u: The I/O unit that targets the zone to convert

>=20
> > + * @zb: The zone selected at the beginning of the function call. The c=
aller must
> > + *      hold zb->mutex.
> > + *
> >   * Modify the offset of an I/O unit that does not refer to a zone such=
 that
> > - * in write target zones array. Add a zone to or remove a zone from th=
e lsit if
> > + * in write target zones array. Add a zone to or remove a zone from th=
e list if
>=20
> Nit: s/list/array

Thanks, will reflect to v2.=
