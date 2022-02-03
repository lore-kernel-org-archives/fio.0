Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5C9C433FE
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353763AbiBCT2h (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:28:37 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18768 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353756AbiBCT2g (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916516; x=1675452516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vmd/0P16DTHSiYXJaNxo/k3eD3xRRAdTRsB7JTM0KXQ=;
  b=BOjU+Y0PgCqbNgfVQVMTKNYMyWSgAqFkMKibLihqO1vZhtWtzLgUdEV5
   y40ZjN0X/eDilw2qaxqLeADhO1y8HhX+nQKeWxwHlXqce2TER4Hbi+8ZM
   MlPh6Q4YF+WaQ33zs3gFNwy5DoSOJwgdykMDDRI4oAXZqxSAGc9zcjd6s
   ZU4aT1amrrCo9FVftXSVBwuMRE7vx08j80bPhg7SFtqi9Z2EogmaMrna3
   4lEUqrQir9uSs3fsys6deyHlnoErtaRLXoEKImDD8q7mbWVhNw4pjd6z1
   AMLdqON6BRfAGYbZpfG07IWdN220OqC3Xw0i7NvAZ/SJpleUPotRqPjnA
   A==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="196918787"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbljXJkuSYeAqoSwJk1Dk2jBLxo+4nNNd70daS1fnPEDMI8Wrxgnuk1Bk2QiWlVzOddYI1UMGa3wm1Tt2Ul9bf9Nyg+iJ01mEU5PVjpNDrWaPaQvWCAC8LOmNaHcxuCtwxHOqX8Q8JqsxwtSx58w2NdZS+6ijpFA621Erdg2Bo5MPwuLFiZl36M1BpKHF0yzUyjdZRfKQ/9zidBdjQepE4E/uI6P0y//oP6k4hNNSK2QYGDxcbonJtRxa6wymOiwZn55oMWpQu7HFPtZ/xtQKY/M+yX/YkKeP7hgpGLSsUhrTqn+EdUITqY+cSc/uDK4k6Kk/7oMR+wsij6dkQkq6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBPg2r5nH+TJ3Fsty0/UwExzoLWbfqPsPafcgi8bO3g=;
 b=jRaXzacwuyoMjSxIhogj+60LuRywldDQSELV8AOp+tsYjdwGA9uh2PVfwrxTcaMoy9jMScx9/8BWVU27dKBIeki3XiIfw5tjJas0JLLDdgaaZwidib4yvcEoETDUasAqGDAxviyv+7XaryH4LtOsh+rrcj9RIBX2LKfNNsUV+RtI9gBYALSWo3Hxwm75TDRPGijm4vHBCbw6+wenIU0r6ybuPp4BOj8EbIOz0fuWqSbCIXW67ES1lL/txbEZ6JS6nx+/CKP7Cd4YbFIu+Qg7GE9lo4f2KuHM5lIOlRkogbHuY0pu9BdxbYMJYOebRQUfrzY+cNS8uqrmBAvvTqlNkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBPg2r5nH+TJ3Fsty0/UwExzoLWbfqPsPafcgi8bO3g=;
 b=FOt3AMJLO2Hg/Q8ulA84knYzKDUTRrog3Ka03f0DuCsPTOKE3APzGTpqn/C43poigGQuBzawWo3QkBpnVG64+SlniH+gNIQecMMCN2XO6+shrkWeWFg2Y4oQjQjZMxSK/tKbWgzcwdp4TWHsLiQQjHLhfivRg+i9X7bzykigMIs=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:28 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 06/18] os: define min/max prio class and level for systems
 without ioprio
Thread-Topic: [PATCH v2 06/18] os: define min/max prio class and level for
 systems without ioprio
Thread-Index: AQHYGTQ3Y/uGgQrVEkynJB7v6TQg6g==
Date:   Thu, 3 Feb 2022 19:28:26 +0000
Message-ID: <20220203192814.18552-7-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fcb12d0-d7ee-4abc-7268-08d9e74b5ad7
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB46329C1E769C73ADC7CCF7B3F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eI7JLoL2naQM2dHLOiCkaG/qQDljFYzl80JB+4CpMXO350UdoONWzctzwscTh0Ns3ZO7zxSrp95ayEF/aDGqTJG3KNho52w3PH+RsQfsKHyQuLk1J3nGY8pe0NEf9KSRXiKKpNEonUtezzokCxz/AX3W2GnXzZS+AOxYMKhjYLibnBGhykHUg63r3hIC3JQYe+PvhrTpDycrOZX4S4IWnIFmU8hax4ulfHj7NMTiYzWmvD9mz5xo6xatsQUa42mNAJcQ7/dTZWWHMZMxbXAVwOt4Jnmci1ZQ0UUSwbfbmwEdOFm7DlUTec0DywIGUHBcS8n6KHT9P5kvkG3EvmTvWSd/pmnamkyv8BV1wLE9NOftDJ3atwW6jTth3pH3cbTr+Ew7FU9+4uXtNkQN5oHBE302kumRHmDaq5kbzwgNBRPvlSeayyED7KVVbqJTb+dDHwwVzcRNTvvI0wVgqjacVNHJajvDUGmyd63l93KV/ZTRQceQYJaZF902ooNOUDGvGBpsAD7K2BTLD9wTPOdIM8O5wuOCIsoro2fb1/tLRXBhT2OJLWy1klEWCy4d2KYqN5y/+1gNHLLziwJHpCo4yehQZhNhvK1WxejA+qFiQtgHOeztRs93v2yqranM+lY3hY38avPQkBNTq9+svCxzX7vDU51l30osg5qyNVB5yMG/llw8T5u7iZeCdQS50/QhXPH5U9U11ReZ6dzogNEB3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(4744005)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?8p4NeJpal8LbK1PCiCXpUnumLafay/DgxhOHlmSqX2LV8mnhRS2rJO8CqE?=
 =?iso-8859-1?Q?Y4P6viKWfUtZzm7Rl59UsU2bmT+ORy8zxk02BqKnfAXXu/ov0t4pu8nYXe?=
 =?iso-8859-1?Q?8CMfvy0NazV2utRwsdNLQrHpIYvqAHRq0NLKf7IjHmElG1BhquR6CjBvs6?=
 =?iso-8859-1?Q?Jzh2XIFw98+SUNg6ZBk6zH+Iomq8nffADeDlRhHfV8ciiMKwSxKElw7yn7?=
 =?iso-8859-1?Q?Fpcvtgskj5wDoRB7Ts3rFisT99eX2q0/rYZmDPKpG/uatdfbzX3c5z1Y+7?=
 =?iso-8859-1?Q?oYeEwmg6PmCoXviDFnE/PXtT4I57dfyN/3fktbUMyDJNP2ccaJAE2b8991?=
 =?iso-8859-1?Q?/20jROy7gIxUQBSP0tRBHHF7DHITCtxCn91Zb9vHggoQ/0xaa5e34zh0Ad?=
 =?iso-8859-1?Q?RMzixtwaMsYO2rOGG4gdYsvdBI/Cl7UjoWGpDjYbNJZSnv9uZiY8LYk/vh?=
 =?iso-8859-1?Q?Nq6K7JpsxsxDUbDT8MQnxQEpP28YUP/w23TbBMI+zTqOU38a9FVYPDoSL7?=
 =?iso-8859-1?Q?tv2vYJKwWT/YuUS34URrtb3z/RM3JahFp8AwR4ugvlBJvq0rrOQ6o0UdWe?=
 =?iso-8859-1?Q?4j80XaNt7ZDbqencTd3ZLcruvQgQ97b5dQB0o/ridJdxYHGjNG7KP9q8AX?=
 =?iso-8859-1?Q?9CT6VNbmxzz50V39uo7zxQnY/i3H/KQcluizMRhOp4dTN4aE/khNVcJjga?=
 =?iso-8859-1?Q?vtmvkYlJTLs1tn46lhICLeAgv2FbnOEJMwsUX7OcicUmZxbzwg9WrVZFa/?=
 =?iso-8859-1?Q?ylSY0vwMUIBysz6MFdQCDZ73oKlDvE/bs7VqmDVShjKkdVXrtbOu1A2V/z?=
 =?iso-8859-1?Q?8FzPx1c44gSSDyTGCxqtMjBioRRcEoLcVF0MW3RHgMC7FyYF9f/invZoVU?=
 =?iso-8859-1?Q?e1h7clvsLCeM/oiWcY8GJTyqp0wYOYKX3JttEN6J/BhMvf/FJKn/gakGEF?=
 =?iso-8859-1?Q?rec4JkbZ3MRllhafvYYbagRNKQqo+icLoWwsr87Vp02nB1pXvj+D/XT7zt?=
 =?iso-8859-1?Q?vWrx1WRIJuwtdtc18jpH5MHkUWWZo3TVH6mo7yfPNWWqcGKyx4N0ivPn1p?=
 =?iso-8859-1?Q?npfZBVxJVC/3JTEIxt+5irtN8iS3mgh6VM4FZ4ieWMCkSjHizEOP4IdzfB?=
 =?iso-8859-1?Q?maMfdwdGGrdUYJLRow8U9/CFGg0Miu2objuZ0tClJxPDJOmKZ7sD00mHBF?=
 =?iso-8859-1?Q?S8RWc05BLo/OuzB20lPZQwA8HvyLNCwwszVfjZeAB2GLYJ7UHNNam87Uld?=
 =?iso-8859-1?Q?nXVO/IYtzH8zc9SQVPINDLB2Cu9gmJtxgTaaladKldZC6rdK1vVCTAAnR/?=
 =?iso-8859-1?Q?SJmVWC2b3edcl0hRKRDyAKaK8WpTQNigi5LzjcaH/r1O5NjVrtv+g9D5Rx?=
 =?iso-8859-1?Q?A1C2QR5FoLANSJXB8OjfN12xDcpb4Mts1GMtDSBNiybViHh9S3NRnPrKvM?=
 =?iso-8859-1?Q?dFcH4pf9zf5G67ARHyMkRHxJOsmm70vSH+H7/BPHfIzw8pmKFZRv1udkYb?=
 =?iso-8859-1?Q?uo8wbOOjOs8UERouDvsUSNpP0lnh3KGym8io5D44KmGQ5kRD3IeHsft2q9?=
 =?iso-8859-1?Q?dvyq+Mb+DP+dzrBC2QAfG53Xzs9G38IcWBpdwmV480U/g+CzlDiLdMkM+n?=
 =?iso-8859-1?Q?xVqXWiXJ4Gil44qBn/67P4m6N7aqE8FWgUKC23QpSh7blNxiTpy+YT5L0F?=
 =?iso-8859-1?Q?VSMnC0pcOU9FBg9ZlMQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fcb12d0-d7ee-4abc-7268-08d9e74b5ad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:26.9132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9cFXQe+2Kt0BraIY916I46tmws9Ie/77P4ZrAzcrOozEsmzQGI4HPjuOH6w2/liESCJ7vYzeJgkCzbM8XdcHqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

In order to avoid additional ifdef FIO_HAVE_IOPRIO_CLASS/FIO_HAVE_IOPRIO
from being added to the code, define IOPRIO_{MIN,MAX}_PRIO_CLASS and
IOPRIO_{MIN,MAX}_PRIO_CLASS as zero for systems without support for ioprio.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 os/os.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/os/os.h b/os/os.h
index 5965d7b8..810e6166 100644
--- a/os/os.h
+++ b/os/os.h
@@ -119,10 +119,14 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsign=
ed int cpu);
=20
 #ifndef FIO_HAVE_IOPRIO_CLASS
 #define ioprio_value_is_class_rt(prio)	(false)
+#define IOPRIO_MIN_PRIO_CLASS		0
+#define IOPRIO_MAX_PRIO_CLASS		0
 #endif
 #ifndef FIO_HAVE_IOPRIO
 #define ioprio_value(prioclass, prio)	(0)
 #define ioprio_set(which, who, prioclass, prio)	(0)
+#define IOPRIO_MIN_PRIO			0
+#define IOPRIO_MAX_PRIO			0
 #endif
=20
 #ifndef FIO_HAVE_ODIRECT
--=20
2.34.1
