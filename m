Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A346C433F5
	for <fio@archiver.kernel.org>; Tue, 18 Jan 2022 21:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiARVK3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jan 2022 16:10:29 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:14926 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229669AbiARVK3 (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 18 Jan 2022 16:10:29 -0500
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IInU9Z029249
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 21:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=Lbhan8EfQ8FIZ6uxc9If6AbeTSMWMQUQXSs7Es2xQNg=;
 b=FaqE1FHprnJ7EzZNCE4zzPie6h6FTesr0QXTVCSytqtMgS9yL4aBNNAEc22gO4aE/zhe
 dpTrvu6+OApDjOc0/qk9hRrM5gVBFT86GC4LqYXE5i+i/qkig55BCNCMjlwD7l2Pc2Hu
 V2JXBSz0oxrl3bCKRZfN/pIkjzTlHM4ZwiRfX9Hwk5OHOa66990GQjekI/1oBsRz776p
 iCANhvHYKxcPJRMWyFMco09hqs2xQ9gmDuGGdEaMpVhbcB4HliNvZkbjuJxJY5mp7zLL
 u/JgOuwYLzkKadXXqwiGuLmu09OlBKNeP7aesdWUO4JnAeY2pXAaqXIi3zyt8hrANpub 5w== 
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3dnywstnvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 21:10:28 +0000
Received: from G1W8107.americas.hpqcorp.net (g1w8107.austin.hp.com [16.193.72.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2352.austin.hpe.com (Postfix) with ESMTPS id DBA12B6
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 21:10:27 +0000 (UTC)
Received: from G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) by
 G1W8107.americas.hpqcorp.net (2002:10c1:483b::10c1:483b) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Tue, 18 Jan 2022 21:10:28 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (15.241.52.13) by
 G4W9121.americas.hpqcorp.net (16.210.21.16) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Tue, 18 Jan 2022 21:10:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=No1eiTZGwnGrUobZ2pOf2hOiuRxquixGvwrLR/g4rrUR6VP6NaAx7ujAj9brLcKYYcSIziS/vds7d6hXk6AOT5/MPZ1cOnuXOqjwiid4Pekyg8dNR02QpK3dHKgfugijVqcZYsnhuK9h3OUephz4TCW7bXVfEJxzxQFhB9vq5BXlMa7FdyQxL+MElKMgeIINnE2WeL/gy2O3QEaI9tok5m4c8xFWbHrI+2czC9T+knG32VhULdSxuKACIOwZH0I3fj0MdEcWi1RNsr4hwBHVvJIWv7+UY1wwh/LE8kAWJM+5Svvzy9y2G4uVOKGNV8ZmqxX/DP1o/fq1H5MWRr4BpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lbhan8EfQ8FIZ6uxc9If6AbeTSMWMQUQXSs7Es2xQNg=;
 b=M9PdmRVpRYQds28FAsz7KFCN6r3ghdNo9ATeW+OiKYjf/a8YUog4kwZxN4qEtMyBwDUhWxlTkP+BMpPkaRo+dOxjjCYzq9HUY4PbOmSbGHgrn3IbUykjXoP10iK6YA+qsamp9XtPl31QaalwhkGwPpoiI4669nkP3bmjxY5QzD8mj96t4mijiatmKAtfYUqRcID2L7igacFeWgNxk70wFpzvEYJ2WagusR+roGbLtjz33pbgb6Wt5iHrshI8o9wtF69xFa2pgfzXrYqM9hWmEY0jvz7XbbfO4jT3zzLrBPeE1LIMep6gig3ipbuzb9mVLqp4Tc598uiuW2J69Cryog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:430::10)
 by PH0PR84MB1645.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:171::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.13; Tue, 18 Jan
 2022 21:10:26 +0000
Received: from SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5412:9971:9c86:1e74]) by SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5412:9971:9c86:1e74%7]) with mapi id 15.20.4888.013; Tue, 18 Jan 2022
 21:10:26 +0000
From:   "Gibson, Thomas" <thomas.gibson@hpe.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: re; How do <>rw and <>rd_wr disk tests work?
Thread-Topic: re; How do <>rw and <>rd_wr disk tests work?
Thread-Index: AdgMrta5hWw6IKUfQBycPuSE/E9kIA==
Date:   Tue, 18 Jan 2022 21:10:26 +0000
Message-ID: <SJ0PR84MB1434C484CDB0DE5E4A19554BF4589@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73a96fe1-cd5c-4f9b-2153-08d9dac6f2e3
x-ms-traffictypediagnostic: PH0PR84MB1645:EE_
x-microsoft-antispam-prvs: <PH0PR84MB16459DD9D14CC91E505E5792F4589@PH0PR84MB1645.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rp80esesCSx9cp/0ZI2EbSkfnw6YYErf6XElansGtCVsUeiL4Tzv600Pn+ksYmSSx7LKrGC7oroVxjlDp5x4n3WSQnatNbX+/HAAbzHC3d8hzxDPKq3eCBqoRHEiQSqraoYG3syMAPNhAzNLPzrvrgCquZG/lbF8pilK8KYqrnCEsRBdiRc60XbgeHeYX7N4Z8jt59/b3JKyz/kVaTh55tO/MoODebYYpTe3P/1oN2HblqxqTe5U1G6KESr1H8iWvGlsTW7kB0T0F9AqDKfRAl01t3ox76qqGrINn9FyGwr9iRIZeMPdlvZCmgj6Z4eg13PLw0vzBAUgh86OtHurcgHF8fyPNs29IuQ9cAvRz1w18H4f9yw4l3aBoiN50bcmDq0XSUxKP9AQe4GA/yypjNWIiGa1Nfu8FvhYO2dGdN+UnuRZM0eYdmDY0svuc6UzKyiaicqJHynlMO0VwuvdS0hNLd3apP9mclgQOX+UCmVD394og+9M90yl5G9q8cvIOyVLtUhy9rnBjcXRqTnQZWwzXLA9iQE8raYBOl1SLrlyE+ElOXFWdI7Y0hIQFklj61wftUZ10SZSrXpqcMUE2v7Mk43q1g0s4wE6XL+EQXWfnXz4W6WUCyzV5b3HopMmCVrjzdjJpcZPnfEK56zaC7zEWRiK9qfRBDsfpSaKQZBe6eV+Bptcq22ibYNLv1x1YkW8JLQVPZKLnjFVnN0NUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(66476007)(9686003)(64756008)(71200400001)(66556008)(86362001)(38100700002)(66446008)(5660300002)(76116006)(6506007)(4744005)(2906002)(122000001)(38070700005)(7696005)(508600001)(52536014)(55016003)(82960400001)(66946007)(186003)(8936002)(6916009)(316002)(33656002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AWiOSpt1zaeh1/dm+AEblunUs6HQVhQF2CJm8s/LSoB042I/mEVf08P7YpOf?=
 =?us-ascii?Q?igx0kxrgDm+u3Ag4chdWTJI8ydQNiO0EDh2+UD0BAy3nomCMP5gI0tqn22dC?=
 =?us-ascii?Q?fEeRgsJemRg/rTB6zGR0VSbmOX9rpNQ6hlOluFQU1ctvBaToYC+vJh62yZqL?=
 =?us-ascii?Q?OQN4GzIVObS55HxMDb53UBRKQ8xucnIMLhUjyyVQ462Af55RfoQtQqjlxgK0?=
 =?us-ascii?Q?H3evrshblfRLk94FBUeqjwkms/KT4/rq6YU8STi31KkAy1vWj8VxfMcJXiaD?=
 =?us-ascii?Q?s5MidlCKAt1+WlKREHffCK8DfNqLmj2hqnD3uZvPKYMXU2QdKmI7Maev3HYX?=
 =?us-ascii?Q?C012X+jFSF9tTAXiUSJBoRMNaGDfpObI0SUoeabjVgFvtXJEr653AMGOQAv0?=
 =?us-ascii?Q?ZDP46fE9d9pAjzK2LZR79tnM5ratAchXmKMDxYm/hzBa6cVWHO4PDY48Jq7G?=
 =?us-ascii?Q?rCLcefjl1/Gm+XfZ5EVZLlUjGvjpUhLk0Go/vuBoKXQP2YdXQWSNzSEjVQcg?=
 =?us-ascii?Q?yUsgJ0GnSrwuRvl+yTswW3LPVM6qC/y79K+WE+Y8/iDFnUO8WGcV6g5YcAj5?=
 =?us-ascii?Q?vYPthnEFKZaggsmDkFIym4n0OAZ/7gyrOULDq1V0iKr7fcC2GeJeEElmGZAC?=
 =?us-ascii?Q?MZpCNOJANSGwokq3SLJNSLtA0OJL/MfQ9uv8zj65dBs1TTM8aJkPrKGdJQNR?=
 =?us-ascii?Q?qhb6hyQ5eu0k15BkphosBd523kGnKuh5TlkUVDWmLIMUFXmGEbMdPfMwIvEm?=
 =?us-ascii?Q?9PADnD3XxF5yahAitnIBgd3jRckYNzXCnodPp/N3GPyI13nssU3P2A6ZuwgK?=
 =?us-ascii?Q?m/Vpvx/Ayx1inD2GPb1jOhC7tK3v4tE+BDdav2epNouU852lNaQRHL2/p49J?=
 =?us-ascii?Q?SxsWDWHVfVtB5kWj7na2v5iV2OUpciX7x5d43DUyZaBn6DwVES9vBrk6bKfe?=
 =?us-ascii?Q?1dcbMqtZrh+gbl8O+vf4yvR6Z6/f4NlfsGHprk0xSJvAvV0Ib/B8kCLmURXy?=
 =?us-ascii?Q?aPoXPDlM3DTdzFJrdQjFJtScDHnSVnqtq7nzrigmTvdjFmaoIwBreac8PKGL?=
 =?us-ascii?Q?a0VL6XJ23gdvZN2lCkZCTg2CrhkyhbwXy2EWbu3WFtjHhbEDCQI8db+aVPms?=
 =?us-ascii?Q?P+y2qappT9cIVTJ87FCU1oIkEAejukB4Sv/sM5cKEx7HiDkPEvE+BGbvdPZK?=
 =?us-ascii?Q?WXxbvf3rWj+I34NX9Nj55+6aktvGzdeYy6hzKexFmR3f76H27PI2215VLQgg?=
 =?us-ascii?Q?WZ+shVG1jGBHrgP0z1vn4NGQ5CcZN5KxTsjoXz1htaUsYGSqBjYRcDBJoSIF?=
 =?us-ascii?Q?5cPkThG02DJe9kbYZWL5yrjeBLm2LP4sqfDqEQOqDa9rJoyjjReAYnl9munX?=
 =?us-ascii?Q?kuGYjSQBnEAZftMTwDKTItDSzD6a4nz6hqPIyjuTc955jUOke6/7gfZ4Fqpe?=
 =?us-ascii?Q?wO3oGLLBlUeJPsnyV/bjLSG52rC7rVhfUUh1Kd5sZpaBqsSet29Di+YGkJWO?=
 =?us-ascii?Q?cefN9pt7uxJIqlY0XCVvWhJ3tTbUZ5FSj72T0hTPku0kzyt5QasLIapB/Vwj?=
 =?us-ascii?Q?/yl8+eN/wpl54vqHYxWXzeXJmhFtxpBhqnt4JZ4J8BNod2NNB303Ct9Dpno5?=
 =?us-ascii?Q?VwAH1ZKIUork0s4uGemJd36s9I5K4Nh2UTfoglQpzobbkOaWhLQEUWW7wbZt?=
 =?us-ascii?Q?PtYX1IG2u0OXuNspzsUe18kHLU8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a96fe1-cd5c-4f9b-2153-08d9dac6f2e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 21:10:26.1893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9QxF873CG6+0orc+nus0w9/g/rSje6MXDVA0tFvkmAQJT6GdbDFjRHXAj9IasXPk3RWZOaQw9L3b2aRRa1Ang==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1645
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: yPNzKYVzzl3YybcT6M23vji9cEbdBZlb
X-Proofpoint-ORIG-GUID: yPNzKYVzzl3YybcT6M23vji9cEbdBZlb
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 adultscore=0 malwarescore=0 mlxscore=0 impostorscore=0 mlxlogscore=687
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180121
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Ok, so I've gotten info, from sitsofe@gmail.com, on the fio test data betwe=
en
      seqrd, seqwr, randrd, randwr.
and
      seqrw, seqrd_seqwr
      randrw, randrd_randwr, randrd_seqwr.

That person that reviewed my test data, id'd that cpu usage was not an issu=
e.  So, I'm now looking at my buffer cache size and what unneeded processes=
 the server is running that I can turn off. =20

I'm trying to determine what things on the server will affect the testing b=
eyond what I'm currently addressing.  It was also suggested that I add "ios=
tat -xzh 1" to see what disk utilization is like.

I know this is a biggy, does anyone know where I can find a copy of JEDEC J=
ESD218?

But I'm still left with a basic question, are there any kind of documents t=
hat describe how the tests operate internally?  By understanding how the te=
sting operates I might be able to identify what could explain the results I=
'm getting.

Tom Gibson
hw/sw engineer
hpe/aruba




