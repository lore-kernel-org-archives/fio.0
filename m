Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72347C7EE25
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 05:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbjFHFuD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 01:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbjFHFt4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 01:49:56 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A572697
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 22:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686203394; x=1717739394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lDDckomDEMPIH5WtSg6QeoK9woQkCglIBZHK5h7t3qY=;
  b=h7phX/cunYC0UhiDVTGizfZGEhmfNMrVMGqR8LWaZJRQbgiI5/GqCmVx
   GjDzhobsBxJsHqeaTSW+A/6M3SQ3WFv0s2wsq6JpHjWxhVasrP5c7oxjE
   F/5ivdMNi8ebEKUkltlMATYs0le0xmcrZ2TVv2UgN9waeUzEKQwbEr4aP
   JrhJKCzjScZYvX54LylUdYjWHgdmuoHwpQXt7r/Ohg+rExSJrDjdmJcrM
   TiVPtKAlYqPDxa8Bh9H8X9sA2RMaHytTbjZe6jnKbjH1cXurdSf7xDLWM
   LAgVQ0FiUgOlN88BzxWmD//vpNgKsznOKeGSwjn2shOAm+UwiCIv23pr6
   g==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="337622491"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 13:49:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1XG0WJG4rUy67Eia10qSTq543itqhBWjXnCAr06i+700sGbgbVad1NIaUf4XVDDm4eokAgPPgzBEZqnty8A3hBMhIljrTezBOibGXrjltgiFroZ42zF3vznlOmaO14btgLK5a1WUwaojyhOce+EQOPFhwxhhdOHMh3RPkoTcSn6aSnVRyZ8yAFmA3kAp7Ovg3l+M8kPKTAFVpMxHAKVTrw54iAUD78ufQLH8HZpQAHiowx7mziuKCk/v7Wyg4AIm1Ih6lJF2tSIYi3XCG7Kr1O8aWDVJuT6JGVzsIgB/ZvJfeE+Yg66IZKszcsI+NZ9hVk32sIu9TCQMEsptG4/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYr4cLoWMCK7+M/UvhHD4jbcQdYDdSqcUWjBaUUi3Ag=;
 b=JsMyP3TuLjJBDpGRgn5MZP0ZIK+PNmH9adjOY2T3qTvoQJfZxNMjm/bc02uahNWsogCxr8Ifvp7RyraYj8kSiCf3UsGgWPXlXbOrEx1RHK/sKNtT+53EV+yxAPiDXhL0/oV6gsFc9b0kCVXDVd+7U58Vh/7A6ksFvUrezAE8CgYFkvF4WII3EuiIn1WDeKTo57H8gtScUFbQRdQq6IUkvY4gM6QtKIKNYFHdnhF9CyXOI+3Ll6Owy0vTLZis1OOgJ3GyDrE8y9LHorpOm6JgPE+EN9nU86/8xQz64AWmMrTGZqc7QhE4Es8kqSf9egKl+vaxO7bCZvZZN1x+IQ2ugw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYr4cLoWMCK7+M/UvhHD4jbcQdYDdSqcUWjBaUUi3Ag=;
 b=C7UZ0JFRuu+RHFVIDda/BWLBNHxA4rMUPOqaPIv/6WLB45nrQ0PB28U5Mm4pQ+3yX3SdzcN/WnKfM25stX8mkeCM+gOGEsgzVkRtO3kpSkszFPQOx85XdVCovsCdw/Up+FlTSJs3BRUBYjupqn0r+XXf2kMfhRhkBxEeW2gl3Hk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB7505.namprd04.prod.outlook.com (2603:10b6:303:a1::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.41; Thu, 8 Jun 2023 05:49:52 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%3]) with mapi id 15.20.6455.028; Thu, 8 Jun 2023
 05:49:52 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Topic: [PATCH 4/7] zbd: fix write zone accounting of trim workload
Thread-Index: AQHZmRqjh+TR46K7pEqo8aItrb/3l69/eEcAgADvmYA=
Date:   Thu, 8 Jun 2023 05:49:52 +0000
Message-ID: <k3sj5wuwfv3o6ssokxw4hx5m7mjdaoe7wmm64h6orsy6mbv6wu@aeimnr4bov5s>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
 <ea7317bd-46fd-6165-f652-8b47ad7e9853@kernel.dk>
In-Reply-To: <ea7317bd-46fd-6165-f652-8b47ad7e9853@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB7505:EE_
x-ms-office365-filtering-correlation-id: 2e517fae-86b4-4911-df53-08db67e42deb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bulpsKCMxKovxGsnEE+rq6NSWmYzr4wF7+Z+pxniVhw6S3xe6RD32TwGQaKdZMUixi+0b8gyRruFFVoYM2jxNY8OGqhkDoMYg/1q7HJ1P4KsqlbE7x98WtLd0zw0upHjKqc4CMLmuJZtDRMC+fwT9DLhZ0jOhzDeTtUG/heJdiDdtzYtPKXG6uyipyyUsppPreNWjMVy0+aejzLW9Gx0rK0uEDMvnRimjTpEmrkRmHsgiSYSuQjgbP0/POhwFdrApKkfJ/VAzhSjSkIFPecVX7lrRGHalV1sBD5rf+Z8cN4MdwaKhV1W8rMVnSRECDMIY3ppN/flJ48oqsqWZO9YQoiGdPh2oTmlYy+yNgZJa0qCTA19sZwKXZx4RASKBgYOGvCAxnOsRHPj8rHvZSGCRqFzUSGoR0gSQDd9ziIu5lqpLAdyOeFmMhR0nvUpx2w35r21vhjnQLwv2v+mazsKLMsLJzvqrz/7C4KHDDXnSWAXmEF6kXKuixSBinWtANUWlwrlrryRl5JZhAfOqGM4krJAsf03Rkuo0dpH7/YQ5+3pnA0G5hqqqcpfZDUiOrnbfZ5UCM3D41+FQ6Ff8oEd7e6k1p4GFBXU5fqD+JrfMWC26U5RUNf02m97s4enZFLD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(38070700005)(2906002)(86362001)(33716001)(44832011)(5660300002)(83380400001)(71200400001)(6486002)(186003)(9686003)(6512007)(6506007)(26005)(478600001)(122000001)(82960400001)(54906003)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(6916009)(4326008)(316002)(38100700002)(41300700001)(91956017)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0U+6mxnKKJ2dZNYavKk5buyqpDAuR6/ZyCR/RngETvZmxERmmTKXTsqbAPGw?=
 =?us-ascii?Q?c+DkCn1vs1Dytgw/wMWEfchAbh1vHDNFCNEq+d+P4TIkA2Dw55tZYgNNHUZ3?=
 =?us-ascii?Q?Ry79G9Z4uLiTgK/JLYxS9r8nyouvRKE7M0LZyUIRzPPOg7Zu3h0EsjhlBl+F?=
 =?us-ascii?Q?CFfDRGvtgAvuiTXt4EVTND4FrRuBUgGSS3IoQTndaLU4BAKhzyS2a9gAUHjk?=
 =?us-ascii?Q?8W4YT56R9YCPK2gVHYkh7pPe7PTAGyZHjS+1Wu0V+J2ogRX88au3MKZ+ygOa?=
 =?us-ascii?Q?1s9EfWjbelGmbcDmAFxtFbvZ+QKFl2bViE7ScSUIwd4rIcmHh9JsvLFxIkGL?=
 =?us-ascii?Q?BBuHny0w65Fcyc47h+pggZ97oHmvNt0H1L9P2S2r2yCxgMZ8Jewof1WJdDUn?=
 =?us-ascii?Q?y9sOzyuSQoQ/gCim9KXnKmBZH6WAlsvwFXYCGh2JD3Y6rpVxeLZ2CMpXSsAU?=
 =?us-ascii?Q?YHDPyS7JOvSINL16ChU2Sy0WD4BxXY7Zq57Da84112CF96bWLytf8fNsf1xS?=
 =?us-ascii?Q?S2pL4wLWN1xWY8ig0eZZUjvifS85PA3xHyHXGClVGSnXIKKjdoHWPBMYXorO?=
 =?us-ascii?Q?gJzqqS0ZUXUL9GiYsnjZ1USd5o7ukLiWcs4ond/nvJHt2ym7DWRbenG3vjo0?=
 =?us-ascii?Q?4oMDgQ41RGZL+I0ZqU6G0F3/u2Ky5ofEGY8BWdou2Xklsr/MNCf3XT+WZ+7+?=
 =?us-ascii?Q?XN8dn8qYJF+Uy9I8eBE0CJzuw4tU6p8iFD3R5GyPIAfDt5ZbjNdxPM7mFbGN?=
 =?us-ascii?Q?1bI+BgfUEGdzvw+jUpG4OCqlOZaO5eVej8MLXn/CbWCG5sAY5s823ypNIKeB?=
 =?us-ascii?Q?YMmRNMxU1TXuVDdsNb6evCJUj13x/P0wcjOYqApKRfNKu2dyfb2cKS9kgzAS?=
 =?us-ascii?Q?zdVYni+4stYL2IFONbRgrNaXFmeGijkmpn+pU2cs5f5zhrZirdmj2yJnNWNV?=
 =?us-ascii?Q?gsrbOvxTzh5J0QcVkWPkIqlOVGzrRZi49925rOVFDSunm7taBHjYw9haVRZJ?=
 =?us-ascii?Q?Sbh+TIsi9G4OLepEblOaQAPMnHM1mariCD9UvSBAew3uNWg97wYxC3+Ivagk?=
 =?us-ascii?Q?Aros/y4KZUtET4zAeKP0WWWVF19zu7byPdFL6PsV7xLt5frR92koJHDOYpzL?=
 =?us-ascii?Q?nXdFZ0c8haFGd2p9kBhRwbXkh99jh9zF1/e5OUmLY5LTLjJ40ZFF9aSmT9Fk?=
 =?us-ascii?Q?1VeK0zw2uTRa3pmOwsrvbpBo45RtT+YjpeeRGlJX07LM5KL10dPzAZmOuT7W?=
 =?us-ascii?Q?HqiSO7by3F89PWf523FFvuwfB06fpOE9s5C3IQ+wri+13JTC0x/XEEtnNzyB?=
 =?us-ascii?Q?/IHeOd3+PIjDCq0bVVNpS8nN91J2OMyh8ps5ujBAVmj0e8/aMuEPmo5Qu+Y1?=
 =?us-ascii?Q?GHzR4MkKUkyHji+gIwWFegNj8yXz1LWck6Bj4ivNuE6G9aqAX94VW5fZfoWB?=
 =?us-ascii?Q?xbcU+uzKEuH2zmBWB2+RsPnWbwjhzCZs+SQEU4Tlx41Bb4ToC7AngIsPCQjV?=
 =?us-ascii?Q?s20k+4m62ufdl88n0FFYKGkXqbTx8DwfzA3T+zF/9jad5q0J5lNu44Ix+IZp?=
 =?us-ascii?Q?Ag0icjIMttTKBrBqGwdhYPTEg+GjxR7j80jX7CW2T9f19vdaKhYr+LZpPVNc?=
 =?us-ascii?Q?3Jf+NmH0DA3h1+owIqLCQx8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <95D59E1684579F4592E4CF1BE7266502@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nKAi1mp1RM/Er9uaYeyGSaidKdLyt6stQcS2df4V5IUAe+7cfoyBZKBP8EFSVDxFnoIw2YMNZzGT3Z/jQiJWyLof7sSgh2U0Yp/EGgnoatwJkJ3Hsr4nnTpWMwl5TksoRe0fbkZ5B9c+skdNeaFO8pOlp3JfrQ2uMreJjoOn7BWVjDfq26kVKyWECeooDULTFRxx1O2oeoe5ds1TLZ54wtO+Sdkug/QdAmrgTV95NDN5lYqwXGzXya7dVvtoYJVJCXk5BOPp+iKVO0hItgPf4bSAR0Oz+7mfAJNBlxaLJTw+ivLZR3SSR1mm5UmBfHvwu/JRxLREJaRh0K4OlWR0YNV0mSqxlSQWEXKVs/cqJtNcNurM6JN+/GflutX/U5MkirhOYE2lcZUIRFPh4CBiQoF5M2o6vgkl0yu2U5V9Cr+WxQMjYNDIUtn/0Ao60J4ZOF2LkItIEFLXmNo4unMfyrhc2RxBMFryzOTjWOPLAyfrnqtFxZLLPYswyTjjEUaXZXj/nJ/uL6CPuqw0i52ljjpCVoWiqN4MbLbMHaZT/YSnXhDTAXS5rypQDrK6FnKIICCjT5Zc6lM3zaEeMEQ0armJyktnRu5NTuQh+LoL//xn35ISHppZtmkhJM0sHJzMTOMLsI9f2uSZ/UoNyqn1Q8yE5tqJkjT35usyMFmz8rGqpTU06REoHyMYg/eFW975hLTKPIrQmn2h+PmYKTRQEvvIGaxL3gSLpEkmmiAaftPFqsMdn5W9qDkBVIiljLGQCFR4VSdHudc2N1tbBrCzQ7rHhoGa+CdijWMThvjB/YMSBXu3uB2Hgqzqt+AuSm3ehbyXA9hCl8EJBf0XOL09BPGuk73GZ7cg/yg9nn+LBSc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e517fae-86b4-4911-df53-08db67e42deb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 05:49:52.3285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tkVcLh+PNtmeamlRZJsTFSppiN5RSMEVJypW1pMvNy7FJiIzacxT5C8vGHKogggVmB+QQ8cAht3Uh5UejqS2/07GEg/fCN7vLCv9PMqY15Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7505
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jun 07, 2023 / 09:32, Jens Axboe wrote:
> On 6/7/23 2:32?AM, Shin'ichiro Kawasaki wrote:
> > @@ -339,6 +339,33 @@ static void zbd_write_zone_put(struct thread_data =
*td, const struct fio_file *f,
> >  	z->write =3D 0;
> >  }
> > =20
> > +/**
> > + * zbd_reset_zone - reset the write pointer of a single zone and remov=
e the zone
> > + *                  from the array of write zones.
> > + * @td: FIO thread data.
> > + * @f: FIO file associated with the disk for which to reset a write po=
inter.
> > + * @z: Zone to reset.
> > + *
> > + * Returns 0 upon success and a negative error code upon failure.
> > + * The caller must hold z->mutex.
> > + */
> > +static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> > +			  struct fio_zone_info *z)
> > +{
> > +	int ret;
> > +
> > +	ret =3D __zbd_reset_zone(td, f, z);
> > +	if (ret)
> > +		goto done;
> > +
> > +	pthread_mutex_lock(&f->zbd_info->mutex);
> > +	zbd_write_zone_put(td, f, z);
> > +	pthread_mutex_unlock(&f->zbd_info->mutex);
> > +
> > +done:
> > +	return ret;
> > +}
>=20
> This would look better as:
>=20
> {
> 	int ret;
>=20
> 	ret =3D __zbd_reset_zone(td, f, z);
> 	if (ret)
> 		return ret;
>=20
> 	pthread_mutex_lock(&f->zbd_info->mutex);
> 	zbd_write_zone_put(td, f, z);
> 	pthread_mutex_unlock(&f->zbd_info->mutex);
> 	return 0;
> }
>=20
> to avoid that goto. Goto only makes sense if there's common cleanup to
> do for multiple error cases, not for a single failure where you can just
> return the error.

Thanks for the comment. Will reflect in v2.=
