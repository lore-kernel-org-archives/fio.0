Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5067C4332F
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 22:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387157AbiBHWZA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386349AbiBHUN7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Feb 2022 15:13:59 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 12:13:58 PST
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADE7C0613CB
        for <fio@vger.kernel.org>; Tue,  8 Feb 2022 12:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644351236; x=1675887236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ep+OXAr0inNroEC2UKzSkLG4Xkb6BagCYoRc8hPuBck=;
  b=LE3Vawt5Pvs0Uy6S0l8YA8tO/ncxrMQX7g20JR3j6YB2fzGaBKofbrWT
   npyKeK1JbrM3bdUEsfyiSIPOH5IqW/I+VK5hbJylXhBmFs0WVioAWaCUg
   NMC/GRjTlduTw3XNOfS/h9vROWwiuiH3jMeRj2eWlL5yP85tr4ck23a6O
   +4cb2PERVLB954qeLH8fc6kKMQi8XG+IBjjm07wiB1jpOAI4pjM5SDc/R
   zUz/+kxG7gR7Z4rYDl3cKD/pSFml19zTJqvAmjmTgdRm8514dewZLohFy
   U5bMIRqzHbSE1NIwgCetHWKXxXz7KQ0WJ1uIpZN/03rck+zxnrEtMVrW+
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,353,1635177600"; 
   d="scan'208";a="192444063"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 04:12:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHP92JaHe8HFzAnJrmvFcmnJsu5YGpFHGa5GH1vkOOvwoZqzZ4W7gCJQElqYQuAl68//cLrAm3JP/ujaMqZjg9nqxHc0JOKjsP+EUT6P1qyoF4/VIPbNfh1wHgefNqkCBtm3g6s6c1Jvl2bx7SG4RwpwNkWf3pGw26xdnOTaQTyunp4kf+WtzfFipWV9ZhsJmOGF9bTtsb2KBHbRLL201+QKC/J4aLQIZr8ZzSyyax8pkyCcFT1AlegWG3eyhXX4ATzKnR82kXF28YEUt8g9VLG0LHAumzZ3lFPn9qMDyy3OWeKn7CooDxlvsk2IggTs6Q1en8t6ErXbUfDBfgkikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep+OXAr0inNroEC2UKzSkLG4Xkb6BagCYoRc8hPuBck=;
 b=Lcz7FTF0VYAwbuz9GCStDRL4P/Def9QYX4uiAx4YKh01b+P4umOoqNgJdEIprc94s9S+fvzXd267+232VVypmXSb2JMCX/Zo6vJRbiI6DpD2+FpLcg8sK3jVBTu9agnx7Ic51jInmnMPFyJ129RuGeLQwDlJd9cM/ANo23mMEISgG9Ze+qZgxyQA8ScW/PyhZEXNeHHO7VmS3RkT0s+aNKpADavS1c1DpcHl6YITrOkHtGuPQ4FtlZwjzr8nkRcp8AdGjFRAmuQj4DpUN4RmM/KnkeWKmr38nL1cKH+3Uj4NC5j/+BHJHxuwT1A/ED1FdbnncHHLvV8Ckh+T/fe0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep+OXAr0inNroEC2UKzSkLG4Xkb6BagCYoRc8hPuBck=;
 b=ffgWOpZJzKBnD+BZifEQecbh5VPJAtOBelrO9BtVSKJ+g+w+qXDQTO5SIDNX/XNQEna/ECCKapW8BkptGVv+BG3JkE1l+T2yfMpixPMnGwEfDkW3aozVg/cMEQ+9tYN+x9+eXJWIkbF2zHafgpgoh/WBnj2HQ2RJPsID7tNZZ48=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB4929.namprd04.prod.outlook.com (2603:10b6:208:5f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 20:12:54 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 20:12:53 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Nick Neumann <nick@pcpartpicker.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: Fio docs say io_submit_mode=offload with async IO is not
 reliable?
Thread-Topic: Fio docs say io_submit_mode=offload with async IO is not
 reliable?
Thread-Index: AQHYHR+XxBFSiijnSkauYx9JzKG7OayKFkEA
Date:   Tue, 8 Feb 2022 20:12:53 +0000
Message-ID: <YgLOxOwzMOUfmKkF@x1-carbon>
References: <CADqNVToxJ4e5ad+YESuhD5SMy9js4cwMd8=7xcXFf7rW8a3+ng@mail.gmail.com>
In-Reply-To: <CADqNVToxJ4e5ad+YESuhD5SMy9js4cwMd8=7xcXFf7rW8a3+ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13428f04-7055-426c-34fd-08d9eb3f63b1
x-ms-traffictypediagnostic: BL0PR04MB4929:EE_
x-microsoft-antispam-prvs: <BL0PR04MB492987D9027AF03167A249A2F22D9@BL0PR04MB4929.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aOEujsPZaNjItP3HVeJKwz02dA1kMMduS9eItemcOebDq/cTteT0rHsjPjQ5RpckU/+6sTYWvC9ERNPY7mfmI0Yo0uBzXivbykNtOLza0K8fjTCGKGQnCmyBV+KeSPVtA2nYEgK2A1dKpw/lT44zHARan7G9mmmURifCF1+9y0HdOcQAqc+mmNj4vMURozUaiSPcOqsjh7W9dhdCGIBdk+2o90MN8c/0stSLdPua34RWYb6iQ76Sg689L4CJpQNyltMf4uZRDTCTnoCp1kTDflVa8ChasK3BF//hNX6rpDvTcWvn51iFaMHBYJt1Z9aQig9+E9QvBfRUgzk4LQaoThvWggmy5hfyE+TsIidUK+aTWspqg3D6YQqYV9M+X4iPT17qsC1ZS1mVCIKu54t/1DmrQ4oEi0S0wtO8AH6teBf2s7/ebhmTEGdioQOIB4jz9HDbjAHIKSw+R5XiiIMoDLj0vf0QSYMB7DBRGPL+30a7KupPDPZI7ZjTsJrDkpRMV9rroYncDaZXOyQbipYEGIvYwD+CbZe8RpTnYIrTed937D0TtF5Cfvf9Pe9kwXzp1j1aZJf39LUdC5GDCr7xGo/kHXn/vy2GIbKOSPqomFK5hIVswfL2cwUCwCWgr+H8cro5tX62zG45lmdclAMvn09pjjrGpPMs3mAdMPjauS6LkfGjex7QDGyxEEZ9NWkQC9wi3AA5GcE2pa+GXx/YTWheJwLq1GCdOeZln9vONb+Kln2y/ZXuNDh84kr0kph4Ti72xRLtq/CXyGn0vqFumK8HKo7DZ48FILmWcF6WBd8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(64756008)(5660300002)(33716001)(186003)(26005)(4326008)(8936002)(8676002)(76116006)(66476007)(66946007)(6506007)(9686003)(6512007)(91956017)(66446008)(38070700005)(66556008)(2906002)(82960400001)(508600001)(86362001)(316002)(6916009)(966005)(71200400001)(83380400001)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oBhEGxWNdljMqQy8z824emx9mBhpIq/Ej2tqlte6FaBFqGd7RlfKTdcnuARH?=
 =?us-ascii?Q?RBd1npfTbICyEuWmv26YUtEb9CseLxKFIh9dxzMFE3n1P7CmYZ4d63xd/esG?=
 =?us-ascii?Q?lIqFLxWOMYwJMgEqTMJQtq53GMF1imQN+ma2SADjabmpxMYimoR5nsLJiyxf?=
 =?us-ascii?Q?UnR+bGZV0Ddw9sKJtidm09qXj7u3q6CmL4/yuR1PHna2BSXz1F/qDsdkDBr6?=
 =?us-ascii?Q?5shYUT2Z1kGi0CyaESYB5WTqq17VBRit/v6+vdcVylQaEgKeYW1Gxhhq4O8Q?=
 =?us-ascii?Q?KXR6AfSa8PYaI8BdGVjr3ni4Au3diMBJciRPpXHMpr5HWxIyl7KTVzP4cYsv?=
 =?us-ascii?Q?mlwFX/QOaXwXC94rpopp4zTJ3mtia8XKh1HpDAiFjWWwnq0cy2/wJ95n6tmu?=
 =?us-ascii?Q?Fe4rCTuPsAoulalClOZf3inG3EzmZWH5SWQXAHlpu/26fUCA9mYXBBubn4m2?=
 =?us-ascii?Q?9xzbxbLnRIMWD8vq2XOHRgqepCOSdbNhlQ9CI+vOKF1rUEOkD9cniLgjVXpH?=
 =?us-ascii?Q?pjz9hmY5Y2s7VQ43OJJTvJqmMECkRBtpQlpuLkvDgyjqD29PVFpA8QBp8UiY?=
 =?us-ascii?Q?NdYYmYnyB1KUa1SG3VHRojQoCvW8QrnYn2G7ymmD5F4+5mk43xvy8GSs7YAr?=
 =?us-ascii?Q?txme96ccHhaSI2+zZZ1l1Bz4QwgKEGax8BB6+Ud9tk3R/xkBolHfNYjXyKXQ?=
 =?us-ascii?Q?rVkfyHeda2Jh2HwPAs59MbauDOWZb0IJcGX2PjUJ27sYQO0/NHe7GENtxkKi?=
 =?us-ascii?Q?PSS1tqy0uGRNL8Kk2lhmviSVnMcGl/TQvW+TMtE5kgIvfNTyK1nYD4XKn+hw?=
 =?us-ascii?Q?nl45HxdUTJxfRhVlv8KGH2FX+TJ3bIxwXoSqzol0tgWQKNZAV4BbY4Wq7h0w?=
 =?us-ascii?Q?cfuz6TkjnyvwxdKS9ZNwH40d6C7+c8KX9VeQBWN+6+cEzGZ59OcnKsGXUSfL?=
 =?us-ascii?Q?4SlotZiYJ5/IPMLZmchAtY7UnTucOlz0+t+OyJZZaw5wkFz28xxYgOlObk2B?=
 =?us-ascii?Q?/3kGclIKkNmV5bxXHp0tOWGQbrVqfHOTVOeX+K5Htn82Wuc5tNo7XCF93xei?=
 =?us-ascii?Q?ksKO80QFVPOyrX8ePbzwcm9s33ashfrWBJHTkql9QJvlZ7CWrEExccnvu4Se?=
 =?us-ascii?Q?d1NKvaqG1Z7avFBIME4qWn8JmBQmKho0FxCB2oeKUf//n/p6UfwUdfu8CaGW?=
 =?us-ascii?Q?XeXo+akBbKWnHYbyFZ4luO6Q7wotR3BKAT/wgzaD+BIRZKMhuoekJnb6++kl?=
 =?us-ascii?Q?xDCcNMY1Y5xDC5YaoMM4U0/hbK6zr5zSA26FLUrimpFbJFotFoVKI/mfgN4a?=
 =?us-ascii?Q?wKCmdiVzP081B0mybTPz4WBe9O6Qr76GbQaJrwRvtFdnRJG/3fiwtcUYsunK?=
 =?us-ascii?Q?qpGFf6iDN6ZEAb3OQheM/TIYpDb7y0cQqjJWof/Io/9Bl1Dp2Zzavw/JZR+x?=
 =?us-ascii?Q?9HoBnBIwI+pP8Iy7fMUQvuJg64nxwZd7gC93b/xwJJDb0MkCls5/rv3aFLw3?=
 =?us-ascii?Q?ygfKh2v7tke9cYjyOCfynbMVpzYBdlUr5L7m6VujzulvwWwHOzNwcX24wCog?=
 =?us-ascii?Q?SkTJ+CrxtgZ/Gn7JGjzEmUWXXSESCenStai1asEY1rUGxF0Xh/KXOm9SqzpQ?=
 =?us-ascii?Q?uOZFno01+78ppFQCYcHX17w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ED8F0DE3DD52E642B6C2FBAED92E3241@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13428f04-7055-426c-34fd-08d9eb3f63b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 20:12:53.6411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k8nrhO2yhu+etR9+PWe/XdDSJ3yn16652Ec1c0frdD/jPRTqJ9q2oQDIhVuyACgWdyXXuZUchhKCqi4afK7UXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4929
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 08, 2022 at 01:10:33PM -0600, Nick Neumann wrote:
> I'm learning about io_submit_mode and avoiding the coordinated
> omission problem. The fio docs cover the mode and give two examples of
> using it. But there is a comment in the docs that says
>=20
> "Note that this option cannot reliably be used with async IO engines."
>=20
> I don't really understand why? Further, both examples in the docs of
> using the option specify the libaio engine, which is asynchronous,
> adding to my confusion.
>=20
> Perhaps the comment means to say "sync" and not "async" - I could see
> how pushing I/O to a pool of threads in the sync case could be odd,
> but not necessarily "unreliable", so maybe not. Just trying to
> understand what danger the comment is trying to warn of.

Original commit disallowed offload for all async ioengines:
https://git.kernel.dk/cgit/fio/commit/?id=3Dabfd235a05330eae8444f0e4c0039bb=
df9f160a3

Later it was changed to be disallowed only for io_uring:
https://git.kernel.dk/cgit/fio/commit/?id=3D8bfe330eb42739d503d35d0b7d96f98=
c5c544204

So I assume that offload works fine with libaio.

Perhaps the HOWTO, man page, and the comment in check_engine_ops()
should simply be updated?


Kind regards,
Niklas=
