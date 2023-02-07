Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8097AC6379F
	for <fio@archiver.kernel.org>; Tue,  7 Feb 2023 14:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjBGOGE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Feb 2023 09:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjBGOGB (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Feb 2023 09:06:01 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B5E44B6
        for <fio@vger.kernel.org>; Tue,  7 Feb 2023 06:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675778759; x=1707314759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TSjnxJQhVqX70qQrcKzi94ziwCl80ciOjXCKAcqGKuY=;
  b=PmdMUJOq7Uw3U1yOLYrpKYjru1YL02KltfqI3oOV4gAkZu3PWNgLhAap
   w96vleHIiLhnts9kA6LCjxcpjcTi3jtBeuiwfPk0KH5Jgy41NYwrvYuuA
   X4gRISY6Y+q6Tno85RHBeR9XqWu3K/8jWKP10/tshkqA0BzOIa3ugkIQZ
   ZsRL2rKrBPExdxQyMN57/khIS/fDfAf1U4aknIeBuTyJcETzM8mFPL9go
   tUiNQ7XXnN1tg55YOGPGmQvQF/4Jb9JR3gsCYMn0tXKFYqyLRB8BwYFfM
   ptTGsOlpr9XfDM2vt94dF0UDTrcs+EJ7WJNU6e6lB8S6bzhni4YGjMwJD
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669046400"; 
   d="scan'208";a="227685228"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2023 22:05:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elfavTqp62vSPYdPhBZm0shkzTqKIh9O5nScqKV+qlkbOatNNB6uhzcnxyr9ICYWTHuv0+TY4ulXze8ZIlP1z5kAixG4NubsF/iCdrDog9F78L8YIReM1tIff62I0oZodUGsZpcH1y3Tg+NqWZWUWzzfZRRfohlQsu4AZ8s2snofOkZisQ+JpFH22HMAX7JwVABpRFaR8jAO0nw4/R3VZfyXyiWn+7T1LiHRwj5xhL/uXPLFeCTozgA4ML7Zy8MLNBXBMmQoavMoBZNcBLOwDS3rqWU6n6/CFDLAD5UG0Xo6gDOtLPJMfpx2vWl6WdXAds94ubOXem2o1EnbDQWuWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGhzvr/dU47w+R3v6TeY+kphc8aafGSc1AR+jYGnFLU=;
 b=RKUSOTADYxQzi8yb+yiRWVfGQOOq8997qekPSPQYbnBJbQSewLrbZZmc0fI0Oy8und7A8SbiDKWp8FiWAARI4vhdw/TP1zoJaFFT+2+WvNi4yT1CD+kBgOO4ZlhJi+4PCaTBajcGnznwPk53+FMEvqOQe+EVwHnQJY5vGqmqiWeS5KfYZcITtOejz+nB8ARxhZzyqPa2a8sFm4P28Xhey7P4NoPFA+MStWkFAWOgaBn98FR89Cwiy/tN4qTp41PMgAsweizCcUP8dGegUQsjzKVbE3YzrYxwg5ccvv6NPJ0bw5yYTbK1Xi885Oyu2vKZyC1qz97oC4zuGGcewy1bYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGhzvr/dU47w+R3v6TeY+kphc8aafGSc1AR+jYGnFLU=;
 b=k2f6Qucw22Kmp8FoSpTlg5PLgnhWpGRQk50+mUXpLTct+FKhCYOA+UuSwbf5kZDjgNXC7BqZIyhSJN0tFV/bEHFRkPx+USJ3MvqN9Pji+kZorWnAOMyvfCKsjKcVCUNdy1tpKX3knfVRDV7AViQgWFzJoLOhzg+iM6CnMV9DHCY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB7042.namprd04.prod.outlook.com (2603:10b6:a03:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:05:54 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Tue, 7 Feb 2023
 14:05:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 2/8] zbd: remove CHECK_SWD feature
Thread-Topic: [PATCH v2 2/8] zbd: remove CHECK_SWD feature
Thread-Index: AQHZOr60/QfhTCEgTkWr+lzcK4YQEK7DhRKA
Date:   Tue, 7 Feb 2023 14:05:53 +0000
Message-ID: <Y+JavajCv6AZpHF9@x1-carbon>
References: <20230207063739.1661191-1-shinichiro.kawasaki@wdc.com>
 <20230207063739.1661191-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230207063739.1661191-3-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB7042:EE_
x-ms-office365-filtering-correlation-id: 04fd30af-701c-4d27-922a-08db09146d41
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ze8erykTsDr0meCzEVdoR3NT00JTA1FZenJLNgOUtNdWZACH/WbSlKMaEeyTagkmgJ0jydxlMgh4FmiVIC7onLoFNxOAN/9GxQfR3gUxTWuGJCu6EgwSxTN0MenXqC/aooz01NqaAXjb0Q4G71GTc7cplO1pYhB1XErZsQw+4cZOnq+PtHtBxXimEiFcxI0tvbbtmugxu4CdmEnYoNwhx7JOr4EJhlV6VxNu29Hu1x/QuQxDovge5qraD8+IpTnMK/EvfXal6lD2oh9bign57a+etEz28+oB52eW3uIV3y3/ZA8m3KlmemvSdecdawEf7dpOBpZKfhzpub64J3+/luZsS+nNHZvOjSvBRJNi3+w9F3Nnr0OITYMphtl9qkk5U0965h0XvWUDMW1m2gOaZBQ+rAhqVV4Drocu6d8Sf17XyLOUZF3BZVEGT1oJUBDMqAnPw34+wj/lDr/0TKrikBttb5rqTPeb5ERA7ftD9BMCu2lESAaE55ONoPYl8rL4jAkZrDfYtDE8eZ8P2Jn010vYgC9SKOTI4qsZIuyV+8CVngE84xy0eXqxIv1aoFIJeYrFgw/3a2aSzIt0BCpr7pZfUlqRLMcq5legs+dBZWEaZf2eYFQ0B7orZ3byiU4FGXOS1bSAjsx+1e4viscDsO2L7T/G9VUdAhxDNN+aABy5lFYYUdBCKXtL5IvKhRC2x3Vr6K8496P3Ls+vlYMEnT0rwCOTzAUEwjtKIcyL4gQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(38070700005)(86362001)(122000001)(66946007)(54906003)(316002)(66556008)(66446008)(91956017)(8676002)(76116006)(38100700002)(64756008)(6486002)(4326008)(478600001)(66476007)(5660300002)(6636002)(2906002)(6862004)(33716001)(8936002)(41300700001)(26005)(6506007)(186003)(9686003)(6512007)(71200400001)(83380400001)(82960400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/23b0rypTSt8wE7XulqwRhdsyYn71+jX6rDzVIEWCayfG2+LlUzVkG1ewQqR?=
 =?us-ascii?Q?kHt0Um/08XEeffhgdaws/h/yCyZa9PkwyHBA7A1Cann0Ih6HxU1sZzg0SD+F?=
 =?us-ascii?Q?ybMqXfQ4SiUy7UHnz9E7f/chDTheg3klUdOAr5esbuVK0qnGnoNUn2B1GyLc?=
 =?us-ascii?Q?jp7luP8y+ezzXgNtXgo+ZMJDBidN5dV3pZQLTdXtBxSwls3gSemNqL1+zQbl?=
 =?us-ascii?Q?AwkPoVQW2Ahf1gObX1zw90zrDvC43JnXUjQWiz1Do5pv9JEuOvVwoKSIFn1C?=
 =?us-ascii?Q?T5KlKO3VMp0Uy3quAoQYZY6pttKWDBV65kCl6rBmleT+SfBLWv7LxcV9JKTA?=
 =?us-ascii?Q?1NKOpPWZ0kYDjgKHdMCEHJ3LuHm5/wYHVSDzGxcXqTX16NtpUE3V5t6F6gS4?=
 =?us-ascii?Q?A/V3jmwaat5A/bpycs9KU9q5Rrls9ZUFaUzSrUJuKTkGYdfXQ/NnfuUkdali?=
 =?us-ascii?Q?0MSWyImOLtKZvBm6FjxQD+CFqGAgKV3c/uKiC3gcUoHn2X5YjFK9BTdry9U3?=
 =?us-ascii?Q?pzo5pYt/4+VKzzfwAawatnSASAS3QpowXIhA7NS4V2eQ0IUC2mhM4CSi2Ia0?=
 =?us-ascii?Q?+A8L60FJITWmSfi7pdkJVDYiToQmduW09+FpyzA4WsmUIZ05IEfWbXWChi2P?=
 =?us-ascii?Q?OAb043kPHo4EetB267ZBW472A2HK6SA9plq5w0NGUGTd+9jAS7B18vsWjRBw?=
 =?us-ascii?Q?xTd2Yy/Et7OD/cvKZlLVzaD64PDohrTouvtho75qundxflbei+uumea7waKq?=
 =?us-ascii?Q?bfDUnYkYkV/YkG+dMGFRwf1S+9j2VhYCbSMuTQ2a0J3ft9rN+Idl73tb6Tj6?=
 =?us-ascii?Q?vuwjPZeyZgqibweJP2TkCGodEld4zkFTGzd84Dv56TQTr55UFrQBtIXPcg7g?=
 =?us-ascii?Q?yo1WVAlZbqY1ERDuRiq1tPlw+7Hnm94CkHFe0BrsCvnwGLQmeVpZvtxndKuX?=
 =?us-ascii?Q?5w6PbhmIofbHuwAmDq8c4njW3h1qpdQRgaOnqRvEwkAVwtCeErVNQXXnLQiX?=
 =?us-ascii?Q?gARO/cLyeWSzClJvED8Pqy2nvfA2F4iNjENj7Wbu4DKaRtux057hhTa9SomM?=
 =?us-ascii?Q?YFz+Jzf31O4H4QTKK/d85zgOVy9l4xwSt1UNGYaxYgV0RUikHMQbcURbvahY?=
 =?us-ascii?Q?hIzU3MGIG8wpOxis1F840RwPxl1aG9GDlkeUSahfCr8M04o8IgkwN/A7lfMu?=
 =?us-ascii?Q?Vz1qOkBlqZvn49Ab9bAvqG8PmD+Lq3v9Tl/51c5HaKXy2kCbRcIqZvYpYx8Z?=
 =?us-ascii?Q?JL2gMPvXoMEiEu5qrRjLn+haVg36dH37gvUrq5KaEHv7ctEm0X9VL+/YaLQn?=
 =?us-ascii?Q?mm/+2oHnWMVggVRNPsQe7V5PkBEMkQ7MV6rKwdCOHNXRO/vNFRISxhY9dt8H?=
 =?us-ascii?Q?7kRSkMWHg+eHo8gQBldERF/7z0fPyI2LXQkom9NEs1DsBufGUvnIZ5+6Xtih?=
 =?us-ascii?Q?ltTCoJGA5Uw6Kwi0iJVr7Gbpe+Il8y1Ujnrt8cLa35/OD1eSblP0rHrzTnLn?=
 =?us-ascii?Q?KfzO1YdzBUfb3nOPvu5aBoYAuGJleWXwkPZoGuKwUn8QFwW8JnSfasRfzN6P?=
 =?us-ascii?Q?xM5rLBEEi9C+EreIEhi+/ETq5oE5Epzm6VcMX77XOEZMSqK033yu0C2+zKfi?=
 =?us-ascii?Q?xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B91BC1251B522A40AE27293E3FE39CEF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WFwlCZHZfNOTb/a3AmzI75KVVWhjwWR+frz5/pUSBjYhzAR0E7yqbh3yVCShF1aQMdWBlUKGRrroMm+uuMAxzjDRCfHhwSXR1wWnIcZTxh1T2RI6c9bdCkguXgtuPulOQ4DuERR+V7gM4Mg8iKLguXwLjgoug4H64BhJEmEigunzSAhr0Wu8fc6fuNUQJxuN9cQyqWZJfYgOZPLcbPkIK9dAsXPW+GvicWt/jFJBdydck+bHA1MKVSd8IkBeB1ADI0FEtZQUrw68xT0H6DVc+I4JXzgBOadlZ98oW/Dd0sEc2R92ed2FFI4r5zut0pVo5WJLKtYmjGLNaQWuKhwpnEW3Q56IsEPJb166n2gcPTZywl93UaK1XIA6/KkzK3ojsJItVFPcp3HElbApBbsZnpbt3q7NxkbcgK9tsnAtUpTRlygVIvBnSExmmHGB3/H76+cILs3EJkF9bOH6yKyBYrzME2/5ye8q1rTVKivbYRqEhdE/4Ndn+ZGYc7lJdX4obhgg/ZvgqBJ8GJUnXRTYJS3OSiid0CodlqDGRktvfD05c5IF/GJhP8Qdusir9AQIxA8lZfb1qxsaXeckBNQCU/sjsmdWQwn1FUpjESaIcwOfqoDhIbWf383T0QN+lGBh9k2Y1qgcICjYyRp+fcqtslXZ4Z9liN60s8M1prvMMLr4QR6EXgfaiiEu9pQg3Hv9dhW0chyXplM+doQhOs4MwzSlVej3NHahJVU0hKBSQrNDuy8Un02TnOYZKbDSOH2/xDwlDGBpAQPw8tFcKL7lg7cf5Ekedbo37k157uVi02b3aVqCjGYwayNZ8ax3A8wz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fd30af-701c-4d27-922a-08db09146d41
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:05:53.9441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9JQP4P49DtbkJMWYB6f45ytGZC6l5+8VoV/Do6oNk42S4bziMU8iz41Ps5rVyCl9hN8Jn23OVaHzCogrUE0jhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7042
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Feb 07, 2023 at 03:37:33PM +0900, Shin'ichiro Kawasaki wrote:
> The 'sectors with data' accounting had been used for CHECK_SWD debug
> feature. It compared expected written data size and actually written
> data size for zonemode=3Dzbd. However, this feature has been disabled for
> a while and not actively used. Also, the sector with data accounting has
> two issues. The first issue is wrong accounting for multiple jobs with
> different write ranges. The second issue is job start up failure due to
> zone lock contention.
>=20
> Avoid using the accounting by removing the CHECK_SWD feature and related
> code. Also rename the function zbd_process_swd() to zbd_set_swd() to
> clarify that it no longer works for CHECK_SWD.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  zbd.c | 38 +++-----------------------------------
>  1 file changed, 3 insertions(+), 35 deletions(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index f5e76c40..b6cf2a93 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -1190,14 +1190,7 @@ static bool zbd_dec_and_reset_write_cnt(const stru=
ct thread_data *td,
>  	return write_cnt =3D=3D 0;
>  }
> =20
> -enum swd_action {
> -	CHECK_SWD,
> -	SET_SWD,
> -};
> -
> -/* Calculate the number of sectors with data (swd) and perform action 'a=
' */
> -static uint64_t zbd_process_swd(struct thread_data *td,
> -				const struct fio_file *f, enum swd_action a)
> +static uint64_t zbd_set_swd(struct thread_data *td, const struct fio_fil=
e *f)
>  {
>  	struct fio_zone_info *zb, *ze, *z;
>  	uint64_t wp_swd =3D 0;
> @@ -1212,14 +1205,7 @@ static uint64_t zbd_process_swd(struct thread_data=
 *td,
>  	}
> =20
>  	pthread_mutex_lock(&f->zbd_info->mutex);
> -	switch (a) {
> -	case CHECK_SWD:
> -		assert(f->zbd_info->wp_sectors_with_data =3D=3D wp_swd);
> -		break;
> -	case SET_SWD:
> -		f->zbd_info->wp_sectors_with_data =3D wp_swd;
> -		break;
> -	}
> +	f->zbd_info->wp_sectors_with_data =3D wp_swd;
>  	pthread_mutex_unlock(&f->zbd_info->mutex);
> =20
>  	for (z =3D zb; z < ze; z++)
> @@ -1229,21 +1215,6 @@ static uint64_t zbd_process_swd(struct thread_data=
 *td,
>  	return wp_swd;
>  }
> =20
> -/*
> - * The swd check is useful for debugging but takes too much time to leav=
e
> - * it enabled all the time. Hence it is disabled by default.
> - */
> -static const bool enable_check_swd =3D false;
> -
> -/* Check whether the values of zbd_info.*sectors_with_data are correct. =
*/
> -static void zbd_check_swd(struct thread_data *td, const struct fio_file =
*f)
> -{
> -	if (!enable_check_swd)
> -		return;
> -
> -	zbd_process_swd(td, f, CHECK_SWD);
> -}
> -
>  void zbd_file_reset(struct thread_data *td, struct fio_file *f)
>  {
>  	struct fio_zone_info *zb, *ze;
> @@ -1255,7 +1226,7 @@ void zbd_file_reset(struct thread_data *td, struct =
fio_file *f)
> =20
>  	zb =3D zbd_get_zone(f, f->min_zone);
>  	ze =3D zbd_get_zone(f, f->max_zone);
> -	swd =3D zbd_process_swd(td, f, SET_SWD);
> +	swd =3D zbd_set_swd(td, f);
> =20
>  	dprint(FD_ZBD, "%s(%s): swd =3D %" PRIu64 "\n",
>  	       __func__, f->file_name, swd);
> @@ -1677,7 +1648,6 @@ static void zbd_put_io(struct thread_data *td, cons=
t struct io_u *io_u)
>  	zbd_end_zone_io(td, io_u, z);
> =20
>  	zone_unlock(z);
> -	zbd_check_swd(td, f);
>  }
> =20
>  /*
> @@ -1866,8 +1836,6 @@ enum io_u_action zbd_adjust_block(struct thread_dat=
a *td, struct io_u *io_u)
>  	    io_u->ddir =3D=3D DDIR_READ && td->o.read_beyond_wp)
>  		return io_u_accept;
> =20
> -	zbd_check_swd(td, f);
> -
>  	zone_lock(td, f, zb);
> =20
>  	switch (io_u->ddir) {
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
