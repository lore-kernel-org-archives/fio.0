Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD85EB64DA
	for <fio@archiver.kernel.org>; Tue, 18 Jul 2023 15:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbjGRP4D (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbjGRPzx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2023 11:55:53 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2671705
        for <fio@vger.kernel.org>; Tue, 18 Jul 2023 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689695743; x=1721231743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q6uDCqsZvGarMOIl+7lzXvKYd7KygnotB9KNLggEb/I=;
  b=f1e1Z9P2nVl5GK8irSJ2uq/3lulhEKhYiyBMr5wB5dmMcP8sCceLc9QX
   PTUgLMSQBHe7auKevamAXLLlpolMuHMNEUsRgawrt8Bv1nQ6vlPrZ1NXK
   fbBuisN2AND6tYOJ2cPGusiG385W3GsJi0vqq4sjeDcROXTFgWbNizHCU
   rX6mHj17lyez7/2Crd3o9BAAu3LJpVX30+zflP0tsaIqrrHL6eGezZ3dZ
   PZ0NjtfKHhWzTwThD2saIPlHU32RVHyYYE4rIDRKJ4EANfQg4GNqjeTtT
   CV+nkYA0kxXQqabe/xDNvdqHB3xonOL9MC1OkXj/K81HHbIDRweIo6H6e
   g==;
X-IronPort-AV: E=Sophos;i="6.01,214,1684771200"; 
   d="scan'208";a="350392159"
Received: from mail-dm6nam04lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jul 2023 23:55:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdLw6ThpgPoOKPQuu6XxKEjx2W+aZu3+nsTBkOaH7H8lBb6Mi4877/aPcsPTLO2mCEdXx2Ft2sMCU8M88Byd83ROcn54Pk6dG3hHdkCuUSVHSyIW3VuSsvEBsnDsVqQQRq60is5riKWyNjesa/nCC0J/7rlT1eYD8t1jlk7UJpXNv43rb9/Q2mo0UpmyBTz68dmAri0YB5j5/+MPKHpcbg49v6QLPFlifhV06kU6OSq/A5TTLZS640zf5W119uXp4sHf+Ye529/QeGwaTy5pgg2KbjXCNVP6GBujbUBBfY4Y0cayPV9DXZMiFyfcOzX4hwNM9kQP9nHB3hLEC0m6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6uDCqsZvGarMOIl+7lzXvKYd7KygnotB9KNLggEb/I=;
 b=lzCe7KA3UTarHSFwxgK8SrtWttxLD1XbyH7Eb678cTY02UqrVGhjxIlqY0zZyNMDoz3wqh6en25vSCqJzPx+hVaCIolgUQwavqjH2nM5cTG6VWl2YSEU+hQ2BaL7EZvS4mP0sFLIUXDDHb81ISzvEaz1aOzE77p83m90q1yxC8iqoektfxPC0s5lNKbVotjs73dfkvgB3gbQuNA98P0nZHxO0x6r256nG5SAuBQeXL805U+YwF6lfPLDeyGSgLAhNPbnex3EbkgbkxwnVhf/WivsXHUGOB6Wehp+7zoZq8AWZZWtoh3cY1TcPnoACO6YaF1jjuU8DKYMDYMjl8izmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6uDCqsZvGarMOIl+7lzXvKYd7KygnotB9KNLggEb/I=;
 b=A7PrPQODUz++mWQRex1lfLmp+bz4B12VIcvVG0JfAmtOmWLXwitsyNzd6BffTGiPonxNK01q/l9Hd4Ot71MPjZdWhbeVf3zCmZKpEYvEwWw2khgluN2ZggchHU3x1/dIeqECVZ8ar2E0aspI+l6PNhU2M+HGriiYHIP7F99KeLU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB6589.namprd04.prod.outlook.com (2603:10b6:5:1ba::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 15:55:41 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 15:55:41 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] options: add priohint option
Thread-Topic: [PATCH 2/4] options: add priohint option
Thread-Index: AQHZr43llv444ficRk+b8nXd3uA3Ga+/vniAgAADAoA=
Date:   Tue, 18 Jul 2023 15:55:41 +0000
Message-ID: <ZLa1+XDlrwJE2QoT@x1-carbon>
References: <20230705221302.430678-1-dlemoal@kernel.org>
 <20230705221302.430678-3-dlemoal@kernel.org> <ZLazc49iA5LXU3bi@x1-carbon>
In-Reply-To: <ZLazc49iA5LXU3bi@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB6589:EE_
x-ms-office365-filtering-correlation-id: 61070531-7d8e-42cd-2cab-08db87a77012
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zjA8Bjw3pxthLVoCCpS0h8OypCNHlYAiqI3vfWOznZcgFzZrFMCVWFEnPkMm/NpZP39mkWQzQI5wrgQo/9Uqu5QPo/NuGDe9QTCUpunvHYzab2g7eJrTj9Tp3iZOT9wxkYhzG3VQGuEpCctjJEDJZMbBzRx2h9P5rWo8K23shEWk8JygYHzWDwO/2NoS98j8J79d/HR5rXujLg2K7tegLoZJZ1wfeuTffhZv8bKpF6cqceTKlidVVyGYhQLhyR/u/9YU1gzORhCHnlMlzoILzF1dH46K0jmJbbh1CwyV9OrFNK6aFtNPQGZTNYNioCSOvl9Jl9jYPsw5s3mS9aWTR0VM9/cMZOrTX4DYtW+6zg8ktlIuZhUoQXNbLAGydRjBBJ6uI9z2zYYFSLhdE7cyBhF4dVRQVnBEPN5d8kER8bDE/Gyp/7M9pozqIWYK8HdirbzDT9L1GahqeoNhiQQodI2AaRSfw0u+6hVhXLCkPdjjRSl/dcxcmJ6JqcGMOLHkLn2YbXfFCXFukTXfcM9a9AW2p6Ok8+6+rv/PgWhJ3Z9l/3WiAWFnn0Jf9UpnwuLVlMTCBd53LRzju/SIMeMGAcN/oJ0xNBYFMTET/oqmmc4uuhdn2vBjAIcMgskr3f34TTwfGHibTaDQjXH1kzHVzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(86362001)(4744005)(2906002)(33716001)(38070700005)(186003)(6512007)(9686003)(6506007)(26005)(38100700002)(82960400001)(6486002)(122000001)(66446008)(54906003)(71200400001)(64756008)(478600001)(316002)(66556008)(66946007)(66476007)(5660300002)(76116006)(91956017)(4326008)(6916009)(41300700001)(8936002)(8676002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rfj7YlxhPhsN+qt4caBbDTimJvnEseBsdPa0iCAue1ShYUDrYM4c7HUeVaBz?=
 =?us-ascii?Q?D120aiCBUJ92u3KIkUtZeyxtU7VCigprhf2ZjKR11Gft0e39xubI6yGlMK2I?=
 =?us-ascii?Q?DOEE5nSkYIRs/dgCrV76g+YEJC69BDP7Tj3elN1jE7FyvBz65IGtB4uVPogU?=
 =?us-ascii?Q?nxD93seP5Cl5/qLJK+CYbi0DD3/Ld7vOhJeIz2r5qUM0rfOpvsdE7VRQ9zFf?=
 =?us-ascii?Q?v7iIIEj+xsQU4GQ2xiIdBZ4jRou8CzG2ytMZfHw8yUZxSEnwySZVk0jwkAqO?=
 =?us-ascii?Q?OG+kuyPOS9MNdWg7uYz4rUmKvLI0Jw8OVp189CfwGXeryTfO+XSfE72oq1i6?=
 =?us-ascii?Q?CO176PNh91Q8dRwTOPD4uYEWbDw0Cu56p/8E20+pzLhFKW/nguBeNgBZgCCr?=
 =?us-ascii?Q?DRlt5n8CgRbhBHb6bivryOlgSspigKeRITLnRDsNb1/2q+lZAKugwQMY7pkf?=
 =?us-ascii?Q?j8RUe6YQ8mIbM8eD5mODIOtY9w49zwRG8hM6KY7MwV2NWAcLFGX5OSgBt+WD?=
 =?us-ascii?Q?fP0i1b0iV2urn0SvVNDLByzu0sTF+U4wDIQRjVWnYW8jQadQbrlrMocd1mRB?=
 =?us-ascii?Q?NfG8UxrGUAV6zwIJo1bBueuR+9eM2cu5IRxbM8KBsZy/jTjNVVYj6AHzu+VT?=
 =?us-ascii?Q?ZoJrECxe4KKaDqUPj8R8E7CkO4t7Aq/dnH88VdLT27RF5Wv898eZBC8myOde?=
 =?us-ascii?Q?lU6673XE+pC8+pC5aa0CEvHOu7hf8y/5JF7j5YQyWpKOQkoz/s9ilRORenE/?=
 =?us-ascii?Q?ZoxdyqilFZEbMh9k/gmA18UwrsGK/Efczgcqi7NJPh3MTbqck0B6acaio3DR?=
 =?us-ascii?Q?Flk0AIoAAaZaMYNQoJWfpvc2qGsbKfRyQ0ygeMtJCIG0phCN8fm5qE17W1/R?=
 =?us-ascii?Q?Mr3rAfyKu1RVjcvhlDoti8A92MO1al2mb0kU1kvrG2RLL20H/H0KA63R4uXL?=
 =?us-ascii?Q?wbj8BIiVN0j3itKqBveqhn/8E9u2mL/XEYga76AmE+O83Zm4tPJMEsCEqjHe?=
 =?us-ascii?Q?HWhxSzI1L+4Ja7Rg2ZKTUCm8QAycG1+SR4xu0nHGz6TLn+WfBKhaghEJrFNa?=
 =?us-ascii?Q?zZtlHZI9Mzo37sNbMhBWxD/lOxIZoeS9H8I+ZJ5TR3G7XZTK1ZNU9QRysknB?=
 =?us-ascii?Q?47qfkbvaSunVsCYK4+maFgLwVkMLUZu+0oQvl0hVP7MQgnMxyCjn2+KUJ5Yb?=
 =?us-ascii?Q?6XKDhpdD0fTqlKNYnBeMg6Rix3tI5pmo3VnW08aM2Z+eqA5ts8juETWk+zKz?=
 =?us-ascii?Q?zBvB6Ytj2r3rVHY39FbzIMf5yCBi3ZoA0ZSSw3MAo38+IBgW+yT3uQUrlJRS?=
 =?us-ascii?Q?biOAMH+EJYCvEliETrvbZaoEoyUwv+ZY4zDE9rkmlF3IzfgtXzF7qDTSbOmT?=
 =?us-ascii?Q?facHfDSmQ2o2m5Vno1WRQQF7kNx2r5n3Okl2q0sG/9Bs9iMZJ7jdXiEMYkOQ?=
 =?us-ascii?Q?R1a+/r8SBd4CCAFmkD7VRp0uryat/ibqsk5cN9jE2ipA4lo+s+/yEaa5u456?=
 =?us-ascii?Q?k4QNVYEYeA6bG9nnc4hXMU00fiS3aZ3XrEHzBSYXRTdhR1P2PIgnHNp2zECh?=
 =?us-ascii?Q?wk/SIHrYRExmRolBA3lpCHkydlCwdabGJjtWfqDRFXmEyMJqYwjnhsPijYkh?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08DDAA766F81BB4B890034A58966706B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nogYqXN5/HIzQfDaQu2eXy1aleURXjDKj8Twglf7wdCqITG5Q9SLXhpL97SqP3jnSZM3sIXY9UpEvWBTXWQcAbysE0ISkUQs23y/47u3OfZT4OLsR2u8qcrrVQSDgrmV87bl8zwoojkxwbmUhpoUlMMYdiiowiE0ohbtn4H0/gUit6/YQBTYTtXsJgzo7ScXrMrc57ppjBRT9b8aF+DUwIFSqgRoHFcLjvuQF/gKrdxVtYV8KRbSW7aJcjFG0hVe40+xdr4BQ36i9ikw6vy+I52z2e84k6UlgDzosTN7rEK99+RHC/78Jd4RIh+XmvJRdc17HVGhXHufHEqRkMqtVA2yCpZa5MifeRV8P/3flP1RFl75o0na2JQY8aQLsewDk+0J3XegixD9bNNX7z8ecen9rLOAjDvGOXbjgM+E/XAAVFv+itb/khanosxzzuBXJYrpIKIW2eUUuqVmXx2ODgvhg+YA95HEUFkt2kOMnc+1IOdvv/zizHQqgSyfv5EEeI/Uu4dU0s0nL392LqNnDKmYRcRWSufbjq5eD9eKZ+5vOixlHY06CfVGJuRZtOjvr7nY0Azcvgr47VrQb4v5eV0b/fgvL5Y/n3oMhGeIGGdE2bHHcor+0YqahZCmAhYcrrsGjKvkQZs0zgsBwwhUWQHBz5yn/NlnGUikGgRW612OmiULNZLfVVriq1pXEmtsYFiNLIohHwoIhU9bipdnY6PApocxYwYBTq7TpYcOPSIAY2DKyE2oXDs8UGx92L05ffhOCv1mPjOjkutEKX+fssu30ztaUWpV2QD3Og/RDANEmhAWrQAh0x+8lmZHftDSh7lMZqK8NOUQ3ZhSUaf5AY3+fBLaZorqX29tAy4v1yA=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61070531-7d8e-42cd-2cab-08db87a77012
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 15:55:41.2536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Of9FrhZeYRMdhyn0EN5vhtd0CuwNzm33Wq1T5Js7wZhFZb7NyEzt+q3eueIbwkSSpS3stPisYXSSwO4KvP9kVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Jul 18, 2023 at 05:44:51PM +0200, Niklas Cassel wrote:
> 2)
> Nit: 'cmdprio_hint' is introduced in a later patch series, so it feels
> a bit premature to mention it in this patch series.

oops... I meant:

".. is introduced in a later patch in the series, so it feels a bit
premature to mention it in this patch."


Kind regards,
Niklas=
