Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B537AC433EF
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351180AbiAaVNU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:20 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:15180 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351179AbiAaVNK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663590; x=1675199590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XqVMGuNYhpn2F74qlLteEas4gGno92BnLL+GY1c9cDA=;
  b=abgQ2ADYSr8GojXjPGjVSPL5pWiS0OngdvcWBPIjx/oQXEEGlSGIva4y
   Wjmmh/KrWpXJa9phdyRGz1xVwEK/eHRD7leKKsiPRhqXiBqkRDVqb4YU+
   W/+WJdJYDWf4GrnLwXvwWWwyC6t72TaqSC9X9F9NMIM/BcfJd4R4E11Tc
   dJUjTWF7m1oDfZB4lvkMMgVAAmW8pxFiL/i3llWDMpGhn87bIkcLqSmJC
   M7vhD4biX2dHCcOHzpgdYaMSFFA0DL75YderpkUpYqSvb0zDPG01YE3Pj
   C0sjX2sQ/uzZh4BrLuWkJSCaRJYKK76krrLZJXTLK2M+oFvRCguP6yRLa
   w==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="303720265"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaPJxgRWbYuwZRiU7D4PD5ijSirPmaXVZgW/lYPEpsc7uVuyRI3HuUeYpg3FmfoYDONm1mmFkyJvNzJ27uF/tCY/2uK4yOwsVmOkw84/JnWsCgeJFmG0lK8P1PgaM4VbtH1tuikxg9C56BhZLoltRWktO8Yj5wX8sLwDOeywS3RUlnRrwRivjh+ZI0mj5NBjXM3gFmt7JGtoivY/gh4gLqYkhlFhGaGKxZbQK09YD1m64jRmSCqgIL52p3Vo+KYuIzgO35Y8YOiLizF/Z0vgpkETpt4hX9W7NmiH7Vng4zT/41N7hiI2xY8zJ0U8+U+UmG4+EJYlXKzKf+3E9wUYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okqFZJzZe6ooZr1Yavvd0NjC7EN8WpUcrNewtrywCDw=;
 b=Y3DCI8Rd5JqxS60z/9QLIK3q+q+snzEfYh88jfAqUnMc4LMjXMnOeLop2GqT/AyULt5lStKa2LdpjTLl6sUQ7r3PY4znZqzMKG8dyFpohm5qD/kmPg+4nvbdRSqAeQmIjK872i2NwyqoOAnuh6y5b90EgUrEvVNr2LUmnk8H0t2w+znar/sRrOKuh1Rk1/NnRWeBe8JQgomu4NxLnFfmXY6dLqW+JdvucAx9HoI8ZGyV2yZFpJK3Hz4Oa/dLfP3B1pJp8JE40gVnIg/+IIR1/hRkw6ODMqvJpyDQ23P6iTDukJQe5mlrBUgGWv5RvoRk/7JVcqSb9h6/b+w5ut6vTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okqFZJzZe6ooZr1Yavvd0NjC7EN8WpUcrNewtrywCDw=;
 b=JC/DVStXl9FUa53vzfLRaTA6q9Ayn8ZvdjRO6PyhGb7IwzHUpX0Je8D2VIjY4UatDh6o7U8tcMgSrF6YAMTqSnVlfoOLEqfdVeYWZzXEZGninAXhr3e3ExrtfcrPT1d4c39u8sf7LrPzeexgrQQDDYbqkE8qveLlJFSnipAn/5M=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Mon, 31 Jan
 2022 21:13:09 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:08 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 13/17] stat: report clat stats on a per priority granularity
Thread-Topic: [PATCH 13/17] stat: report clat stats on a per priority
 granularity
Thread-Index: AQHYFudYiJbGY/MhekmLWS9nC29ZGw==
Date:   Mon, 31 Jan 2022 21:13:08 +0000
Message-ID: <20220131211249.106820-14-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42a8189d-920a-4e34-9db2-08d9e4fe7b39
x-ms-traffictypediagnostic: PH0PR04MB7576:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7576F461E85A079028338326F2259@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5aO9cYaPYld4J4eR12UZlg6p1+Tht1ZI4GAw9evuaWS2mLkvV9myUAPpwgKtbORHMJFzbaIk7RjXNjiLJaYrZ25Fev7cxwUZS3Y5EIWrv6QOymB0lAwdUvSZrRxYeGRNk8HbQNiCfzQ6ZmJGY/0fFp0DWeX1d5hgzy3CxLmcFzOsR8CGGr4MpTCYvjRSsc70QVUxwNxJmn6BEnGUoaVXNvTmrdJufiQ0ELLW4VAWjA+JYvJfEPdWWooQSLGA7//9T0kFxQHvChZtgTOGuwBc+BpejnPNU893A2B2s93mBAUEBigs7KKXtpCSjJkeUsf/dFUY8U3W8v+swzuCEzDJn1A5bnP6n4P6ZF3bjNjGEzw625Y9T/pAX6erqhNaq6Two0xxUxow+d03QKBZzsQqrBk2swwj9Ao6DUG8O42bLxIYJtgpTCdV0xIeJFqiM9uTYY1xotCJRAbsak6Owk9gD3VhDF1Eib1u5DE7mee/2NRKFAPVTgpHTOSINpgjI2wrKovMkDJhcF3XTdWGqkm8Atdz1/OWvrZE+bwZejIU8NQtCiaRlXFmkfVVScUCP/LEIY+n3zbAecLNOflJsToVDk6jaADWsREelSaAJRwyc6f6MZfL1fxcxe/bHupvpCgzWozeQe/BhIhZnJ4YTbGa8ML0vShv1eMN0E33vO40Ff9/N7WSzyRYKb/9P2oXYFkdzlpPVrVN3ZSuvL3+gJIZDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(30864003)(1076003)(26005)(82960400001)(122000001)(186003)(38070700005)(83380400001)(66946007)(76116006)(38100700002)(36756003)(6506007)(316002)(71200400001)(86362001)(4326008)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(91956017)(6512007)(508600001)(6486002)(54906003)(6916009)(5660300002)(579004)(559001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rNBcA13w+IHqZHonDXxTdD8yr+wzWi6X98tC3J/qxUZ2ZyrXx/ubt4Q/gt?=
 =?iso-8859-1?Q?ipCuzejfA0UArHt3w/iu6dx2S4VaTG4LUeHyHXAwV81TVVaWTHyyLwfp5J?=
 =?iso-8859-1?Q?GigZxc7tdU4xIvDASxUQq3UgSnsMDRvkajC34wqL/oj7KzV2p7DiczbhTO?=
 =?iso-8859-1?Q?MkrTCtm2v3GzDkKI7YWVI5KeeZpOM/XzsmhFiQUenzNqdHSptozmHgtk3Y?=
 =?iso-8859-1?Q?J2aGTMkefdilVoSeWpX29ekncdsZgTnLwK/olu6T65+EVAn7BdDPYmxFmb?=
 =?iso-8859-1?Q?bFw3ea361T7EH2w68xqHX/aGsKT5sXmVHe2yccGhh0R2gMzkp0R9bWuozy?=
 =?iso-8859-1?Q?iT17nUyoH+mn8q8n5U54A/rkW9/1Ab5pcYad6/SudHOt3qjRQ+cPO9ss/l?=
 =?iso-8859-1?Q?JuSxxaSevor6WRo4+H3fQv2UnsdWC6ag+FFAySCdSLuQescR2e8kYd5zS6?=
 =?iso-8859-1?Q?DtfV1qNBxIr75MWJr5RvSTP7En970bMZM76+5KrL5i8nZ5lhgLlnjkesnK?=
 =?iso-8859-1?Q?recfvpKPGM9iwovE2drdaF2AzSsYuX7bFeYDDETi2CiSOPLU8PeEj1xufz?=
 =?iso-8859-1?Q?NzznK/JjTKQhqIIkWV10j1VpmJemWR4ZznYE/5YDkTKMy5nJm88hYB3Xn1?=
 =?iso-8859-1?Q?OenxrFq++acCLpiebhH0lGBvDOacdElRHsYu/h46Ym1n4Jv8v0TK2aSBxn?=
 =?iso-8859-1?Q?GU5+QXODV019V1yRWyQTDHbtugoLAtDDbSJWpJf0UP3Wp/8yDOtbsvUncC?=
 =?iso-8859-1?Q?rHjGuvVdgQYs2xLRGnh6c0r1COde13HEltVPx+gPZD802LV52X133WsKnn?=
 =?iso-8859-1?Q?rDrcLu0nO2y9h1Vp5CUVhk9C0TwnAGARqfrXO/fM8OKMaxNKgipe4kmZKt?=
 =?iso-8859-1?Q?OcwLhfHlQhd6xSnOgl51F4KEBl6uHkMRrpiDKkFyB66g4F0xS1OlI35Bvh?=
 =?iso-8859-1?Q?djGwv+A6aX0le/NpwdSdZsWoUSltGzAniDoeWFMTtlirySqD4NgsxAEDDR?=
 =?iso-8859-1?Q?GpbW2TBJV+BS0YYSdH563XdRU5/7ocIAtELcmQaFwCBPyqpoK7ZNj94Kap?=
 =?iso-8859-1?Q?/Q4GWRKWJjy+enuQQsvzrw8dclH+Q67ySEXzWdQF/3nhJil4V0d1PZe2Hl?=
 =?iso-8859-1?Q?W+sU/iUDyE3p/oKKXoyVIm+2gMQHIHNNWZk66Abc82240kxSwGPIB6Lwq8?=
 =?iso-8859-1?Q?NxnrMmErlgLC/hFASTIgdwo+E9O1lDr4XcBBdPHSsGkXOWGkI2TBUQei1q?=
 =?iso-8859-1?Q?SQC9j+8rYu0KsakXGIEDg1LZdSDj4rh3IqKA74HE+gEPsYmhMr/yi33OBt?=
 =?iso-8859-1?Q?DHecp+AxrZA/FJJiaEHHdJYb8uil7b1l3LN0WSR9x9hk7Q8AWxOpKcXbj6?=
 =?iso-8859-1?Q?zoDJHD6F1DBubGLqI3ih/DpxFtCbQc/l1RHai7JGTdM0TJ4Of7eOC0pHcm?=
 =?iso-8859-1?Q?18zuVcuiS16LLsfQYjfekmpknxuzrjuCYhWt/K6d9ikxfdv8JEMzxuQoav?=
 =?iso-8859-1?Q?vbwkYT/crBySshfXp6DyqxQUsnhP+79RDolqYeujac4lpbsAm/SpUNgGvz?=
 =?iso-8859-1?Q?yPnVzBbp5K7PM0Audr7yIQ38JQPppjDXIyJPgNFibxIXP38KqwH0rAMN4m?=
 =?iso-8859-1?Q?/b+gZFDZfRNpGQkOpw+ay9GSu1tN0ziWJQcZDQPI3ytZ2j0yHrbZQLPyAb?=
 =?iso-8859-1?Q?+zK8g6qcmTJp6a1qkwNNl9eXlRwh3U+jqnQl4ORF?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a8189d-920a-4e34-9db2-08d9e4fe7b39
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:08.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfXUzlFYs0KvIBrGbpykF+I10nRmrcgykEFo0AWeQcTY7NV81X57WkF44de6QNGNu9S7308pcOSj2/UL2Dcxqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Convert the stat code to report clat stats on a per priority granularity,
rather than simply supporting high/low priority.

This is made possible by using the new clat_prio_stat array (per ddir),
together with the clat_prio_stat index which is saved in each io_u.

The per priority samples are only printed when there are samples for more
than one priority in the clat_prio_stat array. If there are only samples
for one priority, that means that all I/Os where submitted using the same
priority, so no need to print.

For example, running the following fio command:
fio --name=3Dtest --filename=3D/dev/sdc --direct=3D1 --runtime=3D60 --rw=3D=
randread \
    --ioengine=3Dio_uring --ioscheduler=3Dmq-deadline --iodepth=3D32 --bs=
=3D32k \
    --prioclass=3D2 --prio=3D7 --cmdprio_bssplit=3D32k/20/3/0:32k/10/1/4

Now results in the following output:
test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D465655: Tue Feb  1 02:24:47 =
2022
  read: IOPS=3D146, BW=3D4695KiB/s (4808kB/s)(276MiB/60239msec)
    slat (usec): min=3D18, max=3D335, avg=3D62.87, stdev=3D22.59
    clat (msec): min=3D2, max=3D2135, avg=3D217.97, stdev=3D287.26
     lat (msec): min=3D2, max=3D2135, avg=3D218.03, stdev=3D287.26
    clat prio 2/7 (msec): min=3D3, max=3D606, avg=3D106.57, stdev=3D86.64
    clat prio 3/0 (msec): min=3D10, max=3D2135, avg=3D664.94, stdev=3D339.4=
2
    clat prio 1/4 (msec): min=3D2, max=3D300, avg=3D52.29, stdev=3D42.52
    clat percentiles (msec):
     |  1.00th=3D[    8],  5.00th=3D[   14], 10.00th=3D[   19], 20.00th=3D[=
   33],
     | 30.00th=3D[   52], 40.00th=3D[   77], 50.00th=3D[  108], 60.00th=3D[=
  144],
     | 70.00th=3D[  192], 80.00th=3D[  300], 90.00th=3D[  684], 95.00th=3D[=
  911],
     | 99.00th=3D[ 1234], 99.50th=3D[ 1318], 99.90th=3D[ 1687], 99.95th=3D[=
 1770],
     | 99.99th=3D[ 2140]
    clat prio 2/7 (69.25% of IOs) percentiles (msec):
     |  1.00th=3D[    7],  5.00th=3D[   13], 10.00th=3D[   17], 20.00th=3D[=
   28],
     | 30.00th=3D[   44], 40.00th=3D[   64], 50.00th=3D[   85], 60.00th=3D[=
  111],
     | 70.00th=3D[  140], 80.00th=3D[  174], 90.00th=3D[  226], 95.00th=3D[=
  279],
     | 99.00th=3D[  368], 99.50th=3D[  418], 99.90th=3D[  502], 99.95th=3D[=
  567],
     | 99.99th=3D[  609]
    clat prio 3/0 (20.91% of IOs) percentiles (msec):
     |  1.00th=3D[   44],  5.00th=3D[  138], 10.00th=3D[  205], 20.00th=3D[=
  347],
     | 30.00th=3D[  464], 40.00th=3D[  558], 50.00th=3D[  659], 60.00th=3D[=
  760],
     | 70.00th=3D[  860], 80.00th=3D[  961], 90.00th=3D[ 1099], 95.00th=3D[=
 1217],
     | 99.00th=3D[ 1485], 99.50th=3D[ 1687], 99.90th=3D[ 1871], 99.95th=3D[=
 2140],
     | 99.99th=3D[ 2140]
    clat prio 1/4 (9.84% of IOs) percentiles (msec):
     |  1.00th=3D[    7],  5.00th=3D[   10], 10.00th=3D[   13], 20.00th=3D[=
   18],
     | 30.00th=3D[   24], 40.00th=3D[   30], 50.00th=3D[   39], 60.00th=3D[=
   51],
     | 70.00th=3D[   63], 80.00th=3D[   84], 90.00th=3D[  114], 95.00th=3D[=
  136],
     | 99.00th=3D[  188], 99.50th=3D[  197], 99.90th=3D[  300], 99.95th=3D[=
  300],
     | 99.99th=3D[  300]
   bw (  KiB/s): min=3D 3456, max=3D 5888, per=3D100.00%, avg=3D4697.60, st=
dev=3D472.38, samples=3D120
   iops        : min=3D  108, max=3D  184, avg=3D146.80, stdev=3D14.76, sam=
ples=3D120
  lat (msec)   : 4=3D0.11%, 10=3D2.57%, 20=3D8.67%, 50=3D18.21%, 100=3D18.3=
4%
  lat (msec)   : 250=3D28.87%, 500=3D9.41%, 750=3D5.22%, 1000=3D5.09%, 2000=
=3D3.50%
  lat (msec)   : >=3D2000=3D0.01%
  cpu          : usr=3D0.16%, sys=3D0.97%, ctx=3D17715, majf=3D0, minf=3D26=
2
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.2%, 32=3D99=
.6%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D8839,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D32

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 client.c             |  31 +++-
 engines/filecreate.c |   2 +-
 engines/filedelete.c |   2 +-
 engines/filestat.c   |   2 +-
 io_u.c               |   6 +-
 io_u.h               |   2 -
 server.c             |  41 ++++-
 server.h             |   2 +-
 stat.c               | 353 +++++++++++++++++++++++++++++++++----------
 stat.h               |   4 +-
 10 files changed, 341 insertions(+), 104 deletions(-)

diff --git a/client.c b/client.c
index e5f6cfa7..61c6b930 100644
--- a/client.c
+++ b/client.c
@@ -1037,14 +1037,6 @@ static void convert_ts(struct thread_stat *dst, stru=
ct thread_stat *src)
 	dst->nr_block_infos	=3D le64_to_cpu(src->nr_block_infos);
 	for (i =3D 0; i < dst->nr_block_infos; i++)
 		dst->block_infos[i] =3D le32_to_cpu(src->block_infos[i]);
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		for (j =3D 0; j < FIO_IO_U_PLAT_NR; j++) {
-			dst->io_u_plat_high_prio[i][j] =3D le64_to_cpu(src->io_u_plat_high_prio=
[i][j]);
-			dst->io_u_plat_low_prio[i][j] =3D le64_to_cpu(src->io_u_plat_low_prio[i=
][j]);
-		}
-		convert_io_stat(&dst->clat_high_prio_stat[i], &src->clat_high_prio_stat[=
i]);
-		convert_io_stat(&dst->clat_low_prio_stat[i], &src->clat_low_prio_stat[i]=
);
-	}
=20
 	dst->ss_dur		=3D le64_to_cpu(src->ss_dur);
 	dst->ss_state		=3D le32_to_cpu(src->ss_state);
@@ -1054,6 +1046,19 @@ static void convert_ts(struct thread_stat *dst, stru=
ct thread_stat *src)
 	dst->ss_deviation.u.f 	=3D fio_uint64_to_double(le64_to_cpu(src->ss_devia=
tion.u.i));
 	dst->ss_criterion.u.f 	=3D fio_uint64_to_double(le64_to_cpu(src->ss_crite=
rion.u.i));
=20
+	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		dst->nr_clat_prio[i] =3D le32_to_cpu(src->nr_clat_prio[i]);
+		for (j =3D 0; j < dst->nr_clat_prio[i]; j++) {
+			for (k =3D 0; k < FIO_IO_U_PLAT_NR; k++)
+				dst->clat_prio[i][j].io_u_plat[k] =3D
+					le64_to_cpu(src->clat_prio[i][j].io_u_plat[k]);
+			convert_io_stat(&dst->clat_prio[i][j].clat_stat,
+					&src->clat_prio[i][j].clat_stat);
+			dst->clat_prio[i][j].ioprio =3D
+				le32_to_cpu(dst->clat_prio[i][j].ioprio);
+		}
+	}
+
 	if (dst->ss_state & FIO_SS_DATA) {
 		for (i =3D 0; i < dst->ss_dur; i++ ) {
 			dst->ss_iops_data[i] =3D le64_to_cpu(src->ss_iops_data[i]);
@@ -1796,6 +1801,15 @@ int fio_handle_client(struct fio_client *client)
 	case FIO_NET_CMD_TS: {
 		struct cmd_ts_pdu *p =3D (struct cmd_ts_pdu *) cmd->payload;
 		uint64_t offset;
+		int i;
+
+		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+			if (le32_to_cpu(p->ts.nr_clat_prio[i])) {
+				offset =3D le64_to_cpu(p->ts.clat_prio_offset[i]);
+				p->ts.clat_prio[i] =3D
+					(struct clat_prio_stat *)((char *)p + offset);
+			}
+		}
=20
 		dprint(FD_NET, "client: ts->ss_state =3D %u\n", (unsigned int) le32_to_c=
pu(p->ts.ss_state));
 		if (le32_to_cpu(p->ts.ss_state) & FIO_SS_DATA) {
@@ -2156,6 +2170,7 @@ int fio_handle_clients(struct client_ops *ops)
=20
 	fio_client_json_fini();
=20
+	free_clat_prio_stats(&client_ts);
 	free(pfds);
 	return retval || error_clients;
 }
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 4bb13c34..7884752d 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -49,7 +49,7 @@ static int open_file(struct thread_data *td, struct fio_f=
ile *f)
 		uint64_t nsec;
=20
 		nsec =3D ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
 	}
=20
 	return 0;
diff --git a/engines/filedelete.c b/engines/filedelete.c
index e882ccf0..df388ac9 100644
--- a/engines/filedelete.c
+++ b/engines/filedelete.c
@@ -51,7 +51,7 @@ static int delete_file(struct thread_data *td, struct fio=
_file *f)
 		uint64_t nsec;
=20
 		nsec =3D ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
 	}
=20
 	return 0;
diff --git a/engines/filestat.c b/engines/filestat.c
index 00311247..e587eb54 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -125,7 +125,7 @@ static int stat_file(struct thread_data *td, struct fio=
_file *f)
 		uint64_t nsec;
=20
 		nsec =3D ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
 	}
=20
 	return 0;
diff --git a/io_u.c b/io_u.c
index 656b4610..059637e5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,7 +1595,7 @@ again:
 		assert(io_u->flags & IO_U_F_FREE);
 		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
-				 IO_U_F_VER_LIST | IO_U_F_HIGH_PRIO);
+				 IO_U_F_VER_LIST);
=20
 		io_u->error =3D 0;
 		io_u->acct_ddir =3D -1;
@@ -1890,7 +1890,7 @@ static void account_io_completion(struct thread_data =
*td, struct io_u *io_u,
=20
 		tnsec =3D ntime_since(&io_u->start_time, &icd->time);
 		add_lat_sample(td, idx, tnsec, bytes, io_u->offset,
-			       io_u->ioprio, io_u_is_high_prio(io_u));
+			       io_u->ioprio, io_u->clat_prio_index);
=20
 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops =3D &td->prof_io_ops;
@@ -1912,7 +1912,7 @@ static void account_io_completion(struct thread_data =
*td, struct io_u *io_u,
 	if (ddir_rw(idx)) {
 		if (!td->o.disable_clat) {
 			add_clat_sample(td, idx, llnsec, bytes, io_u->offset,
-					io_u->ioprio, io_u_is_high_prio(io_u));
+					io_u->ioprio, io_u->clat_prio_index);
 			io_u_mark_latency(td, llnsec);
 		}
=20
diff --git a/io_u.h b/io_u.h
index d88d5f2c..206e24fe 100644
--- a/io_u.h
+++ b/io_u.h
@@ -21,7 +21,6 @@ enum {
 	IO_U_F_TRIMMED		=3D 1 << 5,
 	IO_U_F_BARRIER		=3D 1 << 6,
 	IO_U_F_VER_LIST		=3D 1 << 7,
-	IO_U_F_HIGH_PRIO	=3D 1 << 8,
 };
=20
 /*
@@ -194,6 +193,5 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u=
)
 	td_flags_clear((td), &(io_u->flags), (val))
 #define io_u_set(td, io_u, val)		\
 	td_flags_set((td), &(io_u)->flags, (val))
-#define io_u_is_high_prio(io_u)	(io_u->flags & IO_U_F_HIGH_PRIO)
=20
 #endif
diff --git a/server.c b/server.c
index d82c7e5b..0b0e7fe9 100644
--- a/server.c
+++ b/server.c
@@ -1465,6 +1465,7 @@ void fio_server_send_ts(struct thread_stat *ts, struc=
t group_run_stats *rs)
 {
 	struct cmd_ts_pdu p;
 	int i, j, k;
+	size_t clat_prio_stats_extra_size =3D 0;
 	size_t ss_extra_size =3D 0;
 	size_t extended_buf_size =3D 0;
 	void *extended_buf;
@@ -1581,16 +1582,13 @@ void fio_server_send_ts(struct thread_stat *ts, str=
uct group_run_stats *rs)
 	p.ts.cachehit		=3D cpu_to_le64(ts->cachehit);
 	p.ts.cachemiss		=3D cpu_to_le64(ts->cachemiss);
=20
+	convert_gs(&p.rs, rs);
+
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		for (j =3D 0; j < FIO_IO_U_PLAT_NR; j++) {
-			p.ts.io_u_plat_high_prio[i][j] =3D cpu_to_le64(ts->io_u_plat_high_prio[=
i][j]);
-			p.ts.io_u_plat_low_prio[i][j] =3D cpu_to_le64(ts->io_u_plat_low_prio[i]=
[j]);
-		}
-		convert_io_stat(&p.ts.clat_high_prio_stat[i], &ts->clat_high_prio_stat[i=
]);
-		convert_io_stat(&p.ts.clat_low_prio_stat[i], &ts->clat_low_prio_stat[i])=
;
+		if (ts->nr_clat_prio[i])
+			clat_prio_stats_extra_size +=3D ts->nr_clat_prio[i] * sizeof(*ts->clat_=
prio[i]);
 	}
-
-	convert_gs(&p.rs, rs);
+	extended_buf_size +=3D clat_prio_stats_extra_size;
=20
 	dprint(FD_NET, "ts->ss_state =3D %d\n", ts->ss_state);
 	if (ts->ss_state & FIO_SS_DATA)
@@ -1612,6 +1610,33 @@ void fio_server_send_ts(struct thread_stat *ts, stru=
ct group_run_stats *rs)
 	memcpy(extended_buf, &p, sizeof(p));
 	extended_buf_wp =3D (struct cmd_ts_pdu *)extended_buf + 1;
=20
+	if (clat_prio_stats_extra_size) {
+		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+			struct clat_prio_stat *prio =3D (struct clat_prio_stat *) extended_buf_=
wp;
+
+			for (j =3D 0; j < ts->nr_clat_prio[i]; j++) {
+				for (k =3D 0; k < FIO_IO_U_PLAT_NR; k++)
+					prio->io_u_plat[k] =3D
+						cpu_to_le64(ts->clat_prio[i][j].io_u_plat[k]);
+				convert_io_stat(&prio->clat_stat,
+						&ts->clat_prio[i][j].clat_stat);
+				prio->ioprio =3D cpu_to_le32(ts->clat_prio[i][j].ioprio);
+				prio++;
+			}
+
+			/* Set length and offset in the pointer/offset union. */
+			if (ts->nr_clat_prio[i]) {
+				uint64_t offset =3D (char *)extended_buf_wp - (char *)extended_buf;
+				struct cmd_ts_pdu *ptr =3D extended_buf;
+
+				ptr->ts.clat_prio_offset[i] =3D cpu_to_le64(offset);
+				ptr->ts.nr_clat_prio[i] =3D cpu_to_le32(ts->nr_clat_prio[i]);
+			}
+
+			extended_buf_wp =3D prio;
+		}
+	}
+
 	if (ss_extra_size) {
 		uint64_t *ss_iops, *ss_bw;
 		uint64_t offset;
diff --git a/server.h b/server.h
index 25b6bbdc..27091f69 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-	FIO_SERVER_VER			=3D 95,
+	FIO_SERVER_VER			=3D 96,
=20
 	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,
 	FIO_SERVER_MAX_CMD_MB		=3D 2048,
diff --git a/stat.c b/stat.c
index 3345c7c4..096457a2 100644
--- a/stat.c
+++ b/stat.c
@@ -265,6 +265,18 @@ static void show_clat_percentiles(uint64_t *io_u_plat,=
 unsigned long long nr,
 	free(ovals);
 }
=20
+static int get_nr_prios_with_samples(struct thread_stat *ts, enum fio_ddir=
 ddir)
+{
+	int i, nr_prios_with_samples =3D 0;
+
+	for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
+		if (ts->clat_prio[ddir][i].clat_stat.samples)
+			nr_prios_with_samples++;
+	}
+
+	return nr_prios_with_samples;
+}
+
 bool calc_lat(struct io_stat *is, unsigned long long *min,
 	      unsigned long long *max, double *mean, double *dev)
 {
@@ -511,7 +523,8 @@ static void show_ddir_status(struct group_run_stats *rs=
, struct thread_stat *ts,
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
 	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st =3D NULL;
-	int i2p;
+	int i2p, i;
+	const char *clat_type =3D ts->lat_percentiles ? "lat" : "clat";
=20
 	if (ddir_sync(ddir)) {
 		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
@@ -572,12 +585,22 @@ static void show_ddir_status(struct group_run_stats *=
rs, struct thread_stat *ts,
 		display_lat("clat", min, max, mean, dev, out);
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
 		display_lat(" lat", min, max, mean, dev, out);
-	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
-		display_lat(ts->lat_percentiles ? "high prio_lat" : "high prio_clat",
-				min, max, mean, dev, out);
-		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
-			display_lat(ts->lat_percentiles ? "low prio_lat" : "low prio_clat",
-					min, max, mean, dev, out);
+
+	/* Only print per prio stats if there are >=3D 2 prios with samples */
+	if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
+		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
+			if (calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
+				     &max, &mean, &dev)) {
+				char buf[64];
+
+				snprintf(buf, sizeof(buf),
+					 "%s prio %u/%u",
+					 clat_type,
+					 ts->clat_prio[ddir][i].ioprio >> 13,
+					 ts->clat_prio[ddir][i].ioprio & 7);
+				display_lat(buf, min, max, mean, dev, out);
+			}
+		}
 	}
=20
 	if (ts->slat_percentiles && ts->slat_stat[ddir].samples > 0)
@@ -597,8 +620,7 @@ static void show_ddir_status(struct group_run_stats *rs=
, struct thread_stat *ts,
 					ts->percentile_precision, "lat", out);
=20
 	if (ts->clat_percentiles || ts->lat_percentiles) {
-		const char *name =3D ts->lat_percentiles ? "lat" : "clat";
-		char prio_name[32];
+		char prio_name[64];
 		uint64_t samples;
=20
 		if (ts->lat_percentiles)
@@ -606,25 +628,24 @@ static void show_ddir_status(struct group_run_stats *=
rs, struct thread_stat *ts,
 		else
 			samples =3D ts->clat_stat[ddir].samples;
=20
-		/* Only print this if some high and low priority stats were collected */
-		if (ts->clat_high_prio_stat[ddir].samples > 0 &&
-			ts->clat_low_prio_stat[ddir].samples > 0)
-		{
-			sprintf(prio_name, "high prio (%.2f%%) %s",
-					100. * (double) ts->clat_high_prio_stat[ddir].samples / (double) samp=
les,
-					name);
-			show_clat_percentiles(ts->io_u_plat_high_prio[ddir],
-						ts->clat_high_prio_stat[ddir].samples,
-						ts->percentile_list,
-						ts->percentile_precision, prio_name, out);
-
-			sprintf(prio_name, "low prio (%.2f%%) %s",
-					100. * (double) ts->clat_low_prio_stat[ddir].samples / (double) sampl=
es,
-					name);
-			show_clat_percentiles(ts->io_u_plat_low_prio[ddir],
-						ts->clat_low_prio_stat[ddir].samples,
-						ts->percentile_list,
-						ts->percentile_precision, prio_name, out);
+		/* Only print per prio stats if there are >=3D 2 prios with samples */
+		if (get_nr_prios_with_samples(ts, ddir) >=3D 2) {
+			for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
+				uint64_t prio_samples =3D ts->clat_prio[ddir][i].clat_stat.samples;
+
+				if (prio_samples > 0) {
+					snprintf(prio_name, sizeof(prio_name),
+						 "%s prio %u/%u (%.2f%% of IOs)",
+						 clat_type,
+						 ts->clat_prio[ddir][i].ioprio >> 13,
+						 ts->clat_prio[ddir][i].ioprio & 7,
+						 100. * (double) prio_samples / (double) samples);
+					show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
+							      prio_samples, ts->percentile_list,
+							      ts->percentile_precision,
+							      prio_name, out);
+				}
+			}
 		}
 	}
=20
@@ -679,6 +700,7 @@ static void show_mixed_ddir_status(struct group_run_sta=
ts *rs,
 	if (ts_lcl)
 		show_ddir_status(rs, ts_lcl, DDIR_READ, out);
=20
+	free_clat_prio_stats(ts_lcl);
 	free(ts_lcl);
 }
=20
@@ -1353,6 +1375,7 @@ static void show_mixed_ddir_status_terse(struct threa=
d_stat *ts,
 	if (ts_lcl)
 		show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
=20
+	free_clat_prio_stats(ts_lcl);
 	free(ts_lcl);
 }
=20
@@ -1537,6 +1560,7 @@ static void add_mixed_ddir_status_json(struct thread_=
stat *ts,
 	if (ts_lcl)
 		add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
=20
+	free_clat_prio_stats(ts_lcl);
 	free(ts_lcl);
 }
=20
@@ -2038,6 +2062,176 @@ int alloc_clat_prio_stat_ddir(struct thread_stat *t=
s, enum fio_ddir ddir,
 	return 0;
 }
=20
+static int grow_clat_prio_stat(struct thread_stat *dst, enum fio_ddir ddir=
)
+{
+	int curr_len =3D dst->nr_clat_prio[ddir];
+	void *new_arr;
+
+	new_arr =3D scalloc(curr_len + 1, sizeof(*dst->clat_prio[ddir]));
+	if (!new_arr) {
+		log_err("fio: failed to grow clat prio array\n");
+		return 1;
+	}
+
+	memcpy(new_arr, dst->clat_prio[ddir],
+	       curr_len * sizeof(*dst->clat_prio[ddir]));
+	sfree(dst->clat_prio[ddir]);
+
+	dst->clat_prio[ddir] =3D new_arr;
+	dst->clat_prio[ddir][curr_len].clat_stat.min_val =3D ULONG_MAX;
+	dst->nr_clat_prio[ddir]++;
+
+	return 0;
+}
+
+static int find_clat_prio_index(struct thread_stat *dst, enum fio_ddir ddi=
r,
+				uint32_t ioprio)
+{
+	int i, nr_prios =3D dst->nr_clat_prio[ddir];
+
+	for (i =3D 0; i < nr_prios; i++) {
+		if (dst->clat_prio[ddir][i].ioprio =3D=3D ioprio)
+			return i;
+	}
+
+	return -1;
+}
+
+static int alloc_or_get_clat_prio_index(struct thread_stat *dst,
+					enum fio_ddir ddir, uint32_t ioprio,
+					int *idx)
+{
+	int index =3D find_clat_prio_index(dst, ddir, ioprio);
+
+	if (index =3D=3D -1) {
+		index =3D dst->nr_clat_prio[ddir];
+
+		if (grow_clat_prio_stat(dst, ddir))
+			return 1;
+
+		dst->clat_prio[ddir][index].ioprio =3D ioprio;
+	}
+
+	*idx =3D index;
+
+	return 0;
+}
+
+static int clat_prio_stats_copy(struct thread_stat *dst, struct thread_sta=
t *src,
+				enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
+{
+	size_t sz =3D sizeof(*src->clat_prio[src_ddir]) *
+		src->nr_clat_prio[src_ddir];
+
+	dst->clat_prio[dst_ddir] =3D smalloc(sz);
+	if (!dst->clat_prio[dst_ddir]) {
+		log_err("fio: failed to alloc clat prio array\n");
+		return 1;
+	}
+
+	memcpy(dst->clat_prio[dst_ddir], src->clat_prio[src_ddir], sz);
+	dst->nr_clat_prio[dst_ddir] =3D src->nr_clat_prio[src_ddir];
+
+	return 0;
+}
+
+static int clat_prio_stat_add_samples(struct thread_stat *dst,
+				      enum fio_ddir dst_ddir, uint32_t ioprio,
+				      struct io_stat *io_stat,
+				      uint64_t *io_u_plat)
+{
+	int i, dst_index;
+
+	if (!io_stat->samples)
+		return 0;
+
+	if (alloc_or_get_clat_prio_index(dst, dst_ddir, ioprio, &dst_index))
+		return 1;
+
+	sum_stat(&dst->clat_prio[dst_ddir][dst_index].clat_stat, io_stat,
+		 false);
+
+	for (i =3D 0; i < FIO_IO_U_PLAT_NR; i++)
+		dst->clat_prio[dst_ddir][dst_index].io_u_plat[i] +=3D io_u_plat[i];
+
+	return 0;
+}
+
+static int sum_clat_prio_stats_src_single_prio(struct thread_stat *dst,
+					       struct thread_stat *src,
+					       enum fio_ddir dst_ddir,
+					       enum fio_ddir src_ddir)
+{
+	struct io_stat *io_stat;
+	uint64_t *io_u_plat;
+
+	/*
+	 * If src ts has no clat_prio_stat array, then all I/Os were submitted
+	 * using src->ioprio. Thus, the global samples in src->clat_stat (or
+	 * src->lat_stat) can be used as the 'per prio' samples for src->ioprio.
+	 */
+	assert(!src->clat_prio[src_ddir]);
+	assert(src->nr_clat_prio[src_ddir] =3D=3D 0);
+
+	if (src->lat_percentiles) {
+		io_u_plat =3D src->io_u_plat[FIO_LAT][src_ddir];
+		io_stat =3D &src->lat_stat[src_ddir];
+	} else {
+		io_u_plat =3D src->io_u_plat[FIO_CLAT][src_ddir];
+		io_stat =3D &src->clat_stat[src_ddir];
+	}
+
+	return clat_prio_stat_add_samples(dst, dst_ddir, src->ioprio, io_stat,
+					  io_u_plat);
+}
+
+static int sum_clat_prio_stats_src_multi_prio(struct thread_stat *dst,
+					      struct thread_stat *src,
+					      enum fio_ddir dst_ddir,
+					      enum fio_ddir src_ddir)
+{
+	int i;
+
+	/*
+	 * If src ts has a clat_prio_stat array, then there are multiple prios
+	 * in use (i.e. src ts had cmdprio_percentage or cmdprio_bssplit set).
+	 * The samples for the default prio will exist in the src->clat_prio
+	 * array, just like the samples for any other prio.
+	 */
+	assert(src->clat_prio[src_ddir]);
+	assert(src->nr_clat_prio[src_ddir]);
+
+	/* If the dst ts doesn't yet have a clat_prio array, simply memcpy. */
+	if (!dst->clat_prio[dst_ddir])
+		return clat_prio_stats_copy(dst, src, dst_ddir, src_ddir);
+
+	/* The dst ts already has a clat_prio_array, add src stats into it. */
+	for (i =3D 0; i < src->nr_clat_prio[src_ddir]; i++) {
+		struct io_stat *io_stat =3D &src->clat_prio[src_ddir][i].clat_stat;
+		uint64_t *io_u_plat =3D src->clat_prio[src_ddir][i].io_u_plat;
+		uint32_t ioprio =3D src->clat_prio[src_ddir][i].ioprio;
+
+		if (clat_prio_stat_add_samples(dst, dst_ddir, ioprio, io_stat, io_u_plat=
))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int sum_clat_prio_stats(struct thread_stat *dst, struct thread_stat=
 *src,
+			       enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
+{
+	if (dst->disable_prio_stat)
+		return 0;
+
+	if (!src->clat_prio[src_ddir])
+		return sum_clat_prio_stats_src_single_prio(dst, src, dst_ddir,
+							   src_ddir);
+	else
+		return sum_clat_prio_stats_src_multi_prio(dst, src, dst_ddir,
+							  src_ddir);
+}
+
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
 {
 	int k, l, m;
@@ -2045,12 +2239,11 @@ void sum_thread_stats(struct thread_stat *dst, stru=
ct thread_stat *src)
 	for (l =3D 0; l < DDIR_RWDIR_CNT; l++) {
 		if (dst->unified_rw_rep !=3D UNIFIED_MIXED) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], false);
-			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], fa=
lse);
-			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], fals=
e);
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], false);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], false);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], true);
 			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], true);
+			sum_clat_prio_stats(dst, src, l, l);
=20
 			dst->io_bytes[l] +=3D src->io_bytes[l];
=20
@@ -2058,12 +2251,11 @@ void sum_thread_stats(struct thread_stat *dst, stru=
ct thread_stat *src)
 				dst->runtime[l] =3D src->runtime[l];
 		} else {
 			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], false);
-			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], fa=
lse);
-			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], fals=
e);
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], false);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], false);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], true);
 			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], true);
+			sum_clat_prio_stats(dst, src, 0, l);
=20
 			dst->io_bytes[0] +=3D src->io_bytes[l];
=20
@@ -2117,19 +2309,6 @@ void sum_thread_stats(struct thread_stat *dst, struc=
t thread_stat *src)
 	for (k =3D 0; k < FIO_IO_U_PLAT_NR; k++)
 		dst->io_u_sync_plat[k] +=3D src->io_u_sync_plat[k];
=20
-	for (k =3D 0; k < DDIR_RWDIR_CNT; k++) {
-		for (m =3D 0; m < FIO_IO_U_PLAT_NR; m++) {
-			if (dst->unified_rw_rep !=3D UNIFIED_MIXED) {
-				dst->io_u_plat_high_prio[k][m] +=3D src->io_u_plat_high_prio[k][m];
-				dst->io_u_plat_low_prio[k][m] +=3D src->io_u_plat_low_prio[k][m];
-			} else {
-				dst->io_u_plat_high_prio[0][m] +=3D src->io_u_plat_high_prio[k][m];
-				dst->io_u_plat_low_prio[0][m] +=3D src->io_u_plat_low_prio[k][m];
-			}
-
-		}
-	}
-
 	dst->total_run_time +=3D src->total_run_time;
 	dst->total_submit +=3D src->total_submit;
 	dst->total_complete +=3D src->total_complete;
@@ -2157,8 +2336,6 @@ void init_thread_stat_min_vals(struct thread_stat *ts=
)
 		ts->lat_stat[i].min_val =3D ULONG_MAX;
 		ts->bw_stat[i].min_val =3D ULONG_MAX;
 		ts->iops_stat[i].min_val =3D ULONG_MAX;
-		ts->clat_high_prio_stat[i].min_val =3D ULONG_MAX;
-		ts->clat_low_prio_stat[i].min_val =3D ULONG_MAX;
 	}
 	ts->sync_stat.min_val =3D ULONG_MAX;
 }
@@ -2517,6 +2694,13 @@ void __show_run_stats(void)
=20
 	log_info_flush();
 	free(runstats);
+
+	/* free arrays allocated by sum_thread_stats(), if any */
+	for (i =3D 0; i < nr_ts; i++) {
+		ts =3D &threadstats[i];
+		if (!ts->disable_prio_stat)
+			free_clat_prio_stats(ts);
+	}
 	free(threadstats);
 	free(opt_lists);
 }
@@ -2643,6 +2827,14 @@ static inline void add_stat_sample(struct io_stat *i=
s, unsigned long long data)
 	is->samples++;
 }
=20
+static inline void add_stat_prio_sample(struct clat_prio_stat *clat_prio,
+					unsigned short clat_prio_index,
+					unsigned long long nsec)
+{
+	if (clat_prio)
+		add_stat_sample(&clat_prio[clat_prio_index].clat_stat, nsec);
+}
+
 /*
  * Return a struct io_logs, which is added to the tail of the log
  * list for 'iolog'.
@@ -2848,14 +3040,28 @@ static inline void reset_io_u_plat(uint64_t *io_u_p=
lat)
 		io_u_plat[i] =3D 0;
 }
=20
+static inline void reset_clat_prio_stats(struct thread_stat *ts)
+{
+	enum fio_ddir ddir;
+	int i;
+
+	for (ddir =3D 0; ddir < DDIR_RWDIR_CNT; ddir++) {
+		if (!ts->clat_prio[ddir])
+			continue;
+
+		for (i =3D 0; i < ts->nr_clat_prio[ddir]; i++) {
+			reset_io_stat(&ts->clat_prio[ddir][i].clat_stat);
+			reset_io_u_plat(ts->clat_prio[ddir][i].io_u_plat);
+		}
+	}
+}
+
 void reset_io_stats(struct thread_data *td)
 {
 	struct thread_stat *ts =3D &td->ts;
 	int i, j;
=20
 	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		reset_io_stat(&ts->clat_high_prio_stat[i]);
-		reset_io_stat(&ts->clat_low_prio_stat[i]);
 		reset_io_stat(&ts->clat_stat[i]);
 		reset_io_stat(&ts->slat_stat[i]);
 		reset_io_stat(&ts->lat_stat[i]);
@@ -2867,15 +3073,14 @@ void reset_io_stats(struct thread_data *td)
 		ts->total_io_u[i] =3D 0;
 		ts->short_io_u[i] =3D 0;
 		ts->drop_io_u[i] =3D 0;
-
-		reset_io_u_plat(ts->io_u_plat_high_prio[i]);
-		reset_io_u_plat(ts->io_u_plat_low_prio[i]);
 	}
=20
 	for (i =3D 0; i < FIO_LAT_CNT; i++)
 		for (j =3D 0; j < DDIR_RWDIR_CNT; j++)
 			reset_io_u_plat(ts->io_u_plat[i][j]);
=20
+	reset_clat_prio_stats(ts);
+
 	ts->total_io_u[DDIR_SYNC] =3D 0;
 	reset_io_u_plat(ts->io_u_sync_plat);
=20
@@ -3028,22 +3233,21 @@ static inline void add_lat_percentile_sample(struct=
 thread_stat *ts,
 	ts->io_u_plat[lat][ddir][idx]++;
 }
=20
-static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
-						  unsigned long long nsec,
-						  enum fio_ddir ddir,
-						  bool high_prio)
+static inline void
+add_lat_percentile_prio_sample(struct thread_stat *ts, unsigned long long =
nsec,
+			       enum fio_ddir ddir,
+			       unsigned short clat_prio_index)
 {
 	unsigned int idx =3D plat_val_to_idx(nsec);
=20
-	if (!high_prio)
-		ts->io_u_plat_low_prio[ddir][idx]++;
-	else
-		ts->io_u_plat_high_prio[ddir][idx]++;
+	if (ts->clat_prio[ddir])
+		ts->clat_prio[ddir][clat_prio_index].io_u_plat[idx]++;
 }
=20
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
-		     uint64_t offset, unsigned int ioprio, bool high_prio)
+		     uint64_t offset, unsigned int ioprio,
+		     unsigned short clat_prio_index)
 {
 	const bool needs_lock =3D td_async_processing(td);
 	unsigned long elapsed, this_window;
@@ -3056,7 +3260,7 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
=20
 	/*
-	 * When lat_percentiles=3D1 (default 0), the reported high/low priority
+	 * When lat_percentiles=3D1 (default 0), the reported per priority
 	 * percentiles and stats are used for describing total latency values,
 	 * even though the variable names themselves start with clat_.
 	 *
@@ -3064,12 +3268,9 @@ void add_clat_sample(struct thread_data *td, enum fi=
o_ddir ddir,
 	 * lat_percentiles=3D0. add_lat_sample() will add the prio stat sample
 	 * when lat_percentiles=3D1.
 	 */
-	if (!ts->lat_percentiles) {
-		if (high_prio)
-			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
-		else
-			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
-	}
+	if (!ts->lat_percentiles)
+		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
+				     nsec);
=20
 	if (td->clat_log)
 		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
@@ -3084,7 +3285,7 @@ void add_clat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
 		if (!ts->lat_percentiles)
 			add_lat_percentile_prio_sample(ts, nsec, ddir,
-						       high_prio);
+						       clat_prio_index);
 	}
=20
 	if (iolog && iolog->hist_msec) {
@@ -3157,7 +3358,8 @@ void add_slat_sample(struct thread_data *td, enum fio=
_ddir ddir,
=20
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
-		    uint64_t offset, unsigned int ioprio, bool high_prio)
+		    uint64_t offset, unsigned int ioprio,
+		    unsigned short clat_prio_index)
 {
 	const bool needs_lock =3D td_async_processing(td);
 	struct thread_stat *ts =3D &td->ts;
@@ -3175,7 +3377,7 @@ void add_lat_sample(struct thread_data *td, enum fio_=
ddir ddir,
 			       offset, ioprio);
=20
 	/*
-	 * When lat_percentiles=3D1 (default 0), the reported high/low priority
+	 * When lat_percentiles=3D1 (default 0), the reported per priority
 	 * percentiles and stats are used for describing total latency values,
 	 * even though the variable names themselves start with clat_.
 	 *
@@ -3186,12 +3388,9 @@ void add_lat_sample(struct thread_data *td, enum fio=
_ddir ddir,
 	 */
 	if (ts->lat_percentiles) {
 		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
-		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
-		if (high_prio)
-			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
-		else
-			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
-
+		add_lat_percentile_prio_sample(ts, nsec, ddir, clat_prio_index);
+		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
+				     nsec);
 	}
 	if (needs_lock)
 		__td_io_u_unlock(td);
diff --git a/stat.h b/stat.h
index 4b1d4cb8..4f0c746f 100644
--- a/stat.h
+++ b/stat.h
@@ -373,9 +373,9 @@ extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
=20
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned l=
ong long,
-			   unsigned long long, uint64_t, unsigned int, bool);
+			   unsigned long long, uint64_t, unsigned int, unsigned short);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned =
long long,
-			    unsigned long long, uint64_t, unsigned int, bool);
+			    unsigned long long, uint64_t, unsigned int, unsigned short);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned =
long long,
 				unsigned long long, uint64_t, unsigned int);
 extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned l=
ong long);
--=20
2.34.1
