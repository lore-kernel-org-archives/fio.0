Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8DCC433EF
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 00:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiFBAz3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 20:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiFBAz1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 20:55:27 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E130922C466
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 17:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654131324; x=1685667324;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w3UbYburI9aFLPQK6Jqjc2EiLKLd8pi7J58XnDDeSvk=;
  b=bKKlAgm2wBUXIUEi/QIUwDo5yP5Wjc7te9igx8vfQd8Wtz+t+zj3bwPS
   dkXtZYmRAuW187YmrF+VpYG9kAhbljbFSd6VW7tXejCgP7jb989h631D8
   hop/p16uLp5k9ITCxypILepJvjNNpjNm/PXth0ghS1bCt8qTlXNCekBVE
   XUCCs4Qbd/1xWBDUrbcSKztxLbxdnO2rr1NM0WxsjsGFaqgYv9mgvUYgA
   62LdjHdTiJoSXzu40JEjBn2DtA/7d1oBjHduGz/t2mfhdUhGkLlaWsuvQ
   cl8oFveYuBf3mjCdxpPSTF55n8uPAopVAgHWl0OM/Y8GztqOlFijmdpfg
   w==;
X-IronPort-AV: E=Sophos;i="5.91,270,1647273600"; 
   d="scan'208";a="202048105"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jun 2022 08:55:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdxKKqzo9uHTadlTb+vwAhxGGBYsAmGqXY/SkS17E1ch1EX7Y4hYkG3+DMgD+EjYn/AbsJAGlHrSsBH1pgL7UfSecJ69jVT0t2OJpT4Nd/6yz/w671/QQA/14iisnV2tpxgSWF7qXoBCm4WTH6dWH2s9EDzmc64eCNdDnzjGzC8Zpq32/47fsZJ3EF7bNxkSjdCzmMUgFNFVqqMz5dVZMdURxJ+Tpsd5Cf2PtlPvIHeKcZ1XxSBDR72WLM+T5WOX0N/6Z/xN6PpOIKNqtL7rg1pmLz0U0AiCoMRJVUoOjfqKaU0mDACgxC72u/OOl37+MteQjjefdMNO4hg0MkZm9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3UbYburI9aFLPQK6Jqjc2EiLKLd8pi7J58XnDDeSvk=;
 b=jRexLKwugkLopRWeDB6MQwx8DnlY+600ab5UNgyIoAzNQ9ZD404+j1yFs6Vsp7Ez43LZaPB1KBl0zcO7+HSlFQqFWYfXNTh9fqFoBTpOoToWPq0PDxRI8twWbxoYMz4S+BGpnB642PPTyWIBVHjqMDWMDQTpsQEHvKRhZ20G81FT9yeHnQGs7dILXBboHO/GXbuuOw+ZRT85S582HgtlV9PngiFEMXBqWoDt2sgQ7KGskbdp4UI+4pyNpWvKGIpZs33jEA9LX3wtomSoSQYmLjYQuJsuZTe2ATz2mydjgQXRPPRhHaWTvWtuN6Jr3prcsiNxsOk87NLWYk70qeagew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3UbYburI9aFLPQK6Jqjc2EiLKLd8pi7J58XnDDeSvk=;
 b=S7dQVngDi9UfQ+nmHSQGIMMsreWc7Am22v9npPIQojIfDbgUvXFu5SUuiTQVF6zATihIwROZ1KT9wX7KTbZ2Bh+wP4UQl+lxGyEMsf+LwlRGywMq4AM1tE5A5TqFVF14KZM45Ya2UVvVbEfOfirkZ7BnxJL+LFeM8BxLR8yiJOU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM5PR0401MB3669.namprd04.prod.outlook.com (2603:10b6:4:79::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Thu, 2 Jun 2022 00:55:22 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 00:55:22 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "krish.reddy@samsung.com" <krish.reddy@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>
Subject: Re: [PATCH v3 7/9] zbd: Check for direct flag only if its block
 device
Thread-Topic: [PATCH v3 7/9] zbd: Check for direct flag only if its block
 device
Thread-Index: AQHYdZu1+yDl6fdLbEqY06BAXhRfF607S6eA
Date:   Thu, 2 Jun 2022 00:55:22 +0000
Message-ID: <20220602005521.p4q3x34ba7dekrfl@shindev>
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
 <CGME20220531133748epcas5p1e2d8f913398d3ea8c165e1044e6914d8@epcas5p1.samsung.com>
 <20220531133155.17493-8-ankit.kumar@samsung.com>
In-Reply-To: <20220531133155.17493-8-ankit.kumar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 874e8ece-b314-4151-2421-08da44329283
x-ms-traffictypediagnostic: DM5PR0401MB3669:EE_
x-microsoft-antispam-prvs: <DM5PR0401MB36694D62996E8C3D219A5CE9EDDE9@DM5PR0401MB3669.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W6JsW1SD2lMeHxM8or2LwXkhLSDdQYaK6T364O3OGuiMhP8b8B7joMtZJp4yHlHxl2OPelPXO3A19CEYQNYejExLQzE4Rnty6Uo/Ke1ZWqIFxju4n23F9oK/Sjl5omCWgDh2Tbpauqhup1k1h135JjUetmbQS/LFqFNmEuK849cNQdCa/2FG27Hpkh/pQJA43yIXi+/qkqIRrQrZVxQXUJvDbK9IqkFYo6a6zfcU+T5LTub45cZDpkLZAa+FaIVXB7ANYghb6YhHjMxexMb3EZ/Yl4LPVn7sgkNY/dlqX3Ky+9ArgohugugxHN088nxfgoV62XaXlS81OUtqN6msWLp5/iC4FXd1692ak1dUu/bBPNUqmz/XUUNwZNAnUC3VNenUr0ZT/7wt1JI9XB27rUagJ6HfWqgo4NmcMawh1iDBvIe8SmI83wAP7hWD5fiu/185SgDmfaN/C6S2SRpePyuUiPD422wZ4rNIK1gaP/GSg5n0MF20/7t0KKYvmzaRUbeb609fQLCVgTFHuBzKbm4odB2LBD5yPEMeG7fxbrdh1RrhvRsg9D8G1AzLC38wHTW+RK87SXw5FlSxTDRK2yz8mRmZb/Ku9Ch284pnZ6HfHHgs4d5NwX4T09j4yyzg0MQzDw5DhruGorzgtuyOu9lJ7lrltc5egwBkdKFOMyYcCM8Uy502b3p/dc/t40usrBsToCLF8h3Cx+23QoPNtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(76116006)(44832011)(4744005)(66446008)(66556008)(8936002)(91956017)(33716001)(66946007)(8676002)(66476007)(64756008)(316002)(4326008)(9686003)(6512007)(54906003)(6506007)(6916009)(71200400001)(6486002)(2906002)(508600001)(26005)(38100700002)(122000001)(82960400001)(5660300002)(38070700005)(83380400001)(186003)(1076003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bGZSJ7szrTMEdBzqfbyPERV0qSAHYsw4aMaISUyttOdDdv63IdQ8Am/NpZvy?=
 =?us-ascii?Q?HIBnU6XFCSqfL448CQj2Kiat4dbm5Ta7ilUElluxCSeN4PgKy5cFN0e1+pcK?=
 =?us-ascii?Q?XUbghpPiwWj0bnX4S9SXzwtIh9qMGDQOv2M4f9Hnnryky0p7exaQnPevd24t?=
 =?us-ascii?Q?I6n41tBe7A3kCFdsZ/HwAwwD9btsQOh6Sl3jjkW7pRXyUsz+OTfZ8zjkla+o?=
 =?us-ascii?Q?kgwp+QPBHi0Q2AHThMooFsrDmNjmvvnef0ati1aZi4qXbo6E7+9Lmp5jy2WG?=
 =?us-ascii?Q?R8R6aD3dRG5LOpOKAArEz3+CJp1VrHOoaD6ZjvZwWeEwj6JDRq4YXKhcyQvQ?=
 =?us-ascii?Q?Tyz09af2ufsZYPUPjxq6cnn2NskRFcLy4ls8N4qGkVWTu4S7/h7HhapHP1WO?=
 =?us-ascii?Q?WbScJwunO1KlwWUPpwfBTWKugHiMzv/+bBo0UzLZJscZpW5RfhhLpWgdPsL7?=
 =?us-ascii?Q?uo5oC/BLAJ8PlAbREh7d2xiF51fAGIR2d1jP9x1myitPCBXXPCWwcwqfgSgE?=
 =?us-ascii?Q?K8g0RO391ceyc1/cpRxS4m67R/5zW2uRxDs+fRAI30vmIWui2W06Z3mN7Nfm?=
 =?us-ascii?Q?o31k7Y6TQ9rrR6EB6xXbHNuted5xKcV1QhiRzh+4CLjIY86ErUMFZCn30E/K?=
 =?us-ascii?Q?srjZ7AxgUaKDghDSbGJ/blIEhdy+5sMI0nC9pVgiT1iVGuA7RReMl867dVGr?=
 =?us-ascii?Q?blJCeanhBEt1A6UjSrXWcJkimNgnsAXFpBL5syGoTM/ub9bdrxxpBZ3bg7Fc?=
 =?us-ascii?Q?X/uGgFVoHHL8e8WNfaKkpKrpZ+h7HwcZjndrl6GIstv+L+6/VI4rbH9QPY88?=
 =?us-ascii?Q?A7UAAlgx7U0ftB5DrK8qHhyENrTrCuCHGRowc8SlL5fCpQDiXtnoBBj0EjAG?=
 =?us-ascii?Q?AqQc/DBCEPul6TTHtHLi//k6t2e5U/AFS4qjjwLMGPeaQJxxy5+g8WuuqcxI?=
 =?us-ascii?Q?ZRBm8Pu8gXl6ho4AM+GWa4bnG5jGGmw5p8FgRMUGpefC9kW2hogvNS4wFQj5?=
 =?us-ascii?Q?/EV0vmNd+C71kw4nQVto6NbNk7Uvse1AWZ4BkTsIlt6LBuA9VfKyjSQZI+1s?=
 =?us-ascii?Q?lBj1S4ClbR+d6zpSzM8RZZV6uTxXZwEhsNimcCtWIfSJI8sxi0t/SuiIHIWG?=
 =?us-ascii?Q?0fGZAMv7FP/Bt7sbGnJvKmyqp23weOC0i5MpPSMCGdr//FTdZb61XUAHs+mh?=
 =?us-ascii?Q?ymXhWJkdVKtwpeGCJIr9xeWtqRxhhBSoK3UuToj8f9msbhyvLnXcpCrYW9BU?=
 =?us-ascii?Q?Y93F1BjBpG+YIc+G+kspGoQPVzvZpDsNjxs9xhzLOkpKg6hMIzMqsrVUmF+0?=
 =?us-ascii?Q?J3qMlr0KXyu/Up3AU/q4484KrY21K1dcRXB/DzNlyIKTKzr+QcVS2LBr+3DX?=
 =?us-ascii?Q?zfTopzv4X252R2wZNJKCyHJZsa0V55+iLtkub3fyuvQVzAdI+PBVqrGL4422?=
 =?us-ascii?Q?uoJfq/PadXcAYXKqPb4aiEjgjzoDZSVKhKeOFXYrQo1mXcOllwa5IBxZexlK?=
 =?us-ascii?Q?6UjzYd5SuqX/KkyAkZ4yuL55myN1bGPHSZ/+uKDBhYNi0cW2ks0BSwgqMyB3?=
 =?us-ascii?Q?L1QhM6VzyLPSpCJ2oJpmPYYbC0u/y6L+cUZ1E2AEZHQDGn5zeq6TBnSjnmDG?=
 =?us-ascii?Q?YUNE4SGB0wBc0qvuJCnIRLUASSfyRAOAS2V6JB2RoCbXGDcCUsVnevBvokyo?=
 =?us-ascii?Q?vhdsi6CEjWb/Z7SSekfV6eG5n6A4/d48lZb0EchhZ+9bX/e1jT4xImJt2bmf?=
 =?us-ascii?Q?0QGcIwgeXdrCHtBBdW2bSRvbeYU23ezhkvJwmMPxfrWR8d0HVASD?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4373763A1E53E4BB1AB2CE508A9B533@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874e8ece-b314-4151-2421-08da44329283
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 00:55:22.3155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VKrZ5PU8GKfg3aoNTiQugL3m8Ck3Jg5Xl30c4/Agd6h6DmUfqG0z/tt4qoj27hSGcAfGYANtw4NudwxZdDXOhUhbwV85ADWNGsW7+aMYoOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3669
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On May 31, 2022 / 19:01, Ankit Kumar wrote:
> nvme-ns generic character devices currently do not support O_DIRECT flag.
> Check for fio option for direct flag only if filetype is a block device.
>=20
> t/zbd skip test case #1 for character devices as they don't require
> direct I/O.
>=20
> Tested-by: Vincent Fu <vincent.fu@samsung.com>
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>

Thank you for fixing up. Looks good to me.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Shin'ichiro Kawasaki=
