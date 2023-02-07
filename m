Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A74C636CD
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjBGOHA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjBGOGu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:50 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0470838677
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778803; x=1707314803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F0sJutzy26DrnAvBDRIgtoNOd1IDnfWXN2tgJZruJPY=;
  b=IXiYMoOkUDC8AMeuWqpNcFGd7oxMbh69DVpHVl3jNm8T7qLPvFQURk8R
   ci99fwC3THTDreYxDqaW+haupPQ07przRBJfm0nFZ3NsKv2bhaasN3vYS
   QNvbDZId/KmtXJvNnAnC2My0/C3Ec8bSTHHfN4TLECVU0wpiN9kMMm0yx
   Ain4uDt2/kpRVFDmAg03tLaN0S30qK9LwG9At7EPFYtPwcZ7xlCozRjA7
   OAlV1mfTUu9ZO9uXbyVrcDlMNbm5thd7wl/PV2Kis4mLhM49wx8zg+5I1
   ZIo9TlM8coXVJ5rEFU8MJdNNf0oOSRpA0chgBQTV78S8HLHelY7dbowyi
   w==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="222753310"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:06:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFQU/zMtEVxArn2lVaJNsSfZXpXejtRW8DeoxF2X69OWzPXu6hq1zf48HF2CN2qwo5ZXHIu20NuRqn+HyFIxtr9bwHr8Tb+ZES2egewDK9NiBV4YNxuVQ11pawJknkrW3zG8w8tL6c5hYskpgy24gym1y85rojQWIJd3oE0v4ikL/r9OfvM8GcCajPTTPkwDE8MV6gid/0NMZQ8qd1Mj8oRlPyvKyI5sEeDkSAYc1pRbt090xo3oCy2pwnCXJV6qNLft1C31bwi3+kwVLNlM1E4PDSm7ie3eys+WdbuVpFgKhuSgl7aKcT24Q01+HHH7Af9J8nDvkcM2CdACwZZ69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ELHxzKi8ZSdDqNKF0vo6ga3AO4cSO0FA2h0dybAlQxs=;
 b=AkrgruB0HojrLbFDditdhTobRP4O3aD8oY+uuAsQC3AoJFrsjZDksKngGQpz0KTx8dle+qvW96h+ZYa/xNvSaUgrBlaiIn1WsdSXNFDMXXnKLy4b4muYCOOhsUZzqie2VpDRC88GRwOmL1Le8mFra1888cUG0Y2OgbS1K233Xi3A2P4CJ3nJ5kqWzgZ3L0ty7BrYiA8oCwmjq1wtPPE+giUqJLwJ2VSpXC6qZ4EXh8FC1O5fmCyjK7NWwG9O5DRNi2e2Fz99mkk8ey/YuSnxDVB9s8cR5pItTQCLFFz6LcdZxBlzGkdyh6AWphBwS9q8aJdp00uaoRelkoLPl/pAqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELHxzKi8ZSdDqNKF0vo6ga3AO4cSO0FA2h0dybAlQxs=;
 b=Mcv03qplMTzLa6Q+ULOSfemLJcMTjab3kcajqmyNqkW2iiOOjmUGcZGejLKPFw+IDW2Y/kD2BTxYSjkTwHnLalLTk/RwyLbRHA4gIaMwel3fGESLd6eiExto9dWdaGWpOei7tIqmO8A/XXWntLJxX0bkH5uf/ef9EP5On/hLlyQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH7PR04MB8455.namprd04.prod.outlook.com (2603:10b6:510:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 14:06:40 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:06:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 8/8] t/zbd: add test cases for zone_reset_threshold
 option
Thread-Topic: [PATCH v2 8/8] t/zbd: add test cases for zone_reset_threshold
 option
Thread-Index: AQHZOr64R9b5Mvdnzka+rMTOdhhSr67DhUwA
Date:   Tue, 7 Feb 2023 14:06:39 +0000
Message-ID: <Y+Ja7lDe8gPaeNwL@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-9-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-9-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH7PR04MB8455:EE_
x-ms-office365-filtering-correlation-id: 2fa24b41-f466-4d34-8d00-08db091488ae
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b13tjEgLWx1lPaGAuQQomV0OhJIVQz5uvg4Myq9lzS5znk6t1Olda8n92WUlvKETGMdkIYeafVcb128HYFEKw3K3ccZQ0PFyY6WaUL4C9sZSh12PDKzyB7LXRjyefwmXUAfFqUNCv5syjFTecW04cdwTntOJCdLc8badPZ69MJqOpwOuPHVqlUPiTGHW8T34stbKEXjghEJcmqsdIHQY3zuoCfIjCkF2gwSCvEAsWquB/9SBSiW42FALQ/6GWVko5mK7LB2twHQ/pWQ8BITnJFUy8YRwF655ibfTiRsebGSD97By3PM83tE/iY9UAD7VqnOBOfZbQV1fjE77HOsEid8t9pqPjnVs1Az9NKD1fLlq6yAxiel2cpMnt3/b2iZKaPesA9MgD2HwU4nIc88vcKOzAkH6G0exYaZ1zTPBRVT3S+EEIS9MYkpZgR8s7CBvDOEyLu/9VkIo86oRIYzGV1S5FBNnbvM9t7d6v/dLsOM4lpIZXKqOPZw2om9jAPm4pSHxbsx3Zu0GzDfW1KmDcW4y/hAhhoRI+nplS8hPElySi7uH8pI6hNWcvHi2r62a29mM/rML6zeV4LKZSzvlXjwvW7sszuXX88Chfeyx1aoq7apa8SlgcxA7xgW0n40q5xvm1lKhhOgtdiYDSEXYe1Sp0Pu7UIbAijnSAc1t2bbXM6EDhonJ52EFbPeTRCFxAGQDcTJoFgX5Y6lvf4AtUDwYqO4y7k9C6RolG9tlHac=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199018)(86362001)(33716001)(38070700005)(38100700002)(122000001)(82960400001)(6636002)(6486002)(316002)(71200400001)(2906002)(54906003)(478600001)(6862004)(66946007)(6506007)(41300700001)(5660300002)(9686003)(76116006)(66556008)(91956017)(83380400001)(66446008)(8676002)(8936002)(4326008)(64756008)(6512007)(26005)(186003)(66476007)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A9oxqur0pWbQy2d/uMkvFTP1YbWqh3Ui9HRx+v/xuX+4esWEgVDzKt3v/KJX?=
 =?us-ascii?Q?KEkQm7FzWBWMj/bYpdD2hktEEIP41uCMcTy6lP7B8S5cKL+c7F9PL+iuIUuK?=
 =?us-ascii?Q?dEMPbBB8iChG8lh6GFAYHf7QuyDwCudUzCBbj5GjnDohiz04ugTVdG7/VMBP?=
 =?us-ascii?Q?CIT2niwXu3gE6bJgUnavLjCqcLUoYI393+KIRPQEpkzIDOL0LgnPWxVMePtB?=
 =?us-ascii?Q?yIjmsO44n6Wb0ds9+NV6RQtY1b9UCCUzVzCmXlO+ef0Ggtyw6DWmjjor5INv?=
 =?us-ascii?Q?RJpER//OB/Tus119lBSvp/nuQfUo9Fz7WdxvNmYdEqU4Rs42X8B3n9krC8Ge?=
 =?us-ascii?Q?rGiEoWx11cVAFwlQ42f1eSimsEve+CEWVsHITofhjy+FCBY/GHgt9nmhuc11?=
 =?us-ascii?Q?KD7yEN958mTvA8IHXS7ivi0JKoxtLNlMpOgtHXYAA/tUirwy+L5sotk3Kk3f?=
 =?us-ascii?Q?K8iWLa0RD4UhCvfogOIePbXW3pYa5gKyFXMMnsma2NF8Gvm5F6kkKhYr4F2e?=
 =?us-ascii?Q?Yn+exXaTvm1eJtlmMHQSKtDEnhAx2xiSoOCdYM1mHbapzEo30+2IOMy5ntrl?=
 =?us-ascii?Q?4XUW0AOaKpXEtIBbX2G4oeFvDAk38s/GEEUmYyKh1OmdaLmRv0G5PxVhOnSi?=
 =?us-ascii?Q?lEeGWJYFc1AJnbTt7kmizXUGpVz4g9eN26h1i0ShBkSi50BTjxNOqYiUHK6z?=
 =?us-ascii?Q?BErh8QPSeMU3HPC4n2O20HPdFSEOG/lym3qarcpYKZ1HrQdSs6Pj2l68Qk0n?=
 =?us-ascii?Q?fIc7Euugt3gTFfGSzW7cBVxPxt1YpprZNl7aIO0gw7jfuImtdJw1ftdxmD26?=
 =?us-ascii?Q?cCloTj3EnQ69kWv7XTVyG/7B2RrY0Lp1lEDYBntxe4xhnEiXj+DZl3mniQOX?=
 =?us-ascii?Q?eJr45gAab025+Gu8I51mbTYKT4AcDUJhFMbv4ycQoEyOkQ7yYWj++baErgNG?=
 =?us-ascii?Q?lgLQERut8hBeYjdOIx2De5RC2QC3IGGg9VZFBlgMc0AEI+mNJuvWPj1JfIw4?=
 =?us-ascii?Q?sHI1KsaFebTXhLKuQJGbexJosV8P0PxBOFsIae6k2LUqJzW3pBmo9HEiG5jl?=
 =?us-ascii?Q?x5vzGUYsUtYNi+5Zgely852/A1VL7FVlcYeFdW2wr5gUe00qy6JzqpJ5rlwG?=
 =?us-ascii?Q?Fo+O+VrseaGqF8LNko5jToSjHiINhOofsORFDtp8FA8rjKtDYN6z5Mybd0gm?=
 =?us-ascii?Q?PB6c9rgCzKlq4I3zCrx72b1cPHjsxSPvy6RGPE+eM6aI0mBbOFdTTmzh5pJd?=
 =?us-ascii?Q?tfYAD/GMy2KTNoA8rpiLVR5fpl6EVpi/IjrgKuHgejIXAr8jhER8ZM1THhzs?=
 =?us-ascii?Q?w5YUaIircADui+UwlDgIUzKRrqv0F12lZ0bqEM7BQLQdIguRDM28VFSF0Pho?=
 =?us-ascii?Q?gOIVoIxorLhL+PXEZWtVEui+xBW1Ls153jB5xkXXz+ZQgBoWrg3YTXOBFWi5?=
 =?us-ascii?Q?Qu6OMLSIa8WDkkVVVn8nvRcMBz7eOs/xEupEpVsl+1DKXtY6m1ui5s8ux39n?=
 =?us-ascii?Q?+YsqsBANX1NExlggr67QMnLNjnTqO1AEwb+k5dcp94Xk5OUrFWg3/cfg9Z2d?=
 =?us-ascii?Q?Ec3mXcRJLsrNCarjNBcnyz6MhoRV1b5e6N+XfDTwQ6pPl/ZO750Hk9F5pL3f?=
 =?us-ascii?Q?ZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7E8DE95F68320A4486344A0DB9618E43@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +X8e51UMXMeJIV+utLEBJMor+3+PywouCzkbVXOKVgre+rh6xIbwU8xzFBCkEuDT0xprK2fgt6IjAHVJYNYPDOCW7BzLFN/uDZMUwYVbo2Gt2YiVNPrdloWQqAMg2aDuQd861REApQ6qISF2WHcj55YCYlmho0QI7L74s+R4sToAfvCvIMGR5RfQhBO9KFFrUQEHf6mgtEdVoN9PglnkKqdcGC0O/5PepckIzqvQrN8Qs8HbZoB0fCJbNAXQbSHkBoGim7VbmauVMltO9jONPW+DaLn+TNtRKfAmAuxIvcPFPDCeoDNVsvFDEZcdwIGiBnpUNs9ffQXEnxlFRv+OJxov75tUjAsv5IFnfeLPdpuTuTwO8/jevlEZ8YOpNkXjELh+APRAfkr30BcdlFx0xKpwHmhU3umLfrfXSYEADQGIzFJQf1PF5kYtUpb06Nj06SzjurAa3CRSxBIN4/Hft5QC4k2sv6d4KbzUgH0MJ5HcyKXDPGKZZUqDoM/Ab+LWdoFFS3rMfj0fAlmoFV+fwusX9HdqfdMDDMIssWhzPe3hp37nj33YjBTpSvysMFRZL4wXoJaJdZG8PmtJpo5YEA3tmic1NAxSYN/CsnqxPHSvsPfCsmcHSXLFla4gdypHDN6jTTv6HbTSHaM712nsCfLJgcq20B+QKpROEVd6/OthhWeSI/jGIe1t/v9ynk9ye+GWvNlH6guMYM/WSEfWuy99fxYFJ8LFXeNYEZ43+3oG7P7rVQF99iknXjDy4XpWUqeLIJ7L07E4OES1LrrIEiVs7NYcNf1FNOr49os23IJiQ/KWa3dKPKqmRTTXze9e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa24b41-f466-4d34-8d00-08db091488ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:06:39.9881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SJoXvYF0P58j0jZsAkUdW/eELBfp2ClLhOh4guWtEJPDqUuD1+rUgyxhs/JR+X4E+aGLT2DmdFiUhgtuxvEMCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8455
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:39PM +0900, Shin'ichiro Kawasaki wrote:
> The zone_reset_threshold option works for multiple jobs only when the
> jobs have same write range. Add three test cases to confirm that the
> option works for multiple jobs as expected. The first test case checks
> that different write ranges are reported as an error. The second test
> case checks that multiple write jobs work when they have same write
> range. The third test case checks that a read job and a write job work
> when they have different IO ranges.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  t/zbd/test-zbd-support | 56 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>=20
> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
> index c32953c4..893aff3c 100755
> --- a/t/zbd/test-zbd-support
> +++ b/t/zbd/test-zbd-support
> @@ -1305,6 +1305,62 @@ test60() {
>  	grep -q 'not support experimental verify' "${logfile}.${test_number}"
>  }
> =20
> +# Test fio errors out zone_reset_threshold option for multiple jobs with
> +# different write ranges.
> +test61() {
> +	run_fio_on_seq "$(ioengine "psync")" --rw=3Dwrite --size=3D"$zone_size"=
 \
> +		       --numjobs=3D2 --offset_increment=3D"$zone_size" \
> +		       --zone_reset_threshold=3D0.1 --zone_reset_frequency=3D1 \
> +		       --exitall_on_error=3D1 \
> +		       >> "${logfile}.${test_number}" 2>&1 && return 1
> +	grep -q 'different write ranges' "${logfile}.${test_number}"
> +}
> +
> +# Test zone_reset_threshold option works for multiple jobs with same wri=
te
> +# range.
> +test62() {
> +	local bs loops=3D2 size=3D$((zone_size))
> +
> +	[ -n "$is_zbd" ] && reset_zone "$dev" -1
> +
> +	# Two jobs write to single zone twice. Reset zone happens at next write
> +	# after half of the zone gets filled. So 2 * 2 * 2 - 1 =3D 7 times zone
> +	# resets are expected.
> +	bs=3D$(min $((256*1024)) $((zone_size / 4)))
> +	run_fio_on_seq "$(ioengine "psync")" --rw=3Dwrite --bs=3D"$bs" \
> +		       --size=3D$size --loops=3D$loops --numjobs=3D2 \
> +		       --zone_reset_frequency=3D1 --zone_reset_threshold=3D.5 \
> +		       --group_reporting=3D1 \
> +		       >> "${logfile}.${test_number}" 2>&1 || return $?
> +	check_written $((size * loops * 2)) || return $?
> +	check_reset_count -eq 7 || return $?
> +}
> +
> +# Test zone_reset_threshold option works for a read job and a write job =
with
> +# different IO range.
> +test63() {
> +	local bs loops=3D2 size=3D$((zone_size)) off1 off2
> +
> +	[ -n "$is_zbd" ] && reset_zone "$dev" -1
> +
> +	off1=3D$((first_sequential_zone_sector * 512))
> +	off2=3D$((off1 + zone_size))
> +	bs=3D$(min $((256*1024)) $((zone_size / 4)))
> +
> +	# One job writes to single zone twice. Reset zone happens at next write
> +	# after half of the zone gets filled. So 2 * 2 - 1 =3D 3 times zone res=
ets
> +	# are expected.
> +	run_fio "$(ioengine "psync")" --bs=3D"$bs" --size=3D$size --loops=3D$lo=
ops \
> +		--filename=3D"$dev" --group_reporting=3D1 \
> +		--zonemode=3Dzbd --zonesize=3D"$zone_size" --direct=3D1 \
> +		--zone_reset_frequency=3D1 --zone_reset_threshold=3D.5 \
> +		--name=3Dr --rw=3Dread --offset=3D$off1 "${job_var_opts[@]}" \
> +		--name=3Dw --rw=3Dwrite --offset=3D$off2 "${job_var_opts[@]}" \
> +		       >> "${logfile}.${test_number}" 2>&1 || return $?
> +	check_written $((size * loops)) || return $?
> +	check_reset_count -eq 3 || return $?
> +}
> +
>  SECONDS=3D0
>  tests=3D()
>  dynamic_analyzer=3D()
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
