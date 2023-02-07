Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F0EC636CC
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjBGOGC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjBGOGA (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:00 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64D776BF
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778751; x=1707314751;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=72hBLWID5CLewLkchfYgRDMeUkpijBZhpRG3uqVtoo0=;
  b=KaZkoXyz5NJ8h9t3KMKjxcfrWkDVPaqq/AryCZCvH9DmmjW4FtQinIet
   +tu6RNCBJ+dNaEQCYuftTSQMQy/+VV7Ypwp8W4KaJcD5sCa4Ufz7VHlKq
   mHpQr0n/hUQ+NExcT3q7hCc6msRpm/NHCsJI/OA8soJpjwkdAcBKv/IGf
   qzPi7uWOeF0TSyY5wxZzr6qR/k+F9GIo9JdWGW2kmxAij6VUl72mDehxH
   qTS4jO6Brdc/ZckcCGpSHW4F9sLfXMmgNYaPr+OXiy34CRSjQijXTYz5z
   oIHBWkBuisvIICHcNmtStNhvpph6DpVPfnBZHhwEMJj70cI2J4egAvSaR
   A==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="327012714"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:05:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izBi3oMfDTjlAjHLju7qAKJpzmsPuldplF4l0k/y3FizksDSENPHA/t9rAqyZ6XZMGHSWFLJEuz+EMdGyx7O2qCF/NRSR70NKc0abBT7MxqjiL2m6rcisCwHP4IC0Rcw3OvqOQ9IAPXOzDq8h0z0WhiE7rz6fXtFl2YN9vzfHN6g+EUQfmYRyW595n3Av5unMFZr9xyvuitQPOo64h/7a1pKHYytqEHXZlcXKK5DJvL+c75sBeL96X5QqMQcrqx/Y0Q+MK9iKbesTHfeOw8CHN5Vd2A9bVyU8Qhe/n9UPJw40iqECKca2LUKIfCS8XclrjxxYKdxExKNx0Tci32RXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAWQUX/H01TESuH9akOsATfuhZ0empcNje69Hqs6T7U=;
 b=nv/KjVboMcJY7tse7sUNj4n/IEeJBDshSYybJSc/X5L0aEkOYnfvxrwgpA2DQM3uRiU/3olwrjCUdHM7Q0Yeyscfy/jU8htEwFDppdaxJzma+acYnNuqi6FNg7POA0vHc2z65QOlUuq8vW9PWQS+oQWckPHsr9Ke1RlMBoQKh0xm1isVNCKC02HJ3/vtHYeklDczT8Yy3BsIE+dq0G7yePd99Ro8Vbmkg1EFykaaBr3oab7mVDgGaHWhXr2rsQ1aV+/0aVtQGzTeULIZd/v2jnVlANyLlNm9MBRgg+tm6sMPbPPirblbkLiawm0olQTjN0qfYfMUTwbjllZnLZIsOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAWQUX/H01TESuH9akOsATfuhZ0empcNje69Hqs6T7U=;
 b=v3c+CqF2iv2vWY7WjlVGqs8xT7OSJcR9P5LElMbKqJ+PC6In3BmfSKuPUW2RIjyrcr2rIBuemw47xMWQXuAD+qtRfjN95VFmRgojNvhGBb0st26z9fyhbnLtSlvyNQ7JHoyxnX0OA22AFwFzYXjWEFrCKOT57f0K+MGqnbGpGSM=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7042.namprd04.prod.outlook.com (2603:10b6:a03:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:05:42 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:05:42 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 1/8] zbd: refer file->last_start[] instead of sectors
 with data accounting
Thread-Topic: [PATCH v2 1/8] zbd: refer file->last_start[] instead of sectors
 with data accounting
Thread-Index: AQHZOr6zlEQqOg71lEOB7wfpHOblDa7DhQcA
Date:   Tue, 7 Feb 2023 14:05:42 +0000
Message-ID: <Y+JatNhCWDQexWJd@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7042:EE_
x-ms-office365-filtering-correlation-id: 5fecf3a2-0245-4502-b489-08db0914662d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vZUtSkEMaEo+56B7FUVqI6Mnt2fGlynHDKzoJshxaIGTlqb1wazVEKxjXBYGC36Bz2e86+U2k9PIweQOPKKYOAnzwHRrfvtSXOofB1X841W9yODXYt59wdG1ERR4Zrq4s0pu1jkeuoWO3G912isu9LClMBB//XGDA2A/B/zKz8qe+DL7/BvPB+TuvOf5VR6RJX2yAGsGdReGvoeCLRXuu0rFj1lcT1RnxNB+QmJzSFYHSJsuBN7R9qQZ0CXgm8K6JbVLYe2sUaz3p4ATT8ob5w7jCWzdw/OogZLUrPLdE14zrto3HKENagS648RYPi4OJyrRPc3cDgIkqE6DPs1L34V2oiD/R664C8nlMBFKrYnbjgl0SEnjCMmTAaPc8/iqGXjJjuu+6dFdTAyhd83XPBN2YAEhrd+dXdzI/o4RO3ViIbpniQI7fIsFTxnCpRiQKrkwudZLNbvDZ8dcMPmNXsMkgQXVwabLaMxst22H7u1HIWiTbLoS/XgVA6X+jHDvXMWayRssVCelR6f2iaJYHgJvZtqY8byCbV+L04a9uZA8LWiiqXu5MkHatAI8nDlX7jMB7ZJC+iHxeYFCKt3jT7rSQC1UuOahaIRWLfR5HTh8VRvH52zRtEUfYerIYjYDDrUbFFvIg2lkJC7fVhINvm5PDcJaBxysM5nbjj2w9gc//b8OMB4xV+bmKwumvMwo1tEIkVuWnHTRgKLB1bFOt2VwRHTvroy8+Dm+r9YKi+E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(38070700005)(86362001)(122000001)(66946007)(54906003)(316002)(66556008)(66446008)(91956017)(8676002)(76116006)(38100700002)(64756008)(6486002)(4326008)(478600001)(66476007)(5660300002)(6636002)(2906002)(6862004)(33716001)(8936002)(41300700001)(15650500001)(26005)(6506007)(186003)(9686003)(6512007)(71200400001)(83380400001)(82960400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?29bUBebIOkL8MqGN6lxlAK+/1dRZNAmlqcqB/ByEsiL0T4KTLumMcvDtPTLK?=
 =?us-ascii?Q?NyDWHEtsO3bjjExrzvm6Y85kfTundlSANCT4D6zEpm6B4+4kRUwxMf0mgSi1?=
 =?us-ascii?Q?+ECG4YmeT9Ca+dl/200eU1AKdQQm/nVk7sZ/WXXx4zAHXvBlau9/Q4h8uob1?=
 =?us-ascii?Q?lcs6ODCi7IRWuMSOAb0RPaJwFJ/vbqtzFeI/6sq4Zdnd+MWKLQeCezJpkA04?=
 =?us-ascii?Q?5eFAbMmxRT8qs9619H5HF04eSEO3c0uYXef+9SGlbfVO9lvtbaYPMAjdaKcF?=
 =?us-ascii?Q?Xnq7dFsGl39Anbf2XlZqn8BZuaL5pY5lgaH7Uo2S8/P6UGz/CCC+lJv6Qrxc?=
 =?us-ascii?Q?lqwU+7ZDSdtXgz6a1g3b3O3H3I9VRZ6+vfO8orEP/DsdXENKyGYQhVAQFiEY?=
 =?us-ascii?Q?6ZTxdVdx0my1brcNCQh3DVt6wJxvb0VzrM5pcfppFkNBJxcIzzyyE6/MRCp7?=
 =?us-ascii?Q?68/yXHr2tSb7L9igBYulnP+FUTCQtJRWnQVyLQOdwcfbLd+ztlmJfgdH6lx/?=
 =?us-ascii?Q?t505kJOxZyha9oEO/2DgFgPvuuUA7A67h4ebTiwUcbz9R44pQxTm3btnRyFQ?=
 =?us-ascii?Q?ZQbjQn4CgxV9RO+n7ifuRrOnf9pofGgifDJG/PwHwaB3wJ+Bxha1iL8FYj4e?=
 =?us-ascii?Q?kG2SYtrEuK819MbdxvJ5V3q2iInqTzRdeiepTj7diZLy1qSxzxOOiNfxbwSD?=
 =?us-ascii?Q?F3qZ3AjtXL/69CfczeypSkyipBV2RqSdKh6z56C5/M5OQEPQW/otuqBmU1i9?=
 =?us-ascii?Q?dkj8bMHyVHmI1Dm9hbDsd1luL2BoNr7x2gyJS5ZrKhqlXjZnD3FCww4JwUb7?=
 =?us-ascii?Q?doUVnshUW9C01n7teOc251vr6f3sTf+A0fqJx5733wQ2AKc19Kngd9NRzycv?=
 =?us-ascii?Q?GupYeuahjS5W6ksfTBzQ7TRPUe5qA2hxdnHycNZr1NYUwiyHHB8rurW3bKSj?=
 =?us-ascii?Q?N/CRMXLF8ZgGroirUI8yOp+9NQx1UEQn/55JsCo0CNJ08HTVBlNu+B9B2+WC?=
 =?us-ascii?Q?+yL26Wz6AHjylaih+FY4SOqOHFPcDMGC7sitoJpy6o9h6P7uK+eRlgFbNtYl?=
 =?us-ascii?Q?AboWzrzE/v7pn1F05P7unoBoCVtNFpO4lbhG6KSd1fx8KU/MNg/QYAmodM9h?=
 =?us-ascii?Q?EAVy8MQzWCjQNm9vQAfKVdV6qfqHVFC+b/rYTfwT2rbdc9IVkjqGiF7WeQfJ?=
 =?us-ascii?Q?vYrg+F9ZsWEHgkHMG5jVeQeFJcIjmyx7OvBCGeINLr/NFISf/ByyGlWSwrNA?=
 =?us-ascii?Q?V3QTsCwev/aVwKng4clatHIjtsk+1wU9SYKxypPu5q4LXkequhht78fPIeQG?=
 =?us-ascii?Q?z5IixpsUD8aS+Gn9jMPq0UsNSSgzsxLmOvFUXYiDXSo1oXRTY0CeZDWa0wT7?=
 =?us-ascii?Q?i5iqTHr0yXuqUKzJ3K9gQplNNzG2k3ATVTzupfqSV7oecKCb0R96SivtZjQg?=
 =?us-ascii?Q?f2Xx5h82tYrVqmIKcUlxKNsWvxrEtD69gR0jFNoOYu5UiSqwFEjtCzrP/COs?=
 =?us-ascii?Q?pI3XF3glRtf3udx/otq0s1dSsp2axPxuLO+gOHhB/aXMvHd+wduw4UWrDx5S?=
 =?us-ascii?Q?xkxmxWXCiYlJhNf5Y6FpkQq1MJ5TIJwCpanAT1tEkL/v8jxC0z8XZgjJe8aL?=
 =?us-ascii?Q?vA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D795D838F271D246A8D9EC2AB240255C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YNvI6cXRX5TRj2eBX2l3d8fxnlNyriG0tOmD4AL7OqvOixbN7PK/QCQrlGr/TeZrfqpeKKNKA4MFcSgv21wIboLKVUFR3LRKgecEAtvnFPRtUNdw0N8x7vIcLMceICRCDzBcKgm1BoAAg3ZLyT5+I9pfgdD2oPowkEdScebFBQmxh48id5b7DnrUeniGiItGO57tInJeB+TAXGKas1j28BF7ax1tziXLM74NVByC4cLmPG7PcJhZyRaF9vQoujJKckpx6/I6x7zD7NQW2ec9JKk+pqlCAKMeO21NNijoQC4FGdkXC8xA9wr3t7azmhQt8N3bpprQ0Xw6WOwKumtrGLdEYNqKCMha9jyurFY/FQ5ESq1Se/v48zXRrJHyQDmJBQfbgkLXia8Zu7U/hza4tap1SqaAZ0n8ecolLXOmcjnsFZTCu2n8H6Q1VLBcgmYHTuGP05YKrQu0BuAMIhUE8TOmYK+PEsrPgtxTR8/gdnmIQuq6E4m1VffqjPFz8VQE4m8ylPDiJxSt/l4VcLmvB3/drkGZFPmrh/0pgzBP/C5sA4L7eZcZpM7lVmcbNVFiflcl34tANKHBSC/fVHS1NK8E2EaIoRAQbYwB2t2RX647NhT1b4i6fYg8Lcuex3h6BfeZa77IcFpReaZaaEJr8FjwkxcxjP5oxA2gXjnQBWEZLRZZsUQSsrFfhgMrh/rwUjyQfPGImH6F1YJjCdPzO8YBeeUj1J2n1kZTEX109hS3P7iaUVKlDPSNnL6tS+79djBpFwx+LRC0Tt/5k163iBw7gOz32E1i5sdr2THLC541egmhUbLeKlJwFFc3c/6u
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fecf3a2-0245-4502-b489-08db0914662d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:05:42.1168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/py6smnJaNSWFvVL+UTYzUryrkqgrVwRpYVOVcNiwbMA1/AT+W+qiRQZZOC3I0P4HLzvFtqMZhwPMG1ncMO4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:32PM +0900, Shin'ichiro Kawasaki wrote:
> To decide the first IO direction of randrw workload, the function
> zbd_adjust_ddir() refers to the zbd_info->sectors_with_data value which
> indicates the number of bytes written to the zoned block devices being
> accessed. However, this accounting has two issues. The first issue is
> wrong accounting for multiple jobs with different write ranges. The
> second issue is job start up failure due to zone lock contention.
>=20
> Avoid using zbd_info->sectors_with_data and simply refer to file->
> last_start[DDIR_WRITE] instead. It is initialized with -1ULL for each
> job. After any write operation is done by the job, it keeps valid
> offset. If it has valid offset, written data is expected and the first
> IO direction can be read.
>=20
> Also remove zbd_info->sectors_with_data, which is no longer used. Keep
> the field zbd_info->wp_sectors_with_data since it is still used for
> zones with write pointers.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 14 +++-----------
>  zbd.h |  2 --
>  2 files changed, 3 insertions(+), 13 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index d1e469f6..f5e76c40 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -286,7 +286,6 @@ static int zbd_reset_zone(struct thread_data *td, str=
uct fio_file *f,
>  	}
> =20
>  	pthread_mutex_lock(&f->zbd_info->mutex);
> -	f->zbd_info->sectors_with_data -=3D data_in_zone;
>  	f->zbd_info->wp_sectors_with_data -=3D data_in_zone;
>  	pthread_mutex_unlock(&f->zbd_info->mutex);
> =20
> @@ -1201,7 +1200,6 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
>  				const struct fio_file *f, enum swd_action a)
>  {
>  	struct fio_zone_info *zb, *ze, *z;
> -	uint64_t swd =3D 0;
>  	uint64_t wp_swd =3D 0;
> =20
>  	zb =3D zbd_get_zone(f, f->min_zone);
> @@ -1211,17 +1209,14 @@ static uint64_t zbd_process_swd(struct thread_dat=
a *td,
>  			zone_lock(td, f, z);
>  			wp_swd +=3D z->wp - z->start;
>  		}
> -		swd +=3D z->wp - z->start;
>  	}
> =20
>  	pthread_mutex_lock(&f->zbd_info->mutex);
>  	switch (a) {
>  	case CHECK_SWD:
> -		assert(f->zbd_info->sectors_with_data =3D=3D swd);
>  		assert(f->zbd_info->wp_sectors_with_data =3D=3D wp_swd);
>  		break;
>  	case SET_SWD:
> -		f->zbd_info->sectors_with_data =3D swd;
>  		f->zbd_info->wp_sectors_with_data =3D wp_swd;
>  		break;
>  	}
> @@ -1231,7 +1226,7 @@ static uint64_t zbd_process_swd(struct thread_data =
*td,
>  		if (z->has_wp)
>  			zone_unlock(z);
> =20
> -	return swd;
> +	return wp_swd;
>  }
> =20
>  /*
> @@ -1640,10 +1635,8 @@ static void zbd_queue_io(struct thread_data *td, s=
truct io_u *io_u, int q,
>  		 * have occurred.
>  		 */
>  		pthread_mutex_lock(&zbd_info->mutex);
> -		if (z->wp <=3D zone_end) {
> -			zbd_info->sectors_with_data +=3D zone_end - z->wp;
> +		if (z->wp <=3D zone_end)
>  			zbd_info->wp_sectors_with_data +=3D zone_end - z->wp;
> -		}
>  		pthread_mutex_unlock(&zbd_info->mutex);
>  		z->wp =3D zone_end;
>  		break;
> @@ -1801,8 +1794,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *t=
d, struct io_u *io_u,
>  	if (ddir !=3D DDIR_READ || !td_rw(td))
>  		return ddir;
> =20
> -	if (io_u->file->zbd_info->sectors_with_data ||
> -	    td->o.read_beyond_wp)
> +	if (io_u->file->last_start[DDIR_WRITE] !=3D -1ULL || td->o.read_beyond_=
wp)
>  		return DDIR_READ;
> =20
>  	return DDIR_WRITE;
> diff --git a/zbd.h b/zbd.h
> index d425707e..9ab25c47 100644
> --- a/zbd.h
> +++ b/zbd.h
> @@ -54,7 +54,6 @@ struct fio_zone_info {
>   * @mutex: Protects the modifiable members in this structure (refcount a=
nd
>   *		num_open_zones).
>   * @zone_size: size of a single zone in bytes.
> - * @sectors_with_data: total size of data in all zones in units of 512 b=
ytes
>   * @wp_sectors_with_data: total size of data in zones with write pointer=
s in
>   *                        units of 512 bytes
>   * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2=
 or 0
> @@ -76,7 +75,6 @@ struct zoned_block_device_info {
>  	uint32_t		max_open_zones;
>  	pthread_mutex_t		mutex;
>  	uint64_t		zone_size;
> -	uint64_t		sectors_with_data;
>  	uint64_t		wp_sectors_with_data;
>  	uint32_t		zone_size_log2;
>  	uint32_t		nr_zones;
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
