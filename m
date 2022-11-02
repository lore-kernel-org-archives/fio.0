Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB24C433FE
	for <fio@archiver.kernel.org>; Wed,  2 Nov 2022 07:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiKBHfn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Nov 2022 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKBHfn (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Nov 2022 03:35:43 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F9D2126A
        for <fio@vger.kernel.org>; Wed,  2 Nov 2022 00:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667374541; x=1698910541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iGER+TbBaCNyB5iBs/k25R+89YU9yI0XsAk/Qe/lxUU=;
  b=SphM5LveCqL7aHQDP4e3CouRoQpXXfzSbNP2UdAaMRv1MuF5BjSWjlg5
   QiZGlW+6JvM0BPFPkV5XgDGYXMmZR7mpjWHYyUaLTe7VQy/TbXpkSuZTX
   CjGWuKkSDXkMUirRuukN+wxLZOIqdSZRR9VKOb+fhPlvbRXkZkh0V0Y3Z
   zvFMH9HRJTeRC/OtHxTdCLX4ekMzR2CimASdINIqueIESItzVlOcuSL5P
   uRN/7sTltUYllD35cvHZac0lH8eczrSEN93pL8boCBt+GMi08Z59Obs4f
   fYtxDOzZSGnys1W/gE/FxQngs/oNPuFgCUNNWF3I5yNthQU7C/1eNHDBH
   A==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661788800"; 
   d="scan'208";a="319624385"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 02 Nov 2022 15:35:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1rG+b7DkYb+2IJ3itzR0qZHCV7oxo/LCX9o6FmOPbYmQSIRn0iZwFp2RspsqgquQ/S+wgVkkAlIl/drXS2Ve1FKLRZm8ZBZvU/riv7AOViwdoDObu49ImP+K7YDc7nfz/oRileeSsFdb58+n7njPSGKngkCQOimU8WzAB7phkVH81tbOtnlTv8Qy6rBAL93wH44KB8Ia80eFqoZK9w8gWvObUNBZFusehsXK+QroSb+HcXS5pfbOxyjeQXDCjCz2yuPT8wCfzDjdVKY9q6t0HdNeDFH5bwKBe0KFZeJZL5Bl1Mmf1HLnmgv4YpVgzrAxFrStMoAkqHjbkxGqQo/8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkYEgyTwmgc4pLx4HPwEAOpHJsD2XL5wicB1Fe9XVRA=;
 b=heY8Knsg2iOoI3lZ0g0pHgB1PVKkhHx/WhEvKzCS48lGQlLrO32P/T8pu3oYyXxlhvBYSIPRrYNOu2tMkjVGRxEx8BD6gqdNP4jSN8AeA4jQM0gutPF9HldNMoIfYvjhWX2uXf79ZS6o8+ywm+dhmHQgC2MUkh9Ut0pBZkV6CX9N58bEkcYHnjuN/kvgjGvBRc+bzT49P85lFPQ9kPcXXoSO/sZjVlrMKMsIQ+ArqIkRlWehrwQ3smVBBEdudFmiBlfv2MqCE/bimdiLoxuBmUXsNIAQfr5CHliCFqttelue5LW5Cdxl56Y1T0NX7RysE576RjqLD5EXEfTbVVCtXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkYEgyTwmgc4pLx4HPwEAOpHJsD2XL5wicB1Fe9XVRA=;
 b=xBwXKCXDvJCZ1KR0RAsQSAhIE8weGiIvjdBqfZkC1mjH7m5VyffYEEc5u0EejWLh+audPsMgl9RHJI8cEiGUFRde2Tokp8aoa1mhr8pjLY4DIqMXJi8Mbk1tpIRaANnJ2HhS2nRTtk4w0lGk9JA254ecqZcKVG+VMG5VoUPLJ98=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN7PR04MB5363.namprd04.prod.outlook.com (2603:10b6:408:3f::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.36; Wed, 2 Nov 2022 07:35:35 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%6]) with mapi id 15.20.5769.021; Wed, 2 Nov 2022
 07:35:35 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Vincent Fu <vincent.fu@samsung.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v3 06/13] zbd: verify before zone reset for
 zone_reset_threshold option
Thread-Topic: [PATCH v3 06/13] zbd: verify before zone reset for
 zone_reset_threshold option
Thread-Index: AQHY6sP+NT6RlslKlkmia5DwRCS1ZK4qQtUAgAEDBQA=
Date:   Wed, 2 Nov 2022 07:35:35 +0000
Message-ID: <20221102073534.kjlobmc4z5t423go@shindev>
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
 <CGME20221028115413uscas1p2d972c4cfae98ffc0b5ec0c1dba829767@uscas1p2.samsung.com>
 <20221028115354.971715-7-shinichiro.kawasaki@wdc.com>
 <3674bf459f9e4503a5aa83fba2d3efca@samsung.com>
In-Reply-To: <3674bf459f9e4503a5aa83fba2d3efca@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN7PR04MB5363:EE_
x-ms-office365-filtering-correlation-id: f7dac279-2525-4b57-ff2e-08dabca4d48d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4AYsg9sqt3BT1AVcUwQTVZmAm3tMK4Npl+UPjNUG1MQKnvqTAiyvTFYHQ6hs/qdZjoajBZ8fKXXsZucGnPhOEz0XjsJjO8oVNzoSjABSbbsklTswG7Ei9hHg7XvsLgKf8+64BvXy2oc7Fwa4irVHsvC2pVtSTZ2oXWBYo3rMVy0jo4fLjD9JXwuXVgkoYsH8O8v4us1ft5Fyi2RptxJgv7IzTSpLfNzsBPLydQs1LpoId9Loss937o/IKcgXy4k2xEt/YU19np0DH9susjBcWoFgVefU4ojKTE4pgt2v2hX0ButXPI2j8MvOnzzzQZLkNcQ2t3aGvoDqWTMK1HBmarVXmDGUxnot0nkEB2aIBvCWDGGqIb1MUHtGip30SqYoXAydm9dY64Z7w8WgZipeAoI/9BgCyAtFdNxiz1c8nfl4pYItrvg08gFwHn2RaIX2Jo80Spzecjc2ggOJvW6H0dXKnguLEC6easBacNe7LEua8XX8sSXmG8Femgls/Bb+Cm38OS9BR56/l+LhogJr0mfM9KxM6xxiJFFMy7zbFmOekcH/ylNUa+Juu1efaAQln0MFff29L661GaWV+ikotslsc7F74i0IIU5ENzjX8ncFYRBszA8SHC2utnqOaXHVcn2ayhJg+gIyRocj3K59/tB5qN/P/tRD4K4za6c7iwCVxzfys9RTjvLdzTq7U8iOwiNhf34JcLmFNyEYxOL/fguwxbcL2/Q4jBth6hRG5UvIvLxcUDufWW46uxXrVrfDFdvBKIJ/tp7BZK1CnCyooA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(122000001)(186003)(1076003)(478600001)(71200400001)(66446008)(91956017)(53546011)(6512007)(6506007)(9686003)(83380400001)(66556008)(66476007)(26005)(6486002)(82960400001)(38100700002)(6916009)(66946007)(54906003)(316002)(5660300002)(41300700001)(64756008)(76116006)(44832011)(4326008)(8676002)(33716001)(2906002)(15650500001)(38070700005)(8936002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MMBt0+8RNosPEZdHRC4bbizUASqzwD1hhvGd3CtMbLkss4+HiaTG8P5xUixC?=
 =?us-ascii?Q?ZY9L+OOAA8GFGbLJRvrICBBLU0Wy8D4Z7SlhKMLbzTTxYMb3eQQffB4zz+r+?=
 =?us-ascii?Q?uC6JLLScjVwupqI1G2N5AeU/OvI0WVkT4w8FZvAGi9AqGl7b1y4AN2V2jyWE?=
 =?us-ascii?Q?UG5emEeRMRe6FhDI6RNNvY9ukK3b70KJkga87Y/eAavRThBdPgjMhhBy2P6F?=
 =?us-ascii?Q?kV97SsJPI41iV85DoKmqBuU9O3m18HoCv6/AGbGsJzMiHtind5IIGHeiiYTt?=
 =?us-ascii?Q?vMxqbiHFQE3gzqb0MeQbLdhlIpo4h9+3QasJezFsu7svNIn5rfmGIW+Ug8C7?=
 =?us-ascii?Q?AKFj9q27n0xWIOAwua3VPlmukW63WDYkIMcJv9RyxyX0Fuyu4/aUn2yF1rd/?=
 =?us-ascii?Q?wT2PDdWyj6yDijj/85exerh8cVHA4ARBV5MNTZJjhNi817boUXp9lURKkvsM?=
 =?us-ascii?Q?Wy2NS5Txi/fSrvJbJGRUxu622196opNI+x+mM8U00/NsEPQqms+NBycIT0RB?=
 =?us-ascii?Q?JckrO9Aa9Lmg01QRDeaaAsVS06o6wzzBmcp/KNs8r/pGYR4zlEqfFY2DtRMP?=
 =?us-ascii?Q?otKdp7BlDDx4QLWVVQSSWOnbrLgf9buLdwYO994X2kUk+M2ihde8SDRdRel/?=
 =?us-ascii?Q?LDLbkZJ6VqOC/g3dfZ1z/3pMv1o1UgWS4Eiy1HXeHSRZgQUqI38YF75+ZUj+?=
 =?us-ascii?Q?lnLAFIYm92ZMQ8r1l3K7K8n+nGSGyfpnUzz9w6LEf9c96gnA378+hjiQsbXq?=
 =?us-ascii?Q?/CJxAPR+I5ZVk6UOEvOnpGtr+v6x4NuzWW8XFIE/i7rAC4vnnVoSx8bPiM5k?=
 =?us-ascii?Q?lwKg5XDqPDf5Ho4cIv40y43ttB1FwWF4qALaFShEbRCYarxG5N8iYhsu/Fsy?=
 =?us-ascii?Q?JSE40BmDcSII6fMjkvBuS2ke1Xuu22f8uk8iVsPQRitbzNjHrWc31lkkOPP6?=
 =?us-ascii?Q?1c5IZordnXRND3rJRYuRAUsYbXwFm2h92Rk9BxgRy6PaiRrAYuUCb1w8jujj?=
 =?us-ascii?Q?lUDAPbZANZ/3IKqFITPyVSL+4TgbyclFyYiEVvOxt7xOwuEQAnnHAA+65BX8?=
 =?us-ascii?Q?G2yZcSa1gnFV0vhx3p3SCYgI28khhQ1Ylkm+xo8gK3XAKL4lzXtS8HlJhpWy?=
 =?us-ascii?Q?CALAqQQk9m0TSP7kOx/+9Ruy5SM0QHptqdFM6fDWfiyBxVVJe4Od1qKmHYKP?=
 =?us-ascii?Q?kgtY4v/ABnENFeWdqvZTKox6xehr6RgBl2Ncuthw8wajItoHqX0TLM7pvgNj?=
 =?us-ascii?Q?6xYrf+1pb3g79pD4VJNJRo4ZaoO80RMVvKqLyFC24lCLOLtIDJ4RV/n89UBl?=
 =?us-ascii?Q?T5/qu9htBw7HYFqCI8tTY9YqT8csa/K7dFE8LNciFJUDcpRs3/bz0UvGTneW?=
 =?us-ascii?Q?DCDZv0HsVOUc24f2CMMbP7zYW/7ard8xkUGed7Gi7QDAjg66+1J1C4hitTjz?=
 =?us-ascii?Q?rL9RKTw6GJBUd3Cr0bT+cvkwR+9WToURiFg4hIuuVf/AG0Eou1+QgT35cjpp?=
 =?us-ascii?Q?vrXJEop8iwjqmM8bf+Eyj6APKEDJj+78fDuRqCgC/av67Jp0hqCGfhhNxEi9?=
 =?us-ascii?Q?BaXxJYI/5Xtw0MrEW5ASR9kGcGGziKE/nSsebN0oz2Lbp8/aF/iYKlEv7ekI?=
 =?us-ascii?Q?/DzqOvwLX+4OxgxDcd5DgxE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85209E5FC3B61643B1E80A0E310BD981@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7dac279-2525-4b57-ff2e-08dabca4d48d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 07:35:35.2456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JKA1+U5YAr7OPGo5g8/OvEtXKcy5RqspGRWYkgtuY/pji7rNf9i8EgeT9Zq+3iYaQdE/Mzpt+TJcXjZL8Q1P7xzjUh9S39+JtnOG+ybreq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5363
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Nov 01, 2022 / 16:08, Vincent Fu wrote:
> > -----Original Message-----
> > From: Shin'ichiro Kawasaki [mailto:shinichiro.kawasaki@wdc.com]
> > Sent: Friday, October 28, 2022 7:54 AM
> > To: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>; Vincent Fu
> > <vincentfu@gmail.com>
> > Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>; Dmitry
> > Fomichev <Dmitry.Fomichev@wdc.com>; Niklas Cassel
> > <niklas.cassel@wdc.com>; Shin'ichiro Kawasaki
> > <shinichiro.kawasaki@wdc.com>
> > Subject: [PATCH v3 06/13] zbd: verify before zone reset for
> > zone_reset_threshold option
> >=20
> > When verify option is specified together with zonemode=3Dzbd and
> > zone_reset_threshold option, zone reset happens to zones not full. This
> > erases data for verify and causes verify failure. Current implementatio=
n
> > avoids this scenario by assert.
> >=20
> > To allow zone_reset_threshold option together with zonemode=3Dzbd and
> > verify option, do verify before the zone reset. When zone reset is
> > required to an open zone with verify data, call get_next_verify() to
> > get verify read unit and return it from zbd_adjust_block().
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > ---
> >  zbd.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/zbd.c b/zbd.c
> > index 6f4e5ab2..af761c17 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -2032,7 +2032,10 @@ retry:
> >=20
> >  		/* Reset the zone pointer if necessary */
> >  		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
> > -			assert(td->o.verify =3D=3D VERIFY_NONE);
> > +			if (td->o.verify !=3D VERIFY_NONE &&
> > +			    !get_next_verify(td, io_u))
> > +				goto accept;
> > +
> >  			/*
> >  			 * Since previous write requests may have been
> > submitted
> >  			 * asynchronously and since we will submit the
> > zone
> > --
> > 2.37.1
>=20
> The new test case 59 assesses the above functionality with a sequential w=
rite
> workload. But when I try a random write workload, it seems like randomly
> generated write offsets may no longer be changed to a zone write pointer.
>=20
> Am I missing something?

No, you caught a bug. Thank you!

I noticed that get_next_verify() does nothing to io_u when io-u>file is set=
. So
the hunk above does not return verify read io_u from zbd_adjust_block(). Ju=
st
returns the original write io_u without adjustment to write pointer. Hence =
the
weird symptom you observed. (I checked verify debug option output, but
overlooked the returned io_u was not read but write. My bad.)

I modified the hunk to unset io_u->file before calling get_next_verify(), t=
hen
observed the verify read happens as expected. I also found "goto accept" in=
 the
hunk was not good either, since it does not unlock the current selected zon=
e.
The hunk [1] should work good.

On top of the workloads write and randwrite, I also tried rw and randrw. Th=
ey
reported another failure symptom "rand_seed verify check failure". It happe=
ned
because random seed was not reset for the verify read when zone_reset_thres=
hold
option is specified since all write operations have not yet completed. This=
 is
same story as verify_backlog option. I created another hunk [2] which skips=
 the
rand_seed check in same manner as verify_backlog. It avoided the failure.

With the changes [1] and [2], the zone_reset_threshold option looks working=
 good
with verify. After some more testing, I will post v4 with the changes. I wi=
ll
also improve the test case #59 to cover the various workloads, write, randw=
rite,
rw and randrw.


[1]

diff --git a/zbd.c b/zbd.c
index 6f4e5ab2..fadeb458 100644
--- a/zbd.c
+++ b/zbd.c
@@ -2032,7 +2032,19 @@ retry:
=20
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
-			assert(td->o.verify =3D=3D VERIFY_NONE);
+			if (td->o.verify !=3D VERIFY_NONE) {
+				/*
+				 * Unset io-u->file to tell get_next_verify()
+				 * that this IO is not requeue.
+				 */
+				io_u->file =3D NULL;
+				if (!get_next_verify(td, io_u)) {
+					zone_unlock(zb);
+					return io_u_accept;
+				}
+				io_u->file =3D f;
+			}
+
 			/*
 			 * Since previous write requests may have been submitted
 			 * asynchronously and since we will submit the zone



[2]

diff --git a/verify.c b/verify.c
index d6a229ca..ddfadcc8 100644
--- a/verify.c
+++ b/verify.c
@@ -917,9 +917,11 @@ int verify_io_u(struct thread_data *td, struct io_u **=
io_u_ptr)
 		hdr =3D p;
=20
 		/*
-		 * Make rand_seed check pass when have verify_backlog.
+		 * Make rand_seed check pass when have verify_backlog or
+		 * zone reset frequency for zonemode=3Dzbd.
 		 */
-		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG))
+		if (!td_rw(td) || (td->flags & TD_F_VER_BACKLOG) ||
+		    td->o.zrf.u.f)
 			io_u->rand_seed =3D hdr->rand_seed;
=20
 		if (td->o.verify !=3D VERIFY_PATTERN_NO_HDR) {

--=20
Shin'ichiro Kawasaki=
