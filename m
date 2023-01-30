Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BC0C54EAA
	for <fio@archiver.kernel.org>; Mon, 30 Jan 2023 10:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbjA3Kem (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbjA3Kei (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 30 Jan 2023 05:34:38 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAF5303F6
        for <fio@vger.kernel.org>; Mon, 30 Jan 2023 02:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675074841; x=1706610841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SiXMSRgKYJz1faBQarJKQURv8lJqTF3TmZsHi78wTCM=;
  b=gDPTExHhmmmJgtlui5hVNvfdoUl+HhPBXwA4B6FZ9awkhGbDEKPitF0f
   Tq6yJily16ZCtEA/YW5cbKM9RcoNN4rtSrGoKcFJJqc6PAV20CoNfAMMu
   p0rBtCYs11i2sDt89Yg81lkMtxdaZ0Sy1LyVSuMNl5p9sxTph66ogm7pC
   iISJDJC4SUkgidbrBItpmQjFPXVCUadYpHxlwEMl7/VmtsLfzsMb2bJhZ
   fUN9g91tcgiKuVj6sxzw5az76nOQs609FjojJli4RBc8qld0SkKDbJ6hM
   +GcTtL2I/yBS0QXPrNBfR0Bd0Nx+9qN0IowVl4CODrisDMl4FhPmMTk/w
   A==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669046400"; 
   d="scan'208";a="227042379"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jan 2023 18:33:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5LJhdHX1Tc4ZkPQEt1PBSsGnO+iYWYkxqIJtgObRRq7MovTKu6e1Qz04nqbKqcRlViGFx3Akx02JjiNJZOfZ5GbO8uF6aSfuLBicHt98iooQJ48LQdBd63BWXYLTsrMf/LcOLO98+zdEqxbRZ0n4Aw72TBhMv2s3pqOgTCoy7w4IO0Rn1PKOdMiRxOlmKB1yU9hlHy/uLMQPYg37kGvayle2cgZoDJv+6/7crLbFwfhfzkT+CSdFMy6FOKachpX/zGGhhb+cNMk4+IaeVotz1HfTk00VhcPsZrxGlGBp1aVtTSfghIqnLyP8D8AC9zXZUf1UV12z7+rOX3LYaR1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4mxetZ3E7BDsI7xNRuXLcf+gkocaMDf8Tqd/Ip9UK0=;
 b=AqMMZ68AtWN9SlOfXJ54SaEOYXidXq8XbC547SvZm5BraFIMVY0fMuePKtUMY/n+7EjiegdSJbjHRRUjgdDeolnoQGU5c3ug8G6FgcyGVBwFDCFp9eXRPHboPwzn1hL+C3ePupBSMN4W9gbAxXGj4bkRj2QaXfE8HoF5Ap4ZiYgpkXS3IC0uJ4pJNXHVOhbLkdder63ODW4POjT+lbjMUZ+So7g9Y3wcHZ0a8y5akMxbO6WFys3tsPEHisFFgdG7kJbrxNlGjSq8fDwBiuh2srAPe8rxeBInlDpT3CXswe8qe7cNbZcZC+kNc+ThJVTjehw0o+XOnTkRIG0ZLbTnqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4mxetZ3E7BDsI7xNRuXLcf+gkocaMDf8Tqd/Ip9UK0=;
 b=sjbmRewt/CPy1o1D3nmNygn9PEZ+caklS1KvT2nXLc7VsKhjag5IJp40Gxp7vO/G9tQQ9nbe5ncLqN8aXKFCGa6YV02zDLY3G09sNMaVoOEdoqQ8lh5uh3DHEfPo5cI6p4ptc3ISu9s7p/3C+v4dxfDU10857ot/oak5Pnimdfw=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by MW4PR04MB7330.namprd04.prod.outlook.com (2603:10b6:303:71::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 10:33:57 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.023; Mon, 30 Jan 2023
 10:33:56 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Thread-Topic: [PATCH 0/5] zbd: drop 'sectors with data' accounting
Thread-Index: AQHZNFKac1o8LwjOwkyu39Z4WWKlY662xA4A
Date:   Mon, 30 Jan 2023 10:33:56 +0000
Message-ID: <Y9edEqAqMyiqm4tJ@x1-carbon>
References: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230130022850.1375523-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|MW4PR04MB7330:EE_
x-ms-office365-filtering-correlation-id: cce43327-b6f7-4900-e4e7-08db02ad7dc5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJOHDXgKKaKFV4/9E0wFash352HpyvCHlLhnkUTQ5/4O9uDPX5Kcl2ktSdy6B/EdfJI2ecnCK0KyYFjfRSbi532w/HqX+knAqHYAi30DXFzak1kqeldXHPwxQhDVr7oeg3RhM+F62XPSJyLp9IreUtVUK6Ayzh0G9VmUrPIMc47x1iC82RW+8nDLcMab4J/urVRU9bEl32gHAkweWU4ytafrbpIXJ/s+mA3eSdEdn/AMEJ0bX1gHvXofGzuVuC/PHFfa4rJ0mWw298xADOmYzl8bAUuVF5FGag9bz/QnXaVQkjf82qN67Si0gDYU0PDffFCRJZ8Lf++pJbtRCYroS4K2jB1JtA2/n3EOnRlAJV+1d4gNCyjA87sADB1D3d93dUgz3km4rfLeXL7i5YW7gW7/tPWiEQgZdhmBpQ01xb13/Nz8tRck0R7smt/9rHmD33HdpZrtnOKWxNXRpWMsacSPoiwujvcPJSv+tKO11WVzkGc1iiepTTq3PJhxdu4G+0vgVELPhz+Fvg8W+nhBWUbVDL4afd7y4A4JP/KaMHAnV9Mo4oTizxWIkuurKi3UqroUqDAXomDDZBVozpRqAZc+4fxTESCudfNwgsmqN20ZGMChLay96FA1jqmCSzU1I9gz8V3pXPkAzojP/74NkGOEJAkbSx+brra/gxk/9USdar7BZM5fd0BzSVOG0hNTLsn7fmGBrJeKuoARk3nsiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199018)(54906003)(83380400001)(91956017)(316002)(6636002)(41300700001)(4326008)(6862004)(8936002)(64756008)(66556008)(66476007)(76116006)(66946007)(8676002)(66446008)(6506007)(26005)(9686003)(478600001)(186003)(6512007)(6486002)(71200400001)(38070700005)(33716001)(86362001)(122000001)(15650500001)(5660300002)(2906002)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9mA8+LDXvrBep6+kLjGv1K/CfyYK6EKtrut4Stw9O3vGs1wRc1sqQWAFmJaW?=
 =?us-ascii?Q?VI9xUgTGIcFKJUGB/p+S3NmAuIplVApOU5i5laa9qAJuYSpKmrEkU2MqdD8y?=
 =?us-ascii?Q?kiZvJ7HlD3mo7i9+MmV8b5NyCfk/5X6lLoHBy7C/VyreRzcTpiW2GRIbcrGt?=
 =?us-ascii?Q?mFkrVfR/zdqt4Ixqu/bDdONs5NlplA89ycqVLDOmH7VmIqEy/9+NygPF6Hn/?=
 =?us-ascii?Q?2iWhJDwJ36H/ddvC/oK8/ICCL37vsWGCLpeb7lKoDfcwccN9+v/GPsLTqe3I?=
 =?us-ascii?Q?b28K8bh26NJLtKx1MwFqRFdBkY6/cFFT/gbmYyDzjSpdF/ZXv3fUNanOkNM2?=
 =?us-ascii?Q?MWvp2jkKuKDMl1KYNwVF2eMh06+sGrqYnsqNPQ02zRamhUBsLB7O1fIHKO8u?=
 =?us-ascii?Q?eSuTefEGp+/u7aFujEG8DiF6Pf60VI6RRRpbTZhX9b3MgiMTcmnL1kk/l3/R?=
 =?us-ascii?Q?2EBH9JxAhsJ72sWjS9vGRmuYz+7ahcuDT8I9YK+CrrBe+TwG6W70sZfIAsJM?=
 =?us-ascii?Q?/5CzYqr8pGEUM5Clf91D0uv34fotY6P6mFNyydY86BUO+1cSTY8sY7JN/L1G?=
 =?us-ascii?Q?5zu7g0pda02DW91fIXhbJI8W3n55vBJTq7nAPea8soTdEXp0Ml4evdRnPbDD?=
 =?us-ascii?Q?/orJit+UxtZ4Hj2jwyog32Zkpvbcck86kt9g6fFGKVc/LlPXVm1J8lzvmieS?=
 =?us-ascii?Q?ZwZE9EoedtFPGYSwVNM9ctsVcrO8MCxw5zOxoTsur4U+QDigFf3DjP8qyYAG?=
 =?us-ascii?Q?nvyf2szwOepLpsPuJT9hAIi7PwGRAE8XnluJNc3vB6W5yDKY5/RAXu9w0D8s?=
 =?us-ascii?Q?owmjtg/9JLelTTbTShGhVUMb9NJOqGLxLVubg+WqlQ1rvP7XeDaj+v22S9LH?=
 =?us-ascii?Q?GTPAz/cVDEx0OpC0XIUALUsn44E8Z+0y6zKTLBzpQBg5ognSpRhYMuCsSi9W?=
 =?us-ascii?Q?s5hmmdFnpgf0gpuEIvb0i1FC1ImG9HXGOWZipKwnbtsvYtFEXh0M2hraqiXe?=
 =?us-ascii?Q?Nqa8JwwM1QC4ikv6eeTjmhSUohX8bVoqpiy7tvuuuKR9/+Skke8mHjbPNTir?=
 =?us-ascii?Q?h68YahNXyIxg2R0Ml/esTCfTuGABFwIyu42OflRS/ZnWaKCqdcidOW/boS/I?=
 =?us-ascii?Q?PmbeeGad+KC+oLMaNQHHPB30BvRh9pMmc3W0fnxmc+v8kbu9RMBaMFCdznkw?=
 =?us-ascii?Q?4DQVbbExb/xeBDxWhXV2MxInlGxgdStFIdyGqH/rpRENCYpx4PUaHQIQVOuU?=
 =?us-ascii?Q?h34/FWH5bzBJVrVPaYj2ilnjpDVr9UCDiTn7K6uOn8JS08qcxxZVaegrja9y?=
 =?us-ascii?Q?0MBL7jeqYkTor6IC8LtnOg6lhx5iL0Hp2xCfKarDzVq+vtAQbu1YstiRoQVY?=
 =?us-ascii?Q?YwrPIyHR94EQKfoZIvASRPDLZe8R6nRrBXXOxGEj0fc+FqW7zLVihY0sC7nN?=
 =?us-ascii?Q?COhtD3y1uXdFsAFoifKzLXHtXdiXbsqYHlEeiZNIua/dcHNlXEBJXmZd6TOE?=
 =?us-ascii?Q?/PuT6/nfSrNvPztEPkUEiNyW/NCRas/u7ruTSKJJh1AbRmBjdnRnbuG6bXse?=
 =?us-ascii?Q?j9VY9EGuy/sJqb97zEakdzNDyQeROMwcVVxM8gSsSvhEJ687xeCsiqttGelQ?=
 =?us-ascii?Q?yw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD80A582DA76C34A91CAD0C3A350FACC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: joazbbgKV9/JSgvzdn7U4RMpH1Pw9CAFSErdVA87GWUfKCt5uAblTe78VdKdajdf114U5w+G1dAjQA/4EkMMOPs2MTldOUXei7zMjXfxJhj+b0NMRDChWpCYMsrfXPdtBVrqMxbyqHLgMzL+muphmY3ieWG+cfm/4RBL5VoxmehKdw2/YgzXNV0iYKwUZ98Vgo+5/MfwIITQ038KlBySrLr57RlCqKyCPN57lPyFVA6o7ukfiWDoePdqCefzMYejzCLl0BYUKpvdIzsSuLcKzowT3smBzz0q8tlOB82DEd0mfiAKcTtAx6kCNN0PfAru8egoAneqIK10LSwtDBpOpiMH76pey5Yk4FYFHG18mWCgtpr8Y9GTrUjSG4rVo7maT/YzyQuXDQ0qplVbU38tQbcu2msR8FC5YjFmohrRsbmCR1mOAMkKBn8QVgGgLNceRPi+f0+Oc8aoSfBRQ3bYNBey7EK8MgGXsJKxYm2MlaDQgaObi6nSwQD2l/QzLC0bfFFt9OtJgFyyubRQLYWminZALD6klrS6rnW08aam9clajjTFHiExlXCYB1WjS0Arfg4p2OdOkkr/Vqdg1MSMXJ4v+Oguhf/DEID2mXDTPnsEPUKVmBlwJ3jiSsXby9f/jFiIxXKL1r3jf4O+qVLvir0QU9ss9tBjDJwqsjTAYz0wNpXKIhkAR8JroQ5b119MTfF0E3q5IGv2nr4ktaic9L9hcGnVjE4Y61w4RCYA0p5EzxQ9YD6PN5F6Gom7uIU3AUCMzeu5ctafEBZHr1nhU64sTYgsOy5X0/SF7T1mlcnW+5pXOgMU8i9RY6lw0xYhxVrFO6bpULssaolSOpy68g==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce43327-b6f7-4900-e4e7-08db02ad7dc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 10:33:56.5619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bVhU9xUYBEqd6F2gcCIdwOTIYK8L96t3yCovZI2dRltwEa7huQZmFpTPeoI0Pp4W+mcbnbV0B8CnHfGMEe04jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7330
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Jan 30, 2023 at 11:28:45AM +0900, Shin'ichiro Kawasaki wrote:
> When zonemode=3Dzbd is specified, fio does 'sectors with data' accounting=
 to
> record the total number of sectors that have been written on a zoned bloc=
k
> device. This accounting has two issues:
>=20
> 1) The current implementation counts sectors with data per job, over the =
IO
>    range of the job. So for a workload with multiple jobs with overlappin=
g IO
>    ranges, the number of sectors with data is overestimated as written se=
ctors
>    common to multiple jobs are counted multiple times.
>=20
> 2) Counting the total number of written sectors requires taking the zone =
lock of
>    all zones in a job IO range. For a multi-job workload with overlapping=
 IO
>    ranges, this often leads to significant zone lock contention, resultin=
g in
>    some jobs starting doing IOs only after other jobs have completed thei=
r work
>    (which looks like an apparent deadlock on startup).
>=20
> This series addresses the issues by dropping the 'sectors with data' acco=
unting.
> The accounting is used only for two features: 1) randrw first IO directio=
n
> decision and 2) zone_reset_threshold ratio check. The first two patches m=
odify
> these two features to not rely on the 'sectors with data' accounting. The=
 third
> patch drops the 'sectors with data' accounting. The last two patches adju=
st test
> cases and an fio example script for the zone_reset_threshold.

Hello Shin'ichiro,

I understand when using multiple jobs with overlapping IO ranges,
the number of sectors with data was overestimated.
However, patch 5/5 contains a single job.

My expectation for this fio test file is thus that the
zone_reset_threshold should stay the same.

I understand that you might not like the definition of the current option.
But can you just change the definition so that it is unambiguous?

(Regardless if you change the definition to be per job, or per device,
a test case with only one job should be able to keep the same value
as before in the test case.)



I understand that you change the way that the accounting works, but
I don't think that we should just totally change the definition of an
existing option just because we think it should have been defined in
another way.

Can't you:
-Change the accounting
-Clarify the definition of the option, but keep it like it is,
 regardless if it causes zone lock contention or not.
-Implement a new option that might be more optimal, and does not
 cause zone lock contention?
-Potentially deprecate or remove the old zone_reset_threshold option.


I guess my biggest problem is that users might use this option,
and when upgrading fio, that option will silently behave totally
different.

If we remove the option, the user will get an error that the option
does no longer exist, which is good, because then they will understand
that they need to update their fio job/config files.

TL;DR:
Basically, I would prefer to rename the option instead of silently
changing its meaning. (Because users might not notice.)


Kind regards,
Niklas=
