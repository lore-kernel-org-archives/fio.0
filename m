Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FBB29ACCC
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752763178; cv=fail; b=VkysMAUPxfKxtr+fSlkJq6wTEXFs93rBWMAjX/tFU3wavvjll8Io/1Td72kUejzFRH2alwftIltL2J+i93T5LRQr9GnfrvuykRpyeGTzxAJmijYcvEgtk7Sf7BbAuBaoBVKi8RozEf6z2dV9RxBUp+mZH39nBKUCWuYKr+yTaCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752763178; c=relaxed/simple;
	bh=nCe4xcxpHTR9WR66nPU/YGyjr/Ks3d+hZGVOX6oxNQk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ibFdUI3BTZ3qGxxI9fqr+4DGCiUv9KORhA4vtAX1MEDv2Y0oeIyIecrcsqhENi9IBNPVQB6ms0EpkLK0KoDCHA75yIEbfg6KQln9eWtLmTdBy9oXNFzWuXfR8OFAG11Ps6HsQzEYtu8k3ORMzxd0oRorRbylppxj6R8udDgjsOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=tLXk1vbX; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="tLXk1vbX"
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56H9HI70018689
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 10:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=smtpout1; bh=n
	Ce4xcxpHTR9WR66nPU/YGyjr/Ks3d+hZGVOX6oxNQk=; b=tLXk1vbXQhi0sGitP
	vrj9L0PIpc7P+Z9qxg4DTEBAa8pv52EnBippUJLAY+p8qxlFJlVoLj369pY5Plov
	I1kyu36kh6scEyCzADnbjuCGqoqSmDja6alCa1dW3rPQAq0Z/NZfyH5arOc09Yxv
	3sCg8lA1Gc8qUKH2OmlBVfhVnWTqSaD0XDT3JJkfyu2+V1sm3CT4zwQSs9jxC29u
	2dCVQjVCAAVH1nsec/P2OpHBv5qIGox1vwosJI6lBxDLOUQG8RpEyvvfnd0PMwdH
	DjPXItG0bFAVSUr1UZFbMagZSiJyYN907tONh1K7bu0+YWTqLQ7rR7ZT3vqPpYfv
	6j/Ag==
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 47ujv1rk7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 10:39:35 -0400 (EDT)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56HD4t1c026432
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 10:39:34 -0400
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 47y1r59efm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <fio@vger.kernel.org>; Thu, 17 Jul 2025 10:39:34 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYL2GYnMTNqAL1PoOmehYlntDHe5gL/KXds/Ic0712PAGyn96OPK3ShOWE4bR1PWQhvrs7gzJW9aqdzMPzIvnJUUoq0NgleyhoKcwol5NVv+q/V7EyNRK77nawR0ro05219Z27syMzQRDDMhYEqHW4RrxVejwpgQd55WLxJCBUBBoNCR+/uVelWI2H2QSqSOY4ayIKJM47sc6rdrVvAdZk+3bbyIJLH3CBLsg+t9a2fG1Oebm3vtmq1BdjWnUgTAce9/Bzhfnke2gPo7dpTLVkOZ6oMuIqXpIo17drlDPBycHvVyFPSQ25kPwcfA0BuGqzBqQLOxFyobgRfOjhfYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCe4xcxpHTR9WR66nPU/YGyjr/Ks3d+hZGVOX6oxNQk=;
 b=yJIn3PhJwQeGFlE11mj+i24HZUXRoOV9EIyVg5rPF1omAIoIesGatTXWJikrUsVn+E0+q7HjtRPH7vh1ejoyrKtXZ6fsyjzpLkdvG2bcyBMPyG6+x9PmOj58PAOQbjSQkYFxAZSZyDN3NXseP8RoLHqUZQ/kn0WrM3CRDmtnNcRL8cVIfA6Qd+DwfIrHWrwq9N8pFIQiDQ6oIHC80sFdbd0xpWvVhSVBS9+ao/NzUO/STO7s+9s85WI0ybvmulxDEQMAfvtOQTffjHWv1Z7Bi2fPy0hv+cWgUJou6q8QxJnRzYl1z9ptRL7v3lBbbfPoMpH/b6XK5jurXV+0K6EzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SN4PR19MB5471.namprd19.prod.outlook.com (2603:10b6:806:20e::13)
 by BY5PR19MB4113.namprd19.prod.outlook.com (2603:10b6:a03:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 14:39:31 +0000
Received: from SN4PR19MB5471.namprd19.prod.outlook.com
 ([fe80::5243:65f0:5655:96f8]) by SN4PR19MB5471.namprd19.prod.outlook.com
 ([fe80::5243:65f0:5655:96f8%6]) with mapi id 15.20.8943.021; Thu, 17 Jul 2025
 14:39:30 +0000
From: "Yan, Jane" <Jane.J.Yan@dell.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: FIO for random seed usage -How to verify the data validation
Thread-Topic: FIO for random seed usage -How to verify the data validation
Thread-Index: AQHb9yiaUAxEbLyQTkqpTAkiKdZ1BA==
Date: Thu, 17 Jul 2025 14:39:30 +0000
Message-ID:
 <SN4PR19MB547194A3A4A1560CB9A2D2F6A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
References:
 <SN4PR19MB547124FE361F26649D8C7517A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
 <SN4PR19MB54710097436252E45CEAE9E1A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
In-Reply-To:
 <SN4PR19MB54710097436252E45CEAE9E1A851A@SN4PR19MB5471.namprd19.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=True;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2025-07-17T03:13:36.0000000Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=3;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR19MB5471:EE_|BY5PR19MB4113:EE_
x-ms-office365-filtering-correlation-id: dec5dae3-0c29-47a0-e0d1-08ddc53fbd7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?MOfx5Y34MEWL1QlXatBpvMQg14ikp/RWIAn5x+2xIDcife1xTOVfdECojXEQ?=
 =?us-ascii?Q?saw7qt3KYvLY1MdsQfSViufqbcGgwP3DIeQuMOLGZNn1Ea9ZNb6SeGRQ0pPJ?=
 =?us-ascii?Q?LqKmUYqcSeis9NYLmxuO944IJtThi+lNzgqT+DdgJxuy+LMyND3yEFSLexA0?=
 =?us-ascii?Q?M0ZrJTnY2EQuTVxy0gTZhnwoNJox0qvoBcf1rli6Bh8Kq5Tekmx9Hv6uwASi?=
 =?us-ascii?Q?xyYHdM+KgjUxxeTMIKlD18KbG/Sps46xM3Hxief/EqB3r2ILoF4xNEHzIo+2?=
 =?us-ascii?Q?WOunYclBjyEbkXS76tEIYNY7P5GZhTVPhwBs7mVAU/juB4m4mZYHZ1C3L3iV?=
 =?us-ascii?Q?tEFlLYZStZG0+93akWhCj02bh/X/C3wwldYq0kUdwZ1FhG33p/7wiI+mdB8l?=
 =?us-ascii?Q?KDFyE3ZXpzusvi9MDckpWE4jsyzveL6hBOuRtE9wv0adgB/PP3UYQ8IXlKzs?=
 =?us-ascii?Q?kLEeeVu8iLvaSQAf6/IoYAMIyN2PZlrwDHUZcQbPNLdq3nDUj4bcPgI84OD6?=
 =?us-ascii?Q?y/wVIxAAl81oe9cqtVbY8TRNnYi7QxBqjwbcpP2kVvLrES0aKFDinGUFnSb4?=
 =?us-ascii?Q?pmoAc7+byYxayKrpN+I6euzRjZ1r0pRO/Bb2xpf2D408umucXJVQ7OEZyGST?=
 =?us-ascii?Q?abYKbwBW3+NdeK6cXe5/puQ5sQCB+9zw3xlDRW3DANSwZdbDHs1Le5Jaj+XK?=
 =?us-ascii?Q?kcxMmyvWrTSbZP/iRiiRM6HJyoCwMwIY9BZgjnR06zQKyAPzK7nx6P+IN0SD?=
 =?us-ascii?Q?gXt+CyiKF6FTAjkm6D8W7yISjMAMquHLKpc4t9JIAOEweZvp1uHs19lOqiR+?=
 =?us-ascii?Q?aSrsKFKQeeeKzHzKvlkMPNsrvucW1N23Ci+g+T2JGW95tVZ9ZkUYk86Ye9Zo?=
 =?us-ascii?Q?4zGaXQ24EejEQ8Y5HswZcmZFavwNlD8U/hl5Rjf56qvY1ZPGgWORwI4kZrmE?=
 =?us-ascii?Q?JW34t2EHGxHKq+8LFXs8ynk0TaGACZi9hCJBhiX5vCH6qQePskCQnvpS8cOw?=
 =?us-ascii?Q?fgR5P5Q0EgNIeo4bZNJBM98D994pxkiROidVZNjFSrnwHfe+b2v/Wi64qyLh?=
 =?us-ascii?Q?UEOn4WTTm5NC/civQmFFv6z6cKKaVRq6CO5JHs/mCmPzxjE4HG+j3cTI/vQH?=
 =?us-ascii?Q?RffYDFprLDaLlWgDJQZqqj7expCKyFsm9wju9aAczsdlGftsNvIcf1ymM8va?=
 =?us-ascii?Q?OPizPeiK974df0tvxUOTL7m5qbUgh4k9nEGNc5WCOYLopDXCoU9PCPiCqETr?=
 =?us-ascii?Q?xyTtbYRsS/vdde8XTTtlbJsfVtXOB9QdxYCHLJPynpR+Og569OM1uR/6Gl/t?=
 =?us-ascii?Q?/hzlaBbIBZR2C8eSqa3StOsd8CX2APzGH8pX7HqlohhWxNjgtTviHNUuccxy?=
 =?us-ascii?Q?jQbXMJnIDGV14Bukl0wsYM2IFCzRbuSyj4uS3tFs4lQasXOPdv2xIpBZH0Kx?=
 =?us-ascii?Q?NnQ37do7I6+e1lJ/SyiBJT54Hraodwx9rhPzL0SYLuI8IKDKP6KIhg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR19MB5471.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xnUlH/4t90rMH78BFUE6wYCtlu9xrl3dONKmamOzwVxEwFy9EoVYVneMg6FF?=
 =?us-ascii?Q?zSGjeCwLiQysUz7chegiPopERq75NAuS6QU0xe6prAGtCHyF6JotL4DQ9clb?=
 =?us-ascii?Q?GL4b/J8UeAedNCfCS8aIc7jOa43h+k5juFnD6McInnAzgd6CwjD14VmwWRjI?=
 =?us-ascii?Q?d9ewxwjHIEBbRl+rWzoaxGwhRqGEZYpX1nJWXgxALNMpWdmm2+uCbD+lIWAR?=
 =?us-ascii?Q?2ZzRpeZ18/YXU9FFCNO5LXp/yKI5Oc9iVE63W8dJmeP/i27ACA00WhnhFLnW?=
 =?us-ascii?Q?WMmVXYDLu3wx2LlHEhDacsgetQuQPp5WmLsTif+Td4LidMxC1Aqjq3R9ZPm8?=
 =?us-ascii?Q?tRoHkFdj64Dc5T4ZjeXgbuCUk+LP31Uz7O5a8K/Udh21ON4QML8OOe8+zEph?=
 =?us-ascii?Q?Rx2bwZ7YO+8mElCfEBv2lYLtctnPHwiM5uLyTbTThyIbUZECbk0inyzYfQzC?=
 =?us-ascii?Q?N0E66SAA6A1Q5ziOkoVNZIgoGJwV4ACvNooq85DAhTyzo58JXOeKZjE7s83B?=
 =?us-ascii?Q?AGfrZXx5tGhPlMi5i7TLo+grFonQWqXdsK+Bd3iLSf43Lt4hikTHJ8AL7vve?=
 =?us-ascii?Q?d8qchZmwHt/WZZlmCOsLyw0MYZeqB6zYVNssfPwXpiRyt4b404B1dl3nxPgm?=
 =?us-ascii?Q?Rvc0p7+t2Z9ZWv2tFbcBkH0OCZESDlu5jVOGMC6+SnVOghNBLEX2OPFbcDXU?=
 =?us-ascii?Q?YfeLXb/04IbcAIq1NLshldRhs9pQc2LiIAVHgwu8uVgep74u2H+mcFFWqmf+?=
 =?us-ascii?Q?SCMM654wPV4u0lqC0ciG0exMMYspUcj+e2/oleFkf/YMev23sCbuNKCJbKRu?=
 =?us-ascii?Q?AE1XHWIdHRGEk7iB+Fpgw5Nabw4LUYqUg2iusd8PLQtBPgmAhKGXJjLZF1SP?=
 =?us-ascii?Q?yGtAgBmRlvU8hGSo3/hOQZZl5lfnecT+ripA+B/8V1K3x8WedViLYYw/S3i/?=
 =?us-ascii?Q?P32G5vTpSlSWlbQ0yRB9xnpoXtTOG9odsJL3B9I0xZRKi8rwbzLlYH8p/gyX?=
 =?us-ascii?Q?ZsaxrdUb1dek01oJeT2ay5rztIh4keTGXnQZV8GVBzHaSMy6dR/R9nSCiHQ+?=
 =?us-ascii?Q?hytpXHcFSKBg3+1EvGthWuaklFx3yrImXH9v4VGJVJ/yQ1W7ucxg14m5UL1Z?=
 =?us-ascii?Q?eu+MIoVOYB6op//4eB6dYbRXTBsx06UrBVzCUJ63C32kbBwMSoq7epH/CrFu?=
 =?us-ascii?Q?+sBQ8ZXeMJvdDaWNWAsWEpJFS4BsbBYQ6xUwcjqK2IadAdwl3HwIcQyjPEbs?=
 =?us-ascii?Q?5dhjZSY0mD+J0+CX1bF9/tUQLV4NEVJqYDYv7YVCDbg6b8novQUX29nIUrQX?=
 =?us-ascii?Q?/BReLjyJK4Uy/8dmbCw+6EENpy4EowhMp2zTxovTx5nr32jvPr+FFxZLAfMP?=
 =?us-ascii?Q?dfS9ZtVBZWgqjHX74S7ACFz9J5e7d8pMPtJWsUmTnhJHsK1UswA4/EiMH8Qw?=
 =?us-ascii?Q?qG9akQLcnj380M8uyMX5ZnIe6MutyZUwNXbeIdgD31ScLZQ5ThxYol3eLG2e?=
 =?us-ascii?Q?L53J3WIrYMsXa7/SNwltCwe0MxjRYeCyI8JNyk48TheoE8JSdYNQNV9SasXf?=
 =?us-ascii?Q?/2KuhWFXkN+EYfMdvF2WvzR4R/+WZxCFaWJ5kCMBaM5ye2SgYRJ3bNFX1dx3?=
 =?us-ascii?Q?ngZI4686PNhcfI4CdUdboZtmCpHCT4gtExAqzXsxZEIF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR19MB5471.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dec5dae3-0c29-47a0-e0d1-08ddc53fbd7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 14:39:30.8787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: COxDTxiQBOnGlosAoHrHXMqxEy+P+/KMJFwuYIdMq1EfckUevYs0thFwBemxoS6RqGJiKgRlh1BaGrSc4VmV9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB4113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_01,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507170129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDEyNyBTYWx0ZWRfXymFRh5XuhVkQ qiGBMChqOMxnwxiIE1ulTDLT4D7fsoHb7YEuV5QwFPJT4nMAV86BtSx9N8k/wB3ktKbW6PMCNqX BZyU0LST7WV3kvy+KV4XR8yvqjbbANMQ5d4IL1aa+0wAOmuKrNMLkGJ2zdwRsT9nirzQcrZD+RV
 kXW7DZkis4kBRKnkOUHRBfYcXJkntlwBnAiO9f5dIvxX+2CQlNDalXUStvSLDrlzUiYX6InzFLn wgQ6Bn+h8on2+wa9SbYjL7mLADVGB6cznqtj8ufuLnlXY/2GF28/LHsp+KtfHXyRf99tGdTdEnQ cBMD4wcnBj7UgRcAos24QIi2rmIjTpIQclD3Hj1qvuHNtUjq4+Xn9YRWYFb7pUKonT3oKecxVTM
 v66FR7G6vXp9W3jyFdEUVpX6CDzGdQauBxlpDel5dcpnDIW/+UcnshIh31Nt7bXcCIwy69HG
X-Proofpoint-ORIG-GUID: _Bq7EMJ6pAaEZuR5GGlBlDm64BCVrbVb
X-Authority-Analysis: v=2.4 cv=SLtCVPvH c=1 sm=1 tr=0 ts=68790b27 cx=c_pps a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=Evk5wVLeX_X1tTn_Vt8A:9 a=CjuIK1q_8ugA:10 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-GUID: _Bq7EMJ6pAaEZuR5GGlBlDm64BCVrbVb
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 clxscore=1015 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507170127



HI, FIO experts, how are you !

Currently I am using the FIO tool for some testing ,I got a problem which m=
ay need your help , Thanks a lot.
Seems if we used the randseed ,we could not do data validation correctly.


I want to use the randseed to generate totally same data pattern to do dedu=
plication seems we cannot do data verification if we used the seed ?
Can you please give me an example how to validate the data with randseed. T=
hanks .
My step steps:

1. Write configure file:

[write_test]
filename=3D/home/cyc/tmp/seed/testa.txt
size=3D8k
rw=3Dwrite
bs=3D8k
numjobs=3D1
iodepth=3D1
direct=3D1
sync=3D1
randseed=3D383733983
buffer_compress_percentage=3D50
randrepeat=3D1

2. Validation conf file:

[write_test]
filename=3D/home/cyc/tmp/seed/testa.txt
size=3D8k
rw=3Dread
bs=3D8k
numjobs=3D1
iodepth=3D1
direct=3D1
sync=3D1
randseed=3D383733983
buffer_compress_percentage=3D50
randrepeat=3D1
do_verify=3D1

3. Modify the file testa.txt and then do reun the verify file , which did n=
ot report errors this is not expected as I change the testa.txt file ,thank=
s

Thanks a lot.



Internal Use - Confidential
