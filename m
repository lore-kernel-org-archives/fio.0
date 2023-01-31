Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98DEC61DA4
	for <fio@archiver.kernel.org>; Tue, 31 Jan 2023 01:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjAaBiB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaBiA (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 30 Jan 2023 20:38:00 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9309DAD3B
        for <fio@vger.kernel.org>; Mon, 30 Jan 2023 17:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675129079; x=1706665079;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VLXxINozAsJitU5LW0sU8V8QdS0jZ7ZAVQ9w3oTIx/E=;
  b=ZrVpG2+UMnjCkGBkF2VmXETaw2j7AVJhR7R36GYssN3h0hghiW1+AEXP
   9Ku6ZQvhbOEUr0rR41weVUr42Oe3s3RAwgWm53K2g59hTiowGDVxt+Csw
   pnT2IjNyV8EAq+ASMtVzPL2BHbXjYacDAiR4j1PKYimrsqPlBCpuqcW1y
   x8Z6R6bZfGdS3VABMtv1wGgBZPO3RcWBlxm3x5Q1YbpZBerjuzuSC8aX8
   V4VNRNZqkEFZjoNRLhwPocBoc3miQQkfSThktt+ipQNEeN5MZbrBBFeXT
   jxr8222oqi6xptgTXTbvGZL/gavNLbadfcwTsbl4Ee4Ngd8ZjacnYzLZG
   w==;
X-IronPort-AV: E=Sophos;i="5.97,259,1669046400"; 
   d="scan'208";a="221925753"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2023 09:37:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUICZM8eh/FWLVHzsdUnB9bhoPz6YG4ALi1coyi1Y4PMZuWKGh5epvgsC+iR6Vu0ccYS8++Ya4AQYI2/bW7jBsShxFrNIKYdlDB2dX1MYSnpPxoQFWHDA1/AB5VKdP04SnSHwJXMUSLHSFeDCNOnhneOCxh8tvM8RcLf5O/PjCyANrVMYTsxzcJsFV1x0OmDlXcDDLtMpTfamde68UF9Vy2g/kX0XmWubjU0VgZDg1wErf395pwuRNM/ru3IkdoHogYTsKD40YpUPsMGtBnkouh2/gta13VZ3/7qz0GEwV0d+AoSGG94jrf/3fuS/3k5/+ROUhQnOSnv6m99zyYm7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibZ7wd7HPhSjWT3cYY1pmGnnhQr3UdnEUCFaSRLAKWM=;
 b=AmSxt1F7DuzWKgmc3f4wOgRm7VxmR2hxChiakrS6jeww6ucaoTu/7Z3CCsXk1sXh4gK7XJHrkkryl0PoZXQSdfcmhQjGNacOlEvgNhjzMFE2Byv6EYv/hKgh1TxtgfU0GmGQreT5Yqw2jGuJDU2Qvl2tKoxTwjKeyOlUXeCKfd3SLGChee3jBcinuGxkCaqkpjKBRES+YE2VPwJgOH72JnM+hqWKxegTM08gdN965OWNUp83Sy2HMQNgbAoq+9tvwwNfrlwDainq0PTLqf7R5jTa8FW74gIxFmbFdJ7N28Y1UIGG4DMdkemrvpHhPbiXxvHs7D4ppzc0MPkLsKR7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibZ7wd7HPhSjWT3cYY1pmGnnhQr3UdnEUCFaSRLAKWM=;
 b=QEXNzeJe4equRGBX6Gw4Lk6DzmggcO6GHoF1HJs7RgBixNrX3zwxWJLNj97ue+CLEQ3OpFq30iRqHBExAq8wsxjBfjXFxBuhC2EqGMFAvoZsIg+Yvh3ztr/rODVzxJmX7IDw7NiY/8F9/kc92Kt9+zf3w1ZtL1q3mnSP58ccYOE=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MW4PR04MB7266.namprd04.prod.outlook.com (2603:10b6:303:70::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Tue, 31 Jan 2023 01:37:54 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871%8]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 01:37:54 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Thread-Topic: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Thread-Index: AQHZNFKa4Xxew8Afj0yRICK6lH7M+a62xBAAgAD8jwA=
Date:   Tue, 31 Jan 2023 01:37:54 +0000
Message-ID: <20230131013752.24ayrybrt27w2u4w@shindev>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
 <Y9edEqAqMyiqm4tJ@x1-carbon>
In-Reply-To: <Y9edEqAqMyiqm4tJ@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MW4PR04MB7266:EE_
x-ms-office365-filtering-correlation-id: 0e186885-236a-4862-718a-08db032bc614
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m9g+or9HktbuJaLLFltzX+3gjFrtmOCwgiiTbyv2VDt8WOWDaLFkA8rmNPwkK0Yz/2T8zaVXKbOld0p8SRjVsppfbmdP/k32UtPTumemrc3hndSDeElddcTJxgdZrXfD9vpMHEgYFVDu5AnCJswJo4a90StLVxiO7xAibOCJkdL5Fb2Xj3ob5pdRLl4POpSJE0d2LU+KkYZyMziVmF1QHbOg3dOTPycdE2d7BN8okqdy5HJpLlU7wRVrVn3QjSKxga6fpnSxtCCCuS6+Cagm7s5jvNcd/jp/HzSrvw85N3Z3bWSjzQMRhrrmLhMgcMuQsdps6E31jdIpS9RPFLeYInraKKg1Zt+OVRA0VWnty+DXruiMgadanW2RVlqbLE2CJvQyXv3m660WEuT5g77GQarueVHXW2MugaubtYW/H7VcuzuoeJ2AI7EslplgiAK/flSJuG2LKOxwVNfnhMPIDGhgtX83PRW5jQ98WryVnfs2LnQzX0ZalX+qCku2/uhUL+5BhUC7dEakKPT0w9y3Bvpigd4b9oG8UIxZRj/hr8bUMCPZZcNJuBL+mMhS1Hkmj1H3dSAQCKlW4aZzQh1Z3gWOdIDzVEEYM3jMy/nCWknfc0qI6mAnCCuQ14hMaQ1Jn2rMiNaGAtNQK4M0V8mueulKidYIw+G3U+pQha1+0uQ6s0KuAuQsmwyoisGgmYJ+fe7R5vG/ZTY9Ww7eV0IZTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199018)(2906002)(44832011)(86362001)(38070700005)(15650500001)(82960400001)(5660300002)(6862004)(8936002)(41300700001)(4326008)(316002)(6636002)(83380400001)(33716001)(8676002)(64756008)(66556008)(66476007)(76116006)(66446008)(66946007)(91956017)(38100700002)(122000001)(1076003)(186003)(26005)(6512007)(71200400001)(9686003)(6486002)(478600001)(54906003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6YQt875jhXf5u6Lqb+ro2by2zRnP44TH2vJPx9y0u8JoBxKSLJKA7Me9Capo?=
 =?us-ascii?Q?zvADjlaRiK/6t0+rXTfk/GldXTiozMxfeUdCqK7TfNS6918Qu1WEy8YoP1DB?=
 =?us-ascii?Q?HkvIIf/99sYBiDXYIJpFVvPsj/gqfSKIQ0CL4f65t1AwsGQajZ0bs9im6nJp?=
 =?us-ascii?Q?EOr6PB+X8qPmt5685QDk3koi1OIWr5I8953af1ynWWJP88ZshxdG8LGD6XBg?=
 =?us-ascii?Q?TgZzYbNMtuaxW6A1K8elvH9CND6qooG62Mp2mcMtttVMaFqwgPOKosYn25eo?=
 =?us-ascii?Q?eVB2zJTwZxIwaTPOCX5FKVKKcx0wTfW0nhvulNLKurBiPcp+a7Ck29PrkMo5?=
 =?us-ascii?Q?FEG+F9VbN97gia8SdXK6iZLPnttTAp6xG/bIXj5JW7rv3CWR0n/naSTAL5lm?=
 =?us-ascii?Q?kBJ6s/9jTCDA3TPdDV8EQq7vR77BVf8mWVPkUhWBEnfXKq6YS4jzolMUBaiX?=
 =?us-ascii?Q?LjTc1mg23rq0qdcC6HqtqVIy5/y0g4T9tG76JQzUVDorZd84idigW4YHKACX?=
 =?us-ascii?Q?do27eruQ0pYHQYoy4FrCFxelZpvG2w2rHw2DIOJTpUnmzmcs7HYMOqCBu8Nl?=
 =?us-ascii?Q?IWk6fM8s6SbXiGuBhxQ6JVupNmFYUo8A6tyOqyy/UXTqDlZYDP0QiGVCxvrs?=
 =?us-ascii?Q?mhvsIkiXG2cfk5BKMRijxHX6Jil8S7WJMAZViuG/1T8PX8z2NZKxdd0luG5/?=
 =?us-ascii?Q?5UvqppYJwTMXHXdh26wrph1vJCyxiGE5UoYHlvBJZEhGLO+K/TmD8c7wUtGE?=
 =?us-ascii?Q?/zVxl+f3lsJ75gdWu/4/NGCPwZc84GKbR4nRHGAHm9CckOZqYUKUi2fmURaP?=
 =?us-ascii?Q?P5PYFvClJia6FszkaPwaJXTKOe2GwttGCtMgXOBg3hYns0aMh7eWD4MbBnqE?=
 =?us-ascii?Q?MtzOCN4PQVWNePF9SYtwy3B29TTZ0eEv1SkwW00xF/v57v+tkFrJH1wGGEuH?=
 =?us-ascii?Q?5ZIAm8X70woM2J3JSk5ea22mlGkQtb1KDIJI2jXNLKc4xkPWTw935yM5leDD?=
 =?us-ascii?Q?gRcuD80kcWAlqrrRnEKt57Xh3WqOzGAE/QjZheTUjY1mD3nYwT2DyfnRAzEO?=
 =?us-ascii?Q?SfRrv3OTxpcM/QB5C9nlh8wkpq7BbCAAqr0+NH+TM7PPP0+MXBjmL3odb9+f?=
 =?us-ascii?Q?0Wykd9Hf5ZEGv+yJh2jd1bhevbCppW5mShjlIMCxQnZBt96wiuH6rAomXiZh?=
 =?us-ascii?Q?eVucU9SGD0xOoKQx7qpuuoUKwIl0Bs7Z57bmrSqZouZkG8tPjpMdiaAgbfgb?=
 =?us-ascii?Q?9YZIwtGxlqGy2hdmwYOKbDGR61MTinhTUpe80vdtf/Op6kQZ23nIoZaZkxIl?=
 =?us-ascii?Q?2XzSrxsxBT1oAj4VF0cZStgNOly2vWjLdUfoGVhubvbPsSsUFjVCYCPrn9CT?=
 =?us-ascii?Q?fPBMHizJ6jzvEi1q8hZ16rJNnio0fLp981/Ee8b5lV7WRWP7qOqruebsGIYB?=
 =?us-ascii?Q?jTe1bACU+QWl2tlB46R0BHhi1xRk+O9FIeQlcSZ1NuL58fyi1/fTRB7O60T9?=
 =?us-ascii?Q?2KQ7GsrCB64VLzS0ecsIslabrQLXiphkr0pyzunvT2LSX7N8VpjlOscWRPDw?=
 =?us-ascii?Q?w73Yt4zDrOgEh+aOTEHAYMt02IoQLPJjRsdeRFXjXn8BKfXj4iqEuRw6/Hsi?=
 =?us-ascii?Q?Y4veaFyrY7e5SQnyedQumw8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52A19775CB560A4294A930CB941DDE9B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 88WMV9FSWMOZ+5sVgf6hhzBw8daqYsh++zBD9Vw6Jzz7YEYy2+FO/s1rx3Gk3LdZFyo+bsWINYC7+1DlLq7TvXiZ9KnGf1NH+SZYQrSMNePe6077Ttd1iKU/S1oAtdHmLxgZz3e9V6P0rDMvHPOAPfRZQAbVsJUtW3a7zgV1lSrmWU42FNmhuDmosbOJ44ndwtIGgUmT37RgzWeY9JfoaplsY1BB9Rt3nTPGdnx1RUlV0tcK+ncSV421KtgfH3jHadJb9fpZRmBBeJQIPi+e9n3K0+g7OFC492wR6hnO9OM0CVFRC2uTfkTuchiWohIy0RZ6bCozyB6RiH500KnenF+l/8nPkgQ+wwobfpHZ4dOgvgwkWRD0UL78457NS7Svyx3JgN1dy01Y7uBKgJBF/8NNr/AcyNgJZLEJaaEau+Zkq2o2tFBS4/b/5lFn3CaCxy9L9V2xKmLJyDwYgTRqTkS3FXrexipwHjHSG1sVpCJzPgIE/q6AHJ1gAeL3oJUC9uX+hGK7PPCCV23HUZYkvI9HiL0iQnfuM0qCMcGC91M+xHEJD5fGkH/B8FRMwNPOj4A7gpgX942AoS2W2T6HLEkfc844Ql/ApQuYMIQmlRQIC8a4pm2Om8i+GchIw+ADemg7XZGnpq+W2au1Jgt5+JZS75V0DyQ5DQXimVb6flY0i2KYYQ22Wfyf8uUWADFZgJSFq+L8ea7+FI/Xw2h+lXjQnHuIpmOpFhAgpGMmnFfo7+wRWmiC0jsYxqKNx/+t5Sw9W/GTBHsxkv0iaJLffcY2UkeFQe34WqqfMLm2O8Hja276m+Tka0hGIvDu+5jbIyeYdeY/TqX/kFIKRlj/cA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e186885-236a-4862-718a-08db032bc614
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 01:37:54.4607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nc1TMASOJqSy20omvSYgRMjeQMuN24CMjmpGVQvl2+XxQQtyAgJkR5+rwVsI0VScNj4fH/QbgI54mcrgP2843ZjHixzZz0rsvENSEWiJH0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7266
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Jan 30, 2023 / 10:33, Niklas Cassel wrote:
> On Mon, Jan 30, 2023 at 11:28:45AM +0900, Shin'ichiro Kawasaki wrote:
> > When zonemode=3Dzbd is specified, fio does 'sectors with data' accounti=
ng to
> > record the total number of sectors that have been written on a zoned bl=
ock
> > device. This accounting has two issues:
> >=20
> > 1) The current implementation counts sectors with data per job, over th=
e IO
> >    range of the job. So for a workload with multiple jobs with overlapp=
ing IO
> >    ranges, the number of sectors with data is overestimated as written =
sectors
> >    common to multiple jobs are counted multiple times.
> >=20
> > 2) Counting the total number of written sectors requires taking the zon=
e lock of
> >    all zones in a job IO range. For a multi-job workload with overlappi=
ng IO
> >    ranges, this often leads to significant zone lock contention, result=
ing in
> >    some jobs starting doing IOs only after other jobs have completed th=
eir work
> >    (which looks like an apparent deadlock on startup).
> >=20
> > This series addresses the issues by dropping the 'sectors with data' ac=
counting.
> > The accounting is used only for two features: 1) randrw first IO direct=
ion
> > decision and 2) zone_reset_threshold ratio check. The first two patches=
 modify
> > these two features to not rely on the 'sectors with data' accounting. T=
he third
> > patch drops the 'sectors with data' accounting. The last two patches ad=
just test
> > cases and an fio example script for the zone_reset_threshold.
>=20
> Hello Shin'ichiro,

Hi Niklas, thanks for the comments. I have to admit that your points are va=
lid.
I'm not sure know how often the option is used.

>=20
> I understand when using multiple jobs with overlapping IO ranges,
> the number of sectors with data was overestimated.
> However, patch 5/5 contains a single job.
>=20
> My expectation for this fio test file is thus that the
> zone_reset_threshold should stay the same.
>=20
> I understand that you might not like the definition of the current option=
.
> But can you just change the definition so that it is unambiguous?
>=20
> (Regardless if you change the definition to be per job, or per device,
> a test case with only one job should be able to keep the same value
> as before in the test case.)
>=20
>=20
>=20
> I understand that you change the way that the accounting works, but
> I don't think that we should just totally change the definition of an
> existing option just because we think it should have been defined in
> another way.
>=20
> Can't you:
> -Change the accounting
> -Clarify the definition of the option, but keep it like it is,
>  regardless if it causes zone lock contention or not.

In case we would keep the current definition (accounting per job), still we=
 can
avoid the wrong accounting and the zone lock contention by checking write r=
ange
overlap. If the option is specified together with multiple jobs with overla=
pping
write ranges, fio can error out so that users can know that the option does=
 not
work as expected. However, I am reluctant to take this approach since its u=
se
cases are limited (no write range overlap) and it adds 8 bytes to the struc=
t
fio_file only for the option.

> -Implement a new option that might be more optimal, and does not
>  cause zone lock contention?

This sounds good to me. The new option name can be zone_reset_threshold_per=
_dev.

> -Potentially deprecate or remove the old zone_reset_threshold option.

Yes, if we introduce the new option, I prefer to remove the old option.

>=20
>=20
> I guess my biggest problem is that users might use this option,
> and when upgrading fio, that option will silently behave totally
> different.
>=20
> If we remove the option, the user will get an error that the option
> does no longer exist, which is good, because then they will understand
> that they need to update their fio job/config files.
>=20
> TL;DR:
> Basically, I would prefer to rename the option instead of silently
> changing its meaning. (Because users might not notice.)
>=20
>=20
> Kind regards,
> Niklas

--=20
Shin'ichiro Kawasaki=
