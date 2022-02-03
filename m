Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FB7C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353773AbiBCTcT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:19 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1744 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiBCTcP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916736; x=1675452736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mnkn+ou5o5krI9STM7QYfpGQuLbeWzzxQ0ugYnAmgKA=;
  b=ddXu1IlknwLKfYCMtSaZf9d3vNk1r6Ot7i/5BQrclhGwf6QtKMU3lSlo
   8fusZFQMclk/AbyvED9NP71l/+P4xK0ggS49OFsw7/qNYLnsnqIzm1SsV
   sP7vmAiVz/Ry/gHvTkYNuBmeYJeJHi5A4RTJ+olW4HJE1S6McqC4/2bn9
   gwGGNHIryPw39pgSzgQ7ZfYgRk+WAKEvhzJ10Xr2rube1CEaiNG3tRVmD
   4e8Kd4Xi1rdXqJht0HGQ5eLvCjTb8jMEKb8kfBlsbSTCwPhfgbPbGgfQl
   7WKR0RFohY+3+CPDZ3MaaX++BKJCsy+BbUzGuLy4PigFzfEMrlEgirJC8
   g==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095712"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYb3WxPwOiomaDStkGqHGFIq+UFnL3BWppKAsE7+Td3uK90WQElAPaEaPstYZ8EFzA5kU6QBblLwV4x6bqIJTdv/d4HhAbOXSDHnyvPQLZOoOyuRifoH2kxC/VuFkk6QxtT6UfTT6fM1rZozJUt59osq/grMT9lPQ5gE6jloAWfZHc7CN96nUc0nXQAQK+PCtc3pdNw1ZxClzS9j0ev9P43/z4Y2kfML7Hm/C/VsDfvk6y2RCycMT+KLhGy+vWXA+1hHme1vmWa8zcV6eSEJGcVjQ3Gp8wNgcso/pz9xTAZuFN3h07TBEh38MRzkl9FlYKSFTZBOT8g5SiFP3sgsSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnkn+ou5o5krI9STM7QYfpGQuLbeWzzxQ0ugYnAmgKA=;
 b=oYg88AymgP4YGteQnD4hywhjjcAaghBNJ7YI8yOi0QAuBD7lQAUdQT6Ju1crlyIFvsgnaLYZdb7LgdWpcq2U0KyIxN2QNnTXdsWU2Y7xKLOGXFJ6NdPNEXjVioJFIEuRecPdtb84odaTVm6S0qXHrVsZ2jA6QZ3S7Jogj2aT/+eO8Wp9ZET7Xm9D4M+zO01W0Wo0f9XsNr95umIOXKFK8jAeYeaP4AoyE0fTuURe9QoMh121P4FKL3eeI2pcaUOGIDhi6uvkYqXozZchfiOAnSlltqkeQDUoafIQTDi7jzvbDQ9mwIEXFLcRYzc6TSP0h5TP0S+dZIWfs8JCi3MaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnkn+ou5o5krI9STM7QYfpGQuLbeWzzxQ0ugYnAmgKA=;
 b=QYdQbDJtqzuKDJXW0dEcGAJzGuBRcPyRXXXaylMiygqYPmq1I2eA6K4CFYjqsAWgPn7BvAS8MmcuwFMxe2IHRmoxYKkerH4EM3EzRTAYDAVk1dizjs1Te082mn9GI6sjXBEwSso7MBsZL2gwnghaLs5bYN/dTl9g6z8rO4WgqUg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 09/18] examples: add new cmdprio_bssplit format examples
Thread-Topic: [PATCH v2 09/18] examples: add new cmdprio_bssplit format
 examples
Thread-Index: AQHYGTQ4d7mAXUucWk+biYvsTej5uA==
Date:   Thu, 3 Feb 2022 19:28:28 +0000
Message-ID: <20220203192814.18552-10-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de36162f-0060-4027-5fd3-08d9e74b5c0d
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB463240F6405B3913E8D09443F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GVWG5XpkLmmjJXiK4TiN4e2rfv8iMrFyVAImSicuNayQoWR6p6PjeO2GUHLkcUv4kektGyR75OF7nY6HfrHmjGm7uDFZyVZa+sf+tg1U6gwIBkZFhgVqvEFnbHx2NJL8iUZrg3qHqw/tH4LQCZaGd1VGO8T9o2FDqhgeBs+pPHTr3rxt0rQzmDwYmkRzQUb6GZ4RhoQ+qOmQtxdaMeM6UWe1LOQhAJ/NpQnbGiKB3mAMPrhMfpBEs8QaDRIAuWThCsoGJ+xIPSAPrYWOwhaoRL41uDQazF0Wu5o4vi0tupezn2Csk9uZHL18tT3bCbABeMcLA9amXHxZrYie8cdr8p3/Rp2WrV7VcCL/gbQrWKYt3IjGGZKDIqxA1+e/xnc3V3/sXHthTdw3mzrfFgZN4Hu7A4xZWHJCfrxj8pXMkv/s98wNISouateGer2/aTP4haFl4zOy2t7McinuPZl0wOvyZJlycpydFr311Y1PL3FQlMtX5qLX2C3xLajV8fOLS18pqXl3rZBPYDVo+C9QGjWcy/9/tTCcqIHnxvlb6isAQ/EjA/F4WXdnhs/q0tihYi0bw+CgEbsPQjqsoOqEkpkEgPGWd6EB75MFGZw42W3KtkKWWCcp7m9H1qeEZqyls1O+9YS2b2FAENsblmY0XMMlbvT712+DJxag/Na/uLKju8TxTFMonWkc7CRwnHTtRI1h8FZU3uVAte8DeZ7ahA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?wys8LGJTxxe8EdmytS4vyjr3953Q+7ShO6KVbkO1TPLZtdMh979uh+wNq9?=
 =?iso-8859-1?Q?23BFwNB3HL4RjyOd3Pj6ZLy1dwdC3zP/0LxoN1S+oSq3qC+f32p9F9mwc+?=
 =?iso-8859-1?Q?oZrhCGqRWr89tnsx28pkjIi8aTj9g3JnGy6rZDNaypFEFdYnYyTZYnx117?=
 =?iso-8859-1?Q?GUYrLfey+3XSEx9TrSY0Lp8Lb+Ib/HLi5XeHmb/QJ9+ioVeWc8C5PkaYWW?=
 =?iso-8859-1?Q?yIjA0a3po4qDxb5XDY0NG4PqH2kgo+D5KI5eSmVW0Ewwqh0Kr4hYJ03gUJ?=
 =?iso-8859-1?Q?JE51ZeU6e3aR9IHO4WRFWW4hRWddeIr9+4t1wNoyXyz9tVpKmQfNpIXmVo?=
 =?iso-8859-1?Q?Sjk1ByG8FI7yQKqAWJAIWU+i8OIo50DxCMLraskuTMAxDdJ0oL712F8QO0?=
 =?iso-8859-1?Q?+bopO2lgbKiHSkBKFw/rjx3lPBTU8CNLsNr0t00L6A++Za46ACZgEonkMR?=
 =?iso-8859-1?Q?Oac5B25wdGN6YOMXKb8YTRR9q/5azyi7jSTBZUVZ6ux+OxJNOFWT1HZKdO?=
 =?iso-8859-1?Q?Kj21HxAjX2NQWyAwOH2gj14PT3EbGpw0tWIlPH+ud60Exu9VTmE0Jwh387?=
 =?iso-8859-1?Q?uIjAn9W506npNVgIUuEO8EiQJzQ5korIaZ6fqXIXjbdYDLk0hLCRuDXHWH?=
 =?iso-8859-1?Q?fGafqaEvq6zMAOo7aJxBD3IVo+3wIidbKr8vUo8jR0kyrvgm2aBQ+bi9Wk?=
 =?iso-8859-1?Q?8Cv3kNQ55q1G2HpgwIgfUpkpNGNKV4h6HYJSEufE+dFrH49cDEKrFJIm09?=
 =?iso-8859-1?Q?SF63ivAJOS2ppsrhicyPfDq0yW/itODe14HoMgvLspvcMWc7hcS6MJazEI?=
 =?iso-8859-1?Q?uaBGPs2t2iPKk4Z5aR7e+Cace/r/6iHRiJCADat7vJVs67a2eZ8ewLWR2v?=
 =?iso-8859-1?Q?pXg1n2jVIIxm2trwA63YV7CjJquJL3SMB1jMrae3pXZB67zglz0GfvuOCg?=
 =?iso-8859-1?Q?2eeLTNviFmK58DVdFcNiuFIwPd5kbKarZwGtOBYypjJGzOXaZ0YKWXF8rE?=
 =?iso-8859-1?Q?CCf/2M0fN0g481GyFHHWfPCvYhWUZDVMTRtj9zxKE2PcLgHPUU6P+L1y4i?=
 =?iso-8859-1?Q?j9LzW2KQhtSPnjncP10LPna1K7r0qvFHcKItRntSZkjhCWPKTalVtz9Kqn?=
 =?iso-8859-1?Q?1t/Po5jgQWrUSwcZEelDkFrCbKix1+cVYfni3aUd7dExo3N2rhSze6Y1ft?=
 =?iso-8859-1?Q?UMK9fi4CoeAPJ2x0/zfVLVzQljGTC0DZbj1H+oIqdZHGa/SGcJXZdjpsKH?=
 =?iso-8859-1?Q?DmGyjsMLrr8yhSpcL5Vx9u37WVqyuMbeIiw8QO0cjwZDN8/3Wh6W2gyxlg?=
 =?iso-8859-1?Q?Ks3QLDqZYEd0JUaIELF8FH2NgUhORYATYQYZB7amkqmp7suNf03ofD1AT9?=
 =?iso-8859-1?Q?PGHo1hnJb+vtRaDjBLomj+DIXDDztFH/v9UqY3VRmjABs3Eu+OSyyAY6Ir?=
 =?iso-8859-1?Q?w+/PEMT8KVHlNzfgUsFQtMZAupnJJBLBljJw2hy+sCUoxb9Ahlrgw2ap2X?=
 =?iso-8859-1?Q?2hO6WMvaBIJ1K8prFwjHQasjQAwohxAotdxSoEnI3M+W70ltl9/hA0iZ4V?=
 =?iso-8859-1?Q?+x2KTNZvYWjKNVk7YMGmNcupj2AU9QbHubin6IHMelH63fZ/gYJMMVruz1?=
 =?iso-8859-1?Q?2ZLftq99UaSlC6ldJc+/9Nwbuu81IMVjECXwZlYaK2WWoxtnqxxPxINaE3?=
 =?iso-8859-1?Q?OFBSeShgvqnDpep11uoGM8G323TUNNuszDcTSiqe?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de36162f-0060-4027-5fd3-08d9e74b5c0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:28.4611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvtxqP+7VrElsswdD7UeNix8n4Lj1hE71Zl2ZJz4dYKZ+LeXO5Vu+LRoCgNyqW2gsZC4r8aACID8lf8GLmXbvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Add examples of the new cmdprio_bssplit format to cmdprio-bssplit.fio.

In this new format, a priority class and a priority level can be specified
in the cmdprio_bssplit entry itself.

Add the new cmdprio_bssplit format examples as new jobs, as the old format
is still supported.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 examples/cmdprio-bssplit.fio | 39 ++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
index 47e9a790..f3b2fac0 100644
--- a/examples/cmdprio-bssplit.fio
+++ b/examples/cmdprio-bssplit.fio
@@ -1,17 +1,44 @@
 ; Randomly read/write a block device file at queue depth 16.
-; 40 % of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
-; 100% of the 64kB reads are executed at the highest priority and
-; all other IOs executed without a priority set.
 [global]
 filename=3D/dev/sda
 direct=3D1
 write_lat_log=3Dprio-run.log
 log_prio=3D1
-
-[randrw]
 rw=3Drandrw
-bssplit=3D64k/40:1024k/60,1024k/100
 ioengine=3Dlibaio
 iodepth=3D16
+
+; Simple cmdprio_bssplit format. All non-zero percentage entries will
+; use the same prio class and prio level defined by the cmdprio_class
+; and cmdprio options.
+[cmdprio]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 100% of the 64kB reads are executed with prio class 1 and prio level 0.
+; All other IOs are executed without a priority set.
+bssplit=3D64k/40:1024k/60,1024k/100
 cmdprio_bssplit=3D64k/100:1024k/0,1024k/0
 cmdprio_class=3D1
+cmdprio=3D0
+
+; Advanced cmdprio_bssplit format. Each non-zero percentage entry can
+; use a different prio class and prio level (appended to each entry).
+[cmdprio-adv]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
+; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
+; All other IOs are executed without a priority set.
+stonewall
+bssplit=3D64k/40:1024k/60,1024k/100
+cmdprio_bssplit=3D64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
+
+; Identical to the previous example, but with a default priority defined.
+[cmdprio-adv-def]
+; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
+; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
+; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
+; All other IOs are executed with prio class 2 and prio level 7.
+stonewall
+prioclass=3D2
+prio=3D7
+bssplit=3D64k/40:1024k/60,1024k/100
+cmdprio_bssplit=3D64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
--=20
2.34.1
