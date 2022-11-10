Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5162C433FE
	for <fio@archiver.kernel.org>; Thu, 10 Nov 2022 10:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiKJKlX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 10 Nov 2022 05:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKJKlW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Nov 2022 05:41:22 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB18AEB1
        for <fio@vger.kernel.org>; Thu, 10 Nov 2022 02:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668076880; x=1699612880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=96s0lPt0UgpQl1G0KwEt/jTil0PWhEjc9akQzS/pbCU=;
  b=lP80xG0puW1G8foyfBygUw6S53vvjiyx1QfU8+uRxrSsW9k1fx8wQP1o
   n3uiZe3c+V2WtPbJ7v/p4uY7gtGmr9Iw1d8fbHSoKnPYt9l1y3qtCK7oH
   SxpPUA8cbWMI2r6M0rcydRBOp+wQ+Ft3AysirnKDyWT/In98Z9NGOuQdY
   l+FOSpkQyrG6fNpHDfbAt3p4L9KtwktSPaU8XPfREfZDD8bPafDnviT86
   /g7YHo03n2OR2FZsAKhRFLe+UlMCREYJBEG4wFMKtrs24DajG2YLSdNoT
   ch0f7aVqpiy3nKmFrI6KFCOsB12lGASQuHIHXHZkAokvFW7Ebd7GdBKEv
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,153,1665417600"; 
   d="scan'208";a="328046712"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 18:41:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpGV0kdwvSoebMQLR+K59IdrESQJXP5EoVVmj8xfMhXa1RFbuEIyPeA6VQRF9t39dK7yfCxdzCQFWZ7yKSqK8JpuELkEqvdqMmuLtzMluTyxCnt1ARXMrJLgvqSPDBh1SvMxlT6MVehXtHeUZ8a6J1wu4ZdCjz5uPjFRsiHQsjhO6mB5r+TidY4DnRQ4AIQ6/ow73hoNBDO2nc6mN8FxQLI4agYSGo/xNjUuku0kIJj/+ELqyfmFkY6rYlPYH45bbKo9qqttxtXQo1ouIEbv1gh7KFQYIoDakd8dVzgnSFbE7S6WhrnRXbvDuqGwy3BGZY8vyensM2Zo22tOKbsbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4IoBYxnuGTidMtDl10kAXw3bybZWduUQHmEhEwNXxYU=;
 b=mRQs6SU/MHllnCadQP+yM/hidtjLpRoQK5WnpLRlQoY+S4hFmgkYeuofMM68KdBHLISvXe6oERXItDTnqMXRU6DoyCzyCPR1tbmntnpciDYxv6Q1Y9uw0u6/NlNAkS5tshBSGvt6DUN28BXXKcvUiqGg5CU9AVX8wsnBIVqIJWBqoL9+GKQjLRbnqYpsRmoHdPkYwyHt9wxgLuBXRY8hKVrIEyCmdLa9DCjEGQUEKPBXg2hpXcnCPqBSYg40IwIRorMOP7TJqxSmJKNZOmLMg849F471RLUnhs1j3rQl8AFQ+VRzGt6FYdLaUCBTqKYXbxNuzhP5lfk30XGVSRzK1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IoBYxnuGTidMtDl10kAXw3bybZWduUQHmEhEwNXxYU=;
 b=zRqJLoQTY8YU7UzjLGy+PJNySx2UyZJGrvZtrIPt9Eype2QQniNM4mUf26F5WsbPkd/FmpfuYT0oAhH7MOncrLcXQCL6l8WBhCAV4zXwIkO8coel+Eqqi3ZG7VUrjZFsiwZqxO3GKrkPsfRY13J/e9p9E7qBTKEUaP1e4pAYq18=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6682.namprd04.prod.outlook.com (2603:10b6:5:247::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Thu, 10 Nov 2022 10:41:18 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%7]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 10:41:18 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v4 06/13] zbd, verify: verify before zone reset for
 zone_reset_threshold/frequency
Thread-Topic: [PATCH v4 06/13] zbd, verify: verify before zone reset for
 zone_reset_threshold/frequency
Thread-Index: AQHY808Tq3hQp/tcY0WoB7x4Anu4WK43cYmAgACJxYA=
Date:   Thu, 10 Nov 2022 10:41:18 +0000
Message-ID: <20221110104117.qo2r2mqvtbb76ics@shindev>
References: <20221108084940.1574939-1-shinichiro.kawasaki@wdc.com>
 <20221108084940.1574939-7-shinichiro.kawasaki@wdc.com>
 <f728d0cd13f311b5deeae3651ae0e3716c0f3336.camel@wdc.com>
In-Reply-To: <f728d0cd13f311b5deeae3651ae0e3716c0f3336.camel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6682:EE_
x-ms-office365-filtering-correlation-id: 32de4b52-63f7-42ed-08f5-08dac308199b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2kKeWAWkg3gPDeTpvdJ+8RFu+5c7DK0PcVdBYwUGAqKV1A5/hNw0l+SZuhDxKLuvovVP66yrD8yF5hXF6qXZ0Y4szmpLpo1MVx2dfBMB0jQ4/Z7auAtz2pehWKl/ASOJ1AJ3jeDIpSMwR1v1nXEZ7048bew+EOhQIYpLatH5QHMMUPPN9DatJ1iqj59AIX/xn4eL8ewvPFRfanJEJUmiymWDBjoYKoLOvvjiNhGw4CFje4sGtk/OzZQK17ORhlMcUgJJNU99F9Rlvel52Ay53A9iqBdg5WeDF2bQ1M8O3xdVBJQU688sYOqzZ64ZptyY5IOsSzm/L2umruhkpLsF8GDryNj7Up1kxyKDzcGq/nNhSTbUWIBSXNo9+xP5CvkjgUS50ezuFdy9UihOjWNb0dPR431JWzlI+VVSxkd3m7XXPiAOoFDYENto5hlLf6AJKaqIaXziN9Fj5OnCHbfMxwlQIcv6CrJ257/3+pq3Ym7t/KbP0O6U9ZQrqmaX+QsX5lBrKmwcOaMXDyzErGbGQnPOqlS6NizzASHZJV4OJBgHDdfAsnxcGFjnNEuhtgj16XZf45wnhXJgAG3QYFTUNGuBEOe2mW8wL9MqdvIOB5c+6pFnSnKHUinWpX9b+RUtR4eYrQ+qZ2JrZeeuzTwyrAEqN5uIDZNCcUxkXpNJavivINmUKUFR5SSpp/byzd3D7DwC+3FKyGbrwXUQUDiO5JSPMcUXS2s3sc+8IU5PCUzHOj+1fU7ThrYkQbd8LFqstTjh0kJIvo7s2pYBNn/13g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(83380400001)(6486002)(82960400001)(122000001)(478600001)(38070700005)(86362001)(2906002)(33716001)(9686003)(8936002)(66556008)(5660300002)(91956017)(6862004)(54906003)(38100700002)(4326008)(66946007)(8676002)(66476007)(66446008)(64756008)(6636002)(316002)(1076003)(186003)(6506007)(15650500001)(6512007)(76116006)(41300700001)(26005)(44832011)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QRH/HP7GvQr7EdakXOc2NIfr3oxvjkNMnBHwwsOs7cMD9NXhi/+rZm1Shy73?=
 =?us-ascii?Q?YmXr4wKFY43zqmPH2N8Ie8jk/oLhXiUkxzZZzf+i2tFemZV6SR//aS5BlYGr?=
 =?us-ascii?Q?OLu5xzFMCPoVVGlfdALjOMS3bWL+931lcpYweZ4BDKvKtSWIypLDwFOMIZY5?=
 =?us-ascii?Q?udO7zuZXQYGNTNJNJWVcW2W6tyHfzh/ZNtGO6hwD553tGfF3edQEUXou/h/n?=
 =?us-ascii?Q?Owjjm78vkoIdA9bO2U5jslQPa9WCxL/rq7miuRnsRqF5VrSg8oo0HSKGJv9S?=
 =?us-ascii?Q?oVAOBB5TlI3e0O1tpP7hHvheDgZyN++mClakXqdYjRquSoQGXXTRg0WFXH20?=
 =?us-ascii?Q?ZcMxMtB8zWNL6KnKTLG6ehFixNQ85W/CIGH2UUqAUZpwqiwWBQYVDTABwzq5?=
 =?us-ascii?Q?7lFiNCfOIboWJvF82KfxluXcVdgm7i17aCS8GtmDzy34DLEt0loo3TWvEr3f?=
 =?us-ascii?Q?6IuwlcQTnJp5wbgUPoXalt0lxxKOo0BIhbdKQohABcMOwaXMmmYQKyylXqJm?=
 =?us-ascii?Q?2DB18lkcwKOc6toTAKA6w3YiyYaTxipowp3ohJXVfSajDjU8e7T/9/JeTCVk?=
 =?us-ascii?Q?vpXazixzpgyKbwvBSnMyTk9hkCQpsvZd4gz/yFNTUqnjnlR7YwL9moOleCqO?=
 =?us-ascii?Q?XA52Z6Yki4AlLFd8Lv11BE8UuVeklN7Ta2xm7xxR9OIZjF7BWGrHQemrQKQ1?=
 =?us-ascii?Q?jGEh4a6pWz0VJjEPFfKgQMnW+2+lgXaWn7qaN55HPTtphbKfBoaqcGFsrxq7?=
 =?us-ascii?Q?DDts4WzAOh/VL+BN2YeFdYt2EkMSfekpjW4ABGLMtAqrjpW7uz5Swd5lECRV?=
 =?us-ascii?Q?gpOdBKf7yYxqByOjwGWqwXWyFCbC/O/iC2auFCD8V3yfagXVbwhBUXnyMYW+?=
 =?us-ascii?Q?/DIEFsCkSFM9AZJ+KlA560BcI9ZscXS5fDsD1MGcPHEP6wWCB8EdivQDXY7n?=
 =?us-ascii?Q?i5C38cmj17gCzCGFpCVMjfGc9EgfrSmqQlouPB+Pl2Cae+SZu5uNUIHCAr64?=
 =?us-ascii?Q?Jqzjiq0P2lGmFz7umHz6ysI9ZKBUiwZBLriunA635It8UDqFrhtsdJ0rXFaw?=
 =?us-ascii?Q?HaOoIUq/DQ2F/jXfyEuOxGyTFvb/JN2GFvAjBYJTiJx5v/VNAOfFOWOc6aVj?=
 =?us-ascii?Q?A0fROBtBFfAVj0Mh/j/4c1wvQX786ZEvrXLFJ7ttH0a6wAWaT0j9Xu9qH3P0?=
 =?us-ascii?Q?eWPGLEChApMHCCP8Q2Vm26oEMQMogTDwE1aNMVsNj5/iv7LWOVXSkbroPFva?=
 =?us-ascii?Q?j1duRysyKbMEc0tYhqvVGRjdVyFqd8T6j1alcJpvEh9VUr5kpeWXszvhpcrf?=
 =?us-ascii?Q?o8ckf5k/jczPYI7AHsO13bBkoRUFlVgKGr+ygSNgMjGTKe1GKtYaSlCTOe1N?=
 =?us-ascii?Q?LXPWv78YA5ErRQggUEP+GlZXl8PU/BqjOs6cYu9QUxm+xN5BvZR8a//tdZDQ?=
 =?us-ascii?Q?W/z4IdPy1Wx05hwyl9efp5OOXPYXMRf53SoUN/v6HJfpsHWaSfJDj2MCEtL4?=
 =?us-ascii?Q?cU43qvJQFgzb4ZTOBdVOwVYpr0mbFBrOyRl8Q3mgPCSXAmAEwX+/WO/C1PYi?=
 =?us-ascii?Q?HS4OXRSrk2lzWmSkkIGL0XwxMsPrLcU0dXb+TL8y54kXtbPjEvtb02EsKAZ0?=
 =?us-ascii?Q?2s3rbnUleOq6QPQ3gsZlOy0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EC957F76D2B3EC4C82EBC126B381BD9C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32de4b52-63f7-42ed-08f5-08dac308199b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 10:41:18.2466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zAZloOj9gT5IttDsOPBFXkctf4PkQRZHhllJw5/xvICAOdE+u7+rgvSc5gxbAkhwKAFRr2iq7xuyGwWkgs6m53mjR8yE8AaIiPoNI/cx1Ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6682
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Nov 10, 2022 / 02:28, Dmitry Fomichev wrote:

...

> Yesterday, I encountered a test failure with the version 2 of this patch.
>=20
> When I create a /dev/nullb using this command -
>=20
> modprobe null_blk nr_devices=3D1 zoned=3D1 zone_size=3D16 memory_backed=
=3D1
>=20
> and run t/zbd/test-zbd-support /dev/nullb0 against this device, the test =
#34
> fails with verification errors:
>=20
> verify: bad magic header ffff, wanted acca at file /dev/nullb0 offset 335=
54432,
> length 28672 (requested block: offset=3D33554432, length=3D28672)
> verify: bad magic header ffff, wanted acca at file /dev/nullb0 offset 503=
31648,
> length 28672 (requested block: offset=3D50331648, length=3D28672)
> verify: bad magic header ffff, wanted acca at file /dev/nullb0 offset 167=
77216,
> length 28672 (requested block: offset=3D16777216, length=3D28672)
>=20
> I was hoping that v4 will fix this issue, but it is still happening in my
> testing. Setting zone_size to any other value or setting zone_capacity to=
 a value
> other than zone_size makes the test run without an error. This is very pe=
culiar.
> I wonder if you can reproduce this failure...

Thanks for finding this another bug:) Yes, the condition looks weird. I was=
 able
to recreate the failure with zone size 2MB and 16MB. With zone size 1MB, 4M=
B,
8MB and 32MB, it was not observed.

I tracked down and found that get_next_rand_block() calls fio_file_reset() =
when
zone size is 2MB or 16MB. Zones are reset in fio_file_reset() path and the
verify data is screwed up. Hence the verify error.

The test case does random write to 4 zones with block size 28KB. To track r=
andom
write offsets, fio prepares a bitmap with number of bits =3D 4 * zone_size =
/ 28KB.
Each bit in the bitmap indicates which block offset was used for random wri=
te.
When zone size is nor 2MB neither 16MB, all zones are filled and finished b=
efore
all bits of the bitmap marked. So get_next_rand_block() does not have chanc=
e to
call fio_file_reset(). When zone size is 2MB or 16MB, all bits are marked b=
efore
all zones get full, so get_next_rand_block() calls fio_file_reset(). This
failure path can be recreated with any zone size using block size almost sa=
me
but a bit smaller than zone size (e.g. zone size - 4k).

fio_file_reset() calls zbd_file_reset() which resets zones. zbd_file_reset(=
)
checks the condition not to reset zones for verify, but that check did not
cover the failure path. So the fix should be in zbd_file_reset().

I create a quick fix patch below. td_runstate check is not good, since it i=
s not
set to TD_VERIFYING when get_next_rand_block() calls fio_file_reset(). Inst=
ead,
I think td->io_hist_len should be referred. I confirmed this patch avoids t=
he
failure. I will do some more work to brush up this fix. Will improve the te=
st
case #34 also so that it can catch this failure.

diff --git a/zbd.c b/zbd.c
index 547c727f..3106831d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1270,7 +1270,7 @@ void zbd_file_reset(struct thread_data *td, struct fi=
o_file *f)
         * writing any data to avoid that a zone reset has to be issued whi=
le
         * writing data, which causes data loss.
         */
-       verify_ongoing =3D td->runstate =3D=3D TD_VERIFYING || td->verify_b=
atch;
+       verify_ongoing =3D td->io_hist_len || td->verify_batch;
        if (td->io_hist_len && td->o.verify_backlog)
                verify_ongoing =3D td->io_hist_len % td->o.verify_backlog;
        if (td->o.verify !=3D VERIFY_NONE && !verify_ongoing)


--=20
Shin'ichiro Kawasaki=
