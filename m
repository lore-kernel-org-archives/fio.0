Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3988C433F5
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 05:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3D161037
	for <fio@archiver.kernel.org>; Wed, 10 Nov 2021 05:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhKJGAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 10 Nov 2021 01:00:08 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10253 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhKJGAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Nov 2021 01:00:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636523840; x=1668059840;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1hTtgCcM3kw4MxBXFVCPh6MniDujjugt1+j+RToMWeU=;
  b=pII3aGWgoFiJTGMnoRZR7qD/1SdWJwwXWeIIHYPmmoAZpjkva9nGjjk0
   hkdbCLt0jIxI5Q/LYcXhW5yfwtz5kyYjH+6YhI8/E54A8RcDut82+uTUy
   N7NZw6rgUwjW8apOk70KzW+vjH3OCAK7Arfh3AAMb9Hvx5XRUf9Z1+kpG
   SKQxLSxcCp6Uq1PcO88z2RcELygWatduzEA/XhKPmgFKzLXtg6VWBpC4o
   mYLomdclHEAWVIYOMAnW8TGJ5KPzaIyQ51n+1Q3OxdECsYLuz0iWtdLM/
   jBoT+VZISaPk0iqOauwe4l+PLo73bnonREleLAXugmCIu5maxbztiRjNt
   g==;
X-IronPort-AV: E=Sophos;i="5.87,222,1631548800"; 
   d="scan'208";a="190005036"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 13:57:20 +0800
IronPort-SDR: uAQsAizkMYx7nFrmfCox58GkfiPE3GFtBY+yeqi5Io3p1JqZS99GSamYyFJhlAcvwUl7oYqHkp
 6dRHW2Tsy08RjtNAr+cU+pViL3QYI/qpmVtaS31BqJclbfZBmT9m3U/KuYDBOcrOzf+Txkde/T
 iPeh/HMMPkcrTqT1B+Dqee8jIfFoeDSDq8mSfQKDtG6pgB6no6sTpTrNYpjbtBys3VbZEpCXeZ
 HRhNkZkWYcJ6Y1xsCb6VY6qlBU+AEOGsBdFnrp3Cu9vDgPGhgJYrOBoZ5LlqTnWjvLoESzwzF5
 3SQZa6LnYIThOW7GUfxxX4fn
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 21:30:59 -0800
IronPort-SDR: F6ukbwjC8F52WZVWKzKq1AiaT3/sVTktvc/3C3B1uKKKzkNnE3Z+Op/AUpTYv+kV1TL2fukzNC
 Sa+0XcGqvFuxjBz/a7W3b+CVQeu/Yozp9nGqzkQQWYCUnbaCAryzRBhcDEzIM6375hI4RSJDBx
 4wZB4YvGJlWInIQTlnP1OELoIJ9B0EcnZzAqobOJBN3MGRXYU8F0x8vvt/PXjRdPzx+IilBPIa
 YthqYjcGIVGONjcdd6YHjMd/VZLVhQzvvIBlo2LdFYeBLcsCcbY/2HotdfaRVznOeXdSjnJnvn
 +6k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 21:57:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpvJJ4SB0z1RtVm
        for <fio@vger.kernel.org>; Tue,  9 Nov 2021 21:57:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636523840; x=1639115841; bh=1hTtgCcM3kw4MxBXFVCPh6MniDujjugt1+j
        +RToMWeU=; b=hQ4CwiKLJHukzbKsgtPMHk1e1XgYYJ1b8UOW9byir5sc1G1CE0W
        Kl1u5VvZKGMHafun1rjz3a5VwuhF9+7fFDeV9rm67tBbZxVM1u3rwH4Ty+lDAdhB
        2gKca60IankA1j5dxGaWQGyIjeSKF+3jvI/6KLSbLdBw0vDOd8/TsbbAKOK8gypV
        sPf2yJODttAbwb/f7Nc/A0Rj0KpnzE/db4BoOJHsphkC4c7yNOTzCrk7KMWdUTIP
        9is528DID6djsCyAKdRLYPQoSKjVVi0HIsvyuiIkEcUtrwoMmVdR6+KRIbzPEF4b
        BeDBONmPq9JmA/VTHGzFv4n8+IqZvsYmnyA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1UHzPaenSBK0 for <fio@vger.kernel.org>;
        Tue,  9 Nov 2021 21:57:20 -0800 (PST)
Received: from [10.89.81.216] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.81.216])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpvJH3sgwz1RtVl;
        Tue,  9 Nov 2021 21:57:19 -0800 (PST)
Message-ID: <1e4cfd69-2e8a-99c7-a654-d784056c47f8@opensource.wdc.com>
Date:   Wed, 10 Nov 2021 14:57:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-8-Niklas.Cassel@wdc.com>
 <e9dc1315-540e-f69f-6814-f8c95a2c077e@opensource.wdc.com>
 <YYp3vESWV74In8Eo@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <YYp3vESWV74In8Eo@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 22:29, Niklas Cassel wrote:
>>> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>>> -		     bool *has_cmdprio)
>>> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
>>>  {
>>>  	struct thread_options *to = &td->o;
>>>  	bool has_cmdprio_percentage = false;
>>> @@ -140,16 +144,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>>>  	 * is not set, default to RT priority class.
>>>  	 */
>>>  	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
>>> -		if (cmdprio->percentage[i]) {
>>> -			if (!cmdprio->class[i])
>>> -				cmdprio->class[i] = IOPRIO_CLASS_RT;
>>
>> Why do you change this ? If cmdprio->percentage[i] is 0, you do not want to set
>> the calss to RT. Or is it that cmdprio->percentage[i] cannot be 0 ? (I did not
>> check the range of the option).
> 
> option cmdprio_percentage has minval 0.

Which could be changed to 1, since having percentage == 0 is (should be)
equivalent to a "do not set a priority".

> option cmdprio_class has minval 1, however it can still be 0 if the user
> omitted the option and only used option cmdprio to specify a priority level.

Hmmm... class 0 is "NONE", so no priority. In the kernel, that will be changed
to the default BE class. So maybe we should do the same here to avoid this weird
case ? (setting a prio level with class NONE does not make any sense).


> 
> I was thinking that cmdprio_value is only used when the percentage != 0,
> which is the case in my cmdprio branch that allows you to have different
> cmdprio class + levels, but you are right, in this specific patch
> fio_cmdprio_ioprio_was_updated()/fio_cmdprio_set_ioprio() still uses
> cmdprio->class to determine if IO_U_F_HIGH_PRIO flag should be set,
> even when fio_cmdprio_percentage() returned zero..
> 
> The question is, if percentage == 0, for e.g. writes,
> but the user specified cmdprio=3
> (which sets cmdprio->level[] for both DDIR read and write),
> should we set the HIGH_PRIO / LOW_PRIO flag?

That is a non question... If percentage == 0, fio_cmdprio_set_ioprio() should
NOT try to change the io_u prio at all. Then the io_u HIGH/LOW flag will depend
on the default priority. That is the same as for the 0 < percentage < 100 case
when an io_u does not get a "hit" on the percentage and fio_cmdprio_set_ioprio()
does not change its priority. With percentage == 0, you will never get a "hit".

> I think the best way is to simply not set any of the flags,
> If cmdprio percentage is 0 for a certain ddir, then everything
> will be sent with the default prio.

For libaio (io_uring is similar), the code in fio_libaio_prio_prep() is:

        if (p && rand_between(&td->prio_state, 0, 99) < p) {
                io_u->ioprio = cmdprio_value;
                io_u->iocb.aio_reqprio = cmdprio_value;
                io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
                if (!td->ioprio || cmdprio_value < td->ioprio) {
                        /*
                         * The async IO priority is higher (has a lower value)
                         * than the default context priority.
                         */
                        io_u->flags |= IO_U_F_HIGH_PRIO;
                }
        } else if (td->ioprio && td->ioprio < cmdprio_value) {
                /*
                 * The IO will be executed with the default context priority,
                 * and this priority is higher (has a lower value) than the
                 * async IO priority.
                 */
                io_u->flags |= IO_U_F_HIGH_PRIO;
        }

So if percentage == 0, p is 0 and the io_u flag is set according to the default
prio. What you are suggesting is already there and should not change.

> 
> So I will keep the unconditional reassignment of cmdprio->class[]
> here, since it shouldn't matter. If the percentage is 0 for a ddir,
> the value should never be used anyway.
> 
> Will add a if (!p) return false;
> 
> after the p = fio_cmdprio_percentage(cmdprio, io_u);
> assignment that this patch does instead.


-- 
Damien Le Moal
Western Digital Research
