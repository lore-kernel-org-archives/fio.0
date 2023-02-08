Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8224BC05027
	for <fio@archiver.kernel.org>; Wed,  8 Feb 2023 04:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjBHE72 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 23:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBHE70 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 23:59:26 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C692042BD9
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 20:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675832364; x=1707368364;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vh76bQSiVlFNp6fIzsR1y5YUetGz2ySwW/OU4QuGDH4=;
  b=e7NPyRSqo5rYWVyMi7AsX6dhKGW0s/QeygTTYPBkouEhrnmU/0WeIDwe
   IHDETqvk8snMfU0Q7CUUkqj6RIRwbkrhxQoOfg4rx1vP6T59BrYmAg8TG
   hfr9dSW5htPrcLh3bU47l2zLteNYHstn2Sk3vK/eNDBM0k7ZMQWaUUxip
   1wUFxcfpxzWgOe+8s0WBOPhCMvyeoJsz9TplSNfWaKFkWB1FHzHXGpRPl
   b5SB/pGZPSfmZ/D909F3VrR8AIZfIoTP6xwu09VDDLegsxahkUIfluyou
   oh3b7fTQ6ra/92DRbXz2qGnMFW/g2db0F3n9NBqGsB9M0+v7d0R4N1/HS
   A==;
X-IronPort-AV: E=Sophos;i="5.97,280,1669046400"; 
   d="scan'208";a="222576539"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2023 12:59:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUu58QlzF+4FZJwBydSEg39z0uhydPF62p+8cZs2XiVrfJa4u5yoQlmzLbjm4fwEW0nMlqGvg+svmOweb3NWPhXMztjVx89mjRQftYgYL8rFyK0vLbcpzxZworT38vpUISszE9qrDGgpiwBs3iJ+Ctdp8VPwwHeEjDpcdL0iOOanuHa4B1z7IsxOamb5YejJqKL5HN/QFXU3/9hkYM1znvwKkEBKNzBWDwlKRBzAZG9ic+yYnC5hxt0Jg0SDJF1RLMr0KkOoVfKfoPgWDn9BUtk6v+3C9E6KgFHDSIo5QuBwwPQigD2qAu6cpbiEBO7D6NrWS6vWYvdU6J1Gnqq2Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt8Gp/7rrKr9QNgni9px+hmptDBBy7ZMJwvbQOhw46Y=;
 b=g8jtIu39vepsfyr19/012nnB/H8Bvy++kstAyNDYjovElaYoqr26PzYVDOvX8L2ed2v0thM2+4QdYmPpJz0bWYbEiwixR4wwPCzjcii4Lwbnygk4wjTMQO+xlxIeRr6+AQtLpNnQfyiFkr/UY5tjmUIlVsEIZblOQokod9ga1TtB+n7vf8L76FNOnhLJ3s8j6bmQYJ4p4PG2qJEh8lC64rjvKA5ZSZ/AJxU8dmtX7Uu+aNwdlQSWnoN4Xrth9++sdcE39WfGzmvEPkfvKVp0gx62F+ziMQCDkT1+WUZ6Olvq28RE7qcuXmHJgJm8gWhWhJk5EDfjtyvDw43leBpbJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt8Gp/7rrKr9QNgni9px+hmptDBBy7ZMJwvbQOhw46Y=;
 b=K9oTDYKqjayzEyCq2nsvdLZVLazDHVd8y294BSgg0S6g8TbjWDSKgd23AboZDSqmqnn9znE1jSH+vRZ1Jv4Gah2kYor1RRW+02b1tjUkwKAJkyDnoskObDeYZ/0lKfslYmNcAgOChhz+f4oxyhY5NlgjHO7IPWJTfnBsKr3DxLk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH0PR04MB8033.namprd04.prod.outlook.com (2603:10b6:610:fe::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.36; Wed, 8 Feb 2023 04:59:20 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f2ed:2204:b02f:9bfa%5]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 04:59:20 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 6/8] zbd: check write ranges for zone_reset_threshold
 option
Thread-Topic: [PATCH v2 6/8] zbd: check write ranges for zone_reset_threshold
 option
Thread-Index: AQHZOr64piCJDv5JxkmzTyG32k1ANa7DhTsAgAD5e4A=
Date:   Wed, 8 Feb 2023 04:59:20 +0000
Message-ID: <20230208045919.s2s76gpdcp7n5mog@shindev>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-7-shinichiro.kawasaki@wdc.com>
 <Y+Ja38Vlb49Owx0r@x1-carbon>
In-Reply-To: <Y+Ja38Vlb49Owx0r@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH0PR04MB8033:EE_
x-ms-office365-filtering-correlation-id: ef855e33-8a5d-4a13-7d72-08db09913d26
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w91j9EdrnSZUdvGXfKEkCPGSJw0IFZGWSXJNwFz8EJ7zuFIl+78Tf1+/fynEhkm1MnTuf5vs7qtK2EcnyfZC+wAFmdxHXa5sHpnCHZ55chCr/MZfu+4DszfwqxWZWwITSRPj67c7QdYcUqo97EtXVWKR5wFw44yo1uUNO9s4AI/Qm8alEDk5x5WITtExnwWdqa1PJIiE+3LgdGG8l0nefrHDe6iLd3sBZxUGYpplh6/jbfdrohH1wN5C5FsKol3026HR74Ab6eRXEk4LTnsWAUXoparlczkU6MKIFs0B3aHHjf8MUPDGbBpVHWK8jayzVd+rvl6lpZrNybDwefBw1tiUgBXehcmT0GWS9YfZRZSFINljeYexJPAfw2ueyH5BMX/7N4LMnq28X6a7P7udZipOkU/8JRpfFzgUFTxRSd+Jpg2Td4LFhz2FiO2b8sTLavCV6U4/f7ClHEiOhYbMUgeeasi+idpMXlj/U/N8VtFHTSMcGJZBG739ChMf0sgu8joxtftoEOEnRcbYqmO0isC9hep0bL14fBd2ymrW4SpDaL1h/IRt9Vg5UB62XR38KO9RrYAz08JslTWyArxHN/79Ym8/JDkmSKEyWcpi9SxzuLrdm+0Lrqnsi4qh3BdwhtU6HV2Kp+dDrreXCdeyiOjUiIHGHzLHZEnWSqlo8yFz3ngwYfwwMYfbFpdoffshYN86GBMQgMiNUOdcm2TFEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199018)(41300700001)(82960400001)(6506007)(1076003)(186003)(26005)(38100700002)(6636002)(54906003)(316002)(6512007)(38070700005)(9686003)(6486002)(478600001)(86362001)(71200400001)(4326008)(91956017)(64756008)(66446008)(66476007)(66556008)(76116006)(8676002)(66946007)(33716001)(6862004)(8936002)(5660300002)(44832011)(122000001)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sixB0gP306iB7ekNFk5OGCJdiVspNpeQ7TwToARC6WDHUrGazPTWWdQoQZ8L?=
 =?us-ascii?Q?Kfgz8Fq8g8ocn8RMw/vCtp54daaAMwqyCPsZ5pGu0yoVJ0O7Lm6VMIK90y+B?=
 =?us-ascii?Q?a8KAzjRYO6Ch7zWdsbx5lNIg7hqUxTW8hjWT1V8LGNbbp8Ow/ffcbs2tKqVD?=
 =?us-ascii?Q?CszIe46JD7dw6w34Bgl0ZD2WluVP7b5RbyP/M31Efjj2lzao1+SDr1Jj5fok?=
 =?us-ascii?Q?qKwhUU4ad6dMdJr3XG8dzDLBzBgJNLd8Ko6M6QTNZe1u8DRfnDqDkzj/4Gx7?=
 =?us-ascii?Q?hFj/I+LT6v0+YmWGwfKcK0zZSfroBWMu/HODZhgYJSEMO9OmdWRkUXc7BEuk?=
 =?us-ascii?Q?a00TFPXXlrjlRfjRdL4ukMbmpqpLY7zMKxVtl2NXEo+oil3gw773h5OgXLDJ?=
 =?us-ascii?Q?/h3Eo9Gvj53pzEZ9rHYBBaI/95sUpwViEl8gykwPTdk9u5vpiF+WCeJojEwz?=
 =?us-ascii?Q?M+qFnPhzDYG2Dkq85gMifSP9eeF6d/VFjHwIH2hwYp6O93+E1RPydKBXjfyN?=
 =?us-ascii?Q?JVJq8ynQK/o71+y3qQLAVLoTtYge2cd4ZiymmmrUNCwTsA4Uco7fyc+nwmVO?=
 =?us-ascii?Q?TyzL7JCs0eZ+PpgOiimFZgKsVyXvF1DnHLiDF2LueyOUbnkXGRvwyEcs5wSY?=
 =?us-ascii?Q?Tcnc7DLu6otXqw2KP+JtDUxdbT/4AYIzXPnHRL/1JKgEKTKsN64f9mqbnDoz?=
 =?us-ascii?Q?Va7CCjONOkGukboJPfnB0MTU3rAVZHYh3ppA0Ar2XLEHpLB0ie9DcN5MhfrH?=
 =?us-ascii?Q?EcfMbyUwxnJ1j84ItHdgaqAs6POfeU86DBZtgFL8AboiXmUaNPicoZpzdhcd?=
 =?us-ascii?Q?FP79Aal1a/Imn8fnCpgKntOzOwH1Xe+H69H9o/F5O7JdGKestCrzCVlndbLm?=
 =?us-ascii?Q?eOnZYQB8ATPzfOqRhjc2O0jq6IXi0G/iPGzLFjDHIgm4mVwVQDpB+REX3Tal?=
 =?us-ascii?Q?b+LmroSfCLTBNQQG9Hf3QMmiyNDcKVJqY2pa0OXf7Y2h9Iqe0i4S+TIjp0++?=
 =?us-ascii?Q?dticy10EBxKXXEFFV5CL4fvQ03t4fh7s1XzwIhaToTHJyNENZDKGNvV+djub?=
 =?us-ascii?Q?swi8Jqpqjj3B+h4rrlrkGko90UMYFSr/aZYfN3+mW0wkbbePwzkrCKcLdqBt?=
 =?us-ascii?Q?tEpSuIRb2Vi9ozkDt7JXXlReFD5eIj8oKGOX4KdlwaKhh85aEkHA+vHdn5iF?=
 =?us-ascii?Q?EUIQbUUXPZi6QJlQpPATVRd2htbb6m5mpaNePSDhu6nSfEarIQO7E26Fttdv?=
 =?us-ascii?Q?lmgB4BZBam5cSBg1gtgsvvqOhJmeKX5yv+KR2FP3fAsFRtnMHXhNjRErLEDd?=
 =?us-ascii?Q?7BKoxjA3L8xCv281mLh7TVRhLp0AurK7m5QylP6dn+cR/vUHbIBoyIUEV4Zr?=
 =?us-ascii?Q?Rl4arx5zT45+GkHI7mLtuwtlZ63tPZmYOerbPCOGHp2MgHWg4AjgLm/rI9Mf?=
 =?us-ascii?Q?h8+mJQrRrK60aLK/rsFgmGsee/AT2xs/tdqvNFe68QX1kkVcARlQgdOBuVBu?=
 =?us-ascii?Q?nr7mtIIdt8x1TbwSRoUe9d2w/6HF2PFNUjr2QRVnuFfZQTeYhMYS5ORCJVoO?=
 =?us-ascii?Q?+8C4J4zEPy7GXyoONvXuHTLeBUOc4JObkmO6iICG9mMPq/tk+9aQc/fd6GVl?=
 =?us-ascii?Q?8F/hquuR6lY0poA+oXm3SUc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B312642B89FC6A4F9604BF814B64BC5A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vgtv2094ANLvqEhBmoImvS+iSDI1IjCg/1hTkDqDlaIdwtDXuBPqlYxR5ql95Xv+GWnHuaPzjThE7aHjpDifFrP2auz7AQgczI5ReoFfJzY8zy0+4dKuLwmUMyb8OFKtDAqslSqp7MaUrv+hIXpiGpRGzACL1fT3TmxxXWmR9NvSoMEU1jYIJ51QNJkynbUTV1wvhznbMQXVI0sRYNr5RoNfXohiX+ppJ63tlJt5bgsys9qUXZNvi+hEpDvtqSE6Mdlh5apJORrHS4ZqY/QJLz44Dg/YCTnKWeF+lBy/fNSZtpmTEFzt5y20s5gegE51vSE0t5An7/p8kgi5+RPKBKqFeLbUWkfFbflGoPo6JF0vfcbKSZFt4eVo+wTEuySXpaV9XBlqprJLtezaqkeja9FAwkWxuQIpka7V+eEbkArdbfd/KoQmLfXI28+7XvGL6ep5+in8RCuHGQnxcXix8GRCNUcA4iNyxXhBZ6GASoNPvRzg37d5EMiUpo9BMeXMAJWHrfZB132ijCyvykGBJiK9B2uRnWrTNy0uPWn2M2Yj5BaJP26Fxbq7+V3V9rCd114WRZ56FdsVu6FsRoUQR98C6OL32NM0AEwiveNg8ABDSx7F7SMI/6wm0ymVWQ4GHjntimCs9nTaDNG+74lvQV3Qxd9pRghwUFq8oQWPYYbwnmGa43W/pqmrjrg46lGaY0WX9OOInEiQ2dWTqulcuNB2RUpGV4tHcawwHiF8dFEkO3vzGLudI9p8VZB+jeZo2lQQXlRm61jZYpUaHWt1PKM84iRxNEFuZiITbwENkBMt84YNLfsCKL/CVROf5UXy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef855e33-8a5d-4a13-7d72-08db09913d26
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 04:59:20.3428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 49kzMDbsdRe5LY6YzUJSEkaGUNM3F2CDkTO7mlLad4o89GcTrm/q8c5ULzgsGlvUtXqpTqujT8feydEIvjxMV3WfNeneGznet1MV0n7QH9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8033
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Feb 07, 2023 / 14:06, Niklas Cassel wrote:
> On Tue, Feb 07, 2023 at 03:37:37PM +0900, Shin'ichiro Kawasaki wrote:
> > The valid data bytes accounting is used for zone_reset_threshold option=
.
> > This accounting usage has two issues. The first issue is unexpected
> > zone reset due to different IO ranges. The valid data bytes accounting
> > is done for all IO ranges per device, and shared by all jobs. On the
> > other hand, the zone_reset_threshold option is defined as the ratio to
> > each job's IO range. When a job refers to the accounting value, it
> > includes writes to IO ranges out of the job's IO range. Then zone reset
> > is triggered earlier than expected.
> >=20
> > The second issue is accounting value initialization. The initialization
> > of the accounting field is repeated for each job, then the value
> > initialized by the first job is overwritten by other jobs. This works a=
s
> > expected for single job or multiple jobs with same write range. However=
,
> > when multiple jobs have different write ranges, the overwritten value i=
s
> > wrong except for the last job.
> >=20
> > To ensure that the accounting works as expected for the option, check
> > that write ranges of all jobs are same. If jobs have different write
> > ranges, report it as an error. Initialize the accounting field only onc=
e
> > for the first job. All jobs have same write range, then one time
> > initialization is enough. Update man page to clarify this limitation of
> > the option.
> >=20
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  HOWTO.rst |  3 ++-
> >  fio.1     |  3 ++-
> >  zbd.c     | 22 +++++++++++++++++++---
> >  zbd.h     |  4 ++++
> >  4 files changed, 27 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/HOWTO.rst b/HOWTO.rst
> > index d08f8a18..c71c3949 100644
> > --- a/HOWTO.rst
> > +++ b/HOWTO.rst
> > @@ -1088,7 +1088,8 @@ Target file/device
> >  	A number between zero and one that indicates the ratio of written byt=
es
> >  	to the total size of the zones with write pointers in the IO range. W=
hen
> >  	current ratio is above this ratio, zones are reset periodically as
> > -	:option:`zone_reset_frequency` specifies.
> > +	:option:`zone_reset_frequency` specifies. If there are multiple jobs =
when
> > +	using this option, the IO range for all write jobs shall be the same.
>=20
> nit: perhaps replace "shall be the same" with "has to be the same"

Will replace. I find "has to" is more consitent in the document than "shall=
".

>=20
> > =20
> >  .. option:: zone_reset_frequency=3Dfloat
> > =20
> > diff --git a/fio.1 b/fio.1
> > index 54d2c403..80cd23b5 100644
> > --- a/fio.1
> > +++ b/fio.1
> > @@ -857,7 +857,8 @@ value to be larger than the device reported limit. =
Default: false.
> >  A number between zero and one that indicates the ratio of written byte=
s to the
> >  total size of the zones with write pointers in the IO range. When curr=
ent ratio
> >  is above this ratio, zones are reset periodically as \fBzone_reset_fre=
quency\fR
> > -specifies.
> > +specifies. If there are multiple jobs when using this option, the IO r=
ange for
> > +all write jobs shall be the same.
> >  .TP
> >  .BI zone_reset_frequency \fR=3D\fPfloat
> >  A number between zero and one that indicates how often a zone reset sh=
ould be
> > diff --git a/zbd.c b/zbd.c
> > index 6783acf9..ca6816b9 100644
> > --- a/zbd.c
> > +++ b/zbd.c
> > @@ -1201,10 +1201,26 @@ static uint64_t zbd_set_vdb(struct thread_data =
*td, const struct fio_file *f)
> >  {
> >  	struct fio_zone_info *zb, *ze, *z;
> >  	uint64_t wp_vdb =3D 0;
> > +	struct zoned_block_device_info *zbdi =3D f->zbd_info;
> > =20
> >  	if (!accounting_vdb(td, f))
> >  		return 0;
> > =20
> > +	if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
> > +		if (zbdi->wp_write_min_zone !=3D f->min_zone ||
> > +		    zbdi->wp_write_max_zone !=3D f->max_zone) {
> > +			td_verror(td, EINVAL,
> > +				  "multi-jobs with different write ranges are "
> > +				  "not supported with zone_reset_threshold");
> > +			log_err("multi-jobs with different write ranges are "
> > +				"not supported with zone_reset_threshold\n");
> > +		}
> > +		return 0;
> > +	}
>=20
> This check looks a bit weird.
> What if the first job specifies a f->file_offset and an f->io_size that i=
s
> within the same zone? Then f->min_zone and f->max_zone will have the same=
 value.
>=20
> Which should cause wp_write_min_zone and wp_write_max_zone to have the sa=
me
> value.
>=20
> The check will thus not be performed for the second job, after wp_write_m=
in_zone
> and wp_write_min_zone have been initialized.

Thanks for catching this. In most cases, f->min_zone and f->max_zone have
different values, since f->io_size must be equal to or larger than zone siz=
e.
However, still f->min_zone and f->max_zone can be same when the IO range fi=
ts
within a conventional zone. The commit f952800a0b1a is a reference.

I suggest following 3 more changes below:

1) Before IO range check in zbd_set_vdb(), ensure that the IO range include=
s
   zones with write pointer. This also ensures that f->min_zone and f->max_=
zone
   are different. The code diff will be as follows:

diff --git a/zbd.c b/zbd.c
index a464d6df..f0a0856b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1086,6 +1086,13 @@ static uint64_t zbd_set_vdb(struct thread_data *td, =
const struct fio_file *f)
        if (!accounting_vdb(td, f))
                return 0;

+       /*
+        * Ensure that all zones in the I/O range are not conventional so t=
hat
+        * f->min_zone and f->max_zone have different values.
+        */
+       if (!zbd_is_seq_job(f))
+               return 0;
+
        if (zbdi->wp_write_min_zone !=3D zbdi->wp_write_max_zone) {
                if (zbdi->wp_write_min_zone !=3D f->min_zone ||
                    zbdi->wp_write_max_zone !=3D f->max_zone) {

2) The names of new fields wp_write_min_zone and wp_write_max_zone are not
   accurate, since the IO range may cover both coventional zones and zones
   with write pointers. I will rename them to write_min_zone and write_max_=
zone
   without the wp_ prefix.

3) The 4th patch needs modification also. The description of the
   zone_reset_threshold option should cover the case that IO range has both
   conventional zones and zones with write pointers. It will be like this:

  .BI zone_reset_threshold \fR=3D\fPfloat
  A number between zero and one that indicates the ratio of written bytes i=
n the
  zones with write pointers in the IO range to the size of the IO range.

--=20
Shin'ichiro Kawasaki=
