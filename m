Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC68BC433F5
	for <fio@archiver.kernel.org>; Wed, 17 Nov 2021 09:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EED46321A
	for <fio@archiver.kernel.org>; Wed, 17 Nov 2021 09:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhKQJ34 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 17 Nov 2021 04:29:56 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:46655 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbhKQJ3W (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Nov 2021 04:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637141184; x=1668677184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VjqIW/xjIsyQsB1HWoudLZdGdQwqiKkmyaX6NMvVopI=;
  b=LfX1Mj2T1C5BbzSyQZ3BW61IvwLqvjD9vbrOl2qaJUgaEvBjnGZeZFkt
   n4vOsgv7w5XisV0vlsreus+7F57qAIIzswti4iiQerFkiqyGB2u51sa9J
   kdUwod0A2I1NBfj0Ol/wrHrbGq+pxTWJl7hr9/WUL3ut8JO7IH08Dk3Kv
   Unh8EoihI4yW35CNmaYX9niw8Jn/gRdXkeLWvih1K6DBi7zIIbLYV191u
   UQYtAG+zB6CtKRN9BjwNeX5TG/e2lsL1de88sRB0S+76UtwJWEprbUNPV
   YDM4rsrAd+S/zZ/tQ7bjHrZLv7AgEiTpwtjZIImd4UWUb76PW2fpVtSSn
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,241,1631548800"; 
   d="scan'208";a="186825786"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 17 Nov 2021 17:26:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oe1SrxDlGZEzlPuKIzeEJEz2FLAeQmc6vf9BLoRD0dGDn7DoSpZxlnplsPT7W6VRNgVKy4003KNO6FJ3yP6Qxb0V+LloXuO1jDC6XGrBXs8bLhYs1UJnzgdY4iQojhB1pIYx/92I3zT6gtlx4Jb2ncUWntiWdLSILVW1cmprGGOgeWxcugwsxJbgJd+0ZK3KkQoiE0J4ufPPFTvXhTtQE+v3zCbHqH2MnzcT4jwMiRb1p7Wncxm/eKWy+yJmOWUm/pTSTdpBJWpggWMJEfAwz29hZx8MtZk2ToQAMkjTs38I3/KYiwzczzLUjCoP7F520hOsRAhUdtsYfnrSQ2rfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/bGapt8p3/f3z6Lwncj3VJw+U2vElZx+LhGXFvGGZU=;
 b=a5reMC70FsX2pBEptkuMeOGFRBoVCf0PCGwtrc43ZczchZLh6Px75c72W2dgpSLZODdTze8YdOjf99ehJ7rUpj8M5InkA8qcVPwVOZO8VwcKbagSbYkV1Z2e0G9lsC8oVmWCPVLu1tu3RKviDPpbgQ7ojYRX2GAtDpEhHEPorIYpDwUuJQx36QQ3TAWhLfufEM0pnBCYOmis35O06jq8ehISvUSbC7ZBfbVblWKtxi+VamBEcgR1scbVyZwm6FvK5JVjHoDLPnC9/wDWtnsY9Sv19JHXK7jV/HX9PyuxlJ9HEMj60az0xIb6ErplYyhY2KUvBUXjXCw50rkZma/KVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/bGapt8p3/f3z6Lwncj3VJw+U2vElZx+LhGXFvGGZU=;
 b=K8C6uJmQ8KEbzlnjN1XQk5XYy+G8HyUMRK6+t6HYdq1zGNQ+KYgubHLAWUkG6ykYc9oDxN2gkCgGuI/gjW18b7vSsqefkQDifhpHN+1CqarSa7Cog97J+IMWRYtB8a5jTzUMDclbaprOqdPapNiaG+v6KuYWQLUcNaut4kRFrPQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7238.namprd04.prod.outlook.com (2603:10b6:510:8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Wed, 17 Nov
 2021 09:26:18 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.020; Wed, 17 Nov 2021
 09:26:17 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fio: Introduce the log_entries option
Thread-Topic: [PATCH] fio: Introduce the log_entries option
Thread-Index: AQHX23/oV5gO3cMQTk2l56JiA+MXkqwHc1cA
Date:   Wed, 17 Nov 2021 09:26:17 +0000
Message-ID: <YZTKuKTinY5LF9uL@x1-carbon>
References: <20211117065213.124658-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211117065213.124658-1-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 073eda77-06b5-4cd5-d014-08d9a9ac4f53
x-ms-traffictypediagnostic: PH0PR04MB7238:
x-microsoft-antispam-prvs: <PH0PR04MB7238C9A71DBF466008E85F63F29A9@PH0PR04MB7238.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3NGXU3ZEZLfLKmWmKPWYJjwdDHWkC73F0rDL34nI0DmhnUggTE3zH8vFNN1oxhGKpF4YYCteahvyMlbJ/yFiDKpNvlGx9SVTOFKS39/Cs5iYMd//rD2VEBtcNtnI63VbfxNKMg95EZAlktobEHF+hNOqCfwRPNfKqY6gUNE2HPZckReF+/5OPZH8bt8Ft76IeYUCmUrW2nXCSyJsyeW8/6Gnl0W919cRnxnOErA5Q9O7nJjcMZuRaRfOSixcPky23VaHBM7rqeCdD21zAVjtAW+Wa3U9kVs8QpA3t/N90XjPMJw1/5e+sqFD7f3l4Ho3xP7yIlQa0eqBuDLQXTwpKTzlNmgdsP3wAnHAeRx1haO4acIvdReyRVSTlcnr3z+BSJZynPj4U3SWL/XB8pKGtgTRLiszm/LWfcPvCTzld5hskfk1XjMPr8AVLPOsUorb8rcgVODHjfrAM083ZsBnzAz080k7Z9p3YX6QBk7ZuP7/WZsFwhnLaKQ/g56YCpGYIk/vXyvEmckq2m9FQox9l7gyVg6aCowUiQrBEtcSKZmE/Q4DrVUBBtQPeEn5bjcG01NGqy9yqxJWV6wzg12bdNaUsrDuRP3IPqkzvPWUj9vSUgHDLo06K2KxoUwlOTW4W6U7JTBrGWul/Kf5hmtDAMKJDHhV8EK0dx26tHv52jAw96Zswr43vjm7+F8fhF3j8OQRuQHJ2Fwz77mLquPVVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(316002)(54906003)(5660300002)(38100700002)(6486002)(76116006)(71200400001)(66946007)(91956017)(6862004)(66446008)(64756008)(66476007)(66556008)(9686003)(6512007)(2906002)(6506007)(8936002)(186003)(83380400001)(38070700005)(82960400001)(33716001)(86362001)(26005)(4326008)(8676002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZlLWNctMAalniooq3MPL5cbtUiUF7hbnQyc5Z1cbze1fItFqlFOuCpYj9y?=
 =?iso-8859-1?Q?WsfAC3z1KDWkafU9G5Csg8za0FcTpT5yuRDYFSH26QjTlj2daK6qF+JWD4?=
 =?iso-8859-1?Q?rslRsm6NpGNBzta4HR7qTIsKaTJfVXOQyifzI1OyMgrJY05Ssmdc11gARI?=
 =?iso-8859-1?Q?vFyLH1jg5Qi86ygLilOhLkSObXaJn8S33arw3FWCU349kqxtvSPAfbuoyE?=
 =?iso-8859-1?Q?xXuGr9CbHuQNE5OBL3Kwz5Ug+/jg80IxEjGszeU69TD/D8BS7ZHoFK+SzJ?=
 =?iso-8859-1?Q?LO+neia3KL72a1Wjop31Nnj3uPOiEJ3UZ0kNgshpO0YEvgknF7sx+Z6244?=
 =?iso-8859-1?Q?IY7cLxtBL2RnatoV/Qjc8iPW/FqwIS73cLSZGOkPOBFMsfUIPWVOdcubNQ?=
 =?iso-8859-1?Q?OM3ycIZ9DA3y1nF2FoQqrG3wkAhI6/njQtH3xsQKUznnlgj3oYyqCx2lH4?=
 =?iso-8859-1?Q?bwkjyIvBO2IbduxSrOwGHIeJF878PijNYVK+VWspJTBsFQ0oJ6Mfismc9N?=
 =?iso-8859-1?Q?ESNJYy5hvygX60GpLvmGa9bavN+c7mRrihakgkTJ/6vWepLKCLVM7P1sWl?=
 =?iso-8859-1?Q?booT/vM6rnCFd2JUVGcPAZPT0PJp7cwc5dtYuJWqiRcXXmDU8gE1eq8I8/?=
 =?iso-8859-1?Q?01cT0fK8s7VxNYSXb98oCs7GVCb3kmAzvE764Zz4n53AnKI2cHtkkj4MGd?=
 =?iso-8859-1?Q?q3lMwoH+1HujflxAcsERLS8f4YUCHH73KUSi73rPJfUKZpkSr3mtq0wKJx?=
 =?iso-8859-1?Q?mymZIrEJ+EnghWSjsvCewNqT2IhQK2RQQ/0ho0T/s+QlPTZkR1NF1ukOfc?=
 =?iso-8859-1?Q?llnXcArllD8so62pziedREXFvFXT1xyj9GAiM0cePb4AB5+7QmpZTIwTWh?=
 =?iso-8859-1?Q?8iu/lZDN+7uSe/V/N3bL4PSeHRETcj3XAFg21V2g1MFl82jpMF1OwXAj10?=
 =?iso-8859-1?Q?C4k24FXAmZhhkEFzD2B29a5tz6NvvKRW4xbSJM8z9wZqeU8bbXjARv67ph?=
 =?iso-8859-1?Q?nkMytM7l0ndXZb1c162uG3bv5n3jIowBQzJQH6NX0vaD01g4u+GcnNETVq?=
 =?iso-8859-1?Q?OmasCmFtMLglMCp3O+0DyazMu4KWYQpyKuJksfK4enmWH7NO0N52cQf4A6?=
 =?iso-8859-1?Q?0DQUwG7TlOuvnld1ymkiW7H9FhTHxK+EGUk6QJQdx0y3LSUxRYMWu7Q9Aa?=
 =?iso-8859-1?Q?kfMk+vLd+uhUIqF+Q1Bxwt/9W/KK5z/VhzjJriTBY7x2HtQuY/bNV+uAZh?=
 =?iso-8859-1?Q?qb9Od+XdEhdZk/vQi1Y/4pfACzFcGciQro6EKsmuzX31AoyRiLxoWCA9Cw?=
 =?iso-8859-1?Q?s6JcpOO0mwtXSICl4Lzrz14Lsmsh4IyjfcMsO2R0rPsZW4Tw4VFaFvVKin?=
 =?iso-8859-1?Q?DiFOK9m6wJbioG4Uj3YEkDfImEMg31kefA0W1jQLogpeP3mZ8lzNt54Tkh?=
 =?iso-8859-1?Q?w2ecB9EwLe8i23rwQjhMKk75HJCJ05GhkBsPzoJJkdIxM5BPBhL67wsEqK?=
 =?iso-8859-1?Q?rQplqkabZLMCzO1dod1M3XJ4VrhYfT4c2OGaaF9+zfbJQcfPR7+bX+Tx3Q?=
 =?iso-8859-1?Q?jLGcNlEowoLrg+EKqj317TN6Tqn06hl7ILyd/uUhPocPWVqLCz76Sj1gVQ?=
 =?iso-8859-1?Q?WM7Is0syOR9t6ZNiufAZRfV8AfHeDwIALLbHIPJnMoAUNBAUPCIkk7G+W0?=
 =?iso-8859-1?Q?K5RF/nC+zC8pCLXG4Pg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <B04292DA264D1048BD2E580B33781907@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073eda77-06b5-4cd5-d014-08d9a9ac4f53
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 09:26:17.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2lt5wEDpGYSuEgTbQHg+/NSmMOAh76WcEs21h6nhsQ0CXo/29IalTCpDqblWgNkb+Z9Wq59mHkKlYqb6plIdPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7238
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Nov 17, 2021 at 03:52:13PM +0900, Damien Le Moal wrote:
> When iops, latency, or bw logging options are used, fio will by default
> log information for any I/O that completes. The initial number of I/O
> log entries is 1024, as defined by (DEF_LOG_ENTRIES). When all log
> entries are used, new log entries are dynamically allocated by
> get_new_log(). This dynamic log entry allocation can negatively impact
> time-related statistics such as the I/O tail latencies (e.g. 99.9
> percentile completion latency) as growing the logs causes a temporary
> I/O stall (IO quiesce), which disturbs the workload steady state. The
> effect of this is especially noticeable with workloads using IO
> priorities: the tail latencies of high priority I/Os increase if the
> IO log needs to be grown.
>=20
> For example, running the following fio command on a SATA disk
> supporting NCQ priority:
>=20
> fio --name=3Dprio-randread --filename=3D/dev/sdg \
>     --random_generator=3Dtausworthe64 --ioscheduler=3Dnone \
>     --write_lat_log=3Drandread.log --log_prio=3D1 --rw=3Drandread --bs=3D=
128k \
>     --ioengine=3Dlibaio --iodepth=3D32 --direct=3D1 --cmdprio_class=3D1 =
=A5

Nit: s/=A5/\

Republic credits?
Republic credits are no good out here. I need something more real.
(For the Star Wars fans out there..)


>     --cmdprio_percentage=3D30 --runtime=3D900
>=20
> (128KB random read workload at QD=3D32 and 30% of commands issued with a
> high priority), with an inital number of log entries equal to the
> default of 1024, depending on the machine memory state, the completion
> latency statistics may show imprecise percentiles such as shown below.
>=20
> high prio (30.75%) clat percentiles (msec):
>  |  1.00th=3D[   14],  5.00th=3D[   17], 10.00th=3D[   20], 20.00th=3D[  =
 23],
>  | 30.00th=3D[   27], 40.00th=3D[   32], 50.00th=3D[   40], 60.00th=3D[  =
 53],
>  | 70.00th=3D[   71], 80.00th=3D[  104], 90.00th=3D[  169], 95.00th=3D[  =
243],
>  | 99.00th=3D[  514], 99.50th=3D[  676], 99.90th=3D[ 1485], 99.95th=3D[ 1=
502],
>  | 99.99th=3D[ 1552]
> low prio (69.25%) clat percentiles (msec):
>  |  1.00th=3D[   16],  5.00th=3D[   24], 10.00th=3D[   37], 20.00th=3D[  =
 68],
>  | 30.00th=3D[  105], 40.00th=3D[  146], 50.00th=3D[  199], 60.00th=3D[  =
255],
>  | 70.00th=3D[  330], 80.00th=3D[  439], 90.00th=3D[  592], 95.00th=3D[  =
718],
>  | 99.00th=3D[  885], 99.50th=3D[  986], 99.90th=3D[ 1469], 99.95th=3D[ 1=
536],
>  | 99.99th=3D[ 1586]
>=20
> All completion latency percentiles above the 99.90th percentile are
> similar for the high and low priority commands, which is not consistent
> with the drive expected execution of prioritized read commands.
>=20
> To solve this issue and get more precise latency statistics, this patch
> introduces the new "log_entries" option to allow specifying a larger
> initial number of IO log entries to avoid run-time allocation.
> This option value defaults to DEF_LOG_ENTRIES and its maximum value is
> MAX_LOG_ENTRIES to be consistent with get_new_log() allocation. Also
> simplify get_new_log() by using calloc() instead of malloc, thus
> removing the need for the local variable new_size.
>=20
> Adding the "--log_entries=3D65536" option to the previous command line
> example, the completion latency results obtained are more stable:
>=20
> high prio (30.72%) clat percentiles (msec):
>  |  1.00th=3D[   15],  5.00th=3D[   17], 10.00th=3D[   19], 20.00th=3D[  =
 22],
>  | 30.00th=3D[   24], 40.00th=3D[   27], 50.00th=3D[   32], 60.00th=3D[  =
 36],
>  | 70.00th=3D[   46], 80.00th=3D[   57], 90.00th=3D[   81], 95.00th=3D[  =
105],
>  | 99.00th=3D[  161], 99.50th=3D[  188], 99.90th=3D[  271], 99.95th=3D[  =
275],
>  | 99.99th=3D[  363]
> low prio (69.28%) clat percentiles (msec):
>  |  1.00th=3D[   16],  5.00th=3D[   27], 10.00th=3D[   43], 20.00th=3D[  =
 80],
>  | 30.00th=3D[  123], 40.00th=3D[  176], 50.00th=3D[  236], 60.00th=3D[  =
313],
>  | 70.00th=3D[  401], 80.00th=3D[  506], 90.00th=3D[  634], 95.00th=3D[  =
718],
>  | 99.00th=3D[  844], 99.50th=3D[  885], 99.90th=3D[  953], 99.95th=3D[  =
995],
>  | 99.99th=3D[ 1053]
>=20
> All completion percentiles clearly now show shorter latencies for high
> priority commands, as expected. The 99.99th percentile for low prirotiy

Nit: s/prirotiy/priority


> commands is also improved compared to the previous case as the
> measurements are not impacted by the log dynamic allocation.
>=20
> Suggested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Side note:
Would it perhaps be wise, in addition to this patch,
to also increase the DEF_LOG_ENTRIES value slightly?
The default value is 1024, and sizeof(struct io_sample_offset) =3D=3D 40,
regrow_logs() seems (at maximum) regrow 6 different logs (slat, clat,
clat_hist_log, lat_log, bw_log, iops_log).
The default space used for a single log =3D=3D 40 * 1024 =3D 40 KB,
if someone has enabled all 6 different logs/log types =3D 40 KB * 6 =3D 240=
 KB
per thread_data.

While it would be hard to figure out a new default, e.g. bumping it to 3276=
8
would mean 40 * 32768 =3D 1.26 MB, if all 6 logs are enabled =3D 7.5 MB per
struct thread_data. Sure, someone can have thousands of threads, but I doub=
t
that you would have logging enabled for all those threads.
If you have logging enabled, the most common case is probably to have slat,
clat and lat logs, which means 3 different logs:
1.26 MB * 3 =3D 3.76 MB per struct thread_data, however, this dynamic memor=
y
allocation will only be done if you have explicitly enabled any of the log
files in the first place.

TL;DR: I think that we can merge this patch AND increase the default number
of log entries to e.g. 32768. (Or if we want to be quite conservative,
perhaps only bump it to something like 16384, which would only be less than
2 MB per struct thread_data if 3 different log files are enabled.)



For this patch, except for two small nits in the commit message:

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
