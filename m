Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FFFC433EF
	for <fio@archiver.kernel.org>; Thu,  6 Jan 2022 23:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbiAFXam (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 6 Jan 2022 18:30:42 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:51287 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245467AbiAFXal (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Jan 2022 18:30:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1641511841; x=1673047841;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=2e18T9lIKdgbwrjTWg2+yR1h5HV86HGF70wx0C6r1sw=;
  b=avJk3q60vUa/m+Gfv/vyzjdUy55YpFPjAloJGrB1KAVgkYoIVJoRU4Pq
   hOljKzjibz178oG5DXdDRoQL7RqYDCF5Rbbo7W1t4qNfU34siiS4ShsRB
   OXL1DKFVXQpQP3uQx8iiVepql6zErtPj+kBs1oyzWue0QP/uUCHhss10K
   MPCjxD3QyJnkiWLFibxG3UES3drtYj+X51k+hC6qwCVuWKcZAh171dxGW
   hp4gnJObaqK+cAr2FrD2apu9nZJdf4UwSq8WEIdaGoZKyXOWWITfC59bL
   M+sZ/qeKZWleTXQQ7DrbNcU6bDsrjYArsZsKEndb/zQHHsK0vzqE7qADe
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,268,1635177600"; 
   d="scan'208";a="293930812"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jan 2022 07:30:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki6APPyYSzsauiWO7LYPXiMEIiXrBSKspbSCRTHt2APacpB1lYwDkzchj0hRvUgoWzqUx0HdO23YGvm8bjZQUaVS6bDOW68hEWzkhvzotYz5jh/5EJxLCEs20hun7WEnV68rO1FRK7lapPh6vosNQ7IObi3e7vOSNTz55om5wgW5Dbue+XwwztSONwj3Bk7VRgnZba6gyvzSkp3qtHZt9avIBAYJa9iFZdz521qyaGheFepqYbuxPJGg7jNk2A5cMOTokhRGHTb65CXCWm0PXDXL1M2fQ+440szbFXyC1ErxqkfSahTQvoCEvq/6T0BDnFz31CBrBQHyU2u9MkpUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S83iS5kyx60qvzpYNjJoUoZi93S/uBRKgviU71xmPDQ=;
 b=Fh4EYSkoYe5pKQmNRa++Oy8JNfSc22nk0pYPgLa2GP2u8obXYePzIf3I5rJ1m+lrZ8EwNB00iFzTD5SAdxzNMD8OkEbNWEYivpxZLl/TcVjn2vklN3aKDCJZs0SahnF+Lc0v0tD1cP9UC8CIwXdVyz/7VURIdu3o4btykOOPIS4vjrFCY/dDWhwu65JTr0qFgjU6SBDKJR449OHLkwqTwNlKh+oTj3EMwv7oB6qFPr7Eu1Ns2NQGshmD8G4KfW4Ha08Y1/vPAtYRAWjedn2uWRhnQ68rUFbUK1YrFmAJCFTWplns1CqCt6rxE65mOk2X1j4DTvjCi7PPMz+8B25G9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S83iS5kyx60qvzpYNjJoUoZi93S/uBRKgviU71xmPDQ=;
 b=foZMgIUhwJiobbpc+b4bdgr+p90ULjXmT1iz7nl6mWewlwfMuHqA7TjbcgLKpAkjxA+vNpFIyccoynTovRr0U/+XEFb6eU3qXwrH2pXJUhFfkYAMfeftVwVFOacxcMAGRVgKWBwAdmoCBvOU4MM07ObEGxU57f6v+RJ5q0NDByk=
Received: from BYAPR04MB5656.namprd04.prod.outlook.com (2603:10b6:a03:10b::31)
 by SJ0PR04MB7743.namprd04.prod.outlook.com (2603:10b6:a03:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 23:30:36 +0000
Received: from BYAPR04MB5656.namprd04.prod.outlook.com
 ([fe80::f849:cf91:99b7:3ad0]) by BYAPR04MB5656.namprd04.prod.outlook.com
 ([fe80::f849:cf91:99b7:3ad0%2]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 23:30:36 +0000
From:   Jeffrey Lien <Jeff.Lien@wdc.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Brandon Paupore <Brandon.Paupore@wdc.com>
Subject: FIO Dependency on LBA format in Linux
Thread-Topic: FIO Dependency on LBA format in Linux
Thread-Index: AdgDVVP64HIClOYCR42GvuSi6iqThw==
Date:   Thu, 6 Jan 2022 23:30:35 +0000
Message-ID: <BYAPR04MB5656A96F86BDED72F1823510EA4C9@BYAPR04MB5656.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7bfd164-4216-43dd-052d-08d9d16c8a81
x-ms-traffictypediagnostic: SJ0PR04MB7743:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB77433F8A454BDA6A0C8F2D5BEA4C9@SJ0PR04MB7743.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9pwssmtsDIPVyehl+Y8l8Sl0IqlVuUbyVMUNFI1Rx6CD0e+ZTsuu03xJRW/N1l/kAwlibzrJgwibPrneG1FwmNHr59wHdDyOmNdYHx0dWG0RNg+V7w3XI0mQ5Q6jy8qZZff54jLqGsDTW53TJAiK7GuAtfkQ4bBGYijYskmJSyZ4P0DFMIDuHkPLytz2xxb8GxV21+K6OXpWD9KoD+wVpXETRyCWO9yQowWEYlxTMhyo2wq8k7nVtdlbaeD8z2Kffgi5iDNggAWWEWc80U6IOcyLYgThJDqxzN886WshQdh+NOZUB0N+nX6Kj+KLjWXMw9yRVAAKQs4U8Pt7kczKH1E5jrlni9lkPUgNDQDRB85kc4+OqSo4R0OEeO8WNCLyHbjHneRU07mv8aAiss6vCqmpWHyy9k1FRemgS5cfMy02EY5J5L9T6fs290HekqJpCtP3zvkyCFECJSNCbMuR65BWx6zTdfdNTJwUshOP5bjwcEPXICVDd4Us4fNoYMp+PjK6cs4c9zYDjA21A7SRjjzb3VkSyuKBtyii+AhaZgkdJ24rzzJvnf3cmvtYJdl25F4rGyjmMPYYAXMj3QGZuczHcfP8aENPuNem2AJBNzFNPXcZJ8UHSw5DQVF6fnHU3GGK0v/ugUDzyD9wZAuK172Hnd1zPSAZq4LinrNSXK8lNmT28+Q/xz1QZ2OmGnBhp2fv33opj6phqgpKo1J3JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB5656.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(86362001)(9686003)(7696005)(38070700005)(55016003)(6916009)(71200400001)(8936002)(5660300002)(8676002)(4744005)(2906002)(83380400001)(76116006)(33656002)(186003)(40140700001)(52536014)(38100700002)(6506007)(316002)(64756008)(66946007)(66556008)(66446008)(122000001)(26005)(66476007)(508600001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?svI1Cwqi8I5jITZVmJU5nrHBn7dE3ih0ieah8LPX5R6IzOa1YA5aK8mojH8y?=
 =?us-ascii?Q?cqWOLyPmwkJcYx4G5Zru0CXRTSOz3/5I03JYZbtRmaf+n5wMoYcX9U9cbFsa?=
 =?us-ascii?Q?nb1TTstcFqlwVghJ4jNck8v4tAh52Wyxmb59rCSRDkaCpRfzASpJ9+ZJMjwA?=
 =?us-ascii?Q?6kMs51cZ/jvHL0UoOlPNeaG6HI/zCJKR+zvrvZkDU3BwRjFWD+Z2ZecNpTwW?=
 =?us-ascii?Q?/aXQ8L1++K/WJH0Ye2Ln/w8dxuXOHict/5Pvl3siskGBciD4METoUm/sSL6h?=
 =?us-ascii?Q?H+1bpwHVMToEjWsDm6vpMJKeRXFEW1MFXZq+6OtKi87PYKwiIhLE14iQEW5W?=
 =?us-ascii?Q?IPWbvtOwsgKvROwttJ+PZfMHqAG6dOTwyN0iOaVQ+LWnLDrWn4PgJUscP2ee?=
 =?us-ascii?Q?U/F4Ng/GxqMpP0VzND5kXA56q1WA3eyiUdJ5LaB3OkdFdOZR39/j0yGMF8cn?=
 =?us-ascii?Q?j+svDwBsxxN/MLV3PjRNeCkyvnxJVyhItCoFLmAdm1xYDM5XZhSjMUnPvCFL?=
 =?us-ascii?Q?YwVR7H0a+MDzcHv7zUDpCXL5br3NbnxeG1D9b+6X/DM3KA319Lwqoo4INpFH?=
 =?us-ascii?Q?EESu8Pj07+vnXPiDx/fc+A2kKQ98Pz1xCw3yd7Vmcd2A0XXd2Azv38VNa2cd?=
 =?us-ascii?Q?7rsjK6kLP57Yv6RUckcjoQoR7vy6wkJPI4jtmMc/Q5eIHHLJ22WsbQNelQb5?=
 =?us-ascii?Q?y5g6c5klikKyFMml/ShdY7n209OyE9TL1lnSoqkDioYfrNDr5VyfA+ePF5y0?=
 =?us-ascii?Q?RGIOUYd8IdK8Du0o/b0CXaPEPzXxvzzzod+5fJD8qklAn8tJ8f/YmzuktbIV?=
 =?us-ascii?Q?ZVNEk7exkACc0/kvOnZFe6GntZOmBCm8EyQ/OQKvQSeSNmbEQkKu95k3mufb?=
 =?us-ascii?Q?UBcsULdNBF4bF/Lm0tG9G7zIRnRakwQaqDkv4yfWC4FXexwgnAUl/tprHyc/?=
 =?us-ascii?Q?crcJX+T/pDbSQK72kmI4N9ZhtQO22oaaG2gDZLcKU0GfBf3w+AXj0ffwGcpY?=
 =?us-ascii?Q?LGbEUx6vSCW0mQCIdaOZpzDP6EloFKFBs1ri6QrMHtr61F2s1VIU3Mgo1kyr?=
 =?us-ascii?Q?P73e/5034T35XerRN4OtqYHd/QpzPYN1m+ZVop7pm0v5OpBwN5zVhC1UJWhZ?=
 =?us-ascii?Q?SyvAUlDxN1S1l6cz1KooOJpr7/O69Mpsc60heA4ovtvEdwj2ULvAfC7lwisC?=
 =?us-ascii?Q?MxUSZsKMYMfWmaeT3h1M7MhA/5Mqr8nFMBPkJEutoD02KIHtRqU4P6Nb20ix?=
 =?us-ascii?Q?tvbXnB0xnbsCpveF3wJxehufV+Zjv962G7YHu1amaxPy2sU2oc87T+9i09nw?=
 =?us-ascii?Q?FscfwfavyO1gTeCuTUL8ZUxzTeteJCoLBObAicN/5EuPsFRczDChKA1EVE8X?=
 =?us-ascii?Q?oHXUgRucTNYP7RuWoT0dBKAX0NDlF9H3AZhIAx5Drurl2uJDvmtO0msGe/OO?=
 =?us-ascii?Q?MUjyWIoZWPmCyzqOzrIfNZneD6ob9LnaYQU72m7djpaqCWL84wzZkgCaIWNh?=
 =?us-ascii?Q?/sKe6nsHvPjowX5Ok/yjzruIWbrXFaiV+BzOXED1vn8laXVQlNdSDewdEWth?=
 =?us-ascii?Q?+8e0eDIiLaZPb9UKEdl0sPVB6gvB8PHZarik8Mbos+QXL8hmfQDmH/7M/oOm?=
 =?us-ascii?Q?yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB5656.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7bfd164-4216-43dd-052d-08d9d16c8a81
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 23:30:35.8457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ko4uqXvEEcHpGhZRLX2G2QlSxhsqf4Ea/zYKQZ9CJ4yPlQnn3pDR608VJu4+YdAOgF/9Sv6NLsc3mnODO2uEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7743
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I am trying to determine if FIO in Linux is dependent on the drive lba form=
at (sector size + Protection Information size).  I have not found any refer=
ences to this in the FIO code but not totally sure where to look either.  M=
y thoughts on this is that the device driver for the particular drive (nvme=
 driver in my particular case) or the block layer would handle this and iso=
late FIO from any dependencies but would like to confirm it.  If anyone cou=
ld either confirm this or explain any FIO dependencies, that would be great=
ly appreciated.   Thanks
      =20

Jeff Lien
eSSD Core SW Tools & Drivers

Western Digital
2900 37th St NW
Building 108-1
Rochester, MN 55901
Email:  Jeff.Lien@wdc.com
Office: +1-507-322-2416

