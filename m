Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C24C4F8B4
	for <fio@vger.kernel.org>; Thu, 11 Jan 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=csa.canon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csa.canon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=csa.canon.com header.i=@csa.canon.com header.b="Gm2S9meH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvD7qfe7RuMvq1s3Ntn6nY//ZbHZuM1FtkE9JHLI/lGEukg9GNB9g19im9KpCTVGACXjHRy21mzwdzW5fc2McY7yAmc9xeyoNO1p3NQhT080Ul4fefyU/mZva2QTCeCHjSvvwIEm8l2g6BBTAwZcxnfJ/4XU41dVNWjeQsmofdbnr55CSJfew3xcNlYCd0Mi5S4hDeXSDEbXc4UxRTQitbGcB+675pAdu8sntpvNszQ9qjwraC1+Ycw3lvwS4NDLJ6OxRMqNjQApkuTUwt4JYsECbTyR+yvAc0K08/3SNNvWeMaRRLZ1CAhjoBpV0WYtENuePDvnb50NQlee36wr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cj3/RPcysIwgboFl8FG/m5IKt/+xzpGUiatVqvk2mBE=;
 b=ZtozG3IVSW9dGVc9JDXt8VjLPciU7W3biNsv4ZcOw6MvgPnUCy2V6RX5TlYHt0zBKcktKqWKpF38BT5qE70gJ24n218//oNsFcR2PvjmcFKGw9/K5lpYrnos6DMgamHhaD0zSOXE5bWymeF5vgvUyYXvDpDkazrp0yLeCzbwMLv3Io3mEUJraGdzn8eyMFzGgFdpE2WcmJE/WisqzGm4vSnnR23ifaho+PLB8Sg5IXTdkEBKNSB/IAElH+GX1noy77vG247+lb6BOJobgbZ9EMt2tCTomkQxh4ssIyl/+UI+p3+SxNi/ko9vxprmbNtjsTdH7VrsUgnFzuqvW9jHEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csa.canon.com; dmarc=pass action=none
 header.from=csa.canon.com; dkim=pass header.d=csa.canon.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csa.canon.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cj3/RPcysIwgboFl8FG/m5IKt/+xzpGUiatVqvk2mBE=;
 b=Gm2S9meHoRpZMR9r0iND8NW6dSyTBGFLJ7arhvvfsCf2pPkX69VLmDWLrPowF5MaS9sIcoVCpR0QdyVdcK2H4HfaKbDorsZ419NDXLpmeG+t/zQwg5IuYV9TBoeKS1MRiZ3Xe1n7ETGKJDlwzBcQKrY0ObkkhE7d42w3UzgViSw=
Received: from PH0PR16MB5050.namprd16.prod.outlook.com (2603:10b6:510:162::20)
 by LV8PR16MB6332.namprd16.prod.outlook.com (2603:10b6:408:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Thu, 11 Jan
 2024 16:16:55 +0000
Received: from PH0PR16MB5050.namprd16.prod.outlook.com
 ([fe80::acd7:d843:c9d5:752d]) by PH0PR16MB5050.namprd16.prod.outlook.com
 ([fe80::acd7:d843:c9d5:752d%2]) with mapi id 15.20.7159.013; Thu, 11 Jan 2024
 16:16:55 +0000
From: Steven Clinton Drake <sdrake@csa.canon.com>
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: fio 3.36
Thread-Topic: fio 3.36
Thread-Index: AdpEqYdrnEhuR0ZESXyYQ2O0Y/EsBw==
Date: Thu, 11 Jan 2024 16:16:55 +0000
Message-ID:
 <PH0PR16MB50506EC679BA8D6709EED2C18D682@PH0PR16MB5050.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csa.canon.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR16MB5050:EE_|LV8PR16MB6332:EE_
x-ms-office365-filtering-correlation-id: dc59bd65-b077-4f78-3bea-08dc12c0ba7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eigDGUp5dRPF1ZF7yrCCBd8aogdsVYerMe+7NkNGXX+E8W2WvSnPBOFk6hNz+CWxGgdvWQvd5EclKrn4ry7hPL4qyssyCUy+JU1bZAF1xfzaq3Zw+d/c6v99/sCNoZ3TmkSnyxPEhG/uiaVC01aAs5p1la+ub7ydJiEKKqp0bmLRhhJBklLGu81zK0pQNQCaLmRRlYTQ8I8gEq133j4ItYgFJev12ypedntPN9CpoInuTF5Mhq8aVXV14G88Mdi2k1Iv+rb/8tC/aq+mHRB3p65N1XfhGFJUd/hofap4lPRRopxvSaKsApJhXn+GOTnPfV0qrhODDWiX2Is6DvZ84RkHGlEjnpcu9jWUmsqBcTufZE9mTeI85eUqTUyyBEtNPGOnAETqGgyy5a8N262eNQh8EaFRbfXoZ60lIXXkEarfgAhqHka1e16mEc4J0k/pH0SuCUFwIktB1auzmgJAXZmnIlkxS+pLtsITMWy3lgBTzactxWmMKdj4TF7wZN10tAo5zqeVMlAEKOamBmvTWUM9Nc/nYBPAelDVjKyulcEZ4uNwuk7EJJ7tabl/DhHlL2VjjtRxfF5HWR4dU/JmhRNsRmu/W3ihI5L58wRWiNg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR16MB5050.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(346002)(366004)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(5660300002)(66476007)(6506007)(8936002)(9686003)(15974865002)(8676002)(38070700009)(26005)(40140700001)(83380400001)(33656002)(82960400001)(4744005)(38100700002)(41300700001)(2906002)(86362001)(52536014)(122000001)(7116003)(66446008)(66556008)(6916009)(76116006)(66946007)(478600001)(71200400001)(64756008)(55016003)(7696005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?yoEo6ud3+VWiM7pQaeiPJ14yjGlOjHxBRmrky/SDbqL4MSadxlC+mLVtQ8?=
 =?iso-8859-1?Q?jzr3wXDFPiaO5bKeIOrUVtozJwJ2oSHENc6QeHIlbFyJQW51L5gzRx/Qi3?=
 =?iso-8859-1?Q?eafN3qURlpgFA+mlWOvB8S4SBDvspy5p3m+8XzrbxpFD5J2M6dLUlyOwZ8?=
 =?iso-8859-1?Q?f/Ai5gctgUQYjOCC0o1KIYXfCBcHePsseUGkXybIdjRdbiSbNtSIhCqz6I?=
 =?iso-8859-1?Q?5Ip0RfI8UOnfO+nlgZ9Oh9ubpPp4uwENosh5bPjUK/uOx3LZdr0JR9cNSs?=
 =?iso-8859-1?Q?0LgqjhEhU+Zdp9g6HhtwKWGOgoQJRa67TbwWnPrvBXz8AsMHSMWpORcZfQ?=
 =?iso-8859-1?Q?tVGl3BBraJHtQ+ml8SzyoXWXv965dI8v7PBNsUezi9/hICRMFKh6VZ6xNV?=
 =?iso-8859-1?Q?e/o212OYs1iidL9UtsBDbULNAm6M5TNj6gPevBBqoV2gH1qZXf+f5zi8UL?=
 =?iso-8859-1?Q?lG7JTWac1Fbz8dQSmXPic373I9pNcNgLJ667NeR9Drj4Tt4LCHbGf1wIG/?=
 =?iso-8859-1?Q?S9Lx4/2kadx4iTwphr3JDyUNF+MJi0B9e6ydXmO1p+/EJz71qb0L/y7nvR?=
 =?iso-8859-1?Q?Y2tWTAnyfTj/KppInPKm2e2a3kHek0Pad1VzfQjc4Q2tpXuXo0wbQdKNpU?=
 =?iso-8859-1?Q?uDWjAGT9EOcm5/8u10ynteeJnZG94WmfsdExuZkrWzMGyoi7xQVKvrbvpB?=
 =?iso-8859-1?Q?KGX/gGYqqvBoRNb+StzAST+Lx7moII0lPI/yREDeVyxX5d3OrgHUEC4hmv?=
 =?iso-8859-1?Q?dZyxl8rfw5J0y8IQCCCBSMkFH59TmPA03lBOmmB75NwRAjKrhJkuhJR72X?=
 =?iso-8859-1?Q?eGmOEsu/4gRbIgustupmq/vfMEVXbiGa3LzuhYLiy2ZXlH0gl0l9bkRYwN?=
 =?iso-8859-1?Q?TIwC05BoDE62O3m33whHK+mvgqRt5TDAvgBP+flg5sPPruDOWCHv6b39Iq?=
 =?iso-8859-1?Q?XufGzCufowwqJnAV2WKLcUPsxnB+9ElAr92IH271diw1ZW9h9u+dx1iL7a?=
 =?iso-8859-1?Q?sy+kAq7rTILPuL9+51tkh7W9iMkjsg+GEFIcXHCR1TL7wa5nkPXgxq3eqa?=
 =?iso-8859-1?Q?HMzfOr70hp4ir3EfvKC0/jBNJgyd9WqFqeFOTQw5dDV3KXxfQbnZC20xCn?=
 =?iso-8859-1?Q?kRVJnGSIC+gFgYgyNHwL2iQtkbCZqU0H5AkFFwTsnpDvfrWWYq/L435cCK?=
 =?iso-8859-1?Q?LkGGvhwo34aqOr3Id2xBjXZKua46ILjXlhqdj3y3/1pSTJy844UEJ02hT4?=
 =?iso-8859-1?Q?oqeOzIbONCDj1V9TviC79xxZV+cyhsW8HGQikh38fLW8F92Vs+6aduxPeR?=
 =?iso-8859-1?Q?/gES+zyqkcUo5kX1lN/aXNyXEfJdb8DyhcojD+qGImIFwijlwPNJ0wkKJg?=
 =?iso-8859-1?Q?u+oR5NLxPmdfFdGmXjaLRqoGiuYyPGftccipQ2e4UmQlIp2ynoBmjaKxTk?=
 =?iso-8859-1?Q?/Ur4GyZXtfxmZZ51rcMGvgwuaKDR/JLugYUqhIq62omtE/gitBSws8Apr9?=
 =?iso-8859-1?Q?FHLHWDqFpqFQzjbgv09WnnksafSZTyH1wExHwiXHq+h0U2fxchgSNJo83q?=
 =?iso-8859-1?Q?iH2JfZkRItdyAO6+Pq9wu/hIAY0EtFPaqpMjZ98yc52fcgbR5Bk6ojtNZu?=
 =?iso-8859-1?Q?67DKGW+vXEfvIzpNx4lYFMnyW95KyKlROK?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: csa.canon.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR16MB5050.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc59bd65-b077-4f78-3bea-08dc12c0ba7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2024 16:16:55.1121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5132013a-1c8d-4f87-9f4d-43110f5bc07b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yn7oBYBoKx1dVvnxqJFKUCZRP7tbCSggkYhKloYGtDRe/ewwzdaLNtk211t18Zad7GAW8GvLPVZsOQW6ezPsJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR16MB6332


Fio 3.36 - no MB/sec results for 512k blocksize on SLES15 (only IOPS tests =
are performed).=20
Fio 3.36 - Buffered option removed but variable numbers $6 and $7 not decre=
mented in fio.run - so variable assignment is wrong and test won't run at a=
ll.


Steve Drake
Sr. Engineer=20

Canon Solutions America, Inc.
4560 Communications Ave, Suite 100, Boca Raton, Fl 33431
www.csa.canon.com
sdrake@csa.canon.com
T 561.997.3233 =A0 =A0=20


