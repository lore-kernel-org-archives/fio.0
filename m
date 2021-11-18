Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B038C433EF
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 05:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A0E961AA9
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 05:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhKRFJ5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 18 Nov 2021 00:09:57 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61959 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhKRFJ4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Nov 2021 00:09:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637212016; x=1668748016;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gthp04zd2nNYMacqIA4iLGD9fBkNZczCZfREnvqyZuY=;
  b=P+pNvcBX+BxhDecZTP6MaQV1RS9FJjxa0eXGseaifsvWAn25txHdoPRA
   ym1FoqA32cyk2o5ja5XjObM+KFsxjc1QaVR5xp0Nw8dZ1WFXbYREeTFfd
   ojfsoOteMkbw/8xF3FbHeOhaC7Ir7LyhN1yWbW26bfcr3YQN/9VHWLY2b
   DO2u+UI3gabGEQ63g/5ND9wVCAMwZE0xikEZAQVc7DZ08PFJrxaDvera6
   mI0PxQZWZhkMNhakTndTwWq7np2Njz7LBaIiQ4tyXftqKHxTTdFNaYxyO
   eTWQQwWTGT8lrqPbH74tOiO0Vxyka+d2erNWDVUMb8WkOIZ77/5bZRPov
   w==;
X-IronPort-AV: E=Sophos;i="5.87,243,1631548800"; 
   d="scan'208";a="184912501"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 13:06:44 +0800
IronPort-SDR: VEUhT80QUwGjEe1miGPVtPrRAbhVJxkNWaOcVyqXZxrAqD83eUv8AMBKv8KdImO0AHTfb2Q1+7
 1bsXFkumNZpuk2/MIeqmcvNz+lTINELjV6iufyTfrv/wT65Bq9Ri52IABpC2xQegStG0D+ygqF
 awrtgKPw3IcZl7alEcxKccQQNcrIHCtd9JflLtE9XXQrbRY0bBi1q6b2wsb1tUU44l7UR9/Bel
 Pvg35RrA4rHG7gBE7DKerWKzRrqBoIbPOiNQKQHKd7mYVNbkiXUyUF7EmGzdd1MAGKMvIEA6pY
 D4LrVa1WzSiK1bmN6hF7c60C
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 20:41:45 -0800
IronPort-SDR: 81DQhkxnLy3zsGuDAp8JkMX9mVtB5J2LF6ZZokfwO8XGby9hoXCb/O+CIW6q4Nn4ipZupD2NAu
 Cu1+ICSa5Y1uPOEFFGUOvFMTGO9S9prxb/5ipnuZpxBbEHG1cS6w7351EEESSIYfw20pLJgFv5
 UlnlquKVeRYlFGph9AhW0RdORcYwO9c5uPQWCjdvylMpGhFPW9ulHBAuZW8ftxIIB8u1ZA/SXB
 kNO8eKhC7FZOC1D2l4GvRxdIPkRel/5Rlrv7icx5sXlrS1dZz0w/W0wdN5L/F2QwyguO6riUHO
 uyI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 21:06:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HvnpD34Wwz1RtVp
        for <fio@vger.kernel.org>; Wed, 17 Nov 2021 21:06:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637212003; x=1639804004; bh=Gthp04zd2nNYMacqIA4iLGD9fBkNZczCZfR
        EnvqyZuY=; b=e77Jw26OQMC0AapugT+yi8p/yPo7rVvqBU7bBlo8Nvo8t1qfumy
        8JEtnWlwU549jJX9SpD3YFkzuCJ/5iV/wdT8Waadxn2FZXrwDnB1LHgkGiNL8Ypw
        WeTn1vK5wMQBiDw0rb/PGBq48TB0dwCMb5YKEAfe+m5A7Nny+YQX4gs3NNxMhpfg
        BClnRPUglkFEXRik00qRIM/rnytA3vRN3bOglyzv7iS+l2X+RR6I2+P5+0mo7rT0
        bjGMOSdaFGYeeiJ5O9BrtnkNgMwAE/ler76CJBEPpB7wTrYBb+cpbn5TG4loiJ1n
        x4GTt9mQiMFyY2ZdPXUn7GatDXafcsmI5Fw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IVcbxwXGhkIb for <fio@vger.kernel.org>;
        Wed, 17 Nov 2021 21:06:43 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HvnpC1QnNz1RtVl;
        Wed, 17 Nov 2021 21:06:42 -0800 (PST)
Message-ID: <cd39e9bf-00b6-3b02-7e66-9458f5f87327@opensource.wdc.com>
Date:   Thu, 18 Nov 2021 14:06:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH] fio: Introduce the log_entries option
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <20211117065213.124658-1-damien.lemoal@opensource.wdc.com>
 <YZTKuKTinY5LF9uL@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <YZTKuKTinY5LF9uL@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/17 18:26, Niklas Cassel wrote:
> On Wed, Nov 17, 2021 at 03:52:13PM +0900, Damien Le Moal wrote:
>> When iops, latency, or bw logging options are used, fio will by defaul=
t
>> log information for any I/O that completes. The initial number of I/O
>> log entries is 1024, as defined by (DEF_LOG_ENTRIES). When all log
>> entries are used, new log entries are dynamically allocated by
>> get_new_log(). This dynamic log entry allocation can negatively impact
>> time-related statistics such as the I/O tail latencies (e.g. 99.9
>> percentile completion latency) as growing the logs causes a temporary
>> I/O stall (IO quiesce), which disturbs the workload steady state. The
>> effect of this is especially noticeable with workloads using IO
>> priorities: the tail latencies of high priority I/Os increase if the
>> IO log needs to be grown.
>>
>> For example, running the following fio command on a SATA disk
>> supporting NCQ priority:
>>
>> fio --name=3Dprio-randread --filename=3D/dev/sdg \
>>     --random_generator=3Dtausworthe64 --ioscheduler=3Dnone \
>>     --write_lat_log=3Drandread.log --log_prio=3D1 --rw=3Drandread --bs=
=3D128k \
>>     --ioengine=3Dlibaio --iodepth=3D32 --direct=3D1 --cmdprio_class=3D=
1 =C2=A5
>=20
> Nit: s/=C2=A5/\
>=20
> Republic credits?
> Republic credits are no good out here. I need something more real.
> (For the Star Wars fans out there..)

Japanese keyboard: =C2=A5 (Japanese Yen) and \ are the same key/character=
 on many
keyboards.

[...]
>> All completion percentiles clearly now show shorter latencies for high
>> priority commands, as expected. The 99.99th percentile for low priroti=
y
>=20
> Nit: s/prirotiy/priority

Will fix.

>> commands is also improved compared to the previous case as the
>> measurements are not impacted by the log dynamic allocation.
>>
>> Suggested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
> Side note:
> Would it perhaps be wise, in addition to this patch,
> to also increase the DEF_LOG_ENTRIES value slightly?
> The default value is 1024, and sizeof(struct io_sample_offset) =3D=3D 4=
0,
> regrow_logs() seems (at maximum) regrow 6 different logs (slat, clat,
> clat_hist_log, lat_log, bw_log, iops_log).
> The default space used for a single log =3D=3D 40 * 1024 =3D 40 KB,
> if someone has enabled all 6 different logs/log types =3D 40 KB * 6 =3D=
 240 KB
> per thread_data.

Increasing DEF_LOG_ENTRIES can be done independently of this patch. the o=
ption
log_entries defaults to DEF_LOG_ENTRIES and use this value as the min val=
ue too.
So changing DEF_LOG_ENTRIES will also have log_entries follow the change.

> While it would be hard to figure out a new default, e.g. bumping it to =
32768
> would mean 40 * 32768 =3D 1.26 MB, if all 6 logs are enabled =3D 7.5 MB=
 per
> struct thread_data. Sure, someone can have thousands of threads, but I =
doubt
> that you would have logging enabled for all those threads.
> If you have logging enabled, the most common case is probably to have s=
lat,
> clat and lat logs, which means 3 different logs:
> 1.26 MB * 3 =3D 3.76 MB per struct thread_data, however, this dynamic m=
emory
> allocation will only be done if you have explicitly enabled any of the =
log
> files in the first place.
>=20
> TL;DR: I think that we can merge this patch AND increase the default nu=
mber
> of log entries to e.g. 32768. (Or if we want to be quite conservative,
> perhaps only bump it to something like 16384, which would only be less =
than
> 2 MB per struct thread_data if 3 different log files are enabled.)

Not sure. On embedded systems with slow storage (e.g. emmc SD card), incr=
easing
the default log size may not be desired.

DEF_LOG_ENTRIES as is seems to not be an issue for most cases. So I think=
 we
should just leave it as is for now. The new log_entries option now allows=
 larger
logs if one needs/want one.

>=20
>=20
>=20
> For this patch, except for two small nits in the commit message:
>=20
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
>=20


--=20
Damien Le Moal
Western Digital Research
