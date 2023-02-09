Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA7EC05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBIHyL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIHyK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:54:10 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E6724126
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675929249; x=1707465249;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IaYpqxM6bD6jj1i2XnkD1buEMM2DqiTZ+DS+xUeMtmc=;
  b=ffxmHkpm6GS2w3VUGUb+2y1wXMDnYY2+M2THsX2INlJZx2AVSewSq3Y1
   m9Oz7wgzTa482D62aBeGDessp41i9C/PdJzuAMFsrsjliFBNWUSdLjVqP
   fksM9OIZz1qX0Hhrt3TKImfei4DXrAG/DTjS296PQVXu4ly95DJrMdcMY
   5cHs4AzI1kXaMMJjgqHbLg+a2dLgU2tniAHULkIOHSeOk7Lmzc6PQXBKL
   uJLChoFq5aj3lNMltDYc3AbTGjrk1k0A7JX88iFvV4kVZYFh+ifFMNx6I
   CO2lynZtkwpF5IB1mMaXk26bhMMTtlIJxe2iv0xZ3weeTIfHkcZDx/093
   w==;
X-IronPort-AV: E=Sophos;i="5.97,283,1669046400"; 
   d="scan'208";a="227856138"
Received: from mail-dm6nam04lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:54:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClJWSUN0MMR59ODuLtRjtUDMp4nW2/4LNmQKNQR1Od5S/Xb23zOtAqz9WIDZkDspJMcS36YmBSUNgbSjHdJGJf7icXOmE2CfHiYgFc9AzUSudEvaak/3xRHbjdmG/KhExah7pVWnFbKezC5gmHsMJ2pHwbD2TZpzv+QasSqE2Fw9EF3++cMpogsWtEdFPcWeD6nR1F94R5LCLH2Yf6I3E1td2KOXKnSdahtIFCseqOVm7ofrrKbYng9wP1GyZPSqoYLuI+2foUMf/GTbnGKz7X4FTAgZ9Oy4JMQEI47XuVxt0HAcwjCVV/bgujTNa1FYOlQ+3kzp3GHUUcQc+h1+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siA5YKUG0vLQS98I0asWgO6f+8EoGfNrY7yZ4r9kyI0=;
 b=CPwjxXErb5wpSbV/vIWrVUpVGBRWfbwXBc408YHVzIsCMN5hw9qf1+xyWVJkc31rOVW3RUXby+D+FLYMn9KW262zZWIfTlyFOPuzYLnVgFm7z201JAbu4BcDS53B1l3BdPbUDZEMm4UdOW2zD87LTP49P6iJQa7Wk3usRopibqmPpNYn4zrDamSeS4i+z72RAeB70aTIYscsY8YdsLGjTx3rCTDpL7Riu7/I4jhWe16ir1ea5L0+2e65uufJsVXZY/2KPi8BH3MQMzkwnltLuCY6h+nUk2VEj0DkxxQkFX0NbV7wvBhCsLqt6NDZhP0DBJgxGUKVugl3uBoiSqqKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siA5YKUG0vLQS98I0asWgO6f+8EoGfNrY7yZ4r9kyI0=;
 b=raKITbLCO6U1OVQMXmAM8ooR5VWXFwLt+BmbiystN8/ImmEXlp7JYWhU7vEu+woDw7zzxgWz6HSxiwlRUqACPIQGCv9tK6SsrR4bKPx5xaw+r/3P1bOchV+0ZKCIns+rFWhGFoVqT6BttuwM7Pi35giaaNFQnpwk7//YJjll60w=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB4841.namprd04.prod.outlook.com (2603:10b6:5:29::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 07:54:03 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 07:54:03 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v3 4/8] doc: fix unit of zone_reset_threshold and relation
 to other option
Thread-Topic: [PATCH v3 4/8] doc: fix unit of zone_reset_threshold and
 relation to other option
Thread-Index: AQHZPFVtm56dieMleUOpkFq8KKk1Lq7GPq2A
Date:   Thu, 9 Feb 2023 07:54:03 +0000
Message-ID: <Y+SmmSyuOmBZoOuX@x1-carbon>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
 <20230209070907.1733138-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230209070907.1733138-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB4841:EE_
x-ms-office365-filtering-correlation-id: c868d8d0-4e0d-4a24-f8b8-08db0a72cfbd
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RItoYRB8simU9byxHCrMHBmpGYeqENaO0odRqQ1+s7eMXn00PItI3ZG/TQ3KJyEzst2iPjsRQT57AI9v6PjUm+QffxlzanTGltp581tPrLs6MtVwsrKeUZY1ggXDm4AbXi/CGB92eT4gB028mFf8sdzc1XWEdesg1bV6ICCEWB9Wu9/fx7V0ZMmbiNtPEOe6LekDuz4Z5mf95wWI6t2P6ZSonk77Rl/d9zVvfMZ7AMRP7Iv/wULC/DPbkMAj+O45ORi0eyJ4jweIclsS00NdZ5cD/BKXL8JL0Gmog+02NfsZOJIJ7gq1LVhKXtDIhvUNmwnAF32RmGooFMpL/VeLMBG43TXmSkFKLIInZX6XwVgsUIurKtpRaIVpix/XPA3TjYpSYTNRafHARE9H0ONVl3YX1IVF/TlCUEFBc1iLL5fVYDo2HM5ib3VFGR0ssJBeJQgy/kTWqjehMwyXWmC4ZDonD7ojt//tVyzfMWyruiMsEAYv6D0gQO+IzO2SpyPAb1HrX3eNUB9UV2Gfk/ni3Kr/R4P4igNgpUzL+1sPTgmAipxkf3W6DA2vGLfl90Vq8eV6c4Ng3rcz1oMUYPfShg43NrYGNT+15+xo2ROlkLlZplzvxFT4Y8EITgJqiITcTB5fhPlcCrvON7+3TTfFz1SAoKgpILRTjCoNVtWpvZPoXxTk4g41IAWi8znp9pL2iD8d1JutFh3Rj4veXlJ33D5zsjF5tnJa4kofowkirSA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199018)(122000001)(38100700002)(86362001)(2906002)(38070700005)(82960400001)(33716001)(316002)(54906003)(6636002)(41300700001)(5660300002)(8936002)(6862004)(83380400001)(66556008)(76116006)(4326008)(8676002)(91956017)(66946007)(6506007)(64756008)(66446008)(66476007)(478600001)(6486002)(26005)(186003)(6512007)(9686003)(71200400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HR7aOyIeWsoaOKEbsCJjyIpkfueCcEzeCdM0lo0QWyfyFJZLZ8sJdwPDlz8o?=
 =?us-ascii?Q?+zUE6SONA50zLCuTUka145OHfoSc+B9ef/gbMofE3z4Gy70iCSTAHQWMWLPk?=
 =?us-ascii?Q?94Odol2BreAZrICjfLxIrO1aJICjMDjg3VNku2IMS4epyblXVCa8D5rXe8TC?=
 =?us-ascii?Q?uoNXxoDIwiHaua+HmR+oefuRhLZFwRbZil9DmD9ZTCT9ty1vkh0gKYG5xjCt?=
 =?us-ascii?Q?KZuaX+Q0GjAf5VnVhS9pY5dFrFzS6d+llS8Cc1k25x94jhLbBLLvha7KueRb?=
 =?us-ascii?Q?7Eh7aZjQxX9ZT20aF66u6/y8wyfcOVm5w1o15B1MMkI25DWmfsuRi4QOcK2i?=
 =?us-ascii?Q?fl2oRykZS0f0sh8OMj9Pb9ewBRdFmww05x1YeUHeNrYBsZ+QvLhkN4p3QNLE?=
 =?us-ascii?Q?sRCuIzht5cMASsGmuUw52E0wXwj6x71AcBWbOCVGiSzBDMeVF9abHdGDI1mo?=
 =?us-ascii?Q?jnLy1OHbdAPqum45IpbO3eLJJXFJxXtn3x9sBxIUgnNuOr2SlKSz62O5AXBs?=
 =?us-ascii?Q?Tn0kWDMQPAqbIXA5aN+Uwv2Jx/EIdAXCozhaQexFp5INfP5TCm3fuoFtfbJY?=
 =?us-ascii?Q?9EVyvR6AGNjV3S0pdkKL33OYS5Qv+BF9sZUSNbOMFmmhiX35+b0OqJFkw/KJ?=
 =?us-ascii?Q?sSgV/casFNgeulwVq7ESnuBRxH0Hr1goFTTtgK8AdghBepOevCnF++3iwY5x?=
 =?us-ascii?Q?04ZQkfpSx4qFZZPXY6UEnn5hCpSCjz2Q+aHcYsoqhKuONrdpvogvmdY1aO7P?=
 =?us-ascii?Q?p/qa9befeKlm/F+5jkj0Osh+fgCHdOMNGAcsPMAHVoa0XJ32q/lYF5p3HBM1?=
 =?us-ascii?Q?hJ9XixT4bDmULverAqF1QQ/jOkfu8bE/KOzV82gtq+ywB76KjAh7Vj/VpQD1?=
 =?us-ascii?Q?4dS5O3kLQrPdxaTB9OrDg/gTrqKnJARluEw7T28PPvLUPBlKWzooxGNjuKy2?=
 =?us-ascii?Q?BwidU4I6e8WmR8qSJup3h/emZsSdMlqXeQ2M6zLKMwweem7c3h0sHH9Ndl6f?=
 =?us-ascii?Q?ppT5tXbl1oQbsPStWUUR43hnPReL197xeTSYoHbwoq4vuT1L7oXu/0JhMV4J?=
 =?us-ascii?Q?/Ixap5b/8O5RyIiE9HXxUZL5b/wkPUZ6BK2YBFxMWFoOy5SyRGTCrsD56TFg?=
 =?us-ascii?Q?PpSXGRBHsKIvHK5degoosajYOEYVd/UruYRVoS3jDDLsx/7R0s7jldOvTsYq?=
 =?us-ascii?Q?BiSn0ITBznet+tac7LW3EWOhp0LaDFTunVXndFApHcq1huJCFO8Jkl3SYSMo?=
 =?us-ascii?Q?/k93kBugXQOMQGRvlqYVP6d7C9ZrCVCKBdxUVRYVb6WiZRigSoZpHvAsl2Pe?=
 =?us-ascii?Q?Rv2Q7VKOrwEJeE/SvGycfzBfIQyF03hFZOObQ3lqxV65H5xioGeVc0ej1g5q?=
 =?us-ascii?Q?rmK7W0Km5J0n8k/8GWv69gJCa+mUZcU6w0PNAgFa9J+08Aevn9bdDXb58VR8?=
 =?us-ascii?Q?QoZWB+8y7mmrk5fsnaFoIXoViO5XW1geyVwFCr9OTw8tRtPgHtMXgGzCpIXS?=
 =?us-ascii?Q?vBE4UHWiyrYfb9NGt7hbIKo/sWqrR/yfrR6lKYHhHF2Cet6DB5LgQokSmBFJ?=
 =?us-ascii?Q?70iZyza0JrvG1oPpB1ZqvHAEg3qx5Zjl0KlCB3bRqZtGywpP0PiJh9m/xMHK?=
 =?us-ascii?Q?cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E8FB86A864FD24D802EC86AE0D6F347@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QwFwMcT+RdEwry2uILf/Q8Mj8USwYff2XNqztulxduyPruPHGO/HoQsoYl1Cv2mwFxxgUXjI7BDHgiytAlmgtTRX+tXD3foCqkXUOWp5rqwpabLAQNSYOIiA6FSa4ZYKAzSQ+IfdkCEG7OTziWzu+Nec/9tMl63rCEz+c3G/nieGm9l3Dw6cpIxNl0T+pj6MpFWLdklOFWpMtov7+ZVpA0x6MRZ8fizEql61to8ZpSHl0Xiu7CPtpmo0YBxHrIW7wkCubV1rm39hGuENN6AMvu/xbWdpXMMExwSp55gxbWJjWpuUAy7w2DDRKlIYtVQunI2HUHZZ+9qxNVW7obts8XKOUGevhw655ULilQ12mbOkiWCSedvG0rxeagdEr8dxtBJKkavne0sJqBVIuEv1mDeaxyTdCiBBLRUdFPlJlK/5wBZF0bmtdfJ/O+4n1Gk74nmfKDxQisJZG70NlNVktyXFkx0FmGP8noGfZcH9tSpWON5khfLHZzSF6GHfRkgi639x+WZeh61ECZdlUTM9JcGNzsEE6wQqh8SJqvDYrOCc++2J50q0Bn4QStnail5GiwGgcFj2n6kVvtjY5KUhFLuC6wE5w5o3msBvpbx/5BrZfm4u3SOmYxa+Xd+a7Z+4TC9Rx45bR54Cypz0UMMsuMJU3npifanxiOUZYJ2+W5XXMSX0WCAACplRJXBvh6eQxgMAeiG03uKSW2qDx7XTc76oN0Mg5fC4squAbTgnTSOb3vWwfa81Sl29fELQfmzUZSlOs55c3/j1zJ3wQaXYYRei+ALfFVZIEv1uguBJ3ypcDcKtgl7aMNtjPIALEoIu
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c868d8d0-4e0d-4a24-f8b8-08db0a72cfbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 07:54:03.0315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fXytKO0+lMef2GMdyGTk+1Wl1c8MC9doRF/WTn58jfAzvOlFVSerFgaEZ7aLQlQ0J3lVFH/+5rCJYdyG8DnB+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4841
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 09, 2023 at 04:09:03PM +0900, Shin'ichiro Kawasaki wrote:
> The zone_reset_threshold option uses the 'sectors with data' accounting
> then it was described to have 'logical block' as its unit. However, the
> accounting was implemented with 'byte' unit. Fix the description of the
> option.
>=20
> Also, the zone_reset_threshold option works together with the
> zone_reset_frequency option. Describe this relation also.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  HOWTO.rst | 7 ++++---
>  fio.1     | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 17caaf5d..a5f8cc2d 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1085,9 +1085,10 @@ Target file/device
> =20
>  .. option:: zone_reset_threshold=3Dfloat
> =20
> -	A number between zero and one that indicates the ratio of logical
> -	blocks with data to the total number of logical blocks in the test
> -	above which zones should be reset periodically.
> +	A number between zero and one that indicates the ratio of written bytes
> +	in the zones with write pointers in the IO range to the size of the IO
> +	range. When current ratio is above this ratio, zones are reset
> +	periodically as :option:`zone_reset_frequency` specifies.
> =20
>  .. option:: zone_reset_frequency=3Dfloat
> =20
> diff --git a/fio.1 b/fio.1
> index 527b3d46..3556ad35 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -854,9 +854,10 @@ of the zoned block device in use, thus allowing the =
option \fBmax_open_zones\fR
>  value to be larger than the device reported limit. Default: false.
>  .TP
>  .BI zone_reset_threshold \fR=3D\fPfloat
> -A number between zero and one that indicates the ratio of logical blocks=
 with
> -data to the total number of logical blocks in the test above which zones
> -should be reset periodically.
> +A number between zero and one that indicates the ratio of written bytes =
in the
> +zones with write pointers in the IO range to the size of the IO range. W=
hen
> +current ratio is above this ratio, zones are reset periodically as
> +\fBzone_reset_frequency\fR specifies.
>  .TP
>  .BI zone_reset_frequency \fR=3D\fPfloat
>  A number between zero and one that indicates how often a zone reset shou=
ld be
> --=20
> 2.38.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
