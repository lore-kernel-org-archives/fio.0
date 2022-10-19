Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E49AC4332F
	for <fio@archiver.kernel.org>; Wed, 19 Oct 2022 00:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJSAeo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 20:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJSAem (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 20:34:42 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4112113F26
        for <fio@vger.kernel.org>; Tue, 18 Oct 2022 17:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666139681; x=1697675681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+rU90w8VsvUFjRqpCoq+Jt5j1adezIWvgS+qP3hY2qQ=;
  b=SeMa9ZuZVlTTYZTrQXydQGM7joDvvb3WqXZay6ZlocqlJDztCSasQsF6
   rIVMtWAiqY84BkLSX3aMIi2yR3Q163ElgcmBZsquCeSjHLIFnVtn56n1u
   wPaBjyibx6duynOMvdQVmQjrH5b8ncItiLq/eZASb3/nZCa5ICUVeLhsH
   1j8983x2R5BBmSglZUm5XfT/TnBySqVcAFqLwu+0a64hdorxRo5jbXVgI
   DHm2XvXp6aQ8bJDUNr6PYOvy2Gs9e47Y67OHs4GPnVFdykG0Oxz8ZgCxX
   KFHv+HWmVRciG96XnVz8emftlFADa5woKqMi/IFlXZGegvtTf/yhro1PN
   w==;
X-IronPort-AV: E=Sophos;i="5.95,194,1661788800"; 
   d="scan'208";a="214173911"
Received: from mail-sn1anam02lp2048.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.48])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2022 08:34:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbamkeKAR13KwtIMeGbmfsCeSjBI6zRBsh5nXU5OpG370TuLewGj4lQw0FxQzlkY2FILiKEh20CEVC0CQ006A52KIvquXaZ4K02uodtU2h4fhRXGt06vbuoVZXDsG962JcvKmLnI5zyrX2crw9h5pcqNvB93vCMzq+ije3PYUAoJoTd0smwkWZdHB8I4Y9DOSmQIfkX+RAE1RJEOyZdTpj5JPWG5c4MkA3GDOqrAGXavGaV4trLGVfqjUr79eCQdJzMbM3kX3DHXx670qNLL2Vc4QJGXUFoi+N3J5WDXhkMG5wvtWRfAH0ULakEMIg9vhMe2ORMzJug0ByI+gsyOlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YX/OUyLJyPAyWg69tDFWZSg/Z9XKEnmp1MB5nsPGcVI=;
 b=dGXIPFC9bfRSxwlJ3e0S/823u21yzsMJyERgJk23yJoypJ4DVGspvwln0P9mB3bWhUSZQHVXYTz7eAiVCRAwi8Vi74CqXN1Pa7eT2h2QwR6Z6jgBJ8s31hrK3kdV5pPGkhkGnFSrR04D98aYHV0uohcQ1rWj4X0BqtI6SeUEBZnV70pkqLFpOoO+kr2baK6lu8upU5vImvsMhEXvm21p4MAvkc1xodn1QsVks3LtaWrghzqT8M+IgoA62D3lKE2QcrS+0rLsomZQ0dtaoH0Sjgsj+v7h69+inqJrsvONyJMVpJDv9BkdFU0N9vWnmEmA5KDt1baa1Rw0hAIchqYe2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YX/OUyLJyPAyWg69tDFWZSg/Z9XKEnmp1MB5nsPGcVI=;
 b=rWynUMibXJKz9E8VTrpeeRGJGAoZLXO7oPYMRtg8hOdsSjrVdH9or7ur1zt1IV2eBsqYXWz8fshxLYceoBvCLtmFwt9MO+THjhucVxprxzuXbnknfTXWbgE/H9yktIj1ExUQEQCBswCVDXIlUVDRqQSqEbhFmLpnnkkCnZ4nrZU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BYAPR04MB5269.namprd04.prod.outlook.com (2603:10b6:a03:cb::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Wed, 19 Oct 2022 00:34:36 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::fe3:cfe5:dda0:f9e5]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::fe3:cfe5:dda0:f9e5%9]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 00:34:36 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Vincent Fu <vincentfu@gmail.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 0/4] fix experimental verify
Thread-Topic: [PATCH 0/4] fix experimental verify
Thread-Index: AQHY4qiMJAk45gRpqEKWk7OJVSqnS64UVB8AgACLrgA=
Date:   Wed, 19 Oct 2022 00:34:35 +0000
Message-ID: <20221019003434.phkgrtape26sxgza@shindev>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
 <e1d0b1fa-b36a-1269-7d3d-4998d2b62177@gmail.com>
In-Reply-To: <e1d0b1fa-b36a-1269-7d3d-4998d2b62177@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BYAPR04MB5269:EE_
x-ms-office365-filtering-correlation-id: 6f268d7b-ee42-41a8-6ff0-08dab169b320
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Isw/ga+mUFa2N6y2cjaRHlVFxRD2BTR6/Bhw+kgOTB8kg/43T+5GRm/z6uUAVvBDmSTY8pscHeAXYLY4lzBlZqPeoLJaknHdKX7AU419jck6IDJrbu7aQE+3k2JEx/blufVUm47CMgM32kH59nIGJM9yRXK8P1nTFM037meNNmj7WObVMiqXuknuZMvhFiyoPcNMwoTcSqO53rCZgR+YQlIWkNo/PvjwR9eKxIPrgzCOmuRsc5JW0mv5Kl9NBojZqgdJBjsFoz7nfNwcNoGITGUS/Y2+vH2AHkb3EGUlWQvTLfj0ob4x1uB83GKJBlSk0byXwjJ8YI2QELaG/mxBSImSf0bwI5/nBcq91RbVNIwygUT+sPuYEwbx9sOYJO8/dzb/DbN6M9GXbCDxUUue7n7JxLDMoJJ9hKfkCHhjqPdQe+s4MKKTpZJCMsY+qKUm86PeF1mgG27J9/gmkv+K922GBu5E0pbzj0ijRQKMc71w+N1FJiByzUIk06fAQQcZUoXZVysANCSrE1OyJenjKIGAm/qg43DFcsnE/qXfx72bEYwm/Rb45KrcE4L8ulDJbwC+yybEPC088W5HpvrtHRmjWXsrn9yZSXMZkSmd2FHXTKIBeqT2737vxv7/hQrwy8cfMEXmvSsDBD2OMPWgkeXnR89uW1gnQjydzHYRWKRHBcoDzeQYhIyEg+gLZ74bVU/W9NkhYjcH8cKTu/lQIlXO2Ze0pxBc8M7BGnF7BqYshvGqoSag+loFZanBVc26LFXkDx9bri4TadfATFUsqvypOmPXHePsDVTHXCsEeCo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(76116006)(38070700005)(86362001)(82960400001)(4326008)(26005)(41300700001)(64756008)(33716001)(6512007)(6506007)(66446008)(8676002)(5660300002)(66556008)(9686003)(6486002)(8936002)(966005)(91956017)(66946007)(71200400001)(478600001)(6916009)(54906003)(316002)(66476007)(44832011)(38100700002)(122000001)(1076003)(83380400001)(15650500001)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JiLM2AhyVWcaRlon08Mpfy5Tch4tX9p1D6YB2Kj3kvmhm4/aUeWXJjxsMzcb?=
 =?us-ascii?Q?dFdOOn0uARNEbZvRpBxWgQdswViaWn1/dhPT6gr4U7vGk0Z7Mo5cCSPg4gAI?=
 =?us-ascii?Q?JdDJISgRvAXuO2v8Ehwh3pH+05159nXdk/Hq2Qxg4TJV2g13v+KQmNsk7CWJ?=
 =?us-ascii?Q?nWGImhplBkgVxAowAVo7/8xbnTEwDbfQWx2qmYBA6OFys9UiQGX1AXN1MLst?=
 =?us-ascii?Q?NZ7Gl+v7reahPmoA3AbAiSKtl0tzLJNHBlspr+B4j76vIIpIfexo7fM/id2r?=
 =?us-ascii?Q?+b7M+YRfoY819awmGYBNExBmgBNwZtXIKEw9iLwKvNjJuKQRRGzXtDoB7Ae6?=
 =?us-ascii?Q?Z9XyxQ54UY0EgXywacnrBZMpsf1hyyQUZyWQssXUeuO2tdl6kHHTL7hMeSqn?=
 =?us-ascii?Q?HAZTAy0J3hbZ+qKHJnUxQEhlRVnku8X7Y6k0D/++SJ0KgRm5+vtufZYcntpf?=
 =?us-ascii?Q?A8uOeIxjajjCCo58uYzppdnm8cEykMdIdH0A3thwCq2gNTnMUdcF/4+ox/OZ?=
 =?us-ascii?Q?cwK3a24MxZslgt4hLBWWUJ3J//3UkP/vbZN40lIosZ7JvTUHuuf0hLSDFA6G?=
 =?us-ascii?Q?yMHBafNeAakc6Lj3JxyfKS2Ax2XBeE4UMH3pnFmgMm9sYDz+4vVHXZa+SfsY?=
 =?us-ascii?Q?mBuY4UFk2QSWAYnIdWd3KuJg22Pmzjv45iedLw6TuhQQj6VVBPggKuSZBERy?=
 =?us-ascii?Q?NdLfMa0y1/jEvsO2DYfDHCg+GOrY64HLEFzuKENzFjNid+RzrHSmBc9hitOx?=
 =?us-ascii?Q?WXaHHLm5H6j4ZPgmeU8UHpidc1IkWTfOVsJYO/IDiqVq87Dz+kS4MMSPBA48?=
 =?us-ascii?Q?I6yDUO7ReLvjmURaUqgEY4agiBgT+inBnhBpyq0XHYtR1cDzhhzQJM0CzqsJ?=
 =?us-ascii?Q?rfoLp+3S285j5eybPnS17ALiSVeONef8I8uD8xw9M6owe8ujGIwsA7lJqG6c?=
 =?us-ascii?Q?k//jxUwBQEUPhsY39u5K5Sv9v0xAzW5tbNlnRnrmXptokAxgr4MnEAl65CDz?=
 =?us-ascii?Q?hsqQg7njZkO+Uh8zbF37daoHVehoMO7dqrCHkl56sU+o0qLsbkjiUq3XCJ+U?=
 =?us-ascii?Q?xU+BAI2l6mqDcxphNY3pudIo0SGCf3Ez66GfjcZO4RS0wf/N6AO3VrY3DSZV?=
 =?us-ascii?Q?Rz0vlx1GwUjf01pWRfuYe1pj/B2n0qQZWYa8h+j+qM5WA9zNA2d/I5WT2NAk?=
 =?us-ascii?Q?x14rUHcq0wSsWv/XyBr07Y+CqeO4jCecSNVXE4o6LifBEr66HKdryGzbGhKQ?=
 =?us-ascii?Q?NyO0+LE6LzCzM8AEzSerkZaEX3xDXdCaMXuhFKU34lDKZ5B9leZFJL8ofnpg?=
 =?us-ascii?Q?qMFgtBHOoBH8mmeUvmZ4lb75XPNP7GAh9Q9zr0vwN5OJLpW7ejPGTE3hEVw9?=
 =?us-ascii?Q?d7RBUPcNqGPizae8eeCzuXOHprJXcfaxxtM4T3C4OVFCDZg7Cl/ViCjB3mzB?=
 =?us-ascii?Q?7c4she22Sfwql+vtrLhN4Wgj9CLcPOVuFNzoRZqLikQjibFdpCzThUqpHQUh?=
 =?us-ascii?Q?mbaCgKrJGm+vbhhmpKASEYavWcPGPF9GEfa6Jj+k25rJ4j5s/TnFdmkkggbb?=
 =?us-ascii?Q?gT762YYYMXL5sO87O8l1ieT3gqDpfY06VHN0sR65rDKjALMwjjHcwYjQ5OkD?=
 =?us-ascii?Q?upgunBqYlHaRVCy0GEsczZM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A691F37F78B5F84DBC85549D7774E6D4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f268d7b-ee42-41a8-6ff0-08dab169b320
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 00:34:36.1120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MlZE1l3Gd0nDr8lbCxrIb7iUPdIHdM/P18/KD5x6rgUs0M4J8kT6Cu0vJvXryr2ns+6bxYG6m6FtrxmU2tQXDQuYUWjduMo0F9MxfpodqMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5269
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Oct 18, 2022 / 12:14, Vincent Fu wrote:

[...]

> Hello Shin'ichiro,
>=20
> I applied your patches to a branch on GitHub:
>=20
> https://github.com/vincentkfu/fio/commits/exp-verify
>=20
> All of the automated Linux and macOS tests pass but on Windows I see
> failures with t0026:
>=20
> https://ci.appveyor.com/project/vincentkfu/fio/builds/45105941
>=20
> Would you take a look?

Thanks. All 3 failures reported "bad header rand_seed":

verify: bad header rand_seed 59864971564696990, wanted 1584616954246794908 =
at file t0026file offset 1019904, length 4096 (requested block: offset=3D10=
19904, length=3D4096)
verify: bad header rand_seed 59864971564696990, wanted 1584616954246794908 =
at file t0026file offset 1019904, length 4096 (requested block: offset=3D10=
19904, length=3D4096)
verify: bad header rand_seed 822895868, wanted 2592444842 at file t0026file=
 offset 1019904, length 4096 (requested block: offset=3D1019904, length=3D4=
096)

The bug fixes made experimenal verify work again, and unveiled another fail=
ure
scenrio unique to Windows. I walked through rand_seed handling in verify pa=
th,
but could not find anything wrong, or anything os dependent. I guess intege=
r
type sizes unique to Windows could be the cause, but not sure.

My Windows development skill is dusty now, and I don't have Windows environ=
ment.
It is difficult for me to chase it further.

Or, it would be the better to disable this test case for Windows. Is it ok =
to
add the requirement below to this test case?

        'requirements':     [Requirements.not_windows],

--=20
Shin'ichiro Kawasaki=
