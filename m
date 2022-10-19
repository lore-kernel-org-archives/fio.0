Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F54C4332F
	for <fio@archiver.kernel.org>; Wed, 19 Oct 2022 00:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJSAmR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 20:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJSAmQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 20:42:16 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1489379D
        for <fio@vger.kernel.org>; Tue, 18 Oct 2022 17:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666140135; x=1697676135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fHJISnn3TG0v4EifDY1Kw7Rq5WmA6rLnwoO0Zo2t2yk=;
  b=ZDhxmBR3AoVMrEsihwXhX4gLaD6Obaa4pV85DGLr8BCVCKqb3rnMQA68
   j0hqHacI0xsjLVBg7GPc/uOAaKwsxKFaP5rE3Ofij5pDfMjGtIKQ1+xVu
   3PP5olzbNorw8tv4D3D1ZKx4Fy2dWyMjLKUdYyHy68KLSFFugpG0ETsCy
   u6nGqoJHUeSx2rXHZhCRg6NNU8vH9f2QZXIdO9PQT3fsXkeJZfFKvrHY8
   ohCxcgBbjAR0ZVlS2dAaPvpmQGwe/L2JIWahiOGUqEe60D4BJd9bQE3rV
   tsZ5KD0D+tkBUNb7BqEmOq+C/xtiBXRV+me/p3jaHp0MjNlxvBU7xpOiL
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,194,1661788800"; 
   d="scan'208";a="219332765"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2022 08:42:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ywjzo2jRQeR6TxWFv8AugJxj53QtuPYOeuHuPUzvQx06JDz6JMs1m5zWkXvUYCL8pEV0g9ai2d9uPjst017vFAhu2RidZqkBxMdumcvfALepsyp3m6SKFH2w305ZyJ/7vbXYyqnAdRFFRLpN5yDyBuAkslW5P2vDp/7CNVkWla//gYr+rljXKW6f5QoHMfcpzq5IlSVCGdDU4Bmz6MVdXeW+3Ske04Cai2lD7TfUnQge9VUkGnSP2LJEmHBMuM4U5kgrnEiElKMZLyaobj8Th5cNpnXsw1TETr2MmqOzmbSmzJK2+fOTIOS5Fv7FRSPfzZcbPAiUtxF+dbxJpPqfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLcdWuFdwxD9H+IVVZ2zZ8a0JRD3e53aYTNrCx9h+oE=;
 b=i50l4IPXF7h74siizhIbZLUBrT4NB+llBGo+2b8uw5aB3uyJXcLuE89rtwKoeV9bxLyLZR16cUuabv6KlruA1t/n7ZPkwYuMX+iD9kMzQ4bWJxMbD3kCzjGnKlPESj9wDwKBuPTa+FFwF5Izb9l6bWQqwqPT0uoYpucYtXxNrSZslS2OG/GrdEslxH3e6UH6YkLsSgKKW4RiRjDJIUgHNG2wxQMXeU/pO7tAwkdYSQOS75ORFIq/WCCNym3LVwp0IzI6yFWDoNed4SBNwE1mBIUizZt9GlViCncBtKcva17H/9/IBb5xrA31R8FE/x3btJgGHcghDjKI0fk/328KTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLcdWuFdwxD9H+IVVZ2zZ8a0JRD3e53aYTNrCx9h+oE=;
 b=eMtU2h/YkOny5qABZkzHQiiVfLTZYHhpzSi1AMOFPe+NwZqFG0fxfvmmlRJsKTaokPjmdnJx0Mdis2xQ5dXQskkoFJFQdmty7QlPR/wqZ22vvWHsQR9+K/qFClzwVnVuAkE4q/Hq1z60t9Hv0KXFVgjTSlvgsqO8KPGNJ7Owkco=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MN2PR04MB5952.namprd04.prod.outlook.com (2603:10b6:208:3e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Wed, 19 Oct 2022 00:42:05 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::fe3:cfe5:dda0:f9e5]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::fe3:cfe5:dda0:f9e5%9]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 00:42:05 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Vincent Fu <vincentfu@gmail.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 3/4] test: add test for verify read back of experimental
 verify
Thread-Topic: [PATCH 3/4] test: add test for verify read back of experimental
 verify
Thread-Index: AQHY4qiMIlu6wdPZ0km5G++Rswd3Ha4UVLMAgACNMwA=
Date:   Wed, 19 Oct 2022 00:42:05 +0000
Message-ID: <20221019004204.lyd5zr5jqnzoankw@shindev>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
 <20221018041725.807940-4-shinichiro.kawasaki@wdc.com>
 <4640b1de-a98c-185e-e37c-770a895f1117@gmail.com>
In-Reply-To: <4640b1de-a98c-185e-e37c-770a895f1117@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MN2PR04MB5952:EE_
x-ms-office365-filtering-correlation-id: 13fefd2e-30dc-4f23-7808-08dab16abf23
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xaZBdKvfBzfj9CI6NnnlpjdHu327qHTPty/B4cimtxoC06BD7hH6sVMZ8Rbf/dWcKTA5OEC2ZFTyp5ktBER9G2UbIUQfC6pS1kk4K4TYSwlpq+faHovH4aWx7O3B8BhJM1Gy61ZVCqu74R69SPP5F7c0N00CLDmfwscmvlLhegOrzCKkraRkfEfuG5eot8f/r7og/i9yNzZ+ntZmYutBHP+60iVcGyKoautZtg79mOCPbj0tl4+FEOyoTt2kR0zz6qRaDHuiPFuxEnRLXO+ys+dPu8hglHVyl1g/6K1aHpYCruw1Bd7b81Tfkq6iPNXm3YwwdAThsY5n0J5JS1SZapNMD8yyBCu3xgmPboV4Ql5U6PEg3k6xaztVOqfL8woOTinqhLWJRxHq9wcUZe6WrNOoaURe2GTu1M0B/C0u5fV0V/2otrbdvNplUvQ26nsM1eFLwwmNLk04Wd6YuRw7R1SY9Dg1fR41E/l/wG7pXcBaUmWox/se7jWaYOn1maox8w8dWFuAkdKR9akayFqy5RbcfYV0KrQOW6UCZyhfZoqh5AnXgSoDSCtFYRHwjMBaLhtSoeJ90huV1nNjFG+yv/hi8PNXx3kjy7PSZLUvVixdrP9nWK7VG4LQYHZOWU2MmSFHO1qleWoGFAs6w83CERCHHHK9w8uhupGF7SCK8IJdpu7kH1Jn32wTnexyfTYbeYUOGlPXN8zDWCYXVp0t3WB9i0QAReSUV45erRGStLQDzCZQYSZxRay45jRR1onhEjmtXZdKpiXc2aonUvjmQkAF4u1Bqy4ondc4LqpMCUn5CSSI1jsDI3CUmqhEe8GM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(186003)(86362001)(82960400001)(2906002)(5660300002)(66476007)(8936002)(15650500001)(44832011)(41300700001)(33716001)(66446008)(66556008)(91956017)(76116006)(64756008)(4326008)(8676002)(38100700002)(66946007)(6506007)(122000001)(83380400001)(6486002)(316002)(38070700005)(54906003)(71200400001)(6916009)(53546011)(1076003)(9686003)(26005)(6512007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fPZsF3a5iEvzJGkjzFHJ+T5n9dykiNX1+4Xo2DF+JlUF4Vn+kd0ayl4e/cg3?=
 =?us-ascii?Q?30Hw2Ve6yqoPicvuyMXi7Md2To/yWKaqve5LxkFVZm6WDTMFJsdVeamuU5RS?=
 =?us-ascii?Q?+XVYAxjKaEeauYoXkFEG03beehEyFebzlJBj371489PZGCNP87Mz4XDrUbqe?=
 =?us-ascii?Q?6TDU8fUiRQNWxBOVJ/Sui2ehtmESm/e6o7oT2LG/koZ8pIhzltpwp40fMhF5?=
 =?us-ascii?Q?BJrRqtB7KyUzI3AVtXULaUoep2UMzenidEfeWFZwbHN2PipFeU3f0wqULS3d?=
 =?us-ascii?Q?Y8iF94gTaxjvLOszGuQNmY9h+kCqxUqNb3Ak9fnfBOYu9bEfsv01+fo8JLcv?=
 =?us-ascii?Q?ujwUhvFQr3DuUV25iGdjSg62/quNSsxUeLCiJ83upRXs/07im0NoQ7nUONr7?=
 =?us-ascii?Q?WVmOtNojJD64nVNSWcGU2xYk2uNazJLxqbLDvhGRaSM81LcZGVRnHZ3i5A8c?=
 =?us-ascii?Q?vwJliE/XoksU2FF1lI58UgLmsVaMIWJR/QmKHvix1Qza1+jwzshy6cSTfNkZ?=
 =?us-ascii?Q?D7/fHSIdT8nRvu0axM2ssunwyTErBefaiwFIzdaOZ3M+JKaFjUkVyNEBRK8T?=
 =?us-ascii?Q?ZLeDie5Rd5Lm6Oheb8KZ0ENuruWqtPi2OY1HQYrIW/TqOGBN+zHFmsoMP3BC?=
 =?us-ascii?Q?2kcdyzU9EdpSZ6BdTfTfYADCo3iMC6lfLuiDYg4MjI5D6zdYsWoyBA1cluvB?=
 =?us-ascii?Q?P3MEZY6AA9ieyRKsRoaQqCg6h2OaZ19eirtVwfDBx8PsRnhy4gwU4FvtaEkk?=
 =?us-ascii?Q?ULoal/J0K10dCUASL0bHujT/WkWOoW4iN56RqxXspw7jZS8qnuQ8x96yhTRo?=
 =?us-ascii?Q?nSn98bTl4Pc0tn1ywJG7qnsjBsN+jwbFIbJ3T7UK8DzrIYlNJvLy504aD2M6?=
 =?us-ascii?Q?GmpxJG8uJseBr6ecZph/Tsl+PpGSaP1Snqm1rXO1Cl3BOQzC3xBim2nnRa7I?=
 =?us-ascii?Q?j7qJ4tvFkPfTnmmhZeHEEoBi/lPHkyQlXF+cqvAuvcEQeSt5hkhZynQouTe7?=
 =?us-ascii?Q?wA4vQD1bUfAZmjkw2S3y8E5v2BLJBKrBTqgM97cPArjg7/7vNMvIk4wAOPq+?=
 =?us-ascii?Q?1h66qTjLRW2sCaYymqMsB6oKGMK3Z/bJZXC9jWzkB7ZC+eOSkqnK922amhsh?=
 =?us-ascii?Q?jzMlv5oJAAZCBWdNGIgIkHGQyZASw2d4Bdwov9DonMbRnD00oeQO7jZoZws2?=
 =?us-ascii?Q?tbOOFdgVIqmEde+4qQdjMIYMVZrPlTJ9OqIbYq77LKkjF1BcUN/seqfXIt+I?=
 =?us-ascii?Q?Ru+6NYhXVL0MoQ6CyfsLX+np+WWNNNAN1A03IsuAbicXuZQnqN3LocO2SRfM?=
 =?us-ascii?Q?bJUkUnjBZmogpE9ocSVFY6SGyt1lEL8YlJxYOcNkxv834j7oqBoKCDsZ91UO?=
 =?us-ascii?Q?EjxIBoAHUrqKnFCRY18USFh984eAMURu1KhVBjtd3l3eagJU+k/2jdFC1bDU?=
 =?us-ascii?Q?+WsZwAl4o+QCfRMIOagH0WsJTFVpQsLvp3d9hvgcR8tmMPzowR9zJx480pAS?=
 =?us-ascii?Q?3d+78zI8pEidcnkUVCDRVP0dNVOwNI8efYkdZZIJ/bqI48We8tocW3ugioU0?=
 =?us-ascii?Q?TD/7/xQzHtur/BrJjgNO8GemBrvUYGWZRiqO/hJjOZD+d2CbVkh+hlf0aMw0?=
 =?us-ascii?Q?39bsn+nZkxGymwx+XO74ZjA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A65F96A282D3FF49B43902A319FE9D42@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fefd2e-30dc-4f23-7808-08dab16abf23
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 00:42:05.7144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dmzPxVht5907tGx3BFB7zidPySJOgZHx2UcJ3NkMF1PlP801Qz42BQjYTC038KA5xWILvQOC/+FIGX/Rl1SlBaMCRkyujX7LDIBa/W3BxJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5952
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Oct 18, 2022 / 12:16, Vincent Fu wrote:
> On 10/18/22 00:17, Shin'ichiro Kawasaki wrote:
> > Add a test case to confirm fix of bytes_done accounting issue of
> > experimental verify. The test job runs a simple workload with
> > experimental verify and confirm read amount is not zero.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >   t/jobs/t0025.fio   |  8 ++++++++
> >   t/run-fio-tests.py | 22 ++++++++++++++++++++++
> >   2 files changed, 30 insertions(+)
> >   create mode 100644 t/jobs/t0025.fio
> >=20
> > diff --git a/t/jobs/t0025.fio b/t/jobs/t0025.fio
> > new file mode 100644
> > index 00000000..2b35a9ac
> > --- /dev/null
> > +++ b/t/jobs/t0025.fio
> > @@ -0,0 +1,8 @@
> > +[job]
> > +filename=3Dt0025file
> > +size=3D128k
> > +readwrite=3Dwrite
> > +do_verify=3D1
> > +verify=3Dmd5
> > +experimental_verify=3D1
> > +
> > diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
> > index df87ae72..0e15068d 100755
> > --- a/t/run-fio-tests.py
> > +++ b/t/run-fio-tests.py
> > @@ -788,6 +788,18 @@ class FioJobTest_t0024(FioJobTest_t0023):
> >           self.check_all_offsets("bssplit_bw.log", 512, filesize)
> > +class FioJobTest_t0025(FioJobTest):
> > +    """Test experimental verify read backs written data pattern."""
> > +    def check_result(self):
> > +        super(FioJobTest_t0025, self).check_result()
> > +
> > +        if not self.passed:
> > +            return
> > +
> > +        if self.json_data['jobs'][0]['read']['io_kbytes'] =3D=3D 0:
> > +            self.passed =3D False
>=20
> Instead of merely checking that it's nonzero why not check that it is equ=
al
> to the size of the file?

Okay, I'll modify the lines as follows:

        if self.json_data['jobs'][0]['read']['io_kbytes'] !=3D 128:
            self.passed =3D False

Before the fix, the read io_kbytes was zero, so comparison with zero was en=
ough
to confirm the fix. But comparison with the file size is stricter and bette=
r.

--=20
Shin'ichiro Kawasaki=
