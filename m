Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7575CC433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 08:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhLNIeI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:34:08 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:3968 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhLNIeH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 03:34:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639470847; x=1671006847;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KsKHFOYPd1hmbilliB0RIb7gJok2oHbx0fUtcFmnKiE=;
  b=QzlhjcxjEiKapB6bYrGpM58pkoJxKNx9d8zGjVh4y/W3fhdfpsAe4UX2
   RLxAIAyy63u4CxI1qFoQ7s95S4vniOyOq4CypnsusgNeFfqYrhl9RioEQ
   SXTSHOAFLaiqiykzwD72u+4d5/qK8Kgex71/sYqHebsKEag51FaKo8oOx
   klPxIGJin2tNQQ/wFso4eiUhefpNE26VzGJWeyDzyUpgSZO49yP7qOK3y
   h7ON3w/pnCVeVw+7JBntBiRXGLWuqL3gfI2vHW2bxrPTwhH6T2M9Zgmsy
   SYxFFRtc5lcIeO5OlMzpO5nl/l7tBLjmuOWkgr/NDI/4rMGsieA1kOiAH
   A==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="187177255"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 16:34:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cO5oI9eE9r5aL44XkYXTJx4j1D3Zi/JnZg/RqOqK+vxguTrzumAIE1h3mWb67h1FZ4a1ieKxqlFp+VEb2nzFy4KQ4x5Z6nfRXPluguaOTclDn5LxJW6rUOHkplLYKuQSPwAlteAZPor2EEq6u2REEok59ozNy6NWiIi+sxWNQDPGaV1uz09LFxYeHHNVvYnOdiAS5CKZi1SZiawEdZ5/U++2NiLdvGBWEyEHKmDKahpw97SblI3jfrPgcD57MskioWunx2rdC+bPC1mA/o2ZbckbMG08JMiBnx5BnJn8JriB88r7lCFCuMr31+GySBBc4Tj6mhyoUpVLy1I6pV539w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoZEhq4fuZYqfFpZ0ae/1OZRQU1IoQBVv8DSh5m+peY=;
 b=hqE4QgNcGYq2m2M6P1t3B5eedr5Ey5sWg+WwpK8B1a6e8iI1TKbfPLHx2UnkDevlskygU+y+hDPspxMG5D+W4l/mOdDIi4HQ0unPp4kf+FUphmGX05G6IwtfMYWjzjwQBLLdZLxAMqSfFTC4/y8SA5pqje6sndDrxkHiCrj/DNMQG4HqIHEzqaI+xkbdBlwXRzuwNXHJGfeFf/MO5bKUmMDPszsjRbdxvJvXKncAl5vOa9hiFT3hkvI28Q/dOK7GQlt92XSdXYR1c3QP04zohQcGxg6mkf7otTjpkJm2M6YD8VuMLuoA3VQqrG6T273Dnl9LutD0xB8T96uJ0MSNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FoZEhq4fuZYqfFpZ0ae/1OZRQU1IoQBVv8DSh5m+peY=;
 b=eEbNBCL0ueNlVrxGH52xvpLv5G/kgVxak42lnKLU7LqQaGUd6MV3G0XrVa1YjtcvcvdCsC41teofm3dkUxTWoVkF8KNrGqQHdZVsgKGajFjThObW4+Fqf+FscC9s/DHNYDqZxnX4nQUbwTLZ8X5WIF1roMwGNg1+N9+TRXIOtC8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7527.namprd04.prod.outlook.com (2603:10b6:510:4c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:34:01 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:34:01 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 11/12] zbd: introduce zbd_offset_to_zone() helper
Thread-Topic: [PATCH v2 11/12] zbd: introduce zbd_offset_to_zone() helper
Thread-Index: AQHX8Ild5q36J0mqn0Gi/oFVM9cllqwxqZwA
Date:   Tue, 14 Dec 2021 08:34:01 +0000
Message-ID: <YbhW+OEj44+Wc0vl@x1-carbon>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
 <20211214012413.464798-12-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211214012413.464798-12-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36b4754f-8749-4243-9925-08d9bedc7aed
x-ms-traffictypediagnostic: PH0PR04MB7527:EE_
x-microsoft-antispam-prvs: <PH0PR04MB75274DA9DBA3EE12BAF28EFCF2759@PH0PR04MB7527.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZaDK83inD7uHc6ryTyut4vn6e1+gozUd6PiIdXyFZF63zJ/Z4QjQJOLJFMa7unbqX8DjAnZIkx3201RigUkJF6ANFuWZ3+WngO00s4Kwna3XAvkhYfooBlxFvUYq3fXnYVp5K/h04TSsa604kuRVEe8qRxl9Zk8Hl3SZcMft3sUsGd62GY2VK5d/d43QqB4NhXjjPuKNOp7b8U/11uOVgFMxkjT5CIF+mFp9kHVQIvlRrX70WRvCmcV9wli0bW2Ti6CBDsOQsU/2cbiH9FVfSINxl68ImfZeoCdjpZLfa5XMLBxRXrbLpi+vbe32s8aG33IJ8ucQI3GriEvWZIkHa+Kylr7AOZLU5F4rxGzeqQM7OQ265l4Zxv+3r4OSxMbmPzlOspkj+Ic0c1MLKf379Q8Hn4FJV2OgzNLkafuVuQ+U5NvuoZFaGu1pJpEHoiATiSpxfL9zLbHFJda41s/FV+uVGmbvmaDJz+Hbt2a7XSmqK2alMbWdzRliw1XCtnwA+uJjN1Dy/MBCQE6puvEo017Dhbd66QbTzSNP16r+iz6aJMaCoSLGwE3K27AfgJolJ2FH1LOfB1pTZCoeX+DlYNMdXNovtoEfKcATZ/73dPlFHnFlzBfxfxVza211ZQF2JFPTfUWVa07Gqu1JC3QqZQrY3Y8iabvadvg0ysQK6JBVXeNtWQZAYbUXzRrTGlLuMGLbklNmHn6bw3iR453LGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8936002)(4744005)(2906002)(6486002)(6506007)(122000001)(64756008)(82960400001)(8676002)(38100700002)(66556008)(66446008)(71200400001)(508600001)(9686003)(54906003)(6512007)(76116006)(91956017)(33716001)(26005)(6862004)(66476007)(86362001)(66946007)(38070700005)(186003)(316002)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wjClotLU0RNsseDdQmDs3fUBlfjI30783LeetJvRT67EMWzCE1tnAPbeZSnd?=
 =?us-ascii?Q?xxc9GzDNNPfXhwlQ03+UW3BEKUHt08ck82RdLo5B2zT2yl+Ox8wqzqeVaVGL?=
 =?us-ascii?Q?MkLkorV2M8usPconnPNSlVT+0D+kQJ4WZqcJnZObe/eJoFXKUtiDGumztf76?=
 =?us-ascii?Q?KS4M/tldfFQjs2xfO3joUg3RSJZXwO0xWEfZXvclrhGAMYPR6G32k3rEC2sV?=
 =?us-ascii?Q?PvTLVEJOD8JPCAwzhUyvjhG+Cp4UgNhJqST4sjmosGsCUknNv4ddZUtKn6eQ?=
 =?us-ascii?Q?lhNPlfootjniUkiqxJKfUGQSFNVJzRv4cKRQT7UKwgZ9Ks1S/FEOMQ932dwo?=
 =?us-ascii?Q?W6zmc8Fzix9rXl9A8wg18cTMJmd/OIzBK90TjKCoHmq6J7Nl+xQZxqzypKz/?=
 =?us-ascii?Q?/iPyiQcNVpqPZ2egAPHBYplmqo2p6BI7zg+2Qwy4SpBGmrSBZeMEQKU/OJg6?=
 =?us-ascii?Q?chPNY+hmbTI9WJaiG/Ra5d/q23qg8PJP+NDgpjxP2t+crOyFGCEgADMvxxJt?=
 =?us-ascii?Q?M+1XXV0UeY45YhBc8dsztIpT9PGViD3aaXiBdwYQg1QIdzQExIA+zNTxrLhy?=
 =?us-ascii?Q?xLmIdJIF8aAUv04O3P2J3rMXbB8AtKPMSKdFL5vH1EhlrVyIN+1TKmbr1CGT?=
 =?us-ascii?Q?7J1V4I5oSK77B7LNMZYgAoinUnYLztvLkwVTMZA+Jtk5no/rjRe+eTxHnl8l?=
 =?us-ascii?Q?xQh6n58FDB2SDIzNqal1R/HuI2E1OhE7GLNxJECsf0m6FPeQEhUNj/XY73AZ?=
 =?us-ascii?Q?hLReVcs52HD6P+S4vNDENqIYSSNLDO2Yeze9xbs7xWnA20Mcslxefjd54wvz?=
 =?us-ascii?Q?BP98VyLTS383jaHs04ymNCYJtwVcWpKMbibvY8JM3v+pyKqJTleYuutuylUN?=
 =?us-ascii?Q?F/g6J1CWVB/NAS+WuW/sEAB5SwAiI2//hPjgiqoN3KuiKKkOypmI9UH0rVpv?=
 =?us-ascii?Q?GteSEWESMRV3JlUSXAiHpV6m73JqAEhQ17WeyDXqR2sCKqNkXRtCVaVxAi6c?=
 =?us-ascii?Q?rLNLsQ0h69mWxpjyuc4d5WFss1Dn8b6O41avzT5i3r0ElifiyJI/1PDUW80X?=
 =?us-ascii?Q?80XBwuLtEvcNQaAPo17CrimF/+9JHc6jIiZl4MVHzYrTVg6CfgH3pr6EF+Mf?=
 =?us-ascii?Q?dJrmywEjMDd8GG9nFRCUCxayyo9sb9ES18d4GKW+K99Xf6T6eUwJH2j4Ue5Z?=
 =?us-ascii?Q?3mHSbaK3S0xvvY8Mf9kPZnrvau2/iSZTEoBQRdfyhWqb5/GsdyMMrMIyRBJD?=
 =?us-ascii?Q?Let+ftlc4KkNdIYd5Ii95au++dSViuqBgWOmgJ2LtltabQNlB7+/FR/BRKtY?=
 =?us-ascii?Q?TfRq2QnmHt+UiJGDVG6o1d4LCxkILRCuJaolqMuwOIwdlYUnFJ7Vx+C1qx6H?=
 =?us-ascii?Q?shRczQJstLRFiScHoFxvIooEwKbO84oLRTuzl4n7ui73+fuxxWayTICk8BVh?=
 =?us-ascii?Q?uM9mMWGGg/qu25i19OQCRl7a0sChc6pUH5IUtxopWonIuIShJnPVNtckHrAa?=
 =?us-ascii?Q?uEoo5zo/3h1uusjJZYM5hxcjgBrZUAo9F2S0Iz+TP2KzPfvYykQUruS1iNGG?=
 =?us-ascii?Q?UeIXLhPqD3ad8Qy5srkBThQDczLVHpoJCNugV0sgmp2l6u4NvKKtYcPm4puv?=
 =?us-ascii?Q?yY8okYaY/714IK8EsQOpP/U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <685B57833C64F344B2F001F7635F1F4C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b4754f-8749-4243-9925-08d9bedc7aed
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 08:34:01.2885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LPNndH+vtKI4ITFSRdm9T90UzEGFfzmC0NEqTW8LSyaHcwPgjAudtPf3wcgxXqrn4KwOkxilY07Y/jDNHn2IAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7527
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Dec 14, 2021 at 10:24:12AM +0900, Damien Le Moal wrote:
> Introduce the helper function zbd_offset_to_zone() to get a zone
> structure using a file offset. In many functions, this replaces the
> two line code pattern:
>=20
> 	zone_idx =3D zbd_offset_to_zone_idx(f, offset);
> 	z =3D zbd_get_zone(f, zone_idx);
>=20
> with a single line of code:
>=20
> 	z =3D zbd_offset_to_zone(f, offset);
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
