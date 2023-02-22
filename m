Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568BEC636D6
	for <fio@archiver.kernel.org>; Wed, 22 Feb 2023 18:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjBVSwm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Feb 2023 13:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjBVSwl (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Feb 2023 13:52:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2063.outbound.protection.outlook.com [40.92.42.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1BD2728
        for <fio@vger.kernel.org>; Wed, 22 Feb 2023 10:52:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xor0992urrtLHwE6UkZFHqLFFDDvnGooG3sklNq6hh0tZDT+TGC++Muh3VWGUqaG4JHYoozz10M0TwC2Zjwfgeq+FwOhTaS5WCPsTspJ2kmnKMMswrrgijlIIxdtpb86RU04SzopoSPSI6Q2WtXY5LpQVFQO891JCY1+U+4gieg80Ssw73X7YSXQS4crWO4YFLCzTzkzMNtFFdJa6jHuyolE7s4kDwgVfgSVXCUuUXLfvYRBDObs2pO7UL2jTmyaUBldnZi/+X10f+q6mcqG3F4Xomu9oeF8CSsHWUEYjgpusC+2/I558RcOfVYcaLOHk2CpVdpAEqawZzFq0vqImg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czWJAF7adSQj1qeX0yqx/t+MvSLQyYhOpeMTO9c5/hA=;
 b=Om1+WDRF7jt1uc8HeQHrlrzGHp+Qa7txzuBgZUf8TQ+38gcSgKtvENG1AnTJqiwsB2rjiXnNunMvXvS9A0X6iuEswHRhbY5V/iRBaC5pLNNVMQL0kmU5x9iZgQ/VocTknuJdMw5hOv5AdI0svEs11E4kBwIrmlR9vBYhaqg2h/upi5ijaGcXiCeHr+rD4Qq8Kk8lnk34Qr2GxB9Wvx8ZuJkHv0zwkazmPKqti+zQ4brYWKW/6oAwjaOojZ3P9u56PkkxFH5yXPiWNsdG3ec6esoMJnHv1/S8oXyx+C7e8K76A2ESnmUMnf8wsRvlAjvfFOa3U4+hDVokmkd7Pm0PHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czWJAF7adSQj1qeX0yqx/t+MvSLQyYhOpeMTO9c5/hA=;
 b=MBYQqqtjkUwoYkV8JsOnwJuXYaLxz7HstBv244k2RgwIb1cvXVFsPNwyFEormB34q1aSwoDN9IFiiGHEgV1/Ycc/qjgNoeMIB+T/1KtnkdvvZcQnLgFCb8Gtn0B8MjqDeianQg3O+EcK+cPk6s8SxrCrecIlqqdnZNIq1+F/AliReCEftKGHM7Oaq5q7ojumdDSe3/lQEwVFVmzrnWj/y4jsw+qsFPCT2ZdsFt+7UENN6xcuzpkUgxBaxxFhyg37bgpbG4ycxuZfB7ACkZL04iP9Wp2xHytT9yHfun2qfb+jG/z2YEDbA/tPfO7d2sc8gG6MPA7nBj9c/72TM2FjQg==
Received: from IA0PR17MB6275.namprd17.prod.outlook.com (2603:10b6:208:43b::7)
 by IA1PR17MB6424.namprd17.prod.outlook.com (2603:10b6:208:3f1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 18:52:37 +0000
Received: from IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::854b:a77e:3ec2:ac0d]) by IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::854b:a77e:3ec2:ac0d%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 18:52:37 +0000
From:   Adam Horshack <horshack@live.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: Problems with interpreting FIO output
Thread-Topic: Problems with interpreting FIO output
Thread-Index: AQHZRCT1PRztfco5cUCReGrURH7j767WYuAcgAMhAACAAZkQfQ==
Date:   Wed, 22 Feb 2023 18:52:37 +0000
Message-ID: <IA0PR17MB627523589A367A9FE0EC68C1A4AA9@IA0PR17MB6275.namprd17.prod.outlook.com>
References: <CAMtsHkrJbk8GCrAvfAzKAASYOkaudNX0--mdnWHQ=nnAzhnH0w@mail.gmail.com>
 <IA0PR17MB62759977BBEDE6BB9F718115A4A79@IA0PR17MB6275.namprd17.prod.outlook.com>
 <CAMtsHkqzQoBo3kWEKsv==ZjgvaV5bNi1k-XXSd=fxx+JWpjz0A@mail.gmail.com>
In-Reply-To: <CAMtsHkqzQoBo3kWEKsv==ZjgvaV5bNi1k-XXSd=fxx+JWpjz0A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [lyuLSv4VbwGE+Bm7dw6GI70+0dsqXkut]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR17MB6275:EE_|IA1PR17MB6424:EE_
x-ms-office365-filtering-correlation-id: dd465413-32f5-41af-4bbe-08db1505f7ae
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JHibVhWKBLjjygtKd2lfoFkCvp5xAguVgLZXeQiD1p/ai+i9r0HHFMHxxW+kgIy1ExjJ5YWXtcqKUJQclHn69gE2ZiqzgxYzHfiQSeZIfJ7+zQZCKZL4+WJ74Xs6W5U2DynlT7QxO7OlfKWLuOfMYNhkKZkpjhDAS/tgvM5D0YCuFypDbiIZPLKxNRSioMRC6xYANxhNRE+maMlm2F8Bgb+3TTNSC92jnv6aIXulV25d0ZXLs1S46MK7woUVmaS2jWV6c/VyibzoPXOjs5TsgQ9LW3lug9WuQx9wT6xluryUITHzkfFSnGstrWijqlYvUgTNPvSGYrBv6MePUzD9o6QnKZhuc2JK7ttOpdUcFokWR4/KVvF0Cd5iwpYVp+qkKgdEap2qwm9d+2kxfTFp03V3TH/ZLdN4UptPnAt+MezCQxDT7jznwrNhoI7vUMU9na7rsqt//hNGt02uQQlB1X1COnxnpsTIsdgQECxMcl4cYO/NpseiiO/y3Rfh1mAacaNdHjKrMrkbj+9AFhx597d+evtSJh0Wr5nHiHNx8hZ79QwR9LC1SGxqmy5hWwBuWR8ppQx2gdKGVlr0DNnGeKEzfQyEpQohSFftVq7OGEaRRPOR0usKpAhuyz9isXaLucjHsqGnIQppRrELHG1Iaw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sBdXb7MKPVU07Nely3uvLIRaz8o7hNYfbLM5wLgjfeT/9Mqadh+Qw7bw1W?=
 =?iso-8859-1?Q?ssEGDsJ/rY2GXRkchAlrHm7iLaEh/FXhnTvkY7tGr/jsonnRu3pilKBsWv?=
 =?iso-8859-1?Q?4ATDHtLcLFbQd+574I3TkUgK6E+lOVXnKmm//y/zbNYHnTT/oSid6YAEr3?=
 =?iso-8859-1?Q?9Paf+mqgGPR6VmMTC2TkP8RFdbhqbk9hI7F8+JwZ5+C/v4Iz+z2HmP0F3F?=
 =?iso-8859-1?Q?eIKYActE5lOaELJZddrhYI2D6ocVQ9Ie3yNLAC83gzMQqkwf2G+XY4mwf6?=
 =?iso-8859-1?Q?8/Jqx60S85d0C5RIvlg+QqRreUtXA+pU17VZMya7KYmSj/sTC2gwsN+PRl?=
 =?iso-8859-1?Q?P0BoP3iZattKPETGrXZl2KXWBD49kqa+U1vDjEusqKCUKNk28yIa/4CBlS?=
 =?iso-8859-1?Q?Gx1XYae2U1y412cSNFGld2euyl4cPLKmgGSFlFF62LEiKh1BNKqfJhupzQ?=
 =?iso-8859-1?Q?/jXAPn3rek3ajOVlvyUkwD+SeIJWDBXqxWbZKxy0djuZg7YMKHZPXv8ERi?=
 =?iso-8859-1?Q?ybtIfpEjcVN3r57Ai2EVNskg/DtVmH+u1EaWv2VdO1IUsO680L2nPzMquo?=
 =?iso-8859-1?Q?9gCQK2Ck+kt/mPVf7vaOyEFStM1pAzwCvorrlPJWmwTJSvlUip87vRqij6?=
 =?iso-8859-1?Q?ddW6WCGyL1z/1TFRmF5vfws1jEVrx3b02ISXYoo/eg1MheQpo079nW3tuA?=
 =?iso-8859-1?Q?xIgvjAW24ebLURPU/aic0dzvtCShi2iu3xV5aYfLHSlunHXGVgA+D28ZN2?=
 =?iso-8859-1?Q?/EtnfvmolyMxvMaLpA32c0YhuiMJC+eHPvizxFJ3+2XiZ3I+apFQkMUTsd?=
 =?iso-8859-1?Q?68Cc9uIREzIgqUpbk2z8eyW0fGCAvGUbHol2IZ/JRBPqAcgYcla28HgJiW?=
 =?iso-8859-1?Q?H3WmYUiWIjWoRzgfK5tiJK4S3SOkpKM6dbU3UllBZcL9r8hrj/JlXuht6a?=
 =?iso-8859-1?Q?WKV+7ajnWg2/DvMmmAzO0feiE7ccgGHot4QMrZaTM2U33JG9x4pOZKeF1u?=
 =?iso-8859-1?Q?76N8nzL7DhG0ZLUmJzT7GfyZFMYYM+ccnfL5pdDon7Z+U2zQpfYItieCJW?=
 =?iso-8859-1?Q?3ZXSBxNAOL4jArPREBbuOG0rOMlF0tVEbtix7NFJfEW4f48GoQuNnRm3EN?=
 =?iso-8859-1?Q?JSIjLLHNlU2Y9Ud0RhypPcRjqQjlmysJ9HpMLjQjE+GcRsR0toaqQKypww?=
 =?iso-8859-1?Q?nir66iL0tjKS8fCoJgaaZZJlWcvpoEYhghxV9nDc8Mqkmpm5CRibO70B5m?=
 =?iso-8859-1?Q?SKmImWAJiaEMDEgepyj+oUVWtmvxaPEKNJOnAovXcx5+UwxqrQTewEb92Y?=
 =?iso-8859-1?Q?jMix?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-c704e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR17MB6275.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: dd465413-32f5-41af-4bbe-08db1505f7ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 18:52:37.7315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR17MB6424
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi Seyed,=0A=
=0A=
The fact the # samples is much less than expected indicates fio's worker st=
ats worker thread is CPU constrained...or is not awaking as frequently as i=
t should to properly sample the 500ms intervals.=0A=
=0A=
If you can run your test with the following options and zip up the output f=
iles in /tmp/fio and place a link to the zip in a new issue post on the rep=
ository I can have a look:=0A=
=0A=
--write_iops_log=3D/tmp/fio/test --iopsavgtime=3D500 --log_avg_msec=3D500 -=
-output-format=3D"json" --output=3D/tmp/fio/results.json=0A=
=0A=
"mkdir /tmp/fio" prior to execution=0A=
=0A=
Link to post issue: https://github.com/axboe/fio/issues=0A=
=0A=
Adam=0A=
=0A=
=0A=
=0A=
From: seyed mohammad <seymad.f1@gmail.com>=0A=
Sent: Tuesday, February 21, 2023 10:06 AM=0A=
To: Adam Horshack <horshack@live.com>=0A=
Cc: fio@vger.kernel.org <fio@vger.kernel.org>=0A=
Subject: Re: Problems with interpreting FIO output =0A=
=A0=0A=
Hi Adam,=0A=
Just to give a little background, this happened when I was testing my=0A=
software RAID10 (mdadm) alongside BTRFS; I was checking the system=0A=
load with htop and it did not shoot through the roof.=A0 Many thanks for=0A=
the test results. The same experiment with other FS, had much higher=0A=
system loads.=0A=
=0A=
On Sun, Feb 19, 2023 at 9:06 PM Adam Horshack <horshack@live.com> wrote:=0A=
>=0A=
> Hi Seyed,=0A=
>=0A=
> As you probably know, IOPS represents total #I/Os / total time and iops r=
epresents the per-interval averages. The default averaging interval for IOP=
s is 500ms (--iopsavgtime=3D500).=0A=
>=0A=
> fio is reporting 12,469 interval samples for your run. I would expect 400=
 (jobs) x 31.279 (actual runtime secs) x 2 (samples per second, ie 1000/500=
) =3D 25,023 interval samples. It's not unusual for total # samples to depa=
rt vs expected under heavy loads. Your reported IOPS is 2x your iops (199K =
vs 397k for reads), implying the #samples discrepancy is related to the IOP=
s discrepancy.=0A=
>=0A=
> I was able to reproduce your IOPs vs iops discrepancy on a ramdisk using =
100 vs 1,000 jobs. Read IOPs for 5 second run:=0A=
>=0A=
> 100 jobs: #samples=3D910 vs #expected=3D1,000, IOPS=3D84.3k vs iops=3D83.=
4k=0A=
> 1000 jobs: #samples=3D1,470 vs #expected=3D10,000, IOPS=3D107k vs iops=3D=
172k=0A=
>=0A=
> If I enable IOPs logging with a 500ms interval (--write_iops_log and --lo=
g_avg_msec=3D500) I get the following samples for one of the jobs:=0A=
>=0A=
> 100 job run=0A=
> 563, 717, 0, 0, 0=0A=
> 1062, 759, 0, 0, 0=0A=
> 1562, 784, 0, 0, 0=0A=
> 2062, 772, 0, 0, 0=0A=
> 2562, 774, 0, 0, 0=0A=
> 3062, 769, 0, 0, 0=0A=
> 3563, 778, 0, 0, 0=0A=
> 4064, 706, 0, 0, 0=0A=
> 4563, 757, 0, 0, 0=0A=
>=0A=
> 1000 job run:=0A=
> 892, 128, 0, 0, 0=0A=
> 2660, 95, 0, 0, 0=0A=
>=0A=
> First column is elapsed time ms, second is average IOPs over that interva=
l. Notice the 1,000 job run has fewer samples. Some jobs in the 1,000 job r=
un have zero samples. The IOPS vs iops discrepancy is likely sampling error=
 from insufficient samples captured due to CPU load. I'm not too familiar w=
ith the back-end stats capture but I think it runs as a single thread. Perh=
aps its priority could be boosted.=0A=
>=0A=
> Adam=0A=
>=0A=
> From: seyed mohammad <seymad.f1@gmail.com>=0A=
> Sent: Sunday, February 19, 2023 12:42 AM=0A=
> To: fio@vger.kernel.org <fio@vger.kernel.org>=0A=
> Subject: Problems with interpreting FIO output=0A=
>=0A=
> I've run a random read/write FIO test with 400 jobs to benchmark a=0A=
> RAID setup. The output IOPS and the iops statistics (the average/avg)=0A=
> are divergent; how can this be interpreted? Should these two values=0A=
> converge?=0A=
>=0A=
> Test results for read:=0A=
> job1: (groupid=3D0, jobs=3D400): err=3D 0: pid=3D25204:=0A=
>=A0=A0 read: IOPS=3D199k, BW=3D778MiB/s (816MB/s)(23.8GiB/31279msec)=0A=
>=A0=A0=A0=A0 slat (usec): min=3D3, max=3D1401.7k, avg=3D1423.58, stdev=3D3=
8712.03=0A=
>=A0=A0=A0=A0 clat (usec): min=3D60, max=3D2683.7k, avg=3D86310.45, stdev=
=3D289174.76=0A=
>=A0=A0=A0=A0=A0 lat (usec): min=3D70, max=3D2683.7k, avg=3D87730.40, stdev=
=3D291369.20=0A=
>=A0=A0=A0=A0 clat percentiles (usec):=0A=
>=A0=A0=A0=A0=A0 |=A0 1.00th=3D[=A0=A0=A0 239],=A0 5.00th=3D[=A0=A0=A0 562]=
, 10.00th=3D[=A0=A0=A0 717],=0A=
>=A0=A0=A0=A0=A0 | 20.00th=3D[=A0=A0=A0 816], 30.00th=3D[=A0=A0=A0 865], 40=
.00th=3D[=A0=A0=A0 906],=0A=
>=A0=A0=A0=A0=A0 | 50.00th=3D[=A0=A0=A0 947], 60.00th=3D[=A0=A0=A0 988], 70=
.00th=3D[=A0=A0 1057],=0A=
>=A0=A0=A0=A0=A0 | 80.00th=3D[=A0=A0 1156], 90.00th=3D[=A0=A0 2147], 95.00t=
h=3D[ 935330],=0A=
>=A0=A0=A0=A0=A0 | 99.00th=3D[1266680], 99.50th=3D[1300235], 99.90th=3D[135=
0566],=0A=
>=A0=A0=A0=A0=A0 | 99.95th=3D[1384121], 99.99th=3D[1803551]=0A=
>=A0=A0=A0 bw (=A0 MiB/s): min=3D=A0 228, max=3D 3556, per=3D100.00%, avg=
=3D1553.73,=0A=
> stdev=3D 2.08, samples=3D12469=0A=
>=A0=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D58376, max=3D910489, avg=3D397=
711.45, stdev=3D532.63,=0A=
> samples=3D12469=0A=
>=0A=
> Test results for write:=0A=
>=A0 write: IOPS=3D85.1k, BW=3D334MiB/s (350MB/s)(10.2GiB/31279msec); 0 zon=
e resets=0A=
>=A0=A0=A0=A0 slat (usec): min=3D7, max=3D1397.5k, avg=3D1430.09, stdev=3D3=
8675.97=0A=
>=A0=A0=A0=A0 clat (usec): min=3D14, max=3D2684.1k, avg=3D97398.93, stdev=
=3D306662.71=0A=
>=A0=A0=A0=A0=A0 lat (usec): min=3D28, max=3D2684.1k, avg=3D98825.72, stdev=
=3D308705.23=0A=
>=A0=A0=A0=A0 clat percentiles (usec):=0A=
>=A0=A0=A0=A0=A0 |=A0 1.00th=3D[=A0=A0=A0 314],=A0 5.00th=3D[=A0=A0=A0 635]=
, 10.00th=3D[=A0=A0=A0 717],=0A=
>=A0=A0=A0=A0=A0 | 20.00th=3D[=A0=A0=A0 791], 30.00th=3D[=A0=A0=A0 840], 40=
.00th=3D[=A0=A0=A0 881],=0A=
>=A0=A0=A0=A0=A0 | 50.00th=3D[=A0=A0=A0 922], 60.00th=3D[=A0=A0=A0 971], 70=
.00th=3D[=A0=A0 1057],=0A=
>=A0=A0=A0=A0=A0 | 80.00th=3D[=A0=A0 1270], 90.00th=3D[=A0 10290], 95.00th=
=3D[1044382],=0A=
>=A0=A0=A0=A0=A0 | 99.00th=3D[1266680], 99.50th=3D[1300235], 99.90th=3D[135=
0566],=0A=
>=A0=A0=A0=A0=A0 | 99.95th=3D[1384121], 99.99th=3D[1769997]=0A=
>=A0=A0=A0 bw (=A0 KiB/s): min=3D98765, max=3D1568174, per=3D100.00%, avg=
=3D681623.43,=0A=
> stdev=3D924.60, samples=3D12469=0A=
>=A0=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D24675, max=3D391998, avg=3D170=
363.71, stdev=3D231.14,=0A=
> samples=3D12469=0A=
>=0A=
>=0A=
> The FIO job:=0A=
> [global]=0A=
> name=3D4k random read 4 ios=0A=
> ioengine=3Dlibaio=0A=
> direct=3D1=0A=
> readwrite=3Drandrw=0A=
> rwmixread=3D70=0A=
> iodepth=3D64=0A=
> buffered=3D0=0A=
> size=3D400M=0A=
> runtime=3D30=0A=
> time_based=0A=
> randrepeat=3D0=0A=
> norandommap=0A=
> refill_buffers=0A=
> ramp_time=3D10=0A=
> bs=3D4k=0A=
> numjobs=3D400=0A=
> group_reporting=3D1=
