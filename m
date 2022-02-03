Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EB6C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiBCTaq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:30:46 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62008 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiBCTap (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:30:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916645; x=1675452645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GdZjTZtO9d0GVIEQ9K2hubQ7ll5SmYZol8NcPicMqd8=;
  b=GdF1Y0rBk3myqPQHVdoG5eqiL52TMowa9mJwT7mPO/OrLGkoOj1fTZAF
   SynwLf+BwlfaCGSrrdTqlZNA4lhMIfIHbi5QBW/vE6jhj6+eFuxMI0jX0
   FYj4yxUEDQsgq1nqDsruYmwZ2iyCir5HMLZRwhHz6AuAX8O02xEqZnWY1
   pXLmxEyU1u+KnfOfKQgsEH9hoxTOaUPrQUVvhU+Bq3z9DByZ0QyIfNs95
   fpDd4ZgYFUwLf0gaWs5sVKkQRB0ryHHnoLiu5h1W8+Ch91IBvebRqNBvo
   YLyaerBHJYuiKeoSxxPogvVLvuxoUPLePzsPYGcSMT/Y1VjnY9bwkMdFm
   A==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="191044231"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:26:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ux0Q6Wssw15myEQ8TkNaVi6dNM0ZRIOzg+p3n5TO/wRdF5CBb+Bdq5zU6bTAjGQgqOuh6ydCenX2a6vdq/WMVfwlv8naMB/EJpUVutGfo99N6Yd5s1e6dCfCDgGPcEa4hbe33BH94l9FMsIlRr3/+tqqLH2MMH/EjBkmXimbuRloppKcw3FGychKOmD7YwGRK5KYj5Bxmxb0ZrqD4xhdzPgHx9TamHhxRuKlhsd3YBAKvrZYWwIxFQPDdqVTUw/8XGV5EkpCYlh8vaCKN/ZNPTXBkIJM6Y9do466gLDD9lgKOI4wgDBlbRbJ+mHat7i8qm9nr+GepuVf5KLxaYlsLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbPfe0PqhsperBYOIPcD2muE/SA94+nN7z128gMqYdw=;
 b=FxLvKGq6evQwfiZUN1HvZN3+fb5TAZVbGs8EZrkY57sSDQJiCVVdxYVM3HD9ipmmpLNH7Vxawt8QJNPAhyP3KE0zWQCoi1fMWHRW9i2i7naM4qSStMiDx/1vik4YaMpblOsVWTp41ig8aIx0CSuCRw/H49zleDC0Hj+9Ys2qoyg2c8cnDIoXfIoV3KjCG/gKEOxus6YkaKrPQoe6eU5R5FTp6E6nArzgeODolRMJrVJ/CmkY0j5BljQhaH7Ake6GIuHJ9yXOeI9fmGAqN5qKG9C3X1+5oh6pfSvsLuawJX3KrVVFVB972a5JPxlBmjY25lWD0U0P2AhA+iCBhnrn7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbPfe0PqhsperBYOIPcD2muE/SA94+nN7z128gMqYdw=;
 b=f5FfMBKK+vGBvRbcUZUExuvjA8q3PyaVL9g7UZbZhlM8TJHWxbKAt3JgxrKm4y5tieiN6CojraOfxlI9eX63Zt0Z0NU43PEGRoM7XbHiGpbDPBYlxZKHeX+86ApzaGB36rRU4HezyzVNHAzuC5WHXMlJXyHhj0EyhwYai9tRzLc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:26:48 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:26:48 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: [PATCH 13/17] stat: report clat stats on a per priority
 granularity
Thread-Topic: [PATCH 13/17] stat: report clat stats on a per priority
 granularity
Thread-Index: AQHYFudYiJbGY/MhekmLWS9nC29ZG6yBEFYAgAEp04A=
Date:   Thu, 3 Feb 2022 19:26:48 +0000
Message-ID: <Yfwsd/zVIQ0+jWnR@x1-carbon>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-14-Niklas.Cassel@wdc.com>
 <e55b1794-b693-617b-960e-4e737ccc9dff@opensource.wdc.com>
In-Reply-To: <e55b1794-b693-617b-960e-4e737ccc9dff@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 424c173c-6b0f-49b3-2108-08d9e74b1f50
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4632A6D8D8944B89D0436BE8F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:462;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tLKVvgYr4SBiugxYqQBXzSudPjJQoqu0Ag4fCZj8yuG8WmXgWaT88XzNO1qERL6SgSiW/yrt0LZg11l4D1z/iLj/lscP3F02XQQJMmzNVS7nX5UlRcCm1H0dL+enxjVsr9LakTSMlb8+RXqBKD0HouMI329DNJAUvhGcMq2oxRGKjJ70lEVt2u3P76XhcGC8viWj6HkQReao6AAqKAGjp7hUPJFiX32GRqewYF9rHu/eBU49Hny0n7DZTtduhrwTGu5sDNCAEe8EQgh7APUehrYP6OYz7xmTEcJlJQNAYZfKjrOVPVtTU8FKVjz1CHxHThZ96wcfv2woEPcCQ/b/7tXWWvBhAixwmtxTojQNAROxdNo0Rg5B5Rq+JFQola+hssrUIwn+ms0r7E7ihiJrXM80ynPhmjnKlWZv+TMuayOMoKRWwRsIBg5UEDORPkLetm4x+a/joS3nl+7cu4A7J6uc1k94a9v09bohGZ7jg2p6GzPZ5JK/Q9uQLdhfawVlQYCg28pdqTg8m3rMUDmZruvKGZ+0LEWQ7k3/t27l67f9P99Bx6uu2mv8Q1ZWYbDuWtsR9dsKW+2BnRL0Pk5zHzry8s+69BaREqu/huqXdYgBKV9E79V/ZVYOVzr7jtDwPI3BONUcKREm9BGA0NfGDBIDeu+rGc9EuXAfql9Cfg/+k8vqtUx82zXwA6Fs3dlrSJrtpgzFSXMoJmKpwvlXhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(54906003)(2906002)(76116006)(91956017)(71200400001)(6862004)(6506007)(66556008)(186003)(9686003)(508600001)(4326008)(86362001)(66446008)(5660300002)(8936002)(6486002)(53546011)(66476007)(38100700002)(38070700005)(66946007)(122000001)(33716001)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kPzUlo9m/cpxKgYJu16BGG+SsCN/PI8Vt4uZ6eWAUdVkby4XpbdqHhkVn7Ff?=
 =?us-ascii?Q?yaOkEjiO2sSaTXCswPOhgHW0jdyKn4/UvDDU1glKw8hqdyLCuF70L1G6ol/+?=
 =?us-ascii?Q?RfifehyEyXJO5OHbp+T149jjWFiJwe1UHpFY71son92luLs4zYd9wrl1nUIA?=
 =?us-ascii?Q?WOCUpNNO3yKu9Ytv4DBBvwKSEp/5fJweWzZjXizuHH4hPv0S6zmjXkEuJFRa?=
 =?us-ascii?Q?ZwyZEn4/4r5VD/4xQNHr/gNCWtPMvOhQCu3sE8BwD9vtOmYqiUH3d5IJqavM?=
 =?us-ascii?Q?hWRGqA63CV4JtBsQOs7WigX8FI4T5pgDBGLy7vA+7KeYcWI1XGpV+IOzQK3E?=
 =?us-ascii?Q?oAj0mMthmsuwZi0F1DYjN6Q/+eJpbjX3gaHmykCj6pKd3hF9W0WDtk+sLqgt?=
 =?us-ascii?Q?2y2FLOrLqqxCPISGx0DId5RJXoz5XdqwOQcExwdzlD7VzUt6iE0Z/4u/JPJ0?=
 =?us-ascii?Q?ZJJwyiW2qmOHaTNybKDJKvZ5taGX/eIZHueDemQdc/ZX81eX7FqX80xm5OMn?=
 =?us-ascii?Q?NNaEZUKHNJqW31PhMCeAazWNLWIBoLQ4mavpJh5Fq3YXGktpaC5eYupfP6tX?=
 =?us-ascii?Q?lhnrFRLKuuLTkcpagPKSWHPyIidw8/p2v9GkZWZB8TBzoS68Go7q9ybHYLmZ?=
 =?us-ascii?Q?l20AKBu2zOheIUSjYubO1M/avRahwh1em1SABKnE77NveN7fFVL5yr6UCfCS?=
 =?us-ascii?Q?+LumqTHyBwfpcSdoI9vkLybB0MLq7cqn02WXd4t7jsixU3LWRmLqFJtpPLSG?=
 =?us-ascii?Q?aqlXkx7I7RC0hEwkm77TvlXUyU+nPcY9sYyHJQztIJIYmLZf5ncDciG6/5gb?=
 =?us-ascii?Q?dRIK/ESgTNFdvFatcSfS85mR2t/YI8W8UtvOHZ4CGnwjeUuUXmiUJKaE7f8i?=
 =?us-ascii?Q?wpr3ySChtiUa4YEPrK1vauIl7JKCyt1R+gNRYJG3xbCo0N3RfL+KJCR8oRJ/?=
 =?us-ascii?Q?BsinlZOiLPsBSEaF31xrInBtbwLXHZrBnVmP9SrxKq2qIKVJoJgYOMxQRbLX?=
 =?us-ascii?Q?dm5ofYn5cDQS+YdJq1epAF+E8zBJU4+c989vCJNBD0aEvcHT+N350Rh4NG+w?=
 =?us-ascii?Q?xNPVH+piVpjf10jdUgq//GR4gcRcE8YU2hNzH8+aQX+75/d9ToianguK5aza?=
 =?us-ascii?Q?mfwpPzVzX/jn/6kZH5gw8OdV2ZbJFbJ8mmMXBrdLyWROKJVnIe5KwcB++1yp?=
 =?us-ascii?Q?J8B4DJotp2HB9uFsdDkNa9K4rjW4Pm37PGNrKsGWsYV9awdKqJFw+1V4Z4fs?=
 =?us-ascii?Q?gKDFL2OGCJcy+wbHPU/WLUPxbcYyOj/RpPoOOArFgz4H6R0V9haTJondxRsP?=
 =?us-ascii?Q?+B4Wu0R7ErmR9aWFtIkzOoDqicOLqB0wuqlfeipfmp3ZQK5oGlh13TA+aGLL?=
 =?us-ascii?Q?lxhQkHtVHUeuq4XVOD8IM0MjF/9WeyvUSjUkaXChCcJfCF4MeLLcmj5O/3P3?=
 =?us-ascii?Q?Ko56U1mcpF681tcLCeM3wOngngloVI5AokAYrYwqAIGiID8aoLRysbRRruBx?=
 =?us-ascii?Q?O8TsYm0v5VGiLnG0QN4OgEoOpYTRHLtkw0reYkZGdy9K58e1EiNIa4km6pZL?=
 =?us-ascii?Q?XtvRNen10Fv4m3bIvKhzGiYqQleRTbOVpmAyvueEHd10Teup8t7bzQJ+CUJX?=
 =?us-ascii?Q?lMxZqTFjl6xSseMKvW+88Wc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9FB2394496E07D42B6ED17EE101AEF5B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 424c173c-6b0f-49b3-2108-08d9e74b1f50
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:26:48.1825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5L3/he4KTdhJllC0WJn/6G1D2DohKXCIk9JFmHxo3JXMesk2ayVLIzUJI8/6NYQbuiiagOWGzdsdqTVym2/TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 03, 2022 at 10:40:50AM +0900, Damien Le Moal wrote:
> On 2/1/22 06:13, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > Convert the stat code to report clat stats on a per priority granularit=
y,
> > rather than simply supporting high/low priority.
> >=20
> > This is made possible by using the new clat_prio_stat array (per ddir),
> > together with the clat_prio_stat index which is saved in each io_u.
> >=20
> > The per priority samples are only printed when there are samples for mo=
re
> > than one priority in the clat_prio_stat array. If there are only sample=
s
> > for one priority, that means that all I/Os where submitted using the sa=
me
> > priority, so no need to print.
> >=20
> > For example, running the following fio command:
> > fio --name=3Dtest --filename=3D/dev/sdc --direct=3D1 --runtime=3D60 --r=
w=3Drandread \
> >     --ioengine=3Dio_uring --ioscheduler=3Dmq-deadline --iodepth=3D32 --=
bs=3D32k \
> >     --prioclass=3D2 --prio=3D7 --cmdprio_bssplit=3D32k/20/3/0:32k/10/1/=
4
> >=20
> > Now results in the following output:
> > test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D465655: Tue Feb  1 02:24=
:47 2022
> >   read: IOPS=3D146, BW=3D4695KiB/s (4808kB/s)(276MiB/60239msec)
> >     slat (usec): min=3D18, max=3D335, avg=3D62.87, stdev=3D22.59
> >     clat (msec): min=3D2, max=3D2135, avg=3D217.97, stdev=3D287.26
> >      lat (msec): min=3D2, max=3D2135, avg=3D218.03, stdev=3D287.26
> >     clat prio 2/7 (msec): min=3D3, max=3D606, avg=3D106.57, stdev=3D86.=
64
> >     clat prio 3/0 (msec): min=3D10, max=3D2135, avg=3D664.94, stdev=3D3=
39.42
> >     clat prio 1/4 (msec): min=3D2, max=3D300, avg=3D52.29, stdev=3D42.5=
2
> >     clat percentiles (msec):
> >      |  1.00th=3D[    8],  5.00th=3D[   14], 10.00th=3D[   19], 20.00th=
=3D[   33],
> >      | 30.00th=3D[   52], 40.00th=3D[   77], 50.00th=3D[  108], 60.00th=
=3D[  144],
> >      | 70.00th=3D[  192], 80.00th=3D[  300], 90.00th=3D[  684], 95.00th=
=3D[  911],
> >      | 99.00th=3D[ 1234], 99.50th=3D[ 1318], 99.90th=3D[ 1687], 99.95th=
=3D[ 1770],
> >      | 99.99th=3D[ 2140]
> >     clat prio 2/7 (69.25% of IOs) percentiles (msec):
> >      |  1.00th=3D[    7],  5.00th=3D[   13], 10.00th=3D[   17], 20.00th=
=3D[   28],
> >      | 30.00th=3D[   44], 40.00th=3D[   64], 50.00th=3D[   85], 60.00th=
=3D[  111],
> >      | 70.00th=3D[  140], 80.00th=3D[  174], 90.00th=3D[  226], 95.00th=
=3D[  279],
> >      | 99.00th=3D[  368], 99.50th=3D[  418], 99.90th=3D[  502], 99.95th=
=3D[  567],
> >      | 99.99th=3D[  609]
> >     clat prio 3/0 (20.91% of IOs) percentiles (msec):
> >      |  1.00th=3D[   44],  5.00th=3D[  138], 10.00th=3D[  205], 20.00th=
=3D[  347],
> >      | 30.00th=3D[  464], 40.00th=3D[  558], 50.00th=3D[  659], 60.00th=
=3D[  760],
> >      | 70.00th=3D[  860], 80.00th=3D[  961], 90.00th=3D[ 1099], 95.00th=
=3D[ 1217],
> >      | 99.00th=3D[ 1485], 99.50th=3D[ 1687], 99.90th=3D[ 1871], 99.95th=
=3D[ 2140],
> >      | 99.99th=3D[ 2140]
> >     clat prio 1/4 (9.84% of IOs) percentiles (msec):
> >      |  1.00th=3D[    7],  5.00th=3D[   10], 10.00th=3D[   13], 20.00th=
=3D[   18],
> >      | 30.00th=3D[   24], 40.00th=3D[   30], 50.00th=3D[   39], 60.00th=
=3D[   51],
> >      | 70.00th=3D[   63], 80.00th=3D[   84], 90.00th=3D[  114], 95.00th=
=3D[  136],
> >      | 99.00th=3D[  188], 99.50th=3D[  197], 99.90th=3D[  300], 99.95th=
=3D[  300],
> >      | 99.99th=3D[  300]
> >    bw (  KiB/s): min=3D 3456, max=3D 5888, per=3D100.00%, avg=3D4697.60=
, stdev=3D472.38, samples=3D120
> >    iops        : min=3D  108, max=3D  184, avg=3D146.80, stdev=3D14.76,=
 samples=3D120
> >   lat (msec)   : 4=3D0.11%, 10=3D2.57%, 20=3D8.67%, 50=3D18.21%, 100=3D=
18.34%
> >   lat (msec)   : 250=3D28.87%, 500=3D9.41%, 750=3D5.22%, 1000=3D5.09%, =
2000=3D3.50%
> >   lat (msec)   : >=3D2000=3D0.01%
> >   cpu          : usr=3D0.16%, sys=3D0.97%, ctx=3D17715, majf=3D0, minf=
=3D262
> >   IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.2%, 32=
=3D99.6%, >=3D64=3D0.0%
> >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
> >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
> >      issued rwts: total=3D8839,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
> >      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
32
>=20
> Nice !

> > @@ -2517,6 +2694,13 @@ void __show_run_stats(void)
> > =20
> >  	log_info_flush();
> >  	free(runstats);
> > +
> > +	/* free arrays allocated by sum_thread_stats(), if any */
> > +	for (i =3D 0; i < nr_ts; i++) {
> > +		ts =3D &threadstats[i];
> > +		if (!ts->disable_prio_stat)
> > +			free_clat_prio_stats(ts);
>=20
> If disable_prio_stat is true, there will be no array to free so
> free_clat_prio_stats() will do nothing, no ? You could call
> free_clat_prio_stats() unconditionally to simplify.

Yes, free_clat_prio_stats() handles NULL, just like regular free().

I added the extra verbosity on purpose, to highlight the fact that this
allocation wasn't unconditionally performed for each struct thread_stat.

However, on second thought, it probably confuses more than it clarifies,
so I will remove it in V2.


Kind regards,
Niklas=
